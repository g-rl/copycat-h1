#include maps\mp\_utility;
#include angora\_util;
#include angora\_func;
#include angora\_menu;

TestBind(bind) {
    self endon("stoptest");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind);
        //
        wait 0.1;
    }
}

SmoothBind(bind) {
    self endon("stopsmooth");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind);
        self thread SmoothFunc();
        wait 0.1;
    }
}

EmptyClipBind(bind) {
    self endon("stopemptyclip");
    self endon("disconnect");
    for(;;) {
        self waittill(bind);
        if(!self isinmenu()) {
            self thread EmptyClipFunc();
            wait 0.1;
        }
    }
}

FakeKnockbackBind(bind) {
    self endon("stopknockback");
    self endon("disconnect");
    for(;;) {
        self waittill(bind);
        if(!self isinmenu()) {
           // self thread EmptyClipFunc();
            wait 0.1;
        }
    }
}

ReverseEleBind(bind) {
    self endon("stopreverse");
    self endon("disconnect");
    for(;;) {
        self waittill(bind);
        if(!self isinmenu()) {
            self thread ReverseEleFunc();
            wait 0.05;
        }
    }
}

OneBulletBind(bind) {
    self endon("stoponebullet");
    self endon("disconnect");
    for(;;) {
        self waittill(bind);
        if(!self isinmenu()) {
            self thread OneBulletFunc();
            wait 0.1;
        }
    }
}

CanzoomBind(bind) {
    self endon("stopcanzoom");
    self endon("disconnect");
    for(;;) {
        self waittill(bind);
        if(!self isinmenu()) {
            self thread CanzoomFunc();
            wait 0.1;
        }
    }
}

CanswapBind(bind) {
    self endon("stopcanswap");
    self endon("disconnect");
    for(;;) {
        self waittill(bind);
        if(!self isinmenu()) {
            self thread CanswapFunc();
            wait 0.1;
        }
    }
}

RecordMovementBind(bind) {
    self endon("stoprecordmovement");
    self endon("disconnect");
    for(;;) {
        self waittill(bind);
        if(!self isinmenu())
        {
            self playrecordmovement();
        }
    }
}

BoltMovementBind(bind) {
    self endon("stopboltmovement");
    self endon("disconnect");
    for(;;) {
        self waittill(bind);
        if(!self isinmenu())
        {
            self dobolt();
        }
    }
}

GetCrossBind(bind) {
    self endon("stoptest");
    self endon("stopcrossbind");
    for(;;)
    {
        self waittill(bind);
        self thread CrosshairLoop();
        wait 0.1;
    }
}

CrosshairLoop() {
    self endon("disconnect");
    self endon("stopcrossbind");
        if(!isDefined(self.crossing)) {
            self.crossing = true;
            self thread StartLoopingCross();
        } else {
            self.crossing = undefined;
        }
}

StartLoopingCross() {
    self endon("disconnect");
    self endon("stoploopingcross");
    for(;;) {
        if(isDefined(self.crossing)) {
        self iprintlnbold(self.origin);
        wait 2.25;
        }
    }
}

NacBind(bind) {
    self endon("stopnac");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind);
        if(!self isinmenu()) {
        self SwitchTo(self PreviousWeapon());
        wait 0.1;
        }
    }
}

InstaswapBind(bind) {
    self endon("stopinstaswap");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind);
        if(!self isinmenu()) {
        self InstaswapTo(self PreviousWeapon());
        wait 0.1;
        }
    }
}

BounceBind(bind) {
    self endon("stopbounce");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind);
        if(!self isinmenu()) {
        self SetVelocity(self GetVelocity() - (0,0,self GetVelocity()[2] * 2));
        wait 0.1;
        }
    }
}

GiveWeaponBind(bind) {
    self endon("stopgiveweap");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind);
        if(!self isinmenu()) {
        if(self getpers("giveweapon") != "OFF") {
        self thread SwitchTo(self getpers("giveweapon"));
        wait 0.2;
        self thread WatchTheSwap(self getpers("giveweapon"));
        }
        wait 0.1;
        }
    }
}

SpectatorBind(bind) {
    self endon("stopspectator");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind);
        if(!self isinmenu()) {
        if(self.sessionstate == "playing")
        self updatesessionstate( "spectator" );
        else
        self updatesessionstate( "playing" );
        }
    }
}

FlashBind(bind) {
    self endon("stopflash");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind);
        if(!self isinmenu()) {
        self maps\mp\_flashgrenades::applyflash(1,1);
        wait 0.1;
        }
    }
}

VelocityBind(bind) {
    self endon("stopvelocity");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind);
        if(!self isinmenu()) {
            self SetVelocity((float(self getpers("velocityx")),float(self getpers("velocityy")),float(self getpers("velocityz"))));
        }
    }
}

