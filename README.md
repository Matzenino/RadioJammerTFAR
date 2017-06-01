#### TFAR Jammer Script by Matze ####

A simple Modular Jammer for your Arma 3 needs.
Requires the TFAR Mod for Arma 3.

To be used on any valid object in Arma 3.
Uses the TFAR API to do its thing.

Designate a vehicle or object als Jammer Controller and an optional Antenna with the range of the Jammer.

It disables all player broadcasting and receiving ability.

Originally developed for the XPG Arma Community Campaign "UN Task Force - Guardian Angel"

Based upon snippets found on the workshop, made by: [Original Author To Be Added Here]


How to install.

1. put the files into the mission folder
2. if the cfgFunctions.hpp or the description.ext file already exist, add the code inside to your file.
Check if the mission description loads the cfgFunction file or else you'll get errors!
3. the Jammer gets initialized by the jammerinit.sqf file.
The function call is explained inside the file. Here is a short run down of the procedure.
The Jammer has 3 Parameters:
The jammer Object, the range of the jammer (the diameter of the surrounding area), the Antenna and
the jammerActive value. The JammerActive Value is a boolean (a data type that either returns true or false)
that determines if the jammer is active when it gets spawned or if it is deactivated.

It gets called like this:

Put the following inside the init line of the trigger or object you want to make the jammer.
Doesnt really matter. what matters is that the script gets called in the first place. ;)

 [jammer, number, antenna, jammerActive] execVM "jammerinit.sqf";

You replace the jammer with the name of the actual jammer object. Note: animals cannot be jammers.
The Jammer is the controller object of the whole thing. It gets action menu entries that allow you to
manually shuttdown or turn on the jammer when you near it.

Of course you can just turn it on or off via trigger.
The way to do that is with the setVariable command.

jammerName setVariable ["a3f_jammer_active", true] // turns the jammer on
jammerName setVariable ["a3f_jammer_active", false] // turns the jammer off

Number should be selfexplanatory.
You enter the diameter of the jamming area in meters.
So if you wanna jamm a 2 km area you enter 2000 as value.

Antenna is an optional parameter (expected object).
Usually you have the jamming device and an antenna from which the jamming signal gets broadcasted.
If you destroy one of the 2 the jamming will cease.
The script originates the Jamming area from the Antenna. 

So if you wanna mark the position of the jamming area on the map,
just put the marker on top of the antenna.

PS: The script currently only affects men on the ground.
Testing with vehicles hasnt been done yet.

Coming Features:
- Hacking the Jammer to turn it into a Radio booster/Transceiver/Uplink-Station
- Maybe a static sound that gets played over the net when trying to send messages.


Thanks to:
- Frosty and the XPG Community for believing in me finishing this Script.
- The Stargate ARMA Community and their help in making this script a reality.
  Their Input in my query was very very helpfull. You guys saved my sanity!
- Freak for listening to my constant ranting. :D

Also Vita Cola, for being there in my time of need.