params ["_side","_dropPosition","_target","_playerTeam"];

["INFORMATION", Format ["fn_processChemicalMissileEvent.sqf: [%1] Team [%2] [%3] has called chemical missile.", str _side, _playerTeam, name (leader _playerTeam)]] Call WFCO_FNC_LogContent;

if (isNull _target || !alive _target) exitWith {};
_dropPosX = _dropPosition # 0;
_dropPosY = _dropPosition # 1;
_dropPosZ = _dropPosition # 2;
_droppos1 = [_dropPosX + 4, _dropPosY + 4, _dropPosZ];
_droppos2 = [_dropPosX + 8, _dropPosY + 8, _dropPosZ];
waitUntil {!alive _target || isNull _target};
[_dropPosition] remoteExecCall ["WFCL_FNC_processChemicalDamage"]