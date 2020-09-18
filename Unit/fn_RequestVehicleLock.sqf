params ["_vehicle", "_locked"];
private ["_client","_side"];

_vehicle lock _locked;

[_vehicle,_locked] remoteExec ["WFCL_FNC_SetVehicleLock",-2];