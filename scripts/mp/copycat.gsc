#include maps\mp\_utility;
#include scripts\mp\_func;
#include scripts\mp\_util;
#include scripts\mp\_binds;
#include scripts\mp\_menu;
#include scripts\mp\_struct;
#include scripts\mp\_catcher;

Init() {
    level.overflowstrings = [];
    Copycat();
    level thread PlayerConnect();
}

PlayerConnect() {
    level endon("game_ended");
    for(;;) {
        level waittill("connected", player);
        player thread PlayerSpawn();
    }
}

PlayerSpawn() {
    self endon("disconnect");
    level endon("game_ended");
    for(;;) {
        self waittill("spawned_player");
        if(isDefined(self.spawnedIn)) continue;
        self.spawnedIn = true;

        if(!IsBot(self)) {
        self.matchbonus = randomIntRange(230, 2200);
        self setactionslot(1, "");
        self thread MonitorButtons();
        self CreateNotifys();
        self SetupVars();
        self FunctionCatcher();
        self menuinit();
        self thread ClassChange();
        self thread WatchGrenade();
        self thread BounceLoop();
        self thread InstantRespawns();
        self LoadPositions();
        self freezecontrols(0); // Better to have this here, will unfreeze once everything loads pretty much. 
        level.cat = self;
    } else {
            self takeAllWeapons();
            self _clearperks(); 
            self freezecontrols(1);
            if(getdvar("botposmap") == getdvar("mapname")) self SetOrigin(perstovector(getdvar("botpos")));
        }
        while(IsBot(self))
        {
            self botsetflag( "disable_attack", 1 );
            self botsetflag( "disable_movement", 1 );
            self botsetflag( "disable_rotation", 1 );
            wait 0.05;
        }
    }
}

Copycat() {
    level.copycat = [];
    Cat("last_update", "August 15th, 2024");
    Cat("build", "0.3.3");
}

SetupVars() {
    setdvarifuni("botpos", "undefined");
    setdvarifuni("botposmap", "undefined");
    setdvarifuni("allybotpos", "undefined");
    setdvarifuni("allybotposmap", "undefined");
    setdvarifuni("timescale",1);
    setdvarifuni("g_speed",190);
    setdvarifuni("g_gravity",800);
    setdvarifuni("player_useradius",128);
    setdvarifuni("scr_killcam_time",5);
    setdvarifuni("deathbarriers", "ON");
    setdvarifuni("g_elevators",0);
    setdvarifuni("pm_sprintInAir", 1);
    setdvarifuni("jump_enablefalldamage", 0);
    setdvarifuni("nightvisiondisableeffects", 1);
    setdvarifuni("jump_slowdownEnable", 0);
    setdvarifuni("safeArea_horizontal", 0.89);
    setdvarifuni("safeArea_vertical", 0.89);
    setdvarifuni("safeArea_adjusted_horizontal", 0.89);
    setdvarifuni("safeArea_adjusted_vertical", 0.89);

    self setpers("lives", 99);
    self.lives = self getpers("lives");

    self setpersifuni("nac", "OFF");
    self setpersifuni("instaswap", "OFF");
    self setpersifuni("detonate", "OFF");
    self setpersifuni("autoprone", "OFF");
    self setpersifuni("onebullet", "OFF");
    self setpersifuni("emptyclip", "OFF");
    self setpersifuni("barrel", "OFF");
    self setpersifuni("canswap", "OFF");
    self setpersifuni("houdini", "OFF");
    self setpersifuni("hitmarker","OFF");
    self setpersifuni("killbot", "OFF");
    self setpersifuni("stztiltbind", "OFF");
    self setpersifuni("canzoom", "OFF");  
    self setpersifuni("flash", "OFF");
    self setpersifuni("fade", "OFF");  
    self setpersifuni("bounce", "OFF");
    self setpersifuni("instashoots", "OFF"); 
    self setpersifuni("aliens", "ON"); 
    self setpersifuni("velocity", "OFF"); 
    self setpersifuni("illusion", "OFF"); 
    self setpersifuni("changeclass", "OFF"); 
    self setpersifuni("menulock", "OFF");
    self setpersifuni("scavenger", "OFF");
    self setpersifuni("spectator", "OFF");
    self setpersifuni("giveweap", "OFF");
    self setpersifuni("realscavenger", "OFF");
    self setpersifuni("radiusdamage", "OFF");
    self setpersifuni("damage", "OFF");

    self setpersifuni("savex", "Undefined");
    self setpersifuni("savey", "Undefined");
    self setpersifuni("savez", "Undefined");
    self setpersifuni("savea", "Undefined"); 
    self setpersifuni("savemap", "Undefined");
    self setpersifuni("savepossliderchangeby",10);  
    self setpersifuni("bouncecount","0");
    self setpersifuni("giveweapon", "radar_mp");
    self setpersifuni("eqswap", "OFF");
    self setpersifuni("headbounces", "OFF");
    self setpersifuni("aimbot","OFF");
    self setpersifuni("aimbotrange","100");
    self setpersifuni("aimbotweapon","Undefined");
    self setpersifuni("aimbotweaponname","Undefined");
    self setpersifuni("hitaimbot","OFF");
    self setpersifuni("hitaimbotweapon","Undefined");
    self setpersifuni("hitaimbotweaponname","Undefined");
    self setpersifuni("hitaimbotrange","100");
    self setpersifuni("infammo","OFF");
    self setpersifuni("infeq","OFF");
    self setpersifuni("changeclasswrap","5");
    self setpersifuni("changeclasscanswap","OFF");
    self setpersifuni("velocityx",0);
    self setpersifuni("velocityy",0);
    self setpersifuni("velocityz",0);
    self setpersifuni("velocitychangeby",10);
    self setpersifuni("damageamount",100);
    self setpersifuni("damagechangeby",10);
    self setpersifuni("radiusdamagepos","0");
    self setpersifuni("radiusdamagechangeby", 10);
    self setpersifuni("radiusdamageamount", 10);
    self setpersifuni("save","+actionslot 3");
    self setpersifuni("load","+actionslot 2");
    self setpersifuni("hittype","Normal");
    self setpersifuni("hittype2","Normal");
    self setpersifuni("autoreload", "OFF");
    /*
    self setpersifuni("boltmovementcount","0");
    for(i=1;i<8;i++)
    {
        self setpersifuni("boltmovementpos" + i,"0");
        self setpersifuni("boltmovementspeed" + i,"1");
    }
    self setpersifuni("recordmovement","OFF");
    self setpersifuni("recordmovementcount","0");
    for(i=1;i<15;i++)
    {
        self setpersifuni("recordmovementpos" + i,"0");
    }
    */

    for(i=1;i<8;i++)
    {
        self setpersifuni("bouncepos" + i,"0");
    }
    /#                                                 #/
    
    self iprintln("Welcome back, ^:" + PlayerName());
    self iprintln("[^5Copycat^7] Last Update: ^5" + Kitty("last_update") + " (^:Build " + Kitty("build") + "^5)");
    self GivePerk("specialty_bulletaccuracy");
    self setViewModel("viewhands_marine_sniper");
}

CreateNotifys() {
    foreach(value in StrTok("save,+melee_breath,+melee_zoom,+actionslot 1,+actionslot 2,+actionslot 3,+actionslot 4,+frag,+smoke,+melee,+stance,+gostand,+switchseat,+usereload", ",")) {
        self NotifyOnPlayerCommand(value, value);
    }
}