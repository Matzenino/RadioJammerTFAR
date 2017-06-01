/*### TFAR Radio Jammer by Matze ###*/

// [jammer, number, antenna, jammerActive] execVM "jammerinit.sqf";
// Params: jammer object; JammingRadius int; controller object; antenna object;

params ["_jammer",["_jammingRadius", 1500] ,["_antenna", objNull],["_jammerActive", true]];

/* Debug for Dedicated Server: Dumps this info as a string into the arma.RPT File in case crashes happen.*/
diag_log format ["Jammer_fnc_Init: | _jammer: %1 | _jammingRadius: %2 | _antenna: %3 | _jammerActive: %4", _jammer, _jammingRadius, _antenna, _jammerActive];
// comment this out if not needed

if ( isNull _antenna) then {
	_antenna = _jammer;
};

_jammer setVariable ["a3f_jammer_active", _jammerActive , true];


// #include "settingsJammer.sqf" // to do: put additional parameters into this thing.

/*
	to do:
		- make Init Script pre compileable
	  - Hacking Mini Game...
		- Remove unused shit

*/

// creates Action to Jammer to disable it.
if (_jammerActive) then {
_disableAction = "";
_enableAction = "";


	if (isClass(configFile >> "CfgPatches" >> "ace_main")) then
	{
	/*   // expected Action Parameters as defined by the Ace3 wiki:
			0: Action name <STRING>
			1: Name of the action shown in the menu <STRING>
			2: Icon <STRING>
			3: Statement <CODE>
			4: Condition <CODE>
			5: Insert children code <CODE> (Optional)
			6: Action parameters <ANY> (Optional)
			7: Position (Position or Selection Name) <POSITION> or <STRING> (Optional)
			8: Distance <NUMBER> (Optional)
			9: Other parameters <ARRAY> (Optional)
	*/	 // <- All Action parameters.

// Action Menu approach:
	//[_jammer, ["<t color='#ff0000'>Disable Jammer</t>", jammerClass_fnc_disableJammer, [_jammer], 1.5, true, true, ["_jammerActive"], true, 3, false]] remoteExec ["addAction", 0, true];

if (isServer) then {
	_disableAction = [_jammer, ["<t color='#ff0000'>Disable Jammer</t>", jammerClass_fnc_disableJammer, [_jammer], 1.5, true, true, "", "(_target getVariable 'a3f_jammer_active')" , 15, false]];
	_disableAction remoteExec ["addAction", 0, true];
	_enableAction = [_jammer, ["<t color='#ff0000'>Enable Jammer</t>", jammerClass_fnc_enableJammer, [_jammer], 1.5, true, true, "", "!(_target getVariable 'a3f_jammer_active')" , 15, false]];
	_enableAction remoteExec ["addAction", 0, true];
};

	}
	else
	{
		/*			AddAction according to bohemia wiki:
				object addAction [title, script, arguments, priority, showWindow, hideOnUse, shortcut, condition, radius, unconscious, selection]
				[ title, script, arguments, priority, showWindow, hideOnUse, shortcut, condition, radius, unconscious, selection]
		*/
		_disableAction = [_jammer, ["<t color='#ff0000'>Disable Jammer</t>", jammerClass_fnc_disableJammer, [_jammer], 1.5, true, true, "", "(_target getVariable 'a3f_jammer_active')" , 15, false]];
		_disableAction remoteExec ["addAction", 0, true];
		_enableAction = [_jammer, ["<t color='#ff0000'>Enable Jammer</t>", jammerClass_fnc_enableJammer, [_jammer], 1.5, true, true, "", "!(_target getVariable 'a3f_jammer_active')" , 15, false]];
		_enableAction remoteExec ["addAction", 0, true];
	};
} else { // if Jammer NOT Active.

	if (isClass(configFile >> "CfgPatches" >> "ace_main")) then
	{
		_enableAction = [_jammer, ["<t color='#ff0000'>Enable Jammer</t>", jammerClass_fnc_enableJammer, [_jammer], 1.5, true, true, "!(_target getVariable 'a3f_jammer_active')", true, 20, false]];
		_enableAction remoteExec ["addAction", 0, true];
		_disableAction = [_jammer, ["<t color='#ff0000'>Disable Jammer</t>", jammerClass_fnc_disableJammer, [_jammer], 1.5, true, true, "", "(_target getVariable 'a3f_jammer_active')" , 15, false]];
		_disableAction remoteExec ["addAction", 0, true];

	}
	else
	{
		_disableAction = [_jammer, ["<t color='#ff0000'>Disable Jammer</t>", jammerClass_fnc_disableJammer, [_jammer], 1.5, true, true, "", "(_target getVariable 'a3f_jammer_active')" , 15, false]];
		_disableAction remoteExec ["addAction", 0, true];
		_enableAction = [_jammer, ["<t color='#ff0000'>Enable Jammer</t>", jammerClass_fnc_enableJammer, [_jammer], 1.5, true, true, "", "!(_target getVariable 'a3f_jammer_active')" , 15, false]];
		_enableAction remoteExec ["addAction", 0, true];
	};
};

/*
		Main Program loop
		aka "the Jamming part."
*/

while {alive _jammer && alive _antenna } do {

_unitInJammerArea = nearestObjects [_antenna, ["Man"], _jammingRadius];
_allUnits = allPlayers - entities "HeadlessClient_F";
_notInJammerArea = _allUnits - _unitInJammerArea;

_jammerActive = _jammer getVariable "a3f_jammer_active" ;

	// the actual jamming part. when the Jammer is Active do the thing. Else check if hacked.
	if (_jammerActive && alive _antenna && alive _jammer) then {

		if !(count _notInJammerArea isEqualTo 0) then {
			{
				_x setVariable ["tf_receivingDistanceMultiplicator", 1];
				_x setVariable ["tf_sendingDistanceMultiplicator", 1];
			} foreach _notInJammerArea;
		};

		// the outside of jamming radius part

		if !(count _unitInJammerArea isEqualTo 0) then {
			{
				_x setVariable ["tf_receivingDistanceMultiplicator", 0];
				_x setVariable ["tf_sendingDistanceMultiplicator", 0];
			}  foreach _unitInJammerArea;
		};
	} else { // if Jammer disabled...

		{
			_jammer setVariable ["a3f_jammer_active", _jammerActive, false];
					_x setVariable ["tf_receivingDistanceMultiplicator", 1];
					_x setVariable ["tf_sendingDistanceMultiplicator", 1];
		}  foreach _allUnits;

	};

 sleep 1.5
 ; // delay between updates. In here because of Performance

}; // Endloop.

// fallback for when the jammer is destroyed and the thingy gets reset.

if(!alive _jammer || !alive _antenna) then {
	_allUnits = allPlayers - entities "HeadlessClient_F";
	{
		_jammer setVariable ["a3f_jammer_active", _jammerActive, false];
				_x setVariable ["tf_receivingDistanceMultiplicator", 1];
				_x setVariable ["tf_sendingDistanceMultiplicator", 1];
	}  foreach _allUnits;
};
