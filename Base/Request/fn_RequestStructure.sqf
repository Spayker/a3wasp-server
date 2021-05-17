params["_side", "_structureType", "_pos", "_dir", ["_playerUID", ""]];
private ['_index','_script','_structure','_hc'];

_index = (missionNamespace getVariable Format ["WF_%1STRUCTURENAMES",str _side]) find _structureType;
_hc = missionNamespace getVariable ["WF_HEADLESSCLIENT_ID", 0];
if (_index != -1) then {

    [_pos] call WFCO_fnc_cleanTerrainObjects;
	_script = (missionNamespace getVariable Format ["WF_%1STRUCTURESCRIPTS",str _side]) # _index;
	switch(_script)do{
	    case "HQSite": { [_structureType,_side,_pos,_dir,_index] remoteExecCall ["WFHC_FNC_HQSite", _hc] };
	    case "MediumSite": { [_structureType,_side,_pos,_dir,_index,_playerUID] remoteExecCall ["WFHC_FNC_MediumSite", _hc] };
	    case "SmallSite": {[_structureType,_side,_pos,_dir,_index,_playerUID] remoteExecCall ["WFHC_FNC_SmallSite", _hc]}
	}
}