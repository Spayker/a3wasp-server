//------------------fn_SaveGearTemplate-----------------------------------------//
//	Insert gear template to DB					       						    //
//------------------fn_SaveGearTemplate-----------------------------------------//
params ["_scope", "_varName", "_params"];
private ["_query", "_queryRes", "_gear", "_name", "_steamid", "_role", "_side"];

_queryRes = false;

if(extDBOpened) then {
	_gear = _params # 0;
	_name = _params # 1;
	_role = _params # 2;
	_steamid = _params # 3;
	_side = _params # 4;
	
	if(!isNil "_gear" && !isNil "_name" && !isNil "_role" && !isNil "_side") then {		
		_name = [_name] call DB_fnc_mresString;			
		
		if(_steamid != "") then {
			//--Check if template with current name exists--
			_query = format["SELECT id FROM gear_template WHERE player_id = (SELECT id FROM player WHERE steam_id like '%1') AND " +
			" name like '%2' AND terr_type like '%3' AND role like '%4' AND side like '%5'", _steamid, _name, missionNamespace getVariable ["WF_TERR_TYPE", 0], _role, _side];
			_queryRes = [_query,2,true] call DB_fnc_asyncCall;
			
			if(count _queryRes > 0) then {
				_query = format["UPDATE gear_template SET template = '%1' WHERE id = %2", _gear, _queryRes # 0];
			} else {
				_query = format["INSERT INTO gear_template (player_id, name, terr_type, role, template, side) VALUES (" +
					"(SELECT id FROM player WHERE steam_id like '%1' LIMIT 1), '%2', %3, '%4', '%5', '%6')", 
					_steamid, _name, missionNamespace getVariable ["WF_TERR_TYPE", 0], _role, _gear, _side];
			};
			
			[_query,1,true] call DB_fnc_asyncCall;
			_queryRes = true;
		};
	};
};

_scope setVariable [_varName, _queryRes, owner _scope];

_queryRes;