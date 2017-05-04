
// Params: jammer object
params ["_jammer"];

/* Debug for Dedicated Server: Dumps this info as a string into the arma.RPT File in case crashes happen.*/
diag_log format ["jammer_fnc_disableJammer: | _jammer: %1 | Jammer Disable Function called.", _jammer]; // for seeing if the thing actually got executed and what the params where.

_jammer = _this select 0;

_jammer setVariable ["a3f_jammer_active", false, true]; // disables the Jammer.

hint format ["%1 - Disabled.",_jammer];
