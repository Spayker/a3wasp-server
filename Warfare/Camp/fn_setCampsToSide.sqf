/*
	Set a town's camps to a side.
	 Parameters:
		- Town.
		- Old Side.
		- New Side.
*/
Params ['_town', '_side_old', '_side_new'];
Private ["_camps","_side_old","_side_new","_startingSV","_town"];

_camps = _town getVariable "camps";

if !(isNil "_camps") then {
_startingSV = _town getVariable "startingSupplyValue";

{
	_x setVariable ["sideID", _side_new, true];
["INFORMATION",Format ["Server_SetCampsToSide.sqf : [%1] Camps [%2] were set to [%3], previously owned by [%4].", _town getVariable "name", count _camps, _side_new, _side_old]] Call WFCO_FNC_LogContent;

        if(_sideId != WF_C_CIV_ID) then {
            [_town, _side_old, _side_new] remoteExecCall ["WFCL_FNC_AllCampsCaptured", (_side_old) Call WFCO_FNC_GetSideFromID, true]
        };
        [_town, _side_old, _side_new] remoteExecCall ["WFCL_FNC_AllCampsCaptured", (_side_new) Call WFCO_FNC_GetSideFromID, true]

    } forEach _camps
}
