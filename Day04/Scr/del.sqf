_q = nearestObjects [getPos trigRCamp_1, ["Car"], 50];
while {true} do {
	{deleteVehicle _x} forEach _q
};



