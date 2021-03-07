/* Structures */
missionNamespace setVariable ['WF_NEURODEF_BARRACKS_WALLS',[
	['Land_HBarrier_large',[8,0,0],90],
	['Land_HBarrier_large',[8,10,0],90],
	['Land_HBarrier_large',[8,-7.5,0],90],
	['Land_HBarrier_large',[5,-11,0],180],
	['Land_HBarrier_large',[0.5,-11,0],180],
	['Land_HBarrier_large',[-6,-11,0],180],
	['Land_HBarrier_large',[-9.5,-7.5,0],90],
	['Land_HBarrier_large',[-9.5,2.5,0],90],
	['Land_HBarrier_large',[5,13,0],180],
	['Land_HBarrier_large',[0.5,13,0],180],
	['Land_HBarrier_large',[-6,13,0],180],
	['Land_HBarrier_large',[-9.5,9.5,0],90]
]];

missionNamespace setVariable ['WF_NEURODEF_LIGHT_WALLS',[
	['Land_HBarrier_large',[10,-1,0],90],
	['Land_HBarrier_large',[10,9,0],-90],
	['Land_HBarrier_large',[10,-8.5,0],90],
	['Land_HBarrier_large',[7,-12,0],180],
	['Land_HBarrier_large',[0,-12,0],180],
	['Land_HBarrier_large',[-7,-12,0],180],
	['Land_HBarrier_large',[7,12,0],180],
	['Land_HBarrier_large',[0,12,0],180],
	['Land_HBarrier_large',[-7,12,0],180],
	['Land_HBarrier_large',[-11,-9,0],90],
	['Land_HBarrier_large',[-11,-1.5,0],90],
	['Land_HBarrier_large',[-11,6,0],90],
	['Land_HBarrier_large',[-11,9,0],90]
]];

missionNamespace setVariable ['WF_NEURODEF_COMMANDCENTER_WALLS',[
	['Land_HBarrier_large',[4,-3.5,0],90],
	['Land_HBarrier_large',[4,4,0],90],
	['Land_HBarrier_large',[1,7.5,0],180],
	['Land_HBarrier_large',[-2.5,7.5,0],180],
	['Land_HBarrier_large',[-5.5,4,0],90],
	['Land_HBarrier_large',[-5.5,-3.5,0],90],
	['Land_HBarrier5',[4,-6.5,0],180]
]];

missionNamespace setVariable ['WF_NEURODEF_SERVICEPOINT_WALLS',[
	['Land_HBarrier_large',[4,-3.5,0],90],
	['Land_HBarrier_large',[4,4,0],90],
	['Land_HBarrier_large',[1,7.5,0],180],
	['Land_HBarrier_large',[-2.5,7.5,0],180],
	['Land_HBarrier_large',[-5.5,4,0],90],
	['Land_HBarrier_large',[-5.5,-3.5,0],90],
	['Land_HBarrier5',[4,-6.5,0],180]
]];

missionNamespace setVariable ['WF_NEURODEF_HEAVY_WALLS',[
	['Land_HBarrier_large',[14,-1,0],90],
	['Land_HBarrier_large',[14,9,0],-90],
	['Land_HBarrier_large',[14,-8.5,0],90],
	['Land_HBarrier_large',[14,-11,0],90],
	['Land_HBarrier_large',[11,-14.5,0],180],
	['Land_HBarrier_large',[4.5,-14.5,0],180],
	['Land_HBarrier_large',[-3,-14.5,0],180],
	['Land_HBarrier_large',[-10.5,-14.5,0],180],
	['Land_HBarrier_large',[-14,-11,0],90],
	['Land_HBarrier_large',[-14,-3.5,0],90],
	['Land_HBarrier_large',[-14,4,0],90],
	['Land_HBarrier_large',[-14,9.5,0],90],
	['Land_HBarrier_large',[11,13,0],180],
	['Land_HBarrier_large',[3.5,13,0],180],
	['Land_HBarrier_large',[-4,13,0],180],
	['Land_HBarrier_large',[-11,13,0],-180]
]];

missionNamespace setVariable ['WF_NEURODEF_AIRCRAFT_WALLS',[
	['Land_HBarrier_large',[10,-1,0],90],
	['Land_HBarrier_large',[10,9,0],-90],
	['Land_HBarrier_large',[10,-8.5,0],90],
	['Land_HBarrier_large',[7,-12,0],180],
	['Land_HBarrier_large',[0,-12,0],180],
	['Land_HBarrier_large',[-7,-12,0],180],
	['Land_HBarrier_large',[7,12,0],180],
	['Land_HBarrier_large',[0,12,0],180],
	['Land_HBarrier_large',[-7,12,0],180],
	['Land_HBarrier_large',[-11,-9,0],90],
	['Land_HBarrier_large',[-11,-1.5,0],90],
	['Land_HBarrier_large',[-11,6,0],90],
	['Land_HBarrier_large',[-11,9,0],90]
]];

