#include maps\mp\_utility;
#include angora\_func;
#include angora\_util;
#include angora\_binds;
#include angora\_menu;
#include angora\_struct;
#include angora\_catcher;

Init() {
    setdvarifuni("axisname", "^:+");
    setdvarifuni("allyname", "^:-");
    setdvar("xblive_privatematch", 1);
    preCacheModel("body_infect");
    preCacheModel("body_hazmat");
    preCacheModel("viewhands_infect");
    preCacheModel("viewhands_hazmat");
    preCacheModel("vestlight");
    precacheitem("h2_infect_mp");

    Copycat();
    level thread PlayerConnect();
    level thread RandomRound();
    aw_replace(1);
	wait 1;
    aw_replace(2);
}

Copycat() {
	level.botcount = 0;
    Cat("last_update", "September 6th, 2024");
    Cat("build", "0.8");
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
        if(IsBot(self)) {
        if(getdvar("botposmap") == getdvar("mapname") && getDvar("snr") != "ON") 
        self SetOrigin(PersToVector(getdvar("botpos")));
        self InfectedModel();
        } else {
        self H2FreezeWrapper(0);
        self LoadPositions();
        self giveperk("specialty_longersprint");
        self giveperk("specialty_unlimitedsprint");
        self giveperk("specialty_fastsprintrecovery");
        self giveperk("specialty_falldamage");
        self giveperk("specialty_bulletpenetration");
        self thread ModelCycle();
        }
        if(isDefined(self.spawnedIn)) continue;
        self.spawnedIn = true;
        if(!IsBot(self)) {
        self thread MonitorButtons();
        self CreateNotifys();
        self SetupVars();
        self FunctionCatcher();
        self menuinit();
        self thread ZombieSounds();
        self thread ClassChange();
        self thread WatchGrenade();
        self thread WatchBounces();
        self thread DisableNightVision();
        self thread ThirdPersonFix();
        self thread TimerPause();
        self thread NadeMonitor();
        self thread WatchAmmo();
        self thread TakeMonitor();
        self thread MapBounces();
        self thread MapElevators();
        self thread UnlinkOnEnd();
        self thread PMCrashFix();
        // Enabling online classes glitches out restarts & menu sometimes
        self thread WatchPM();
        self OverflowFixInit();
        if(self isHost()) {
            if(!isDefined(self.pers["ini"])) {
            self setpers("ini", true);
            self CallDvars();
           // self thread SpawnAI("allies");
        }
            self WatchMyTeam();
        }
    } else {
            self thread AIClasses(8,25); // Class Cycle + Time - 0.7.1
            if(getdvar("botposmap") == getdvar("mapname")) self SetOrigin(PersToVector(getdvar("botpos")));
        }
        while(IsBot(self)) {
            if(getDvar("g_gametype") != "dm") {
            if(getDvar("snr") == "OFF") { // 0.6.3
            self SetFlags(0);
            if(getdvar("botposmap") == getdvar("mapname")) self SetOrigin(PersToVector(getdvar("botpos")));
            } else {
            self SetFlags(1);
            }
            }
            wait 0.05;
        }
    }
}

