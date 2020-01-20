private _pos1 = [[worldSize / 2, worldsize / 2, 0],0,worldsize / 2,5,0,20,0,[[getMarkerPos "heli",5000]]] call BIS_fnc_findSafePos;
private _pos2 = [_pos1,5000,worldsize / 4,5,0,20,0,[[getMarkerPos "heli",5000]]] call BIS_fnc_findSafePos;
missionNameSpace setVariable ["missionOn",true,true];
missionNameSpace setVariable ["bocMissions",(missionNameSpace getVariable "bocMissions") + 1,true];

private _marker1 = createMarker ["missionStart",_pos1];
_marker1 setMarkerColor "colorBLUE";
_marker1 setMarkerType "mil_pickup";
_marker1 setMarkerText "Pick Up Point";

private _marker2 = createMarker ["missionEnd",_pos2];
_marker2 setMarkerColor "colorGREEN";
_marker2 setMarkerType "mil_end";
_marker2 setMarkerText "Landing Zone";

private _a = 0;
private _Fgroup = [_pos1, WEST, (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad")] call BIS_fnc_spawnGroup;
private _interval = 360/(count units _Fgroup);
{
	private _newPos = _pos1 getPos [50,_a];
	_x setPos _newPos;
	_x disableai "move";
	_x setUnitPos "middle";
	_x setDir _a;
	_a = _a + _interval;
} forEach units _Fgroup;

private _task = format ["task%1",missionNameSpace getVariable "bocMissions"];

[WEST, [_task], ["Troop Insert. Pick up location marked with blue smoke, drop off location unmarked. Enemy forces will patrol near the LZ.", format ["Task #%1: Air Assault Mission",missionNameSpace getVariable "bocMissions"], ""], objNull,"CREATED"] call BIS_fnc_taskCreate;

[WEST, [format ["%1start",_task],_task], ["The pickup location is marked with blue smoke.", "Pick up Troops", "missionStart"], getMarkerPos "missionStart","ASSIGNED"] call BIS_fnc_taskCreate;

[WEST, [format ["%1end",_task],_task], ["The dropoff location is patrolled by enemy troops.", "Drop off Troops", "missionend"], getMarkerPos "missionEnd","CREATED"] call BIS_fnc_taskCreate;
private _smokeF = objNull;
private _smokeE = objNull;
if ("Smoke" call BIS_fnc_getParamValue > 0) then {
	_smokeF = "SmokeShellBlue_Infinite" createVehicle _pos1;
};

if ("Smoke" call BIS_fnc_getParamValue > 1) then {
	_smokeE = "SmokeShellRed_Infinite" createVehicle _pos2;
};


if ("PeaceMode" call BIS_fnc_getParamValue == 0) then {
	private _pos1spawn = [_pos2,50,500,15,0,20,0,[[getMarkerPos "heli",5000]]] call BIS_fnc_findSafePos;
	private _group1 = [_pos1spawn, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_G_F" >> "Infantry" >> "O_G_InfSquad_Assault")] call BIS_fnc_spawnGroup;
	[_group1,_pos1spawn,500] call CBA_fnc_taskPatrol;
	
	private _pos2spawn = [_pos2,50,500,15,0,20,0,[[getMarkerPos "heli",5000]]] call BIS_fnc_findSafePos;
	private _group2 = [_pos2spawn, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_G_F" >> "Infantry" >> "O_G_InfSquad_Assault")] call BIS_fnc_spawnGroup;
	[_group2,_pos2spawn,500] call CBA_fnc_taskPatrol;
	
	private _pos3spawn = [_pos2,50,500,15,0,20,0,[[getMarkerPos "heli",5000]]] call BIS_fnc_findSafePos;
	private _group3 = [_pos3spawn, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_G_F" >> "Infantry" >> "O_G_InfSquad_Assault")] call BIS_fnc_spawnGroup;
	[_group3,_pos3spawn,500] call CBA_fnc_taskPatrol;
};

waitUntil {!isNull (missionNameSpace getVariable "currentHeli")};

waitUntil {(((missionNameSpace getVariable "currentHeli") distance _pos1) < 50) && (speed (missionNameSpace getVariable "currentHeli") < 1) && ((getPosATL (missionNameSpace getVariable "currentHeli") # 2) < 2)};

{
	_x moveInCargo (missionNameSpace getVariable "currentHeli");
} forEach units _Fgroup;
[format ["%1start",_task],"SUCCEEDED"] call BIS_fnc_taskSetState;

[format ["%1end",_task],"ASSIGNED"] call BIS_fnc_taskSetState;

waitUntil {(((missionNameSpace getVariable "currentHeli") distance _pos2) < 50) && (speed (missionNameSpace getVariable "currentHeli") < 1) && ((getPosATL (missionNameSpace getVariable "currentHeli") # 2) < 2)};

{
	_x enableAi "move";
	_x setUnitPos "auto";	
	unassignVehicle _x;
	doGetOut _x;
} forEach units _Fgroup;
[format ["%1end",_task],"SUCCEEDED"] call BIS_fnc_taskSetState;
[_task,"SUCCEEDED"] call BIS_fnc_taskSetState;

waitUntil {(((missionNameSpace getVariable "currentHeli") distance _pos2) > 150)};

{
	deleteVehicle _x;	
} forEach units _Fgroup;

{
	if (side _x == east) then {
		deleteVehicle _x;
	};
} forEach allUnits;

if ("Smoke" call BIS_fnc_getParamValue > 0) then {
	deleteVehicle _smokeF;
};

if ("Smoke" call BIS_fnc_getParamValue > 1) then {
	deleteVehicle _smokeE;
};
