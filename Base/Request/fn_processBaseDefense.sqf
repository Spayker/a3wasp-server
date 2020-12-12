params ["_side", "_defenseType", "_pos", "_dir", "_manned","_playerUID", "_playerID", "_defense"];
private ["_index", "_inBaseArea", "_logik", "_areas", "_areaRange", "_playerAreas", "_inPlayerArea", "_playerArea",
"_playerForts", "_defense", "_grp", "_playerAreasIndex"];

[_defense] spawn WFSE_FNC_addEmptyVehicleToQueue;

_index = (missionNamespace getVariable Format["WF_%1DEFENSENAMES",str _side]) find _defenseType;
if (_index != -1) then {
	//--Check if new item in basearea--
	_inBaseArea = false;
	_logik = (_side) call WFCO_FNC_GetSideLogic;
	_areas = _logik getVariable ["wf_basearea", []];
	_areaRange = (missionNamespace getVariable ["WF_C_BASE_AREA_RANGE", 0]) +
	    (missionNamespace getVariable ["WF_C_BASE_HQ_BUILD_RANGE", 0]);

	{
	    if(_pos inArea [_x, _areaRange, _areaRange, 0, false]) exitWith {
	        _inBaseArea = true;
	    };
	} forEach _areas;

	//--Construction is no in base area zone, put new record about player area--
	if(!_inBaseArea) then {
	    _playerAreas = [];
	    _playerAreasIndex = -1;

        _areas = missionNamespace getVariable ["WF_PLAYERS_FORTIFICATIONS_AREA", []];
        //--[[uid, [areas]]]--
        {
            if(_x # 0 == _playerID) exitWith {
                _playerAreas = _x # 1;
                _playerAreasIndex = _forEachIndex;
            };
        } forEach _areas;

        _inPlayerArea = false;
        {
            if(_pos inArea [_x, _areaRange, _areaRange, 0, false]) exitWith {
                _playerArea = _x;
                _inPlayerArea = true;
            };
        } forEach _playerAreas;

        if(_inPlayerArea) then {
            //--Add object ref to existen player forts area--
            _playerForts = _playerArea getVariable ["fortifications", []];
            _playerForts pushBack _defense;
            _playerForts = _playerForts - [objNull];
            _playerArea setVariable ["fortifications", _playerForts];
        } else {
            //--Add new player area--
            _grp = createGroup sideLogic;
            _logik = _grp createUnit ["Logic",_pos,[],0,"NONE"];
            _logik setVariable ["fortifications", [_defense]];
            _playerAreas pushBack _logik;
        };

        _playerAreas = _playerAreas - [objNull];
        if(_playerAreasIndex > -1) then {
            _areas set [_playerAreasIndex, [_playerID, _playerAreas]];
        } else {
            _areas pushBack [_playerID, _playerAreas];
        };

        missionNamespace setVariable ["WF_PLAYERS_FORTIFICATIONS_AREA", _areas];
        //--Refresh areas data on client--
        missionNamespace setVariable ["WF_FORTITIFACTIONS_AREAS", _playerAreas, _playerID];
	};

};