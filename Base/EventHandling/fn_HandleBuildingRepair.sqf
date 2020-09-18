Private ["_bindex","_degradation","_direction","_etat","_group","_lastCompletionCheck","_logic","_logik","_position","_ruins","_ruinsType","_side","_sideID","_type","_redu"];

_logic = _this select 0;
_type = _this select 1;
_side = _this select 2;
_bindex = _this select 3;
_logik = (_side) Call WFCO_FNC_GetSideLogic;
_sideID = (_side) Call WFCO_FNC_GetSideID;
_redu = if (_type isKindOf "Warfare_HQ_base_unfolded") then {5} else {missionNamespace getVariable "WF_C_STRUCTURES_DAMAGES_REDUCTION"};
_lastCompletionCheck = 0;
_degradation = missionNamespace getVariable "WF_C_STRUCTURES_BUILDING_DEGRADATION";

_ruinsType = missionNamespace getVariable "WF_C_STRUCTURES_RUINS";
_position = _logic getVariable "WF_B_Position";
_direction = _logic getVariable "WF_B_Direction";

//--- Create ruins wherever the building get destroyed.
_ruins = _ruinsType createVehicle _position;
_ruins setDir _direction;
_ruins setPos _position;

while {true} do {
	_etat = _logic getVariable 'WF_B_Completion';

	//--- Completed.
	if (_etat >= 100) exitWith {
		Private ["_buildingsCosts","_buildingsNames","_buildingsType","_current","_index","_limit","_site"];
		_buildingsType = missionNamespace getVariable Format["WF_%1STRUCTURES",str _side];
		_index = _buildingsType find (_buildingsType select 0);
		if(_index > -1)then{_buildingsType deleteAt _index};
		_buildingsNames = missionNamespace getVariable Format["WF_%1STRUCTURENAMES",str _side];
		_index = _buildingsNames find (_buildingsNames select 0);
		if(_index > -1)then{_buildingsNames deleteAt _index};
		_buildingsCosts = missionNamespace getVariable Format["WF_%1STRUCTURECOSTS",str _side];
		
		//--- Place if limits allows us to do so.
		_index = _buildingsNames find _type;
		
		if (_index != -1) then {
			_current = _logik getVariable "wf_structures_live";
			_limit = missionNamespace getVariable Format['WF_C_STRUCTURES_MAX_%1',(_buildingsType select _index)];
			if (isNil '_limit') then {_limit = 4}; //--- Default.
			
			//--- We can build, the limit hasn't been reached yet.
			if ((_current select _index) < _limit) then {			
				_site = _type createVehicle _position;
				_site setDir _direction;
				_site setPos _position;
				_site setVariable ["wf_side", _side];
				_site setVariable ["wf_structure_type", _buildingsType select _index];
				
				[_side, "Constructed", ["Base", _site]] Spawn WFSE_fnc_SideMessage;

				//--- Site is created, we add the rest.
				if !(isNull _site) then {
					_current set [_bindex, (_current select _bindex) + 1];
					_logik setVariable ["wf_structures_live", _current, true];
					
					_logik setVariable ["wf_structures", (_logik getVariable "wf_structures") + [_site], true];
					
					[_site,false,_sideID] remoteExec ["WFCL_fnc_initBaseStructure"];
					
					_site addEventHandler ["hit",{_this Spawn WFSE_fnc_BuildingDamaged}];
						_site addEventHandler ['handleDamage',{[_this select 0,_this select 2,_this select 3] Call WFSE_fnc_BuildingHandleDamage}];
					
					Call Compile Format ["_site AddEventHandler ['killed',{[_this select 0,_this select 1,'%1'] Spawn WFSE_fnc_BuildingKilled}];",_type];
						[_side, -round((_buildingsCosts select _index)/2)] Call WFCO_FNC_ChangeSideSupply;
					
				};
				
				_logic setVariable ["WF_B_Repair",false];
			};
		};
	
		_logik setVariable ["wf_structures_logic", (_logik getVariable "wf_structures_logic") - [_logic]];
	};
	
	sleep 5;
	
	//--- Has the etat changed?
	if ((_logic getVariable 'WF_B_Completion') == _etat) then {_lastCompletionCheck = _lastCompletionCheck + 5} else {_lastCompletionCheck = 0};
	
	//--- Degradation if nothing happened.
	if (_lastCompletionCheck > 30) then {
		_etat = (_logic getVariable "WF_B_Completion") - _degradation;
		if (_etat < 0) then {_etat = 0};
		_logic setVariable ["WF_B_Completion",_etat];
		_lastCompletionCheck = 0;
	};
	
	//--- If the etat reach 0, the building is lost.
	if (_etat <= 0) exitWith {
		_logik setVariable ["wf_structures_logic", (_logik getVariable "wf_structures_logic") - [_logic]];
	
		_group = group _logic;
		deleteVehicle _logic;
		deleteGroup _group;
	};
};

deleteVehicle _ruins;