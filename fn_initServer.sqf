#include "script_macros.hpp"

if (!isServer || time > 30) exitWith {
	diag_log Format["[WF (WARNING)][frameno:%1 | ticktime:%2] Init_Server: The server initialization cannot be called more than once.",diag_frameno,diag_tickTime]
};

["INITIALIZATION", Format ["fn_initServer.sqf: Server initialization begins at [%1]", time]] Call WFCO_FNC_LogContent;

//--- Allow resistance and civilian group to be spawned without a placeholder.
createCenter resistance;
createCenter civilian;

//--- MAke res forces not friendly to all playable sides.
resistance setFriend [west,0];
resistance setFriend [east,0];
resistance setFriend [civilian,1];
civilian setFriend [west, 0];
civilian setFriend [east, 0];
civilian setFriend [resistance, 1];

// Prepare extDB before starting the initialization process for the server.
private _extDBNotLoaded = "";
extDBOpened = false;
private _dbresult = "extDB3" callExtension "9:VERSION";
if (_dbresult == "") then {
	["INITIALIZATION", "fn_initServer.sqf: extDB3 Failed to Load!"] Call WFCO_FNC_LogContent;
} else {
	if (isNil {uiNamespace getVariable "wasp_sql_id"}) then {
		wasp_sql_id = round(random(9999));
		CONSTVAR(wasp_sql_id);
		uiNamespace setVariable ["wasp_sql_id", wasp_sql_id];
		try {
			_result = EXTDB format ["9:ADD_DATABASE:%1",EXTDB_SETTING(getText,"DatabaseName")];
			if (!(_result isEqualTo "[1]")) then {throw "extDB3: Error with Database Connection"};
			_result = EXTDB format ["9:ADD_DATABASE_PROTOCOL:%2:SQL:%1:TEXT2",FETCH_CONST(wasp_sql_id),EXTDB_SETTING(getText,"DatabaseName")];
			if (!(_result isEqualTo "[1]")) then {throw "extDB3: Error with Database Connection"};
		} catch {
			diag_log _exception;
			_extDBNotLoaded = [true, _exception];
		};
		if (_extDBNotLoaded isEqualType []) exitWith {};
		
		EXTDB "9:LOCK";
		diag_log "extDB3: Connected to Database";
		extDBOpened = true;
	} else {
		wasp_sql_id = uiNamespace getVariable "wasp_sql_id";
		CONSTVAR(wasp_sql_id);
		diag_log "extDB3: Still Connected to Database";
		extDBOpened = true;
	};
};

//--- Stationary defense init
WF_static_defenses = [];
[] spawn WFSE_FNC_startStaticDefenseProcessing;

//--- Server Init is now complete.
serverInitComplete = true;
["INITIALIZATION", "fn_initServer.sqf: Functions are loaded."] Call WFCO_FNC_LogContent;

//--- Getting all locations.
startingLocations = [0,0,0] nearEntities ["LocationArea_F", 100000];
["INITIALIZATION", "fn_initServer.sqf: Initializing starting locations."] Call WFCO_FNC_LogContent;

//--- Waiting for the common part to be executed.
waitUntil {commonInitComplete && townInit};

//--- Side logics.
_present_west = missionNamespace getVariable "WF_WEST_PRESENT";
_present_east = missionNamespace getVariable "WF_EAST_PRESENT";
_present_res = missionNamespace getVariable "WF_GUER_PRESENT";

[] Call Compile preprocessFile 'waspServer\Base\Init_Defenses.sqf';

//--- Weather.
[] spawn WFSE_FNC_RunWeatherEnvironment;

["INITIALIZATION", "fn_initServer.sqf: Weather module is loaded."] Call WFCO_FNC_LogContent;

//--- Static defenses groups in main towns.
{
	missionNamespace setVariable [Format ["WF_%1_DefenseTeam", _x], createGroup [_x, true]];
	(missionNamespace getVariable Format ["WF_%1_DefenseTeam", _x]) setVariable ["wf_persistent", true];
} forEach [west,east,resistance];

