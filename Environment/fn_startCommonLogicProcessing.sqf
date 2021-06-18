private["_total","_side","_hq","_structures","_towns","_factories","_uid","_name","_sunriseSunsetTime",
"_lastSunState","_currentSunState"];

_loopTimer = 30;
_sunriseSunsetTime = date call BIS_fnc_sunriseSunsetTime;

//--TRUE - day, FALSE - night--
_currentSunState = daytime > (_sunriseSunsetTime # 0) && daytime < (_sunriseSunsetTime # 1);
_lastSunState = !_currentSunState;
_isThreeSideMode = true;
_threePresentedSides = WF_PRESENTSIDES;
_structureTypes = ["BARRACKS","LIGHT","HEAVY","AIRCRAFT"];
_firstOutTeamSide = sideUnknown;

while {!WF_GameOver} do {

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
    if(_isThreeSideMode) then {
        _firstTeamOut = false;

	{
		_side = _x;
		_hqs = (_side) call WFCO_FNC_GetSideHQ;
            _hqs = _hqs - [objNull];
		_structures = (_side) call WFCO_FNC_GetSideStructures;

		_factories = 0;
		{
			_factories = _factories + count([_side,missionNamespace getVariable format ["WF_%1%2TYPE",_side,_x], _structures] call WFCO_FNC_GetFactories);
            } forEach _structureTypes;

            if(count _hqs == 0 && _factories == 0) exitWith {
                _firstTeamOut = true;
                _firstOutTeamSide = _side
            }
        } forEach _threePresentedSides;

        if(_firstTeamOut) then {
            _isThreeSideMode = false;
            _newFriendSide = sideUnknown;

            switch (_firstOutTeamSide) do {
                case west:{
                    _eastScore = scoreSide east;
                    _resScore = scoreSide resistance;

                    if (_eastScore >= _resScore) then {
                        _firstOutTeamSide setFriend [resistance, 1];
                        resistance setFriend [_firstOutTeamSide, 1];
                        _newFriendSide = resistance;
                    } else {
                        _firstOutTeamSide setFriend [east, 1];
                        east setFriend [_firstOutTeamSide, 1];
                        _newFriendSide = east;
                    }
                };
                case east:{
                    _westScore = scoreSide west;
                    _resScore = scoreSide resistance;

                    if (_westScore >= _resScore) then {
                        _firstOutTeamSide setFriend [resistance, 1];
                        resistance setFriend [_firstOutTeamSide, 1];
                        _newFriendSide = resistance;
                    } else {
                        _firstOutTeamSide setFriend [west, 1];
                        west setFriend [_firstOutTeamSide, 1];
                        _newFriendSide = west;
                    }
                        };
                case resistance:{
                    _eastScore = scoreSide east;
                    _westScore = scoreSide west;

                    if (_westScore >= _eastScore) then {
                        _firstOutTeamSide setFriend [east, 1];
                        east setFriend [_firstOutTeamSide, 1];
                        _newFriendSide = east;
                    } else {
                        _firstOutTeamSide setFriend [west, 1];
                        west setFriend [_firstOutTeamSide, 1];
                        _newFriendSide = west;
                    }
                }
            };

            [Format [localize "STR_WF_INFO_Alliance_Formed", _firstOutTeamSide, _newFriendSide]] remoteExecCall ["WFCL_fnc_TitleTextMessage", east, true];
            [Format [localize "STR_WF_INFO_Alliance_Formed", _firstOutTeamSide, _newFriendSide]] remoteExecCall ["WFCL_fnc_TitleTextMessage", west, true];
            [Format [localize "STR_WF_INFO_Alliance_Formed", _firstOutTeamSide, _newFriendSide]] remoteExecCall ["WFCL_fnc_TitleTextMessage", resistance, true];

            _friendlySides = [_firstOutTeamSide, _newFriendSide];
            _firstOutTeamLogic = (_firstOutTeamSide) Call WFCO_FNC_GetSideLogic;
            _firstOutTeamLogic setVariable ["wf_friendlySides", _friendlySides, true];
            _firstOutTeamLogic setVariable ["wf_isFirstOutTeam", true, true];

            _newFriendLogic = (_newFriendSide) Call WFCO_FNC_GetSideLogic;
            _newFriendLogic setVariable ["wf_friendlySides", _friendlySides, true];
            _newFriendLogic setVariable ["wf_isFirstOutTeam", false, true];

            [_newFriendSide] remoteExecCall ["WFCL_fnc_updateFriendlyMarkers", _firstOutTeamSide, true];
            [_firstOutTeamSide, true] remoteExecCall ["WFCL_fnc_updateFriendlyMarkers", _newFriendSide, true];

            //--- update lost team with friendly start gear and unit list
            [_newFriendSide] remoteExecCall ["WFCL_fnc_updateLostTeamWithFriendlyData", _firstOutTeamSide, true];

            //--- create custom channel for allies
            private _channelName = localize "STR_WF_INFO_Alliance_Channel_Name";
            private _channelID = radioChannelCreate [[0.4,0,0.5,1], _channelName, "%UNIT_NAME", []];
            if (_channelID == 0) exitWith {diag_log format ["fn_startCommonLogicProcessing.sqf: Custom channel '%1' creation failed!", _channelName]};
            _alliedFriendlyChannelData = [_channelID, _channelName];
            missionNamespace setVariable ['alliedFriendlyChannelData', _alliedFriendlyChannelData];
            [_channelID, {_this radioChannelAdd [player]}] remoteExec ["call", _firstOutTeamSide, _channelName];
            [_channelID, {_this radioChannelAdd [player]}] remoteExec ["call", _newFriendSide, _channelName];

            [_alliedFriendlyChannelData] remoteExecCall ["WFCL_fnc_setFriendlyChannelData", _firstOutTeamSide];
            [_alliedFriendlyChannelData] remoteExecCall ["WFCL_fnc_setFriendlyChannelData", _newFriendSide];

            //--- misc
            _firstOutTeamLogic setVariable ["wf_commander", objNull, true];

            _hqs = (_newFriendSide) call WFCO_FNC_GetSideHQ;
            _newFriendSideId = _newFriendSide call WFCO_FNC_GetSideID;
            {
                if(_x isKindOf 'Warfare_HQ_base_unfolded') then {
                    [_x, true, _newFriendSideId] remoteExec ["WFCL_fnc_initBaseStructure", _firstOutTeamSide, true]
                }
            } forEach _hqs;

            _structures = (_newFriendSide) call WFCO_FNC_GetSideStructures;
            {
                [_x, false, _newFriendSideId] remoteExec ["WFCL_fnc_initBaseStructure", _firstOutTeamSide, true]
            } forEach _structures;

            _threePresentedSides = _threePresentedSides - [_firstOutTeamSide]
		    }
		} else {
        _total = count towns;
        {
            _side = _x;
            _hqs = (_side) call WFCO_FNC_GetSideHQ;
            _hqs = _hqs - [objNull];
            _structures = (_side) call WFCO_FNC_GetSideStructures;
            _towns = (_x) call WFCO_FNC_GetTownsHeld;
            _aliveHq = false;
            {
                if (alive _x) exitWith { _aliveHq = true }
            } forEach _hqs;

            _factories = 0;
            {
                _factories = _factories + count([_side,missionNamespace getVariable format ["WF_%1%2TYPE",_side,_x], _structures] call WFCO_FNC_GetFactories);
            } forEach _structureTypes;

            if (!WF_GameOver && ((!(_aliveHq) && _factories == 0))) then {
			WF_Logic setVariable ["WF_Winner", _side];
			WF_GameOver = true;
                _winner = sideUnknown;
				switch (_side) do {
                    case west: {
                        if(east in _threePresentedSides) then {
                            _winner = east
                        } else {
                            _winner = resistance
                        }
                    };
                    case east: {
                        if(west in _threePresentedSides) then {
                            _winner = west
                        } else {
                            _winner = resistance
                        }
                    };
                    case resistance: {
                        if(east in _threePresentedSides) then {
                            _winner = east
                        } else {
                            _winner = west
                        }
                    }
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
                            missionNamespace setVariable [format["wf_ps_%1", _uid], nil]
                        }
                    }
			} forEach (allPlayers - entities "HeadlessClient_F");

			[format["GAME IS OVER ID = %1",  missionNamespace getVariable["WF_GAME_ID", 0]], 1] call WFDC_FNC_LogContent;
            }
        } forEach _threePresentedSides
    };

	missionNamespace setVariable["WF_SERVER_FPS", diag_fps, true];
	sleep _loopTimer
};

sleep 5;
diag_log format["[WF (OUTRO)][frameno:%1 | ticktime:%2] fn_startCommonLogicProcessing.sqf: Mission end - [Done]",diag_frameno,diag_tickTime];
failMission "END1";