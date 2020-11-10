/*
	Return a list of groups to spawn in a town.
	 Parameters:
		- Town Entity.
		- Side.
*/
params ["_town", "_side"];
private ["_groups_max","_current_infantry_upgrade","_town_airactive","_squadTypes","_side","_sv","_town",
"_unitTemplateCount","_randomSelectedTemplate", "_total_infantry","_total_infantry","_contents","_startingSupplyValue"];

_sv = _town getVariable "supplyValue";
_town_airactive = _town getVariable "wf_active_air";
_startingSupplyValue = _town getVariable "startingSupplyValue";

_groups_max = round(_sv / 10);
_current_infantry_upgrade = 0;

if (_side != resistance) then {
    _upgrades = (_side) Call WFCO_FNC_GetSideUpgrades;
    _current_infantry_upgrade = _upgrades select WF_UP_BARRACKS;
    _groups_max = round(_groups_max * (missionNamespace getVariable "WF_C_TOWNS_OCCUPATION_COEF"));
} else {
    _current_infantry_upgrade = floor random 4;
    _groups_max = round(_groups_max * (missionNamespace getVariable "WF_C_TOWNS_DEFENDER_COEF"));
};

_squadTypes = [format["%1%2", WF_TOWNS_TEAMS # 0, _current_infantry_upgrade], format["%1%2", WF_TOWNS_TEAMS # 1, _current_infantry_upgrade]];

for '_j' from 0 to (_groups_max - 1 - (count _squadTypes)) do {
    _squadTypes pushBack format["%1%2", selectRandom WF_TOWNS_TEAMS, _current_infantry_upgrade];
};

_contents = [];
{
	_get = missionNamespace getVariable format ["WF_%1_GROUPS_%2", _side, _x];
	if (!isNil '_get') then {
	    _contents pushBack (_get # floor(random count _get));
	};
} forEach _squadTypes;

_contents