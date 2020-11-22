Params["_units", "_destination", "_artyRange"];
Private ["_units", "_destination", "_artyRange"];

//--- Check towns are in range of arty fire
_nearest = [_destination, towns, _artyRange] Call WFCO_FNC_GetClosestEntity;

if(isNull _nearest) exitWith {
    ["INFORMATION", Format ["fn_calculateArtyDamage.sqf: no towns in range - %1, to calculate their damage on position - %2", _artyRange, _destination]] Call WFCO_FNC_LogContent;
};

_isArtyStrikeFinished = {
    Params[["_units", []]];
    Private["_units", "_isRestricted"];
    _result = true;
    {
        if (alive _x) then {
            _isRestricted = _x getVariable ["restricted", false];
            if (_isRestricted) exitWith {
                _result = false
            }
        }
    } forEach _units;
    _result
};
diag_log format ["fn_calculateArtyDamage.sqf: before loop _isArtyStrikeFinished - %1", ([_units] call _isArtyStrikeFinished)];

[_units, _nearest, _isArtyStrikeFinished] spawn {
    Params["_units", "_nearest", "_isArtyStrikeFinished"];
    while {!([_units] call _isArtyStrikeFinished)} do { sleep 240 };

    _halfTownRange = (_nearest getVariable "range")/2;
    _initialTownMaxSupplyValue = _nearest getVariable ["initialMaxSupplyValue", 50];
    _townRuins = count (nearestObjects [_nearest, ["Ruins"], _halfTownRange]);
    _newTownMaxSV = floor (_initialTownMaxSupplyValue - ((_initialTownMaxSupplyValue/100)*_townRuins));
    _initialStartingSupplyValue = _nearest getVariable "initialStartSupplyValue";

    if (_newTownMaxSV < _initialStartingSupplyValue / 10) then {
        towns = towns - [_nearest];
        missionNamespace setVariable ["totalTowns", count towns, true];
        [_nearest getVariable "name", _nearest getVariable "camps"] remoteExecCall ["WFCL_FNC_TownRemoved"];
        ["TownCanceled", _nearest] remoteExecCall ["WFCL_FNC_TaskSystem"];
        sleep 3;
        _camps = _nearest getVariable ["camps", []];
        { deleteVehicle _x } forEach _camps;

        deleteVehicle _nearest
    } else {
        _nearest setVariable ["maxSupplyValue", _newTownMaxSV, true];
        _currentSupplyValue = _nearest getVariable "supplyValue";
        if(_currentSupplyValue >= _newTownMaxSV) then {
            _nearest setVariable ["supplyValue", _newTownMaxSV, true]
        }
    }
};









