
// Params: jammer object
params ["_jammer","_disableAction"];
_enableAction = "";

/* Debug for Dedicated Server: Dumps this info as a string into the arma.RPT File in case crashes happen.*/
diag_log format ["jammer_fnc_disableJammer: | _jammer: %1 | Jammer Disable Function called.", _jammer]; // for seeing if the thing actually got executed and what the params where.

_jammer = _this select 0;

_jammer setVariable ["a3f_jammer_active", false, true]; // disables the Jammer.

hint format ["%1 - Disabled. JammerActive: %2", _jammer, _jammer getVariable "a3f_jammer_active"]; // Debug Message.

if (!isNull _disableAction) {
_jammer removeAction _disableAction;
};

if (isClass(configFile >> "CfgPatches" >> "ace_main")) then
{

// [_jammer, 0, ["ACE_MainActions", "a3f_disable_Jammer"]] remoteExec ["ace_interact_menu_fnc_removeActionFromObject", 0, true];
// also add the enable action again in case you wanna reactivate the Jammer. Placeholder for now, until the minigame is finished.
//	[_jammer, ["<t color='#ff0000'>Enable Jammer</t>", jammerClass_fnc_enableJammer, [_jammer], 1.5, true, true, ["!_jammerActive"], true, 3, false]] remoteExec ["addAction", 0, true];

_enableAction = [_jammer, ["<t color='#ff0000'>Enable Jammer</t>", jammerClass_fnc_enableJammer, [_jammer, _enableAction], 1.5, true, true, "", "!_jammerActive" , 15, false]];
_enableAction remoteExec ["addAction", 0, true];

//_action = ["a3f_enable_Jammer", "<t color='#ff0000'>Enable Jammer</t>", "", [!_jammerActive] , true] call ace_interact_menu_fnc_createAction;
//[_jammer, 0, ["ACE_MainActions"], _action] remoteExec ["ace_interact_menu_fnc_addActionToObject", 0, true];


}
else // to do: figure out how to remove action by name in vanilla A3... for later.
{
_enableAction = [_jammer, ["<t color='#ff0000'>Enable Jammer</t>", jammerClass_fnc_enableJammer, [_jammer, _enableAction], 1.5, true, true, "", "!_jammerActive" , 15, false]];
_enableAction remoteExec ["addAction", 0, true];
};
