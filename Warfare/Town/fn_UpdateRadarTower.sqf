//------------------------fn_UpdatgeRadarMarker-----------------------------------------------------------------------//
//	Update Radar circle marker          										                                      //
//------------------------fn_UpdatgeRadarMarker-----------------------------------------------------------------------//
params ["_player", "_tower"];
private ["_sideId", "_side"];

_side = side _player;
_sideId = _side Call WFCO_FNC_GetSideID;

[_sideId, _tower] remoteExec ["WFCL_FNC_UpdateRadarMarker", west, true];
[_sideId, _tower] remoteExec ["WFCL_FNC_UpdateRadarMarker", east, true];
