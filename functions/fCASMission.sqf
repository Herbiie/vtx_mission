private _pos1 = [[worldSize / 2, worldsize / 2, 0],0,worldsize / 2,15,0,20,0,[[getMarkerPos "heli",5000]]] call BIS_fnc_findSafePos;
private _pos2 = [_pos1,200,400,15,0,20,0,[[getMarkerPos "heli",5000]]] call BIS_fnc_findSafePos;
missionNameSpace setVariable ["onCall",false,true];
missionNameSpace setVariable ["missionOn",true,true];
missionNameSpace setVariable ["bocMissions",(missionNameSpace getVariable "bocMissions") + 1,true];
private _group1 = [_pos1, WEST, (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad")] call BIS_fnc_spawnGroup;
private _dir1 = _pos1 getDir _pos2;
{
	_x disableai "move";
	_x setDir _dir1;
	_x setUnitPos "middle";
	_x setCaptive true;
} forEach units _group1;
private _group2 = [_pos2, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad")] call BIS_fnc_spawnGroup;
private _dir2 = _pos2 getDir _pos1;
{
	_x disableai "move";
	_x setDir _dir2;
	_x setUnitPos "middle";
} forEach units _group2;

private _marker1 = createMarker ["missionStart",_pos2];
_marker1 setMarkerColor "colorOPFOR";
_marker1 setMarkerType "mil_destroy";
_marker1 setMarkerText "Target";
private _smokeF = objNull;
private _smoke = objNull;
if ("Smoke" call BIS_fnc_getParamValue > 0) then {
	_smokeF = "SmokeShellBlue_Infinite" createVehicle _pos1;
};
if ("Smoke" call BIS_fnc_getParamValue > 1) then {
	_smoke = "SmokeShellRed_Infinite" createVehicle _pos2;
};


private _marker2 = createMarker ["ff",_pos1];
_marker2 setMarkerColor "colorBLUFOR";
_marker2 setMarkerType "b_inf";
private _marker3 = createMarker ["ffS",_pos1];
_marker3 setMarkerColor "colorBLACK";
_marker3 setMarkerType "group_1";
_marker3 setMarkerText "Friendly Patrol";

private _task = format ["task%1",missionNameSpace getVariable "bocMissions"];

[WEST, [_task], ["Friendly infantry unit has requested Close Air Support.", format ["Task #%1: Close Air Support",missionNameSpace getVariable "bocMissions"], ""], objNull,"CREATED"] call BIS_fnc_taskCreate;

[WEST, [format ["%1start",_task],_task], ["Target marked with red smoke!", "Destroy enemy infantry", "missionStart"], getMarkerPos "missionStart","ASSIGNED"] call BIS_fnc_taskCreate;

waitUntil {({side _x == east && (_x distance _pos2) < 50} count allUnits) == 0};

[format ["%1start",_task],"SUCCEEDED"] call BIS_fnc_taskSetState;
[_task,"SUCCEEDED"] call BIS_fnc_taskSetState;


if ("Smoke" call BIS_fnc_getParamValue > 1) then {
	deleteVehicle _smoke;
};
if ("Smoke" call BIS_fnc_getParamValue > 0) then {
	deleteVehicle _smokeF;
};
deleteMarker _marker1;
deleteMarker _marker2;
deleteMarker _marker3;

missionNameSpace setVariable ["missionOn",false,true];

waitUntil {((missionNameSpace getVariable "currentHeli") distance _pos2) > 1500};
{
	deleteVehicle _x;
} forEach (units _group1);
{ deleteVehicle _x } forEach allDeadMen;

