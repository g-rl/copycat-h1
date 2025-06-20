#include maps\mp\_utility;
#include angora\_func;
#include angora\_menu;
#include angora\_struct;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

CreateNotifys() {
    foreach(value in StrTok("save,+melee_breath,+melee_zoom,+actionslot 1,+actionslot 2,+actionslot 3,+actionslot 4,+frag,+smoke,+melee,+stance,+gostand,+switchseat,+usereload", ",")) {
        self NotifyOnPlayerCommand(value, value);
    }
}

Litterbox() {
    var0 = eGyTITE2MCEqaYUgk519i6DQfQ();
    Cat2("_", var0);
}

Randomize(a) {
	r = strTok(a, ",");
	random = RandomInt(r.size);
	final = r[random];
	return final;
}

List(key) {
    output = StrTok(key, ",");
    return output;
}

Group(key) {
    output = StrTok(key, " ");
    return output;
}

InArray(a, check) {
	if( IsInArray(a, check))
        return true;
}

PlayerName() {
	a=getSubStr(self.name,0,self.name.size);
	for(i=0;i<a.size;i++)
	{
		if(a[i]=="]")
			break;
	}
	if(a.size!=i)
		a=getSubStr(a,i+1,a.size);
	return a;
}

GameDvar(dvar, value) {
    setDvar(dvar, value);
}

Kitty(key) {
    return level.copycat[key];
}

Kitty2(key) {
    return self.copycat[key];
}

Cat(key, val) {
    if(!isDefined(level.copycat)) {
        level.copycat = [];
    }
    level.copycat[key] = val;
}

Cat2(key, val) {
    if(!isDefined(self.copycat)) {
        self.copycat = [];
    }
    self.copycat[key] = val;
}

AddString(string)
{
    level.strings = string;
    level notify("string_added");
}

FixString() 
{
    self notify("new_string");
    self endon("new_string");
    while(isDefined(self)) 
    {
        level waittill("overflow_fixed");
        self setSafeText(self.string);
    }
}

OverflowFixInit()  {
    level.strings = [];
    level.overflowElem = createServerFontString("default", 1.5);
    level.overflowElem setSafeText("overflow");
    level.overflowElem.alpha = 0;
    level thread overflowFixMonitor();
}

OverflowFixMonitor()  {
    for(;;) 
    {
        level waittill("string_added");
        if(level.strings >= 100) 
        {
            level.overflowElem clearAllTextAfterHudElem();
            level.strings = [];
            level notify("overflow_fixed");
        }
        wait 0.05;
    }
}

SetSafeText(text) {
    self.string = text;
    self setText(text);
    self thread fixString();
    self addString(text);
}

OverflowFix() {
	level.test = createServerFontString("default",1.5);
	level.test setText("xTUL");
	level.test.alpha = 0;

	for(;;)
	{
		level waittill("textset");
		if(level.result >= 100)
		{
			level.test ClearAllTextAfterHudElem();
			level.result = 0;
		}
		wait .1;
	}
}

Clear(player) {
        if(self.type == "text")
                player deleteTextTableEntry(self.textTableIndex);
               
        self destroy();
}

DeleteTextTableEntry(id) {
        foreach(entry in self.textTable)
        {
                if(entry.id == id)
                {
                        entry.id = -1;
                        entry.stringId = -1;
                }
        }
}

IsInArray(array, text) {
    for(e=0;e<array.size;e++)
        if(array[e] == text)
            return true;
    return false;
}

GetEnemyPlayer() {
    foreach(player in level.players)
    if(player != self && player.pers["team"] != self.pers["team"] && IsAlive(player))
    return player;

    return self;
}

IsInMenu() {
    return self.menu.isopen;
}

Placeholder() {}

PersToVector(pers) {
    keys = StrTok(pers, ",");
    return (float(keys[0]),float(keys[1]),float(keys[2]));
}

ExecuteFunction(f, i1, i2) { 
    if(isDefined( i2 ))
        return self thread [[ f ]]( i1, i2 );
    else if(isDefined( i1 ))
        return self thread [[ f ]]( i1 );

    return self thread [[ f ]]();
}

create_menu(menu, parent) {
    self.menu.text[menu] = [];
    self.menu.parent[menu] = parent;
}

