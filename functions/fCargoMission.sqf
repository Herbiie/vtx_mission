private _pos1 = [[worldSize / 2, worldsize / 2, 0],0,worldsize / 2,15,0,20,0,[[getMarkerPos "heli",5000]]] call BIS_fnc_findSafePos;
private _pos2 = [_pos1,5000,worldsize / 4,15,0,20,0,[[getMarkerPos "heli",5000]]] call BIS_fnc_findSafePos;
missionNameSpace setVariable ["missionOn",true,true];
missionNameSpace setVariable ["bocMissions",(missionNameSpace getVariable "bocMissions") + 1,true];

private _attackPos = selectRandom [_pos1,_pos2];
if ("PeaceMode" call BIS_fnc_getParamValue == 0) then {
	[_attackPos] spawn {
		params ["_attackPos"];
		waitUntil {((missionNameSpace getVariable "currentHeli") distance _attackPos) < 2000};
		private _pos = [_attackPos,300,400,5,0,20,0,[[getMarkerPos "heli",5000]]] call BIS_fnc_findSafePos;
		private _group = [_pos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_G_F" >> "Infantry" >> "O_G_InfSquad_Assault")] call BIS_fnc_spawnGroup;
		_wp = _group addWaypoint [_attackPos, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointBehaviour "AWARE";
		_wp setWaypointCombatMode "RED";
		_wp setWaypointFormation "WEDGE";
		_wp setWaypointSpeed "NORMAL";
		_group setCurrentWaypoint _wp;
		private _pos = [_attackPos,300,400,5,0,20,0,[[getMarkerPos "heli",5000]]] call BIS_fnc_findSafePos;
		private _group = [_pos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_G_F" >> "Infantry" >> "O_G_InfSquad_Assault")] call BIS_fnc_spawnGroup;
		_wp = _group addWaypoint [_attackPos, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointBehaviour "AWARE";
		_wp setWaypointCombatMode "RED";
		_wp setWaypointFormation "WEDGE";
		_wp setWaypointSpeed "NORMAL";
		_group setCurrentWaypoint _wp;
	};
};
private _a = 0;
private _group1 = [_pos1, WEST, (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad")] call BIS_fnc_spawnGroup;
private _interval = 360/(count units _group1);
{
	private _newPos = _pos1 getPos [50,_a];
	_x setPos _newPos;
	_x disableai "move";
	_x setUnitPos "middle";
	_x setDir _a;
	_a = _a + _interval;
} forEach units _group1;

private _group2 = [_pos2, WEST, (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad")] call BIS_fnc_spawnGroup;
private _interval = 360/(count units _group2);
{
	private _newPos = _pos2 getPos [50,_a];
	_x setPos _newPos;
	_x disableai "move";
	_x setUnitPos "middle";
	_x setDir _a;
	_a = _a + _interval;
} forEach units _group2;


private _marker1 = createMarker ["missionStart",_pos1];
_marker1 setMarkerColor "colorBLUE";
_marker1 setMarkerType "mil_pickup";
_marker1 setMarkerText "Mission Start";

private _marker2 = createMarker ["missionEnd",_pos2];
_marker2 setMarkerColor "colorGREEN";
_marker2 setMarkerType "mil_end";
_marker2 setMarkerText "Mission End";

private _cargo = "B_CargoNet_01_ammo_F" createVehicle _pos1;
private _smoke1 = objNull;
private _smoke2 = objNull;
if ("Smoke" call BIS_fnc_getParamValue > 0) then {
	_smoke1 = "SmokeShellBlue_Infinite" createVehicle _pos1;
	_smoke2 = "SmokeShellGreen_Infinite" createVehicle _pos2;
};

private _task = format ["task%1",missionNameSpace getVariable "bocMissions"];

[WEST, [_task], ["Transport cargo. Pick up location marked with blue smoke, drop off location marked with green smoke.", format ["Task #%1: Cargo Mission",missionNameSpace getVariable "bocMissions"], ""], objNull,"CREATED"] call BIS_fnc_taskCreate;

[WEST, [format ["%1start",_task],_task], ["The pickup location is marked with blue smoke.", "Pick up cargo", "missionStart"], getMarkerPos "missionStart","ASSIGNED"] call BIS_fnc_taskCreate;

[WEST, [format ["%1end",_task],_task], ["The dropoff location is marked with green smoke.", "Drop off cargo", "missionend"], getMarkerPos "missionEnd","CREATED"] call BIS_fnc_taskCreate;

waitUntil {(ropeAttachedTo _cargo) == (missionNameSpace getVariable "currentHeli")};

[format ["%1start",_task],"SUCCEEDED"] call BIS_fnc_taskSetState;
[format ["%1end",_task],"ASSIGNED"] call BIS_fnc_taskSetState;


waitUntil {((_cargo distance _pos2) < 20) && (ropeAttachedTo _cargo != (missionNameSpace getVariable "currentHeli"))};


[format ["%1end",_task],"SUCCEEDED"] call BIS_fnc_taskSetState;
[_task,"SUCCEEDED"] call BIS_fnc_taskSetState;

deleteVehicle _cargo;
if ("Smoke" call BIS_fnc_getParamValue > 0) then {
	deleteVehicle _smoke1;
	deleteVehicle _smoke2;
};
deleteMarker _marker1;
deleteMarker _marker2;

missionNameSpace setVariable ["missionOn",false,true];

waitUntil {((missionNameSpace getVariable "currentHeli") distance _pos2) > 1500};
{
	deleteVehicle _x;
} forEach (units _group1) + (units _group2);

{
	if (side _x == east) then {
		deleteVehicle _x;
	};
} forEach allUnits;
{ deleteVehicle _x } forEach allDeadMen;