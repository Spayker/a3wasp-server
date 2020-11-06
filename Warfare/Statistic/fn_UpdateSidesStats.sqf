//------------------fn_UpdateSidesStats-------------------------------------------------------------------------------//
//	Update data about sides score                                                                                     //
//  in the game and how much he been a commander                                                                      //
//------------------fn_UpdatePlayingTime------------------------------------------------------------------------------//
params [["_eastScore", 0], ["_westScore", 0], ["_guerScore", 0]];
private ["_query", "_queryRes", "_gameId"];

if(extDBOpened) then {
    _gameId = missionNamespace getVariable["WF_GAME_ID", 0];
    if(_gameId > 0) then {
        _query = format["UPDATE game SET east_score = %2, west_score = %3, guer_score = %4 WHERE id = %1",
            _gameId, _eastScore, _westScore, _guerScore];
        [_query,1] call DB_fnc_asyncCall;
	};
};