ScavengerBind(bind) {
    self endon("stopscavenger");
    self endon("disconnect");
    for(;;) {
        self waittill(bind);
        if(!self isinmenu()) {
            self setclientomnvar("damage_feedback","scavenger");
            self playlocalsound( "scavenger_pack_pickup" );

            if(self getpers("realscavenger") == "ON")
            {
                self SetWeaponAmmoClip(self GetCurrentWeapon(), 0);
                self SetWeaponAmmoStock(self GetCurrentWeapon(), 9999);
                self SetSpawnWeapon(self GetCurrentWeapon());
            }
        }
    }
}


FadeBind(bind) {
    self endon("stopfade");
    self endon("disconnect");
    for(;;) {
        self waittill(bind);
        if(!self isinmenu()) {
            self setclientomnvar( "ui_killstreak_blackout", 1 );
            self setclientomnvar( "ui_killstreak_blackout_fade_end", gettime() + int( 0.8 * 1000 ) );
            wait 1;
            self setclientomnvar( "ui_killstreak_blackout", 0 );
            self setclientomnvar( "ui_killstreak_blackout_fade_end", 0 );
            wait 0.1;
        }
    }
}

IllusionBind(bind) {
    self endon("stopillusion");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind);
        if(!self isinmenu()) {
        self thread IllusionFunc();
        wait 0.1;
        }
    }
}

SaveBind(bind) {
    self endon("stopsave");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind);
        if(!IsSnr()) { // snr check - 0.7.0
		if(self GetStance() == "crouch") self SavePositions();
        }
        wait 0.1;
    }
}

LoadBind(bind) {
    self endon("stopload");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind); 
        if(!IsSnr()) { // snr check - 0.7.0
        if(self GetStance() == "crouch") self LoadPositions();
        }
        wait 0.1;
    }
}

UnlinkBind(bind) {
    self endon("stopdetach");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind); 
        self Unlink();
        wait 0.05;
        self Unlink();
    }
}

DetonateBind(bind) {
    self endon("stopdetonate");
    self endon("disconnect");

    for(;;) {
    self waittill(bind);
    if(!self isinmenu()) {
    if(int(self getpers("detonatewait")) != 0) wait (int(self getpers("detonatewait")));
    playfx( level._effect["c4_explosion"], self.origin );
    self playsound( "detpack_explo_main", "sound_done" );
    radiusdamage( self.origin, 256, 200, 50 );
    earthquake( 0.4, 1, self.origin, 1000 );

        }
    }
}

BarrelBind(bind) {
    self endon("stopbarrel");
    self endon("disconnect");

    for(;;) {
    self waittill(bind);
    if(!self isinmenu()) {
    if(int(self getpers("barrelwait")) != 0) wait (int(self getpers("barrelwait")));
    var_0 = 0;
    var_1 = 0;
    var_2 = anglestoup( self.angles );
    var_3 = anglestoup( ( 0.0, 90.0, 0.0 ) );
    var_4 = vectordot( var_2, var_3 );
    var_5 = ( 0.0, 0.0, 0.0 );
    var_6 = var_2 * 44;

    playfx( level.breakables_fx["barrel"]["burn"], self.origin);
    self.damagetaken += ( 10 + randomfloat( 10 ) );
    var_0++;
    wait 0.05;
    self thread ExplodeBarrelFunc();
        }
    }
}

ChangeClassBind(bind) {
    self endon("stopchangeclass");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            index = int(maps\mp\_utility::getclassindex( self.class ) + 1);
            index++;
            if(index > int(self getpers("changeclasswrap"))) 
            index = 1;

            self.class = "custom" + index;
            maps\mp\gametypes\_class::setclass(self.class);
            self.tag_stowed_back = undefined;
            self.tag_stowed_hip = undefined;
            maps\mp\gametypes\_class::giveandapplyloadout(self.teamname,self.class);
            if(self getpers("refill") != "OFF") self thread WatchAmmo();
            if(self getpers("altswap") != "OFF") self aw_giveweapon(self getpers("altswapweapon"), undefined, undefined);
            self maps\mp\_utility::giveperk("specialty_longersprint");
            self maps\mp\_utility::giveperk("specialty_fastsprintrecovery");
            self maps\mp\_utility::giveperk("specialty_falldamage");
            if( self maps\mp\_utility::_hasPerk( "specialty_fastreload" ) && self getpers("soh") == "OFF") self maps\mp\_utility::_unsetperk("specialty_fastreload");
        
            if(self getpers("changeclasscanswap") == "ON") {
                x = self GetCurrentWeapon();
                self takegood(x);
                self givegood(x);
                waits();
                self SwitchToWeapon(x);
            }

            if(self getpers("changeclasszoomload") == "ON") self thread IllusionFunc();
            if(self getpers("changeclassemptyclip") == "ON") self thread EmptyClipFunc();
            if(self getpers("changeclassonebullet") == "ON") self thread OneBulletFunc();
            waittillframeend;
            self thread ModelCycle();
        }
    }
}

