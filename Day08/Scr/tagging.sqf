if (!hasInterface) exitWith {};
sleep 80;

hintSilent parseText"<img size= '5' shadow='false' image='Img\jsoc_logo.paa'/><br/><br/><t color='#6C7169' align='left'>Uncle: Viper, we need you to tag a few of the T100 Tigers with a GPS tracker.<br/>Get close enough to the vehicle in order to place the GPS tracker.<br/></t>";
_logTime = [dayTime] call BIS_fnc_timeToString;
_logTimeText = "Log: " + _logTime;
player createDiaryRecord ["Wolfpack Log", [_logTimeText,"
<br/><br/><font color='#9da698' size='14'>From: JSOC TOC</font><br/>
<font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/>
<font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/>
<font color='#6C7169'>Uncle: Viper, we need you to tag a few of the T100 Tigers with a GPS tracker.</font><br/>
<font color='#6C7169'>Get close enough to the vehicle in order to place the GPS tracker.</font>
<br/><br/>"]];

waitUntil {
	sleep 3;
	(
		triggerActivated tObj1 ||
		triggerActivated tObj2 ||
		triggerActivated tObj3 ||
		triggerActivated tObj4 ||
		triggerActivated tObj5 ||
		triggerActivated tObj6
	);
};

sleep 5;

_logTime = [dayTime] call BIS_fnc_timeToString;
_logTimeText = "Log: " + _logTime;
player createDiaryRecord ["Wolfpack Log", [_logTimeText,"
<br/><br/><font color='#9da698' size='14'>From: JSOC TOC</font><br/>
<font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/>
<font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/>
<font color='#6C7169'>Uncle: Good job Viper, we have a clear signal on the location of Ice Tiger.</font><br/><br/>
<font color='#6C7169'>Standby for exfil information...</font>
<br/><br/>"]];
for "_i" from 1 to 20 do {
	hintSilent parseText"<img size= '5' shadow='false' image='Img\jsoc_logo.paa'/><br/><br/><t color='#6C7169' align='left'>Uncle: Good job Viper, we have a clear signal on the location of Ice Tiger.<br/><br/>Standby for exfil information...<br/></t>";
	sleep 1;
};