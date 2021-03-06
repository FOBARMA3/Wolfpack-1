if (ADF_HC_execute || isServer) then {
	call compile preprocessFileLineNumbers "Core\F\ADF_fnc_position.sqf";
	call compile preprocessFileLineNumbers "Core\F\ADF_fnc_distance.sqf";
	call compile preprocessFileLineNumbers "Core\F\ADF_fnc_defendArea.sqf";
	call compile preprocessFileLineNumbers "Core\F\ADF_fnc_vehiclePatrol.sqf";
	call compile preprocessFileLineNumbers "Core\F\ADF_fnc_footPatrol.sqf";
	call compile preprocessFileLineNumbers "Core\F\ADF_fnc_airPatrol.sqf";
	call compile preprocessFileLineNumbers "Core\F\ADF_fnc_seaPatrol.sqf";
};

execVM "Scr\loadout.sqf"; // Loadout for Wolfpack training missions
execVM "Scr\timer.sqf"; // Time in minutes, prep time in minutes (max. 15 min)

if (hasInterface) then {
	player createDiarySubject ["Wolfpack Log","Wolfpack Log"];
	player createDiaryRecord ["Wolfpack Log",["Wolf Communications Log","
	<br/><br/><font color='#6c7169'>The Wolfpack Log is a logbook of all operational radio comms between Wolf and TOC<br/>
	The messages are logged once displayed on screen. All messages are time-stamped and saved in order of appearance.</font>
	<br/><br/>
	"]];
};

if (isServer) then {
	[wolfCrate_1] execVM "Core\C\ADF_cCargo_B_SpecOps.sqf";
	[wolfCrate_2] execVM "Core\C\ADF_cCargo_B_SpecOps.sqf";
};

wp_airPatrols = false;
bDect = 0;

ADF_fnc_GM_1teleport = {
	openMap true; sleep .5;
	hintSilent format ["%1, click on a location on the map to teleport...", name vehicle player];
	onMapSingleClick "vehicle player setPos _pos; onMapSingleClick '';true; openMap false; hint format [""%1, you are now at: %2"", name vehicle player, getPosATL player];";
};

if !(isNil "GM_1") then {GM_1 addAction ["<t align='left' color='#F7D358'>Teleport</t>",ADF_fnc_GM_1teleport];};

if (ADF_HC_execute) exitWith { // HC Autodetect. If no HC present execute on the Server.
	private ["_g","_p","_c","_v"];
	
	// CP Static Positions
	_g = CreateGroup EAST;
	_p = _g createUnit ["O_Soldier_F",getMarkerPos "mAOborder",[],0,"SERGEANT"]; _p assignAsGunner oStat_30; _p moveInGunner oStat_30;
	_p = _g createUnit ["O_Soldier_F",getMarkerPos "mAOborder",[],0,"CORPORAL"]; _p assignAsGunner oStat_31; _p moveInGunner oStat_31;
	_p = _g createUnit ["O_Soldier_F",getMarkerPos "mAOborder",[],0,"PRIVATE"]; _p assignAsGunner oStat_32; _p moveInGunner oStat_32;
	_p = _g createUnit ["O_Soldier_F",getMarkerPos "mAOborder",[],0,"PRIVATE"]; _p assignAsGunner oStat_33; _p moveInGunner oStat_33;
	_p = _g createUnit ["O_Soldier_F",getMarkerPos "mAOborder",[],0,"PRIVATE"]; _p assignAsGunner oStat_34; _p moveInGunner oStat_34;
	_p = _g createUnit ["O_Soldier_F",getMarkerPos "mAOborder",[],0,"PRIVATE"]; _p assignAsGunner oStat_35; _p moveInGunner oStat_35;
	_p = _g createUnit ["O_Soldier_F",getMarkerPos "mAOborder",[],0,"PRIVATE"]; _p assignAsGunner oStat_36; _p moveInGunner oStat_36;
	_p = _g createUnit ["O_Soldier_F",getMarkerPos "mAOborder",[],0,"PRIVATE"]; _p assignAsGunner oStat_36; _p moveInGunner oStat_36;
	_p = _g createUnit ["O_Soldier_F",getMarkerPos "mAOborder",[],0,"PRIVATE"]; _p assignAsGunner oStat_37; _p moveInGunner oStat_37;

	// EI patrols
	for "_i" from 1 to 18 do {
		private ["_spawnPos","_g"];
		_spawnPos = format ["mIP_%1",_i];
		_g = [getMarkerPos _spawnPos, EAST, (configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry")] call BIS_fnc_spawnGroup;
		[_g, getMarkerPos _spawnPos, 800, 5, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 5, true] call ADF_fnc_footPatrol;
	};		

	// Vehicle patrols
	selectVehPool = {
		private "_vPoolArray";
		_vPoolArray = ["O_MRAP_02_F","O_MRAP_02_hmg_F","O_MRAP_02_gmg_F","O_G_Offroad_01_armed_F","O_Truck_02_covered_F","O_Truck_03_covered_F","O_Truck_02_transport_F","O_Truck_03_transport_F","O_Truck_02_fuel_F","O_Truck_03_fuel_F","O_Truck_02_ammo_F","O_Truck_03_ammo_F","O_Truck_02_box_F","O_Truck_03_device_F","O_Truck_02_medical_F","O_Truck_03_medical_F","O_APC_Wheeled_02_rcws_F"] call BIS_fnc_selectRandom;
		_vPoolArray;
	 };

	for "_i" from 1 to 7 do {
		private ["_c","_vPool","_spawnPos"];
		_c = createGroup EAST;
		_vPool = call selectVehPool;
		private ["_spawnPos"];
		_spawnPos = format ["mVP_%1",_i];	
		_v = [getMarkerPos _spawnPos, 0, _vPool, _c] call BIS_fnc_spawnVehicle;
		[_c, getmarkerpos _spawnPos, 2500, 6, "MOVE", "SAFE", "RED", "LIMITED", 25] call ADF_fnc_vehiclePatrol;
		_c setBehaviour "SAFE";
	};	

	// CP's
	for "_i" from 1 to 7 do {
		private ["_spawnPos","_g"];
		_spawnPos = format ["mCP_%1",_i];	
		_g = [getMarkerPos _spawnPos, EAST, (configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry")] call BIS_fnc_spawnGroup;
		[_g, getMarkerPos _spawnPos, 50, 2, true] call ADF_fnc_defendArea;
	};

	waitUntil {sleep 1; time > 120};

	// Air Patrols	
	private "_co";
	_c = createGroup EAST; 
	_v = [getMarkerPos "mAOborder", 0, "O_Heli_Light_02_unarmed_F", _c] call BIS_fnc_spawnVehicle;
	wp_ap1 = _v select 0;
	_co = effectiveCommander wp_ap1;
	_c setCombatMode "GREEN";
	_c setBehaviour "SAFE";
	wp_ap1 setPilotLight true;
	_co action ["lightOn",  wp_ap1];	
	[_c, getmarkerpos "mAOborder", 5000, 25, 4, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 250] call ADF_fnc_airPatrol;
	wp_airPatrols = true; publicVariable "wp_airPatrols";
	if (ADF_debug) then {[EAST,"OFF"] call ADF_fnc_debugMarkers}; // Side, Labels "ON"/"OFF"
};

waitUntil {sleep 1; wp_airPatrols};
["1", "onEachFrame", {player action ["lightOn",wp_ap1];}] call BIS_fnc_addStackedEventHandler;
