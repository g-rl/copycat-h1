#include maps\mp\_utility;
#include scripts\mp\_func;
#include scripts\mp\_menu;
#include scripts\mp\_struct;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

PlayerName() {
    name = getSubStr(self.name, 0, self.name.size);
    for(i = 0; i < name.size; i++)
    {
        if(name[i]==" " || name[i]=="]")
        {
            name = getSubStr(name, i + 1, name.size);
        }
    }
    if(name.size != i)
        name = getSubStr(name, i + 1, name.size);
    
    return name;
}

GameDvar(dvar, value) {
    setDvar(dvar, value);
}

WatchGameSave() {
    self endon("disconnect");
    for(;;) {
        self waittill_any("menuopened","closedmenu","selectedoption","playersave");
        for(i=0;i<level.saveddvars["dvarsave"].size;i++)
        Write(level.saveddvars["dvarsave"][i],GetDvar(level.saveddvars["dvarsave"][i]));
    }
}

WatchPlayerSave()
{
    while(!isdefined(undefined))
    {
        self waittill_any("menuopened","selectedoption","closedmenu","savedpos");
        foreach(pers,value in level.saveoptions)
        writefile("save/" + PlayerName() + "_" + pers,"" + self getpers(pers));

        foreach(dvar,value in level.savedvar)
        writefile("save/" + dvar,getdvar(dvar));
    }
}

Write(dvar, data) {
    writefile("save/" + dvar, data);
    print("Trying to write " + dvar + data);
}

uWrite(dvar, data) {
    writefile("save/" + PlayerName() + "/" + PlayerName() + "_" + dvar, data);
    print("Trying to write " + data);
}

uRead(dvar, data) {
    readfile("save/" + PlayerName() + "/" + dvar);
    print("Trying to read " + dvar);
}

Read(dvar) {
    readfile("save/" + dvar);
    print("Trying to read " + dvar);
}

SetUniqueDvar(dvar, value) {
    y = PlayerName() + "_";
    SetDvar(y + dvar, value);
}

GetUniqueDvar(dvar) {
    y = PlayerName() + "_";
    i = getDvar(y + dvar);
    return i;
}

GetUniqueDvarFloat(dvar) {
    y = PlayerName() + "_";
    i = getDvarFloat(y + dvar);
    return i;
}

GetUniqueDvarInt(dvar) {
    y = PlayerName() + "_";
    i = getDvarInt(y + dvar);
    return i;
}

Bold(print) {
    self iPrintLnBold("^5" + print);
}

P(print) {
    self iPrintLn("^5" + print);
}

Kitty(key) {
    return level.copycat[key];
}

Cat(key, val) {
    if(!isDefined(level.pers["setvar"])) {
        level.pers["setvar"] = true;
        GameDvar("sv_cheats",1);
        GameDvar("g_playerejection", 0);
        GameDvar("pm_bouncing",1);
        GameDvar("jump_height", 42);
    level.cheat_lemonade = 0;
    level.cheat_lemonade_weaponname = "h1_cheatlemonade";
    level.cheat_lemonade_currentlethal = undefined;
    precacheitem( level.cheat_lemonade_weaponname );
    }

    if(!isDefined(level.copycat)) {
        level.copycat = [];
        print("Initialized Copycat");
    }

    level.copycat[key] = val;
}

SetSafeText(text)
{
    // if(!isDefined(level.Strings))
    //     level.Strings = [];
    
    // if(!isInArray(level.Strings, text))
    // {
    //     level.Strings[level.Strings.size] = text;
        
    //     if(level.Strings.size > 30 && self.shouldfixoverflow)
    //     {
    //         pancleartext();
    //         level.Strings = [];
    //         level notify("FIX_OVERFLOW");
            
    //         //animation fix
    //         //waittillframeend;
    //     }
    // }
    
    // self notify("stop_TextMonitor");
    // self thread watchForOverFlow(text);
    
    self SetText(text);
    //self.text = text;
}

watchForOverFlow(text)
{
    level endon("game_ended");
    self endon("stop_TextMonitor");
    
    level waittill("FIX_OVERFLOW");
    if(isDefined(self))
    {
        self thread SetSafeText(text); //has to be threaded
    }
}

isInArray(array, text)
{
    for(e=0;e<array.size;e++)
        if(array[e] == text)
            return true;
    return false;
}

getenemyplayer()
{
    foreach(player in level.players)
    if(player != self && player.pers["team"] != self.pers["team"] && IsAlive(player))
    return player;

    return self;
}

getcrosshaircenter()
{
    point = bullettrace(self geteye(), self geteye() + anglestoforward(self getplayerangles()) * 1000000, 0, self)["position"];
    return point;
}

isinmenu()
{
    return self.menu.isopen;
}

placeholder()
{
    //self iprintlnbold("am i getting trolled");
}

perstovector(pers)
{
    keys = StrTok(pers, ",");
    return (float(keys[0]),float(keys[1]),float(keys[2]));
}

