//------------------fn_addEmptyVehicleToQueue-----------------------------------------//
//	The Server getting ref on vehicle and add it to global queue of handling          //
//  empty vehicles. This missionNamespace scope is visible only on the server         //
//------------------fn_addEmptyVehicleToQueue-----------------------------------------//

params["_vehicle"];

//--Prevent empty vehicles queue from outside changing while pushBack is running--
["WF_EmptyVehiclesQueueLocked", missionNamespace] call WFCO_FNC_MutexLock;

private _WF_EmptyVehiclesQueue = missionNamespace getVariable ["WF_EmptyVehiclesQueue", []];
_WF_EmptyVehiclesQueue pushBackUnique _vehicle;
missionNamespace setVariable ["WF_EmptyVehiclesQueue", _WF_EmptyVehiclesQueue];
["WF_EmptyVehiclesQueueLocked", missionNamespace] call WFCO_FNC_MutexUnlock;