params ["_playerChanged", "_newScore"];
private["_oldScore"];

_oldScore = score _playerChanged;
_playerChanged addScore -_oldScore;
_playerChanged addScore _newScore;

[_playerChanged,_newScore] remoteExecCall ["WFCL_FNC_ChangeScore"];