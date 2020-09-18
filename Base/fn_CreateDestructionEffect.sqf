params ["_object"];
private ["_position", "_ex", "_fire", "_smoke"];

_position = getPosATL _object;

_ex = createVehicle [
    "R_TBG32V_F",
    _position,
    [],
    0,
    "CAN_COLLIDE"
];
_ex setVectorDirAndUp [[0,0,1],[0,-1,0]];
_ex setVelocity [0,0,-1000];

_smoke = "#particlesource" createVehicle _position;
_smoke setParticleClass "MediumSmoke";
_smoke setParticleFire [0.3,1.0,0.1];

_fire = "#particlesource" createVehicle _position;
_fire setParticleClass "ObjectDestructionFire1Smallx";

sleep (WF_DELETE_RUINS_LAT / 1.5);

deleteVehicle _fire;
deleteVehicle _smoke;