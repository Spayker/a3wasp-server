params ["_side", "_message", ["_parameters", []]];
private ["_logik","_receiver","_speaker","_topicside"];

_logik = (_side) Call WFCO_FNC_GetSideLogic;

_speaker = _logik getVariable "wf_radio_hq";
_receiver = _logik getVariable "wf_radio_hq_rec";
_topicSide = _logik getVariable "wf_radio_hq_id";
_announcerType = _logik getVariable "wf_radio_hq_type";

if(isNil '_speaker') then {
    _speaker = (createGroup sideLogic) createUnit ["Logic",[0,0,0],[],0,"NONE"];
    [_speaker] joinSilent (createGroup _side);
    _logik setVariable ["wf_radio_hq", _speaker, true];
};

switch (true) do {
	case (_message in ["Lost","Captured","HostilesDetectedNear"]): {
		_locRaw = "";
		_rlName = _parameters getVariable ["name", "Town"];
		
		switch (_message) do {
			case ("Lost"): {
				_locRaw = format["%1 LOST!", _rlName];
			};
			case ("Captured"): {
				_locRaw = format[localize "STR_WF_CHAT_Town_Captured", _rlName, _side];
			};
			case ("HostilesDetectedNear"): {
				_locRaw = format[localize "STR_WF_CHAT_Town_Hostiles", _rlName];
			};
		};		
		
		if(_message == "HostilesDetectedNear") then {
			_speaker kbTell [_receiver, _topicSide, _message,
						["1", "", "", [format["\sounds\%1\%3.%2", _announcerType # 0, _announcerType # 1, _message]]],
						["2", "", _locRaw, [format["\sounds\%1\%3.%2", _announcerType # 0, _announcerType # 1, "town"]]],
						["3", "", _rlName, []],
						 true];
		} else {
			_speaker kbTell [_receiver, _topicSide, _message,
						["1", "", _locRaw, [format["\sounds\%1\%3.%2", _announcerType # 0, _announcerType # 1, "town"]]],
						["2", "", _rlName, []],
						["3", "", "", [format["\sounds\%1\%3.%2", _announcerType # 0, _announcerType # 1, _message]]], true];			
		};
	};
	case (_message in ["CapturedNear","LostAt"]): {
		_locRaw = "";
		_rlName = (_parameters # 1) getVariable ["name", "Town"];
		
		switch (_message) do {
			case ("CapturedNear"):{
				_locRaw = format[localize "STR_WF_CHAT_Camp_Captured", _rlName];
			};
			case ("LostAt"):{
				_locRaw = format[localize "STR_WF_CHAT_Camp_Captured_Enemy", _rlName];
			};
		};		
		
		_speaker kbTell [_receiver, _topicSide, _message,
						["1", "", _locRaw, [format["\sounds\%1\%3.%2", _announcerType # 0, _announcerType # 1, "strongpoint"]]],
						["2", "", "", [format["\sounds\%1\%3.%2", _announcerType # 0, _announcerType # 1, _message]]],
						["3", "", "",[format["\sounds\%1\%3.%2", _announcerType # 0, _announcerType # 1, "town"]]],
						["4", "", "",[]], true];		
	};
	case (_message in ["Constructed","Destroyed","Deployed","Mobilized","IsUnderAttack"]): {
		_localizedString = "";
		_value = "";
		if ((_parameters # 0 ) == "Base") then {
			switch ((_parameters # 1) getVariable "wf_structure_type") do {
				case "Headquarters": { _localizedString = localize "STRHeadquarters";_value = "Headquarters"};
				case "Barracks": { _localizedString = localize "strwfbarracks";_value = "Barracks"};
				case "Light": { _localizedString = localize "STRLightVehicleSupply";_value = "LightVehicleSupply"; if((_announcerType # 1) == "ogg") then { _value = format["%1Point", _value]; }; };
				case "CommandCenter": {
					_localizedString = localize "STR_WF_CommandCenter";
					_value = "UAVTerminal";
				};
				case "Heavy": { _localizedString = localize "STRHeavyVehicleSupply";_value = "HeavyVehicleSupply"; if((_announcerType # 1) == "ogg") then { _value = format["%1Point", _value]; }; };
				case "Aircraft": { _localizedString = localize "STRHelipad";_value = "Helipad"};
				case "ServicePoint": { _localizedString = localize "STRServicePoint";_value = "ServicePoint"};
				case "AARadar": { _localizedString = localize "STRAntiAirRadar";_value = "AntiAirRadar"};
				case "ArtyRadar": { _localizedString = localize "STRArtilleryRadar";_value = "ArtilleryRadar"};
			};
			if!(isNil '_speaker') then {			
			     _speaker kbTell [_receiver, _topicSide, "simpletwo",["1","",_localizedString,[format ["\sounds\%1\%3.%2", _announcerType # 0, _announcerType # 1, _value]]],
			     ["2","",localize (format["STR%1", _message]),[format ["\sounds\%1\%3.%2", _announcerType # 0, _announcerType # 1, _message]]], true];
		        }
                 } else {
			_localizedString = (_parameters # 1) getVariable "name";
			_dub = (_parameters # 1) getVariable "wf_town_dubbing";
			if (_dub != "Town") then {if (count(getArray(configFile >> (missionNamespace getVariable Format ["WF_%1_RadioAnnouncers_Config", _side]) >> "Words" >> _dub)) == 0) then {_dub = "Town"}};
			_value = _dub;
			
			_speaker kbTell [_receiver, _topicSide, "simplethree",
			["1","",localize "STR_Town",[format ["\sounds\%1\%3.%2", _announcerType # 0, _announcerType # 1, "Town"]]],
			["2","",_localizedString,[]],
			["3","",localize (format["STR%1", _message]),[format ["\sounds\%1\%3.%2", _announcerType # 0, _announcerType # 1, _message]]], true];			
		};
	};
	case (_message in ["VotingForNewCommander","NewIntelAvailable","MMissionFailed","NewMissionAvailable"]): {
		_messageF = _message;
		if(_message == "VotingForNewCommander" && (_announcerType # 1) == "ogg") then { _messageF = "VotingForANewCommander"; };
		_speaker kbTell [_receiver, _topicSide, _message, ["1", "", "", [format["\sounds\%1\%3.%2", _announcerType # 0, _announcerType # 1, _messageF]]], true];
	};
	case (_message in ["MMissionComplete","ExtractionTeam","ExtractionTeamCancel"]): {
		_speaker kbTell [_receiver, _topicSide, _message,["1","",_parameters # 0,[_parameters # 1]],true];
	};	
	case (_message == "CommonText"): {
		_speaker kbTell [_receiver, _topicSide, _message,["1", "", _parameters # 0,[_parameters # 1]],true];
	};
};