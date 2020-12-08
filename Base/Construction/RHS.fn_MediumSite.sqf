//*****************************************************************************************
//Description: Creates a small construction site.
//*****************************************************************************************
params ["_type", "_side", "_position", "_direction", "_index", "_playerUID"];
private ["_construct","_constructed","_group","_logik","_nearLogic","_rlType","_sideID","_site","_siteName","_startTime",
"_structures","_structuresNames","_time","_timeNextUpdate","_siteMaxHealth","_dmgr",
"_WF_MEDIUM_SITE_1_OBJECTS", "_WF_MEDIUM_SITE_2_OBJECTS", "_WF_MEDIUM_SITE_3_OBJECTS"];

#include "fn_MediumSiteObjects.sqf";

_logik = (_side) Call WFCO_FNC_GetSideLogic;
_sideID = (_side) Call WFCO_FNC_GetSideID;

_time = ((missionNamespace getVariable Format ["WF_%1STRUCTURETIMES",str _side]) select _index) / 2;

_siteName = missionNamespace getVariable Format["WF_%1CONSTRUCTIONSITE",str _side];

_structures = missionNamespace getVariable Format ['WF_%1STRUCTURES',str _side];
_structuresNames = missionNamespace getVariable Format ['WF_%1STRUCTURENAMES',str _side];
_dmgr = (missionNamespace getVariable format["WF_%1STRUCTUREDMGREDUCER",str _side]) # _index;
_siteMaxHealth = (missionNamespace getVariable format ["WF_%1STRUCTUREMAXHEALTH",str _side]) # _index;
_rlType = _structures select (_structuresNames find _type);

_startTime = time;
_timeNextUpdate = _startTime + _time;

_constructed = ([_position,_direction,_WF_MEDIUM_SITE_1_OBJECTS] Call WFSE_FNC_CreateObjectsFromArray);

//--- Create the logic.
(createGroup sideLogic) createUnit ["LocationArea_F",_position,[],0,"NONE"];

_nearLogic = objNull;
if ((missionNamespace getVariable "WF_C_STRUCTURES_CONSTRUCTION_MODE") == 0) then {
	//--- Grab the logic.
	_nearLogic = _position nearEntities [["LocationArea_F"],15];
	_nearLogic = [_position, _nearLogic] Call WFCO_FNC_GetClosestEntity;
	
	if (isNull _nearLogic) exitWith {};
	
	//--- Position the logic.
	_nearLogic setPos _position;
	
	_nearLogic setVariable ["WF_B_Type", _rlType];

	waitUntil {time >= _timeNextUpdate};
	_timeNextUpdate = _startTime + _time * 2;
} else {
	//--- Grab the logic.
	_nearLogic = _position nearEntities [["LocationArea_F"],15];
	_nearLogic = [_position, _nearLogic] Call WFCO_FNC_GetClosestEntity;
	
	if (isNull _nearLogic) exitWith {};
	
	//--- Position the logic.
	_nearLogic setPos _position;
	
	//--- Instanciate the logic.
	_nearLogic setVariable ["WF_B_Completion", 0];
	_nearLogic setVariable ["WF_B_CompletionRatio", 0.6];
	_nearLogic setVariable ["WF_B_Direction", _direction];
	_nearLogic setVariable ["WF_B_Position", _position];
	_nearLogic setVariable ["WF_B_Repair", false];
	_nearLogic setVariable ["WF_B_Type", _rlType];
	
	//--- Add the logic to the list.
	_logik setVariable ["wf_structures_logic", (_logik getVariable "wf_structures_logic") + [_nearLogic]];
	
	//--- Awaits for 33% of completion.
	while {true} do {
		sleep 1;
		if ((_nearLogic getVariable "WF_B_Completion") >= 33.33) exitWith {};
	};
};

_constructed = _constructed + ([_position,_direction,_WF_MEDIUM_SITE_2_OBJECTS] Call WFSE_FNC_CreateObjectsFromArray);

if ((missionNamespace getVariable "WF_C_STRUCTURES_CONSTRUCTION_MODE") == 0) then {
	waitUntil {time >= _timeNextUpdate};
	_timeNextUpdate = _startTime + _time * 3;
} else {
	//--- Awaits for 66%
	while {true} do {
		sleep 1;
		if ((_nearLogic getVariable "WF_B_Completion") >= 66.66) exitWith {};
	};
};

_constructed = _constructed + ([_position,_direction,_WF_MEDIUM_SITE_3_OBJECTS] Call WFSE_FNC_CreateObjectsFromArray);

if ((missionNamespace getVariable "WF_C_STRUCTURES_CONSTRUCTION_MODE") == 0) then {
	waitUntil {time >= _timeNextUpdate};
	
	if !(isNull _nearLogic) then {
		_group = group _nearLogic;
		deleteVehicle _nearLogic;
		deleteGroup _group;
	};
} else {
	//--- Awaits for 100%
	while {true} do {
		sleep 1;
		if ((_nearLogic getVariable "WF_B_Completion") >= 100) exitWith {};
	};
	
	//--- Remove the logic from the list since it's built. Add it back if destroyed.
	_logik setVariable ["wf_structures_logic", (_logik getVariable "wf_structures_logic") - [_nearLogic]];
};

if(!isNil "_constructed")then{
	{
	    if!(isNull _x)then{
	        deleteVehicle _x
	    };
	} forEach _constructed;
};

_site = createVehicle [_type, [0,0,random [25,50,100]], [], 0, "NONE"];
_site setDir _direction;
_site setPos _position;
_site setVariable ["wf_side", _side];
_site setVariable ["wf_structure_type", _rlType];
_site setVariable ["wf_site_maxhealth", _siteMaxHealth];
_site setVariable ["wf_site_health", _siteMaxHealth, true];
_site setVariable ["wf_reducer", _dmgr # 0];
_site setVariable ["wf_index", _index];

[_site, _rlType] remoteExec ["WFCL_FNC_addBaseBuildingRepAction", _side, true];

//--Not for AAR construction--
if((missionNamespace getVariable[format["WF_AutoWallConstructingEnabled_%1", _playerUID], WF_AutoWallConstructingEnabled]) && !(_rlType in ["AARadar","ArtyRadar"])) then {
    _defenses = [_site, missionNamespace getVariable format ["WF_NEURODEF_%1_WALLS", _rlType]] call WFSE_FNC_CreateDefenseTemplate;
    _site setVariable ["WF_Walls", _defenses];
};

[_side, "Constructed", ["Base", _site]] Spawn WFSE_FNC_SideMessage;

if (!isNull _site) then {
	_logik setVariable ["wf_structures", (_logik getVariable "wf_structures") + [_site], true];
	[_site,false,_sideID] remoteExec ["WFCL_fnc_initBaseStructure", 0, true];
	
	_site addEventHandler ["Hit", {
            params ["_unit"];
            [_unit] call WFSE_FNC_BuildingDamaged;
        }];

        _site addEventHandler ["HandleDamage", {
            _this call WFCO_FNC_BuildingHandleDamage;
            false;
        }];
	
	["INFORMATION", Format ["Construction_MediumSite.sqf: [%1] Structure [%2] has been constructed.", str _side, _type]] Call WFCO_FNC_LogContent;
};