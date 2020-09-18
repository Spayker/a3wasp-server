//------------------fn_updatePlayersList------------------------------------------------------------------------------//
//	Updating west and east players list for global                                                                    //
//------------------fn_updatePlayersList------------------------------------------------------------------------------//
params ["_action", "_uid", ["_name", ""], ["_side", sideUnknown]];
private ["_players"];

//--Player connected--
if(_action == 0) then {

    if(isNil "_uid") then {
        {
            _side = side _x;
    _players = missionNamespace getVariable [format["WF_PLAYERS_%1", _side], []];
            _uid = getPlayerUID _x;
            _name = name _x;
    _players pushBack [_uid, _name, _side];
            missionNamespace setVariable [format["WF_PLAYERS_%1", _side], _players, true]
        } forEach (allPlayers - entities "HeadlessClient_F");
    } else {
        _players = missionNamespace getVariable [format["WF_PLAYERS_%1", _side], []];
        _players pushBack [_uid, _name, _side];
        missionNamespace setVariable [format["WF_PLAYERS_%1", _side], _players, true]
    }
};

//--Player disconnected--
if(_action == 1) then {
    _players = (missionNamespace getVariable ["WF_PLAYERS_WEST", []]) +
                    (missionNamespace getVariable ["WF_PLAYERS_EAST", []]);
    //--Determine side of disconnected player--
    {
        if(_x # 0 == _uid) exitWith {
            _side = _x # 2;
        };
    } forEach _players;

    if(_side != sideUnknown) then {
        _players = missionNamespace getVariable [format["WF_PLAYERS_%1", _side], []];
        //--Delete player from global array--
        _players deleteAt (_players findIf {(_x # 0) == _uid});
        missionNamespace setVariable [format["WF_PLAYERS_%1", _side], _players, true];
    };
};