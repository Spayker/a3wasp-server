//------------------fn_passVote---------------------------------------------------------------------------------------//
//	Players calls this function through remoteExec for passing his vote                                               //
//------------------fn_passVote---------------------------------------------------------------------------------------//

params ["_side", "_voter", "_votedFor"];

missionNamespace setVariable [format["WF_VOTER_%1_%2", _side, _voter], _votedFor];