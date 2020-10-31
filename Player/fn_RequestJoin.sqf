params ["_player", "_side"];
private ["_canJoin","_get","_name","_sideOrigin","_uid","_skip","_otherside","_sidepros","_othersidepros","_playersinside","_playersinotherside"];

_name = name _player;

_skip = 0;
_otherside = west;
_playersinside = 0;
_playersinotherside = 0;
_sidepros = 0;
_othersidepros = 0;

_uid = getPlayerUID(_player);
_canJoin = true;

if (_side == west) then {_otherside = east;};

_playersinside = ({side _x == _side && isPlayer _x} count (playableUnits + switchableUnits));
_playersinotherside = ({side _x == _otherside && isPlayer _x} count (playableUnits + switchableUnits));
_get = missionNamespace getVariable Format["WF_JIP_USER%1",_uid];

if !(isNil '_get') then { //--- Retrieve JIP Information if there's any.
	_skip = _get # 4;
	_sideOrigin = _get # 2; //--- Get the original side.

	if (_skip == 0) then {
		_players_difference =  _playersinside - _playersinotherside;

		if(_players_difference > 2 && WF_C_GAMEPLAY_TEAMSTACKING_CHECK > 0) then {
	        _canJoin = false;
			missionNamespace setVariable [format["WF_JIP_USER%1",_uid], nil];
			['Teamstack',_name,_uid,_side] remoteExecCall ["WFCL_FNC_LocalizeMessage", _player];
			["INFORMATION", Format["fn_RequestJoin.sqf: Player [%1] [%2] has been sent back to the lobby for teamstacking,joined side [%3].", _name,_uid,_side]] Call WFCO_FNC_LogContent;
			[Format["Player :joystick: **%1** has been sent back to the lobby for teamstacking, joined side %2% **%3**", _name, _side Call WFCO_FNC_GetSideFLAG, _side]] Call WFDC_FNC_LogContent;
			_get set [4,0];
		};
	} else {
		if (_sideOrigin != _side) then { //--- The joined side differs from the original one.

			_canJoin = false;

			['Teamswap',_name,_uid,_sideOrigin,_side] remoteExecCall ["WFCL_FNC_LocalizeMessage"];

            _canJoinText = {
                14000 cutText ["<t size='3'>"+(localize 'STR_WF_Teamswap')+"</t>", "PLAIN", 20, true, true];
            };
            [_canJoinText] remoteExec ["call", _player];

			if (canSuspend) then {
				sleep 12;
			};

			["INFORMATION", Format["fn_RequestJoin.sqf: Player [%1] [%2] has been sent back to the lobby for teamswapping, original side [%3], joined side [%4].", _name,_uid,_sideOrigin,_side]] Call WFCO_FNC_LogContent;
			[Format[":arrow_right_hook: Player :joystick: **%1** has been sent back to the lobby for teamswapping :no_good: original side %4 **%2**, joined side %5 **%3** :leftwards_arrow_with_hook:", 
				_name, _sideOrigin, _side, _sideOrigin Call WFCO_FNC_GetSideFLAG, _side Call WFCO_FNC_GetSideFLAG]] Call WFDC_FNC_LogContent;
		} else {
			_canJoin = true;
		};
	};

} else {
	["WARNING", Format["fn_RequestJoin.sqf: Unable to find JIP information for player [%1] [%2].", _name, _uid]] Call WFCO_FNC_LogContent;
};

["INFORMATION", Format["fn_RequestJoin.sqf: Player [%1] [%2] can join? [%3].", _name, _uid, _canJoin]] Call WFCO_FNC_LogContent;

missionNamespace setVariable[format["wf_cj_%1", _uid], _canJoin];
[_canJoin] remoteExecCall ["WFCL_FNC_updateCanJoinFlag", _player];