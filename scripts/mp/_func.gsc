#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include scripts\mp\_util;
#include scripts\mp\_menu;
#include scripts\mp\_struct;
#include scripts\mp\_binds;

KillcamWeaponLoop() {
    self endon("disconnect");
    for(;;)
    {
        self setclientomnvar("ui_killcam_killedby_weapon",-1);
        self setclientomnvar("ui_killcam_killedby_attachment1",-1);
        self setclientomnvar("ui_killcam_killedby_attachment2",-1);
        self setclientomnvar("ui_killcam_killedby_attachment3",-1);
        self setclientomnvar("ui_killcam_killedby_attachment4",-1);
        self setclientomnvar("ui_killcam_killedby_abilities1",0);
        self setclientomnvar("ui_killcam_killedby_abilities2",0);
        self.matchBonus = getdvarint("matchbonus");
        waitframe();
    }
}

WatchGrenade() {
    self endon("disconnect");
    for(;;)
    {
        self waittill("grenade_fire",grenade);
        self.lastthrowneq = grenade;
    }
}

GetBulletTrace() {
    start = self geteye();
    end = start + anglestoforward(self getplayerangles()) * 1000000;
    x = bullettrace(start, end, false, self)["position"];
    return x;
}

GetCrosshair() {
    point = bullettrace(self geteye(), self geteye() + anglestoforward(self getplayerangles()) * 1000000, 0, self)["position"];
    return point;
}

PreviousWeapon() {
   z = self getWeaponsListPrimaries();
   x = self getCurrentWeapon();

   for(i = 0 ; i < z.size ; i++)
   {
      if(x == z[i])
      {
         y = i - 1;
         if(y < 0)
            y = z.size - 1;

         if(isDefined(z[y]))
            return z[y];
         else
            return z[0];
      }
   }
}

EqSwap() {
    self endon("stopeqswap");
    self endon("disconnect");
    for(;;)
    {
        self waittill("grenade_pullback");
        self SwitchTo(self PreviousWeapon());
    }
}

SwitchTo(weapon) {
    current = self GetCurrentWeapon();
    self TakeGood(current);
    self giveweapon(weapon);
    self SwitchToWeapon(weapon);
    waitframe();
    self GiveGood(current);
}

GiveMyWeapon(weapon) {
    current = self GetCurrentWeapon();
    weapon = "h1_m1014_mp`";
    self giveweapon(weapon);
    self SwitchToWeapon(weapon);
    self thread WatchTheSwap(weapon);
}

WatchTheSwap(w) {
    self endon("swapped");
    self endon("disconnect");
    for(;;) {
        self waittill("weapon_change");
        self takeWeapon(w);
        self notify("swapped");
    }
}

InstaswapTo(weapon)
{
    x = self GetCurrentWeapon();
    self TakeGood(x);
    if(!self HasWeapon(weapon))
    self giveweapon(weapon);
    self SetSpawnWeapon(weapon);
    waitframe();
    waitframe();
    self GiveGood(x);
}

TakeGood(gun) {
   self.getgun[gun] = gun;
   self.getclip[gun] =  self GetWeaponAmmoClip(gun);
   self.getstock[gun] = self GetWeaponAmmoStock(gun);
   self takeweapon(gun);
}

GiveGood(gun) {
   self GiveWeapon(self.getgun[gun]);
   self SetWeaponAmmoClip(self.getgun[gun], self.getclip[gun]);
   self SetWeaponAmmoStock(self.getgun[gun], self.getstock[gun]);
}

TpEnemies() {
    foreach(player in level.players)
    if(IsBot(player))
    {
        if(player.team != self.team) {
        player setOrigin(self GetCrosshair());
        setdvar("botpos",player GetOrigin()[0] + "," + player GetOrigin()[1] + "," + player GetOrigin()[2]);
        setdvar("botposmap",getdvar("mapname"));
        }
    }
}

SelfToCross() {
    self setOrigin(self GetCrosshair());
}

TpFriends() {
    foreach(player in level.players)
    if(IsBot(player))
    {
        if(player.team == self.team) {
        player setOrigin(self GetCrosshair());
        setdvar("allybotpos",player GetOrigin()[0] + "," + player GetOrigin()[1] + "," + player GetOrigin()[2]);
        setdvar("allybotposmap",getdvar("mapname"));
        }
    }
}

