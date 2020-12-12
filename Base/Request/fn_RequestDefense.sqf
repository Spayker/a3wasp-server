params ["_side", "_defenseType", "_pos", "_dir", "_manned","_playerUID", "_playerID"];
private ["_hc"];

_hc = missionNamespace getVariable ["WF_HEADLESSCLIENT_ID", 0];
if(_hc > 0) then {
    [_defenseType, _side, _pos, _dir, _manned, _playerUID, _playerID] remoteExecCall ["WFHC_FNC_StationaryDefense", _hc]
}