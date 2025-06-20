#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include angora\_util;
#include angora\_menu;
#include angora\_struct;
#include angora\_binds;
#include maps\mp\gametypes\_playerlogic;

// #############################################################################

aw_checkeach(val, type) {
    foreach(i in val) {
        self aw_print(i, type);
        wait 3;
    }
}

aw_genie(a, b) { // 0.5.6
    genie = [];
    genie[0] = a;
    genie[1] = b;
    output = genie[randomint(genie.size)];
    return output;
}

aw_format(text, var_0, var_1) { // 0.5.9
    self iprintln(va(text, var_0, var_1));
}

aw_print(message, bold) { // 0.5.6
    if(isDefined(bold)) {
        self iprintlnbold("^:" + message);
        return;
    }
    self iprintln("^:" + message);
}

aw_giveweapon(weapon, drop, dos) {
    if(!isDefined(weapon)) self giveMaxAmmo(self getCurrentWeapon());

    if(weapon == self getCurrentWeapon()) {
        nw = self getCurrentWeapon();
        self dropitem(nw);
        self giveWeapon(nw);
        self giveMaxAmmo(nw);
        self switchToWeapon(nw);
        return;
    }

    self giveWeapon(weapon);
    self giveMaxAmmo(weapon);
    if(isDefined(dos)) self switchToWeapon(weapon);
    if(isDefined(drop)) self dropItem(weapon);
}

aw_takeweapon(weapon) {
    if(isDefined(weapon)) {
        self takeWeapon(weapon);
        w = self getWeaponsListPrimaries();
        self switchtoweapon(w[0]); 
        return;
    } 

    self takeWeapon(self getCurrentWeapon());
    w = self getWeaponsListPrimaries();
    self switchtoweapon(w[0]);
}

aw_dropweapon(weapon) {
    if(isDefined(weapon)) {
        self aw_giveweapon(weapon, true);
    } else {
        self dropItem(self getCurrentWeapon());
        w = self getWeaponsListPrimaries();
        self switchtoweapon(w[0]);
    }
}

aw_replace(a) {
    if(a == 1) {
	replaceFunc(maps\mp\gametypes\_teams::getteamshortname, ::getteamshortname_); 
	replaceFunc(maps\mp\_events::firstbloodevent, ::firstbloodevent_); 
    replacefunc(maps\mp\gametypes\_killcam::killcam, ::killcam_stub);
    replacefunc(maps\mp\gametypes\_music_and_dialog::init, ::init_stub);
    replacefunc(maps\mp\gametypes\_music_and_dialog::onplayerspawned, ::music_onplayerspawned_stub);
    replacefunc(maps\mp\_skill::isskillenabled, ::isskillenabled);
    replacefunc(maps\mp\gametypes\_battlechatter_mp::onplayerspawned, ::onplayerspawned_stub);
    replacefunc(maps\mp\gametypes\_damagefeedback::updatedamagefeedback, ::updatedamagefeedback_stub);
    replacefunc(maps\mp\gametypes\dom::precacheflags, ::precacheflags_stub);
    replacefunc(maps\mp\gametypes\_rank::xppointspopup, ::xppointspopup_stub);
    replacefunc(maps\mp\_events::updaterecentkills, ::updaterecentkills_stub);
    replacefunc(maps\mp\gametypes\_playerlogic::callback_playerconnect, ::callback_playerconnect_stub);
    replacefunc(maps\mp\gametypes\_playerlogic::callback_playerdisconnect, ::callback_playerdisconnect_stub);
	if(getDvar("g_gametype") != "sd") replaceFunc(maps\mp\perks\_perkfunctions::monitorTIUse, ::monitorTIUse_);
	replaceFunc( maps\mp\gametypes\_damage::dofinalkillcam, ::dofinalkillcam_ ); 
	replaceFunc( maps\mp\_utility::cac_getcustomclassloc, ::cac_getcustomclassloc_ ); 
	replaceFunc( maps\mp\_utility::rankingEnabled, ::returnTrue_ ); 
	replaceFunc( maps\mp\_utility::privateMatch, ::returnFalse_ ); 
	replaceFunc( maps\mp\_events::firstbloodevent, ::firstbloodevent_ );
	replaceFunc( maps\mp\gametypes\_rank::awardgameevent, ::awardgameevent_ ); 
	replaceFunc( maps\mp\gametypes\_gamelogic::checkroundswitch, ::checkroundswitch_ ); 
	replaceFunc( maps\mp\gametypes\_gamelogic::displayroundswitch, ::displayroundswitch_ ); 
	replaceFunc( maps\mp\gametypes\_gamelogic::matchstarttimerwaitforplayers, maps\mp\gametypes\_gamelogic::matchStartTimerSkip ); 
    }
    if(a == 2) {
	game["strings"]["change_class"] = undefined;
	level.onOneLeftEvent = undefined;
	level.numkills = 1;
	level.rankedmatch = 1;
    level.allowlatecomers = 1;
    level.graceperiod = 0;
    level.ingraceperiod = 0;
    level.prematchperiod = 0;
    level.waitingforplayers = 0;
    level.prematchperiodend = 0;
    }
}

returnTrue_( one, two, three, four, five, six )
{
	return true;
}

returnFalse_( one, two, three, four, six )
{
	return false;
}

awardgameevent_( var_0, var_1, var_2, var_3, var_4 )
{
    if ( maps\mp\_utility::invirtuallobby() )
		return;

    var_1 maps\mp\gametypes\_rank::giverankxp( var_0, undefined, var_2, var_4, undefined, var_3 );

    if ( maps\mp\gametypes\_rank::allowplayerscore( var_0 ) )
        var_1 maps\mp\gametypes\_gamescore::giveplayerscore( var_0, var_1, var_3 );
}

dofinalkillcam_()
{
    level waittill( "round_end_finished" );
	setDvar( "xblive_privatematch", 0 );
    level.showingfinalkillcam = 1;
    var_0 = "none";

    if ( isdefined( level.finalkillcam_winner ) )
        var_0 = level.finalkillcam_winner;

    var_1 = level.finalkillcam_delay[var_0];
    var_2 = level.finalkillcam_victim[var_0];
    var_3 = level.finalkillcam_attacker[var_0];
    var_4 = level.finalkillcam_attackernum[var_0];
    var_5 = level.finalkillcam_killcamentityindex[var_0];
    var_6 = level.finalkillcam_killcamentitystarttime[var_0];
    var_7 = level.finalkillcam_usestarttime[var_0];
    var_8 = level.finalkillcam_sweapon[var_0];
    var_9 = level.finalkillcam_weaponindex[var_0];
    var_10 = level.finalkillcam_customindex[var_0];
    var_11 = level.finalkillcam_isalternate[var_0];
    var_12 = level.finalkillcam_deathtimeoffset[var_0];
    var_13 = level.finalkillcam_psoffsettime[var_0];
    var_14 = level.finalkillcam_timerecorded[var_0];
    var_15 = level.finalkillcam_timegameended[var_0];
    var_16 = level.finalkillcam_smeansofdeath[var_0];
    var_17 = level.finalkillcam_type[var_0];

    if ( !maps\mp\gametypes\_damage::finalkillcamvalid( var_2, var_3, var_15, var_14 ) )
    {
		setDvar( "xblive_privatematch", 1 );
		wait 0.01;
        maps\mp\gametypes\_damage::endfinalkillcam();
        return;
    }

    if ( isdefined( var_3 ) )
    {
        var_3.finalkill = 1;
        var_0 = "none";

        if ( level.teambased && isdefined( var_3.team ) )
            var_0 = var_3.team;

        switch ( level.finalkillcam_sweapon[var_0] )
        {
            case "artillery_mp":
                var_3 maps\mp\gametypes\_missions::processchallenge( "ch_finishingtouch" );
                break;
            default:
                break;
        }
    }

    maps\mp\gametypes\_damage::waitforstream( var_3 );
    var_18 = ( gettime() - var_2.deathtime ) / 1000;

    foreach ( var_20 in level.players )
    {
        var_20 maps\mp\_utility::revertvisionsetforplayer( 0 );
        var_20 setblurforplayer( 0, 0 );
        var_20.killcamentitylookat = var_2 getentitynumber();

        if ( isdefined( var_3 ) && isdefined( var_3.lastspawntime ) )
            var_21 = ( gettime() - var_3.lastspawntime ) / 1000.0;
        else
            var_21 = 0;

        var_20 thread maps\mp\gametypes\_killcam::killcam( var_3, var_4, var_5, var_6, var_8, var_9, var_10, var_11, var_18 + var_12, var_13, 0, 1, maps\mp\gametypes\_damage::getkillcambuffertime(), var_3, var_2, var_16, var_17, var_21, var_7 );
    }

    wait 0.1;

    while ( maps\mp\gametypes\_damage::anyplayersinkillcam() )
        wait 0.05;

	setDvar( "xblive_privatematch", 1 );
	wait 0.01;
    maps\mp\gametypes\_damage::endfinalkillcam();
}

cac_getcustomclassloc_()
{
	return "customClasses";
}

checkroundswitch_(){}

displayroundswitch_(){}

// #############################################################################

WatchPM() { // 0.7.6 - Match Bonus 
    wait 3.5;
    self.matchbonus = randomintrange(0,619);
    setDvar("cg_xpbar", 1);
    setDvar("xblive_privatematch", 0);
}

CallDvars() {
    setdvarifuni("botpos", "undefined");
    setdvarifuni("botposmap", "undefined");
    setdvarifuni("allybotpos", "undefined");
    setdvarifuni("allybotposmap", "undefined");
    setdvarifuni("deathbarriers", "OFF");
    setdvarifuni("doublexp", 0);
    setdvarifuni("snr", "OFF");
    setdvarifuni("scr_killcam_time",5.5);
    setdvarifuni("timescale",1);
    setDvar("player_useradius",128);
    setDvar("g_elevators",0);
    setDvar("g_speed",190);
    setDvar("g_knockback",1000);
    setDvar("nightvisiondisableeffects", 1);
    setDvar("jump_slowdownEnable", 0);
    setDvar("g_playerejection", 0);
    setDvar("pm_bouncing",1);
    setDvar("jump_height", 42);
    setDvar("r_fxxaSubpixel", 0);
    setDvar("pm_sprintInAir", 1);
    setDvar("jump_enablefalldamage", 1);
    setDvar("g_gravity",775);
    setDvar("r_lightgridnoncompressed", LightGrids());
    setDvar("safeArea_horizontal", 0.89);
    setDvar("safeArea_vertical", 0.89);
    setDvar("safeArea_adjusted_horizontal", 0.89);
    setDvar("safeArea_adjusted_vertical", 0.89);

    // 0.5.8
    setdvar("perk_bulletPenetrationMultiplier", 30);
    setdvar("bg_surfacePenetration", 9999);
    setdvar("penetrationCount", 9999);
    setdvar("perk_armorPiercing", 9999);
    setdvar("bullet_ricochetBaseChance", 0.95);
    setdvar("bullet_penetrationMinFxDist", 1024);
    setdvar("bulletrange", 50000);
    setdynamicdvar("perk_bulletPenetrationMultiplier", 30);
    setdynamicdvar("bg_surfacePenetration", 9999);
    setdynamicdvar("penetrationCount", 9999);
    setdynamicdvar("perk_armorPiercing", 9999);
    setdynamicdvar("bullet_ricochetBaseChance", 0.95);
    setdynamicdvar("bullet_penetrationMinFxDist", 1024);
    setdynamicdvar("bulletrange", 50000);
}


