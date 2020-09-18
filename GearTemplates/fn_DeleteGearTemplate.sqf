//------------------fn_DeleteGearTemplate-----------------------------------------//
//	Delete gear temaplate from the DB			       						      //
//------------------fn_DeleteGearTemplate-----------------------------------------//
params ["_scope", "_varName", "_params"];
private ["_query", "_queryRes", "_templateDbId"];

_queryRes = [];

if(extDBOpened) then {
	_templateDbId = _params # 0;
	
	_query = format["DELETE FROM gear_template WHERE id = %1", _templateDbId];
	_queryRes = [_query,1,true] call DB_fnc_asyncCall;
};

_scope setVariable [_varName, _queryRes, owner _scope];

[]