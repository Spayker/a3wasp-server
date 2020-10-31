WFSE_FNC_initServer = compile preprocessFileLineNumbers "waspServer\fn_initServer.sqf";
WFSE_FNC_broadCastFPS = compile preprocessFileLineNumbers "waspServer\fn_broadCastFPS.sqf";
WFSE_FNC_createBaseComposition = compile preprocessFileLineNumbers "waspServer\Base\fn_createBaseComposition.sqf";
WFSE_FNC_createDefenseTemplate = compile preprocessFileLineNumbers "waspServer\Base\fn_createDefenseTemplate.sqf";
WFSE_FNC_createObjectsFromArray = compile preprocessFileLineNumbers "waspServer\Base\fn_createObjectsFromArray.sqf";
WFSE_FNC_processUpgrade = compile preprocessFileLineNumbers "waspServer\Base\fn_processUpgrade.sqf";
WFSE_FNC_requestUpgrade = compile preprocessFileLineNumbers "waspServer\Base\fn_requestUpgrade.sqf";
WFSE_FNC_synchronizeUpgade = compile preprocessFileLineNumbers "waspServer\Base\fn_synchronizeUpgade.sqf";
WFSE_FNC_startBaseAreaProcessing = compile preprocessFileLineNumbers "waspServer\Base\fn_startBaseAreaProcessing.sqf";
WFSE_FNC_CreateDestructionEffect = compile preprocessFileLineNumbers "waspServer\Base\fn_CreateDestructionEffect.sqf";
WFSE_FNC_startStaticDefenseProcessing = compile preprocessFileLineNumbers "waspServer\Base\fn_startStaticDefenseProcessing.sqf";
            
WFSE_FNC_createBasePatrol = compile preprocessFileLineNumbers "waspServer\Base\Ai\fn_createBasePatrol.sqf";

WFSE_FNC_hQSite = compile preprocessFileLineNumbers "waspServer\Base\Construction\fn_hQSite.sqf";
WFSE_FNC_mediumSite = compile preprocessFileLineNumbers "waspServer\Base\Construction\fn_mediumSite.sqf";
WFSE_FNC_smallSite = compile preprocessFileLineNumbers "waspServer\Base\Construction\fn_smallSite.sqf";
WFSE_FNC_stationaryDefense = compile preprocessFileLineNumbers "waspServer\Base\Construction\fn_stationaryDefense.sqf";

WFSE_FNC_buildingDamaged = compile preprocessFileLineNumbers "waspServer\Base\EventHandling\fn_buildingDamaged.sqf";
WFSE_FNC_buildingHandleDamage = compile preprocessFileLineNumbers "waspServer\Base\EventHandling\fn_buildingHandleDamage.sqf";
WFSE_FNC_buildingKilled = compile preprocessFileLineNumbers "waspServer\Base\EventHandling\fn_buildingKilled.sqf";
WFSE_FNC_handleDefense = compile preprocessFileLineNumbers "waspServer\Base\EventHandling\fn_handleDefense.sqf";
WFSE_FNC_handleBuildingRepair = compile preprocessFileLineNumbers "waspServer\Base\EventHandling\fn_handleBuildingRepair.sqf";

WFSE_FNC_mHQRepair = compile preprocessFileLineNumbers "waspServer\Base\Hq\fn_mHQRepair.sqf";
WFSE_FNC_onHQKilled = compile preprocessFileLineNumbers "waspServer\Base\Hq\fn_onHQKilled.sqf";
WFSE_FNC_requestMHQRepair = compile preprocessFileLineNumbers "waspServer\Base\Hq\fn_requestMHQRepair.sqf";

WFSE_FNC_requestAutoWallConstructinChange = compile preprocessFileLineNumbers "waspServer\Base\Request\fn_requestAutoWallConstructinChange.sqf";
WFSE_FNC_requestDefense = compile preprocessFileLineNumbers "waspServer\Base\Request\fn_requestDefense.sqf";
WFSE_FNC_requestDefenseSell = compile preprocessFileLineNumbers "waspServer\Base\Request\fn_requestDefenseSell.sqf";
WFSE_FNC_requestStructure = compile preprocessFileLineNumbers "waspServer\Base\Request\fn_requestStructure.sqf";
WFSE_FNC_RequestStructureSell = compile preprocessFileLineNumbers "waspServer\Base\Request\fn_RequestStructureSell.sqf";
            
WFSE_FNC_requestCommanderVote = compile preprocessFileLineNumbers "waspServer\Commander\fn_requestCommanderVote.sqf";
WFSE_FNC_requestNewCommander = compile preprocessFileLineNumbers "waspServer\Commander\fn_requestNewCommander.sqf";
WFSE_FNC_voteForCommander = compile preprocessFileLineNumbers "waspServer\Commander\fn_voteForCommander.sqf";
WFSE_FNC_passVote = compile preprocessFileLineNumbers "waspServer\Commander\fn_passVote.sqf";