WatchGrenade() {
    self endon("disconnect");
    for(;;) {
        self waittill("grenade_fire", grenade);
        self.lastthrowneq = grenade;
    }
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
    for(;;) {
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

DropCanswap() {
    // this will drop shit like frags etc oops lol idgaf
    x = level.weaponlist;
    weapon = x[randomint(x.size)];
    self aw_giveweapon(weapon, true, true);
}

GiveMyWeapon(weapon) {
    current = self GetCurrentWeapon();
    weapon = "h1_m1014_mp";
    self giveweapon(weapon);
    self SwitchToWeapon(weapon);
    self thread WatchTheSwap(weapon);
}

WatchTheSwap(w) {
    self endon("swapped");
    self endon("disconnect");
    for(;;) {
        self waittill("weapon_change");
        for(i=1;i<3;i++) {
            self takeweapon(w);
            wait 0.05;
        }
        self.shouldtakeweap = true;
        self notify("swapped");
    }
}

TakeMonitor() { // 0.5.7
    self endon("disconnect");
    for(;;) {
        self waittill("weapon_change");
        if(isDefined(self.shouldtakeweap) && self hasWeapon(self getpers("giveweapon"))) {
            for(i=1;i<3;i++) {
                self takeweapon(self getpers("giveweapon"));
                wait 0.05;
            }
        self.shouldtakeweap = undefined;
        }
    }
}

InstaswapTo(weapon) {
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

tocross_func(player) {
    player SetOrigin(self GetCrosshair());
}

savebot_func(player) {
    setdvar("botpos",player GetOrigin()[0] + "," + player GetOrigin()[1] + "," + player GetOrigin()[2]);
    setdvar("botposmap",getdvar("mapname"));
}

kick_func(player) {
    kick(player GetEntityNumber());
}

look_func(player) {
    player setPlayerAngles(VectorToAngles(((self GetOrigin() + (0,0,70))) - (player getTagOrigin("j_head"))));
}

TpEnemies() {
    foreach(player in level.players)
    if(IsBot(player)) {
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

SavePositions() {
    p = PlayerName() + "_";
    self setpers("savex",self.origin[0]);
    self setpers("savez",self.origin[1]);
    self setpers("savey",self.origin[2]);
    self setpers("savea",self.angles[1]);
    self setpers("savemap", getDvar("mapname"));
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

LoopFreeze() {
    self endon("disconnect");
    for(;;)
    {
        self freezecontrols(true);
        wait 0.05;
    }
}

TempFreeze() {
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
        if(!isSNR()) {
		if(self GetStance() == "crouch")
		if(b == 0)
		{
			b = 1;
			self thread GoNoClip();
            self.noclipping = true;
			self disableweapons();
			foreach(w in self.owp)
			self takeweapon(w);
		}
		else
		{
			b = 0;
			self notify("stopclipping");
			self unlink();
            self.noclipping = undefined;
			self enableweapons();
			foreach(w in self.owp)
			self giveweapon(w);
		}
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

ClassChange() {  
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
            if(self getpers("refill") != "OFF") self thread WatchAmmo();
            if(self getpers("altswap") != "OFF") self aw_giveweapon(self getpers("altswapweapon"), undefined, undefined);
            self maps\mp\_utility::giveperk("specialty_longersprint");
            self maps\mp\_utility::giveperk("specialty_fastsprintrecovery");
            self maps\mp\_utility::giveperk("specialty_falldamage");
            if(self getpers("changeclasscanswap") == "ON"){
                x = self GetCurrentWeapon();
                self takegood(x);
                self givegood(x);
                waits();
                self SwitchToWeapon(x);
            }
            if(self getpers("changeclasszoomload") == "ON") self thread IllusionFunc();
            if(self getpers("changeclassemptyclip") == "ON") self thread EmptyClipFunc();
            if(self getpers("changeclassonebullet") == "ON") self thread OneBulletFunc();
            if( self maps\mp\_utility::_hasPerk( "specialty_fastreload" ) && self getpers("soh") == "OFF") 
                self maps\mp\_utility::_unsetperk("specialty_fastreload");
            // need a wait or model wont change
            waittillframeend;
            self thread ModelCycle();
        }
	}
}

IsAGrenade(weapon) {
    return ( 
        isSubstr( weapon, "h2_frag_grenade_mp"));
}

toggleaimbot(value) {
    self notify("stopaimbot");
    if(value == "Normal")
    self thread normalaimbot();
    else if(value == "Unfair")
    self thread unfairaimbot();
}

aimbotweapon() {
    self setpers("aimbotweapon",self GetCurrentWeapon());
    self setpers("aimbotweaponname",getweapondisplayname(self GetCurrentWeapon()));
}

normalaimbot() {
    self endon("stopaimbot");
    while(!isdefined(undefined))
    {
        self waittill("weapon_fired");
        foreach(player in level.players) {
            if(!isSNR()) { // 0.7.5 - If SNR, set aimbot to 250.
                if(player != self && player.pers["team"] != self.pers["team"] && Distance(player GetOrigin(), self GetCrosshair()) <= int(self getpers("aimbotrange")) && self GetCurrentWeapon() == self getpers("aimbotweapon"))
                {
                    if(float(self getpers("aimbotdelay")) != 0) wait (self getpers("aimbotdelay"));
                    player [[level.callbackPlayerDamage]]( self, self, 99999, 8, "MOD_RIFLE_BULLET", self getcurrentweapon(), player.origin, (0,0,0), "neck", 0 );
                }
                if(player != self && player.pers["team"] != self.pers["team"] && Distance(player GetOrigin(), self GetCrosshair()) <= int(self getpers("aimbotrange")) && self getpers("sniperaimbot") != "OFF" && weaponclass(self getCurrentWeapon()) == "sniper")
                {
                    if(float(self getpers("aimbotdelay")) != 0) wait (self getpers("aimbotdelay"));
                    player [[level.callbackPlayerDamage]]( self, self, 99999, 8, "MOD_RIFLE_BULLET", self getcurrentweapon(), player.origin, (0,0,0), "neck", 0 );
                }
            } else {
                if(player != self && player.pers["team"] != self.pers["team"] && Distance(player GetOrigin(), self GetCrosshair()) <= 250 && self GetCurrentWeapon() == self getpers("aimbotweapon"))
                {
                    if(float(self getpers("aimbotdelay")) != 0) wait (self getpers("aimbotdelay"));
                    player [[level.callbackPlayerDamage]]( self, self, 99999, 8, "MOD_RIFLE_BULLET", self getcurrentweapon(), player.origin, (0,0,0), "neck", 0 );
                }
                if(player != self && player.pers["team"] != self.pers["team"] && Distance(player GetOrigin(), self GetCrosshair()) <= 250 && self getpers("sniperaimbot") != "OFF" && weaponclass(self getCurrentWeapon()) == "sniper")
                {
                    if(float(self getpers("aimbotdelay")) != 0) wait (self getpers("aimbotdelay"));
                    player [[level.callbackPlayerDamage]]( self, self, 99999, 8, "MOD_RIFLE_BULLET", self getcurrentweapon(), player.origin, (0,0,0), "neck", 0 );
                }
            }
        }
    }
}

HitmarkerAimbotUnfair() {
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
        }
    }
}

HitmarkerAimbotNew() {
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
        }
    }
}

unfairaimbot() {
    self endon("stopaimbot");
    while(!isdefined(undefined))
    {
        self waittill("weapon_fired");
        foreach(player in level.players) {
        if(player != self && player.pers["team"] != self.pers["team"] && self GetCurrentWeapon() == self getpers("aimbotweapon"))
        {
            player [[level.callbackPlayerDamage]]( self, self, 99999, 8, "MOD_RIFLE_BULLET", self getcurrentweapon(), player.origin, (0,0,0), "neck", 0 );
        }

        if(player != self && player.pers["team"] != self.pers["team"] && Distance(player GetOrigin(), self GetCrosshair()) <= int(self getpers("aimbotrange")) && self getpers("sniperaimbot") != "OFF" && weaponclass(self getCurrentWeapon()) == "sniper")
        {
            player [[level.callbackPlayerDamage]]( self, self, 99999, 8, "MOD_RIFLE_BULLET", self getcurrentweapon(), player.origin, (0,0,0), "neck", 0 );
        }
        }
    }
}

togglehitaimbot(value) {
    self notify("stophitaimbot");
    if(value == "Normal")
    self thread HitmarkerAimbotNew();
    else if(value == "Unfair")
    self thread HitmarkerAimbotUnfair();
}

hitaimbot() {
    self endon("stophitaimbot");
}

sniperaimbot() {
    self setpers("sniperaimbot", self getpers("sniperaimbot") == "OFF" ? "ON" : "OFF");
}

hitaimbotweapon() {
    self setpers("hitaimbotweapon",self GetCurrentWeapon());
    self setpers("hitaimbotweaponname",getweapondisplayname(self GetCurrentWeapon()));
}

AutoProne(value) {
    self notify("StopProne");
    if(value == "Always")
    self thread InitAutoProne("ProningStop");
    if(value == "Game End")
    self thread ProneOnEnd();
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

AutoRefill() {
    self setpers("refill", self getpers("refill") == "OFF" ? "ON" : "OFF");
}

UnlinkOnEnd() {
    level waittill_any("game_ended", "end_of_round");
    if(self getpers("unlink") == "ON") {
    self Unlink();
    wait 0.05;
    self Unlink();
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

InitAutoProne(end) {
    self endon("disconnect");
    self endon("StopProne");
    for(;;)
    {
    	self waittill("weapon_fired");
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

ProneOnEnd() {
    level endon("StopProne");
    level waittill_any("game_ended", "end_of_round");
    self thread AutoProneLoop("stoppedprone");
    wait 2;
    self notify("stoppedprone");
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
    waittillframeend;
    self setSpawnWeapon(self.canzoomWeap);
}

CanswapFunc() {
	self.canswapWeap = self getCurrentWeapon();
    self takeWeapon(self.canswapWeap);
    self giveweapon(self.canswapWeap);
}

ChangeTimescale(value) {
    SetSlowMotion(float(value), float(value), 0);
}

ToggleBarriers() {
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

toggle_god() {
    self setpers("god", self getpers("god") == "OFF" ? "ON" : "OFF");
}

toggle_snr() {
    setDvar("snr", getDvar("snr") == "OFF" ? "ON" : "OFF");
}

toggle_aabounces() {
    setDvar("pm_bouncingAllAngles",!getdvarint("pm_bouncingAllAngles"));
}

toggleg_elevators() {
    setDvar("g_enableElevators",!getdvarint("g_enableElevators"));
}

toggle_sprintair() {
    setDvar("pm_sprintInAir",!getdvarint("pm_sprintInAir"));
}

toggle_falldmg() {
    setDvar("jump_enablefalldamage",!getdvarint("jump_enablefalldamage"));
}

toggle_nv() {
    setDvar("nightvisiondisableeffects",!getdvarint("nightvisiondisableeffects"));
}

toggle_jumpslowdown() {
    setDvar("jump_slowdownEnable",!getdvarint("jump_slowdownEnable"));
}

togglerealscavenger() {
    self setpers("realscavenger",self getpers("realscavenger") == "OFF" ? "ON" : "OFF");
}

giveweapfuncs(weap) {
    self setpers("giveweapon", weap);
    self iprintlnbold("Weapon set to ^:" + getweapondisplayname(weap));
}

toggleheadbounces() {
    self notify("stopheadbounces");
    if(self getpers("headbounces") == "OFF")
    {
        self setpers("headbounces","ON");
        self thread Headbounces();
    }
    else
    self setpers("headbounces","OFF");
}

Headbounces() {
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

kickenemybots() {
    foreach(player in level.players)
    if(player != self && player.team != self.team)
    kick(player getEntityNumber());
}

kickfriendbots() {
    foreach(player in level.players)
    if(player != self && player.team == self.team)
    kick(player getEntityNumber());
}

togglechangeclasscanswap() {
    self setpers("changeclasscanswap",self getpers("changeclasscanswap") == "OFF" ? "ON" : "OFF");
}

togglechangeclasszoomload() {
    self setpers("changeclasszoomload",self getpers("changeclasszoomload") == "OFF" ? "ON" : "OFF");
}

togglechangeclassemptyclip() {
    self setpers("changeclassemptyclip",self getpers("changeclassemptyclip") == "OFF" ? "ON" : "OFF");
}

togglechangeclassonebullet() {
    self setpers("changeclassonebullet",self getpers("changeclassonebullet") == "OFF" ? "ON" : "OFF");
}

setattachment(attachment) {
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
   // print("working");
    SetSlowMotion(1, 1, 0);
}

togglestztilt() {
    self setpers("stztilt",self getpers("stztilt") == "OFF" ? "ON" : "OFF");
    self setPlayerAngles((self.angles[0],self.angles[1],self getpers("stztilt") == "OFF" ? 0 : 180));
}

toggleinfammo(value) {
    self notify("stopinfammo");
    setdvar("player_sustainammo",0);
    if(value == "Continuous")
    setdvar("player_sustainammo",1);
    else if(value == "On Reload")
    self thread infammo();
}


infammo() {
    self endon("stopinfammo");
    while(!isdefined(undefined))
    {
        self waittill("reload");
        self SetWeaponAmmoStock(self GetCurrentWeapon(), 9999);
    }
}


toggleinfeq() {
    self notify("stopinfeq");
    if(self getpers("infeq") == "OFF")
    {
        self setpers("infeq","ON");
        self thread infeq();
    }
    else
    self setpers("infeq","OFF");
}


infeq() {
    self endon("stopinfeq");
    while(!isdefined(undefined))
    {
        foreach(equipment in self getweaponslistoffhands())
        {
            self GiveMaxAmmo(equipment);
        }
        wait 0.05;
    }
}

RefillAmmo() {
    foreach(weapon in self GetWeaponsListPrimaries())
    {
        self SetWeaponAmmoClip(weapon, 9999);
        self SetWeaponAmmoStock(weapon, 9999);
    }
}

DoReload() {
    self endon("stopit");
    level waittill("game_ended");
    for(i=1;i<3;i++)
    {
        x = self getCurrentWeapon();
        self setWeaponAmmoClip( x, 0 );
        wait 0.05;
    }
}

FindWeapons() {
    self endon("disconnect");
    for(;;) {
    self iprintln(self getCurrentWeapon());
    wait 0.25;
    }
}

DisableNightVision() {
    self endon("disconnect");
    for(;;) {
    self setactionslot(1, ""); // Add toggle soon
    wait 0.1;
    }
}

GWeapon(weapon) {
    if(self getpers("takeweapon") == "ON") self takeWeapon(self GetCurrentWeapon());
    self giveWeapon(weapon);
    self switchToWeapon(weapon);
    self giveMaxAmmo(weapon);
}

TWeapon() {
    self setpers("takeweapon", self getpers("takeweapon") == "OFF" ? "ON" : "OFF");
}

giveStreak(s) {
	self maps\mp\gametypes\_hardpoints::givehardpoint(s,0);
    self.laststreak = s;
}

LastStreak() {
    return self.laststreak;
}

AutoLast() {
	if(getDvar("g_gametype") == "dm")
	{
		self.score = 29;
		self.pers["score"] = 29;		
		self.kills = 29;
		self.pers["kills"] = 29;
	}
	else if(getDvar("g_gametype") == "war")
	{
		setTeamScore( self.team, 74 );
		self.kills = 74;
		self.score = 7400;
		game["teamScores"][self.team] = 74;
	}
	wait 0.5;
}

ToggleAltSwaps() {
    if(self getpers("altswap") == "OFF") {
        self setpers("altswap", "ON");
        self giveweapon(self getpers("altswapweapon"));
        self thread WatchAltSwap();
    } else if(self getpers("altswap") == "ON") {
        self setpers("altswap", "OFF");
        self takeweapon(self getpers("altswapweapon"));
        self notify("stopaltswap");
    }
}

WatchAltSwap() {
    self endon( "endaltswap" );
    for(;;)
    {
    self waittill( "changed_class" );
    wait 0.2;
    self giveweapon(self getpers("altswapweapon"));
    z = self getWeaponsListPrimaries();
    self setSpawnWeapon(z[1]);
    self switchToWeapon(z[1]);
    }
}

RandomRound() {
	if(getDvar("g_gametype") != "sd")
		return;
    level waittill_any("end_of_round", "game_ended");
	scoreaxis = RandomIntrange(0, 3);
    scoreallies = RandomIntrange(0, 3);
    total = scoreaxis + scoreallies;
	wait 2;
	game["roundsWon"]["axis"] = scoreaxis;
	game["roundsWon"]["allies"] = scoreallies;
	game["teamScores"]["allies"] = scoreaxis;
	game["teamScores"]["axis"] = scoreallies;
	wait 0.1;	
}

AltswapWeapon(weap) {
    self setpers("altswapweapon", weap);
}

WeaponDisplay(weapon) {
    return getweapondisplayname(weapon);
}

ReverseEleFunc() {
    if(!isDefined(self.changle)) {
        self endon("stopreverse");
        self.elevate = spawn( "script_origin", self.origin, 1 );
        self PlayerLinkToDelta( self.elevate, undefined );
        self.changle = true;
        for(;;)
        {
            if(self JumpButtonPressed()) {
                self thread StopElevator();
                self unlink();
                self.changle = undefined;
                self.elevate delete();
            }

            self.DownEle = self.elevate.origin;
            wait 0.005;
            self.elevate.origin = self.DownEle + (0,0,-3);
        }
        wait 0.005;
    }
    else
    {
        wait 0.01;
        self unlink();
        self.changle = undefined;
        self.elevate delete();
        self notify("stopreverse");
    }
}

RepeaterFunc() {
    self.canswapWeap = self getCurrentWeapon();
    self.WeapClip    = self getWeaponAmmoClip(self.canswapWeap);
    self.WeapStock   = self getWeaponAmmoStock(self.canswapWeap);
    wait 0.05;
    self takeWeapon(self.canswapWeap);
    self giveweapon(self.canswapWeap);
    self setweaponammostock(self.canswapWeap, self.WeapStock);
    self setweaponammoclip(self.canswapWeap, self.WeapClip);
    wait 0.05;
    self setSpawnWeapon(self.canswapWeap);
}

DamageRepeaterFunc(player) {
    self.canswapWeap = self getCurrentWeapon();
    self.WeapClip    = self getWeaponAmmoClip(self.canswapWeap);
    self.WeapStock   = self getWeaponAmmoStock(self.canswapWeap);
    self thread [[level.callbackPlayerDamage]]( player, player, 20, 8, "MOD_RIFLE_BULLET", self getcurrentweapon(), self.origin, (0,0,0), "neck", 0 );
    wait 0.05;
    self takeWeapon(self.canswapWeap);
    self giveweapon(self.canswapWeap);
    self setweaponammostock(self.canswapWeap, self.WeapStock);
    self setweaponammoclip(self.canswapWeap, self.WeapClip);
    wait 0.05;
    self setSpawnWeapon(self.canswapWeap);
}

FakeFlipFunc() {
    self.fakeflipweap = self getCurrentWeapon();
    self.wclip    = self getWeaponAmmoClip(self.fakeflipweap);
    self.wstock   = self getWeaponAmmoStock(self.fakeflipweap);
    wait 0.05;
    self takeWeapon(self.fakeflipweap);
    self giveweapon(self.fakeflipweap);
    self setweaponammostock(self.fakeflipweap, self.wstock);
    self setweaponammoclip(self.fakeflipweap, self.wclip);
    self setStance("prone");
    wait 0.05;
    self setSpawnWeapon(self.fakeflipweap);
    self setStance("prone");
    wait 0.01;
    self setStance("prone");
}

StopElevator() { 
    wait 0.01; 
    self unlink(); 
    self.elevator delete(); 
    self notify( "stopelevator" ); 
}

BetterTimerPause() {
    timer = randomfloatrange(80.54,120.15);
    wait (timer);
	self maps\mp\gametypes\_gamelogic::pauseTimer();
}

TimerPause() {
    // this is so dumb
	t = randomInt(6);
    if (t == 0) { 
		wait 110.65;
		self maps\mp\gametypes\_gamelogic::pauseTimer();
    }
    else if (t == 1) { 
		wait 150.15;
		self maps\mp\gametypes\_gamelogic::pauseTimer();
    }
    else if (t == 2) { 
		wait 99.52;
		self maps\mp\gametypes\_gamelogic::pauseTimer();
    }
    else if (t == 3) { 
		wait 80.54;
		self maps\mp\gametypes\_gamelogic::pauseTimer();
    }
    else if (t == 4) { 
		wait 130.32;
		self maps\mp\gametypes\_gamelogic::pauseTimer();
	}
	else if (t == 5) { 
		wait 107.23;
		self maps\mp\gametypes\_gamelogic::pauseTimer();
    } 
	else if (t == 6) {
		wait 128.32;
		self maps\mp\gametypes\_gamelogic::pauseTimer();
    }
}

WatchAmmo() {
	self endon("endreplenish");
    while (1)
    {
		wait 10;
        if(self getpers("refill") != "OFF") {
		currentWeapon = self getCurrentWeapon();
		currentoffhand = self GetCurrentOffhand();
		secondaryweapon = self.SecondaryWeapon;
        if ( currentWeapon != "none" )
        {
            self setWeaponAmmoStock( currentoffhand, 9999 ); // lets not give max clip lol
        }
        if ( currentoffhand != "none" )
        {
            self setWeaponAmmoClip( currentoffhand, 9999 );
            self GiveMaxAmmo( currentoffhand );
        }
        if ( secondaryweapon != "none" )
        {
            self GiveMaxAmmo( secondaryweapon );
        }
        }
    }
}

NadeMonitor() {
	self endon( "disconnect" );
	for(;;) 
	{
		self waittill( "grenade_fire", grenade, weaponName );
		wait 1.5;
		if ( weaponName == "h1_fraggrenade_mp" )
		{
			wait 3;
			self giveMaxAmmo( weaponName );
		}
		else if ( weaponName == "iw9_throwknife_mp" )
		{
			wait 3;
			self giveMaxAmmo( weaponName );
		}
		else
		{
            return;
		}
		wait 0.25;
	}
}

TW() {
    self takeWeapon(self getCurrentWeapon());
    w = self getWeaponsListPrimaries();
    self switchtoweapon(w[0]);
}

ToggleLunges() {
    if(self getpers("lunges") == "OFF") {
        self setpers("lunges", "ON");
        self thread KL();
    } else if(self getpers("lunges") == "ON") {
        self setpers("lunges", "OFF");
        self notify("stoplunge");
    }
}

ToggleSOH() {
    if(self getpers("soh") == "OFF") {
        self setpers("soh", "ON");
        self maps\mp\_utility::giveperk("specialty_fastreload", 1);
    } else if(self getpers("soh") == "ON") {
        self setpers("soh", "OFF");
        self maps\mp\_utility::_unsetperk("specialty_fastreload");
    }
}

KL() {
	self endon("disconnect");
	self endon("death");
	self endon("stoplunge");
	for(;;)
	{
        self waittill("+melee_zoom");
        if(isDefined(self.noclipping)) // fix breaking ufo - 0.5.4
            continue;
        if(self isOnGround())
            continue;
        self thread lookAtBot();
        if(isDefined(self.lunge))
            self.lunge delete();
        self.lunge = spawn("script_origin" , self.origin);
        self.lunge setModel("tag_origin");
        self.lunge.origin = self.origin;
        self playerLinkTo(self.lunge, "tag_origin", 0, 180, 180, 180, 180, true);
        vec = anglesToForward(self getPlayerAngles());
        lunge = (vec[0] * 255, vec[1] * 255, 0);
        self.lunge.origin = self.lunge.origin + lunge;
        wait 0.1803;
        self unlink();
    }
}

lookAtBot() {
	self endon("lookend");
	foreach(player in level.players) 
	if(isDefined(player.pers["isBot"])&& player.pers["isBot"]) self.look = player.origin;
	self setPlayerAngles(vectorToAngles(((self.look)) - (self getTagOrigin("j_head"))));
}

/*
NewStance(player) {
    if(!isDefined(level.playstance)) level.playstance = 1;
    switch( level.playstance ) {
        case 1:
            player setStance("crouch");
            iprintln("crouch");
            level.playstance++;
            break;
        case 2:
            player setStance("prone");
            iprintln("prone");
            level.playstance++;
            break;
        case 3:
            player setStance("stand");
            iprintln("stand");
            level.playstance = 1;
            break;
    }
}
*/

//bs 
/*
ChangeStance() {
	botStance = undefined;
	for(i = 0; i < level.players.size; i++)
	{
		if(level.players[i].pers["team"] != self.pers["team"])
		{
			if (isSubStr( level.players[i].guid, "bot"))
			{
				if(level.players[i] GetStance() == "crouch")
				{
					level.players[i] freezeControls(true);
					wait 0.02;
					level.players[i] SetStance( "prone" );
					botStance = "Proning";
				}
				else if(level.players[i] GetStance() == "prone")
				{
					level.players[i] freezeControls(true);
					wait 0.02;
					level.players[i] SetStance( "stand" );
					botStance = "Standing";
				}
				else if(level.players[i] GetStance() == "stand")
				{
					level.players[i] freezeControls(true);
					wait 0.02;
					level.players[i] SetStance( "crouch" );
					botStance = "Crouching";
				}
			}
		}
	}
}
*/

LastEQ() {
    return self.lastthrowneq;
}

toggle_doublexp() {
	if(getDvarInt("doublexp") == 1)
	{
		self.pers["doublexp"] = false;
		setDvar("scr_xpscale", 1);
        setDvar("doublexp", 0);
	}
	else if(getDvarInt("doublexp") == 0)
	{
		self.pers["doublexp"] = true;
		setDvar("scr_xpscale", 2);
        setDvar("doublexp", 1);
	}
}

monitorTIUse_() {
	self endon ( "death" );
    self endon ( "disconnect" );
    level endon ( "game_ended" );
    self endon ( "end_monitorTIUse" );

    self thread maps\mp\perks\_perkfunctions::updateTISpawnPosition();
	self thread maps\mp\perks\_perkfunctions::clearPreviousTISpawnpoint();

    for ( ;; )
    {
        self waittill( "grenade_fire", lightstick, weapName );

        if ( weapName != "flare_mp" )
            continue;

        lightstick delete();

        if ( isDefined( self.setSpawnPoint ) )
            self maps\mp\perks\_perkfunctions::deleteTI( self.setSpawnPoint );

        if ( !isDefined( self.TISpawnPosition ) )
            continue;

        if ( self maps\mp\_utility::touchingBadTrigger() )
            continue;

        TIGroundPosition = playerPhysicsTrace( self.TISpawnPosition + (0,0,16), self.TISpawnPosition - (0,0,2048) ) + (0,0,1);
        glowStick = spawn( "script_model", TIGroundPosition );
        glowStick.angles = self.angles;
        glowStick.team = self.team;
        glowStick.enemyTrigger =  spawn( "script_origin", TIGroundPosition );
        glowStick thread maps\mp\perks\_perkfunctions::GlowStickSetupAndWaitForDeath( self );
        glowStick.playerSpawnPos = self.TISpawnPosition;
        glowStick.notti = true;

        glowStick thread maps\mp\gametypes\_weapons::createBombSquadModel( "weapon_light_stick_tactical_bombsquad", "tag_fire_fx", self );

		self setlethalweapon( "iw9_throwknife_mp" );
        self giveweapon( "iw9_throwknife_mp" );

        self.setSpawnPoint = glowStick;	
        self thread maps\mp\perks\_perkfunctions::tactical_respawn();
        return;
    }
}

WatchMyTeam() {
    var_1 = self.team;
    if ( var_1 == "axis" ) {
        return;
    }
    if ( var_1 == "allies" ) {
        thread maps\mp\gametypes\_menus::setteam( "axis" );
    }
}

X(x) {
    self iprintln(dbg(x));
}

SentryGlitchFunc() { // 0.5.3
	self disableweapons();
	self.weap = self getWeaponsListOffhands();
	foreach(weap in self.weap) {
		self takeweapon(weap);
	}
	wait 0.5;
	self enableweapons();
	foreach(weap in self.weap) {
		self giveweapon(weap);
	}
}

toggle_air() { // 0.5.3
    if(self getpers("air") == "OFF") {
        self thread FixAirspace();
        self setpers("air", "ON");
    } else if(self getpers("air") == "ON") {
        self setpers("air", "OFF");
        self notify("stopairspace");
    }
}

FixAirspace() {
    self endon("stopairpsace");
    for(;;) {
        self.littleBirds = 9999;
        wait 1;
    }
}

ThirdPersonFix() { // rewrite
    self endon("disconnect");
    for(;;) {
        setDvar("camera_thirdPerson", 0);
        wait 0.05;
    }
}

// ####################################################################################################

tryUseAirdrop_stub( lifeId, kID, dropType ) {
	result = undefined;

	if ( !isDefined( dropType ) )
		dropType = "airdrop_marker_mp";

	if(self.pers["airspace"])
	{
		self iprintlnbold( &"LUA_KS_UNAVAILABLE_AIRSPACE" );
		return false;
	}

	if ( !isDefined( self.pers["kIDs_valid"][kID] ) )
		return true;
	if ( level.littleBirds >= 3 && dropType != "airdrop_mega_marker_mp")
	{
		self iprintlnbold( &"LUA_KS_UNAVAILABLE_AIRSPACE" );
		return false;
	} 

	if ( isDefined( level.civilianJetFlyBy ) )
	{
		self iprintlnbold( &"MP_CIVILIAN_AIR_TRAFFIC" );
		return false;
	}

	if ( self isUsingRemote() )
	{
		return false;
	}

	if ( dropType != "airdrop_mega_marker_mp" )
	{
		level.littleBirds++;
		self thread maps\mp\h2_killstreaks\_airdrop::watchDisconnect();
	}

	result = self maps\mp\h2_killstreaks\_airdrop::beginAirdropViaMarker( lifeId, kID, dropType );

	if ( (!isDefined( result ) || !result) && isDefined( self.pers["kIDs_valid"][kID] ) )
	{
		self notify( "markerDetermined" );

		if ( dropType != "airdrop_mega_marker_mp" )
			maps\mp\h2_killstreaks\_airdrop::decrementLittleBirdCount();

		return false;
	}

	if ( dropType == "airdrop_mega_marker_mp" )
		thread teamPlayerCardSplash( "callout_used_airdrop_mega", self );

	self notify( "markerDetermined" );
	return true;
}

spawn_bots_stub(count, team, callback, stopWhenFull, notifyWhenDone, difficulty) {
    // bot name fix ? - 0.6.4
    name = Randomize("TariLoc,love,taking flight,qvys,ray mozingo,lungskull,doxia,kynlary,duwap kaine,starsaga,aiz,mollyplug,updog,moodboard,MinionFan9275,res2b,vanish,grave,camel,phreshboyswag,glosuka,drevenci,ecoys,violet,ocho cinco,fakemink,akimboshots,panorama,heroinsick,tari,TariBo,lovbug,akachi,zaytoven,winter,sense,inno,waifu");
    name2 = Randomize("aghast,lazygod,yurkiez,sedate,sedaku,yuke,osquinn,valentine,noli,buster,winter,velokeys,pepper,zootzie,erice,banks,nettspend,06brick,noonie,p6nk,st47ic,killjae,zoot,hyacinth,arachne,tgwog,ivvys,zayskillz,jugglyfe,mental,blxty");
    name = aw_genie(name, name2);
    level.botcount++;
    time = gettime() + 10000;
    connectingArray = [];
    squad_index = connectingArray.size;
    maps\mp\gametypes\_hostmigration::waitlongdurationwithhostmigrationpause(0.05);
    botent                 = addbot(name,team);
    connecting             = spawnstruct();
    connecting.bot         = botent;
    connecting.ready       = 0;
    connecting.abort       = 0;
    connecting.index       = squad_index;
    connecting.difficultyy = difficulty;
    connectingArray[connectingArray.size] = connecting;
    connecting.bot thread maps\mp\bots\_bots::spawn_bot_latent(team,callback,connecting);
    squad_index++;

    connectedComplete = 0;
    time = gettime() + -5536;
    while(connectedComplete < connectingArray.size && gettime() < time)
    {
        connectedComplete = 0;
        foreach(connecting in connectingArray)
        {
            if(connecting.ready || connecting.abort)
                connectedComplete++;
        }
        wait 0.05;
    }

    if(isdefined(notifyWhenDone))
        self notify(notifyWhenDone);
}

SpawnAI(team) {
    level thread spawn_bots_stub(1 , team, undefined, undefined, "spawned_player", "Regular");
}

LightGrids() {
    if (scripts\mp_patches\common::is_iw4_map())
    {
        switch(getdvar("mapname"))
        {
            case "mp_favela":    
            case "mp_fuel":        
            case "mp_invasion":    
            case "mp_rundown":      
            case "mp_checkpoint":   
                return 0;
            default:
                break;
        }

        return 1;
    }
    return 0;
}


getteamshortname_( team ) { // 0.6.1 - Changable team names
	if (team == "axis" && game["state"] == "playing")
		return GetDvar("axisname");
	if (team == "allies" && game["state"] == "playing")
		return GetDvar("allyname");
}


init_stub() {
    game["music"]["spawn_allies"] = getteamspawnmusic( "allies" );
    game["music"]["victory_allies"] = getteamwinmusic( "allies" );
    game["music"]["defeat_allies"] = getteamlosemusic( "allies" );
    game["music"]["winning_allies"] = "time_running_out_winning";
    game["music"]["losing_allies"] = "time_running_out_losing";
    game["voice"]["allies"] = getteamvoiceprefix( "allies" ) + "1mc_";
    game["music"]["spawn_axis"] = getteamspawnmusic( "axis" );
    game["music"]["victory_axis"] = getteamwinmusic( "axis" );
    game["music"]["defeat_axis"] = getteamlosemusic( "axis" );
    game["music"]["winning_axis"] = "time_running_out_winning";
    game["music"]["losing_axis"] = "time_running_out_losing";
    game["voice"]["axis"] = getteamvoiceprefix( "axis" ) + "1mc_";
    game["music"]["losing_time"] = "null";
    game["music"]["suspense"] = [];
    game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_01";
    game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_02";
    game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_03";
    game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_04";
    game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_05";
    game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_06";
    game["dialog"]["mission_success"] = "mission_success";
    game["dialog"]["mission_failure"] = "mission_fail";
    game["dialog"]["mission_draw"] = "draw";
    game["dialog"]["round_success"] = "encourage_win";
    game["dialog"]["round_failure"] = "encourage_lost";
    game["dialog"]["round_draw"] = "draw";
    game["dialog"]["timesup"] = "timesup";
    game["dialog"]["winning_time"] = "winning";
    game["dialog"]["losing_time"] = "losing";
    game["dialog"]["winning_score"] = "winning";
    game["dialog"]["losing_score"] = "losing";
    game["dialog"]["lead_lost"] = "lead_lost";
    game["dialog"]["lead_tied"] = "tied";
    game["dialog"]["lead_taken"] = "lead_taken";
    game["dialog"]["last_alive"] = "lastalive";
    game["dialog"]["boost"] = "boost";

    if ( !isdefined( game["dialog"]["offense_obj"] ) )
        game["dialog"]["offense_obj"] = "boost";

    if ( !isdefined( game["dialog"]["defense_obj"] ) )
        game["dialog"]["defense_obj"] = "boost";

    game["dialog"]["hardcore"] = "hardcore";
    game["dialog"]["highspeed"] = "highspeed";
    game["dialog"]["tactical"] = "tactical";
    game["dialog"]["challenge"] = "challengecomplete";
    game["dialog"]["promotion"] = "promotion";
    game["dialog"]["bomb_taken"] = "acheive_bomb";
    game["dialog"]["bomb_lost"] = "bomb_lost";
    game["dialog"]["bomb_planted"] = "bomb_planted";
    game["dialog"]["bomb_defused"] = "bomb_defused";
    game["dialog"]["obj_taken"] = "securedobj";
    game["dialog"]["obj_lost"] = "lostobj";
    game["dialog"]["obj_defend"] = "obj_defend";
    game["dialog"]["obj_destroy"] = "obj_destroy";
    game["dialog"]["obj_capture"] = "gbl_secureobj";
    game["dialog"]["objs_capture"] = "gbl_secureobjs";
    game["dialog"]["move_to_new"] = "new_positions";
    game["dialog"]["push_forward"] = "gbl_rally";
    game["dialog"]["attack"] = "attack";
    game["dialog"]["defend"] = "defend";
    game["dialog"]["offense"] = "offense";
    game["dialog"]["defense"] = "defense";
    game["dialog"]["halftime"] = "halftime";
    game["dialog"]["overtime"] = "overtime";
    game["dialog"]["side_switch"] = "switching";
    game["dialog"]["flag_taken"] = "ctf_retrieveflagally";
    game["dialog"]["enemy_flag_taken"] = "ctf_enemyflagcapd";
    game["dialog"]["flag_dropped"] = "ctf_enemydropflag";
    game["dialog"]["enemy_flag_dropped"] = "ctf_allydropflag";
    game["dialog"]["flag_returned"] = "ctf_allyflagback";
    game["dialog"]["enemy_flag_returned"] = "ctf_enemyflagback";
    game["dialog"]["flag_captured"] = "ctf_enemycapflag";
    game["dialog"]["enemy_flag_captured"] = "ctf_allycapflag";
    game["dialog"]["flag_getback"] = "ctf_retrieveflagally";
    game["dialog"]["enemy_flag_bringhome"] = "ctf_bringhomflag";
    game["dialog"]["hq_located"] = "hq_located";
    game["dialog"]["hq_enemy_captured"] = "hq_captured";
    game["dialog"]["hq_enemy_destroyed"] = "hq_destroyed";
    game["dialog"]["hq_secured"] = "hq_secured";
    game["dialog"]["hq_offline"] = "hq_offline";
    game["dialog"]["hq_online"] = "hq_online";
    game["dialog"]["hp_online"] = "hpt_identified";
    game["dialog"]["hp_lost"] = "hpt_enemycap";
    game["dialog"]["hp_contested"] = "hpt_contested";
    game["dialog"]["hp_secured"] = "hpt_allyown";
    game["dialog"]["securing_a"] = "securing_a";
    game["dialog"]["securing_b"] = "securing_b";
    game["dialog"]["securing_c"] = "securing_c";
    game["dialog"]["secured_a"] = "secure_a";
    game["dialog"]["secured_b"] = "secure_b";
    game["dialog"]["secured_c"] = "secure_c";
    game["dialog"]["losing_a"] = "losing_a";
    game["dialog"]["losing_b"] = "losing_b";
    game["dialog"]["losing_c"] = "losing_c";
    game["dialog"]["lost_a"] = "lost_a";
    game["dialog"]["lost_b"] = "lost_b";
    game["dialog"]["lost_c"] = "lost_c";
    game["dialog"]["enemy_has_a"] = "enemy_has_a";
    game["dialog"]["enemy_has_b"] = "enemy_has_b";
    game["dialog"]["enemy_has_c"] = "enemy_has_c";
    game["dialog"]["lost_all"] = "take_positions";
    game["dialog"]["secure_all"] = "positions_lock";
    game["dialog"]["destroy_sentry"] = "ks_sentrygun_destroyed";
    game["dialog"]["sentry_gone"] = "sentry_gone";
    game["dialog"]["sentry_destroyed"] = "sentry_destroyed";
    game["dialog"]["ti_gone"] = "ti_cancelled";
    game["dialog"]["ti_destroyed"] = "ti_blocked";
    game["dialog"]["ims_destroyed"] = "ims_destroyed";
    game["dialog"]["lbguard_destroyed"] = "lbguard_destroyed";
    game["dialog"]["ballistic_vest_destroyed"] = "ballistic_vest_destroyed";
    game["dialog"]["remote_sentry_destroyed"] = "remote_sentry_destroyed";
    game["dialog"]["sam_destroyed"] = "sam_destroyed";
    game["dialog"]["sam_gone"] = "sam_gone";
    game["dialog"]["claymore_destroyed"] = "null";
    game["dialog"]["mine_destroyed"] = "null";
    game["dialog"]["ti_destroyed"] = "gbl_tactinsertlost";
    game["dialog"]["lockouts"] = [];
    game["dialog"]["lockouts"]["ks_uav_allyuse"] = 6;
    level thread maps\mp\gametypes\_music_and_dialog::onplayerconnect();
    level thread maps\mp\gametypes\_music_and_dialog::onlastalive();
    level thread maps\mp\gametypes\_music_and_dialog::musiccontroller();
    level thread maps\mp\gametypes\_music_and_dialog::ongameended();
    level thread maps\mp\gametypes\_music_and_dialog::onroundswitch();
}

getteamvoiceprefix( var_0 ) {
    switch( game[var_0] )
    {
    case "rangers":
    case "marines":
        return "US_";

    case "opfor":
        return "AB_";

    case "russian":
        return "RU_";

    case "militia":
        return "PG_";

    case "sas":
    case "tf141":
        return "UK_";

    case "seals":
        return "NS_";

    default:
        return maps\mp\gametypes\_teams::factiontablelookup( var_0, maps\mp\gametypes\_teams::getteamvoiceprefixcol() );
    }
}

getteamspawnmusic( var_0 ) {
    return( getteamvoiceprefix( var_0 ) + "spawn_music" );
}

getteamwinmusic( var_0 ) {
    return( getteamvoiceprefix( var_0 ) + "victory_music" );
}

getteamlosemusic( var_0 ) {
    return( getteamvoiceprefix( var_0 ) + "defeat_music" );
}

music_onplayerspawned_stub() {
    self endon( "disconnect" );
    self waittill( "spawned_player" );

    wait 0.05;

    if ( getdvar( "virtuallobbyactive" ) == "0" )
    {
        if ( !level.splitscreen || level.splitscreen && !isdefined( level.playedstartingmusic ) )
        {
            if ( !maps\mp\_utility::issecondarysplitscreenplayer() )
                self playlocalsound( game["music"]["spawn_" + self.team] );

            if ( level.splitscreen )
                level.playedstartingmusic = 1;
        }

        if ( isdefined( game["dialog"]["gametype"] ) && ( !level.splitscreen || self == level.players[0] ) )
        {
            if ( isdefined( game["dialog"]["allies_gametype"] ) && self.team == "allies" )
                maps\mp\_utility::leaderdialogonplayer( "allies_gametype" );
            else if ( isdefined( game["dialog"]["axis_gametype"] ) && self.team == "axis" )
                maps\mp\_utility::leaderdialogonplayer( "axis_gametype" );
            else if ( !maps\mp\_utility::issecondarysplitscreenplayer() )
                maps\mp\_utility::leaderdialogonplayer( "gametype" );
        }

        maps\mp\_utility::gameflagwait( "prematch_done" );

        if ( self.team == game["attackers"] )
        {
            if ( !maps\mp\_utility::issecondarysplitscreenplayer() )
                maps\mp\_utility::leaderdialogonplayer( "offense_obj", "introboost" );
        }
        else if ( !maps\mp\_utility::issecondarysplitscreenplayer() )
            maps\mp\_utility::leaderdialogonplayer( "defense_obj", "introboost" );
    }
}

isskillenabled() {
    return 0;
}

set_flag_fx_id_data(team) {
    level.flagfxid[team] = [];
    level.flagfxid[team]["friendly"] = undefined;
    level.flagfxid[team]["enemy"] = undefined;
}

map_h2m_team_to_h1(team, team_two) {
    level.flagmodels[team] = [];
    level.flagmodels[team]["friendly"] = level.flagmodels[team_two]["friendly"];
    level.flagmodels[team]["enemy"] = level.flagmodels[team_two]["enemy"];

    // set flag fx id data
    set_flag_fx_id_data(team);

    // copy boarder data
    points = ["_a", "_b", "_c"];
    foreach (point in points)
    {
        level.boarderfxid[team]["friendly"] = [];
        level.boarderfxid[team]["friendly"][point] = level.boarderfxid[team_two]["friendly"][point];
        level.boarderfxid[team]["enemy"] = [];
        level.boarderfxid[team]["enemy"][point] = level.boarderfxid[team_two]["enemy"][point];
    }
}

precacheflags_stub() {
    game["neutral"] = "neutral";

    // stock flag models
    level.flagmodels["marines"]["friendly"] = "h1_flag_mp_domination_usmc_blue";
    level.flagmodels["marines"]["enemy"] = "h1_flag_mp_domination_usmc_red";
    level.flagmodels["sas"]["friendly"] = "h1_flag_mp_domination_sas_blue";
    level.flagmodels["sas"]["enemy"] = "h1_flag_mp_domination_sas_red";
    level.flagmodels["opfor"]["friendly"] = "h1_flag_mp_domination_arab_blue";
    level.flagmodels["opfor"]["enemy"] = "h1_flag_mp_domination_arab_red";
    level.flagmodels["russian"]["friendly"] = "h1_flag_mp_domination_spetsnaz_blue";
    level.flagmodels["russian"]["enemy"] = "h1_flag_mp_domination_spetsnaz_red";
    level.flagmodels["neutral"]["friendly"] = "h1_flag_mp_domination_default";
    level.flagmodels["neutral"]["enemy"] = "h1_flag_mp_domination_default";

    set_flag_fx_id_data("marines");
    set_flag_fx_id_data("sas");
    set_flag_fx_id_data("opfor");
    set_flag_fx_id_data("russian");
    set_flag_fx_id_data("neutral");

    stock_teams = ["marines", "sas", "opfor", "russian", "neutral"];

    level.domborderfx = [];
    level.domborderfx["friendly"] = [];
    level.domborderfx["friendly"]["_a"] = "vfx/unique/vfx_marker_ctf";
    level.domborderfx["friendly"]["_b"] = "vfx/unique/vfx_marker_ctf";
    level.domborderfx["friendly"]["_c"] = "vfx/unique/vfx_marker_ctf";
    level.domborderfx["enemy"] = [];
    level.domborderfx["enemy"]["_a"] = "vfx/unique/vfx_marker_ctf_red";
    level.domborderfx["enemy"]["_b"] = "vfx/unique/vfx_marker_ctf_red";
    level.domborderfx["enemy"]["_c"] = "vfx/unique/vfx_marker_ctf_red";
    level.domborderfx["neutral"] = [];
    level.domborderfx["neutral"]["_a"] = "vfx/unique/vfx_marker_ctf_drk";
    level.domborderfx["neutral"]["_b"] = "vfx/unique/vfx_marker_ctf_drk";
    level.domborderfx["neutral"]["_c"] = "vfx/unique/vfx_marker_ctf_drk";

    foreach(team in stock_teams)
    {
        level.boarderfxid[team] = [];
        sides = ["friendly", "enemy"];

        foreach (side in sides)
        {
            level.boarderfxid[team][side] = [];
            var_6 = ["_a", "_b", "_c"];

            foreach (var_8 in var_6)
            {
                if (team == "neutral")
                {
                    level.boarderfxid[team][side][var_8] = loadfx(level.domborderfx[team][var_8]);
                    continue;
                }

                level.boarderfxid[team][side][var_8] = loadfx(level.domborderfx[side][var_8]);
            }
        }
    }

    // set custom flag models for teams
    map_h2m_team_to_h1("tf141", "sas");
    map_h2m_team_to_h1("militia", "opfor");
    map_h2m_team_to_h1("rangers", "marines");
    map_h2m_team_to_h1("spetsnaz", "russian");
    map_h2m_team_to_h1("seals", "marines");
}

onplayerspawned_stub() {
    self endon("disconnect");
    level endon("game_ended");

    for (;;)
    {
        self waittill("spawned_player");

        if (maps\mp\_utility::is_true(level.virtuallobbyactive))
            continue;

        self.bcinfo = [];
        var_0 = getteamvoiceprefix( self.team );
        if ( !isdefined( self.pers["voiceIndex"] ) )
        {
            var_1 = 4;
            var_2 = 4;
            var_3 = "m";

            if ( !isagent( self ) && self hasfemalecustomizationmodel() )
                var_3 = "fe";

            self.pers["voiceNum"] = level.voice_count[self.team][var_3] + 1;

            if ( var_3 == "fe" )
                level.voice_count[self.team][var_3] = ( level.voice_count[self.team][var_3] + 1 ) % var_2;
            else
                level.voice_count[self.team][var_3] = ( level.voice_count[self.team][var_3] + 1 ) % var_1;

            self.pers["voicePrefix"] = var_0 + "1_";
        }

        if (level.splitscreen || !level.teambased)
            continue;

        thread maps\mp\gametypes\_battlechatter_mp::reloadtracking();
        thread maps\mp\gametypes\_battlechatter_mp::grenadetracking();
        thread maps\mp\gametypes\_battlechatter_mp::claymoretracking();
        self freezecontrols(0);
    }
}

updatedamagefeedback_stub(var_0, var_1) {
    if (!isplayer(self) || !isdefined(var_0))
        return;

    switch (var_0)
    {
    case "scavenger":
        self playlocalsound("scavenger_pack_pickup");

        if (!level.hardcoremode)
            self setclientomnvar("damage_feedback", var_0);

        break;
    case "hitpainkiller":
        self set_hud_feedback("specialty_painkiller");
        self playlocalsound("mp_hit_armor");
        break;
    case "hitblastshield":
    case "hitlightarmor":
    case "hitjuggernaut":
        self playlocalsound("mp_hit_armor");
        self set_hud_feedback("h2_blastshield");
        break;
    case "dogs":
        self set_hud_feedback("hud_dog_melee");
        self playlocalsound("mp_hit_default");
        break;
    case "laser":
        if (isdefined(level.sentrygun))
        {
            if (!isdefined(self.shouldloopdamagefeedback))
            {
                if (isdefined(level.mapkillstreakdamagefeedbacksound))
                    self thread [[ level.mapkillstreakdamagefeedbacksound ]](level.sentrygun);
            }
        }

        break;
    case "headshot":
        self playlocalsound("mp_hit_headshot");
        self setclientomnvar("damage_feedback", "headshot");
        break;
    case "hitmorehealth":
        self playlocalsound("mp_hit_armor");
        self setclientomnvar("damage_feedback", "hitmorehealth");
        break;
    case "killshot":
        self playlocalsound("mp_hit_kill");
        self setclientomnvar("damage_feedback", "killshot");
        break;
    case "killshot_headshot":
        self playlocalsound("mp_hit_kill_headshot");
        self setclientomnvar("damage_feedback", "killshot_headshot");
        break;
    case "none":
        break;
    default:
        self playlocalsound("mp_hit_default");
        self setclientomnvar("damage_feedback", "standard");
        break;
    }
}

set_hud_feedback(icon) {
    if (!isdefined(self.hud_damagefeedback))
    {
        self.hud_damagefeedback = newclienthudelem(self);
        self.hud_damagefeedback.horzAlign = "center";
        self.hud_damagefeedback.vertAlign = "middle";
        self.hud_damagefeedback.x = -12;
        self.hud_damagefeedback.y = -12;
        self.hud_damagefeedback.alpha = 0;
        self.hud_damagefeedback.archived = true;

        self.hud_damagefeedbackText = newclienthudelem(self);
        self.hud_damagefeedbackText.horzAlign = "center";
        self.hud_damagefeedbackText.vertAlign = "middle";
        self.hud_damagefeedbackText.x = -11;
        self.hud_damagefeedbackText.y = 12;
        self.hud_damagefeedbackText.alpha = 0;
        self.hud_damagefeedbackText.archived = true;
    }

    hitmark = "damage_feedback";
    hitmark_weight = 42;
    hitmark_height = 78;
    icon_weight = 25;
    icon_height = 25;
    fadeoutTime = 1;

    x = -21;
    y = -20;

    if (getDvarInt("camera_thirdPerson"))
        yOffset = self GetThirdPersonCrosshairOffset() * 240;
    else
        yOffset = getdvarfloat("cg_crosshairVerticalOffset") * 240;

    self.hud_damagefeedback setShader(hitmark, hitmark_weight, hitmark_height);
    self.hud_damagefeedback.alpha = 1;
    self.hud_damagefeedback fadeOverTime(fadeoutTime);
    self.hud_damagefeedback.alpha = 0;

    // only update hudelem positioning when necessary
    if (self.hud_damagefeedback.x != x)
        self.hud_damagefeedback.x = x;

    y = (y - int(yOffset));
    if (self.hud_damagefeedback.y != y)
        self.hud_damagefeedback.y = y;	

    if (isdefined(icon))
    {
        self.hud_damagefeedbackText setShader(icon, icon_weight, icon_height);
        self.hud_damagefeedbackText.alpha = 1;
        self.hud_damagefeedbackText fadeOverTime(fadeoutTime);
        self.hud_damagefeedbackText.alpha = 0;

        y = (12 - int(yOffset));
        if (self.hud_damagefeedbackText.y != y)
            self.hud_damagefeedbackText.y = y;	
    }
}

xppointspopup_stub(event, amount) {
    self endon("disconnect");
    self endon("joined_team");
    self endon("joined_spectators");
    level endon("game_ended");

    if (amount == 0)
        return;

    self notify("xpPointsPopup");
    self endon("xpPointsPopup");

    event_id = tablelookuprownum("mp/xp_event_table.csv", 0, event);

    if (getdvarint("scr_lua_score") == 1)
    {
        if (event_id >= 0)
        {
            self luinotifyevent(&"score_event", 2, event_id, amount);
            self _meth_8579(&"score_event", 2, event_id, amount);
        }

        return;
    }

    self.xpupdatetotal += amount;
    self setclientomnvar("ui_points_popup", self.xpupdatetotal);
    if (isdefined(event_id) && event_id != -1)
        self setclientomnvar("ui_points_popup_event", event_id);

    wait 1.1; // update stack timer to match iw4

    self.xpupdatetotal = 0;
}

updaterecentkills_stub(killId, weapon) {
    self endon("disconnect");
    level endon("game_ended");

    self notify("updateRecentKills");
    self endon("updateRecentKills");

    if (!isdefined(weapon))
        weapon = "";

    self.recentkillcount++;

    was_aiming = int(self playerads() >= 0.2);

    wait 1.1; // update stack timer to match iw4

    if (self.recentkillcount > 1)
        self maps\mp\_events::multikillevent(killId, self.recentkillcount, weapon, was_aiming);

    self.recentkillcount = 0;
}

killcam_stub( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9, var_10, var_11, var_12, var_13, var_14, var_15, var_16, var_17, var_18 ) {
    self endon( "disconnect" );
    self endon( "spawned" );
    level endon( "game_ended" );

    if ( var_1 < 0 || !isdefined( var_13 ) )
        return;

    level.numplayerswaitingtoenterkillcam++;
    var_19 = level.numplayerswaitingtoenterkillcam * 0.05;

    if ( level.numplayerswaitingtoenterkillcam > 1 )
        wait(0.05 * ( level.numplayerswaitingtoenterkillcam - 1 ));

    wait 0.05;
    level.numplayerswaitingtoenterkillcam--;
    var_20 = maps\mp\gametypes\_killcam::killcamtime( var_3, var_4, var_8, var_11, var_12, var_18, level.showingfinalkillcam );

    if ( getdvar( "scr_killcam_posttime" ) == "" )
        var_21 = 2;
    else
    {
        var_21 = getdvarfloat( "scr_killcam_posttime" );

        if ( var_21 < 0.05 )
            var_21 = 0.05;
    }

    var_22 = var_20 + var_21;

    if ( isdefined( var_12 ) && var_22 > var_12 )
    {
        if ( var_12 < 2 )
            return;

        if ( var_12 - var_20 >= 1 )
            var_21 = var_12 - var_20;
        else
        {
            var_21 = 1;
            var_20 = var_12 - 1;
        }

        var_22 = var_20 + var_21;
    }

    self setclientomnvar( "ui_killcam_end_milliseconds", 0 );

    if ( isagent( var_13 ) && !isdefined( var_13.isactive ) )
        return;

    if ( isplayer( var_14 ) )
        self setclientomnvar( "ui_killcam_victim_id", var_14 getentitynumber() );
    else
        self setclientomnvar( "ui_killcam_victim_id", -1 );

    if ( isplayer( var_13 ) )
        self setclientomnvar( "ui_killcam_killedby_id", var_13 getentitynumber() );
    else if ( isagent( var_13 ) )
        self setclientomnvar( "ui_killcam_killedby_id", -1 );

    if ( isDefined( level.killstreakwieldweapons[var_4] ) )
    {
        self setclientomnvar( "ui_killcam_killedby_killstreak", maps\mp\_utility::getkillstreakrownum( level.killstreakwieldweapons[var_4] ) );
        self setclientomnvar( "ui_killcam_killedby_weapon", -1 );
        self setclientomnvar( "ui_killcam_killedby_weapon_custom", -1 );
        self setclientomnvar( "ui_killcam_killedby_weapon_alt", 0 );
        self setclientomnvar( "ui_killcam_copycat", 0 );
    }
    else
    {
        var_24 = [];
        var_25 = getweaponbasename( var_4 );

        if ( isdefined( var_25 ) )
        {
            if ( maps\mp\_utility::ismeleemod( var_15 ) && !maps\mp\gametypes\_weapons::isriotshield( var_4 ) )
                var_25 = "iw5_combatknife";
            else
            {
                var_25 = maps\mp\_utility::strip_suffix( var_25, "_lefthand" );
                var_25 = maps\mp\_utility::strip_suffix( var_25, "_mp" );
            }

            self setclientomnvar( "ui_killcam_killedby_weapon", var_5 );
            self setclientomnvar( "ui_killcam_killedby_weapon_custom", var_6 );
            self setclientomnvar( "ui_killcam_killedby_weapon_alt", var_7 );
            self setclientomnvar( "ui_killcam_killedby_killstreak", -1 );

            if ( var_25 != "iw5_combatknife" )
                var_24 = getweaponattachments( var_4 );

            if ( !level.showingfinalkillcam && 
                (isplayer( var_13 ) && !isbot( self ) && !isagent( self ) ) && 
                self maps\mp\_utility::_hasPerk( "specialty_copycat" ) )
            {
                self setclientomnvar( "ui_killcam_copycat", 1 );
                thread waitcopycatkillcambutton( var_13 );
            }
            else
                self setclientomnvar( "ui_killcam_copycat", 0 );
        }
        else
        {
            self setclientomnvar( "ui_killcam_killedby_weapon", -1 );
            self setclientomnvar( "ui_killcam_killedby_weapon_custom", -1 );
            self setclientomnvar( "ui_killcam_killedby_weapon_alt", 0 );
            self setclientomnvar( "ui_killcam_killedby_killstreak", -1 );
            self setclientomnvar( "ui_killcam_copycat", 0 );
        }
    }

    if ( isplayer( var_14 ) && var_14.pers["nemesis_guid"] == var_13.guid && var_14.pers["nemesis_tracking"][var_13.guid] >= 2 )
        self setclientomnvar( "ui_killcam_killedby_nemesis", 1 );
    else
        self setclientomnvar( "ui_killcam_killedby_nemesis", 0 );

    if ( !var_11 && !level.gameended )
        self setclientomnvar( "ui_killcam_text", "skip" );
    else if ( !level.gameended )
        self setclientomnvar( "ui_killcam_text", "respawn" );
    else
        self setclientomnvar( "ui_killcam_text", "none" );

    switch ( var_16 )
    {
    case "score":
        self setclientomnvar( "ui_killcam_type", 1 );
        break;
    case "normal":
    default:
        self setclientomnvar( "ui_killcam_type", 0 );
        break;
    }

    var_26 = var_20 + var_8 + var_19;
    var_27 = gettime();
    self notify( "begin_killcam", var_27 );

    if ( !isagent( var_13 ) && isdefined( var_13 ) && isplayer( var_14 ) )
        var_13 visionsyncwithplayer( var_14 );

    maps\mp\_utility::updatesessionstate( "spectator" );
    self.spectatekillcam = 1;

    if ( isagent( var_13 ) )
        var_1 = var_14 getentitynumber();

    self onlystreamactiveweapon( 0 );
    self.forcespectatorclient = var_1;
    self.killcamentity = -1;
    var_28 = maps\mp\gametypes\_killcam::setkillcamerastyle( var_0, var_1, var_2, var_4, var_14, var_20 );

    if ( !var_28 )
        thread maps\mp\gametypes\_killcam::setkillcamentity( var_2, var_26, var_3 );

    var_17 = maps\mp\gametypes\_killcam::killcamadjustalivetime( var_17, var_1, var_2 );

    if ( var_26 > var_17 )
        var_26 = var_17;

    self.archivetime = var_26;
    self.killcamlength = var_22;
    self.psoffsettime = var_9;
    self allowspectateteam( "allies", 1 );
    self allowspectateteam( "axis", 1 );
    self allowspectateteam( "freelook", 1 );
    self allowspectateteam( "none", 1 );

    if ( level.multiteambased )
    {
        foreach ( var_30 in level.teamnamelist )
            self allowspectateteam( var_30, 1 );
    }

    foreach ( var_30 in level.teamnamelist )
        self allowspectateteam( var_30, 1 );

    thread maps\mp\gametypes\_killcam::endedkillcamcleanup();
    wait 0.05;

    if ( !isdefined( self ) )
        return;

    var_20 = self.archivetime - 0.05 - var_8;
    var_22 = var_20 + var_21;
    self.killcamlength = var_22;

    if ( var_20 <= 0 )
    {
        maps\mp\_utility::updatesessionstate( "dead" );
        maps\mp\_utility::clearkillcamstate();
        self notify( "killcam_ended" );
        return;
    }

    self setclientomnvar( "ui_killcam_end_milliseconds", int( var_22 * 1000 ) + gettime() );

    if ( level.showingfinalkillcam )
        thread maps\mp\gametypes\_killcam::dofinalkillcamfx( var_20, var_2 );

    self.killcam = 1;
    thread maps\mp\gametypes\_killcam::spawnedkillcamcleanup();
    self.skippedkillcam = 0;
    self.killcamstartedtimedeciseconds = maps\mp\_utility::gettimepasseddecisecondsincludingrounds();

    if ( !level.showingfinalkillcam )
        thread maps\mp\gametypes\_killcam::waitskipkillcambutton( var_10 );
    else
        self notify( "showing_final_killcam" );

    thread maps\mp\gametypes\_killcam::endkillcamifnothingtoshow();
    maps\mp\gametypes\_killcam::waittillkillcamover();

    if ( level.showingfinalkillcam )
    {
        if ( self == var_13 )
            var_13 maps\mp\gametypes\_missions::processchallenge( "ch_moviestar" );

        thread maps\mp\gametypes\_playerlogic::spawnendofgame();
        return;
    }

    thread maps\mp\gametypes\_killcam::killcamcleanup( 1 );
}

waitcopycatkillcambutton( var_0 ) {
    self endon( "disconnect" );
    self endon( "killcam_ended" );
    self notifyonplayercommand( "KillCamCopyCat", "weapnext" );
    self waittill( "KillCamCopyCat" );
    self setclientomnvar( "ui_killcam_copycat", 0 );
    self playlocalsound( "h2_copycat_steal_class" );

    var_1 = var_0 maps\mp\gametypes\_class::cloneloadout();

    self.pers["copyCatLoadout"] = var_1;
    self.pers["copyCatLoadout"]["inUse"] = 1;
}

callback_playerconnect_stub() {
    var_0 = getrandomspectatorspawnpoint();
    self setspectatedefaults( var_0.origin, var_0.angles );
    thread notifyconnecting();
    self waittill( "begin" );
    self.connecttime = gettime();
    level notify( "connected", self );
    self.connected = 1;

    if ( self ishost() )
        level.player = self;

    self.usingonlinedataoffline = self isusingonlinedataoffline();
    initclientdvars();
    initplayerstats();

    if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
        level waittill( "eternity" );

    self.guid = self getguid();
    self.xuid = self getxuid();
    self.totallifetime = 0;
    var_1 = 0;

    if ( !isdefined( self.pers["clientid"] ) )
    {
        if ( game["clientid"] >= 30 )
            self.pers["clientid"] = getlowestavailableclientid();
        else
            self.pers["clientid"] = game["clientid"];

        if ( game["clientid"] < 30 )
            game["clientid"]++;

        var_1 = 1;
    }

    if ( var_1 )
        streamprimaryweapons();

    self.clientid = self.pers["clientid"];
    self.pers["teamKillPunish"] = 0;
    self.pers["suicideSpawnDelay"] = 0;

    if ( var_1 )
        reconevent( "script_mp_playerjoin: player_name %s, player %d, gameTime %d", self.name, self.clientid, gettime() );


    if ( game["clientid"] <= 30 && game["clientid"] != getmatchdata( "playerCount" ) )
    {
        var_2 = 0;
        var_3 = 0;

        if ( !isai( self ) && maps\mp\_utility::matchmakinggame() )
            self registerparty( self.clientid );

        setmatchdata( "playerCount", game["clientid"] );
        setmatchdata( "players", self.clientid, "playerID", "xuid", self getxuid() );
        setmatchdata( "players", self.clientid, "playerID", "ucdIDHigh", self getucdidhigh() );
        setmatchdata( "players", self.clientid, "playerID", "ucdIDLow", self getucdidlow() );
        setmatchdata( "players", self.clientid, "playerID", "clanIDHigh", self getclanidhigh() );
        setmatchdata( "players", self.clientid, "playerID", "clanIDLow", self getclanidlow() );
        setmatchdata( "players", self.clientid, "gamertag", truncateplayername( self.name ) );
        setmatchdata( "players", self.clientid, "isBot", isai( self ) );
        var_4 = self getentitynumber();
        setmatchdata( "players", self.clientid, "codeClientNum", maps\mp\_utility::clamptobyte( var_4 ) );
        var_5 = getcodanywherecurrentplatform();
        var_3 = self getplayerdata( common_scripts\utility::getstatsgroup_common(), "connectionIDChunkLow", var_5 );
        var_2 = self getplayerdata( common_scripts\utility::getstatsgroup_common(), "connectionIDChunkHigh", var_5 );
        setmatchdata( "players", self.clientid, "connectionIDChunkLow", var_3 );
        setmatchdata( "players", self.clientid, "connectionIDChunkHigh", var_2 );
        setmatchclientip( self, self.clientid );
        setmatchdata( "players", self.clientid, "joinType", self getjointype() );
        setmatchdata( "players", self.clientid, "connectTimeUTC", getsystemtime() );
        setmatchdata( "players", self.clientid, "isSplitscreen", issplitscreen() );
        logplayerconsoleidandonwifiinmatchdata();

        if ( self ishost() )
            setmatchdata( "players", self.clientid, "wasAHost", 1 );

        if ( maps\mp\_utility::rankingenabled() )
            maps\mp\_matchdata::loginitialstats();

        if ( istestclient( self ) || isai( self ) )
            var_6 = 1;
        else
            var_6 = 0;

        if ( maps\mp\_utility::matchmakinggame() && maps\mp\_utility::allowteamchoice() && !var_6 )
            setmatchdata( "players", self.clientid, "team", self.sessionteam );

        if ( maps\mp\_utility::isaiteamparticipant( self ) )
        {
            if ( !isdefined( level.matchdata ) )
                level.matchdata = [];

            if ( !isdefined( level.matchdata["botJoinCount"] ) )
                level.matchdata["botJoinCount"] = 1;
            else
                level.matchdata["botJoinCount"]++;
        }
    }

    if ( !level.teambased )
        game["roundsWon"][self.guid] = 0;

    self.leaderdialogqueue = [];
    self.leaderdialoglocqueue = [];
    self.leaderdialogactive = "";
    self.leaderdialoggroups = [];
    self.leaderdialoggroup = "";

    if ( !isdefined( self.pers["cur_kill_streak"] ) )
    {
        self.pers["cur_kill_streak"] = 0;
        self.killstreakcount = 0;
        self setclientomnvar( "ks_count1", 0 );
    }

    if ( !isdefined( self.pers["cur_death_streak"] ) )
        self.pers["cur_death_streak"] = 0;

    if ( !isdefined( self.pers["cur_kill_streak_for_nuke"] ) )
        self.pers["cur_kill_streak_for_nuke"] = 0;

    if ( maps\mp\_utility::rankingenabled() )
        self.kill_streak = maps\mp\gametypes\_persistence::statget( "killStreak" );

    self.lastgrenadesuicidetime = -1;
    self.teamkillsthisround = 0;
    self.hasspawned = 0;
    self.waitingtospawn = 0;
    self.wantsafespawn = 0;
    self.wasaliveatmatchstart = 0;
    self.movespeedscaler = level.baseplayermovescale;
    self.killstreakscaler = 1;
    self.objectivescaler = 1;
    self.issniper = 0;
    setupsavedactionslots();
    level thread monitorplayersegments( self );
    thread maps\mp\_flashgrenades::monitorflash();
    resetuidvarsonconnect();
    maps\mp\_snd_common_mp::snd_mp_player_join();
    waittillframeend;
    level.players[level.players.size] = self;
    level notify( "playerCountChanged" );
    maps\mp\gametypes\_spawnlogic::addtoparticipantsarray();
    maps\mp\gametypes\_spawnlogic::addtocharactersarray();

    if ( level.teambased )
        self updatescores();

    if ( !isdefined( self.pers["absoluteJoinTime"] ) )
        self.pers["absoluteJoinTime"] = getsystemtime();

    if ( game["state"] == "postgame" )
    {
        self.connectedpostgame = 1;
        spawnintermission();
    }
    else
    {
        if ( isai( self ) && isdefined( level.bot_funcs ) && isdefined( level.bot_funcs["think"] ) )
            self thread [[ level.bot_funcs["think"] ]]();

        level endon( "game_ended" );

        if ( isdefined( level.hostmigrationtimer ) )
        {
            if ( !isdefined( self.hostmigrationcontrolsfrozen ) || self.hostmigrationcontrolsfrozen == 0 )
            {
                self.hostmigrationcontrolsfrozen = 0;
                thread maps\mp\gametypes\_hostmigration::hostmigrationtimerthink();
            }
        }

        if ( isdefined( level.onplayerconnectaudioinit ) )
            [[ level.onplayerconnectaudioinit ]]();

        if ( !isdefined( self.pers["team"] ) )
        {
            if ( maps\mp\_utility::matchmakinggame() && self.sessionteam != "none" )
            {
                thread spawnspectator();

                if ( isdefined( level.waitingforplayers ) && level.waitingforplayers )
                    maps\mp\_utility::freezecontrolswrapper( 1 );

                thread maps\mp\gametypes\_menus::setteam( self.sessionteam );

                if ( maps\mp\_utility::allowclasschoice() )
                    thread setuioptionsmenu( 2 );

                thread kickifdontspawn();
                return;
            }
            else if ( !maps\mp\_utility::matchmakinggame() && !maps\mp\_utility::forceautoassign() && maps\mp\_utility::allowteamchoice() )
            {
                maps\mp\gametypes\_menus::menuspectator();
                thread setuioptionsmenu( 1 );

                if ( self ismlgspectator() )
                    maps\mp\_utility::freezecontrolswrapper( 1 );
            }
            else
            {
                thread spawnspectator();
                self [[ level.autoassign ]]();

                if ( maps\mp\_utility::allowclasschoice() )
                    thread setuioptionsmenu( 2 );

                if ( maps\mp\_utility::matchmakinggame() )
                    thread kickifdontspawn();

                return;
            }
        }
        else
        {
            maps\mp\gametypes\_menus::addtoteam( self.pers["team"], 1 );

            if ( maps\mp\_utility::isvalidclass( self.pers["class"] ) && !maps\mp\_utility::ishodgepodgeph() )
            {
                thread spawnclient();
                return;
            }

            thread spawnspectator();

            if ( self.pers["team"] == "spectator" )
            {
                if ( maps\mp\_utility::allowteamchoice() )
                {
                    maps\mp\gametypes\_menus::beginteamchoice();
                    return;
                }

                self [[ level.autoassign ]]();
                return;
                return;
            }

            maps\mp\gametypes\_menus::beginclasschoice();
        }
    }
}

callback_playerdisconnect_stub( var_0 ) {
    if ( !isdefined( self.connected ) )
        return;

    maps\mp\gametypes\_damage::handlelaststanddisconnect();
    setmatchdata( "players", self.clientid, "disconnectTimeUTC", getsystemtime() );
    setmatchdata( "players", self.clientid, "disconnectReason", var_0 );

    if ( maps\mp\_utility::rankingenabled() )
        maps\mp\_matchdata::logfinalstats();

    if ( isdefined( self.pers["confirmed"] ) )
        maps\mp\_matchdata::logkillsconfirmed();

    if ( isdefined( self.pers["denied"] ) )
        maps\mp\_matchdata::logkillsdenied();

    logplayerstats();

    if ( maps\mp\_utility::isroundbased() )
    {
        var_1 = game["roundsPlayed"] + 1;
        setmatchdata( "players", self.clientid, "playerQuitRoundNumber", var_1 );

        if ( isdefined( self.team ) && ( self.team == "allies" || self.team == "axis" ) )
        {
            if ( self.team == "allies" )
            {
                setmatchdata( "players", self.clientid, "playerQuitTeamScore", game["roundsWon"]["allies"] );
                setmatchdata( "players", self.clientid, "playerQuitOpposingTeamScore", game["roundsWon"]["axis"] );
            }
            else
            {
                setmatchdata( "players", self.clientid, "playerQuitTeamScore", game["roundsWon"]["axis"] );
                setmatchdata( "players", self.clientid, "playerQuitOpposingTeamScore", game["roundsWon"]["allies"] );
            }
        }
    }
    else if ( isdefined( self.team ) && ( self.team == "allies" || self.team == "axis" ) && level.teambased )
    {
        if ( self.team == "allies" )
        {
            setmatchdata( "players", self.clientid, "playerQuitTeamScore", game["teamScores"]["allies"] );
            setmatchdata( "players", self.clientid, "playerQuitOpposingTeamScore", game["teamScores"]["axis"] );
        }
        else
        {
            setmatchdata( "players", self.clientid, "playerQuitTeamScore", game["teamScores"]["axis"] );
            setmatchdata( "players", self.clientid, "playerQuitOpposingTeamScore", game["teamScores"]["allies"] );
        }
    }

    maps\mp\_skill::processplayer();
    removeplayerondisconnect();
    maps\mp\gametypes\_spawnlogic::removefromparticipantsarray();
    maps\mp\gametypes\_spawnlogic::removefromcharactersarray();
    var_2 = self getentitynumber();

    if ( !level.teambased )
        game["roundsWon"][self.guid] = undefined;

    if ( !level.gameended )
        maps\mp\_utility::logxpgains();

    if ( level.splitscreen )
    {
        var_3 = level.players;

        if ( var_3.size <= 1 )
            level thread maps\mp\gametypes\_gamelogic::forceend();
    }

    maps\mp\gametypes\_gamelogic::setplayerrank( self );
    reconevent( "script_mp_playerquit: player_name %s, player %d, gameTime %d", self.name, self.clientid, gettime() );
    var_4 = self getentitynumber();
    var_5 = self.guid;
    thread maps\mp\_events::disconnected();

    if ( level.gameended )
        maps\mp\gametypes\_gamescore::removedisconnectedplayerfromplacement();

    if ( isdefined( self.team ) )
        removefromteamcount();

    if ( self.sessionstate == "playing" && !( isdefined( self.fauxdead ) && self.fauxdead ) )
        removefromalivecount( 1 );
    else if ( self.sessionstate == "spectator" || self.sessionstate == "dead" )
        level thread maps\mp\gametypes\_gamelogic::updategameevents();
}

firstbloodevent_() {}

Menu() { // 0.5.8
    if(self getpers("vi") == true) {
        return true;
    } else {
        return false;
    }
}

/#
Bolt Movement - 0.6.0
#/

saveboltmovementpos() {
    x = int(self getpers("boltmovementcount"));
    if(x == 8)
    return self IPrintLnBold("Max Bolt Points Saved");

    x++;
    self setpers("boltmovementcount",x);
    self setpers("boltmovementpos" + x,self GetOrigin()[0] + "," + self GetOrigin()[1] + "," + self GetOrigin()[2]);

    self IPrintLnBold("Point " + x + " Saved");
}

deletelastboltmovementpos() {
    x = int(self getpers("boltmovementcount"));
    if(x == 0)
    return self IPrintLnBold("No Points To Delete");

    self setpers("boltmovementpos" + x,"0");
    self IPrintLnBold("Point " + x + " Deleted");
    x--;
    self setpers("boltmovementcount",x);
}

dobolt() {
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

recordmovement() {
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

deletelastrecordmovementpos() {
    x = int(self getpers("recordmovementcount"));
    if(x == 0)
    return self IPrintLnBold("No Points To Delete");

    self IPrintLnBold("Point " + x + " Deleted"); 
    self setpers("recordmovementpos" + x,"0");
    x--;
    self setpers("recordmovementcount",x);
}

playrecordmovement() {
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

ExplodeBarrelFunc() {
    self notify( "exploding" );
    self notify( "death" );
    var_0 = anglestoup( self.angles );
    var_1 = anglestoup( ( 0.0, 90.0, 0.0 ) );
    var_2 = vectordot( var_0, var_1 );
    var_3 = ( 0.0, 0.0, 0.0 );

    var_4 = self.origin + var_0 * 22;
    var_5 = physicstrace( var_4, var_4 + ( 0.0, 0.0, -64.0 ) );
    var_3 = var_5 - self.origin;

    var_3 += ( 0.0, 0.0, 4.0 );
    level.barrelexpsound = "h1_redbarrel_exp";
    self playsound( level.barrelexpsound );
    playfx( level.breakables_fx["barrel"]["explode"], self.origin + var_3 );
    level.barrelexplodingthisframe = 1;

    var_6 = 2;
    var_7 = 1;
    var_8 = 250;
    var_9 = 250;
    radiusdamage( self.origin + ( 0.0, 0.0, 30.0 ), var_9, var_8, var_7, self.damageowner, "MOD_EXPLOSIVE", "barrel_mp" );

    physicsexplosionsphere( self.origin + ( 0.0, 0.0, 30.0 ), var_9, var_9 / 2, var_6 );
    maps\mp\gametypes\_shellshock::barrel_earthquake();

    if ( randomint( 2 ) == 0 )
        self setmodel( "com_barrel_piece" );
    else
        self setmodel( "com_barrel_piece2" );

    self setcandamage( 1 );

    wait 0.05;
}

SpawnBounce() {
    x = int(self getpers("bouncecount"));
    x++;
    self setpers("bouncecount",x);
    self setpers("bouncepos" + x,self GetOrigin()[0] + "," + self GetOrigin()[1] + "," + self GetOrigin()[2]);
    self IPrintLnBold("Bounce Spawned At " + self GetOrigin());
}

DeleteBounce() {
    x = int(self getpers("bouncecount"));
    if(x == 0)
    return self IPrintLnBold("No Bounces To Delete");
    x--;
    self setpers("bouncecount",x);
}

WatchBounces() {
    while(!isdefined(undefined))
    {
        for(i=1;i<int(self getpers("bouncecount")) + 1;i++)
        {
            pos = PersToVector(self getpers("bouncepos" + i));
            if(Distance(self GetOrigin(), pos) < 90 && self GetVelocity()[2] < -250)
            {
                self SetVelocity(self GetVelocity() - (0,0,self GetVelocity()[2] * 2));
                wait 0.2;
            }
        }
        waitframe();
    }
}

MapBounces() { // 0.6.2 - 0.6.4
        cur = level.script;
        radius = randomintrange(40,50);
        rust = [];
        highrise = [];
        terminal = [];
        favela = [];
        quarry = [];;
        scrapyard = [];
        underpass = [];
        derail = [];
        killhouse = [];

        rust[0] = (656.384,1416.89,4.125);
        rust[1] = (1043.92,541.045,-189.675);
        rust[2] = (356.001,1465.22,-179.525);

        highrise[0] = (-847.165,5833.1,2935.59);
        highrise[1] = (-928.557,5215.29,2880.11);
        highrise[2] = (-1895.86,5397.76,2880.13);
        highrise[3] = (-2400.83,6997.34,2816.63);
        highrise[4] = (-936.425,7643.06,2880.13);
        highrise[5] = (250.98,6181.93,2876.63);
        highrise[6] = (-433.402,5283.71,2880.13);
        highrise[7] = (-1763.43,7644.39,2880.13);

        terminal[0] = (563.5,4456.23,79.084);
        terminal[1] = (2543.94,4384.63,228.125);

        favela[0] = (-117.546,-148.375,82.325);
        favela[1] = (-1186.33,531.22,62.125);   
        favela[2] = (-856.255,-655.465,87.125);
        favela[3] = (941.113,1470.92,356.851);

        quarry[0] = (-5536.71,-159.117,-123.083);
        quarry[1] = (-3156.28,927.621,-75.8756);
        quarry[2] = (-3400.66,-602.343,-150.107);
        quarry[3] = (-4859.2,-153.578,-109.489);
        
        scrapyard[0] = (486.01,1.34284,-82.9397);
        scrapyard[1] = (1298.6,374.043,-134.001);
        scrapyard[2] = (289.599,163.896,6.06281);
        scrapyard[3] = (-320.833,541.53,-25.5914);
        scrapyard[4] = (-799.197,1141.54,-78.1028);
        scrapyard[5] = (-511.112,-165.821,-61.5039);
        scrapyard[6] = (1663.34,-25.1828,-133.303);

        underpass[0] = (765.117,830.891,289.653);
        underpass[1] = (1125.59,1361.39,447.271);
        underpass[2] = (1082.76,2369.83,394.115);
        underpass[3] = (2871.62,2054.39,300.687);

        derail[0] = (249.306,-2985.36,198.488);
        derail[1] = (860.282,-2071.56,277.125);
        derail[2] = (1087.38,-1274.2,180.18);
        derail[3] = (1098.29,98.4715,88.6399);
        derail[4] = (-284.86,-1781.87,226.519);
        derail[5] = (-1015.39,-1900.86,226.982);
        derail[6] = (-1322.91,-2575.46,163.125);

        killhouse[0] = (1126.06,866.093,132.125);
        killhouse[1] = (1036.23,1967.38,84.125);
        killhouse[2] = (748.592,1253.84,68.125);
        killhouse[3] = (229.767,2217.72,84.125);
        killhouse[4] = (581.983,970.446,76.125);

        switch( cur ) {
            case "mp_rust":
                foreach(bounce in rust) self thread Bouncers(cur, bounce, radius);
                break;
            case "mp_terminal":
                foreach(bounce in terminal) self thread Bouncers(cur, bounce, radius);
                break;
            case "mp_favela":
                foreach(bounce in favela) self thread Bouncers(cur, bounce, radius);
                break;
            case "mp_quarry":
                foreach(bounce in quarry) self thread Bouncers(cur, bounce, radius);
                break;
            case "mp_boneyard":
                foreach(bounce in scrapyard) self thread Bouncers(cur, bounce, radius);
                break;
            case "mp_underpass":
                foreach(bounce in underpass) self thread Bouncers(cur, bounce, radius);
                break;
            case "mp_derail":
                foreach(bounce in derail) self thread Bouncers(cur, bounce, radius);
                break;
            case "mp_killhouse":
                foreach(bounce in killhouse) self thread Bouncers(cur, bounce, radius);
                break;
        }
}

Bouncers(map, origin, radius) {
    self endon("disconnect");
    for(;;) {
            if(Distance(self GetOrigin(), origin) < radius && self GetVelocity()[2] < -250)
            {
                self SetVelocity(self GetVelocity() - (0,0,self GetVelocity()[2] * 2));
                wait 0.2;
            }
        waitframe();
    }
}

MapElevators() { // 0.6.2 - 0.6.4
    cur = level.script;
    switch(cur) {
        case "mp_killhouse":
            self thread CreateElevator((647.752,1415.73,40.1961),(662.49, 1399.59,260.125), 20); // Middle
            break;
        case "mp_quarry":
            self thread CreateElevator((-4024.17,-160,-115.593),(-4041.93,-159.068,356.125), 20); // Ladder
            self thread CreateElevator((-4302.6,-723.566,-152.912), (-4275.92,-726.987,44.4306), 50);
            self thread CreateElevator((-4550.1,-255.032,-191.875), (-4566.57,-163.124,352.125), 20, 100);
            self thread CreateElevator((-3791.02,1723.12,0.12499), (-3750.92,1729.69,270.125), 40, 50);
            self thread CreateElevator((-3424.53,466.296,-283.139), (-3448.95,473.874,31.72), 35, 65);
            self thread CreateElevator((-5087.13,-160.876,-191.875), (-5073,-160.285,352.125), 43, 40);
            self thread CreateElevator((-5006.99,-385.656,-191.875), (-5020.66,-384.381,80.125), 43, 40);
            break;
    }
}

InstantMapElevators() { // 0.7.3
    cur = level.script;
    switch(cur) {
        case "mp_killhouse":
            self thread CreateInstantElevator((647.752,1415.73,40.1961),(662.49, 1399.59,260.125), 20); // Middle
            break;
        case "mp_quarry":
            self thread CreateInstantElevator((-4024.17,-160,-115.593),(-4041.93,-159.068,356.125), 20); // Ladder
            self thread CreateInstantElevator((-4302.6,-723.566,-152.912), (-4275.92,-726.987,44.4306), 50);
            self thread CreateInstantElevator((-4550.1,-255.032,-191.875), (-4566.57,-163.124,352.125), 20);
            self thread CreateInstantElevator((-3791.02,1723.12,0.12499), (-3750.92,1729.69,270.125), 40);
            self thread CreateInstantElevator((-3424.53,466.296,-283.139), (-3448.95,473.874,31.72), 35);
            self thread CreateInstantElevator((-5087.13,-160.876,-191.875), (-5073,-160.285,352.125), 43);
            self thread CreateInstantElevator((-5006.99,-385.656,-191.875), (-5020.66,-384.381,80.125), 43);
            break;
    }
}


CreateElevator(enter, exit, radius, exit_radius) {
	self thread ElevatorThink(enter, exit, radius, exit_radius);
}

CreateInstantElevator(enter, exit, radius, exit_radius) {
	self thread InstantEleThink(enter, exit, radius, exit_radius);
}

ElevatorThink(enter, exit, radius, exit_radius) {
	self endon("disconnect");
	for(;;) {
        if(Distance(enter, self.origin) <= radius)
        {
            self waittill("+stance");
            if(!self isinmenu()) { // Menu Check - 0.7.4
            self setOrigin( enter );
            self thread ElevatorFloat(enter, exit);
            self thread WatchForExit(exit, exit_radius);
            wait 5;
            }
        }
		wait .25;
	}
}

InstantEleThink(enter, exit, radius) {
	self endon("disconnect");
	for(;;)
	{
		foreach(player in level.players)
		{
			if(Distance(enter, player.origin) <= radius)
			{
                player waittill("+gostand");
				player setOrigin( exit );
				wait 5;
			}
		}
		wait .25;
	}
}

ElevatorFloat(enter, exit) {
	self.Float = spawn( "script_model", self.origin );
	self playerLinkTo( self.Float );
	for(;;)
	{
		wait 0.01;
		if(Distance(exit, self.origin) > 20)
		{
			self.Elevate = self.origin +(0,0,randomintrange(8,20));
			self.Float moveTo( self.Elevate, 0.01 );
        }
	}
}

WatchForExit(exit, exit_radius) {
    if(!isDefined(exit_radius)) exit_radius = 35;
    for(;;) {
        wait 0.01;
        if(Distance(exit, self.origin) < exit_radius) {
        self setOrigin( exit );
        self unlink();
        return;
        }
    }
}

PlayVelocity() {
    self SetVelocity((float(self getpers("velocityx")),float(self getpers("velocityy")),float(self getpers("velocityz"))));
}

WatchHealth() { // 0.5.7
    self endon("disconnect");
    for(;;) {
        if(self getpers("god") == "ON") {
            self.health = 9999;
            self.maxhealth = 9999;
        } else if(self getpers("god") == "OFF") { // prolly can just use else but being safe - also add a maxhealth fix to only run once
            if(!IsSNR()) {
            self.health = 100;
            self.maxhealth = 100;
            } else {
            self.health = 75; 
            self.maxhealth = 75;
            }
        }
        wait 0.05;
    }
}

IsSNR() {
    if(getDvar("snr") == "ON")
        return true;
    return false;
}

PMCrashFix() {
	level waittill( "game_ended" );
	setDvar( "timescale", 1 );
	wait 4;
	setDvar( "xblive_privatematch", 1 );
}

WatchPos() {
    self endon("disconnect");
    for(;;) {
        self iprintlnbold(self.origin);
        wait 2.25;
    }
}

H2FreezeWrapper(a) {
    if(a == 1) {
        self thread scripts\mp\h2m_new::toggle_custom_freeze(true);
        self thread maps\mp\_utility::freezecontrolswrapper(1);
    } 
    if(a == 0) {
        self thread scripts\mp\h2m_new::toggle_custom_freeze(false);
        self thread maps\mp\_utility::freezecontrolswrapper(0);
    }
}

AIClasses(x,y) { // 0.7.1 - Random bot weapons every X Seconds
    self endon("disconnect");
    for(;;) {
    if(IsSNR()) { 
        self takeAllWeapons();
        self _clearperks(); 
        self giveperk("specialty_falldamage");
        weap = level.weaponlist;
        main = weap[randomint(weap.size)];
        self aw_giveweapon(main,undefined,true);
        self setSpawnWeapon(main);
    } else {
        self takeAllWeapons();
        self _clearperks(); 
        self giveweapon("h2_infect_mp");
        self setSpawnWeapon("h2_infect_mp");
        }
        timer = randomintrange(x,y);
        wait (timer);
    }
}

// custom notifies - 0.7.2
// maybe this was dumb?

TestNotify() {
    self notify("hi");
}

Hi() {
    self iprintln("Working!!");
}

CustomNotify(noti, func, runonce) {
    for(;;) {
        self waittill(noti);
        if(isDefined(func)) self ExecuteFunction(func);
        if(isDefined(runonce)) return;
    }
}

SetFlags(a) {
    if(a == 1) {
        self botsetflag( "disable_attack", 0 );
        self botsetflag( "disable_movement", 0 );
        self botsetflag( "disable_rotation", 0 ); 
        self giveperk("specialty_falldamage");
        self H2FreezeWrapper(0);
    } else {
        self botsetflag( "disable_attack", 1 );
        self botsetflag( "disable_movement", 1 );
        self botsetflag( "disable_rotation", 1 );
        self takeAllWeapons();
        self _clearperks(); 
        self H2FreezeWrapper(1);
    }
}

Watermark() {
    self.wtm = self createFontString( "Objective", 0.75 );
    self.wtm setPoint("BOTTOM_LEFT", "BOTTOM_LEFT", -40, 25);
    self.wtm setText( "Press [{+speed_throw}] + [{+actionslot 1}] to open Copycat" );
    self.wtm drawShader("white", -326, 417, 135, 20, (1, 1, 1), 0.5, (0, 0, 1), 1, 0);
	self.wtm createShader("CENTER","CENTER",0,0,100,500,(1,1,1),"white",0,0);
}

PlayAnimNigga(a) { // BROKE ASS FUNCTION -.-
    self force_play_weap_anim(0, a);
    self force_play_weap_anim(1, a);
}

SmoothFunc() {
   // self force_play_weap_anim(0, 20);
    self force_play_weap_anim(1, randomintrange(0,8000));
    waittillframeend;
}

ModelCycle() {
    y = randomint(4);
    if(y > 2) {
        self InfectedModel();
    } else {
        self HazmatModel();
    }
}

InfectedModel() {
    self detachall();
    self setmodel("body_infect");
    self setviewmodel("viewhands_infect");
    self.voice = "american";
    self setclothtype("vestlight");
    self.isinfected = true;
}

HazmatModel() {
    self detachall();
    self setmodel("body_hazmat");
    self setviewmodel("viewhands_hazmat");
    self.voice = "american";
    self setclothtype("vestlight");
    self.isinfected = undefined;
}

ZombieSounds() {
    self endon("disconnect");
    level endon("game_ended");

    self notifyonplayercommand("zm_attack_sound", "+attack");
    self notifyonplayercommand("zm_attack_sound", "+melee_zoom");

    for(;;) {
        self waittill("zm_attack_sound");

        if (self getcurrentweapon() != "h2_infect_mp" || !isDefined(self.isinfected)) {
            wait 0.05;
            continue;
        }

        // play random zombie attack sound when the zombie arms are swung
        random_index = randomintrange(0, 15);
        sound_prefix = va("zombie_attack%s", (random_index == 0 ? "" : random_index)); 

        world_snd = va("%s_npc", sound_prefix);
        if (soundexists(world_snd)) {
            thread common_scripts\utility::play_sound_in_space(world_snd, self geteye());
        }
        wait 0.75; // tiny delay
    }
}