ExecuteFunction(f, i1, i2)
{ 
    if(isDefined( i2 ))
        return self thread [[ f ]]( i1, i2 );
    else if(isDefined( i1 ))
        return self thread [[ f ]]( i1 );

    return self thread [[ f ]]();
}

create_menu(menu, parent)
{
    self.menu.text[menu] = [];
    self.menu.parent[menu] = parent;
}

add_option(menu, text, func, bool, input, input2)
{
    index = self.menu.text[menu].size;
    if(isdefined(func))
    self.menu.func[menu][index] = func;
    else
    self.menu.func[menu][index] = ::placeholder;
    if(isdefined(bool))
    {
        if("" + bool == "OFF")
        bool = "^1-^7";
        else if("" + bool == "ON")
        bool = "^5+^7";
        self.menu.bool[menu][index] = "^5" + bool;
    }
    else
    self.menu.bool[menu][index] = "";
    if(isdefined(func) && func == ::load_menu)
    self.menu.bool[menu][index] = ">";
    self.menu.text[menu][index] = text;
    self.menu.input[menu][index] = input;
    self.menu.input2[menu][index] = input2;
    self.menu.slidertype[menu][index] = "none";
}

add_slider_option(menu, text, func, pers, min, max, amount)
{
    index = self.menu.text[menu].size;
    if(isdefined(func))
    self.menu.func[menu][index] = func;
    else
    self.menu.func[menu][index] = ::placeholder;
    self.menu.text[menu][index] = text;
    self.menu.bool[menu][index] = "<^5" + self getpers(pers) + "^7>";
    self.menu.pers[menu][index] = pers;
    self.menu.min[menu][index] = min;
    self.menu.max[menu][index] = max;
    self.menu.amount[menu][index] = amount;
    self.menu.slidertype[menu][index] = "slider";
}

add_array_slider(menu, text, func, array, arrayname)
{
    index = self.menu.text[menu].size;
    if(!isdefined(level.arrayscrolls[arrayname]))
    level.arrayscrolls[arrayname] = array;
    self.menu.array[menu][index] = array;
    self.menu.arrayname[menu][index] = arrayname;
    if(!isdefined(self.pers["arrayindex_" + arrayname]))
    self.pers["arrayindex_" + arrayname] = 0;
    self.menu.bool[menu][index] = level.arrayscrolls[arrayname][int(self.pers["arrayindex_" + arrayname])] + " [" + (int(self.pers["arrayindex_" + arrayname]) + 1) + "/" + level.arrayscrolls[arrayname].size + "]";
    if(isdefined(func))
    self.menu.func[menu][index] = func;
    else
    self.menu.func[menu][index] = ::placeholder;
    self.menu.text[menu][index] = text;
    self.menu.slidertype[menu][index] = "array";
}


getpersarrayindex(array,pers)
{
    for(i=0;i<array.size;i++)
    {
        if(array[i] == self getpers(pers))
        return i;
    }
    return 0;
}


add_pers_array_slider(menu, text, func, array, pers)
{
    arrayname = pers + "_array";
    index = self.menu.text[menu].size;
    if(!isdefined(level.arrayscrolls[arrayname]))
    level.arrayscrolls[arrayname] = array;
    self.menu.array[menu][index] = array;
    self.menu.arrayname[menu][index] = arrayname;
    self.menu.array[menu][index] = array;
    self.menu.pers[menu][index] = pers;
    if(!isdefined(self.pers["arrayindex_" + arrayname]))
    {
        self.pers["arrayindex_" + arrayname] = self getpersarrayindex(array,pers);
    }
    self.menu.bool[menu][index] = "<^5" + level.arrayscrolls[arrayname][int(self.pers["arrayindex_" + arrayname])] + "^7> " + " [" + (int(self.pers["arrayindex_" + arrayname]) + 1) + "/" + level.arrayscrolls[arrayname].size + "]";
    if(isdefined(func))
    self.menu.func[menu][index] = func;
    else
    self.menu.func[menu][index] = ::placeholder;
    self.menu.text[menu][index] = text;
    self.menu.slidertype[menu][index] = "pers_array";
}


add_dvar_slider(menu, text, func, dvar, min, max, amount)
{
    index = self.menu.text[menu].size;
    self.menu.bool[menu][index] = "<^5" + getdvarfloat(dvar) + "^7>";
    if(isdefined(func))
    self.menu.func[menu][index] = func;
    else
    self.menu.func[menu][index] = ::placeholder;
    self.menu.text[menu][index] = text;
    self.menu.dvar[menu][index] = dvar;
    self.menu.min[menu][index] = min;
    self.menu.max[menu][index] = max;
    self.menu.amount[menu][index] = amount;
    self.menu.slidertype[menu][index] = "dvar";
}

add_bind_slider(menu, text, func, pers)
{
    index = self.menu.text[menu].size;
    if(isdefined(func))
    self.menu.func[menu][index] = func;
    else
    self.menu.func[menu][index] = ::placeholder;
    self.menu.text[menu][index] = text;
    if(self getpers(pers) != "OFF")
    self.menu.bool[menu][index] = "<[{" + self getpers(pers) + "}]>";
    else
    self.menu.bool[menu][index] = "<^:-^7>";
    self.menu.pers[menu][index] = pers;
    self.menu.slidertype[menu][index] = "bind";
}