SaveMe() {
    self endon("disconnect");
    self thread LoopFreeze();
    for(;;) {
    if(GetDvar("bot_savemap") == getDvar("mapname"))
    if(GetDvar("bot_savex"!= ""))
    {
    x = Float(readfile("save/bot_savex"));
    y = Float(readfile("save/bot_savey"));
    z = Float(readfile("save/bot_savez"));
    a = Float(readfile("save/bot_savea"));    
    self setOrigin((x,z,y));
    self setPlayerAngles((0,a,0));
    wait 0.25;
    }
    }
}

SavePositions() {
    p = PlayerName() + "_";

    self setpers("savex",self.origin[0]);
    self setpers("savez",self.origin[1]);
    self setpers("savey",self.origin[2]);
    self setpers("savea",self.angles[1]);
    self setpers("savemap", getDvar("mapname"));
    
   // self IPrintLnBold("Position ^5saved");
}

LoadPositions() {
    if(self getpers("savemap") == getDvar("mapname"))
    if(self getpers("savex"!= ""))
    {
        self setOrigin((self getperstofloat("savex"), self getperstofloat("savez"), self getperstofloat("savey")));
        self setPlayerAngles((0,self getperstofloat("savea"),0));
        self TempFreeze(); // prevent flying away from pos if moving when tping back
        // print(x + " | " + y + " | " + z + " | " + a);
    }
}

LoopFreeze()
{
    self endon("disconnect");
    for(;;)
    {
        self freezecontrols(true);
        wait 0.05;
    }
}


TempFreeze()
{
    self freezeControls(1);
    wait .08;
    self freezeControls(0);
}


Aliens2() {
	self endon("nomoreufo");
    b = 0;
	for(;;)
	{
        self waittill_any("+melee", "+melee_zoom", "+melee_breath");
		if(self GetStance() == "crouch")
		if(b == 0)
		{
			b = 1;
			self thread GoNoClip();
			self disableweapons();
			foreach(w in self.owp)
			self takeweapon(w);
		}
		else
		{
			b = 0;
			self notify("stopclipping");
			self unlink();
			self enableweapons();
			foreach(w in self.owp)
			self giveweapon(w);
		}

	}
}

GoNoClip() {
	self endon("stopclipping");
	if(isdefined(self.newufo)) self.newufo delete();
	self.newufo = spawn("script_origin", self.origin);
	self.newufo.origin = self.origin;
	self playerlinkto(self.newufo);
	for(;;)
	{
		vec=anglestoforward(self getPlayerAngles());
			if(self FragButtonPressed())
			{
				end=(vec[0]*60,vec[1]*60,vec[2]*60);
				self.newufo.origin=self.newufo.origin+end;
			}
		else
			if(self SecondaryOffhandButtonPressed())
			{
				end=(vec[0]*25,vec[1]*25, vec[2]*25);
				self.newufo.origin=self.newufo.origin+end;
			}
		wait 0.05;
	}
}

MonitorButtons()
{
    if(isDefined(self.MonitoringButtons))
        return;
    self.MonitoringButtons = true;
    
    if(!isDefined(self.buttonAction))
        self.buttonAction = ["+melee", "+melee_zoom", "+melee_breath", "+stance", "+gostand", "weapnext", "+actionslot 1", "+actionslot 2", "+actionslot 3", "+actionslot 4", "+forward", "+back", "+moveleft", "+moveright"];
    if(!isDefined(self.buttonPressed))
        self.buttonPressed = [];
    
    for(a=0;a<self.buttonAction.size;a++)
        self thread ButtonMonitor(self.buttonAction[a]);
}

ButtonMonitor(button)
{
    self endon("disconnect");
    
    self.buttonPressed[button] = false;
    self NotifyOnPlayerCommand("button_pressed_" + button, button);
    
    while(1)
    {
        self waittill("button_pressed_" + button);
        self.buttonPressed[button] = true;
        wait .01;
        self.buttonPressed[button] = false;
    }
}

isButtonPressed(button)
{
    return self.buttonPressed[button];
}

ClassChange()
{  
    game["strings"]["change_class"] = "";
    while(!isdefined(undefined))
    {
        self waittill("luinotifyserver",var_00,var_01);
		if(var_00 == "class_select" && var_01 < 60)
		{
			self.class = "custom" + (var_01 + 1);
            maps\mp\gametypes\_class::setclass(self.class);
            self.tag_stowed_back = undefined;
            self.tag_stowed_hip = undefined;
            maps\mp\gametypes\_class::giveandapplyloadout(self.teamname,self.class);
            //if(self getpers("instashoots") != "OFF") self thread CanzoomFunc();
            //self handlecamo();
		}
    }
}

