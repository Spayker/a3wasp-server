/*
	AI Commander Upgrade script.
	 Parameters:
		- Side.
*/
Params ['_side'];
Private["_can_upgrade","_cost","_funds","_level","_logik","_path","_side","_to_upgrade","_upgrade","_upgrades"];

_logik = (_side) Call WFCO_FNC_GetSideLogic;

_path = missionNamespace getVariable Format ["WF_C_UPGRADES_%1_AI_ORDER", _side];
_upgrades = _logik getVariable "wf_upgrades";

//--- Get the existing content.
_to_upgrade = [];
{
	_upgrade = _x select 0;
	_level = _x select 1;
	
	if (_upgrades select _upgrade < _level) exitWith {_to_upgrade = _x;};
} forEach _path;

waitUntil {!(_logik getVariable ["wf_upgrading", false])};

//--- Found something to upgrade!
if (count _to_upgrade > 0) then {
	_upgrade = _to_upgrade select 0;
	_upgrade_cost_array = missionNamespace getVariable Format["WF_C_UPGRADES_%1_COSTS", _side];
	if(!(isNil '_upgrade_cost_array') && count _upgrade_cost_array > 0)then{
	    _cost_for_new_upgrade = _upgrade_cost_array select _upgrade;

	    if(!(isNil '_cost_for_new_upgrade') && count _cost_for_new_upgrade > 0)then{
	        if(!(isNil '_to_upgrade') && count _to_upgrade > 0) then {
	            _cost =  _cost_for_new_upgrade select (_to_upgrade select 1);
	        };
	    };

        if((isNil '_cost'))then{ _cost = [1000] };

        //--- Validation.
        _can_upgrade = false;

        if ((_side Call WFCO_FNC_GetSideSupply) >= (_cost select 0)) then {_can_upgrade = true;};

        //--- Roll on!
        if (_can_upgrade) then {
            [_side, _upgrade, _upgrades select _upgrade, false] Spawn WFSE_fnc_ProcessUpgrade;
            _logik setVariable ["wf_upgrading", true, true];

            //--- Deduct.
            [_side,-(_cost select 0)] Call WFSE_fnc_ChangeAICommanderFunds;
            [_side,-(_cost select 1)] Call WFCO_FNC_ChangeSideSupply;
        };

	};

};