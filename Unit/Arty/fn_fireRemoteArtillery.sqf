params ["_units", "_destination", "_side", "_artyRange"];
private ["_hc"];

_hc = missionNamespace getVariable ["WF_HEADLESSCLIENT_ID", 0];
if(_hc > 0) then {
    [_units, _destination, _side, _artyRange] remoteExec ["WFHC_FNC_fireRemoteArtillery",_hc];
} else {
    {
        [_x, _destination, _side, _artyRange] Spawn WFCO_FNC_FireArtillery
    } forEach _units
}