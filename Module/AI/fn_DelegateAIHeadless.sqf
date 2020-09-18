/*
	Delegate town AI creation to an headless client.
	 Parameters:
		- Side
		- Groups
		- Spawn positions
		- Teams
*/
params ["_hc", "_side", "_unitType", "_position", "_team", "_dir", ["_special", nil]];

//--- Delegate The groups to the miscelleanous headless clients.
if (isNil "_special") then {
    [_side, _unitType, _position, _team, _dir] remoteExecCall ["WFHC_FNC_DelegateAI", _hc];
} else {
    [_side, _unitType, _position, _team, _dir, _special] remoteExecCall ["WFHC_FNC_DelegateAI", _hc];
};