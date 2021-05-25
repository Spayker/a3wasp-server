//------------------------fn_UpdatgeRadarMarker-----------------------------------------------------------------------//
//	Update Radar circle marker          										                                      //
//------------------------fn_UpdatgeRadarMarker-----------------------------------------------------------------------//
params ["_player", "_tower"];
private ["_sideId", "_side"];

_side = side _player;
_sideId = _side Call WFCO_FNC_GetSideID;

_currentTowerSideID = _tower getVariable "sideID";

[_sideId, _tower] remoteExec ["WFCL_FNC_UpdateRadarMarker", _side, true];

if!(isNil '_currentTowerSideID') then {
    [_sideId, _tower] remoteExec ["WFCL_FNC_UpdateRadarMarker", (_currentTowerSideID) call WFCO_FNC_GetSideFromID, true];
}

