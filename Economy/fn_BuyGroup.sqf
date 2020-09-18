params ["_player", "_selectedGroupTemplate", "_position", "_direction"];

_hc = missionNamespace getVariable ["WF_HEADLESSCLIENT_ID", 0];
if(_hc > 0) then {
    [_player, _selectedGroupTemplate, _position, _direction] remoteExec ["WFHC_FNC_DelegateHighCommandGroup", _hc]
            } else {
    [_player, _selectedGroupTemplate, _position, _direction] call WFCO_fnc_CreateHighCommandGroup
}





