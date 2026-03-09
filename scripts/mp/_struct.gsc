#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include scripts\mp\_func;
#include scripts\mp\_util;
#include scripts\mp\_binds;
#include scripts\mp\_menu;

structure()
{
    self create_menu( "Copycat", "exit" );
    self add_option( "Copycat", "Miscellaneous", ::load_menu, undefined, "Miscellaneous" );
    self add_option( "Copycat", "Binds", ::load_menu, undefined, "Binds" );
    self add_option( "Copycat", "Toggles", ::load_menu, undefined, "Toggles" );
    self add_option( "Copycat", "Aimbot", ::load_menu, undefined, "Aimbot");

    self create_menu( "Toggles", "Copycat" );
    self add_option( "Toggles", "Edit Safe Area", ::load_menu, undefined, "Edit Safe Area");
    self add_option( "Toggles", "Weapon Angles", ::load_menu, undefined, "Custom Weapon Angles");
    self add_option( "Toggles", "All Angle Bounces", ::toggle_aabounces, getdvarint("pm_bouncingAllAngles") ? "ON" : "OFF" );
    self add_option( "Toggles", "Death Barriers", ::toggledeathbarriers, getdvar("deathbarriers") );
    self add_option( "Toggles", "Elevators", ::toggleg_elevators, getdvarint("g_enableElevators") ? "ON" : "OFF" );
    self add_option( "Toggles", "Sprint Mid Air", ::toggle_sprintair, getdvarint("pm_sprintInAir") ? "ON" : "OFF" );
    self add_option( "Toggles", "Fall Damage", ::toggle_falldmg, getdvarint("jump_enablefalldamage") ? "ON" : "OFF" );
    self add_option( "Toggles", "Disable Nightvision", ::toggle_nv, getdvarint("nightvisiondisableeffects") ? "ON" : "OFF" );
    self add_option( "Toggles", "Jump Slowdown", ::toggle_jumpslowdown, getdvarint("jump_slowdownEnable") ? "ON" : "OFF" );
    
    self create_menu( "Custom Weapon Angles", "Toggles" );
    self add_dvar_slider( "Custom Weapon Angles", "X", undefined, "cg_gun_x", -200, 200, 1 );
    self add_dvar_slider( "Custom Weapon Angles", "Y", undefined, "cg_gun_y", -200, 200, 1 );
    self add_dvar_slider( "Custom Weapon Angles", "Z", undefined, "cg_gun_z", -200, 200, 1 );

    self add_option( "Toggles", "Infinite Equipment", ::toggleinfeq, self getpers("infeq") );
    self add_pers_array_slider( "Toggles", "Infinite Ammo", ::toggleinfammo, StrTok("^5OFF^7,Continuous,On Reload", ","), "infammo" );
    self add_dvar_slider( "Toggles", "Gravity", undefined, "g_gravity", 100, 1500, 50 );
    self add_dvar_slider( "Toggles", "Time Scale", ::ChangeTimescale, "timescale", 0.25, 10, 0.25 );
    self add_dvar_slider( "Toggles", "Use Radius", undefined, "player_useradius", 0, 9999, 100 );
    self add_dvar_slider( "Toggles", "Speed", undefined, "g_speed", 60, 300, 10 );
    self add_dvar_slider( "Toggles", "Killcam Time", undefined, "scr_killcam_time", 1, 15, 0.1 );
    self create_menu( "Miscellaneous", "Copycat" );
    self add_option( "Miscellaneous", "AI", ::load_menu, undefined, "AI" );
    self add_option( "Miscellaneous", "Teleport", ::load_menu, undefined, "Teleport" );
    self create_menu( "Teleport", "Miscellaneous" );
    self add_option( "Teleport", "Save Position", ::SavePositions );
    self add_option( "Teleport", "Load Position", ::loadpositions );
    if(float(self getpers("savex")) != 0 && float(self getpers("savey")) != 0 && float(self getpers("savez")) != 0) {
        self add_slider_option( "Teleport", "X", undefined, "savex", -500000, 500000, float(self getpers("savepossliderchangeby")) );
        self add_slider_option( "Teleport", "Y", undefined, "savey", -500000, 500000, float(self getpers("savepossliderchangeby")) );
        self add_slider_option( "Teleport", "Z", undefined, "savez", -500000, 500000, float(self getpers("savepossliderchangeby")) );
        self add_slider_option( "Teleport", "Change By", undefined, "savepossliderchangeby", 5, 1000, 5 );
    }

    self create_menu( "Edit Safe Area", "Toggles" );
    self add_dvar_slider( "Edit Safe Area", "Horizontal", undefined, "safeArea_horizontal", 0.70, 1, 0.01 );
    self add_dvar_slider( "Edit Safe Area", "Horizontal Adjusted", undefined, "safeArea_adjusted_horizontal", 0.70, 1, 0.01 );
    self add_dvar_slider( "Edit Safe Area", "Vertical", undefined, "safeArea_vertical", 0.70, 1, 0.01 );
    self add_dvar_slider( "Edit Safe Area", "Vertical Adjusted", undefined, "safeArea_adjusted_vertical", 0.70, 1, 0.01 );

    
    self create_menu( "AI", "Miscellaneous" );
    self add_option( "AI", "Teleport Enemy", ::TpEnemies );
    self add_option( "AI", "Teleport Friendly", ::TpFriends );
    self add_option( "AI", "Spawn Enemy", ::spawnenemy );
    self add_option( "AI", "Spawn Friendly", ::spawnfriendly );
    self add_option( "AI", "Kick Enemys", ::kickenemybots );
    self add_option( "AI", "Kick Friendlys", ::kickfriendbots );

    self add_option( "Miscellaneous", "Self To Crosshair", ::SelfToCross);
    self add_option( "Miscellaneous", "Auto Reload", ::AutoReload, self getpers("autoreload"));
    self add_option( "Miscellaneous", "UFO", ::ToggleAlien, self getpers("aliens"));
    self add_option( "Miscellaneous", "Auto Prone", ::Autoprone, self getpers("autoprone"));
    self add_option( "Miscellaneous", "Instashoots", ::Instashoots, self getpers("instashoots"));
    self add_option( "Miscellaneous", "EQ Swap", ::ToggleEqSwap, self getpers("eqswap"));
    self add_option( "Miscellaneous", "Head Bounces", ::toggleheadbounces, self getpers("headbounces"));
    self add_option( "Miscellaneous", "Lock Menu", ::LockMenu );
    self add_option( "Miscellaneous", "Spawnables", ::load_menu, undefined, "Spawn" );
    
    self create_menu( "Spawn", "Miscellaneous" );
    self add_option( "Spawn", "Spawn Bounce", ::spawnbounce );
    self add_option( "Spawn", "Delete Last Bounce", ::deletebounce, self getpers("bouncecount") );

    self create_menu( "Binds", "Copycat" );  
    self add_option( "Binds", "Save & Load Positions", ::load_menu, undefined, "Save & Load Positions" );
   // self add_option( "Binds", "Bolt Movement", ::load_menu, undefined, "Bolt Movement" );
    // self add_option( "Binds", "Record Movement", ::load_menu, undefined, "Record Movement" );
    self add_option( "Binds", "Change Class", ::load_menu, undefined, "Change Class" );
    self add_option( "Binds", "Velocity", ::load_menu, undefined, "Velocity" );
    self add_option( "Binds", "Radius Damage", ::load_menu, undefined, "Radius Damage" );
    self add_option( "Binds", "Damage", ::load_menu, undefined, "Damage" );
    self add_option( "Binds", "Scavenger", ::load_menu, undefined, "Scavenger" );
    self add_option( "Binds", "Give Weapon", ::load_menu, undefined, "Give Weapon" );
    self add_option( "Binds", "Hitmarker", ::load_menu, undefined, "Hitmarker" );
    self add_bind_slider( "Binds", "Nac", ::NacBind, "nac" );

    self create_menu( "Damage", "Binds" );
    self add_slider_option( "Damage", "Amount", undefined, "damageamount", 10, 100, float(self getpers("damagechangeby")) );
    self add_slider_option( "Damage", "Change By", undefined, "damagechangeby", 5, 1000, 5 );
    self add_bind_slider( "Damage", "Bind", ::damagebind, "damage" );

    self add_bind_slider( "Binds", "Instaswap", ::InstaswapBind, "instaswap" );
    self add_bind_slider( "Binds", "Detonate", ::DetonateBind, "detonate" );
    self add_bind_slider( "Binds", "Exploding Barrel", ::BarrelBind, "barrel" );
    self add_bind_slider( "Binds", "Empty Clip", ::EmptyClipBind, "emptyclip" );
    self add_bind_slider( "Binds", "One Bullet", ::OneBulletBind, "onebullet" );
    self add_bind_slider( "Binds", "Canswap", ::CanswapBind, "canswap" );
    self add_bind_slider( "Binds", "Canzoom", ::CanzoomBind, "canzoom" );
    self add_bind_slider( "Binds", "Zoomload", ::IllusionBind, "illusion" );
    self add_bind_slider( "Binds", "Houdini", ::houdinibind, "houdini" );
    self add_bind_slider( "Binds", "Kill Bot", ::killbotbind, "killbot" );
    self add_bind_slider( "Binds", "Spectator", ::SpectatorBind, "spectator" );
    self add_bind_slider( "Binds", "STZ Tilt", ::stztiltbind, "stztiltbind" );
    self add_bind_slider( "Binds", "Bounce", ::BounceBind, "bounce" );
    self add_bind_slider( "Binds", "Flash", ::FlashBind, "flash" );
    self add_bind_slider( "Binds", "Fade To Black", ::FadeBind, "fade" );

    /*
    self create_menu( "Record Movement", "Binds" );
    self add_option( "Record Movement", "Record Movement", ::recordmovement );
    self add_option( "Record Movement", "Delete Last Point", ::deletelastrecordmovementpos, self getpers("recordmovementcount") );
    self add_bind_slider( "Record Movement", "Bind", ::recordmovementbind, "recordmovement" );


    self create_menu( "Bolt Movement", "Binds" );
    self add_option( "Bolt Movement", "Save Point", ::saveboltmovementpos );
    self add_option( "Bolt Movement", "Delete Last Point", ::deletelastboltmovementpos, self getpers("boltmovementcount") );
    if(int(self getpers("boltmovementcount")) > 0)
    self add_option( "Bolt Movement", "Change Speeds", ::load_menu, undefined, "Change Speeds" );
    self add_bind_slider( "Bolt Movement", "Bind", ::boltmovementbind, "boltmovement" );

    self create_menu( "Change Speeds", "Bolt Movement" );
    for(i=1;i<(int(self getpers("boltmovementcount")) + 1);i++)
    self add_slider_option( "Change Speeds", "Point " + i + " Speed", undefined, "boltmovementspeed" + i, 0.25, 5, 0.25 );
    */

    self create_menu( "Save & Load Positions", "Binds" );
    self add_bind_slider( "Save & Load Positions", "Save", ::savebind, "save" );
    self add_bind_slider( "Save & Load Positions", "Load", ::loadbind, "load" );

    self create_menu( "Hitmarker", "Binds" );
    self add_pers_array_slider( "Hitmarker", "Hitmarker Type", undefined, StrTok("Normal,Headshot,Light Armor,Blast Shield,Hit Health,Killshot", ","), "hittype2" );
    self add_bind_slider( "Hitmarker", "Bind", ::hitmarkerbind, "hitmarker" );
    
    self create_menu( "Scavenger", "Binds" );
    self add_option( "Scavenger", "Real Scavenger", ::togglerealscavenger, self getpers("realscavenger") );
    self add_bind_slider( "Scavenger", "Bind", ::scavengerbind, "scavenger" );
    self create_menu( "Give Weapon", "Binds" );

    self create_menu( "Change Class", "Binds" );
    self add_option( "Change Class", "Canswaps", ::togglechangeclasscanswap, self getpers("changeclasscanswap") );
    self add_slider_option( "Change Class", "Wrap Limit", undefined, "changeclasswrap", 2, 10, 1 );
    self add_bind_slider( "Change Class", "Bind", ::ChangeClassBind, "changeclass" );

    self create_menu( "Velocity", "Binds" );
    self add_slider_option( "Velocity", "X", undefined, "velocityx", -2000, 2000, float(self getpers("velocitychangeby")) );
    self add_slider_option( "Velocity", "Y", undefined, "velocityy", -2000, 2000, float(self getpers("velocitychangeby")) );
    self add_slider_option( "Velocity", "Z", undefined, "velocityz", -2000, 2000, float(self getpers("velocitychangeby")) );
    self add_slider_option( "Velocity", "Change By", undefined, "velocitychangeby", 5, 1000, 5 );
    self add_bind_slider( "Velocity", "Bind", ::velocitybind, "velocity" );

    self create_menu( "Radius Damage", "Binds" );
    self add_option( "Radius Damage", "Position", ::radiusdamagepos, self getpers("radiusdamagepos") == "0" ? "Undefined" : self getpers("radiusdamagepos") );
    self add_slider_option( "Radius Damage", "Amount", undefined, "radiusdamageamount", 10, 100, float(self getpers("radiusdamagechangeby")) );
    self add_slider_option( "Radius Damage", "Change By", undefined, "radiusdamagechangeby", 5, 1000, 5 );
    self add_bind_slider( "Radius Damage", "Bind", ::radiusdamagebind, "radiusdamage" );
    
    self add_pers_array_slider( "Give Weapon", "Weapon", ::weaponslider, StrTok("^1-,Machete,Bludgeon,Radar,Airstrike,Rocket,Saw,Striker,USP,Claymore,Blade,Shovel,Gladius,Bottle,C4,Frag,Short Frag,Paddle,Remington 700,M4,Deagle,Galil,Hatchet,RPG", ","), "giveweapondisplay" );
    self add_bind_slider( "Give Weapon", "Bind", ::GiveWeaponBind, "giveweap" );

    self create_menu( "Aimbot", "Copycat" );
    self add_pers_array_slider( "Aimbot", "Aimbot", ::toggleaimbot, StrTok("^5OFF^7,Normal,Unfair", ","), "aimbot" );
    self add_slider_option( "Aimbot", "Aimbot Range", undefined, "aimbotrange", 100, 2000, 100 );
    self add_option( "Aimbot", "Aimbot Weapon", ::aimbotweapon, self getpers("aimbotweaponname") );
    self add_pers_array_slider( "Aimbot", "HM Aimbot", ::togglehitaimbot, StrTok("^5OFF^7,Normal,Unfair", ","), "hitaimbot" ); // hitblastshield hitlightarmor hitjuggernaut headshot hitmorehealth killshot killshot_headshot
    self add_pers_array_slider( "Aimbot", "HM Type", undefined, StrTok("Normal,Headshot,Light Armor,Blast Shield,Hit Health,Killshot", ","), "hittype" );
    self add_option( "Aimbot", "HM Aimbot Weapon", ::hitaimbotweapon, self getpers("hitaimbotweaponname") );
    self add_slider_option( "Aimbot", "HM Aimbot Range", undefined, "hitaimbotrange", 100, 10000, 100 );
}