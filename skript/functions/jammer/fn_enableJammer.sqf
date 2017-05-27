
// Params: jammer object
params ["_jammer","_enableAction"];
_disableAction = "";

/* Debug for Dedicated Server: Dumps this info as a string into the arma.RPT File in case crashes happen.*/
diag_log format ["jammer_fnc_enableJammer: | _jammer: %1 | Jammer Enable Function called.", _jammer];
// for seeing if the thing actually got executed and what the params where.

_jammer = _this select 0;

_jammer setVariable ["a3f_jammer_active", true, true]; // disables the Jammer.

hint format ["%1 - Enabled. JammerActive: %2", _jammer, _jammer getVariable "a3f_jammer_active"]; // Debug Message.

if (!isNull _enableAction) {
_jammer removeAction _enableAction;
};

if (isClass(configFile >> "CfgPatches" >> "ace_main")) then
{
// [_jammer, 0, ["ACE_MainActions", "a3f_enable_Jammer"]] remoteExec ["ace_interact_menu_fnc_removeActionFromObject", 0, true];

// also add the enable action again in case you wanna re-deactivate the Jammer. Placeholder for now, until the minigame is finished.
	_disableAction = [_jammer, ["<t color='#ff0000'>Disable Jammer</t>", jammerClass_fnc_disableJammer, [_jammer, _disableAction], 1.5, true, true, "", "_jammerActive = true" , 15, false]];
  _disableAction remoteExec ["addAction", 0, true];

// _action = ["a3f_disable_Jammer", "<t color='#ff0000'>Disable Jammer</t>", "", [!_jammerActive] , true] call ace_interact_menu_fnc_createAction;
// [_jammer, 0, ["ACE_MainActions"], _action] remoteExec ["ace_interact_menu_fnc_addActionToObject", 0, true];

}
else // to do: figure out how to remove action by name in vanilla A3... for later.
{
  _jammer removeAction jammerClass_fnc_enableJammer;

	_disableAction = [_jammer, ["<t color='#ff0000'>Disable Jammer</t>", jammerClass_fnc_disableJammer, [_jammer, _disableAction], 1.5, true, true, "", "_jammerActive = true" , 15, false]];
  _disableAction remoteExec ["addAction", 0, true];
};
