//------------------fn_GetGearTemplates-----------------------------------------//
//	Select player geartemplates for current role       						    //
//------------------fn_GetGearTemplates-----------------------------------------//
params ["_scope", "_varName", "_params"];
private ["_query", "_queryRes", "_uid", "_terr_type", "_side", "_role"];

_queryRes = [];

if(extDBOpened) then {
	_uid = _params # 0; //--steam id of player--
	_side = _params # 1;
	_role = _params # 2;

	_query = format["SELECT name, template, id FROM gear_template WHERE player_id IN (SELECT id FROM player WHERE steam_id like '%1') AND terr_type = %2 AND side like '%3' AND role like '%4'", 
	_uid, missionNamespace getVariable ["WF_TERR_TYPE", 0], _side, _role];
	_queryRes = [_query,2,true] call DB_fnc_asyncCall;
};

if(isNil "_queryRes") then { _queryRes = [] };

_scope setVariable [_varName, _queryRes, owner _scope];

[]