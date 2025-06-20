#include maps\mp\_utility;
#include angora\_util;
#include angora\_binds;
#include angora\_func;
#include angora\_menu;

FunctionCatcher() {
    if(getdvar("deathbarriers") == "OFF") {
        ents = getEntArray();
        for ( index = 0; index < ents.size; index++ )     
        if(isSubStr(ents[index].classname, "trigger_hurt"))     
        ents[index].origin = (0,0,999999);
    }

    if(self getpers("autoprone") == "Always") self thread InitAutoProne("ProningStop");
    if(self getpers("autoprone" == "Game End")) self thread ProneOnEnd();
    if(self getpers("menulock") == "ON") self thread LockMenu();
    if(self getpers("refill") == "ON") self thread WatchAmmo();
    if(self getpers("autoreload") == "ON") self thread DoReload();
    if(self getpers("aliens") == "ON") self thread Aliens2();

    if(self getpers("altswap") == "ON") {
        self aw_giveweapon(self getpers("altswapweapon"), undefined, undefined);
        self thread WatchAltSwap();
    }

    if(self maps\mp\_utility::_hasPerk( "specialty_fastreload" ) && self getpers("soh") == "OFF")
        self maps\mp\_utility::_unsetperk("specialty_fastreload");

    if(self getpers("eqswap") == "ON") self thread EqSwap();
    if(self getpers("headbounces") == "ON") self thread Headbounces();
    if(self getpers("instashoots") == "ON") self thread WatchInstashoots();
    if(self getpers("lunges") == "ON") self thread KL();
    
    if(self getpers("aimbot") == "Normal") self thread normalaimbot();
    else if(self getpers("aimbot") == "Unfair") self thread unfairaimbot();

    if(self getpers("hitaimbot") == "Normal") self thread HitmarkerAimbotNew();
    else if(self getpers("hitaimbot") == "Unfair") self thread HitmarkerAimbotUnfair();

    if(self getpers("infammo") == "Continuous") setdvar("player_sustainammo",1);
    else if(self getpers("infammo") == "On Reload") self thread infammo();

    if(self getpers("infeq") == "ON") self thread infeq();

    SetSlowMotion(getdvarfloat("timescale"), getdvarfloat("timescale"), 0); /# Need to rewrite this cause it doesnt work like H1 #/
}