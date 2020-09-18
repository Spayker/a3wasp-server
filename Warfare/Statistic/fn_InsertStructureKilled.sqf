//------------------fn_InsertStructureKilled--------------------------------------------------------------------------//
//	Insert data about structure killed                                                                                //
//------------------fn_InsertStructureKilled--------------------------------------------------------------------------//
params [["_structureType", ""], ["_side", 4], ["_killerUID", 0], ["_killerName", ""], ["_time", time]];
private ["_query", "_gameId"];

if(extDBOpened) then {
    _gameId = missionNamespace getVariable["WF_GAME_ID", 0];
    _query = "INSERT INTO structure_kill (game_id, structure_id, player_name_id, missiontime, side_id) VALUES (";
    _query = format["%1%2,(SELECT id FROM structure WHERE type = '%3'),", _query, _gameId, _structureType];
    _query = format["%1(SELECT id FROM player_name WHERE player_id = (SELECT id FROM player WHERE steam_id = '%2') AND name = '%3'),", _query, _killerUID, _killerName];
    _query = format["%1%2,(SELECT id FROM side WHERE code = %3))", _query, _time, _side];

	[_query,1] call DB_fnc_asyncCall;
};