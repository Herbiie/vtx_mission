[{

	if (!(alive (missionNameSpace getVariable "currentHeli"))) then {
		missionNameSpace setVariable ["currentHelI",objNull,true];
	};

	if (isNull (missionNameSpace getVariable "currentHeli")) then {
		[_this # 1] call CBA_fnc_removePerFrameHandler;
	};
},0.5]  call CBA_fnc_addPerFrameHandler;
