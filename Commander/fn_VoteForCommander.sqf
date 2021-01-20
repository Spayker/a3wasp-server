/*
	Trigger a commander's vote.
	 Parameters:
		- Side.
*/

private ["_logic", "_side", "_voteTime", "_oldCommander", "_highest", "_highestUID", "_vote", "_votes", "_votesValues",
"_voteIndex", "_electResults"];

_side = _this;
_voteTime = (missionNamespace getVariable 'WF_C_GAMEPLAY_VOTE_TIME');
_logic = _side call WFCO_FNC_GetSideLogic;

//--- Vote countdown.
while {_voteTime > -1} do {
    _voteTime = _voteTime - 0.25;
    _logic setVariable ["wf_votetime", _voteTime, true];

    _votes = [];
    _votesValues = [];

    //--Compute votes--
    {
        _voter = _x # 0;
        _vote = missionNamespace getVariable [format["WF_VOTER_%1_%2", _side, _voter], ""];
        _voteIndex = _votes find _vote;
        if(_voteIndex > -1) then {
            _votesValues set [_voteIndex, (_votesValues # _voteIndex) + 1];
        } else {
            _votes pushBack _vote;
            _votesValues pushBack 1;
        };
    } forEach (missionNamespace getVariable [format["WF_PLAYERS_%1", _side], []]);

    _electResults = [];
    {
        _electResults pushBack [_x, _votesValues # _forEachIndex];
    } forEach _votes;

    [_electResults] remoteExec ["WFCL_FNC_passVoteResults", _side, true];

    sleep 0.25;
};

_commander = objNull;
_highestUID = "";
_highest = 0;

{
    if((_x # 1) > _highest) then {
        _highestUID = _x # 0;
        _highest = _x # 1;
    };
} forEach _electResults;

//--Check if _highest is equal with anyone other--
{
    if((_x # 0) != _highestUID && (_x # 1) == _highest) exitWith {
       _highestUID = ""; //--Votes are divided, assign commanding to AI--
    };
} forEach _electResults;

//--Player elected--
if(_highestUID != "") then {
    {
        if(getPlayerUID _x == _highestUID) exitWith {
            _commander = _x;
        };
    } forEach allPlayers;
};

//--Store commanding time for old commander--
_oldCommander = _logic getVariable ["wf_commander", objNull];

if(!isNull _oldCommander) then {
    _oldCommander = leader _oldCommander;
    [getPlayerUID _oldCommander, name _oldCommander, _side call WFCO_FNC_GetSideID, 0,
        time - (missionNamespace getVariable [format["wf_ct_%1", getPlayerUID _oldCommander], time])] spawn WFSE_FNC_UpdatePlayingTime;
    missionNamespace setVariable [format["wf_ct_%1", getPlayerUID _oldCommander], nil];
};

//--Finally set the commander, null = ai--
_logic setVariable ["wf_commander", group _commander, true];

//--- Notify the clients.
[_commander] remoteExecCall ["WFCL_FNC_processVoteCommanderResults", _side];

//--- Process the AI Commander FSM if it's not running.
    //--Set new commander start time--
    missionNamespace setVariable [format["wf_ct_%1", getPlayerUID _commander], time];
	if (_logic getVariable "wf_aicom_running") then {_logic setVariable ["wf_aicom_running", false]};