//--- Select whether the spawn restriction is enabled or not.
_locationLogics = [];
if ((missionNamespace getVariable "WF_C_BASE_START_TOWN") > 0) then {
	{
		_nearLogics = _x nearEntities[["LocationArea_F"],2000];
		if (count _nearLogics > 0) then {{if !(_x in _locationLogics) then {_locationLogics pushBack _x;}} forEach _nearLogics};
	} forEach towns;
	if (count _locationLogics < 3) then {_locationLogics = startingLocations;};
	["INITIALIZATION", Format ["fn_initServer.sqf: spawn locations were refined [%1].",count _locationLogics]] Call WFCO_FNC_LogContent;
} else {
	_locationLogics = startingLocations;
};

WF_Logic setVariable ["wf_spawnpos", _locationLogics];

Private ["_i", "_maxAttempts", "_minDist", "_rPosE", "_rPosW", "_setEast", "_setGuer", "_setWest", "_startE", "_startW"];
_i = 0;
_maxAttempts = 2000;
_minDist = missionNamespace getVariable 'WF_C_BASE_STARTING_DISTANCE';
_startW = [0,0,0];
_startE = [0,0,0];
_rPosW = [0,0,0];
_rPosE = [0,0,0];
_setWest = if (_present_west) then {true} else {false};
_setEast = if (_present_east) then {true} else {false};
_setGuer = if (_present_res) then {true} else {false};
_total = count _locationLogics;

_use_random = false;

_spawn_north = objNull;
_spawn_south = objNull;
_spawn_central = objNull;
_skip_w = false;
_skip_e = false;
{
	if (!isNil {_x getVariable "wf_spawn"}) then {
		switch (_x getVariable "wf_spawn") do {
			case "north": {_spawn_north = _x;};
			case "south": {_spawn_south = _x;};
			case "central": {_spawn_central = _x;};
		};
	};
} forEach startingLocations;

switch (missionNamespace getVariable "WF_C_BASE_STARTING_MODE") do {
	case 0: {
		//--- West north, east south.
		if (isNull _spawn_north || isNull _spawn_south) then {
			_use_random = true;
		} else {
			_startE = _spawn_south;
			_startW = _spawn_north;
		};
	};
	case 1: {
		//--- West south, east north.
		if (isNull _spawn_north || isNull _spawn_south) then {
			_use_random = true;
		} else {
			_startE = _spawn_north;
			_startW = _spawn_south;
		};
	};
	case 2: {
		_use_random = true;
	};
};

