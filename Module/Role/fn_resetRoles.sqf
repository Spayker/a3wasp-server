private ["_playerRoles","_skillDetails","_index","_newSkillArray","_c"];
params [["_player", ObjNull,[ObjNull]], ["_role", "",[""]]];

if (isNull _player) exitWith {};
if(_role == "") exitwith {};

_roleDetails = [_role, side _player] call WFCO_fnc_getRoleDetails;
_currentRoleAmount = (_roleDetails # 7);
if(_currentRoleAmount > 0)then{
    _roleDetails set [7, _currentRoleAmount - 1];
};

_uid = getPlayerUID(_player);
_team = grpNull;
{
	{
		if !(isNil {_x getVariable "wf_uid"}) then {if ((_x getVariable "wf_uid") == _uid) then {_team = _x}};
		if !(isNull _team) exitWith {};
	} forEach ((_x Call WFCO_FNC_GetSideLogic) getVariable "wf_teams");
	if !(isNull _team) exitWith {};
} forEach WF_PRESENTSIDES;
_team setVariable ["wf_role", "", true];

_uid = getPlayerUID(_player);
_get = missionNamespace getVariable format["WF_JIP_USER%1",_uid];
_get set [5, ""];
missionNamespace setVariable [format["WF_JIP_USER%1",_uid], _get];

[] remoteExecCall ["WFCL_fnc_resetRolesConfirm",(owner _player)];