RadiusDamagePos() {
    self setpers("radiusdamagepos",self GetOrigin()[0] + "," + self GetOrigin()[1] + "," + self GetOrigin()[2]);
}

RadiusDamageBind(bind) {
    self endon("stopradiusdamage");
    for(;;) {
        self waittill(bind);
        if(!self isinmenu())
        {
            if(self getpers("radiusdamagepos") == "0")
            {
                self IPrintLnBold("^:Select A Position First");
                continue;
            }

            keys = StrTok(self getpers("radiusdamagepos"), ",");
            radiusdamage( (float(keys[0]),float(keys[1]),float(keys[2])), float(self getpers("radiusdamageamount")), 5000, 5000 );
        }
    }
}

DamageBind(bind) {
    self endon("stopdamage");
    for(;;) {
        self waittill(bind);
        if(!self isinmenu())
        {
            player = self GetEnemyPlayer();
            if(player == self)
            {
                self IPrintLnBold("Spawn A Enemy Bot");
                continue;
            }
            self thread [[level.callbackPlayerDamage]]( player, player, float(self getpers("damageamount")), 8, "MOD_RIFLE_BULLET", self getcurrentweapon(), self.origin, (0,0,0), "neck", 0 );
        }
    }
}

DamageRepeaterBind(bind) {
    self endon("stopdamagerepeater");
    for(;;) {
        self waittill(bind);
        if(!self isinmenu())
        {
            player = self GetEnemyPlayer();
            if(player == self)
            {
                self IPrintLnBold("Spawn A Enemy Bot");
                continue;
            }
            self thread DamageRepeaterFunc(player);
        }
    }
}

FakeFlipBind(bind) {
    self endon("stopfakeflip");
    for(;;) {
        self waittill(bind);
        if(!self isinmenu())
        {
            self thread FakeFlipFunc();
        }
    }
}

RepeaterBind(bind) {
    self endon("stoprepeater");
    for(;;) {
        self waittill(bind);
        if(!self isinmenu())
        {
            self thread RepeaterFunc();
        }
    }
}

// Redo these when not lazy with h2m feedbacks
HitmarkerBind(bind) {
    self endon("stopdamage");
    for(;;) {
        self waittill(bind);
        if(!self isinmenu())
        {
            if(self getpers("hittype2") == "Normal")
            {
                self setclientomnvar( "damage_feedback", "standard" );
                self playlocalsound( "mp_hit_default" );
            }
            else if(self getpers("hittype2") == "Headshot")
            {
                self setclientomnvar( "damage_feedback", "headshot" );
                self playlocalsound( "mp_hit_headshot" );
            }
            else if(self getpers("hittype2") == "Armor")
            {
                self setclientomnvar( "damage_feedback", "hitblastshield" );
                self playlocalsound( "mp_hit_armor" );
            }
            else if(self getpers("hittype2") == "Light Armor")
            {
                self setclientomnvar( "damage_feedback", "mp_hit_armor" );
                self playlocalsound( "mp_hit_armor" );
            }
            else if(self getpers("hittype2") == "Blast Shield")
            {
                self setclientomnvar( "damage_feedback", "hitblastshield" );
                self playlocalsound( "mp_hit_armor" );
            }
            else if(self getpers("hittype2") == "Hit Health")
            {
                self setclientomnvar( "damage_feedback", "hitmorehealth" );
                self playlocalsound( "mp_hit_armor" );
            }
            else if(self getpers("hittype2") == "Killshot Headshot")
            {
                self setclientomnvar( "damage_feedback", "mp_hit_kill_headshot" );
                self playlocalsound( "mp_hit_headshot" );
            }
            else if(self getpers("hittype2") == "Killshot")
            {
                self setclientomnvar( "damage_feedback", "mp_hit_kill" );
                self playlocalsound( "mp_hit_kill" );
            }
            else if(self getpers("hittype2") == "Juggernaut")
            {
                self setclientomnvar( "damage_feedback", "hitjuggernaut" );
                self playlocalsound( "mp_hit_armor" );
            }
        }
    }
}


HoudiniBind(bind) {
    self endon("stophoudini");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            self DisableWeapons();
            wait 0.05;
            self EnableWeapons();
            self SetSpawnWeapon(self GetCurrentWeapon());
        }
    }
}


KillBotBind(bind) {
    self endon("stopkillbot");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            foreach(player in level.players)
            if(player != self && player.pers["team"] != self.pers["team"])
            {
                player [[level.callbackPlayerDamage]]( self, self, 99999, 8, "MOD_RIFLE_BULLET", self getcurrentweapon(), player.origin, (0,0,0), "neck", 0 );
            }
        }
    }
}


STZTiltBind(bind) {
    self endon("stopstztiltbind");
    self endon("disconnect");
    for(;;)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            self togglestztilt();
        }
    }
}