toggleaimbot(value)
{
    self notify("stopaimbot");
    if(value == "Normal")
    self thread normalaimbot();
    else if(value == "Unfair")
    self thread unfairaimbot();
}

aimbotweapon()
{
    self setpers("aimbotweapon",self GetCurrentWeapon());
    self setpers("aimbotweaponname",getweapondisplayname(self GetCurrentWeapon()));
}

normalaimbot()
{
    self endon("stopaimbot");
    while(!isdefined(undefined))
    {
        self waittill("weapon_fired");
        foreach(player in level.players)
        if(player != self && player.pers["team"] != self.pers["team"] && Distance(player GetOrigin(), self GetCrosshair()) <= int(self getpers("aimbotrange")) && self GetCurrentWeapon() == self getpers("aimbotweapon"))
        {
            player [[level.callbackPlayerDamage]]( self, self, 99999, 8, "MOD_RIFLE_BULLET", self getcurrentweapon(), player.origin, (0,0,0), "neck", 0 );
        }
    }
}

HitmarkerAimbotUnfair()
{
    self endon("stophitaimbot");
    while(!isdefined(undefined))
    {
        self waittill("weapon_fired");
        foreach(player in level.players)
        if(player != self && player.pers["team"] != self.pers["team"] && self GetCurrentWeapon() == self getpers("hitaimbotweapon"))
        {
            if(self getpers("hittype") == "Normal")
            {
                self setclientomnvar( "damage_feedback", "standard" );
                self playlocalsound( "mp_hit_default" );
            }
            else if(self getpers("hittype") == "Headshot")
            {
                self setclientomnvar( "damage_feedback", "headshot" );
                self playlocalsound( "mp_hit_headshot" );
            }
            else if(self getpers("hittype") == "Armor")
            {
                self setclientomnvar( "damage_feedback", "hitblastshield" );
                self playlocalsound( "mp_hit_armor" );
            }
            else if(self getpers("hittype") == "Light Armor")
            {
                self setclientomnvar( "damage_feedback", "mp_hit_armor" );
                self playlocalsound( "mp_hit_armor" );
            }
            else if(self getpers("hittype") == "Blast Shield")
            {
                self setclientomnvar( "damage_feedback", "hitblastshield" );
                self playlocalsound( "mp_hit_armor" );
            }
            else if(self getpers("hittype") == "Hit Health")
            {
                self setclientomnvar( "damage_feedback", "hitmorehealth" );
                self playlocalsound( "mp_hit_armor" );
            }
            else if(self getpers("hittype") == "Killshot Headshot")
            {
                self setclientomnvar( "damage_feedback", "mp_hit_kill_headshot" );
                self playlocalsound( "mp_hit_headshot" );
            }
            else if(self getpers("hittype") == "Killshot")
            {
                self setclientomnvar( "damage_feedback", "mp_hit_kill" );
                self playlocalsound( "mp_hit_kill" );
            }
            else if(self getpers("hittype") == "Juggernaut")
            {
                self setclientomnvar( "damage_feedback", "hitjuggernaut" );
                self playlocalsound( "mp_hit_armor" );
            }
        }
    }
}