if (_use_random) then {
	while {true} do {
		if (!_setWest && !_setEast && !_setGuer) exitWith {["INITIALIZATION", "fn_initServer.sqf : All sides were placed [Random]."] Call WFCO_FNC_LogContent};

		//--- Determine west starting location if necessary.
		if (_setWest) then {
			_rPosW = _locationLogics # floor(random _total);
			if (_rPosW distance _startE > _minDist) then {_startW = _rPosW; _setWest = false;};
		};

		// --- Determine west starting location if necessary.
		if (_setEast) then {
			_rPosE = _locationLogics # floor(random _total);
			if (_rPosE distance _startW > _minDist) then {_startE = _rPosE; _setEast = false;};
		};

		_i = _i + 1;

		if (_i >= _maxAttempts) exitWith {
			//--- Get the default locations.
			Private ["_eastDefault", "_westDefault"];
			_eastDefault = objNull;
			_westDefault = objNull;

			{
				if (!isNil {_x getVariable "wf_default"}) then {
					switch (_x getVariable "wf_default") do {
						case west: {_westDefault = _x;};
						case east: {_eastDefault = _x;};
					};
				};
			} forEach startingLocations;

			// --- Ensure that everything is set, otherwise we randomly set the spawn.
			if (isNull _eastDefault || isNull _westDefault) then {
				Private ["_tempWork"];
				_tempWork = +(startingLocations) - [_westDefault, _eastDefault];
				if (isNull _eastDefault && _present_east) then {_eastDefault = _tempWork # floor(random _total); _tempWork = _tempWork - [_eastDefault];};
				if (isNull _westDefault && _present_west) then {_westDefault = _tempWork # floor(random _total); _tempWork = _tempWork - [_westDefault];};
			};

			if (_present_east && !_skip_e) then {_startE = _eastDefault;};
			if (_present_west && !_skip_w) then {_startW = _westDefault;};

			["INITIALIZATION", "fn_initServer.sqf : All sides were placed by force after that the attempts limit was reached."] Call WFCO_FNC_LogContent;
		};
	};
};

["INITIALIZATION", Format ["fn_initServer.sqf: Starting location mode is on [%1].",missionNamespace getVariable "WF_C_BASE_STARTING_MODE"]] Call WFCO_FNC_LogContent;

//--- Pre-initialization of the Garbage Collector & Empty vehicle collector.
[] spawn WFSE_fnc_startEmptyVehiclesCollector;
["INITIALIZATION", "fn_initServer.sqf: Empty Vehicle Collector is defined."] Call WFCO_FNC_LogContent;

//--- Global sides initialization.
{
	Private["_side"];
	_side = _x # 1;
	//--- Only use those variable if the side logic is present in the editor.
	if (_x # 0) then {
		_pos = _x # 2;
		_logik = (_side) Call WFCO_FNC_GetSideLogic;
		_sideID = (_side) Call WFCO_FNC_GetSideID;

		//--- HQ init.
		_safePos = [_pos, 1, 5, 4, 0, 20, 0] call BIS_fnc_findSafePos;
		_hq = [missionNamespace getVariable Format["WF_%1MHQNAME", _side], _safePos, _sideID, getDir _pos, true, false, true] Call WFCO_FNC_CreateVehicle;
		if(damage _hq > 0) then { _hq setDamage 0; };
       
		//--- Get upgrade clearance for side.
		_clearance = missionNamespace getVariable "WF_C_GAMEPLAY_UPGRADES_CLEARANCE";
		_upgrades = false;
		if (_clearance != 0) then {
			_upgrades = switch (true) do {
				case (_clearance in [1,4,5,7] && _side == west): {true};
				case (_clearance in [2,4,6,7] && _side == east): {true};
				case (_clearance in [3,5,6,7] && _side == resistance): {true};
				default {false};
			};
		};

		if !(_upgrades) then {
			_upgrades = [];
			for '_i' from 0 to count(missionNamespace getVariable Format["WF_C_UPGRADES_%1_LEVELS", _side])-1 do {_upgrades pushBack 0};
		} else {
			_upgrades = missionNamespace getVariable Format["WF_C_UPGRADES_%1_LEVELS", _side];
		};

		//--- Logic init.
		_logik setVariable ["wf_commander", objNull, true];

		_logik setVariable ["wf_startpos", _pos, true];
		_logik setVariable ["wf_structure_lasthit", 0];
		_logik setVariable ["wf_structures", [], true];
		_logik setVariable ["wf_aicom_running", false];
		_logik setVariable ["wf_aicom_funds", round((missionNamespace getVariable Format ['WF_C_ECONOMY_FUNDS_START_%1', _side])*1.5)];
		_logik setVariable ["wf_upgrades", _upgrades, true];
		_logik setVariable ["wf_upgrading", false, true];
		_logik setVariable ["wf_votetime", missionNamespace getVariable "WF_C_GAMEPLAY_VOTE_TIME", true];
		_logik setVariable ["wf_hqinuse",false];

		WF_Logic setVariable [Format["%1UnitsCreated",_side],0,true];
		WF_Logic setVariable [Format["%1Casualties",_side],0,true];
		WF_Logic setVariable [Format["%1VehiclesCreated",_side],0,true];
		WF_Logic setVariable [Format["%1VehiclesLost",_side],0,true];

		//--- Parameters specific.
		if ((missionNamespace getVariable "WF_C_BASE_AREA") > 0) then {_logik setVariable ["wf_basearea", [], true]};
		
		_logik setVariable ["wf_supply", missionNamespace getVariable Format ["WF_C_ECONOMY_SUPPLY_START_%1", _side], true];
		missionNamespace setVariable ["wf_commander_percent", if ((missionNamespace getVariable "WF_C_ECONOMY_INCOME_PERCENT_MAX") >= 50 && (missionNamespace getVariable "WF_C_ECONOMY_INCOME_PERCENT_MAX") <= 100) then { missionNamespace getVariable "WF_C_ECONOMY_INCOME_PERCENT_MAX"} else {100}, true];
		

		//--- Structures limit (live).
		_str = [];
		for '_i' from 0 to count(missionNamespace getVariable Format["WF_%1STRUCTURES",_side])-2 do {_str set [_i, 0]};
		_logik setVariable ["wf_structures_live", _str, true];

		//--- Radio: Initialize the announcers entities.
		_radio_hq1 = (createGroup sideLogic) createUnit ["Logic",[0,0,0],[],0,"NONE"];
		_radio_hq2 = (createGroup sideLogic) createUnit ["Logic",[0,0,0],[],0,"NONE"];
		[_radio_hq1] joinSilent (createGroup _side);
		[_radio_hq2] joinSilent (createGroup _side);
		_logik setVariable ["wf_radio_hq", _radio_hq1, true];
		_logik setVariable ["wf_radio_hq_rec", _radio_hq2];

		//--- Radio: Pick a random announcer.
		_announcers = missionNamespace getVariable Format ["WF_%1_RadioAnnouncers", _side];
		_radio_hq_id = (_announcers) # floor(random (count _announcers));
		_announcersType = missionNamespace getVariable Format ["WF_%1_RadioAnnouncers_Type", _side];
		
		_logik setVariable ["wf_radio_hq_type", _announcersType # floor(random (count _announcersType)), true];

		//--- Radio: Apply an identity.
		_radio_hq1 setIdentity _radio_hq_id;
		_radio_hq1 setRank 'COLONEL';
		_radio_hq1 setGroupId ["HQ"];
		_radio_hq1 kbAddTopic [_radio_hq_id, "Common\Module\Kb\hq.bikb","Common\Module\Kb\hq.fsm", {call WFCO_fnc_initHq}];
		_logik setVariable ["wf_radio_hq_id", _radio_hq_id, true];

		//--- Starting vehicles.
		{
			_pos = getPosATL _hq;
			_safePos = [_pos, 15, 15, 4, 0, 20, 0] call BIS_fnc_findSafePos;
			_vehicle = [_x, _pos, _sideID, 0, false] Call WFCO_FNC_CreateVehicle;
			(_vehicle) call WFCO_FNC_ClearVehicleCargo;
		} forEach (missionNamespace getVariable Format ['WF_%1STARTINGVEHICLES', _side]);

		//--- spawn of additional vehicles
		switch _side do{
			case west: {
				call WFCO_fnc_respawnStartVeh;
				_tVeh = WEST_StartVeh # floor(random (count WEST_StartVeh));
				_pos = getPosATL _hq;
				_safePos = [_pos, 1, 25, 4, 0, 20, 0] call BIS_fnc_findSafePos;
				_vehicle = [_tVeh,_safePos, west, 0, false] Call WFCO_FNC_CreateVehicle;
			};
			case east:{
				call WFCO_fnc_respawnStartVeh;
				_tVeh = EAST_StartVeh # floor(random (count EAST_StartVeh));
				_pos = getPosATL _hq;
				_safePos = [_pos, 1, 25, 4, 0, 20, 0] call BIS_fnc_findSafePos;
				_vehicle = [_tVeh, _safePos, east, 0, false] Call WFCO_FNC_CreateVehicle;
			};
		};

		//--- Groups init.
		_teams = [];
		{
			if !(isNil '_x') then {
				if (_x isKindOf "Man") then {
					Private ["_group"];
					_group = group _x;
					_teams pushBack _group;

					if (isNil {_group getVariable "wf_funds"}) then {_group setVariable ["wf_funds", missionNamespace getVariable Format ["WF_C_ECONOMY_FUNDS_START_%1", _side], true]};
					_group setVariable ["wf_side", _side];
					_group setVariable ["wf_persistent", true];
					_group setVariable ["wf_queue", []];
					_group setVariable ["wf_vote", -1, true];
					_group setVariable ["wf_role", "", true];
					(leader _group) enableSimulationGlobal true;

					["INITIALIZATION", Format["fn_initServer.sqf: [%1] Team [%2] was initialized.", _side, _group]] Call WFCO_FNC_LogContent;
				};

			};
		} forEach ((getPosATL _logik) nearObjects ["Man", 150]);

		_logik setVariable ["wf_teams", _teams, true];
		_logik setVariable ["wf_teams_count", count _teams];
	};
} forEach [[_present_east, east, _startE],[_present_west, west, _startW]];

_selected_pos_array = [];
_start_position_array = [];
serverInitFull = true;

//--- Town starting mode.
if((missionNamespace getVariable "WF_DEBUG_DISABLE_TOWN_INIT") == 0) then {
	waitUntil{count towns == totalTowns};
};

// run one global server town script to process supply updates in each town
[] spawn WFSE_fnc_startTownProcessing;

[] spawn {
	if ((missionNamespace getVariable "WF_C_TOWNS_DEFENDER") > 0 || (missionNamespace getVariable "WF_C_TOWNS_OCCUPATION") > 0) then {
		[] spawn WFSE_fnc_startTownAiProcessing; // for occupation forces (spawn/despawn mode)
	};
};

if ((missionNamespace getVariable "WF_C_TOWNS_STARTING_MODE") != 0) then {
	[] spawn WFSE_fnc_initTowns;
} else {
	townInitServer = true;
};

//--- Don't pause the server init script.
[] spawn {
	waitUntil {townInit};
		[] spawn WFSE_fnc_startEndGameConditionProcessing;
		["INITIALIZATION", "fn_initServer.sqf: Victory Condition FSM is initialized."] Call WFCO_FNC_LogContent;

	[] spawn WFSE_fnc_updateResources;
	["INITIALIZATION", "fn_initServer.sqf: Resources FSM is initialized."] Call WFCO_FNC_LogContent;

	[] spawn WFCO_FNC_updateCampsInTown;
	["INITIALIZATION", "fn_initServer.sqf: camps update script is initialized."] Call WFCO_FNC_LogContent;
};

[] spawn WFSE_fnc_startGarbageCollector;
["INITIALIZATION", "fn_initServer.sqf: Garbage Collector is defined."] Call WFCO_FNC_LogContent;

//--- Base Area (grouped base)
if ((missionNamespace getVariable "WF_C_BASE_AREA") > 0) then {[] spawn WFSE_fnc_startBaseAreaProcessing};

//--WASP MODULES: start TaskDirector--
["INITIALIZATION", Format ["fn_initServer.sqf: Server start TaskDirector at [%1]", time]] Call WFCO_FNC_LogContent;
[] spawn WFSE_fnc_initTaskDirector;

//--- Waiting until that the game is launched.
waitUntil { time > 0 };

//--Start broadcast FPS  of the server--
[] spawn WFSE_FNC_broadCastFPS;

//--Update players global list--
if(isMultiplayer && !isDedicated)then{
    [0] spawn WFSE_FNC_updatePlayersList;
};

//--- Resistance base spawning
emptyQueu = [];
_startLocationPositions = [];
{
    _startLocationPositions pushBack (getPosAtl _x);
    deleteVehicle _x
} forEach ([0,0,0] nearEntities [["LocationOutpost_F"], 100000]);

[0, _startLocationPositions] spawn WFSE_FNC_CreateBaseComposition;

//--- Voting process init
["INITIALIZATION", Format ["fn_initServer.sqf: Server start autovoting at [%1]", time]] Call WFCO_FNC_LogContent;
{_x spawn WFSE_FNC_VoteForCommander} forEach WF_PRESENTSIDES;

[worldName, missionNamespace getVariable ["WF_MISSIONNAME", ""]] spawn WFSE_FNC_InitGameInfo;

[format [":regional_indicator_g: :regional_indicator_a: :regional_indicator_m: :regional_indicator_e:   :regional_indicator_s: :regional_indicator_t: :regional_indicator_a: :regional_indicator_r: :regional_indicator_t: :regional_indicator_e: :regional_indicator_d:   :point_right:   **%1**", missionNamespace getVariable "WF_MISSIONNAME"]] Call WFDC_FNC_LogContent;

["INITIALIZATION", Format ["fn_initServer.sqf: Server initialization ended at [%1]", time]] Call WFCO_FNC_LogContent;
[format ["Server initialization ended at [%1]", time]] Call WFDC_FNC_LogContent;