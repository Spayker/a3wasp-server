private["_args","_properties","_team"];

_args = _this;
_team = _args select 0;

//--- One team.
if (_team isEqualType []) then {
	{
		_x setBehaviour (_args # 1);
		_x setCombatMode (_args # 2);
		_x setFormation (_args # 3);
		_x setSpeedMode (_args # 4);
		["INFORMATION", Format ["RequestTeamUpdate.sqf: Team [%1] properties were updated.", _x]] Call WFCO_FNC_LogContent;
	} forEach _team;
};

//--- The whole team.
if (_team isEqualType WEST) then {
	{
		_x setBehaviour (_args # 1);
		_x setCombatMode (_args # 2);
		_x setFormation (_args # 3);
		_x setSpeedMode (_args # 4);
	} forEach (missionNamespace getVariable Format["WF_%1TEAMS",str _team]);
	["INFORMATION", Format ["RequestTeamUpdate.sqf: [%1] Teams properties were updated.", _team]] Call WFCO_FNC_LogContent;
};