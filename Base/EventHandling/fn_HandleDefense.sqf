params ["_defense","_side","_team"];
private ["_buildings","_closest","_direction","_distance","_index","_position","_type","_gunnerType","_unit",
"_commander","_repeats","_hc","_canMann"];

_canMann = false;
_repeats = 0;

while {alive _defense} do {
	if (isNull(gunner _defense) || !alive (gunner _defense)) then {

		_buildings = (_side) call WFCO_FNC_GetSideStructures;
		_closest = ['BARRACKSTYPE',_buildings,WF_C_BASE_DEFENSE_MANNING_RANGE,_side,_defense] call WFCO_FNC_BuildingInRange;
        _canMann = alive _closest;

        //--Second check if we have a barracks in WF_C_BASE_DEFENSE_MANNING_RANGE + WF_C_BASE_DEFENSE_MANNING_RANGE_EXT * 2 (DIAMETER)--
        //--and any building in this area--
        if(!_canMann) then {
            _closest = ['BARRACKSTYPE',_buildings,
                       (WF_C_BASE_DEFENSE_MANNING_RANGE + (WF_C_BASE_DEFENSE_MANNING_RANGE_EXT * 2)),
                       WF_Client_SideJoined,_defense] call WFCO_FNC_BuildingInRange;
            _canMann = (alive _closest && alive([position _defense,_buildings] call WFCO_FNC_GetClosestEntity5));
        };

		if (_canMann) then {
			_type = typeOf _closest;
			_index = (missionNamespace getVariable format["WF_%1STRUCTURENAMES",str _side]) find _type;
			_distance = (missionNamespace getVariable format["WF_%1STRUCTUREDISTANCES",str _side]) # _index;
			_direction = (missionNamespace getVariable format["WF_%1STRUCTUREDIRECTIONS",str _side]) # _index;
			_position = [getPosATL _closest,_distance,getDir (_closest) + _direction] call WFCO_FNC_GetPositionFrom;

			_gunnerType = missionNamespace getVariable format ["WF_%1SOLDIER", _side];
            
            ["INFORMATION", format ["fn_HandleDefense.sqf: [%1] New or old unit will be dispatched to a [%2] defense.",
                str _side, format["%1 %2", typeOf _defense, _defense]]] call WFCO_FNC_LogContent;
			_hc = missionNamespace getVariable ["WF_HEADLESSCLIENT_ID", 0];
            if (_hc > 0) then {
                [_side, _team, [_defense]] remoteExec ["WFHC_FNC_DelegateAIStaticDefence", _hc];
            } else {
                [_side, _team, [_defense]] spawn WFCO_FNC_CreateUnitForStaticDefence;
            };

			_repeats = 0;
		} else {
			if(_repeats == 0) then {
				["INFORMATION", format["Server_HandleDefense.sqf: Can not to create unit for %1, no barracks.", format["%1 %2", typeOf _defense, _defense]]] call WFCO_FNC_LogContent;
				_repeats = 1;
			};
		};
	};

	sleep WF_C_BASE_DEFENSE_MANNING_TIMEOUT;
};