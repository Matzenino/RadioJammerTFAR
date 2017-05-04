/*### TFAR Radio Jammer by Matze ###*/

// Params: jammer object; JammingRadius int; controller object; antenna object;

params [["_jammer",objNull, [objNull]],["_jammingRadius",1500] ,["_antenna",_jammer],["_jammerActive",true]];

/* Debug for Dedicated Server: Dumps this info as a string into the arma.RPT File in case crashes happen.*/
diag_log format ["Jammer_fnc_Init: | _jammer: %1 | _jammingRadius: %2 | _antenna: %3 | _jammerActive: %4", _jammer, _jammingRadius, _antenna, _jammerActive];
// comment this out if not needed

/* // old way of applying this shit.
_jammer = _this select 0;
_jammingRadius = _this select 1;
_antenna = _this select 2;
_jammerActive = _this select 3;
*/

#include "settingsJammer.sqf" // to do: put additional parameters into this thing.

/*
	to do:
	  - toggle it with an action bound to a controller
			- internal Button logic: check if Jammer is on.
					(If on: add action to disable.) else (If off: remove disable action. add action to enable.)
					 ((or other way around. have it be on by default and only add disable function...))
	  - make jamming range variable
	  - test if this works with longrange and shortrange.
	  - a fucking Hacking minigame... (THANKS FROSTY <.<)
*/

// creates Action to Jammer to disable it.

	if (isClass(configFile >> "CfgPatches" >> "ace_main")) then
	{
	/*
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
	*/																																								// add function call
		_action = ["a3f_disable_Jammer", "<t color='#ff0000'>deactivate Jammer</t>", "", [_jammerActive = true] , true] call ace_interact_menu_fnc_createAction;
		[_jammer, 0, ["ACE_MainActions"], _action] remoteExec ["ace_interact_menu_fnc_addActionToObject", 0, true];

	}
	else
	{/*			AddAction according to wiki:
				object addAction [title, script, arguments, priority, showWindow, hideOnUse, shortcut, condition, radius, unconscious, selection]
		*/
		[_jammer, ["<t color='#ff0000'>deactivate Jammer</t>", jammer_fnc_disableJammer, [], 1.5, true, true, [_jammerActive = true], true, 3, false]] remoteExec ["addAction", 0, true];
	};

// only jam while the Jammer is alive
while{alive _jammer }do {

_unitInJammerArea = nearestObjects [_jammer, ["Man"], _jammingRadius];
_allUnits = allPlayers - entities "HeadlessClient_F";

_notInJammerArea = _allUnits - _unitInJammerArea;

// the actual jamming part
if !(count _notInJammerArea isEqualTo 0) then {
	{
		_x setVariable ["tf_receivingDistanceMultiplicator", 1];
		_x setVariable ["tf_sendingDistanceMultiplicator", 1];
	}foreach _notInJammerArea;
};

// the outside of jamming radius part
if !(count _unitInJammerArea isEqualTo 0) then {
	{
		_x setVariable ["tf_receivingDistanceMultiplicator", 0];
		_x setVariable ["tf_sendingDistanceMultiplicator", 0];
	}foreach _unitInJammerArea;
};

sleep 5; // delay between updates.

};
