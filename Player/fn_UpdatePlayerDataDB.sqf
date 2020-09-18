//------------------fn_UpdatePlayerDataDB-----------------------------------------------------------------------------//
//	Insert data about new player or update nicknames info                                                             //
//------------------fn_UpdatePlayerDataDB-----------------------------------------------------------------------------//
#include "..\script_macros.hpp"
params ["_uid", "_name", "_sideJoined"];
private["_names", "_exists", "_alsoknown", "_alsoknownDC"];

if(extDBOpened) then {
	[format["SELECT InsertPlayer('%1', '%2') as ID", _uid, _name],1] call DB_fnc_asyncCall;

	_names = [format["SELECT name FROM player_name WHERE player_id = (select id from player where steam_id like '%1')", _uid],2,true] call DB_fnc_asyncCall;
	_exists = false;
	_alsoknown = "";
	_alsoknownDC = "";

	{
		private _nm = _x # 0;
		if(EQUAL(_nm,_name)) then {
			_exists = true;
		} else {
			_alsoknown = _alsoknown + " [" + _nm + "]";
			_alsoknownDC = _alsoknownDC + " **" + _nm + "**";
		};
	} forEach _names;

	if(count _alsoknown > 0) then {
		['CommonText', "STR_WF_M_PlayerAlsoKnownAS", _name, _alsoknown] remoteExecCall ["WFCL_FNC_LocalizeMessage", -2];
		[format ["Player **%1** is also known as: %2 :point_up:", _name, _alsoknownDC]] Call WFDC_FNC_LogContent;
	};

	[_uid, _name] spawn WFSE_FNC_ShowPlayerStats;
};