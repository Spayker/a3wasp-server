private ["_skill","_playerRoles","_skillDetails","_newSkillArray","_c","_l"];
params [["_player", ObjNull,[ObjNull]], ["_role", "",[""]]];
_roleDetails = [];
_playerRoles = [];

if (isNull _player || _role == "") exitWith {};

// get the skill details
waitUntil{!isNil 'WFCO_fnc_getRoleDetails'};
_roleDetails = [_role, side _player] call WFCO_fnc_getRoleDetails;

// Skill not found/invalid
if (count _roleDetails == 0) exitWith {};

// check if the user already have that skill
if (_role in _playerRoles) exitWith {
    [_role,"owned",_playerRoles] remoteExecCall ["WFCL_fnc_buyRoleConfirm",(owner _player)];
};

// check if role limit allows to take requested role by player
if ((_roleDetails # 7) >= (_roleDetails # 6)) exitWith {
    [_role,"maxRoleLimit",_playerRoles] remoteExecCall ["WFCL_fnc_buyRoleConfirm",(owner _player)];
};

// check if player has already bought some other role
if ((count _playerRoles) >= 1) exitWith {
    [_role,"limit",_playerRoles] remoteExecCall ["WFCL_fnc_buyRoleConfirm",(owner _player)];
};

_playerRoles pushBack _role;
_currentOcuupiedRoleAmount = (_roleDetails # 7) + 1;
_roleDetails set [7, _currentOcuupiedRoleAmount];

_uid = getPlayerUID(_player);
_team = grpNull;

waitUntil{!isNil 'WF_PRESENTSIDES'};
{
	{
		if !(isNil {_x getVariable "wf_uid"}) then {if ((_x getVariable "wf_uid") == _uid) then {_team = _x}};
		if !(isNull _team) exitWith {};
	} forEach ((_x Call WFCO_FNC_GetSideLogic) getVariable "wf_teams");
	if !(isNull _team) exitWith {};
} forEach WF_PRESENTSIDES;
_team setVariable ["wf_role", _role, true];

_get = missionNamespace getVariable format["WF_JIP_USER%1",_uid];
_get set [5, _role];
missionNamespace setVariable [format["WF_JIP_USER%1",_uid], _get];

[_role,"success",_playerRoles] remoteExecCall ["WFCL_fnc_buyRoleConfirm",(owner _player)];