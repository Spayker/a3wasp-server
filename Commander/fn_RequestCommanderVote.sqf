params ["_side", "_name"];
private["_commander","_logik","_commanderUID"];

_logik = _side call WFCO_FNC_GetSideLogic;

if ((_logik getVariable "wf_votetime") <= 0) then {
	_commander = _side call WFCO_FNC_GetCommanderTeam;
	_commanderUID = "";

	if(!isNull _commander) then {
        _commanderUID = getPlayerUID (leader _commander);
	};

    //--Give all votes to current commander--
    {
        missionNamespace setVariable [format["WF_VOTER_%1_%2", _side, _x # 0], _commanderUID];
    } forEach (missionNamespace getVariable [format["WF_PLAYERS_%1", _side], []]);

	_side spawn WFSE_fnc_VoteForCommander;
	[_side,"VotingForNewCommander"] spawn WFSE_fnc_SideMessage;
	
	[_name] remoteExec ["WFCL_FNC_startCommanderVoting", _side];
};