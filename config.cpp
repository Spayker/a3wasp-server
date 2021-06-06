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
            class processUpgrade {};
            class requestUpgrade {};
            class synchronizeUpgade {};
            class CreateDestructionEffect {};
            class CleanTerrainRespawnPoint {};
        };

        class ServerBaseRequest {
            file = "waspServer\Base\Request";
            class requestAutoWallConstructinChange {};
            class requestDefense {};
            class requestStructure {};
            class requestStructureSell {};
            class processBaseDefense {};
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
	    class initTowns {};
	        class updateRadarTower {};
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

        class ServerModuleCruiseMissile {
            file = "waspServer\Module\CruiseMissile";
            class processCruiseMissileEvent {};
            class processChemicalMissileEvent {};
            class processTacticalNukeMissileEvent {};
            class processMissileDamage {};
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
            class UpdateSidesStats {};
        };
    };
};