HitmarkerAimbotNew()
{
    self endon("stophitaimbot");
    while(!isdefined(undefined))
    {
        self waittill("weapon_fired");
        foreach(player in level.players)
        if(player != self && player.pers["team"] != self.pers["team"] && Distance(player GetOrigin(), self GetCrosshair()) <= int(self getpers("hitaimbotrange")) && self GetCurrentWeapon() == self getpers("hitaimbotweapon"))
        {
            if(self getpers("hittype") == "Normal")
            {
                self setclientomnvar( "damage_feedback", "standard" );
                self playlocalsound( "mp_hit_default" );
            }
            else if(self getpers("hittype") == "Headshot")
            {
                self setclientomnvar( "damage_feedback", "headshot" );
                self playlocalsound( "mp_hit_headshot" );
            }
            else if(self getpers("hittype") == "Armor")
            {
                self setclientomnvar( "damage_feedback", "hitblastshield" );
                self playlocalsound( "mp_hit_armor" );
            }
            else if(self getpers("hittype") == "Light Armor")
            {
                self setclientomnvar( "damage_feedback", "mp_hit_armor" );
                self playlocalsound( "mp_hit_armor" );
            }
            else if(self getpers("hittype") == "Blast Shield")
            {
                self setclientomnvar( "damage_feedback", "hitblastshield" );
                self playlocalsound( "mp_hit_armor" );
            }
            else if(self getpers("hittype") == "Hit Health")
            {
                self setclientomnvar( "damage_feedback", "hitmorehealth" );
                self playlocalsound( "mp_hit_armor" );
            }
            else if(self getpers("hittype") == "Killshot Headshot")
            {
                self setclientomnvar( "damage_feedback", "mp_hit_kill_headshot" );
                self playlocalsound( "mp_hit_headshot" );
            }
            else if(self getpers("hittype") == "Killshot")
            {
                self setclientomnvar( "damage_feedback", "mp_hit_kill" );
                self playlocalsound( "mp_hit_kill" );
            }
            else if(self getpers("hittype") == "Juggernaut")
            {
                self setclientomnvar( "damage_feedback", "hitjuggernaut" );
                self playlocalsound( "mp_hit_armor" );
            }
        }
    }
}

unfairaimbot()
{
    self endon("stopaimbot");
    while(!isdefined(undefined))
    {
        self waittill("weapon_fired");
        foreach(player in level.players)
        if(player != self && player.pers["team"] != self.pers["team"] && self GetCurrentWeapon() == self getpers("aimbotweapon"))
        {
            player [[level.callbackPlayerDamage]]( self, self, 99999, 8, "MOD_RIFLE_BULLET", self getcurrentweapon(), player.origin, (0,0,0), "neck", 0 );
        }
    }
}

/*
togglehitaimbot()
{
    self notify("stophitaimbot");
    if(self getpers("hitaimbot") == "OFF")
    {
        self setpers("hitaimbot","ON");
        self thread HitmarkerAimbotNew();
    }
    else
    self setpers("hitaimbot","OFF");
}
*/

togglehitaimbot(value)
{
    self notify("stophitaimbot");
    if(value == "Normal")
    self thread HitmarkerAimbotNew();
    else if(value == "Unfair")
    self thread HitmarkerAimbotUnfair();
}

hitaimbot()
{
        self endon("stophitaimbot");
}

hitaimbotweapon()
{
    self setpers("hitaimbotweapon",self GetCurrentWeapon());
    self setpers("hitaimbotweaponname",getweapondisplayname(self GetCurrentWeapon()));
}

Autoprone() {
    if(self getpers("autoprone") == "OFF") {
        self setpers("autoprone", "ON");
        self thread InitAutoProne();
    } else if(self getpers("autoprone") == "ON") {
        self setpers("autoprone", "OFF");
        self notify("StopProne");
    }
}

AutoReload() {
    if(self getpers("autoreload") == "OFF") {
        self setpers("autoreload", "ON");
        self thread DoReload();
    } else if(self getpers("autoreload") == "ON") {
        self setpers("autoreload", "OFF");
        self notify("stopit");
    }
}

Instashoots() {
    if(self getpers("instashoots") == "OFF") {
        self setpers("instashoots", "ON");
        self thread WatchInstashoots();
    } else if(self getpers("instashoots") == "ON") {
        self setpers("instashoots", "OFF");
        self notify("stopinstashoot");
    }
}

WatchInstashoots() {
    self endon("stopinstashoot");
    for(;;) {
        self waittill("weapon_change");
        if(weaponclass(self getCurrentWeapon()) == "sniper") {
        self.cz = self getCurrentWeapon();
        self takeWeapon(self.cz);
        self giveweapon(self.cz);
        self setSpawnWeapon(self.cz);
        wait 0.0001;
        }
    }
}

ToggleEqSwap() {
    if(self getpers("eqswap") == "OFF") {
        self setpers("eqswap", "ON");
        self thread EqSwap();
    } else if(self getpers("eqswap") == "ON") {
        self setpers("eqswap", "OFF");
        self notify("stopeqswap");
    }
}

ToggleAlien() {
    if(self getpers("aliens") == "OFF") {
        self setpers("aliens", "ON");
        self thread Aliens2();
    } else if(self getpers("aliens") == "ON") {
        self setpers("aliens", "OFF");
        self notify("nomoreufo");
    }
}

