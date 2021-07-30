# A3 WASP WARFARE SERVER
Server scripts that partially responcible for major gameplay mechanics and network cooperation between players and headless client.

## Description
waspServer mod is a server side mod that contains main warfare logic to run WASP warfare missions properly. It must be used by dedicated Arma host process (-serverMod)

## How To Use
Create a script (.bat, .sh) that will run your dedicated server process on target host. 
Include -mod string like it shown below:
"-serverMod=!Workshop\@waspServer;!Workshop\@AdvancedRappelling"

Full Example:

@echo off
echo ArmA 3 Restart Script
start /wait /high ..\arma3server_x64.exe -profiles=Profiles -name=Administrator -port=2302 -bepath=Z:\BattlEye\ -bandwidthAlg=2 -limitFPS=200 -hugePages -cfg=config.cfg -config=server.cfg -malloc=system -loadMissionToMemory -world=empty "-mod=!Workshop\@CBA_A3;!Workshop\@CUP Terrains - Core;!Workshop\@CUP Terrains - Maps;!Workshop\@CUP Units;!Workshop\@CUP Vehicles;!Workshop\@CUP Weapons;!Workshop\@Cold War Rearmed III;!Workshop\@AdWaspLite;" "-serverMod=!Workshop\@waspServer;!Workshop\@AdvancedRappelling"

## Links
Steam Workshop: https://steamcommunity.com/sharedfiles/filedetails/?id=2346668851 </br>