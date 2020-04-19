private _helicopters = "((configName _x) isKindOf ['vtx_H60_base', configFile >> 'CfgVehicles']) && (getNumber (_x >> 'scope') == 2)" configClasses (configFile >> "CfgVehicles");

private _bocMissionFunctions = "true" configClasses (configFile >> "CfgFunctions" >> "boc" >> "missions");


if ("PeaceMode" call BIS_fnc_getParamValue == 1) then {
	_bocMissionFunctions = "getNumber (_x >> 'peaceMode') > 0" configClasses (configFile >> "CfgFunctions" >>"boc" >> "missions")
};

_mainAction = ["boc_OnCall", "Toggle on Call", "", {if (missionNameSpace getVariable "onCall") then {missionNameSpace setVariable ["onCall",false,true]} else {missionNameSpace setVariable ["onCall",true,true]}}, {(leader group player) == player}] call ace_interact_menu_fnc_createAction;

["CAManBase", 1, ["ACE_SelfActions"], _mainAction, true] call ace_interact_menu_fnc_addActionToClass;

_missionsAction = ["boc_Missions", "Request Mission", "", {}, {((leader group player) == player) && !(missionNameSpace getVariable "missionOn")}] call ace_interact_menu_fnc_createAction;
["CAManBase", 1, ["ACE_SelfActions"], _missionsAction, true] call ace_interact_menu_fnc_addActionToClass;

{
	private _text = getText (_x >> "missionName");
	private _name = format ["boc_fnc_%1",configName _x];
	_thisAction = [format ["boc_Mission%1",_forEachIndex], _text, "", {
		params ["_target", "_player", "_name"];
		[] remoteExec [_name,2];
	}, {((leader group player) == player) && !(missionNameSpace getVariable "missionOn")},{},_name] call ace_interact_menu_fnc_createAction;
	["CAManBase", 1, ["ACE_SelfActions","boc_Missions"], _thisAction, true] call ace_interact_menu_fnc_addActionToClass;
} forEach _bocMissionFunctions;

{
	private _name = getText (_x >> "displayName");
	private _type = configName _x;
	private _thisAction = [format ["boc_Heli%1",_forEachIndex], _name, "", {
		params ["_target", "_player", "_type"];
		private _heli = _type createVehicle getMarkerPos "heli";
		missionNameSpace setVariable ["currentHeli",_heli,true];
		[] remoteExec ["boc_fnc_HeliCheck",2];
	}, {((leader group player) == player) && isNull (missionNameSpace getVariable "currentHeli")},{},_type] call ace_interact_menu_fnc_createAction;
	[heliSelector,0,["ACE_MainActions"],_thisAction] call ace_interact_menu_fnc_addActionToObject;
} forEach _helicopters;

private _byeHeli = ["boc_byeHeli","Return current helicopter","",{
	private _heli = (missionNameSpace getVariable "currentHeli");
	if ((_heli distance getMarkerPos "heli") < 20) then {
		if ((count crew _heli) > 0) then {
			hint "Someone is in the helicopter";		
		} else {			
			deleteVehicle _heli;
			missionNameSpace setVariable ["currentHeli",objNull,true];
		};
	} else {
		hint "Helicopter is not close enough";
	};
},{((leader group player) == player) && !(isNull (missionNameSpace getVariable "currentHeli"))}] call ace_interact_menu_fnc_createAction;
[heliSelector,0,["ACE_MainActions"],_byeHeli] call ace_interact_menu_fnc_addActionToObject;

private _HeliTele = ["boc_HeliTele","Teleport to helicopter","",{
	private _heli = (missionNameSpace getVariable "currentHeli");
	if (count (crew _heli) > 0) then {
		player moveInCargo _heli;
	} else {
		private _pos = getPos _heli;
		private _newPos = [_pos, 1, 10, 1, 0, 50, 0] call BIS_fnc_findSafePos;
		player setPos _newPos;
	};
},{!(isNull (missionNameSpace getVariable "currentHeli"))}] call ace_interact_menu_fnc_createAction;
["CAManBase", 1, ["ACE_SelfActions"], _HeliTele, true] call ace_interact_menu_fnc_addActionToClass;

[player,"BluFor","playerLoadout"] call tb3_fnc_Loadout;

while {true} do {
	private _onCall = "No";
	if (missionNameSpace getVariable "onCall") then {_onCall = "Yes"};
	private _text = format ["<t size='0.5'>On Call: %1.",_onCall];
	if (missionNameSpace getVariable "missionOn") then {_text = "<t size='0.5'>On Mission."};
	if (!(isNull (missionNameSpace getVariable "currentHeli"))) then {
		private _heliType = typeOf (missionNameSpace getVariable "currentHeli");
		private _heliName = getText (configFile >> "CfgVehicles" >> _heliType >> "displayName");
		_text = _text + format ["<br/>Current Helicopter: %1</t>",_heliName];
	} else {
		_text = _text + "</t>";		
	};
	[_text, safezoneX+safeZoneW-0.75,safezoneY+safezoneH-1.61833, 0.5, 0] spawn BIS_fnc_dynamicText;
	sleep 0.5;
};
