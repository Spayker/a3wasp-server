params ["_hc"];
private ["_id","_uid"];

_id = owner _hc;
_uid = getPlayerUID _hc;

["INFORMATION", Format["fn_addHeadlessClient.sqf: Headless client is now connected [%1] [%2] with Owner ID [%3].", _hc, _uid, _id]] call WFCO_FNC_LogContent;

if (_id > 0) then {
    missionNamespace setVariable ["WF_HEADLESSCLIENT_ID", _id];
    missionNamespace setVariable ["WF_HEADLESSCLIENT_UID", _uid];
} else {
    ["WARNING", Format["fn_addHeadlessClient.sqf: Headless client [%1] Owner ID is [0], it is server controlled.",_hc]] call WFCO_FNC_LogContent;
};