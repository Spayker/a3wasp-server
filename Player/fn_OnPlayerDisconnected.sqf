/*
	Event Handler triggered everytime a player disconnect from the server, this file handle all the players disconnection.
	 Parameters:
		- User ID
		- User Name
*/

params ["_unit", "_id", "_uid", "_name"];
private ['_funds','_get','_hq','_side','_team','_unitVehicle','_canDeleteVehicle','_logic','_role'];

sleep 0.5;

//--- Wait for a proper common & server initialization before going any further.
waitUntil {commonInitComplete && serverInitFull};

if (_name == '__SERVER__' || _uid == '' || local player) exitWith {};

//--Delete player AIs and vehicles--
_team = grpNull;
{
	{
		if !(isNil {_x getVariable "wf_uid"}) then {if ((_x getVariable "wf_uid") == _uid) then {_team = _x}};
		if !(isNull _team) exitWith {};
	} forEach ((_x call WFCO_FNC_GetSideLogic) getVariable "wf_teams");
	if !(isNull _team) exitWith {};
} forEach WF_PRESENTSIDES;

//--Resave player fortifications areas with unexist client id--
//--Next client with same id must to store other areas array--
{
    if(_x # 0 == owner _unit) exitWith {
        ["WF_PLAYERS_FORTIFICATIONS_AREA_LOCKED", missionNamespace] call WFCO_FNC_MutexLock;

        private _areas = missionNamespace getVariable ["WF_PLAYERS_FORTIFICATIONS_AREA", []];
        if(count _areas > _forEachIndex) then {
            _areas set [_forEachIndex, [-time - (owner _unit), (_areas # _forEachIndex) # 1]];
        };

        missionNamespace setVariable ["WF_PLAYERS_FORTIFICATIONS_AREA", _areas];
        ["WF_PLAYERS_FORTIFICATIONS_AREA_LOCKED", missionNamespace] call WFCO_FNC_MutexUnlock;
    };
} forEach (missionNamespace getVariable ["WF_PLAYERS_FORTIFICATIONS_AREA", []]);

["INFORMATION", format ["fn_OnPlayerDisconnected.sqf: Player [%1] [%2] has left the game", _name, _uid]] call WFCO_FNC_LogContent;
[format ["Player **%1** has left the game :wave:", _name]] call WFDC_FNC_LogContent;

//--Update playing time statistic--
//if(missionNamespace getVariable[format["wf_cj_%1", _uid], false]) then {
    [_uid, _name, missionNamespace getVariable[format["wf_ps_%1", _uid], WF_C_UNKNOWN_ID],
        time - (missionNamespace getVariable [format["wf_pt_%1", _uid], time]),
        time - (missionNamespace getVariable [format["wf_ct_%1", _uid], time])] spawn WFSE_FNC_UpdatePlayingTime;
	missionNamespace setVariable [format["wf_pt_%1", _uid], nil];
    missionNamespace setVariable [format["wf_ct_%1", _uid], nil];
	missionNamespace setVariable [format["wf_ps_%1", _uid], nil];
	//missionNamespace setVariable [format["wf_cj_%1", _uid], nil];
//};

//--Update players global list--
[1, _uid] spawn WFSE_FNC_updatePlayersList;

//--- Headless Clients disconnection?.
if (_uid == (missionNamespace getVariable["WF_HEADLESSCLIENT_UID", '0'])) then {
	missionNamespace setVariable ["WF_HEADLESSCLIENT_ID", nil];
	missionNamespace setVariable ["WF_HEADLESSCLIENT_UID", nil];
	["INFORMATION", format ["fn_OnPlayerDisconnected.sqf: missionNamespace variable WF_HEADLESSCLIENT_ID [%1]", missionNamespace getVariable["WF_HEADLESSCLIENT_ID", 0]]] call WFCO_FNC_LogContent;
};

//--- Player had any objects created?
_get = missionNamespace getVariable format ["WF_CLIENT_%1_OBJECTS", _uid];
if !(isNil '_get') then {
	{if !(isNil '_x') then {deleteVehicle _x}} forEach _get;
	missionNamespace setVariable [format ["WF_CLIENT_%1_OBJECTS", _uid], nil];
};

//--- We force the unit out of it's vehicle.
if !(isNull(assignedVehicle _unit)) then {
	unassignVehicle _unit;
	[_unit] orderGetIn false;
	[_unit] allowGetIn false;
};

//--- We attempt to get the player information in case that he joined before.
_get = missionNamespace getVariable format["WF_JIP_USER%1",_uid];

if (isNil '_get') exitWith {["INFORMATION", Format ["fn_OnPlayerDisconnected.sqf: Player [%1] [%2] don't have any information stored", _name, _uid]] Call WFCO_FNC_LogContent};
_side = _get # 3;

//--- Eject the unit if it's in the HQ.
_mhqs = (_side) Call WFCO_FNC_GetSideHQ;
_hq = [_unit,_mhqs] call WFCO_FNC_GetClosestEntity;
if (vehicle _unit == _hq) then {_unit action ["EJECT", _hq]};

{
	_unitVehicle = objectParent _x;
	if(!isNull _unitVehicle) then {
		_canDeleteVehicle = true;
		{
			if(group _x != _team) exitWith {
				_canDeleteVehicle = false;
			};
		} forEach (crew _unitVehicle);

		if(_canDeleteVehicle) then {
		    if(_unitVehicle != _hq) then { deleteVehicle _unitVehicle };
            deleteVehicle _x
		} else {
			_unitVehicle deleteVehicleCrew _x;
		};
	} else {
		deleteVehicle _x;
	};
} forEach (units _team);

//--- We attempt to fetch the client old unit, we need to check if it's group is the right one (on the fly group swapping).
_old_unit = _team getVariable "wf_teamleader";
if (isNil '_old_unit') then {
	_old_unit = objNull;
} else {
	if !(alive _old_unit) then {_old_unit = objNull};
};

if (isNull _old_unit) then {
	_old_unit = leader _team;
	["INFORMATION", Format ["fn_OnPlayerDisconnected.sqf: Player [%1] [%2] current team leader is dead or nil, using original team leader [%3].", _name, _uid, _team]] Call WFCO_FNC_LogContent;
};
_old_unit_group = group _old_unit;

//--- Make sure that our disconnected player group was the same as the original, we simply set him back to his group otherwise).
if (_old_unit_group != _team) then {

	["INFORMATION", Format ["fn_OnPlayerDisconnected.sqf: Player [%1] [%2] was in team [%3] and has been transfered to it's source team [%4].", _name, _uid, _old_unit_group, _team]] Call WFCO_FNC_LogContent;

	//--- Make sure that the disconnected unit is the leader of it's group now.
	if (leader _team != _old_unit) then {
		_team selectLeader _old_unit;
		["INFORMATION", Format ["Server_PlayerDisconnected.sqf: Player [%1] [%2] has been set as the leader of it's source team [%3].", _name, _uid, _team]] Call WFCO_FNC_LogContent;
	};
};

//--- We force the unit out of it's vehicle.
if !(isNull(assignedVehicle _old_unit)) then {
	unassignVehicle _old_unit;
	[_old_unit] orderGetIn false;
	[_old_unit] allowGetIn false;
};

//--- We save the disconnect client funds.
_get set [1,_unit getVariable "wf_funds"];

//--Check if disconnected player group is commander group--
{
    _logic = _x call WFCO_FNC_GetSideLogic;
    if(!isNil "_logic" && !isNil "_team") then {
        if((_logic getVariable ["wf_commander", grpNull]) isEqualTo _team) exitWith {
            _logic setVariable ["wf_commander", grpNull, true];
        };
    };
} forEach WF_PRESENTSIDES;

//--Reset roles list
_role = _get # 5;

if(!isNil "_role") then {
    if(_role != "") then {
        _roleDetails = [_role, _side] call WFCO_fnc_getRoleDetails;
        _roleList = [_side] call WFCO_fnc_roleList;

        _currentOcuupiedRoleAmount = (_roleDetails # 7) - 1;
        _roleDetails set [7, _currentOcuupiedRoleAmount];
        _get set [5, ""];
    };
};

//--- Update the new informations.
missionNamespace setVariable [format["WF_JIP_USER%1",_uid], _get];