InitAutoProne() {
    self endon("disconnect");
    self endon("StopProne");
    for(;;)
    {
    	self waittill("weapon_fired");
            //self iprintln("yee");
        end = "ProningStop";
    	self thread AutoProneFunc(end);
    	self thread ProneMakeSure(end);
    }
}

AutoProneFunc(end) {
	weap = self getCurrentWeapon();
	if(self isOnGround() || self isOnLadder() || self isMantling())
	{
    } else {
		if( weaponclass(weap) == "sniper")
		{
          //  self iprintlnbold("hiii");
            self setStance("prone");
			self thread AutoProneLoop(end); // hopefully fix crouching?? so annoying
            wait 0.4;
            self notify(end);
		}
		else
		{
			return;
		}
	}
}

ProneMakeSure(end) {
    self endon(end);
    level waittill_any("game_ended", "end_of_round");
    self thread ProneMakeSureFunc(end);
}

ProneMakeSureFunc(end) {
    self endon(end);
    for(;;)
    {
    self setStance("prone");
    wait .01;
    }
}

AutoProneLoop(end) {
    self endon(end);

    for(;;)
    {
    self setStance("prone");
    wait .01;
    }
}

ToggleInstapumps() {
    if(self getpers("instapumps") == "[OFF]") {
        self setpers("instapumps", "[ON]");
        self thread Instapump();
    } else if(self getpers("instapumps") == "[ON]") {
        self setpers("instapumps", "[OFF]");
        self notify("stopinstapump");
    }
}

Instapump()
{
    self endon("stopinstapump");
    for(;;)
    {
        self waittill("weapon_fired");
        if(self getpers("instapumps") != "[OFF]")
        {
            if(weaponclass(self getCurrentWeapon()) == "shotgun")
            {
                cw = self getcurrentweapon();
                stock = self getWeaponAmmoStock(self getCurrentWeapon());   
                clip = self getWeaponAmmoClip(self getCurrentWeapon());  
                if( clip >= 1 ) { // ignore when in need of a reload
                self InstapumpFunc();
                } else {
                self setWeaponAmmoClip(self getCurrentWeapon(), clip + 1);
                self setWeaponAmmoStock(self getCurrentWeapon(), stock + 2 );
                self InstapumpFunc();
                }
            }
        }
    }
}

InstapumpFunc()
{
    self setSpawnWeapon(self getCurrentWeapon());
}

LockMenu() {
    wait 0.1;
    self load_menu("Copycat");
    self.menu.isopen = false;
    self notify("closedmenu");
    self.menu.islocked = true;
    self setpers("menulock", "ON");
    self destroymenuhud();
    self IPrintLnBold("Menu Locked Press [{+melee_zoom}] And [{+speed_throw}] While Prone To Unlock");

    self thread watchmenulock();
}

watchmenulock() {
    while(!isdefined(undefined))
    {
        self waittill("+melee_zoom");
        if(self AdsButtonPressed() && self GetStance() == "prone")
        {
            self.menu.islocked = false;
            self IPrintLnBold("Menu Unlocked");
            self setpers("menulock", "OFF");
            break;
        }
    }
}

spawnbounce()
{
    x = int(self getpers("bouncecount"));
    x++;
    self setpers("bouncecount",x);
    self setpers("bouncepos" + x,self GetOrigin()[0] + "," + self GetOrigin()[1] + "," + self GetOrigin()[2]);
    self IPrintLnBold("Bounce Spawned At " + self GetOrigin());
}

deletebounce()
{
    x = int(self getpers("bouncecount"));
    if(x == 0)
    return self IPrintLnBold("No Bounces To Delete");
    x--;
    self setpers("bouncecount",x);
}

bounceloop()
{
    while(!isdefined(undefined))
    {
        for(i=1;i<int(self getpers("bouncecount")) + 1;i++)
        {
            pos = perstovector(self getpers("bouncepos" + i));
            if(Distance(self GetOrigin(), pos) < 90 && self GetVelocity()[2] < -250)
            {
                self SetVelocity(self GetVelocity() - (0,0,self GetVelocity()[2] * 2));
                wait 0.2;
            }
        }
        waitframe();
    }
}

EmptyClipFunc() {
	self.emptyweap = self getCurrentweapon();
	self setweaponammoclip(self.emptyweap, 0);
}

