//--- Nuke destruction.
params ["_target"];
private ["_array","_blackListed","_range","_allstatics","_walls","_z"];

_blackListed = [];
_blackListed pushback (missionNamespace getVariable "WF_C_DEPOT");
_blackListed pushback "Land_BagBunker_Tower_F";
_blackListed pushback "LocationCamp_F";

_range = 1500;
_array = _target nearEntities [["Man","Car","Motorcycle","Tank","Ship","Air","StaticWeapon"], _range];

{if ((typeOf _x) in _blackListed) then {_array deleteAt _forEachIndex}} forEach _array;

{
	_x removeAllEventHandlers "Killed";
	_x removeAllEventHandlers "Hit";
	_x removeAllEventHandlers "HandleDamage";
	{_x setDamage  [1, false]} forEach crew _x;
	_x setDamage [1, false];
} forEach _array;

for [{_z = 0},{_z < 5},{_z = _z + 1}] do {
		_arrayStatic = _target nearObjects ["Static", _range];
		{
		    if((_x getVariable ["wf_site_health", 0]) > 0 && _x getVariable ["wf_site_alive", true]) then {
                _x setVariable ["wf_site_health", 0];
				_x removeAllEventHandlers "Killed";
				_x removeAllEventHandlers "Hit";
				_x removeAllEventHandlers "HandleDamage";
                    [_x] spawn WFSE_FNC_BuildingKilled;
		    } else {
		        _x setDamage [1, false];
		    };
		} forEach _arrayStatic;

		_arrayHouse = _target nearObjects ["House", _range];
		{
		    if((_x getVariable ["wf_site_health", 0]) > 0 && _x getVariable ["wf_site_alive", true]) then {
                _x setVariable ["wf_site_health", 0];
				_x removeAllEventHandlers "Killed";
				_x removeAllEventHandlers "Hit";
				_x removeAllEventHandlers "HandleDamage";
                    [_x] spawn WFSE_FNC_BuildingKilled;
            } else {
                _x setDamage [0.25, false];
            };
		} forEach _arrayHouse;

		_towns = [_target, towns, _range] Call WFCO_FNC_SortByDistance;
		{
		    towns = towns - [_x];
            missionNamespace setVariable ["totalTowns", count towns, true];
            [_x getVariable "name", _x getVariable "camps"] remoteExecCall ["WFCL_FNC_TownRemoved"];
            ["TownCanceled", _x] remoteExecCall ["WFCL_FNC_TaskSystem"];
            sleep 3;
            _camps = _x getVariable ["camps", []];
            _flags = _x getVariable ["flags", []];
            { deleteVehicle _x } forEach _camps + _flags;

            deleteVehicle _x
		} forEach _towns;

		_arrayHouseEP = _target nearObjects ["House_EP1", _range];
		{
		    if((_x getVariable ["wf_site_health", 0]) > 0 && _x getVariable ["wf_site_alive", true]) then {
                _x setVariable ["wf_site_health", 0];
				_x removeAllEventHandlers "Killed";
				_x removeAllEventHandlers "Hit";
				_x removeAllEventHandlers "HandleDamage";
                    [_x] spawn WFSE_FNC_BuildingKilled;
            } else {
                _x setDamage [0.25, false];
            };
		} forEach _arrayHouseEP;

		_allstatics = [];
        {
        	_allstatics append (missionNamespace getVariable [Format["WF_%1DEFENSENAMES", _x], []]);
        } forEach WF_PRESENTSIDES;

        _walls = nearestObjects [_target, _allstatics, _range];
        {
        	if (((missionNamespace getVariable [format["%1", typeOf _x], [0,0,0,0,0,0,""]]) # 6) == "Fortification") then {
        		deleteVehicle _x;
        	};
        } forEach _walls;

	sleep 3;
};
