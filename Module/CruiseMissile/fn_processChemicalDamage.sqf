params ["_dropPosition"];

//--- Chemical post effect
_radiusZone 	= 100;
_chemicalDamage = 0.03;
_rad_prot_mask_obj	= [''];

_velocityFog = [random 3, random 3, -0.2]; // fog spreading
_colorFog = [0.5, 1.7, 0.2]; // fog color
_alphaFog = 0.02+random 0.2; // fog transparency
_fog = "#particlesource" createVehicleLocal _dropPosition;
_fog setParticleParams [["\A3\Data_F\ParticleEffects\Universal\universal.p3d" , 16, 12, 13, 0], "", "Billboard", 1, 10, [0, 0, -6], _velocityFog, 1, 1.275, 1, 0,[14,10], [_colorFog + [0], _colorFog + [_alphaFog], _colorFog  + [0]], [1000], 1, 0, "", "", _radiusZone];
_fog setParticleRandom [3, [55, 55, 0.2], [0, 0, -0.1], 2, 0.45, [0, 0, 0, 0.1], 0, 0];
_fog setParticleCircle [0.001, [0, 0, -0.12]];
_fog setDropInterval 0.01;

_timeMissileStriked = time;

_unitIsWeared = false;
while {time - _timeMissileStriked < 300} do {
    {
        _unit = _x;
        _currentDamage = getdammage _unit;

        _unitIsWeared = false;
        _isUnitInLightVehicle = false;
        _veh = vehicle _unit;

        if(_veh != _unit) then {
            if (_veh iskindof "tank" || _veh iskindof "apc" || _veh iskindof "plane"|| _veh iskindof "Helicopter") then {
                _unitIsWeared = true;
            } else {
                _isUnitInLightVehicle = true;
            }
        };

        if !(_unitIsWeared) then {
            if ((goggles _unit) in WF_C_GAS_MASKS) then {
                _unitIsWeared = true
            } else {
                _unitIsWeared = false
            }
        };

        if((_unit distance _dropPosition) < _radiusZone) then {

            if (_unitIsWeared) then {
                sleep (1.2 + random 1)
            } else {
                _unitIsWeared = false;
                0 = ["DynamicBlur", 400, [1]] spawn {
                    params ["_name", "_priority", "_effect", "_handle"];
                    while {
                        _handle = ppEffectCreate [_name, _priority];
                        _handle < 0
                    } do {
                        _priority = _priority + 1;
                        sleep 0.01;
                    };
                    _handle ppEffectEnable true;
                    _handle ppEffectAdjust _effect;
                    _handle ppEffectCommit 1;
                    waitUntil {ppEffectCommitted _handle};
                    uiSleep 1;
                    _handle ppEffectAdjust [0];
                    _handle ppEffectCommit 1;
                    uiSleep 2;
                    _handle ppEffectEnable false;
                    ppEffectDestroy _handle;
                };

                _noise_rad = ppEffectCreate ["FilmGrain", 2000];
                _noise_rad ppEffectEnable true;
                _noise_rad ppEffectAdjust[0.1,0.1,0.3+random 0.3,0.1+ random 0.3,0.1+ random 0.3,false];
                _noise_rad ppEffectCommit 0;
                enableCamShake true;
                _shake_b = linearConversion [0.1, 1,(getdammage _unit), 0, 1, true];
                addCamShake [_shake_b, 3, 17];
                _afect = ["NoSound","cough_1","NoSound","NoSound","cough","NoSound","NoSound","NoSound","cough_2","NoSound","NoSound","NoSound","NoSound","cough_1","NoSound","NoSound","NoSound","NoSound","NoSound","cough_2","NoSound","NoSound","NoSound"] call BIS_fnc_selectRandom;
                _currentDamage= _currentDamage + _chemicalDamage;
                _unit setdammage _currentDamage;
                if (_isUnitInLightVehicle) then {
                    {
                        (_x) setdammage _currentDamage
                    } foreach (crew (vehicle _unit))
                };

                _amplificat_effect = linearConversion [0, 1,(getdammage _unit), 2, 0.1, true];
                sleep _amplificat_effect;
                _noise_rad ppEffectEnable false
            }
        }
    } forEach (_dropPosition nearEntities [["Man", "Motorcycle", "Car", "Tank", "Apc", "Plane", "Helicopter", "StaticWeapon"], _radiusZone]);
    sleep 5
};

deleteVehicle _fog