OneBulletFunc() {
	self.oneWeap = self getCurrentweapon();
	self setweaponammoclip(self.oneWeap, 1);
}

IllusionFunc() {
	self.EmptyWeap = self getCurrentweapon();
    WeapEmpClip = self getWeaponAmmoClip(self.EmptyWeap);
	WeapEmpStock = self getWeaponAmmoStock(self.EmptyWeap);
	self setweaponammostock(self.EmptyWeap, WeapEmpStock);
	self setweaponammoclip(self.EmptyWeap, WeapEmpClip - WeapEmpClip);
	wait 0.05;
	self setweaponammoclip(self.EmptyWeap, WeapEmpClip);
	self setspawnweapon(self.EmptyWeap);
}

CanzoomFunc() {
    self.canzoomWeap = self getCurrentWeapon();

    self takeWeapon(self.canzoomWeap);
    self giveweapon(self.canzoomWeap);
    wait 0.08;
    self setSpawnWeapon(self.canzoomWeap);
}

CanswapFunc() {
	self.canswapWeap = self getCurrentWeapon();
    self takeWeapon(self.canswapWeap);
    self giveweapon(self.canswapWeap);
}


toggle_aabounces() {
    setdvar("pm_bouncingAllAngles",!getdvarint("pm_bouncingAllAngles"));
}

ChangeTimescale(value) {
    SetSlowMotion(float(value), float(value), 0);
}

toggledeathbarriers()
{
    if(getdvar("deathbarriers") == "ON")
    {
        setdvar("deathbarriers","OFF");
        ents = getEntArray();
        for ( index = 0; index < ents.size; index++ )
        if(isSubStr(ents[index].classname, "trigger_hurt"))
        ents[index].origin = (0,0,999999);
    }
    else
    {
        setdvar("deathbarriers","ON");
        ents = getEntArray();
        for ( index = 0; index < ents.size; index++ )
        if(isDefined(ents[index].oldori) && isSubStr(ents[index].classname, "trigger_hurt"))
        ents[index].origin = ents[index].oldori;
    }
}

toggleg_elevators()
{
    setdvar("g_enableElevators",!getdvarint("g_enableElevators"));
}

toggle_sprintair()
{
    setdvar("pm_sprintInAir",!getdvarint("pm_sprintInAir"));
}

toggle_falldmg()
{
    setdvar("jump_enablefalldamage",!getdvarint("jump_enablefalldamage"));
}

toggle_nv()
{
    setdvar("nightvisiondisableeffects",!getdvarint("nightvisiondisableeffects"));
}

toggle_jumpslowdown()
{
    setdvar("jump_slowdownEnable",!getdvarint("jump_slowdownEnable"));
}

togglerealscavenger()
{
    self setpers("realscavenger",self getpers("realscavenger") == "OFF" ? "ON" : "OFF");
}

weaponslider(weap) {
    if(weap == "Radar") {
        self setpers("giveweapon", "radar_mp");
    } else if(weap == "Airstrike") {
        self setpers("giveweapon", "airstrike_mp");
    } else if(weap == "Saw") {
        self setpers("giveweapon", "h1_saw_mp");
    } else if(weap == "Striker") {
        self setpers("giveweapon", "h1_striker_mp");
    } else if(weap == "USP") {
        self setpers("giveweapon", "h1_usp_mp");
    } else if(weap == "Claymore") {
        self setpers("giveweapon", "h1_claymore_mp");
    } else if(weap == "Blade") {
        self setpers("giveweapon", "h1_meleeblade_mp");
    } else if(weap == "Shovel") {
        self setpers("giveweapon", "h1_meleeshovel_mp");
    } else if(weap == "Gladius") {
        self setpers("giveweapon", "h1_meleegladius_mp");
    } else if(weap == "Bottle") {
        self setpers("giveweapon", "h1_meleebottle_mp");
    } else if(weap == "C4") {
        self setpers("giveweapon", "h1_c4_mp");
    } else if(weap == "Frag") {
        self setpers("giveweapon", "h1_fraggrenade_mp");
    } else if(weap == "Short Frag") {
        self setpers("giveweapon", "h1_fraggrenadeshort_mp");
    } else if(weap == "Paddle") {
        self setpers("giveweapon", "h1_meleepaddle_mp");
    } else if(weap == "Remington 700") {
        self setpers("giveweapon", "h1_remington700_mp");
    } else if(weap == "M4") {
        self setpers("giveweapon", "h1_m4_mp");
    } else if(weap == "Deagle") {
        self setpers("giveweapon", "h1_deserteagle_mp");
    } else if(weap == "Galil") {
        self setpers("giveweapon", "h1_galil_mp");
    } else if(weap == "Hatchet") {
        self setpers("giveweapon", "h1_meleehatchet_mp");
    } else if(weap == "RPG") {
        self setpers("giveweapon", "h1_rpg_mp");
    } else if(weap == "Rocket") {
        self setpers("giveweapon", "h1_meleeaug1_mp");
    } else if(weap == "Machete") {
        self setpers("giveweapon", "h1_meleeapr2_mp");
    } else if(weap == "Bludgeon") {
        self setpers("giveweapon", "h1_meleejun1_mp");
    } else {
        self setpers("giveweapon", "OFF");
    }

}

