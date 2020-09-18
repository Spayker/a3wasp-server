//------------------fn_InitGameInfo-----------------------------------------------------------------------------------//
//	Create record about new match                                                                                     //
//------------------fn_InitGameInfo-----------------------------------------------------------------------------------//
params [["_terrain", "VR"], ["_mission", ""]];
private ["_query", "_queryRes"];

if(extDBOpened) then {
	_query = format["SELECT InitGameInfo(%1, '%2', '%3') as ID", WF_C_UNKNOWN_ID, _terrain, _mission];
	_queryRes = [_query,2,true] call DB_fnc_asyncCall;
	if(count _queryRes > 0) then {
        missionNamespace setVariable["WF_GAME_ID", (_queryRes # 0) # 0];
	};
};