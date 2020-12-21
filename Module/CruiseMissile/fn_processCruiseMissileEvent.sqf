params ["_side","_base","_target","_playerTeam"];

["INFORMATION", Format ["fn_processCruiseMissileEvent.sqf: [%1] Team [%2] [%3] has called cruise missile.", str _side, _playerTeam, name (leader _playerTeam)]] Call WFCO_FNC_LogContent;
if (isNull _target || !alive _target) exitWith {};
_dropPosX = getPosAtl _base select 0;
_dropPosY = getPosAtl _base select 1;
_dropPosZ = getPosAtl _base select 2;
_droppos1 = [_dropPosX + 4, _dropPosY + 4, _dropPosZ];
_droppos2 = [_dropPosX + 8, _dropPosY + 8, _dropPosZ];
waitUntil {!alive _target || isNull _target};
[_base] call WFSE_FNC_processMissileDamage