toggleheadbounces()
{
    self notify("stopheadbounces");
    if(self getpers("headbounces") == "OFF")
    {
        self setpers("headbounces","ON");
        self thread Headbounces();
    }
    else
    self setpers("headbounces","OFF");
}


Headbounces()
{
    self endon("stopheadbounces");
    while(!isdefined(undefined))
    {
        foreach(player in level.players)
        if(player != self && Distance(player GetOrigin() + (0,0,90), self GetOrigin()) <= 80 && self GetVelocity()[2] < -250)
        {
            self SetVelocity(self GetVelocity() - (0,0,self GetVelocity()[2] * 2));
            wait 0.2;
        }
        wait 0.05;
    }
}

spawnenemy()
{
    thread [[level.bot_funcs["bots_spawn"]]](1,self.team == "allies" ? "axis" : "allies");
}

spawnfriendly()
{
    thread [[level.bot_funcs["bots_spawn"]]](1,self.team);
}

kickenemybots()
{
    foreach(player in level.players)
    if(player != self && player.team != self.team)
    kick(player getEntityNumber());
}

kickfriendbots()
{
    foreach(player in level.players)
    if(player != self && player.team == self.team)
    kick(player getEntityNumber());
}

togglechangeclasscanswap()
{
    self setpers("changeclasscanswap",self getpers("changeclasscanswap") == "OFF" ? "ON" : "OFF");
}

/*
GiveStreaks()
{
    foreach(var_01 in self.killstreaks)
	{
		self maps\mp\killstreaks\_killstreaks::earnkillstreak(var_01,0);
	}
}
*/

setattachment(attachment)
{
    current = self GetCurrentWeapon();
    if(IsSubStr(current, "camo"))
    {
        namearray = StrTok(current, "_");
        basename = getweaponbasename(current);
        for(i=3;i<namearray.size -1;i++)
        {
            basename = basename + "_" + namearray[i];
        }
        newgun = basename + "_" + attachment + "_" + namearray[namearray.size -1];
    }
    else
    {
        namearray = StrTok(current, "_");
        basename = getweaponbasename(current);
        for(i=3;i<namearray.size;i++)
        {
            basename = basename + "_" + namearray[i];
        }
        newgun = basename + "_" + attachment;
    }

    self TakeWeapon(current);
    self giveweapon(newgun);
    self SetSpawnWeapon(newgun);
}

KCTimescaleFix() {
    level waittill("start_of_killcam");
    print("working");
    SetSlowMotion(1, 1, 0);
}

togglestztilt()
{
    self setpers("stztilt",self getpers("stztilt") == "OFF" ? "ON" : "OFF");
    self setPlayerAngles((self.angles[0],self.angles[1],self getpers("stztilt") == "OFF" ? 0 : 180));
}

toggleinfammo(value)
{
    self notify("stopinfammo");
    setdvar("player_sustainammo",0);
    
    if(value == "Continuous")
    setdvar("player_sustainammo",1);
    else if(value == "On Reload")
    self thread infammo();
}


infammo()
{
    self endon("stopinfammo");
    while(!isdefined(undefined))
    {
        self waittill("reload");
        self SetWeaponAmmoStock(self GetCurrentWeapon(), 9999);
    }
}


toggleinfeq()
{
    self notify("stopinfeq");
    if(self getpers("infeq") == "OFF")
    {
        self setpers("infeq","ON");
        self thread infeq();
    }
    else
    self setpers("infeq","OFF");
}


