params["_side", "_structureType", "_pos", "_dir", ["_playerUID", ""]];
private ['_index','_script','_structure'];

_index = (missionNamespace getVariable Format ["WF_%1STRUCTURENAMES",str _side]) find _structureType;
if (_index != -1) then {
	_script = (missionNamespace getVariable Format ["WF_%1STRUCTURESCRIPTS",str _side]) # _index;
	switch(_script)do{
	    case "HQSite": {[_structureType,_side,_pos,_dir,_index] spawn WFSE_fnc_HQSite;};
	    case "MediumSite": {[_structureType,_side,_pos,_dir,_index,_playerUID] spawn WFSE_fnc_MediumSite;};
	    case "SmallSite": {[_structureType,_side,_pos,_dir,_index,_playerUID] spawn WFSE_fnc_SmallSite;};
	};
};