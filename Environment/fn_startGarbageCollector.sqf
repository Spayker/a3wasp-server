private["_whq","_ehq", "_WF_C_UNITS_CLEAN_TIMEOUT"];

_WF_C_UNITS_CLEAN_TIMEOUT = missionNamespace getVariable ["WF_C_UNITS_CLEAN_TIMEOUT", 120];
_miscObjectTypes = ["WeaponHolder", "GroundWeaponHolder", "WeaponHolderSimulated", "CraterLong_small", "CraterLong"];

while {!WF_GameOver} do {
	_whq = (west) Call WFCO_FNC_GetSideHQ;
	_ehq = (east) Call WFCO_FNC_GetSideHQ;

    _alldead = allDead;
    if!(isNil '_whq') then {
        _alldead = _alldead - _whq;
    };

    if!(isNil '_ehq') then {
        _alldead = _alldead - _ehq;
    };

	_alldead = _alldead - [objNull];

	{
		_wf_trashed_time = _x getVariable ["wf_trashed_time", 0];
		if((time - _wf_trashed_time - 5) > _WF_C_UNITS_CLEAN_TIMEOUT) then {
            _x setVariable ["wf_trashed_time", time];
            _x spawn WFCO_FNC_TrashObject;
            ["INFORMATION", Format["fn_startGarbageCollector.sqf: Exec WFCO_FNC_TrashObject for [%1].", _x]] Call WFCO_FNC_LogContent;
		};
	} forEach _alldead;

	//--Trash all UAVs without fuel or dead--
	{
		if(!alive _x || (fuel _x) < 0.01) then {
			deleteVehicle _x; 
		};
	} forEach allUnitsUAV;
	
    _delete = false;
    {
        _missionObject = _x;
        {
            if (_missionObject isKindOf _x) then {
                if (count(_missionObject nearEntities ["Man", 15]) < 1) then {deleteVehicle _missionObject; _delete = true};
            };
        } forEach _miscObjectTypes;

        if (_delete) exitWith {};
    } forEach allMissionObjects "";

	
	sleep 30;
};