missionNamespace setVariable ['WF_NEURODEF_MG',[
	['Land_fortified_nest_small_EP1',[0.25,0,0],180],
	['Land_fort_bagfence_corner',[-1,-3,0],0]
]];

missionNamespace setVariable ['WF_NEURODEF_AAPOD',[
	['Land_fort_bagfence_round',[0,2,0],0],
	['Land_fort_bagfence_long',[-2.8,-1.7,0],90],
	['Land_fort_bagfence_long',[2.8,-1.7,0],90],
	['Land_fort_bagfence_long',[1.4,-5.5,0],0],
	['Land_fort_bagfence_corner',[-1.8,-5,0],0]
]];

if (WF_Camo) then {
missionNamespace setVariable ['WF_NEURODEF_EAST_BASE',[
    ["RU_WarfareBLightFactory",[9.57227,12.7861,-0.600006],90],
    ["RU_WarfareBUAVterminal",[-8.06445,15.25,0],0],
    ["RU_WarfareBBarracks",[8.91406,-14.2578,-0.600006],0],
    ["BTR90_HQ_unfolded",[-11.7051,-14.7051,0],90],
    ["Base_WarfareBBarrier10xTall",[20.6318,6.98145,0],90],
    ["Base_WarfareBBarrier10xTall",[-23.4258,-7.65527,0],90],
    ["Base_WarfareBBarrier10xTall",[-0.323242,-30.1289,0],0],
    ["Base_WarfareBBarrier10xTall",[-0.0878906,29.1484,0],0],
    ["Land_HBarrierTower_F",[17.2803,24.665,0],180],
    ["Land_HBarrierTower_F",[16.2432,-25.417,0],90],
    ["Base_WarfareBBarrier10xTall",[20.6768,-22.3057,0],90],
    ["Base_WarfareBBarrier10xTall",[20.6768,22.2783,0],90],
    ["Land_HBarrierTower_F",[-19.0898,-24.624,0],0],
    ["Land_HBarrierTower_F",[-17.3887,26.0361,0],270],
    ["Base_WarfareBBarrier10xTall",[-23.4258,22.4785,0],90],
    ["Base_WarfareBBarrier10xTall",[-23.4258,-22.6533,0],90],
    ["Base_WarfareBBarrier10xTall",[14.6885,-30.0479,0],0],
    ["Base_WarfareBBarrier10xTall",[14.6885,29.0986,0],0],
    ["Base_WarfareBBarrier10xTall",[-15.6221,-30.1768,0],0],
    ["Base_WarfareBBarrier10xTall",[-15.415,29.1445,0],0],
    ["Land_JumpTarget_F",[-29.957,-0.140625,0],0],
    ["Land_JumpTarget_F",[-29.957,16.9697,0],0],
    ["Land_JumpTarget_F",[-29.957,-17.4082,0],0]
]];

missionNamespace setVariable ['WF_NEURODEF_WEST_BASE',[
	["USMC_WarfareBLightFactory",[9.57227,12.7861,-0.600006],90],
    ["USMC_WarfareBUAVterminal",[-8.06445,15.25,0],0],
    ["USMC_WarfareBBarracks",[8.91406,-14.2578,-0.600006],0],
    ["LAV25_HQ_unfolded",[-11.7051,-14.7051,0],90],
    ["Base_WarfareBBarrier10xTall",[20.6318,6.98145,0],90],
    ["Base_WarfareBBarrier10xTall",[-23.4258,-7.65527,0],90],
    ["Base_WarfareBBarrier10xTall",[-0.323242,-30.1289,0],0],
    ["Base_WarfareBBarrier10xTall",[-0.0878906,29.1484,0],0],
    ["Land_HBarrierTower_F",[17.2803,24.665,0],180],
    ["Land_HBarrierTower_F",[16.2432,-25.417,0],90],
    ["Base_WarfareBBarrier10xTall",[20.6768,-22.3057,0],90],
    ["Base_WarfareBBarrier10xTall",[20.6768,22.2783,0],90],
    ["Land_HBarrierTower_F",[-19.0898,-24.624,0],0],
    ["Land_HBarrierTower_F",[-17.3887,26.0361,0],270],
    ["Base_WarfareBBarrier10xTall",[-23.4258,22.4785,0],90],
    ["Base_WarfareBBarrier10xTall",[-23.4258,-22.6533,0],90],
    ["Base_WarfareBBarrier10xTall",[14.6885,-30.0479,0],0],
    ["Base_WarfareBBarrier10xTall",[14.6885,29.0986,0],0],
    ["Base_WarfareBBarrier10xTall",[-15.6221,-30.1768,0],0],
    ["Base_WarfareBBarrier10xTall",[-15.415,29.1445,0],0],
    ["Land_JumpTarget_F",[-29.957,-0.140625,0],0],
    ["Land_JumpTarget_F",[-29.957,16.9697,0],0],
    ["Land_JumpTarget_F",[-29.957,-17.4082,0],0]
    ]]
} else {
    missionNamespace setVariable ['WF_NEURODEF_EAST_BASE',[
        ["TK_WarfareBLightFactory_base_EP1",[9.57227,12.7861,-0.600006],90],
        ["TK_WarfareBUAVterminal_Base_EP1",[-8.06445,15.25,0],0],
        ["TK_WarfareBBarracks_Base_EP1",[8.91406,-14.2578,-0.600006],0],
        ["BTR90_HQ_unfolded",[-11.7051,-14.7051,0],90],
        ["Base_WarfareBBarrier10xTall",[20.6318,6.98145,0],90],
        ["Base_WarfareBBarrier10xTall",[-23.4258,-7.65527,0],90],
        ["Base_WarfareBBarrier10xTall",[-0.323242,-30.1289,0],0],
        ["Base_WarfareBBarrier10xTall",[-0.0878906,29.1484,0],0],
        ["Land_HBarrierTower_F",[17.2803,24.665,0],180],
        ["Land_HBarrierTower_F",[16.2432,-25.417,0],90],
        ["Base_WarfareBBarrier10xTall",[20.6768,-22.3057,0],90],
        ["Base_WarfareBBarrier10xTall",[20.6768,22.2783,0],90],
        ["Land_HBarrierTower_F",[-19.0898,-24.624,0],0],
        ["Land_HBarrierTower_F",[-17.3887,26.0361,0],270],
        ["Base_WarfareBBarrier10xTall",[-23.4258,22.4785,0],90],
        ["Base_WarfareBBarrier10xTall",[-23.4258,-22.6533,0],90],
        ["Base_WarfareBBarrier10xTall",[14.6885,-30.0479,0],0],
        ["Base_WarfareBBarrier10xTall",[14.6885,29.0986,0],0],
        ["Base_WarfareBBarrier10xTall",[-15.6221,-30.1768,0],0],
        ["Base_WarfareBBarrier10xTall",[-15.415,29.1445,0],0],
        ["Land_JumpTarget_F",[-29.957,-0.140625,0],0],
        ["Land_JumpTarget_F",[-29.957,16.9697,0],0],
        ["Land_JumpTarget_F",[-29.957,-17.4082,0],0]
]];

    missionNamespace setVariable ['WF_NEURODEF_WEST_BASE',[
        ["US_WarfareBLightFactory_base_EP1",[9.57227,12.7861,-0.600006],90],
        ["US_WarfareBUAVterminal_Base_EP1",[-8.06445,15.25,0],0],
        ["US_WarfareBBarracks_Base_EP1",[8.91406,-14.2578,-0.600006],0],
        ["LAV25_HQ_unfolded",[-11.7051,-14.7051,0],90],
        ["Base_WarfareBBarrier10xTall",[20.6318,6.98145,0],90],
        ["Base_WarfareBBarrier10xTall",[-23.4258,-7.65527,0],90],
        ["Base_WarfareBBarrier10xTall",[-0.323242,-30.1289,0],0],
        ["Base_WarfareBBarrier10xTall",[-0.0878906,29.1484,0],0],
        ["Land_HBarrierTower_F",[17.2803,24.665,0],180],
        ["Land_HBarrierTower_F",[16.2432,-25.417,0],90],
        ["Base_WarfareBBarrier10xTall",[20.6768,-22.3057,0],90],
        ["Base_WarfareBBarrier10xTall",[20.6768,22.2783,0],90],
        ["Land_HBarrierTower_F",[-19.0898,-24.624,0],0],
        ["Land_HBarrierTower_F",[-17.3887,26.0361,0],270],
        ["Base_WarfareBBarrier10xTall",[-23.4258,22.4785,0],90],
        ["Base_WarfareBBarrier10xTall",[-23.4258,-22.6533,0],90],
        ["Base_WarfareBBarrier10xTall",[14.6885,-30.0479,0],0],
        ["Base_WarfareBBarrier10xTall",[14.6885,29.0986,0],0],
        ["Base_WarfareBBarrier10xTall",[-15.6221,-30.1768,0],0],
        ["Base_WarfareBBarrier10xTall",[-15.415,29.1445,0],0],
        ["Land_JumpTarget_F",[-29.957,-0.140625,0],0],
        ["Land_JumpTarget_F",[-29.957,16.9697,0],0],
        ["Land_JumpTarget_F",[-29.957,-17.4082,0],0]
    ]]
}
