//------------------fn_FinishGameInfo-----------------------------------------//
//	Update record about end of the match                                      //
//------------------fn_FinishGameInfo-----------------------------------------//
params [["_winnerSide", WF_C_UNKNOWN_ID]];
private ["_query", "_queryRes"];

if(extDBOpened) then {
	_query = format["UPDATE game SET winnerside = (SELECT id FROM side WHERE code = %2), endtime = now() WHERE id = %1",
	    missionNamespace getVariable["WF_GAME_ID", 0], _winnerSide];
	[_query,1] call DB_fnc_asyncCall;
};