params ["_side", "_structure", "_isHq"];
private ['_hc'];

_hc = missionNamespace getVariable ["WF_HEADLESSCLIENT_ID", 0];
if(_hc > 0) then {
    [_side, _structure, _isHq] remoteExecCall ["WFHC_FNC_performStructureSell", _hc]
    }
