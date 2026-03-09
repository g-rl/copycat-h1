#include maps\mp\_utility;
#include scripts\mp\_util;
#include scripts\mp\_menu;
#include scripts\mp\_struct;
#include scripts\mp\_binds;
#include scripts\mp\_func;

FunctionCatcher() {
    if(self getpers("nac") != "OFF")
    self thread NacBind(self getpers("nac"));

    if(self getpers("instaswap") != "OFF")
    self thread InstaswapBind(self getpers("instaswap"));

    if(self getpers("emptyclip") != "OFF")
    self thread EmptyClipBind(self getpers("emptyclip"));

    if(self getpers("onebullet") != "OFF")
    self thread OneBulletBind(self getpers("onebullet"));

    if(self getpers("canzoom") != "OFF")
    self thread CanzoomBind(self getpers("canzoom"));

    if(self getpers("changeclass") != "OFF")
    self thread ChangeClassBind(self getpers("changeclass"));

    if(self getpers("houdini") != "OFF")
    self thread HoudiniBind(self getpers("houdini"));

    if(self getpers("stztiltbind") != "OFF")
    self thread StzTiltBind(self getpers("stztiltbind"));

    if(self getpers("hitmarker") != "OFF")
    self thread HitmarkerBind(self getpers("hitmarker"));

    /#
    if(self getpers("boltmovement") != "OFF")
    self thread BoltMovementBind(self getpers("boltmovement"));
    #/

    if(self getpers("stztiltbind") != "OFF")
    self thread RecordMovementBind(self getpers("recordmovement"));


    if(self getpers("killbot") != "OFF")
    self thread KillBotBind(self getpers("killbot"));

    if(self getpers("velocity") != "OFF")
    self thread VelocityBind(self getpers("velocity"));

    if(self getpers("canswap") != "OFF")
    self thread CanswapBind(self getpers("canswap"));

    if(self getpers("illusion") != "OFF")
    self thread IllusionBind(self getpers("illusion"));
    
    if(self getpers("bounce") != "OFF")
    self thread BounceBind(self getpers("bounce"));

    if(self getpers("flash") != "OFF")
    self thread FlashBind(self getpers("flash"));

    if(self getpers("detonate") != "OFF")
    self thread DetonateBind(self getpers("detonate"));
    
    if(self getpers("barrel") != "OFF")
    self thread BarrelBind(self getpers("barrel"));

    if(self getpers("damage") != "OFF")
    self thread DamageBind(self getpers("damage"));

    if(self getpers("radiusdamage") != "OFF")
    self thread RadiusDamageBind(self getpers("radiusdamage"));

    if(self getpers("fade") != "OFF")
    self thread FadeBind(self getpers("fade"));

    if(self getpers("scavenger") != "OFF")
    self thread ScavengerBind(self getpers("scavenger"));

    if(self getpers("save") != "OFF")
    self thread SaveBind(self getpers("save"));

    if(self getpers("load") != "OFF")
    self thread LoadBind(self getpers("load"));

    if(self getpers("giveweap") != "OFF")
    self thread GiveWeaponBind(self getpers("giveweap"));

    if(self getpers("autoprone") == "ON")
    self thread InitAutoProne();

    if(self getpers("menulock") == "ON")
    self thread LockMenu();

    if(self getpers("autoreload") == "ON")
    self thread DoReload();

    if(self getpers("aliens") == "ON")
    self thread Aliens2();

    if(self getpers("eqswap") == "ON")
    self thread EqSwap();

    if(self getpers("headbounces") == "ON")
    self thread Headbounces();

    if(self getpers("instashoots") == "ON")
    self thread WatchInstashoots();

    if(self getpers("spectator") != "OFF")
    self thread SpectatorBind();

    if(self getpers("aimbot") == "Normal")
    self thread normalaimbot();
    else if(self getpers("aimbot") == "Unfair")
    self thread unfairaimbot();

    if(self getpers("hitaimbot") == "Normal")
    self thread HitmarkerAimbotNew();
    else if(self getpers("hitaimbot") == "Unfair")
    self thread HitmarkerAimbotUnfair();

    if(getdvar("deathbarriers") == "OFF")
    {
        ents = getEntArray();
        for ( index = 0; index < ents.size; index++ )
        if(isSubStr(ents[index].classname, "trigger_hurt"))
        ents[index].origin = (0,0,999999);
    }

    if(self getpers("infammo") == "Continuous")
    setdvar("player_sustainammo",1);
    else if(self getpers("infammo") == "On Reload")
    self thread infammo();

    SetSlowMotion(getdvarfloat("timescale"), getdvarfloat("timescale"), 0);

}