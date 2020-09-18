//------------------fn_UpdatePlayingTime------------------------------------------------------------------------------//
//	Update data about how much seconds player has been                                                                //
//  in the game and how much he been a commander                                                                      //
//------------------fn_UpdatePlayingTime------------------------------------------------------------------------------//
params [["_uid", 0], ["_name", ""], ["_side", 4], ["_totaltime", 0], ["_commandertime", 0]];
private ["_query", "_queryRes", "_gameId"];

if(extDBOpened) then {
    _gameId = missionNamespace getVariable["WF_GAME_ID", 0];
    _query = format["CALL UpdatePlayingTime(%1, '%2', '%3', %4, %5, %6)",
        _gameId, _uid, _name, _side, _totaltime, _commandertime];
	[_query,1] call DB_fnc_asyncCall;
};