WFSE_FNC_changeAICommanderFunds = compile preprocessFileLineNumbers "waspServer\Economy\fn_changeAICommanderFunds.sqf";
WFSE_FNC_getAICommanderFunds = compile preprocessFileLineNumbers "waspServer\Economy\fn_getAICommanderFunds.sqf";
WFSE_FNC_updateResources = compile preprocessFileLineNumbers "waspServer\Economy\fn_updateResources.sqf";
WFSE_FNC_buyGroup = compile preprocessFileLineNumbers "waspServer\Economy\fn_buyGroup.sqf";

WFSE_FNC_onPlayerConnected = compile preprocessFileLineNumbers "waspServer\Player\fn_onPlayerConnected.sqf";
WFSE_FNC_onPlayerDisconnected = compile preprocessFileLineNumbers "waspServer\Player\fn_onPlayerDisconnected.sqf";
WFSE_FNC_requestChangeScore = compile preprocessFileLineNumbers "waspServer\Player\fn_requestChangeScore.sqf";
WFSE_FNC_requestJoin = compile preprocessFileLineNumbers "waspServer\Player\fn_requestJoin.sqf";
WFSE_FNC_updateTeamLeader = compile preprocessFileLineNumbers "waspServer\Player\fn_updateTeamLeader.sqf";
WFSE_FNC_sideMessage = compile preprocessFileLineNumbers "waspServer\Player\fn_sideMessage.sqf";
WFSE_FNC_updatePlayersList = compile preprocessFileLineNumbers "waspServer\Player\fn_updatePlayersList.sqf";

WFSE_FNC_canUpdateTeam = compile preprocessFileLineNumbers "waspServer\Team\fn_canUpdateTeam.sqf";
WFSE_FNC_requestTeamUpdate = compile preprocessFileLineNumbers "waspServer\Team\fn_requestTeamUpdate.sqf";
WFSE_FNC_updateTeam = compile preprocessFileLineNumbers "waspServer\Team\fn_updateTeam.sqf";

WFSE_FNC_markTownInactive = compile preprocessFileLineNumbers "waspServer\Warfare\Town\fn_markTownInactive.sqf";
WFSE_FNC_startTownProcessing = compile preprocessFileLineNumbers "waspServer\Warfare\Town\fn_startTownProcessing.sqf";
WFSE_FNC_initTowns = compile preprocessFileLineNumbers "waspServer\Warfare\Town\fn_initTowns.sqf";
WFSE_FNC_SaveTownSurvivedGroups = compile preprocessFileLineNumbers "waspServer\Warfare\Town\fn_SaveTownSurvivedGroups.sqf";

WFSE_FNC_getTownGroups = compile preprocessFileLineNumbers "waspServer\Warfare\Town\Ai\fn_getTownGroups.sqf";
WFSE_FNC_getTownPatrol = compile preprocessFileLineNumbers "waspServer\Warfare\Town\Ai\fn_getTownPatrol.sqf";
WFSE_FNC_manageTownDefenses = compile preprocessFileLineNumbers "waspServer\Warfare\Town\Ai\fn_manageTownDefenses.sqf";
WFSE_FNC_operateTownDefensesUnits = compile preprocessFileLineNumbers "waspServer\Warfare\Town\Ai\fn_operateTownDefensesUnits.sqf";
WFSE_FNC_spawnTownDefense = compile preprocessFileLineNumbers "waspServer\Warfare\Town\Ai\fn_spawnTownDefense.sqf";
WFSE_FNC_getTownActiveGroups = compile preprocessFileLineNumbers "waspServer\Warfare\Town\Ai\fn_getTownActiveGroups.sqf";
WFSE_FNC_startTownAiProcessing = compile preprocessFileLineNumbers "waspServer\Warfare\Town\Ai\fn_startTownAiProcessing.sqf";
WFSE_FNC_getVehicleTownGroups = compile preprocessFileLineNumbers "waspServer\Warfare\Town\Ai\fn_getVehicleTownGroups.sqf";
WFSE_FNC_spawnTownGroups = compile preprocessFileLineNumbers "waspServer\Warfare\Town\Ai\fn_spawnTownGroups.sqf";

WFSE_FNC_setCampsToSide = compile preprocessFileLineNumbers "waspServer\Warfare\Camp\fn_setCampsToSide.sqf";
WFSE_FNC_repairCamp = compile preprocessFileLineNumbers "waspServer\Warfare\Camp\fn_repairCamp.sqf";
WFSE_FNC_destroyCamp = compile preprocessFileLineNumbers "waspServer\Warfare\Camp\fn_destroyCamp.sqf";

