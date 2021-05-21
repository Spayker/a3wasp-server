//------------------fn_UpdatePlayerDataDB-----------------------------------------------------------------------------//
//	Insert data about new player or update nicknames info                                                             //
//------------------fn_UpdatePlayerDataDB-----------------------------------------------------------------------------//
#include "..\script_macros.hpp"
params ["_uid", "_name", "_sideJoined"];
private["_names", "_exists", "_alsoknown", "_alsoknownDC"];

if(extDBOpened) then {
	[format["SELECT InsertPlayer('%1', '%2') as ID", _uid, _name],1] call DB_fnc_asyncCall;
};