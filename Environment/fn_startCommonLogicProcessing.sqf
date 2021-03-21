private["_total","_side","_hq","_structures","_towns","_factories","_uid","_name","_sunriseSunsetTime",
"_lastSunState","_currentSunState"];

_loopTimer = 60;
_sunriseSunsetTime = date call BIS_fnc_sunriseSunsetTime;

//--TRUE - day, FALSE - night--
_currentSunState = daytime > (_sunriseSunsetTime # 0) && daytime < (_sunriseSunsetTime # 1);
_lastSunState = !_currentSunState;

while {!WF_GameOver} do {

    _total = count towns;

    //--Day/Night time multiplier managment--
    _currentSunState = daytime > (_sunriseSunsetTime # 0) && daytime < (_sunriseSunsetTime # 1);
    if(_currentSunState != _lastSunState) then { //--Sun state changed, do apply time multiplier--
        if(_currentSunState) then {
            setTimeMultiplier WF_C_ENVIRONMENT_DAY_FAST_TIME;
        } else {
            setTimeMultiplier WF_C_ENVIRONMENT_NIGHT_FAST_TIME;
        };

        _lastSunState = _currentSunState;
    };

    //--Store info about sides score--
    if(missionNamespace getVariable ["WF_GAME_ID", 0] > 0) then {
        [scoreSide east, scoreSide west, scoreSide resistance] spawn WFSE_FNC_UpdateSidesStats;
    };

	//--Calculate Start/End game condition--
	{
		_side = _x;
		_hqs = (_side) call WFCO_FNC_GetSideHQ;
		_structures = (_side) call WFCO_FNC_GetSideStructures;
		_towns = (_x) call WFCO_FNC_GetTownsHeld;
		_aliveHq = false;
		{
		    if (alive _x) exitWith { _aliveHq = true }
		} forEach _hqs;

		_factories = 0;
		{
			_factories = _factories + count([_side,missionNamespace getVariable format ["WF_%1%2TYPE",_side,_x], _structures] call WFCO_FNC_GetFactories);
		} forEach ["BARRACKS","LIGHT","HEAVY","AIRCRAFT"];

		if(_side == resistance) then {
		    if (!WF_GameOver && ((!(_aliveHq) && _factories == 0))) then {
                _locationLogics = WF_Logic getVariable ["wf_spawnpos", []];
                _total = count _locationLogics;

                if(_total > 0) then {
                    _startG = nil;
                    while {isNil '_startG'} do {
                        _rPosG = _locationLogics # floor(random _total);
                        _detected = (_rPosG nearEntities ["AllVehicles", 1000]) unitsBelowHeight 20;
                        _enemies = [_detected, _side] call WFCO_FNC_GetAreaEnemiesCount;

                        if (_enemies == 0) then {
                            _startG = _rPosG;

                            _hqName = missionNamespace getVariable Format["WF_%1MHQNAME", _side];
                            _sideID = (_side) Call WFCO_FNC_GetSideID;
                            _startGPos = getPosATL _startG;
                            _hq = [_hqName, [_startGPos # 0, _startGPos # 1, 5], _sideID, 0, true, false, true] Call WFCO_FNC_CreateVehicle;
                            _hq setVectorUp surfaceNormal position _hq;
                            _hq setDir 90;
                            if(damage _hq > 0) then { _hq setDamage 0 };
                        };
                        sleep 0.5
                    }
                }
		    }
		} else {
		if (!WF_GameOver && ((!(_aliveHq) && _factories == 0) || _towns == _total)) then {
			WF_Logic setVariable ["WF_Winner", _side];
			WF_GameOver = true;
			_winner = _side;
			if(_towns != _total) then {
				switch (_side) do {
					case west: { _winner = east; };
					default { _winner = west; };
				};
			};

			[_winner] remoteExec ["WFCL_FNC_showEndGameResults", 0, true];

			[_winner call WFCO_FNC_GetSideID] spawn WFSE_FNC_FinishGameInfo;

			[format[":regional_indicator_g: :regional_indicator_a: :regional_indicator_m: :regional_indicator_e:   :regional_indicator_o: :regional_indicator_v: :regional_indicator_e: :regional_indicator_r:   **%1** %2   :regional_indicator_w: :regional_indicator_o: :regional_indicator_n:", _winner, _winner call WFCO_FNC_GetSideFLAG]] call WFDC_FNC_LogContent;

			//--Collect data about all players and update playing time stats (before server will be restarted)--
			{
                if(!isNull _x) then {
                    _uid = getPlayerUID _x;
                    _name = name _x;
                    if((missionNamespace getVariable[format["wf_ps_%1", _uid], WF_C_UNKNOWN_ID]) != WF_C_UNKNOWN_ID) then {
                        [_uid, _name, missionNamespace getVariable[format["wf_ps_%1", _uid], WF_C_UNKNOWN_ID],
                        time - (missionNamespace getVariable [format["wf_pt_%1", _uid], time]),
                        time - (missionNamespace getVariable [format["wf_ct_%1", _uid], time])] spawn WFSE_FNC_UpdatePlayingTime;
                        missionNamespace setVariable [format["wf_pt_%1", _uid], nil];
                        missionNamespace setVariable [format["wf_ct_%1", _uid], nil];
                        missionNamespace setVariable [format["wf_ps_%1", _uid], nil];
                    };
                };
			} forEach (allPlayers - entities "HeadlessClient_F");

			[format["GAME IS OVER ID = %1",  missionNamespace getVariable["WF_GAME_ID", 0]], 1] call WFDC_FNC_LogContent;
            }
		}
	} forEach WF_PRESENTSIDES - [WF_DEFENDER];

	missionNamespace setVariable["WF_SERVER_FPS", diag_fps, true];

	sleep _loopTimer;
};

sleep 5;
diag_log format["[WF (OUTRO)][frameno:%1 | ticktime:%2] fn_startCommonLogicProcessing.sqf: Mission end - [Done]",diag_frameno,diag_tickTime];
failMission "END1";