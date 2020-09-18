params ["_side","_base","_target","_playerTeam"];
private ["_bomb","_droppos1","_droppos2","_dropPosX","_dropPosY","_dropPosZ"];

["INFORMATION", Format ["fn_processIcbmEvent.sqf: [%1] Team [%2] [%3] called in an ICBM Nuke.", str _side, _playerTeam, name (leader _playerTeam)]] Call WFCO_FNC_LogContent;
["Some team called in an **ICBM Nuke** :radioactive:"] Call WFDC_FNC_LogContent;
if (isNull _target || !alive _target) exitWith {};
_dropPosX = getPosAtl _base select 0;
_dropPosY = getPosAtl _base select 1;
_dropPosZ = getPosAtl _base select 2;
_droppos1 = [_dropPosX + 4, _dropPosY + 4, _dropPosZ];
_droppos2 = [_dropPosX + 8, _dropPosY + 8, _dropPosZ];
waitUntil {!alive _target || isNull _target};
[_base] call WFSE_FNC_processNukeDamage