WFSE_FNC_addEmptyVehicleToQueue = compile preprocessFileLineNumbers "waspServer\Unit\fn_addEmptyVehicleToQueue.sqf";
WFSE_FNC_requestVehicleLock = compile preprocessFileLineNumbers "waspServer\Unit\fn_requestVehicleLock.sqf";
WFSE_FNC_setLocalityOwner = compile preprocessFileLineNumbers "waspServer\Unit\fn_setLocalityOwner.sqf";            

WFSE_FNC_addHeadlessClient = compile preprocessFileLineNumbers "waspServer\HeadlessClient\fn_addHeadlessClient.sqf";

WFSE_FNC_aiComUpgrade = compile preprocessFileLineNumbers "waspServer\Module\AI\fn_aiComUpgrade.sqf";
WFSE_FNC_delegateAIHeadless = compile preprocessFileLineNumbers "waspServer\Module\AI\fn_delegateAIHeadless.sqf";
WFSE_FNC_manningOfResBaseDefense = compile preprocessFileLineNumbers "waspServer\Module\AI\fn_manningOfResBaseDefense.sqf";
        
WFSE_FNC_aiMoveTo = compile preprocessFileLineNumbers "waspServer\Module\AI\Orders\fn_aiMoveTo.sqf";
WFSE_FNC_aiPatrol = compile preprocessFileLineNumbers "waspServer\Module\AI\Orders\fn_aiPatrol.sqf";
WFSE_FNC_aiTownPatrol = compile preprocessFileLineNumbers "waspServer\Module\AI\Orders\fn_aiTownPatrol.sqf";
WFSE_FNC_aiWPAdd = compile preprocessFileLineNumbers "waspServer\Module\AI\Orders\fn_aiWPAdd.sqf";
WFSE_FNC_aiWPRemove = compile preprocessFileLineNumbers "waspServer\Module\AI\Orders\fn_aiWPRemove.sqf";

WFSE_FNC_paratroopers = compile preprocessFileLineNumbers "waspServer\Module\Support\fn_paratroopers.sqf";
WFSE_FNC_heliparatroopers = compile preprocessFileLineNumbers "waspServer\Module\Support\fn_heliparatroopers.sqf";
WFSE_FNC_paraVehicles = compile preprocessFileLineNumbers "waspServer\Module\Support\fn_paraVehicles.sqf";

WFSE_FNC_processIcbmEvent = compile preprocessFileLineNumbers "waspServer\Module\ICBM\fn_processIcbmEvent.sqf";

WFSE_FNC_buyRole = compile preprocessFileLineNumbers "waspServer\Module\Role\fn_buyRole.sqf";
WFSE_FNC_getRoleList = compile preprocessFileLineNumbers "waspServer\Module\Role\fn_getRoleList.sqf";
WFSE_FNC_resetRoles = compile preprocessFileLineNumbers "waspServer\Module\Role\fn_resetRoles.sqf";

WFSE_FNC_runWeatherEnvironment = compile preprocessFileLineNumbers "waspServer\Module\Weather\fn_runWeatherEnvironment.sqf";

WFSE_FNC_getGearTemplates = compile preprocessFileLineNumbers "waspServer\GearTemplates\fn_getGearTemplates.sqf";
WFSE_FNC_saveGearTemplate = compile preprocessFileLineNumbers "waspServer\GearTemplates\fn_saveGearTemplate.sqf";
WFSE_FNC_deleteGearTemplate = compile preprocessFileLineNumbers "waspServer\GearTemplates\fn_deleteGearTemplate.sqf";

WFSE_FNC_initTaskDirector = compile preprocessFileLineNumbers "waspServer\Task\fn_initTaskDirector.sqf";

WFSE_FNC_startEmptyVehiclesCollector = compile preprocessFileLineNumbers "waspServer\Environment\fn_startEmptyVehiclesCollector.sqf";
WFSE_FNC_startGarbageCollector = compile preprocessFileLineNumbers "waspServer\Environment\fn_startGarbageCollector.sqf";
WFSE_FNC_startEndGameConditionProcessing = compile preprocessFileLineNumbers "waspServer\Environment\fn_startEndGameConditionProcessing.sqf";

WFSE_FNC_FinishGameInfo = compile preprocessFileLineNumbers "waspServer\Warfare\Statistic\fn_FinishGameInfo.sqf";
WFSE_FNC_InitGameInfo = compile preprocessFileLineNumbers "waspServer\Warfare\Statistic\fn_InitGameInfo.sqf";
WFSE_FNC_InsertStructureKilled = compile preprocessFileLineNumbers "waspServer\Warfare\Statistic\fn_InsertStructureKilled.sqf";
WFSE_FNC_UpdatePlayingTime = compile preprocessFileLineNumbers "waspServer\Warfare\Statistic\fn_UpdatePlayingTime.sqf";