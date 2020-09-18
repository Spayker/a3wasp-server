params ["_side", "_template", "_building", "_status", ["_isInfantry", false]];
private["_side", "_template", "_buildings", "_status", "_building", "_end", "_inf_group"];

_end = false;
_alives = [];
_inf_group = nil;

if(count _alives == 0) then {
	_inf_group = createGroup [_side, true];
	{
		if !(isNull _building) then {
			[_building,_x,_side,_inf_group] call WFSE_FNC_ResBuyUnit
		}
	} forEach _template
};

sleep 15;

while{!_end} do {
	_alives = (units _inf_group) Call WFCO_FNC_GetLiveUnits;
	if(count _alives > 0) then {
	    WF_Logic setVariable [_status, true];
		_end = false
	} else {
	    WF_Logic setVariable [_status, false];
		_end = true
	};

    _nearTowns = [];
    _near = [];
    _allSortedTownsByDistance = [getPosATL (leader _inf_group), towns] Call WFCO_FNC_SortByDistance;
    _prefferableTownAmount = count _allSortedTownsByDistance;
    if (_prefferableTownAmount > 4) then { _prefferableTownAmount = 3 };


    for [{_i = 0},{_i < _prefferableTownAmount},{_i = _i + 1}] do { _near pushBack (_allSortedTownsByDistance # _i) };

    if (count _near > 0) then {
        for [{_z = 0}, {_z < _prefferableTownAmount}, {_z = _z + 1}] do {
            _isInserted = false;
            while{ !_isInserted } do {
                _selectedRandomTown = selectRandom _near;
                if!(_selectedRandomTown in _nearTowns) then {
                    _nearTowns pushBack (_selectedRandomTown);
                    _isInserted = true
                }
            }
        }
    };

    [_inf_group, _nearTowns, 400, 'FILE', _isInfantry] Call WFSE_FNC_AITownPatrol;
	sleep 300
}

