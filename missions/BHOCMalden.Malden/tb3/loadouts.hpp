//Loadouts called with: [this,"side_class","unit_class"] call tb3_fnc_Loadout;
//Use those bellow as an example as to creating a side and unit class.
class TB3_Gear {
	class BluFor {
		class playerLoadout {
			ace_earplugs = 1;
	
			weapons[] = {"SMG_05_F","hgun_P07_khk_F"}; 
			priKit[] = {"30Rnd_9x21_Mag_SMG_02"};
			secKit[] = {};
			pisKit[] = {"16Rnd_9x21_Mag"};

			assignedItems[] = {"ItemRadio","ItemMap","ItemCompass","ItemWatch","ItemGPS"};

			headgear[] = {"H_PilotHelmetHeli_O"};
			goggles[] = {};
			uniform[] = {"U_B_CombatUniform_mcam"};
				uniformContents[] = {
					{"30Rnd_9x21_Mag_SMG_02",1},
					{"SmokeShellRed",2},
					{"Chemlight_green",1},
					{"FirstAidKit",1}
				};

			vest[] = {"V_TacVest_khk"};
				vestContents[] = {
					{"30Rnd_9x21_Mag_SMG_02",5},
					{"16Rnd_9x21_Mag",2},
					{"SmokeShellRed",2}
				};

			backpack[] = {"B_AssaultPack_cbr"};
				backpackContents[] = {
					{"DemoCharge_Remote_Mag",2},
				};

			magazines[] = {}; items[] = {};
		};
	};
};
