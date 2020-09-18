//------------------fn_MarkTownInactive---------------------------------------------------//
//	Set active var to false for a towns													  //
//------------------fn_MarkTownInactive---------------------------------------------------//
params ["_town"];

_town setVariable ["wf_active", false];
_town setVariable ["wf_active_air", false];
_town setVariable ["captureTime", nil];