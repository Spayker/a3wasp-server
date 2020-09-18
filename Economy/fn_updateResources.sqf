private["_ii","_incomeCoef","_divisor","_logik","_income","_income_player","_income_commander","_supply","_comTeam","_paycheck"];

_ii = missionNamespace getVariable "WF_C_ECONOMY_INCOME_INTERVAL";

_incomeCoef = 1;
_divisor = 0;
_suppluy_max_limit = missionNamespace getVariable "WF_C_ECONOMY_SUPPLY_MAX_TEAM_LIMIT";

_incomeCoef = missionNamespace getVariable "WF_C_ECONOMY_INCOME_COEF";
_divisor = missionNamespace getVariable "WF_C_ECONOMY_INCOME_DIVIDED";

while {!WF_GameOver} do {
	{		
		_logik = (_x) Call WFCO_FNC_GetSideLogic;
		_income = 0; // declares money
		_income_player = 0; // declares money income for a player
		_income_commander = 0; // declares money income for a commander
		_supply = 0; // declares supplies

		_supply =  [_x, false] Call WFCO_FNC_GetTownsSupply;

		if(_supply  < _suppluy_max_limit) then {

			_income = [_x, true] Call WFCO_FNC_GetTownsSupply;
			_team_count = (_logik getVariable "wf_teams_count");
			_commanderPercent = missionNamespace getVariable "wf_commander_percent";

			_income_player = round(_income + ((_income / 100) * (100 - _commanderPercent)));
			_income_commander = round(((_income * _incomeCoef) / 100) * _commanderPercent);			
			
			if (_income > 0) then {
				[_x, _supply] Call WFCO_FNC_ChangeSideSupply;

				_comTeam = (_x) Call WFCO_FNC_GetCommanderTeam;
				if (isNull _comTeam) then {_comTeam = grpNull};
				{
					if !(isNil '_x') then {
					    _teamGroup = _x;
						if(isPlayer (leader _teamGroup))then{
						    _paycheck = if (_comTeam != _teamGroup) then {_income_player} else {_income_commander};
							if (_paycheck != 0) then {[_teamGroup, _paycheck] call WFCO_FNC_ChangeTeamFunds}
						}
					}
				} forEach (_logik getVariable "wf_teams")
			}
		}
	} forEach WF_PRESENTSIDES;
	sleep _ii
}