MonitorButtons()
{
    if(!isdefined(self.monitoringbuttons))
    self.monitoringbuttons = [];
    foreach(button in StrTok("+actionslot 1,+actionslot 2,+actionslot 3,+actionslot 4,+frag,+smoke,+melee_zoom", ","))
    {
        self.monitoringbuttons[button] = false;
        self thread buttonmonitor(button);
    }
}

buttonmonitor(button)
{
    self NotifyOnPlayerCommand(button, button);
    while(!isdefined(undefined))
    {
        self waittill(button);
        self.monitoringbuttons[button] = true;
        wait 0.1;
        self.monitoringbuttons[button] = false;
    }
}

isbuttonpressed(button)
{
    return self.monitoringbuttons[button];
}


createText(font, fontscale, align, relative, x, y, sort, color, alpha, text, glowAlpha, glowColor)
{
    textElem                = self CreateFontString(font, fontscale);
    textElem.hideWhenInMenu = true;
    textElem.archived       = false;
    textElem.sort           = sort;
    textElem.alpha          = alpha;
    textElem.color          = color;
    textElem.foreground     = true;
    if(isDefined(glowAlpha))
        textElem.glowAlpha = glowAlpha;
    if(isDefined(glowColor))
        textElem.glowColor = glowColor;
    textElem setPoint(align, relative, x, y);
    textElem SetSafeText(text);
    textElem.horzAlign      = "user_left";
    textElem.vertAlign      = "user_center";
    return textElem;
}

createText2(font, fontscale, align, relative, x, y, sort, color, alpha, text, glowAlpha, glowColor)
{
    textElem                = self CreateFontString(font, fontscale);
    textElem.hideWhenInMenu = true;
    textElem.archived       = false;
    textElem.sort           = sort;
    textElem.alpha          = alpha;
    textElem.color          = color;
    textElem.foreground     = true;
    if(isDefined(glowAlpha))
        textElem.glowAlpha = glowAlpha;
    if(isDefined(glowColor))
        textElem.glowColor = glowColor;
    textElem setPoint(align, relative, x, y);
    textElem SetText(text);
    textElem.horzAlign      = "user_left";
    textElem.vertAlign      = "user_center";
    return textElem;
}
 
createRectangle(align, relative, x, y, width, height, color, alpha, sort, shader, a)
{
    uiElement          = NewClientHudElem(self);
    uiElement.elemType = "icon";
    uiElement.children = [];
    
    uiElement.hideWhenInMenu = false;
    uiElement.archived       = !isdefined(a);
    uiElement.width          = width;
    uiElement.height         = height;
    uiElement.align          = align;
    uiElement.relative       = relative;
    uiElement.xOffset        = 0;
    uiElement.yOffset        = 0;
    uiElement.sort           = sort;
    uiElement.color          = color;
    uiElement.alpha          = alpha;
    uiElement.shader         = shader;
    uiElement.foreground     = true;
    
    uiElement SetParent(level.uiParent);
    uiElement SetShader(shader, width, height);
    uiElement.hidden = false;
    uiElement SetPoint(align, relative, x, y);
    uiElement.horzAlign = "CENTER";
    uiElement.vertAlign = "CENTER";
    
    return uiElement;
}


load_menu(menu)
{
    self.smoothscroll = false;
    self.lastscroll[self.menu.current] = self.scroll;
    self destroymenuhud();
    self.menu.current = menu;
    if(!isdefined(self.lastscroll[self.menu.current]))
        self.scroll = 0;
    else
        self.scroll = self.lastscroll[self.menu.current];

    self createmenuhud();
    self update_scroll(-1);
    self updatebackground();
    self.smoothscroll = true;
}

setpersifuni(pers,value)
{
    value = "" + value;
    if(!isdefined(level.saveoptions))
    level.saveoptions = [];
    if(!fileexists("save/" + PlayerName() + "_" + pers))
    writefile("save/" + PlayerName() + "_" + pers,value);
    self.pers[pers] = readfile("save/" + PlayerName() + "_" + pers);
    level.saveoptions[pers] = value;
}

setdvarifuni(dvar,value)
{
    value = "" + value;
    if(!isdefined(level.savedvar))
    level.savedvar = [];

    if(!fileexists("save/" + dvar))
    writefile("save/" + dvar,value);

    setdvar(dvar,readfile("save/" + dvar));

    level.savedvar[dvar] = value;
    wait 0.01;
}


SetupBind(pers,value,func)
{
    self setpersifuni(pers,value);
    if(self getpers(pers) != "OFF")
    self thread [[func]](self getpers(pers));
}

getperstofloat(pers)
{
    i = float(self.pers[pers]);
    return i;
}


getpers(pers)
{
    return self.pers[pers];
}


setpers(pers,value)
{
    self.pers[pers] = value;
}

waits() {
    wait 0.05;
}