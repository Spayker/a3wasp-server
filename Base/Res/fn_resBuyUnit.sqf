params ["_building", "_unitType", "_side", "_team"];
Private ["_building","_built","_config","_crew","_dir","_distance","_factoryPosition","_factoryType","_index","_vehiSlots","_longest","_position","_queu","_queu2","_ret","_side","_sideID","_sideText","_soldier","_team","_turrets","_type","_unitType","_vehicle","_waitTime"];

_sideID = (_side) Call WFCO_FNC_GetSideID;
_sideText = str _side;

if !(alive _building) exitWith {["INFORMATION", Format ["fn_resBuyUnit.sqf: Unit [%1] construction has been stopped due to factory destruction.", _unitType]] Call WFCO_FNC_LogContent};

["INFORMATION", Format ["fn_resBuyUnit.sqf: [%1] Team has purchased a [%1] unit.",_team, _unitType]] Call WFCO_FNC_LogContent;

_type = typeOf _building;

_index = (missionNamespace getVariable Format ["WF_%1STRUCTURENAMES", _sideText]) find _type;
_distance = (missionNamespace getVariable Format ["WF_%1STRUCTUREDISTANCES", _sideText]) # _index;
_factoryType = (missionNamespace getVariable Format ["WF_%1STRUCTURES", _sideText]) # _index;

_waitTime = (missionNamespace getVariable _unitType) # QUERYUNITTIME;
_direction = (missionNamespace getVariable Format["WF_%1STRUCTUREDIRECTIONS", str _side]) # _index;
_position = [getPos _building, _distance, getDir _building + _direction] Call WFCO_FNC_GetPositionFrom;
_longest = missionNamespace getVariable Format ["WF_LONGEST%1BUILDTIME",_factoryType];

if !(alive _building) exitWith {["INFORMATION", Format ["fn_resBuyUnit.sqf: Unit [%1] construction has been stopped due to factory destruction.", _unitType]] Call WFCO_FNC_LogContent};

_HC = missionNamespace getVariable ["WF_HEADLESSCLIENT_ID", 0];
_factoryPosition = getPosATL _building;
_dir = -((((_position # 1) - (_factoryPosition # 1)) atan2 ((_position # 0) - (_factoryPosition # 0))) - 90);

if (_unitType isKindOf "Man") then {
	if (_HC > 0) then {
        [_side, _unitType, _position, _team, _dir] remoteExec ["WFHC_FNC_DelegateAI", _hc]
	} else {
	    _soldier = [_unitType,_team,_position,_sideID] Call WFCO_FNC_CreateUnit;
        //--- Infantry can use the team vehicles as cargo.
        _vehicle = [_team,true] Call WFCO_FNC_GetTeamVehicles;
        {_team addVehicle _x} forEach _vehicle
	}
} else {
    if (_HC > 0) then {
        _special = if (_unitType isKindOf "Air") then {"FLY"} else {"NONE"};
        [_side, _unitType, _position, _team, _dir, _special] remoteExec ["WFHC_FNC_DelegateAI", _hc]
    } else {
        _position = [_position, 50] call WFCO_fnc_getEmptyPosition;
        if(_unitType isKindOf 'Air') then {
            _position = [_position # 0, _position # 1, 40]
        } else {
            _position = [_position # 0, _position # 1, 0.5]
        };

        _vehicleArray = [_position, _dir, _unitType, _team] call bis_fnc_spawnvehicle;
        _vehicle = _vehicleArray # 0;
        _vehicle  spawn {_this allowDamage false; sleep 15; _this allowDamage true};
        [str _side,'UnitsCreated',1] Call WFCO_FNC_UpdateStatistics;
        {
            [_x, typeOf _x,_team,_position,_sideID] spawn WFCO_FNC_InitManUnit;

            private _classLoadout = missionNamespace getVariable Format ['WF_%1ENGINEER', _side];

            _x setUnitLoadout _classLoadout;
            _x setUnitTrait ["Engineer",true];
            [str _side,'UnitsCreated',1] Call WFCO_FNC_UpdateStatistics;
        } forEach crew _vehicle;

        _unitskin = -1;
        _type = typeOf _vehicle;
        _vehicleCoreArray = missionNamespace getVariable [_type, []];
        if((count _vehicleCoreArray) > 10) then { _unitskin = _vehicleCoreArray # 10 };
        [_vehicle, _sideID, false, true, true, _unitskin] call WFCO_FNC_InitVehicle;
        _vehicle allowCrewInImmobile true;
        _vehicle engineOn true
    }
}