params ["_vehicle", "_player", "_price"];
private ["_hostUID", "_playerUID", "_area", "_get"];

_hostUID = _vehicle getVariable ["playerUID", "-1"];
_playerUID = getPlayerUID _player;

if(_hostUID == _playerUID) then {
    _vehicle setVariable ['sold',true];
    round(_price/2.5) remoteExecCall ["WFCL_FNC_ChangePlayerFunds", owner _player];

    _area = [getPos (_vehicle),((side _player) call WFCO_FNC_GetSideLogic) getVariable "wf_basearea"] call WFCO_FNC_GetClosestEntity2;

    if(_vehicle isKindOf "staticWeapon") then {
        _get = _area getVariable "availStaticDefense";
    if(!isNil "_get") then {
            deleteVehicle _vehicle;
            if (!isNull _area && _get < missionNamespace getVariable "WF_C_BASE_DEFENSE_MAX") then {
                _area setVariable ['availStaticDefense', _get +1];
                (parseText format ["Available Defenses: " +"<t color='#00FF00'>"+" %1"+"</t>",
                    _area getVariable 'availStaticDefense']) remoteExecCall ["hintSilent", owner _player]
            }
        }
    } else {
        _get = _area getVariable 'avail';
        if(!isNil "_get") then {
            if (!isNull _area && _get < missionNamespace getVariable "WF_C_BASE_AV_FORTIFICATIONS") then {
                _area setVariable ['avail', _get +1];
                (parseText format ["Available Fortfications: " +"<t color='#00FF00'>"+" %1"+"</t>",
                    _area getVariable 'avail']) remoteExecCall ["hintSilent", owner _player]
            }
        }
    };

    deleteVehicle _vehicle;
};