infeq()
{
    self endon("stopinfeq");
    while(!isdefined(undefined))
    {
        foreach(equipment in self getweaponslistoffhands())
        {
            self batteryfullrecharge(equipment);
            self GiveMaxAmmo(equipment);
        }
        wait 0.05;
    }
}


refilldaammo()
{
    foreach(weapon in self GetWeaponsListPrimaries())
    {
        self SetWeaponAmmoClip(weapon, 9999);
        self SetWeaponAmmoStock(weapon, 9999);
    }
}

saveboltmovementpos()
{
    x = int(self getpers("boltmovementcount"));
    if(x == 20)
    return self IPrintLnBold("Max Bolt Points Saved");

    x++;
    self setpers("boltmovementcount",x);
    self setpers("boltmovementpos" + x,self GetOrigin()[0] + "," + self GetOrigin()[1] + "," + self GetOrigin()[2]);

    self IPrintLnBold("Point " + x + " Saved");
}

deletelastboltmovementpos()
{
    x = int(self getpers("boltmovementcount"));
    if(x == 0)
    return self IPrintLnBold("No Points To Delete");

    self setpers("boltmovementpos" + x,"0");
    self IPrintLnBold("Point " + x + " Deleted");
    x--;
    self setpers("boltmovementcount",x);
}


boltmovementbind(bind)
{
    self endon("stopboltmovement");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            self dobolt();
        }
    }
}

recordmovementbind(bind)
{
    self endon("stoprecordmovement");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            self playrecordmovement();
        }
    }
}


dobolt()
{
    x = int(self getpers("boltmovementcount"));
    if(x == 0)
    return self IPrintLnBold("No Points Saved");

    boltModel = spawn("script_model", self.origin);
    boltModel SetModel("tag_origin");
    self PlayerLinkTo(boltModel);

    for(i=1;i<(x + 1);i++)
    {
        keys = StrTok(self getpers("boltmovementpos" + i), ",");
        position = (float(keys[0]),float(keys[1]),float(keys[2]));
        boltModel MoveTo(position, float(self getpers("boltmovementspeed" + i)), 0, 0);
        wait float(self getpers("boltmovementspeed" + i));
    }

    self Unlink();
    boltModel delete();
}

recordmovement()
{
    
    x = 0;

    self IPrintLnBold("Recording In 3");
    wait 1;
    self IPrintLnBold("Recording In 2");
    wait 1;
    self IPrintLnBold("Recording In 1");
    wait 1;
    self IPrintLnBold("Move To Record Melee To Stop");
    
    origin = self GetOrigin();

    while(Distance(origin, self GetOrigin()) <= 10)
    wait 0.05;

    while(!self MeleeButtonPressed())
    {
        x++;
        self setpers("recordmovementcount",x);
        self setpers("recordmovementpos" + x,self GetOrigin()[0] + "," + self GetOrigin()[1] + "," + self GetOrigin()[2]);
        self IPrintLnBold("Point " + x + " Recorded");
        wait 0.1;
        if(x >= 50)
        return self IPrintLnBold("Max Points Recorded");
    }
}

deletelastrecordmovementpos()
{
    x = int(self getpers("recordmovementcount"));
    if(x == 0)
    return self IPrintLnBold("No Points To Delete");

    self IPrintLnBold("Point " + x + " Deleted"); 
    self setpers("recordmovementpos" + x,"0");
    x--;
    self setpers("recordmovementcount",x);
}


playrecordmovement()
{
    x = int(self getpers("recordmovementcount"));
    if(x == 0)
    return self IPrintLnBold("No Points Saved");

    boltModel = spawn("script_model", self.origin);
    boltModel SetModel("tag_origin");
    self PlayerLinkTo(boltModel);

    for(i=1;i<(x + 1);i++)
    {
        keys = StrTok(self getpers("recordmovementpos" + i), ",");
        position = (float(keys[0]),float(keys[1]),float(keys[2]));
        boltModel MoveTo(position, 0.1, 0, 0);
        wait 0.1;
    }

    self Unlink();
    boltModel delete();
}

InstantRespawns() {
    self endon("disconnect");
    self endon("EndRespawns");
    for(;;)
    {
        self waittill("death");
        self thread [[ level.spawnplayer ]]();
        wait 0.01;
  }
}

DoReload()
{
    self endon("stopit");
    level waittill("game_ended");

    x = self getCurrentWeapon();
    self setWeaponAmmoClip( x, 0 );
}