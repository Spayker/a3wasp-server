//------------------fn_MarkTownInactive---------------------------------------------------//
//	Set active var to false for a towns													  //
//------------------fn_MarkTownInactive---------------------------------------------------//
params ["_town"];

_town setVariable ["wf_active", false, true];
_town setVariable ["wf_active_air", false, true];
_town setVariable ["captureTime", nil, true];