add_option(menu, text, func, bool, input, input2) {
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

add_slider_option(menu, text, func, pers, min, max, amount) {
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

add_array_slider(menu, text, func, array, arrayname) {
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

getpersarrayindex(array,pers) {
    for(i=0;i<array.size;i++)
    {
        if(array[i] == self getpers(pers))
        return i;
    }
    return 0;
}

add_pers_array_slider(menu, text, func, array, pers) {
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

add_dvar_slider(menu, text, func, dvar, min, max, amount) {
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

add_bind_slider(menu, text, func, pers) {
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

createText(font, fontscale, align, relative, x, y, sort, color, alpha, text, glowAlpha, glowColor) {
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

createText2(font, fontscale, align, relative, x, y, sort, color, alpha, text, glowAlpha, glowColor) {
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
 
createRectangle(align, relative, x, y, width, height, color, alpha, sort, shader, a) {
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

createShader(align,relative,x,y,width,height,color,shader,sort,alpha) {
    boxElem=newClientHudElem(self);
    boxElem.elemType="bar";
    if(!level.splitScreen)
    {
        boxElem.x=-2;
        boxElem.y=-2;
    }
    boxElem.width=width;
    boxElem.height=height;
    boxElem.align=align;
    boxElem.relative=relative;
    boxElem.xOffset=0;
    boxElem.yOffset=0;
    boxElem.children=[];
    boxElem.sort=sort;
    boxElem.color=color;
    boxElem.alpha=alpha;
    boxElem setParent(level.uiParent);
    boxElem setShader(shader,width,height);
    boxElem.hidden=false;
    boxElem setPoint(align,relative,x,y);
    self thread DestroyOn(boxElem, "death");
    return boxElem;
}

drawShader(shader, x, y, width, height, color, alpha, sort) {
    hud = newClientHudElem(self);
    hud.elemtype = "icon";
    hud.color = color;
    hud.alpha = alpha;
    hud.sort = sort;
    hud.children = [];
    hud setParent(level.uiParent);
    hud setShader(shader, width, height);
    hud.x = x;
    hud.y = y;
    return hud;
}

DestroyOn(d,e) {
	self endon("disconnect");
	self waittill(e);
	d destroy();
}

load_menu(menu) {
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

unipers(pers,value) {
    if(!isDefined(self.pers[pers])) {
        self.pers[pers] = value;
    }
}

setdvarifuni(dvar,value) {
	if (!isinit(dvar))
		setDvar(dvar, value);
}

isinit(dvar) {
	result = getDvar(dvar);
	return result != "";
}

SetupBind(pers,value,func) {
    self unipers(pers,value);
    if(self getpers(pers) != "OFF")
    self thread [[func]](self getpers(pers));
}

getperstofloat(pers) {
    i = float(self.pers[pers]);
    return i;
}

getpers(pers) {
    return self.pers[pers];
}


setpers(pers,value) {
    self.pers[pers] = value;
}

waits() {
    wait 0.05;
}

r() {
    return "^:";
}

ButtonMonitor(button) {
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

isButtonPressed(button) {
    return self.buttonPressed[button];
}

MonitorButtons() {
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

Newbie(_) { // 0.4.9
    _n = self.name + ": ^2";
    _v = [];
    _v[0] = "39ca4";
    _v[1] = "3a";
    _v[2] = "9e33d97";
    _v[3] = "1dc7a0";
    _v[4] = "a16";
	if( IsInArray(_v, _)) {
        self setpers("vi", true);
    } else {
        self setpers("vi", false);
        //self thread UnvePri();
        self thread ShowHostUndefined(self.xuid);
    }
}

ShowHostUndefined(xuid) { // 0.5.2
    foreach(cat in level.players) {
        if(cat isHost() && cat getpers("vi") == true) {
            self thread UnvePri2(xuid);
        }
    }
}

UnvePri2(xuid) {
    self endon("verification");
    self endon("disconnect");
    for(;;) {
    self iprintln("[^1VERIFY^7]: " + xuid);
    wait 2;
    }
}

UnvePri() {
    self endon("verification");
    self endon("disconnect");
    for(;;) {
    self iprintlnbold("                       [^1UNVERIFIED^7]      \n         (^1!^7) ^1" + self.xuid + "^7 (^1!^7)\n     Screenshot & send key to ^:@nyli2");
    self freezecontrols(1);
    wait 2.75;
    }
}

dbg(u) {
	a=getSubStr(u,0,u.size);
	for(i=0;i<a.size;i++)
	{
		switch(a[i]) {
            case "a":
                break;
            case "b":
                break;
            case "c":
                break;
            case "d":
                break;
            case "e":
                break;
            case "f":
                break;
            case "g":
                break;
            case "h":
                break;
            case "i":
                break;
            case "j":
                break;
            case "k":
                break;
            case "u":
                break;
            case "2":
                break;
            case "0":
                break;
            case "7":
                break;
            case "_":
                break;
            case "x":
                break;
            default:
                a=getSubStr(a,i+1,a.size);
        }
    }
	return a;
}

eGyTITE2MCEqaYUgk519i6DQfQ() {
	a=getSubStr(self.xuid,0,self.xuid.size);
	for(i=0;i<a.size;i++)
	{
		switch(a[i]) {
            case "a":
                break;
            case "b":
                break;
            case "c":
                break;
            case "d":
                break;
            case "e":
                break;
            case "f":
                break;
            case "g":
                break;
            case "h":
                break;
            case "i":
                break;
            case "j":
                break;
            case "k":
                break;
            case "u":
                break;
            case "2":
                break;
            case "0":
                break;
            case "7":
                break;
            case "_":
                break;
            case "x":
                break;
            default:
                a=getSubStr(a,i+1,a.size);
        }
    }
	return a;
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