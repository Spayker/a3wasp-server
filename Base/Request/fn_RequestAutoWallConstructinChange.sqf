params ["_isAutoWallConstructingEnabled", "_player"];

missionNamespace setVariable [format["WF_AutoWallConstructingEnabled_%1", getPlayerUID _player], _isAutoWallConstructingEnabled];
[_isAutoWallConstructingEnabled] remoteExecCall ["WFCL_FNC_changeAutoWallConstructingFlag", _player];
