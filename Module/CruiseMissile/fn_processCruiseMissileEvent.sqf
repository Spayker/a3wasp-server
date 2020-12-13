params ["_side","_base","_target","_playerTeam"];

["INFORMATION", Format ["fn_processCruiseMissileEvent.sqf: [%1] Team [%2] [%3] has called cruise missile.", str _side, _playerTeam, name (leader _playerTeam)]] Call WFCO_FNC_LogContent;