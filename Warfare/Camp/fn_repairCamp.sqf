params ["_camp", "_repairSideID"];
private ["_camp_sideID"];

_camp hideObjectGlobal false;

//--- Do we have to update the camp SID ?
_camp_sideID = _camp getVariable "sideID";
if (_camp_sideID != _repairSideID) then {
    private ["_town"];
    _camp setVariable ["sideID", _repairSideID, true];

    //--- Notify / update map if needed.
    [_camp, _repairSideID, _camp_sideID, true] remoteExecCall ["WFCL_FNC_CampCaptured"];
};