class DefaultEventhandlers;
class CfgPatches {
    class waspServer {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"A3_Data_F","A3_Soft_F","A3_Soft_F_Offroad_01","A3_Characters_F"};
        fileName = "waspServer.pbo";
        author = "WASP CTI Community";
    };
};

class CfgFunctions {
    class MySQL_Database {
        tag = "DB";
        class MySQL {
            file = "\waspServer\MySQL";
            class asyncCall {};
			class mresString {};
        };
    };

	class WF_server {
        tag = "WFSE";

        class ServerMain {
            file = "waspServer";
            class initServer {};
        };

        class ServerBase {
            file = "waspServer\Base";
            class createDefenseTemplate {};
            class createObjectsFromArray {};
            class processUpgrade {};
            class requestUpgrade {};
            class synchronizeUpgade {};
            class startBaseAreaProcessing {};
            class CreateDestructionEffect {};
            class startStaticDefenseProcessing {};
        };

        class ServerBaseAi {
            file = "waspServer\Base\Ai";
            class createBasePatrol {};
        };
		
		class ServerBaseConstruction {
            file = "waspServer\Base\Construction";
            class hQSite {};
            class smallSite {};
            class stationaryDefense {};
            class mediumSite {};
            class mediumSiteObjects {};
        };

        class ServerBaseEventHandling {
            file = "waspServer\Base\EventHandling";
            class buildingDamaged {};
            class buildingKilled {};
            class handleBuildingRepair {};
        };

        class ServerBaseHq {
            file = "waspServer\Base\Hq";
            class OnHQKilled {};
        };

        class ServerBaseRequest {
            file = "waspServer\Base\Request";
            class requestAutoWallConstructinChange {};
            class requestDefense {};
            class requestStructure {};
            class RequestStructureSell {};
        };

        class ServerCommander {
            file = "waspServer\Commander";
            class requestCommanderVote {};
            class requestNewCommander {};
            class voteForCommander {};
            class passVote {};
        };

        class ServerEconomy {
            file = "waspServer\Economy";
            class buyGroup {};
            class changeAICommanderFunds {};
            class getAICommanderFunds {};
            class updateResources {};
        };

        class ServerPlayer {
            file = "waspServer\Player";
            class onPlayerConnected {};
            class onPlayerDisconnected {};
            class requestChangeScore {};
            class requestJoin {};
            class updateTeamLeader {};
            class sideMessage {};
            class updatePlayerDataDB {};
            class updatePlayersList {};
            class groupQuery {};
        };

        class ServerTeam {
            file = "waspServer\Team";
            class canUpdateTeam {};
            class requestTeamUpdate {};
            class updateTeam {};
        };

        class ServerTown {
            file = "waspServer\Warfare\Town";
            class startTownProcessing {};
	    class initTowns {};
        };

        class ServerTownAi {
            file = "waspServer\Warfare\Town\Ai";
            class getTownPatrol {};
        };

        class ServerCamp {
            file = "waspServer\Warfare\Camp";
            class setCampsToSide {};
            class repairCamp {};
            class destroyCamp {};
        };

        class ServerUnit {
            file = "waspServer\Unit";
            class addEmptyVehicleToQueue {};
            class requestVehicleLock {};
            class setLocalityOwner {};            
        };

        class ServerUnitArty {
            file = "waspServer\Unit\Arty";
            class fireRemoteArtillery {};
            class calculateArtyDamage {};
        };

        class ServerHeadlessClient {
            file = "waspServer\HeadlessClient";
            class addHeadlessClient {};
        };

        class ServerModuleAI {
            file = "waspServer\Module\AI";
            class aiComUpgrade {};
            class delegateAIHeadless {};
        };

        class ServerModuleCram {
            file = "waspServer\Module\Cram";
            class initCram {};
        };

        class ServerModuleIcbm {
            file = "waspServer\Module\ICBM";
            class processIcbmEvent {};
            class processNukeDamage {};
        };

        class ServerModuleRole {
            file = "waspServer\Module\Role";
            class buyRole {};
            class getRoleList {};
            class resetRoles {};
        };

        class ServerModuleWeather {
            file = "waspServer\Module\Weather";
            class runWeatherEnvironment {};			
        };

        class ServerModuleTestCode {
            file = "waspServer\Module\TestCode";
            class compileNext {};
            class compileAndExecFile {};
        };

        class GearTemplates {
            file = "\waspServer\GearTemplates";
            class getGearTemplates {};
            class saveGearTemplate {};
            class deleteGearTemplate {};
        };

        class ServerEnvironment {
            file = "\waspServer\Environment";
            class startEmptyVehiclesCollector {};
            class startCommonLogicProcessing {};
        };

        class ServerStatistic {
            file = "waspServer\Warfare\Statistic";
            class UpdatePlayingTime {};
            class InitGameInfo {};
            class FinishGameInfo {};
            class InsertStructureKilled {};
            class ShowPlayerStats {};
            class UpdateSidesStats {};
        };
    };
};