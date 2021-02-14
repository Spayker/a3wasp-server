#include "..\script_macros.hpp"
/*
	Event Handler triggered everytime a player connect to the server, this file handle the first connection along with the JIP connections of a player.
	 Parameters:
		- User ID
		- User Name
*/

params ["_uid","_name","_id"];
private ["_funds","_get","_max","_sideJoined","_sideOrigin","_team","_units"];

//--- Wait for a proper common & server initialization before going any further.
waitUntil {commonInitComplete && serverInitFull};



["INFORMATION", format ["fn_OnPlayerConnected.sqf: Player [%1] [%2] has joined the game", _name, _uid]] Call WFCO_FNC_LogContent;

//--- Skip this script if the server is trying to run this.

if (_name == '__SERVER__' || _uid == '' || local player) exitWith {};

//--- We try to get the player and it's group from the playableUnits.
_team = grpNull;
_sideJoined = nil;

waitUntil {commonInitComplete && serverInitFull};

_sideJoined = switch (getNumber(configFile >> "CfgVehicles" >> typeof (leader _team) >> "side")) do {case 0: {east}; case 1: {west}; case 2: {resistance}; default {civilian}};

while {isNull _team} do {
	{
		if ((getPlayerUID _x) == _uid) exitWith {
			_team = group _x;
			_sideJoined = side (leader _team);
		};
	} forEach playableUnits;
	if (isNull _team) then {sleep 1};
};

if (isNull _team) exitWith {
    ["INFORMATION", format ["fn_OnPlayerConnected.sqf: Player [%1] [%2] can not join to game", _name, _uid]] Call WFCO_FNC_LogContent;
};

[format ["Player **%1** has joined the game with %2**%3** team :sign_of_the_horns:", _name, _sideJoined Call WFCO_FNC_GetSideFLAG, _sideJoined]] Call WFDC_FNC_LogContent;

//--Update player data in DB--
[_uid, _name, _sideJoined] spawn WFSE_FNC_UpdatePlayerDataDB;

//--Update players global list--
[0, _uid, _name, _sideJoined] spawn WFSE_FNC_updatePlayersList;

_logic = _sideJoined Call WFCO_FNC_GetSideLogic;
_teams = _logic getVariable ["wf_teams", []];
_teams pushBackUnique _team;

{
	if !(isNil '_x') then {
			Private ["_group"];
        _group = nil;
        if (typeName _team == "OBJECT") then {
            _group = group _team
        } else {
            _group = group (leader _team)
        };

			
			if((_teams pushBackUnique _group) != -1) then {
				if (isNil {_group getVariable "wf_funds"}) then {_group setVariable ["wf_funds", missionNamespace getVariable Format ["WF_C_ECONOMY_FUNDS_START_%1", _sideJoined], true]};
				_group setVariable ["wf_side", _sideJoined];
				_group setVariable ["wf_persistent", true];
				_group setVariable ["wf_queue", []];
				_group setVariable ["wf_vote", -1, true];
				_group setVariable ["wf_role", "", true];

				["INITIALIZATION", Format["fn_OnPlayerConnected.sqf: [%1] Team [%2] was initialized.", _sideJoined, _group]] Call WFCO_FNC_LogContent;
			};

    }
} forEach (_teams);

_logic setVariable ["wf_teams", _teams, true];
_logic setVariable ["wf_teams_count", count _teams];


[_team, _sideJoined, _uid, true] remoteExec ["WFCO_fnc_UpdateClientTeams"];

//--- We attempt to get the player informations in case that he joined before.
_get = missionNamespace getVariable format["WF_JIP_USER%1",_uid];

//--- If we choose not to keep the current units during this session, then we simply remove them.
["INFORMATION", format ["fn_OnPlayerConnected.sqf: Team [%1] units are now being removed for player [%1] [%2].", _team, _name, _uid]] Call WFCO_FNC_LogContent;
(leader _team) enableSimulationGlobal true;
_units = units _team;
_units = _units + ([_team,false] Call WFCO_FNC_GetTeamVehicles);
{if (!isPlayer _x && !(_x in playableUnits)) then {deleteVehicle _x}} forEach _units;

//--- We 'Sanitize' the player, we remove the waypoints and we heal him.
_team Call WFCO_FNC_WaypointsRemove;
_team deleteGroupWhenEmpty false;
(leader _team) setDammage 0;

//--- We store the player UID over the group, this allows us to easily fetch the disconnecting client original group.
_team setVariable ["wf_uid", _uid];
_team setVariable ["wf_teamleader", leader _team];

//--Set the time of connection and player side--
missionNamespace setVariable [format["wf_pt_%1", _uid], time];
missionNamespace setVariable[format["wf_ps_%1", _uid], _sideJoined call WFCO_FNC_GetSideID];

//--- The player has joined for the first time.
if (isNil '_get') exitWith {
	/*
		UID | Cash | Side | Current Side | flag of first connect on a session
		The JIP system store the main informations about a client, the UID is used to track the player all along the session.
	*/
	missionNamespace setVariable [format["WF_JIP_USER%1",_uid], [_uid, 0, _sideJoined, _sideJoined, 0, ""]];

	_team setVariable ["wf_funds", missionNamespace getVariable format ["WF_C_ECONOMY_FUNDS_START_%1", _sideJoined], true];
	["INFORMATION", Format ["fn_OnPlayerConnected.sqf: Team [%1] Leader [%2] JIP Information have been stored for the first time.", _team, _uid]] Call WFCO_FNC_LogContent;
};

//--- The player has already joined the session previously, we just need to update the informations.
_get set [3, _sideJoined];

_sideOrigin = _get # 2;
_get set [4,1];
//--- Update the new informations.
missionNamespace setVariable [format["WF_JIP_USER%1",_uid], _get];

//--- Get saved funds.
_funds = _get # 1;
if (_sideOrigin != _sideJoined) then {
	_funds = missionNamespace getVariable Format ["WF_C_ECONOMY_FUNDS_START_%1", _sideJoined];
} else {
	if(isNil '_funds') then {
		_funds = missionNamespace getVariable Format ["WF_C_ECONOMY_FUNDS_START_%1", side (leader _team)];
	} else {
if(_funds <= 0) then {
		_funds = missionNamespace getVariable Format ["WF_C_ECONOMY_FUNDS_START_%1", side (leader _team)];
	};
	}
};

//--Set the current player funds--
_team setVariable ["wf_funds", _funds, true];(leader _team) setVariable ["wf_funds", _funds, true];