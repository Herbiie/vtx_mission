class cfgFunctions {
	class boc {
		class missions {
			class cargoMission {
				file = "vtx_mission\functions\fCargoMission.sqf";
				missionName = "Cargo Transport";
				peacemode = 1;
			};
			class casMission {
				file = "vtx_mission\functions\fCASMission.sqf";
				missionName = "Close Air Support (Infantry)";
				peacemode = 0;
			};
			class casMission2 {
				file = "vtx_mission\functions\fCASMission2.sqf";
				missionName = "Close Air Support (Armour)";
				peacemode = 0;
			};
			class insertMission {
				file = "vtx_mission\functions\fInsertMission.sqf";
				missionName = "Air Assault";
				peacemode = 1;
			};
		};

		class core {
			class setup {
				file = "vtx_mission\functions\fSetUp.sqf";
			};
			class playersetup {
				file = "vtx_mission\functions\fPlayerSetup.sqf";
			};
			class heliCheck {
				file = "vtx_mission\functions\fheliCheck.sqf";
			};
		};
	}
};