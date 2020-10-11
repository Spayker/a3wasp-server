Params ['_group', '_player', '_side'];
Private ["_group","_player","_side"];

if (alive _player) then {
    if (alive leader _group) then {
        if (isPlayer leader _group) then {
            //--- Player, forward the request.
            [_player] remoteExecCall ["WFCL_FNC_GroupsReceiveRequest", leader _group]
        } else {
            if (isNil {_group getVariable "wf_uid"}) then { //--- Ensure that the group is ai-controlled.
                [_player, _group, _side] Call WFCO_FNC_ChangeUnitGroup;

                //--- Tell the player that his request is granted.
                [_group] remoteExecCall ["WFCL_FNC_Groups_JoinAccepted", _player]
            }
        }
    }
}