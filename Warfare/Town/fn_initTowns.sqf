private ['_boundaries','_camps','_eStart','_half','_initied','_limit','_minus','_near','_nearTownsE','_nearTownsW',
'_require','_resTowns','_total','_town','_towns','_wStart','_z'];

waitUntil {townInit};

//--- Special Towns mode.
_half = round(count towns)/3;
		_wStart = (west Call WFCO_FNC_GetSideLogic) getVariable "WF_startpos";
		_eStart = (east Call WFCO_FNC_GetSideLogic) getVariable "WF_startpos";
		_gStart = (resistance Call WFCO_FNC_GetSideLogic) getVariable "WF_startpos";

		_nearTownsW = [];
		_nearTownsE = [];
		_nearTownsG = [];

		_near = [_wStart,towns] Call WFCO_FNC_SortByDistance;
		if (count _near > 0) then {
    for [{_z = 0},{_z < _half},{_z = _z + 1}] do {
			    _town = _near # _z;
        _sideId = _town getVariable "sideID";
        if(_sideId == WF_C_CIV_ID) then {
            _nearTownsW pushBack (_near # _z)
			    }
			}
		};

_near = [_gStart,towns] Call WFCO_FNC_SortByDistance;
		if (count _near > 0) then {
    for [{_z = 0},{_z < _half},{_z = _z + 1}] do {
			    _town = _near # _z;
        _sideId = _town getVariable "sideID";
        if(_sideId == WF_C_CIV_ID) then {
            _nearTownsG pushBack (_near # _z)
                }
			}
		};

_nearTownsE = (towns - _nearTownsW - _nearTownsG);

_originalWStart = _wStart;
_firstRandomSideId = selectRandom [WF_C_GUER_ID, WF_C_EAST_ID];
		{
    _x setVariable ['sideID',_firstRandomSideId,true];
             _locationSpecialities = _x getVariable ["townSpeciality", []];

    _camps = _x getVariable ["camps", []];
		     if(count _camps > 0) then {
        {_x setVariable ['sideID',_firstRandomSideId,true]} forEach _camps
		     }
		} forEach _nearTownsW;

if(_firstRandomSideId == WF_C_GUER_ID) then {
		{
            _x setVariable ['sideID',WF_C_EAST_ID,true];
            _locationSpecialities = _x getVariable ["townSpeciality", []];
		    _camps = _x getVariable "camps";
            if(count _camps > 0) then {
                    {_x setVariable ['sideID',WF_C_EAST_ID,true]} forEach _camps
                }
    } forEach _nearTownsG;

		{
        _x setVariable ['sideID',WF_C_WEST_ID,true];
            _locationSpecialities = _x getVariable ["townSpeciality", []];
            _camps = _x getVariable "camps";
                if(count _camps > 0) then {
            {_x setVariable ['sideID',WF_C_WEST_ID,true]} forEach _camps
                }
    } forEach _nearTownsE;
} else {
			{
        _x setVariable ['sideID',WF_C_WEST_ID,true];
        _locationSpecialities = _x getVariable ["townSpeciality", []];
					_camps = _x getVariable "camps";
                    if(count _camps > 0) then {
					    {_x setVariable ['sideID',WF_C_WEST_ID,true]} forEach _camps
					}
    } forEach _nearTownsG;

    {
        _x setVariable ['sideID',WF_C_WEST_ID,true];
        _locationSpecialities = _x getVariable ["townSpeciality", []];
				    _camps = _x getVariable "camps";
                	if(count _camps > 0) then {
					    {_x setVariable ['sideID',WF_C_WEST_ID,true]} forEach _camps
					}
    } forEach _nearTownsE;
};

townInitServer = true;

["INITIALIZATION", "Init_Server.sqf: Town starting mode is done."] Call WFCO_FNC_LogContent;