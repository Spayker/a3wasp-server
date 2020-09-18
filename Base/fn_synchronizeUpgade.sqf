Private ["_side","_upgrade_id","_upgrade_level"];

_side = _args select 0;
_upgrade_id = _this select 1;
_upgrade_level = _this select 2;

if !(isNil {missionNamespace getVariable Format["WF_upgrade_%1_%2_%3_sync", str _side, _upgrade_id, _upgrade_level]}) then {
    missionNamespace setVariable [Format["WF_upgrade_%1_%2_%3_sync", str _side, _upgrade_id, _upgrade_level], true]
};
