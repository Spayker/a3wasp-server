private["_WF_EmptyVehiclesQueue","_empVehTick","_prolongVehClasses"];

_prolongVehClasses = [];

{
    _prolongVehClasses pushBack (missionNamespace getVariable format["WF_%1REPAIRTRUCKS",str _x]);
} forEach WF_PRESENTSIDES;

_prolongVehClasses = _prolongVehClasses + (missionNamespace getVariable ["WF_AMBULANCES", []]);

while {!WF_GameOver} do {

	_WF_EmptyVehiclesQueue = missionNamespace getVariable ["WF_EmptyVehiclesQueue", []];

	{
	    if(isNull _x) then {
	        _WF_EmptyVehiclesQueue deleteAt _forEachIndex
	    } else {
		if(alive _x) then {
			_empVehTick = _x getVariable ["_empVehTick", time];

			if (({alive _x} count crew _x) > 0) then { _empVehTick = time };

			_subtraction = time - _empVehTick;
			if (typeOf _x in _prolongVehClasses) then { _subtraction = _subtraction - WF_C_UNITS_EMPTY_TIMEOUT };

			if (_subtraction > WF_C_UNITS_EMPTY_TIMEOUT) then {
				["INFORMATION", Format["fn_startEmptyVehiclesCollector.sqf: Deleting empty vehicle [%1], it has been [%2] seconds.",
					_x, floor _subtraction]] Call WFCO_FNC_LogContent;
				_WF_EmptyVehiclesQueue deleteAt _forEachIndex;
				deleteVehicle _x
			} else {
				_x setVariable ["_empVehTick", _empVehTick]
			}
		}
	    }
	} forEach _WF_EmptyVehiclesQueue;

	missionNamespace setVariable ["WF_EmptyVehiclesQueue", _WF_EmptyVehiclesQueue];
	
	sleep 60
}