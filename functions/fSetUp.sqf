missionNameSpace setVariable ["currentHeli",objNull,true];
missionNameSpace setVariable ["onCall",false,true];
missionNameSpace setVariable ["missionOn",false,true];
missionNameSpace setVariable ["bocMissions",0,true];

private _bocMissionFunctions = "true" configClasses (ConfigFile >> "CfgFunctions" >>"boc" >> "missions");

if ("PeaceMode" call BIS_fnc_getParamValue == 1) then {
	_bocMissionFunctions = "getNumber (_x >> 'peaceMode') > 0" configClasses (ConfigFile >> "CfgFunctions" >>"boc" >> "missions")
};

if ("Arsenal" call BIS_fnc_getParamValue == 1) then {
	[box, true] call ace_arsenal_fnc_initBox;
};

while {true} do {
	waitUntil {((missionNameSpace getVariable "onCall")) && !(missionNameSpace getVariable "missionOn")};
	sleep 10;
	private _a = random 100;
	if ((_a < 50) && (missionNameSpace getVariable "onCall")) then {
		missionNameSpace setVariable ["onCall",false,true];
		private _function = selectRandom _bocMissionFunctions;
		private _name = format ["boc_fnc_%1",configName _function];
		[true] remoteExec [_name,2];
	};
};