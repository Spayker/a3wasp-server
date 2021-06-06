params ["_side","_target","_cruise","_playerTeam"];
private ["_bomb","_droppos1","_droppos2","_dropPosX","_dropPosY","_dropPosZ"];


["INFORMATION", Format ["fn_processIcbmEvent.sqf: [%1] Team [%2] [%3] called in an Tactical Nuke.", str _side, _playerTeam, name (leader _playerTeam)]] Call WFCO_FNC_LogContent;

["Some team called in an **Tactical Nuke** :radioactive:"] Call WFDC_FNC_LogContent;

if (isNull _target || !alive _target) exitWith {};

_height = (getPosAtl _cruise) # 2;
while {alive _cruise} do {
    if(alive _cruise)then{
        _height = (getPos _cruise) # 2
    }
};

[_target, _cruise] remoteExec ["WFCL_FNC_initIcbmStrike", west];
[_target, _cruise] remoteExec ["WFCL_FNC_initIcbmStrike", east];
[_target, _cruise] remoteExec ["WFCL_FNC_initIcbmStrike", resistance];

if (_height < 25) then {
    [_target, 1000] call WFSE_FNC_processMissileDamage
}