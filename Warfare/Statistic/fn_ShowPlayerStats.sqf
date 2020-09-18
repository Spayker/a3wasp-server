//------------------fn_ShowPlayerStats--------------------------------------------------------------------------------//
//  Localize message with palyer stats                                                                                //
//------------------fn_ShowPlayerStats--------------------------------------------------------------------------------//
params [["_uid", 0], ["_playername", ""]];
private ["_query", "_queryRes", "_message", "_sides", "_txt"];

if(extDBOpened) then {
    _txt = "";

	//--Select games count, totalplaying time, commanding time--
    _query = format ["SELECT count(game_id), IFNULL(ROUND((sum(totaltime) / 60) / 60, 2), 0),
    IFNULL(ROUND((sum(commandertime) / 60) / 60, 2), 0)
    FROM lnk_game_player
    WHERE player_name_id IN (
    						SELECT id
    						FROM player_name WHERE player_id =
    						(SELECT id
    						FROM player
    						WHERE steam_id = '%1'))", _uid];

    _queryRes = [_query, 2,true] call DB_fnc_asyncCall;
    _queryRes = _queryRes # 0;
	_message = [["STR_WF_STAT_GAMES_TIME", _queryRes # 0, _queryRes # 1, _queryRes # 2]]; //--Games count, totalplaying time, commanding time--
	_txt = format["Participated in games: %1. Total played hours: %2. Commanded hours: %3. ", _queryRes # 0, _queryRes # 1, _queryRes # 2];

	_query = format ["SELECT count(1) AS CNT, (SELECT sd.name FROM side sd WHERE sd.id = lnk.side_id) AS SIDE
	FROM lnk_game_player lnk
	WHERE player_name_id IN (
    						SELECT id
    						FROM player_name WHERE player_id =
    						(SELECT id
    						FROM player
    						WHERE steam_id = '%1'))
	GROUP BY side_id", _uid];

	_queryRes = [_query, 2,true] call DB_fnc_asyncCall;

	_sides = "";
    _txt = _txt + "Faction games:";
	{
		_sides = format ["%1 %2: %3", _sides, _x # 1, _x # 0];
		_txt = format["%1 %2: %3", _txt, _X # 1, _x # 0];
	} forEach _queryRes;

	_message pushBack ["STR_WF_STAT_PLAYING_SIDES", _sides];

	_query = format ["SELECT ROUND((commandtime / 5) + ((totaltime - commandtime) / 10) + 
					  ((HQS - HQSTK) * 30) + ((BS - BSTK) * 3) + ((LS - LTK) * 4.5) + ((CCS - CCTK) * 5) + 
					  ((HS - HTK) * 7) + ((ACS - ACTK) * 8) + ((SPS - SPTK) * 3) + ((AARS - AARTK) * 8) + 
					  ((ARS - ARTK) * 3), 2) as SCORE, HQS, BS, LS, HS, ACS, CCS + SPS + AARS + ARS AS OTHER
                      FROM view_player_statistic
                      WHERE steamid = '%1'", _uid];

	_queryRes = [_query, 2,true] call DB_fnc_asyncCall;

	_sides = "";
	_txt = _txt + ". HQ and factories kills:";

	if((count _queryRes) > 0) then {
	    _queryRes = _queryRes # 0;
        _sides =  _sides + format [" [SCORE]: %1, [HQ]: %2, [B]: %3, [LF]: %4, [HF]: %5, [AF]: %6, [OTHER]: %7",
            _queryRes # 0, _queryRes # 1, _queryRes # 2, _queryRes # 3, _queryRes # 4, _queryRes # 5, _queryRes # 6];
        _txt = _txt + format [" [SCORE]: %1, [HQ]: %2, [B]: %3, [LF]: %4, [HF]: %5, [AF]: %6, [OTHER]: %7",
            _queryRes # 0, _queryRes # 1, _queryRes # 2, _queryRes # 3, _queryRes # 4, _queryRes # 5, _queryRes # 6];
	} else {
	    _sides = _sides + " 0";
        _txt = _txt + " 0";
	};

	_message pushBack ["STR_WF_STAT_STRUCTURES_KILLS", _sides];
	['PlayerStats', _playername, _message] remoteExecCall ["WFCL_FNC_LocalizeMessage", -2];
    [format ["Player **%1** statistics ```%2```", _playername, _txt]] Call WFDC_FNC_LogContent;
};