private ['_boundaries','_camps','_eStart','_half','_initied','_limit','_minus','_near','_nearTownsE','_nearTownsW',
'_require','_resTowns','_total','_town','_towns','_wStart','_z'];

waitUntil {townInit};

//--- Special Towns mode.
switch (missionNamespace getVariable "WF_C_TOWNS_STARTING_MODE") do {
	//--- 50-50.
	case 1: {
		_half = round(count towns)/2;
		_wStart = (west Call WFCO_FNC_GetSideLogic) getVariable "WF_startpos";
		_eStart = (east Call WFCO_FNC_GetSideLogic) getVariable "WF_startpos";
		_gStart = (resistance Call WFCO_FNC_GetSideLogic) getVariable "WF_startpos";

		_nearTownsW = [];
		_nearTownsE = [];

		_near = [_wStart,towns] Call WFCO_FNC_SortByDistance;
		if (count _near > 0) then {
			for [{_z = 0},{_z < _half},{_z = _z + 1}] do {_nearTownsW pushBack (_near # _z)}
		};

		_nearTownsE = (towns - _nearTownsW);

		{
            _x setVariable ['sideID',WF_C_WEST_ID,true];
            _locationSpecialities = _x getVariable ["townSpeciality", []];

		    _camps = _x getVariable ["camps", []];
		    if(count _camps > 0) then {
                {_x setVariable ['sideID',WF_C_WEST_ID,true]} forEach _camps
			}
		} forEach _nearTownsW;
		{
            _x setVariable ['sideID',WF_C_EAST_ID,true];
            _locationSpecialities = _x getVariable ["townSpeciality", []];
		    _camps = _x getVariable "camps";
		    if(count _camps > 0) then {
                {_x setVariable ['sideID',WF_C_EAST_ID,true]} forEach _camps
            }
		} forEach _nearTownsE
	};

	//--- Nearby Towns.
	case 2: {
		_total = count towns;
		_wStart = (west Call WFCO_FNC_GetSideLogic) getVariable "WF_startpos";
		_eStart = (east Call WFCO_FNC_GetSideLogic) getVariable "WF_startpos";
		_gStart = (resistance Call WFCO_FNC_GetSideLogic) getVariable "WF_startpos";

		_limit = (missionNamespace getVariable "WF_C_TOWNS_STARTING_MODE") + 8;
		_nearTownsW = [];
		_nearTownsE = [];
		_nearTownsG = [];

		_near = [_wStart,towns] Call WFCO_FNC_SortByDistance;
		if (count _near > 0) then {
			for [{_z = 0},{_z < _limit},{_z = _z + 1}] do {
			    _town = _near # _z;
			    _locationSpecialities = _town getVariable ["townSpeciality", []];
			    if !(WF_C_MINE in _locationSpecialities) then {
			        _nearTownsW pushBack (_town)
			    }
			}
		};

		_near = [_eStart,(towns - _nearTownsW)] Call WFCO_FNC_SortByDistance;
		if (count _near > 0) then {
			for [{_z = 0},{_z < _limit},{_z = _z + 1}] do {
			    _town = _near # _z;
                _locationSpecialities = _town getVariable ["townSpeciality", []];
                if !(WF_C_MINE in _locationSpecialities) then {
                    _nearTownsE pushBack (_town)
                }
			}
		};

		{
		     _x setVariable ['sideID',WF_C_WEST_ID,true];
             _locationSpecialities = _x getVariable ["townSpeciality", []];
		    _camps = _x getVariable "camps";
		     if !(isNil "_camps") then {
		     if(count _camps > 0) then {
                    {_x setVariable ['sideID',WF_C_WEST_ID,true]} forEach _camps
                 }
		     }
		} forEach _nearTownsW;

		{
            _x setVariable ['sideID',WF_C_EAST_ID,true];
            _locationSpecialities = _x getVariable ["townSpeciality", []];
		    _camps = _x getVariable "camps";
		    if !(isNil "_camps") then {
            if(count _camps > 0) then {
                    {_x setVariable ['sideID',WF_C_EAST_ID,true]} forEach _camps
                }
		    }
		} forEach _nearTownsE;

	};
	
	//--- Random Towns (25% East, 25% West, 50% Res).
	case 3: {
		_total = count towns;
		_half = round(count towns)/4;
		_minus = round(count towns)/2;
		_boundaries = missionNamespace getVariable 'WF_BOUNDARIESXY';
		_nearTownsW = [];
		_resTowns = [];
		_towns = +towns;
		
		//--- Use boundaries to determinate the center if possible.
		if !(isNil '_boundaries') then {
			Private ["_dis1","_dis2","_e","_posF1","_posF2","_posx","_posy","_searchArea","_size"];
			//--- Attempt to set the center of the island resistance.
			_searchArea = [(_boundaries / 2)-0.1,(_boundaries / 2)+0.1,0];
			_posx = _searchArea # 0;
			_posy = _searchArea # 0;
			_size = _boundaries/5;
			_e = sqrt((_size)^2 - (_size)^2);
			_posF1 = [_posx + (sin (90) * _e),_posy + (cos (90) * _e)];
			_posF2 = [_posx - (sin (90) * _e),_posy - (cos (90) * _e)];
			_total = 2 * _size;
			
			//--- Determinate resistance towns.
			{
				_position = getPos _x;
				
				_dis1 = _position distance _posF1;
				_dis2 = _position distance _posF2;
				if (_dis1+_dis2 < _total) then {
					_resTowns pushBack _x;
				};
				
				if (count _resTowns >= _minus) exitWith {};
			} forEach towns;
			
			//--- Update Towns.
			_towns = _towns - _resTowns;
			_e = count _towns;
			
			//--- Check if we couldn't reach 50% Res.
			if (count _resTowns < _minus) then {
				for '_z' from 0 to _e-1 do {
					_town = _towns # round(random((count _towns)-1));
					
					_index = _towns find _town;
					if(_index > -1)then{_towns deleteAt _index};
					
					_resTowns pushBack _town;
					
					if (count _resTowns >= _minus) exitWith {};
				};
			};
			
			//--- Update Towns Again.
			_towns = _towns - _resTowns;
			_e = count _towns;
			
			//--- Assign west or east towns.
			for '_z' from 0 to totalTowns-_minus-1 do {
				_town = _towns # round(random((count _towns)-1));
				_index = _towns find _town;
				if(_index > -1)then{_towns deleteAt _index};
				if (count _nearTownsW < _half) then {
                    _town setVariable ['sideID',WF_C_WEST_ID,true];
                    _locationSpecialities = _town getVariable ["townSpeciality", []];
                    _nearTownsW pushBack _town;
					_camps = _x getVariable "camps";
                    if(count _camps > 0) then {
					    {_x setVariable ['sideID',WF_C_WEST_ID,true]} forEach _camps
					}
				} else {
                    _town setVariable ['sideID',WF_C_EAST_ID,true];
                    _locationSpecialities = _town getVariable ["townSpeciality", []];
				    _camps = _x getVariable "camps";
                	if(count _camps > 0) then {
					    {_x setVariable ['sideID',WF_C_EAST_ID,true]} forEach _camps
					}
				}
			}
		} else {
			//--- No boundaries defined, we use a random system.
			for '_z' from 0 to _minus-1 do {
				_town = _towns # round(random((count _towns)-1));
				_index = _towns find _town;
				if(_index > -1)then{_towns deleteAt _index};
				if (count _nearTownsW < _half) then {
                    _town setVariable ['sideID',WF_C_WEST_ID,true];
                    _locationSpecialities = _town getVariable ["townSpeciality", []];
				    _camps = _x getVariable "camps";
                    if(count _camps > 0) then {
					    _nearTownsW pushBack _town;
					    {_x setVariable ['sideID',WF_C_WEST_ID,true]} forEach _camps
					}
				} else {
                    _town setVariable ['sideID',WF_C_EAST_ID,true];
                    _locationSpecialities = _town getVariable ["townSpeciality", []];
				    _camps = _x getVariable "camps";
                    if(count _camps > 0) then {
					    {_x setVariable ['sideID',WF_C_EAST_ID,true]} forEach _camps
					}
				}
			}
		}
	}
};

townInitServer = true;

["INITIALIZATION", "Init_Server.sqf: Town starting mode is done."] Call WFCO_FNC_LogContent;