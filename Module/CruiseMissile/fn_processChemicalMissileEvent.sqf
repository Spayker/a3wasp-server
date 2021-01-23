params ["_side","_dropPosition","_target","_playerTeam"];

["INFORMATION", Format ["fn_processChemicalMissileEvent.sqf: [%1] Team [%2] [%3] has called chemical missile.", str _side, _playerTeam, name (leader _playerTeam)]] Call WFCO_FNC_LogContent;

if (isNull _target || !alive _target) exitWith {};

_height = (getPosAtl _target) # 2;
while {alive _target} do {
    if(alive _target)then{
        _height = (getPos _target) # 2
    }
};

if (_height < 25) then {
    [_dropPosition] remoteExecCall ["WFCL_FNC_processChemicalDamage", -2, true];

    [_dropPosition] spawn {
        params ['_dropPosition'];
        _chemicalDamage = 0.06;
        _timeMissileStriked = time;
        _unitIsWeared = false;
        while {time - _timeMissileStriked < 300} do {

            _units = [];
            _units = _units + (_dropPosition nearEntities [["Man"], WF_C_CHEMICAL_DAMAGE_RADIUS]);
            _vehicles = _dropPosition nearEntities [["Motorcycle", "Car", "Ship", "StaticWeapon"], WF_C_CHEMICAL_DAMAGE_RADIUS];

            {
                _vehicle = _x;
                { _units pushBackUnique _x } forEach (crew _vehicle)
            } foreach _vehicles;

            {
                _unit = _x;
                _currentDamage = getdammage _unit;
                _unitIsWeared = false;
                _isUnitInLightVehicle = false;

                if !(_unitIsWeared) then {
                    if ((goggles _unit) in WF_C_GAS_MASKS) then {
                        _unitIsWeared = true
                    } else {
                        _unitIsWeared = false
                    }
                };

                if (_unitIsWeared) then {
                    sleep (1.2 + random 1)
                } else {
                    _unitIsWeared = false;
                    _currentDamage= _currentDamage + _chemicalDamage;

                    if (_isUnitInLightVehicle) then {
                        {
                            (_x) setdammage _currentDamage
                        } foreach (crew (vehicle _unit))
                    } else {
                        _unit setdammage _currentDamage
                    };

                    _amplificat_effect = linearConversion [0, 1,(getdammage _unit), 2, 0.1, true];
                    sleep _amplificat_effect;
                };
            } forEach _units;
            sleep 5
        }
    }


}