SetupVars() {
    self SetupBind("nac", "OFF", ::NacBind);
    self SetupBind("unlinkbind", "OFF", ::UnlinkBind);
    self SetupBind("instaswap", "OFF", ::InstaswapBind);
    self SetupBind("emptyclip", "OFF", ::EmptyClipBind);
    self SetupBind("detonate", "OFF", ::DetonateBind);
    self SetupBind("canswap", "OFF", ::CanswapBind);
    self SetupBind("canzoom", "OFF", ::CanzoomBind);
    self SetupBind("radiusdamage", "OFF", ::RadiusDamageBind);
    self SetupBind("changeclass", "OFF", ::ChangeClassBind);
    self SetupBind("houdini", "OFF", ::HoudiniBind);
    self SetupBind("stztiltbind", "OFF", ::StzTiltBind);
    self SetupBind("hitmarker", "OFF", ::HitmarkerBind);
    self SetupBind("killbot", "OFF", ::KillBotBind);
    self SetupBind("velocity", "OFF", ::VelocityBind);
    self SetupBind("canswap", "OFF", ::CanswapBind);
    self SetupBind("illusion", "OFF", ::IllusionBind);
    self SetupBind("bounce", "OFF", ::BounceBind);
    self SetupBind("damage", "OFF", ::DamageBind);
    self SetupBind("barrel", "OFF", ::BarrelBind);
    self SetupBind("flash", "OFF", ::FlashBind);
    self SetupBind("save", "+actionslot 3", ::SaveBind);
    self SetupBind("load", "+actionslot 2", ::LoadBind);
    self SetupBind("giveweap", "OFF", ::GiveWeaponBind);
    self SetupBind("spectator", "OFF", ::SpectatorBind);
    self SetupBind("fade", "OFF", ::FadeBind);
    self SetupBind("scavenger", "OFF", ::ScavengerBind);
    self SetupBind("onebullet", "OFF", ::OneBulletBind);
    self SetupBind("reverse", "OFF", ::ReverseEleBind);
    self SetupBind("damagerepeater", "OFF", ::DamageRepeaterBind);
    self SetupBind("fakeflip", "OFF", ::FakeFlipBind);
    self SetupBind("repeater", "OFF", ::RepeaterBind);
    self setupbind("boltmovement","OFF",::BoltMovementBind);
    self setupbind("recordmovement","OFF",::RecordMovementBind);
    self setupbind("smooth","OFF",::SmoothBind);

    self setpers("lives", 99);
    self unipers("unlink", "OFF");
    self unipers("god", "ON");
    self unipers("air", "OFF");
    self unipers("ele", "OFF");
    self unipers("soh", "ON");
    self unipers("altswap", "OFF");
    self unipers("altswapweapon", "h2_usp_mp");
    self unipers("takeweapon", "OFF");
    self unipers("autoprone", "OFF");
    self unipers("instashoots", "OFF"); 
    self unipers("aliens", "ON"); 
    self unipers("menulock", "OFF");
    self unipers("refill", "OFF");
    self unipers("realscavenger", "OFF");
    self unipers("savex", "Undefined");
    self unipers("savey", "Undefined");
    self unipers("savez", "Undefined");
    self unipers("savea", "Undefined"); 
    self unipers("savemap", "Undefined");
    self unipers("savepossliderchangeby",10);  
    self unipers("bouncecount","0");
    self unipers("giveweapon", "radar_mp");
    self unipers("eqswap", "OFF");
    self unipers("headbounces", "OFF");
    self unipers("sniperaimbot", "ON");
    self unipers("aimbot","Normal");
    self unipers("aimbotdelay", "0.00");
    self unipers("aimbotrange","300");
    self unipers("aimbotweapon","Undefined");
    self unipers("aimbotweaponname","Undefined");
    self unipers("hitaimbot","OFF");
    self unipers("hitaimbotweapon","Undefined");
    self unipers("hitaimbotweaponname","Undefined");
    self unipers("hitaimbotrange","100");
    self unipers("infammo","OFF");
    self unipers("infeq","OFF");
    self unipers("changeclasswrap","5");
    self unipers("changeclasscanswap","OFF");
    self unipers("changeclasszoomload","OFF");
    self unipers("changeclassemptyclip","OFF");
    self unipers("changeclassonebullet", "OFF");
    self unipers("velocityx",0);
    self unipers("velocityy",0);
    self unipers("velocityz",0);
    self unipers("velocitychangeby",10);
    self unipers("damageamount",100);
    self unipers("damagechangeby",10);
    self unipers("radiusdamagepos","0");
    self unipers("radiusdamagechangeby", 10);
    self unipers("radiusdamageamount", 10);
    self unipers("hittype","Normal");
    self unipers("hittype2","Normal");
    self unipers("autoreload", "OFF");
    self unipers("lunges", "OFF");
    self unipers("recordmovementcount","0");
    self unipers("boltmovementcount","0");
    self unipers("barrelwait",0);
    self unipers("detonatewait",0);
    // must limit some of these to prevent crashes ):
    for(i=1;i<8;i++) {
        self unipers("bouncepos" + i,"0");
    }

    for(i=1;i<7;i++)
    {
        self unipers("boltmovementpos" + i,"0");
        self unipers("boltmovementspeed" + i,"1");
    }
    for(i=1;i<7;i++)
    {
        self unipers("recordmovementpos" + i,"0");
    }
    //

    self iprintln("Welcome back, ^:" + PlayerName());
    self iprintln("[^:Copycat^7] Last Update: ^5" + Kitty("last_update") + " ^7(^:Build " + Kitty("build") + "^7)");
    self GivePerk("specialty_bulletaccuracy");
    self.lives = self getpers("lives");
}