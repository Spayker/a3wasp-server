params ["_side", "_assigned_commander"];
private["_commanderTeam","_logic","_name","_team","_oldCommander"];

_logic = (_side) Call WFCO_FNC_GetSideLogic;

if ((_logic getVariable "wf_votetime") <= 0) then {
	_team = -1;

    //--Store commanding time for old commander--
    _oldCommander = _logic getVariable ["wf_commander", objNull];
    if(!isNull _oldCommander) then {
        _oldCommander = leader _oldCommander;
        missionNamespace setVariable [format["wf_ct_%1", getPlayerUID _oldCommander], nil];
    };

	//--- Set the commander
	_logic setVariable ["wf_commander", _assigned_commander, true];
	[_assigned_commander] remoteExecCall ["WFCL_FNC_assignedCommander", _side];

	if(!(isNil 'WF_L_HCCCC'))then {
        (leader _assigned_commander) synchronizeObjectsAdd [WF_L_HCCCC];
        (leader _assigned_commander) setVariable ["BIS_HC_scope",WF_L_HCCCC];
        _oldCommander synchronizeObjectsRemove [WF_L_HCCCC];
    };

	//--Set new commander start time--
    missionNamespace setVariable [format["wf_ct_%1", getPlayerUID (leader _assigned_commander)], time];
};