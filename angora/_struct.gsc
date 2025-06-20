#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include angora\_func;
#include angora\_util;
#include angora\_binds;
#include angora\_menu;

Structure() {
    self create_menu( "Copycat", "exit" );
    self add_option( "Copycat", "Preference", ::load_menu, undefined, "Preference" );
    self add_option( "Copycat", "Match", ::load_menu, undefined, "Match" );
    self add_option( "Copycat", "Teleport", ::load_menu, undefined, "Teleport" );
    self add_option( "Copycat", "Class", ::load_menu, undefined, "Class" );
    self add_option( "Copycat", "Killstreaks", ::load_menu, undefined, "Killstreaks" );
    if(!IsSnr()) self add_option( "Copycat", "Binds", ::load_menu, undefined, "Binds" );
    // self add_option( "Copycat", "Maps", ::load_menu, undefined, "Maps" );
    if(!IsSnr()) self add_option( "Copycat", "Aimbot", ::load_menu, undefined, "Aimbot");
    self add_option( "Copycat", "AI", ::load_menu, undefined, "AI" );
    if(self isHost()) self add_option( "Copycat", "Players", ::load_menu, undefined, "Players");

    self create_menu( "Class", "Copycat" );
    self add_option( "Class", "Take Weapon", ::TWeapon, self getpers("takeweapon") );
   // if(!IsSnr()) self add_option( "Class", "Killstreaks", ::load_menu, undefined, "Killstreaks" );
    // self add_option( "Class", "Perks", ::load_menu, undefined, "Perks" );
    //if(!IsSnr()) self create_menu( "Killstreaks", "Class" );
    self create_menu( "Killstreaks", "Copycat" );
    self add_option( "Killstreaks", "UAV", ::givestreak, undefined, "radar_mp");
    self add_option( "Killstreaks", "Care Package", ::givestreak, undefined, "airdrop_marker_mp");
    self add_option( "Killstreaks", "Predator Missile", ::givestreak, undefined, "predator_mp");
    self add_option( "Killstreaks", "Airstrike", ::givestreak, undefined, "airstrike_mp");
    self add_option( "Killstreaks", "Counter UAV", ::givestreak, undefined, "counter_radar_mp");
    self add_option( "Killstreaks", "AC130", ::givestreak, undefined, "ac130_mp");
    self add_option( "Killstreaks", "EMP", ::givestreak, undefined, "emp_mp");
    self add_option( "Killstreaks", "Nuke", ::givestreak, undefined, "nuke_mp");
    self add_option( "Killstreaks", "Pave Low", ::givestreak, undefined, "pavelow_mp");
    self add_option( "Killstreaks", "Harrier", ::givestreak, undefined, "harrier_airstrike_mp");
    self add_option( "Killstreaks", "Stealth Bomber", ::givestreak, undefined, "stealth_airstrike_mp");
    self add_option( "Killstreaks", "Sentry", ::givestreak, undefined, "sentry_mp");
    
    self add_option("Class", "Infected", ::GWeapon, undefined, "h2_infect_mp");
    foreach(weapon in level.weaponlist) { 
        //if(IsAGrenade(weapon)) return;
        self add_option("Class", getweapondisplayname(weapon), ::GWeapon, "^1", weapon);
    }

    self create_menu( "Match", "Copycat" );
    self add_option( "Match", "Dvar Sliders", ::load_menu, undefined, "Dvars" );
    self create_menu( "Dvars", "Match" );
    self add_dvar_slider( "Dvars", "Gravity", undefined, "g_gravity", 100, 1500, 25 );
    self add_dvar_slider( "Dvars", "Time Scale", ::ChangeTimescale, "timescale", 0.25, 10, 0.25 );
    self add_dvar_slider( "Dvars", "Use Radius", undefined, "player_useradius", 0, 9999, 100 );
    self add_dvar_slider( "Dvars", "Speed", undefined, "g_speed", 60, 300, 10 );
    self add_dvar_slider( "Dvars", "Killcam Time", undefined, "scr_killcam_time", 1, 15, 0.1 );

    if(self isHost()) self add_option( "Match", "SNR Mode", ::toggle_snr, getDvar("snr"));
    self add_option( "Match", "All Angle Bounces", ::toggle_aabounces, getdvarint("pm_bouncingAllAngles") ? "ON" : "OFF" );
    self add_option( "Match", "Death Barriers", ::ToggleBarriers, getdvar("deathbarriers") );
    self add_option( "Match", "Elevators", ::toggleg_elevators, getdvarint("g_enableElevators") ? "ON" : "OFF" );
    self add_option( "Match", "Sprint Mid Air", ::toggle_sprintair, getdvarint("pm_sprintInAir") ? "ON" : "OFF" );
    self add_option( "Match", "Softlands", ::toggle_falldmg, getdvarint("jump_enablefalldamage") ? "OFF" : "ON" );
    //self add_option( "Match", "Fix Airspace", ::toggle_air, self getpers("air"));
    //self add_option( "Match", "Disable Nightvision", ::toggle_nv, getdvarint("nightvisiondisableeffects") ? "ON" : "OFF" );
    self add_option( "Match", "Jump Slowdown", ::toggle_jumpslowdown, getdvarint("jump_slowdownEnable") ? "ON" : "OFF" );
    self add_option( "Match", "Double XP", ::toggle_doublexp, getdvarint("doublexp") ? "ON" : "OFF" );

    self create_menu( "Preference", "Copycat" );
    if(PlayerName() == "angora") self add_option( "Preference", "Watch Position", ::WatchPos );
    self add_option( "Preference", "Altswap", ::load_menu, undefined, "Altswap" );
    self add_option( "Preference", "Spawnables", ::load_menu, undefined, "Spawn" );
    self add_option( "Preference", "Self To Crosshair", ::SelfToCross);
    self add_option( "Preference", "Sentry Glitch", ::SentryGlitchFunc);
    self add_option( "Preference", "Fast Last", ::AutoLast);
    self add_option( "Preference", "Take Weapon", ::TW);
    self add_option( "Preference", "Drop Canswap", ::DropCanswap);
    self add_option( "Preference", "Lock Menu", ::LockMenu);
    self add_pers_array_slider( "Preference", "Auto Prone", ::AutoProne, StrTok("^1-,Always,Game End", ","), "autoprone" );
    self add_pers_array_slider( "Preference", "Infinite Ammo", ::toggleinfammo, StrTok("^1-,Continuous,On Reload", ","), "infammo" );
    self add_option( "Preference", "Infinite Equipment", ::toggleinfeq, self getpers("infeq") );
    // self add_option( "Preference", "Invincibility", ::toggle_god, self getpers("god"));
    self add_option( "Preference", "Sleight Of Hand", ::ToggleSOH, self getpers("soh"));
    self add_option( "Preference", "Auto Reload", ::AutoReload, self getpers("autoreload"));
    self add_option( "Preference", "Auto Refill", ::AutoRefill, self getpers("refill"));
    self add_option( "Preference", "EQ Swap", ::ToggleEqSwap, self getpers("eqswap"));
    self add_option( "Preference", "UFO", ::ToggleAlien, self getpers("aliens"));
    self add_option( "Preference", "Fake Lunges", ::ToggleLunges, self getpers("lunges"));
    self add_option( "Preference", "Instashoots", ::Instashoots, self getpers("instashoots"));
    self add_option( "Preference", "Head Bounces", ::toggleheadbounces, self getpers("headbounces"));


    self create_menu( "Teleport", "Copycat" );
    self add_option( "Teleport", "Save Position", ::SavePositions );
    self add_option( "Teleport", "Load Position", ::loadpositions );
    
    if(float(self getpers("savex")) != 0 && float(self getpers("savey")) != 0 && float(self getpers("savez")) != 0) {
        self add_slider_option( "Teleport", "X", undefined, "savex", -500000, 500000, float(self getpers("savepossliderchangeby")) );
        self add_slider_option( "Teleport", "Y", undefined, "savey", -500000, 500000, float(self getpers("savepossliderchangeby")) );
        self add_slider_option( "Teleport", "Z", undefined, "savez", -500000, 500000, float(self getpers("savepossliderchangeby")) );
        self add_slider_option( "Teleport", "Change By", undefined, "savepossliderchangeby", 5, 1000, 5 );
    }

    self create_menu( "AI", "Copycat" );
    self add_option( "AI", "Spawn", ::SpawnAI, undefined, getotherteam(self.team));
    self add_option( "AI", "Teleport", ::TpEnemies );
    self add_option( "AI", "Kick", ::kickenemybots );
    
    self create_menu( "Altswap", "Preference" );
    self add_option( "Altswap", "Altswap", ::ToggleAltSwaps, self getpers("altswap"));
    self add_option( "Altswap", "Choose Weapon", ::load_menu, undefined, "Altswap Weapon" );
    self create_menu( "Altswap Weapon", "Altswap" );
    
    
    self add_option("Altswap Weapon", "Infected", ::altswapweapon, "^1", "h2_infect_mp");

    foreach(weapon in level.weaponlist) { 
        self add_option("Altswap Weapon", getweapondisplayname(weapon), ::altswapweapon, "^1", weapon);
    }

    //self add_option( "Altswap", "Current Weapon", ::AltswapWeapon, WeaponDisplay(self getpers("altswapweapon")));
    self create_menu( "Spawn", "Preference" );
    self add_option( "Spawn", "Bounces", ::load_menu, undefined, "Bounces" );
    self create_menu( "Bounces", "Copycat" );
    self add_option( "Bounces", "Spawn Bounce", ::spawnbounce );
    self add_option( "Bounces", "Delete Last Bounce", ::deletebounce, self getpers("bouncecount") );

    self create_menu( "Binds", "Copycat" );  
    self add_option( "Binds", "Save & Load Positions", ::load_menu, undefined, "Save & Load Positions" );
    self add_option( "Binds", "Change Class", ::load_menu, undefined, "Change Class" );
    self add_option( "Binds", "Velocity", ::load_menu, undefined, "Velocity" );
    self add_option( "Binds", "Bolt Movement", ::load_menu, undefined, "Bolt Movement" );
    self add_option( "Binds", "Record Movement", ::load_menu, undefined, "Record Movement" );
    self add_option( "Binds", "Radius Damage", ::load_menu, undefined, "Radius Damage" );
    self add_option( "Binds", "Damage", ::load_menu, undefined, "Damage" );
    self add_option( "Binds", "Scavenger", ::load_menu, undefined, "Scavenger" );
    self add_option( "Binds", "Give Weapon", ::load_menu, undefined, "Give Weapon" );
    self add_option( "Binds", "Hitmarker", ::load_menu, undefined, "Hitmarker" );
    self add_option( "Binds", "Exploding Barrel", ::load_menu, undefined, "Exploding Barrel" );
    self add_option( "Binds", "Detonate", ::load_menu, undefined, "Detonate" );
    self add_bind_slider( "Binds", "Infinite Nac", ::NacBind, "nac" );
    self add_bind_slider( "Binds", "Smooth Anims", ::SmoothBind, "smooth" );
    self add_bind_slider( "Damage", "Bind", ::damagebind, "damage" );
    self add_bind_slider( "Binds", "Damage Repeater", ::DamageRepeaterBind, "damagerepeater" );
    self add_bind_slider( "Binds", "Repeater", ::RepeaterBind, "repeater" );
    self add_bind_slider( "Binds", "Reverse Elevator", ::ReverseEleBind, "reverse" );
    self add_bind_slider( "Binds", "Instaswap", ::InstaswapBind, "instaswap" );
    self add_bind_slider( "Binds", "Zoomload", ::IllusionBind, "illusion" );
    self add_bind_slider( "Binds", "Fake Flip", ::FakeFlipBind, "fakeflip" );
    self add_bind_slider( "Binds", "Empty Clip", ::EmptyClipBind, "emptyclip" );
    self add_bind_slider( "Binds", "One Bullet", ::OneBulletBind, "onebullet" );
    self add_bind_slider( "Binds", "Canswap", ::CanswapBind, "canswap" );
    self add_bind_slider( "Binds", "Unlink", ::UnlinkBind, "unlinkbind" );
    self add_bind_slider( "Binds", "Canzoom", ::CanzoomBind, "canzoom" );
    self add_bind_slider( "Binds", "Houdini", ::houdinibind, "houdini" );
    self add_bind_slider( "Binds", "Kill Bot", ::killbotbind, "killbot" );
    self add_bind_slider( "Binds", "Spectator", ::SpectatorBind, "spectator" );
    self add_bind_slider( "Binds", "STZ Tilt", ::stztiltbind, "stztiltbind" );
    self add_bind_slider( "Binds", "Bounce", ::BounceBind, "bounce" );
    self add_bind_slider( "Binds", "Flash", ::FlashBind, "flash" );
    self add_bind_slider( "Binds", "Fade To Black", ::FadeBind, "fade" );

    self create_menu( "Detonate", "Binds" );
    self add_slider_option( "Detonate", "Wait Time", undefined, "detonatewait", 0, 3, 0.5 );
    self add_bind_slider( "Detonate", "Bind", ::DetonateBind, "detonate" );
    self create_menu( "Exploding Barrel", "Binds" );
    self add_slider_option( "Exploding Barrel", "Wait Time", undefined, "barrelwait", 0, 3, 0.5 );
    self add_bind_slider( "Exploding Barrel", "Bind", ::BarrelBind, "barrel" );

    self create_menu( "Damage", "Binds" );
    self add_slider_option( "Damage", "Amount", undefined, "damageamount", 10, 100, float(self getpers("damagechangeby")) );
    self add_slider_option( "Damage", "Change By", undefined, "damagechangeby", 5, 1000, 5 );

    self create_menu( "Save & Load Positions", "Binds" );
    self add_bind_slider( "Save & Load Positions", "Save", ::savebind, "save" );
    self add_bind_slider( "Save & Load Positions", "Load", ::loadbind, "load" );

    self create_menu( "Hitmarker", "Binds" );
    self add_pers_array_slider( "Hitmarker", "Hitmarker Type", undefined, StrTok("Normal,Headshot", ","), "hittype2" );
    self add_bind_slider( "Hitmarker", "Bind", ::hitmarkerbind, "hitmarker" );
    
    self create_menu( "Scavenger", "Binds" );
    self add_option( "Scavenger", "Real Scavenger", ::togglerealscavenger, self getpers("realscavenger") );
    self add_bind_slider( "Scavenger", "Bind", ::scavengerbind, "scavenger" );

    self create_menu( "Change Class", "Binds" );
    self add_option( "Change Class", "Canswap", ::togglechangeclasscanswap, self getpers("changeclasscanswap") );
    self add_option( "Change Class", "Zoomload", ::togglechangeclasszoomload, self getpers("changeclasszoomload") );
    self add_option( "Change Class", "Empty Clip", ::togglechangeclassemptyclip, self getpers("changeclassemptyclip") );
    self add_option( "Change Class", "One Bullet", ::togglechangeclassonebullet, self getpers("changeclassonebullet") );
    self add_slider_option( "Change Class", "Wrap Limit", undefined, "changeclasswrap", 2, 10, 1 );
    self add_bind_slider( "Change Class", "Bind", ::ChangeClassBind, "changeclass" );

    self create_menu( "Record Movement", "Binds" );
    self add_option( "Record Movement", "Record Movement", ::recordmovement );
    self add_option( "Record Movement", "Delete Last Point", ::deletelastrecordmovementpos, self getpers("recordmovementcount") );
    self add_bind_slider( "Record Movement", "Bind", ::recordmovementbind, "recordmovement" );


    self create_menu( "Bolt Movement", "Binds" );
    self add_option( "Bolt Movement", "Save Point", ::saveboltmovementpos );
    self add_option( "Bolt Movement", "Delete Last Point", ::deletelastboltmovementpos, self getpers("boltmovementcount") );
    if(int(self getpers("boltmovementcount")) > 0) {
    self add_option( "Bolt Movement", "Change Speeds", ::load_menu, undefined, "Change Speeds" );
    self add_option( "Bolt Movement", "Play Bolt", ::dobolt );
    }
    self add_bind_slider( "Bolt Movement", "Bind", ::boltmovementbind, "boltmovement" );

    self create_menu( "Change Speeds", "Bolt Movement" );
    for(i=1;i<(int(self getpers("boltmovementcount")) + 1);i++)
    self add_slider_option( "Change Speeds", "Point " + i + " Speed", undefined, "boltmovementspeed" + i, 0.25, 5, 0.25 );

    self create_menu( "Velocity", "Binds" );
    self add_slider_option( "Velocity", "X", undefined, "velocityx", -2000, 2000, float(self getpers("velocitychangeby")) );
    self add_slider_option( "Velocity", "Y", undefined, "velocityy", -2000, 2000, float(self getpers("velocitychangeby")) );
    self add_slider_option( "Velocity", "Z", undefined, "velocityz", -2000, 2000, float(self getpers("velocitychangeby")) );
    self add_slider_option( "Velocity", "Change By", undefined, "velocitychangeby", 5, 1000, 5 );
    self add_bind_slider( "Velocity", "Bind", ::velocitybind, "velocity" );
    if(float(self getpers("velocityx")) != 0 || float(self getpers("velocityy")) != 0 || float(self getpers("velocityz")) != 0 ) self add_option( "Velocity", "Play Velocity", ::playvelocity, float(self getpers("velocityx")) + " | " + float(self getpers("velocityy")) + " | " + float(self getpers("velocityz")));
    
    self create_menu( "Radius Damage", "Binds" );
    self add_option( "Radius Damage", "Position", ::radiusdamagepos, self getpers("radiusdamagepos") == "0" ? "Undefined" : self getpers("radiusdamagepos") );
    self add_slider_option( "Radius Damage", "Amount", undefined, "radiusdamageamount", 10, 100, float(self getpers("radiusdamagechangeby")) );
    self add_slider_option( "Radius Damage", "Change By", undefined, "radiusdamagechangeby", 5, 1000, 5 );
    self add_bind_slider( "Radius Damage", "Bind", ::radiusdamagebind, "radiusdamage" );

    self create_menu( "Give Weapon", "Binds" );
    self add_option( "Give Weapon", "Choose Weapon", ::load_menu, undefined, "Choose Weapon" );
    self add_bind_slider( "Give Weapon", "Bind", ::GiveWeaponBind, "giveweap" );
    self create_menu( "Choose Weapon", "Give Weapon" );

    self add_option("Choose Weapon", "Infected", ::giveweapfuncs, undefined, "h2_infect_mp");
    foreach(weapon in level.weaponlist) { 
        self add_option("Choose Weapon", getweapondisplayname(weapon), ::giveweapfuncs, "^1", weapon);
    }

    self create_menu( "Aimbot", "Copycat" );
    self add_option( "Aimbot", "All Snipers", ::sniperaimbot, self getpers("sniperaimbot") );
    self add_pers_array_slider( "Aimbot", "Aimbot", ::toggleaimbot, StrTok("^1-,Normal,Unfair", ","), "aimbot" );
    self add_slider_option( "Aimbot", "Aimbot Range", undefined, "aimbotrange", 100, 2000, 100 );
    self add_slider_option( "Aimbot", "Aimbot Delay", undefined, "aimbotdelay", 0.00, 5.00, 0.1 );
    self add_option( "Aimbot", "Aimbot Weapon", ::aimbotweapon, self getpers("aimbotweaponname") );
    self add_pers_array_slider( "Aimbot", "HM Aimbot", ::togglehitaimbot, StrTok("^1-,Normal,Unfair", ","), "hitaimbot" ); // hitblastshield hitlightarmor hitjuggernaut headshot hitmorehealth killshot killshot_headshot
    self add_pers_array_slider( "Aimbot", "HM Type", undefined, StrTok("Normal,Headshot", ","), "hittype" );
    self add_option( "Aimbot", "HM Aimbot Weapon", ::hitaimbotweapon, self getpers("hitaimbotweaponname") );
    self add_slider_option( "Aimbot", "HM Aimbot Range", undefined, "hitaimbotrange", 100, 10000, 100 );

    self create_menu( "Players", "Copycat" );
    foreach(player in level.players) {
        self add_option( "Players",  player.name, ::load_menu, undefined, player.name );
        self create_menu( player.name, "Players" );
        self add_option( player.name,  "To Crosshair", ::tocross_func, undefined, player );
        if(IsBot(player)) self add_option( player.name,  "Save Position", ::savebot_func, undefined, player );
        self add_option( player.name,  "Look At Me", ::look_func, undefined, player );
        self add_option( player.name,  "Kick", ::kick_func, undefined, player );
        }
}