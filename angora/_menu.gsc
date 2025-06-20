#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include angora\_func;
#include angora\_util;
#include angora\_struct;

menuinit() {
    self.menu = SpawnStruct();
    self.hud = SpawnStruct();
    self.menu.isopen = false;
    self.scrolly = -26;
    self.shouldfixoverflow = false;
    self.menu.islocked = false;
    self Structure();
    self thread MenuButtons();
    self thread DestroyMenus("death");
    self thread DestroyMenus("game_ended");
}

MenuButtons() {
    self endon("disconnect");
    for(;;) {
        if(!self.menu.islocked)
        {
            if(!self.menu.isopen)
            {
                if(self isbuttonpressed("+actionslot 1") && self AdsButtonPressed())
                {
                    self freezecontrols(0);
                    self.menu.isopen = true;
                    self createmenuhud();
                    self Structure();
                    self load_menu("Copycat");
                    self notify("menuopened");
                    wait 0.1;
                }
            }
            else
            {
                if(self isButtonPressed("+actionslot 3") && self.menu.slidertype[self.menu.current][self.scroll] == "bind")
                {
                    pers = self.menu.pers[self.menu.current][self.scroll];
                    self notify("stop" + pers);

                    if(self getpers(pers) == "OFF")
                    self setpers(pers,"+smoke");
                    else if(self getpers(pers) == "+smoke") 
                    self setpers(pers,"+frag");
                    else if(self getpers(pers) == "+frag") 
                    self setpers(pers,"+actionslot 4");
                    else if(self getpers(pers) == "+actionslot 4") 
                    self setpers(pers,"+actionslot 3");
                    else if(self getpers(pers) == "+actionslot 3") 
                    self setpers(pers,"+actionslot 2");
                    else if(self getpers(pers) == "+actionslot 2") 
                    self setpers(pers,"+actionslot 1");
                    else if(self getpers(pers) == "+actionslot 1") 
                    self setpers(pers,"OFF");


                    if(self getpers(pers) != "OFF")
                    self executefunction( self.menu.func[self.menu.current][self.scroll], self getpers(pers) );
                    self structure();
                    self load_menu( self.menu.current );
                    self notify("selectedoption");
                    wait 0.1;
                }

                if(self isButtonPressed("+actionslot 4") && self.menu.slidertype[self.menu.current][self.scroll] == "bind")
                {
                    pers = self.menu.pers[self.menu.current][self.scroll];
                    self notify("stop" + pers);

                    if(self getpers(pers) == "OFF")
                    self setpers(pers,"+actionslot 1");
                    else if(self getpers(pers) == "+actionslot 1") 
                    self setpers(pers,"+actionslot 2");
                    else if(self getpers(pers) == "+actionslot 2") 
                    self setpers(pers,"+actionslot 3");
                    else if(self getpers(pers) == "+actionslot 3") 
                    self setpers(pers,"+actionslot 4");
                    else if(self getpers(pers) == "+actionslot 4") 
                    self setpers(pers,"+frag");
                    else if(self getpers(pers) == "+frag") 
                    self setpers(pers,"+smoke");
                    else if(self getpers(pers) == "+smoke") 
                    self setpers(pers,"OFF");


                    if(self getpers(pers) != "OFF")
                    self executefunction( self.menu.func[self.menu.current][self.scroll], self getpers(pers) );
                    self structure();
                    self load_menu( self.menu.current );
                    self notify("selectedoption");
                    wait 0.1;
                }

                if(self isButtonPressed("+actionslot 3") && self.menu.slidertype[self.menu.current][self.scroll] == "pers_array")
                {
                    array = self.menu.array[self.menu.current][self.scroll];
                    arrayname = self.menu.arrayname[self.menu.current][self.scroll];
                    pers = self.menu.pers[self.menu.current][self.scroll];
                    index = int(self.pers["arrayindex_" + arrayname]);

                    index--;
                    if(index < 0)
                    index = array.size - 1;

                    self.pers["arrayindex_" + arrayname] = index;
                    self setpers(pers,array[index]);
            
                    if(self.menu.func[self.menu.current][self.scroll] != ::placeholder)
                    self executefunction( self.menu.func[self.menu.current][self.scroll], self getpers(pers) );
                    self structure();
                    self load_menu(self.menu.current); 
                    self notify("selectedoption");
                    wait 0.1;
                }

                if(self isButtonPressed("+actionslot 4") && self.menu.slidertype[self.menu.current][self.scroll] == "pers_array")
                {
                    array = self.menu.array[self.menu.current][self.scroll];
                    arrayname = self.menu.arrayname[self.menu.current][self.scroll];
                    pers = self.menu.pers[self.menu.current][self.scroll];
                    index = int(self.pers["arrayindex_" + arrayname]);

                    index++;
                    if(index >= array.size)
                    index = 0;

                    self.pers["arrayindex_" + arrayname] = index;
                    self setpers(pers,array[index]);

                    if(self.menu.func[self.menu.current][self.scroll] != ::placeholder)
                    self executefunction( self.menu.func[self.menu.current][self.scroll], self getpers(pers) );
                    self structure();
                    self load_menu(self.menu.current);
                    self notify("selectedoption"); 
                    wait 0.1;
                }

                if(self isButtonPressed("+actionslot 3") && self.menu.slidertype[self.menu.current][self.scroll] == "slider")
                {
                    pers = self.menu.pers[self.menu.current][self.scroll];
                    value = float(self getpers(pers));

                    value -= self.menu.amount[self.menu.current][self.scroll];
                    if(value < self.menu.min[self.menu.current][self.scroll])
                    value = self.menu.max[self.menu.current][self.scroll];

                    self setpers(pers,value);

                    if(self.menu.func[self.menu.current][self.scroll] != ::placeholder)
                    self executefunction( self.menu.func[self.menu.current][self.scroll], self getpers(pers) );
                    self structure();
                    self load_menu( self.menu.current );
                    self notify("selectedoption");
                    wait 0.1;
                }

                if(self isButtonPressed("+actionslot 4") && self.menu.slidertype[self.menu.current][self.scroll] == "slider")
                {
                    pers = self.menu.pers[self.menu.current][self.scroll];
                    value = float(self getpers(pers));

                    value += self.menu.amount[self.menu.current][self.scroll];
                    if(value > self.menu.max[self.menu.current][self.scroll])
                    value = self.menu.min[self.menu.current][self.scroll];

                    self setpers(pers,value);

                    if(self.menu.func[self.menu.current][self.scroll] != ::placeholder)
                    self executefunction( self.menu.func[self.menu.current][self.scroll], self getpers(pers) );
                    self structure();
                    self load_menu( self.menu.current );
                    self notify("selectedoption");
                    wait 0.1;
                }

                if(self isButtonPressed("+actionslot 3") && self.menu.slidertype[self.menu.current][self.scroll] == "dvar")
                {
                    dvar = self.menu.dvar[self.menu.current][self.scroll];
                    value = getdvarfloat(dvar);

                    value -= self.menu.amount[self.menu.current][self.scroll];
                    if(value < self.menu.min[self.menu.current][self.scroll])
                    value = self.menu.max[self.menu.current][self.scroll];

                    setdvar(dvar,value);

                    self ExecuteFunction(self.menu.func[self.menu.current][self.scroll],getdvarfloat(dvar));
                    self notify("selectedoption");  
                    self structure();
                    self load_menu(self.menu.current); 
                    wait 0.1;
                }

                if(self isButtonPressed("+actionslot 4") && self.menu.slidertype[self.menu.current][self.scroll] == "dvar")
                {
                    dvar = self.menu.dvar[self.menu.current][self.scroll];
                    value = getdvarfloat(dvar);

                    value += self.menu.amount[self.menu.current][self.scroll];
                    if(value > self.menu.max[self.menu.current][self.scroll])
                    value = self.menu.min[self.menu.current][self.scroll];

                    setdvar(dvar,value);

                    self ExecuteFunction(self.menu.func[self.menu.current][self.scroll],getdvarfloat(dvar));
                    self notify("selectedoption");  
                    self structure();
                    self load_menu(self.menu.current); 
                    wait 0.1;
                }


                if(self isButtonPressed("+actionslot 3") && self.menu.slidertype[self.menu.current][self.scroll] == "array")
                {
                    array = self.menu.array[self.menu.current][self.scroll];
                    arrayname = self.menu.arrayname[self.menu.current][self.scroll];
                    index = int(self.pers["arrayindex_" + arrayname]);

                    index--;
                    if(index < 0)
                    index = array.size - 1;

                    self.pers["arrayindex_" + arrayname] = index;

                    self structure();
                    self load_menu(self.menu.current); 
                    wait 0.1;
                }

                if(self isButtonPressed("+actionslot 4") && self.menu.slidertype[self.menu.current][self.scroll] == "array")
                {
                    array = self.menu.array[self.menu.current][self.scroll];
                    arrayname = self.menu.arrayname[self.menu.current][self.scroll];
                    index = int(self.pers["arrayindex_" + arrayname]);

                    index++;
                    if(index >= array.size)
                    index = 0;

                    self.pers["arrayindex_" + arrayname] = index;

                    self structure();
                    self load_menu(self.menu.current); 
                    wait 0.1;
                }


                if(self isButtonPressed("+actionslot 1"))
                {
                    self.scroll--;
                    self update_scroll(0);
                    wait 0.1;
                }
                
                if(self isButtonPressed("+actionslot 2"))
                {
                    self.scroll++;
                    self update_scroll(1);

                    wait 0.1;
                }

                if(self usebuttonpressed())
                { 
                    if(self.menu.slidertype[self.menu.current][self.scroll] == "none")
                    {
                        self ExecuteFunction(self.menu.func[self.menu.current][self.scroll],self.menu.input[self.menu.current][self.scroll],self.menu.input2[self.menu.current][self.scroll]);
                        self notify("selectedoption");    
                        self structure();
                        self load_menu(self.menu.current);    
                        wait 0.2;
                    }
                    else if(self.menu.slidertype[self.menu.current][self.scroll] == "array")
                    {
                        arrayname = self.menu.arrayname[self.menu.current][self.scroll];
                        self ExecuteFunction(self.menu.func[self.menu.current][self.scroll],level.arrayscrolls[arrayname][int(self.pers["arrayindex_" + arrayname])]);
                        self notify("selectedoption");    
                        self structure();
                        self load_menu(self.menu.current);    
                        wait 0.2;
                    }
                    else if(self.menu.slidertype[self.menu.current][self.scroll] == "bind")
                    {
                        pers = self.menu.pers[self.menu.current][self.scroll];
                        self setpers(pers,"OFF");
                        self notify("stop" + pers);
                        self notify("selectedoption");    
                        self structure();
                        self load_menu(self.menu.current);    
                        wait 0.2;
                    }
                }

                if(self isButtonPressed("+stance"))
                {
                    if(self.menu.parent[self.menu.current] == "exit")
                    {
                        self destroymenuhud();
                        self.menu.isopen = false;
                        self notify("closedmenu");
                    }
                    else
                    {
                        self load_menu(self.menu.parent[self.menu.current]);
                        waitframe();
                    }
                    wait 0.1;
                }
            }
        }    
        waitframe();
    }
}


createmenuhud() {
    self.hud.scroll = self createRectangle("TOP", "CENTER", 201, -25, 200, 15, (0.204,0.216,0.247), 1, 4, "white"); // try and use first so it doesnt glitch out ?
    self.hud.background = self createRectangle("TOP", "CENTER", 201, -50, 200, 200, (0,0,0), 1, 0, "white");
    self.hud.background2 = self createRectangle("TOP", "CENTER", 201, -50, 200, 200, (0,0,0), 2, 1, "white");
    self.hud.background3 = self createRectangle("TOP", "CENTER", 201, -50, 200, 23, (0.204,0.216,0.247), 1, 9, "white");
    self.hud.background4 = self createRectangle("TOP", "CENTER", 201, -50, 200, 15, (0.204,0.216,0.247), 1, 9, "white");
    self.hud.background5 = self createRectangle("TOP", "CENTER", 201, -50, 200, 15, (0.204,0.216,0.247), 1, 9, "white");
    self.hud.topbar = self createRectangle("TOP", "CENTER", 201, -50, 200, 1, (0,0,0), 1, 10, "white");
    self.hud.middlebar = self createRectangle("TOP", "CENTER", 201, -27, 200, 1, (0,0,0), 1, 10, "white");
    self.hud.rightbar = self createRectangle("TOP", "CENTER", 301, -50, 1, 200, (0,0,0), 1, 10, "white");
    self.hud.leftbar = self createRectangle("TOP", "CENTER", 101, -50, 1, 200, (0,0,0), 1, 10, "white");
    self.hud.lurkzybar = self createRectangle("TOP", "CENTER", 201, 50, 201, 1, (0,0,0), 1, 10, "white");
    self.hud.prezhbar = self createRectangle("TOP", "CENTER", 201, 50, 201, 1, (0,0,0), 1, 10, "white");


    for(i=0;i<8;i++)
    {
        self.hud.text[i] = self createText("objective", 0.8, "LEFT", "CENTER", 106, -19 + (i * 15), 8, (0.9,0.9,0.9), 1, "");
        self.hud.booltext[i] = self createText("objective", 0.8, "RIGHT", "CENTER", 295, -19 + (i * 15), 8, (0.9,0.9,0.9), 1, "");
    }
}

destroymenuhud() {
    self.faketext Destroy();
    self.fakebool Destroy();
    self.hud.background Destroy();
    self.hud.background2 Destroy();
    self.hud.background3 Destroy();
    self.hud.background4 Destroy();
    self.hud.background5 Destroy();
    self.hud.topbar Destroy();
    self.hud.middlebar Destroy();
    self.hud.leftbar Destroy();
    self.hud.rightbar Destroy();
    self.hud.lurkzybar Destroy();
    self.hud.prezhbar Destroy();
    self.hud.scroll Destroy();

    for(i=0;i<8;i++)
    {
        self.hud.text[i] Destroy();
        self.hud.booltext[i] Destroy();
    }
}

updatebackground() {
    amount = self.menu.text[self.menu.current].size;
    if(amount > 8)
    amount = 8;
    self.hud.background SetShader("white", 200, 34 + (15 * amount));
    self.hud.background2 SetShader("white", 200, 34 + (15 * amount));
    self.hud.leftbar SetShader("white", 1, 40 + (15 * amount));
    self.hud.rightbar SetShader("white", 1, 40 + (15 * amount));
    self.hud.prezhbar.y = -26 + (15 * amount);
    self.hud.lurkzybar.y = -10 + (15 * amount);
    self.hud.background4.y = -25 + (15 * amount);
    self.hud.background5.y = -25 + (15 * amount);
}


moveandset(text,direction) {
    //self.ballsack = hudelem(self);
    self moveovertime(0.05);
    if(direction == 1)
    self.y -= 12;
    else
    self.y += 14;
    wait 0.1;
    //self thread SetSafeText(text);
    if(direction == 1)
    self.y += 12;
    else
    self.y -= 14;
}

panfix(direction) {
    if(direction == 1)
    return isdefined( self.menu.text[self.menu.current][self.scroll + 3] );
    else
    return isdefined( self.menu.text[self.menu.current][self.scroll + 4] );
}

update_scroll(direction) {
    balls = true;
    if(self panfix(direction))
    balls = false;

    if(balls && direction == -1)
    {
        for(i=0;i<8;i++)
        {
            self.hud.text[i] Destroy();
            self.hud.text[i] = self createText("objective", 0.8, "LEFT", "CENTER", 106, -19 + (i * 15), 8, (0.9,0.9,0.9), 1, "");

            self.hud.booltext[i] Destroy();
            self.hud.booltext[i] = self createText("objective", 0.8, "RIGHT", "CENTER", 295, -19 + (i * 15), 8, (0.9,0.9,0.9), 1, "");
        }
    }
    else
    self.shouldfixoverflow = true;

    if(self.smoothscroll)
    self.hud.scroll MoveOverTime(0.1);
    else
    self.hud.scroll MoveOverTime(0);

    if ( self.scroll < 0 )
        self.scroll = self.menu.text[self.menu.current].size - 1;

    if ( self.scroll > self.menu.text[self.menu.current].size - 1 )
        self.scroll = 0;

    if (  (direction == -1 && self.scroll < 5) || (direction == 1 && self.scroll < 5) || (direction == 0 && self.scroll < 4) || (self.menu.text[self.menu.current].size <= 8) )
    {
        for ( i = 0; i < 8; i++ )
        {
            if ( isdefined( self.menu.text[self.menu.current][i] ) )
                self.hud.text[i] SetSafeText( self.menu.text[self.menu.current][i] );
            else
                self.hud.text[i] SetSafeText( "" );

            self.hud.booltext[i] SetSafeText( self.menu.bool[self.menu.current][i] );
        }
        self.hud.scroll.y = self.scrolly + 15 * self.scroll;
    }
    else if (self panfix(direction))
    {
        
        self.hud.scroll.y = self.scrolly + 15 * 4;
        if(direction != -1)
        {
            index = 0;
            for ( i = self.scroll - 4; i < self.scroll + 4; i++ )
            {
                if ( isdefined( self.menu.text[self.menu.current][i] ) )
                    self.hud.text[index] thread moveandset( self.menu.text[self.menu.current][i], direction );
                else
                    self.hud.text[index] thread moveandset( "", direction );

                self.hud.booltext[index] thread moveandset( self.menu.bool[self.menu.current][i], direction );
                index++;
            }
            self.faketext = self createText2("objective", 0.8, "LEFT", "CENTER", 106, direction == 1 ? (-19 + (8 * 15)) : -31, 2, (0.9,0.9,0.9), 1, direction == 1 ? self.menu.text[self.menu.current][self.scroll + 3] : self.menu.text[self.menu.current][self.scroll - 4]);
            self.fakebool = self createText2("objective", 0.8, "RIGHT", "CENTER", 295, direction == 1 ? (-19 + (8 * 15)) : -31, 2, (0.9,0.9,0.9), 1, direction == 1 ? self.menu.bool[self.menu.current][self.scroll + 3] : self.menu.bool[self.menu.current][self.scroll - 4]);
            self.faketext MoveOverTime(0.05);
            self.fakebool MoveOverTime(0.05);
            if(direction == 1)
            {
                self.fakebool.y -= 12;
                self.faketext.y -= 12;
                wait 0.1;
                self.faketext Destroy();
                self.fakebool Destroy();
            }
            else
            {
                self.fakebool.y += 12;
                self.faketext.y += 12;
                wait 0.1;
                self.faketext Destroy();
                self.fakebool Destroy();
            }
            for(i=0;i<8;i++)
            {
               // if(isdefined(self.hud.text[i].ballsack))
                self.hud.text[i] Destroy();
                self.hud.text[i] = self createText("objective", 0.8, "LEFT", "CENTER", 106, -19 + (i * 15), 8, (0.9,0.9,0.9), 1, "");

              //  if(isdefined(self.hud.booltext[i].ballsack))
                self.hud.booltext[i] Destroy();
                self.hud.booltext[i] = self createText("objective", 0.8, "RIGHT", "CENTER", 295, -19 + (i * 15), 8, (0.9,0.9,0.9), 1, "");
            }
            index = 0;
            for ( i = self.scroll - 4; i < self.scroll + 4; i++ )
            {
                if ( isdefined( self.menu.text[self.menu.current][i] ) )
                    self.hud.text[index] SetSafeText( self.menu.text[self.menu.current][i] );
                else
                    self.hud.text[index] SetSafeText( "" );

                self.hud.booltext[index] SetSafeText( self.menu.bool[self.menu.current][i] );
                index++;
            }

        }
        else
        {
            for(i=0;i<8;i++)
            {
                self.hud.text[i] Destroy();
                self.hud.text[i] = self createText("objective", 0.8, "LEFT", "CENTER", 106, -19 + (i * 15), 8, (0.9,0.9,0.9), 1, "");

                self.hud.booltext[i] Destroy();
                self.hud.booltext[i] = self createText("objective", 0.8, "RIGHT", "CENTER", 295, -19 + (i * 15), 8, (0.9,0.9,0.9), 1, "");
            }
            index = 0;
            for ( i = self.scroll - 4; i < self.scroll + 4; i++ )
            {
                if ( isdefined( self.menu.text[self.menu.current][i] ) )
                    self.hud.text[index] SetSafeText( self.menu.text[self.menu.current][i] );
                else
                    self.hud.text[index] SetSafeText( "" );

                self.hud.booltext[index] SetSafeText( self.menu.bool[self.menu.current][i] );
                index++;
            }
        }
    }
    else
    {
        for(i=0;i<8;i++)
        {
            self.hud.text[i] Destroy();
            self.hud.text[i] = self createText("objective", 0.8, "LEFT", "CENTER", 106, -19 + (i * 15), 8, (0.9,0.9,0.9), 1, "");

            self.hud.booltext[i] Destroy();
            self.hud.booltext[i] = self createText("objective", 0.8, "RIGHT", "CENTER", 295, -19 + (i * 15), 8, (0.9,0.9,0.9), 1, "");
        }
        for(i=0;i<8;i++)
        {
            self.hud.text[i] SetSafeText(self.menu.text[self.menu.current][self.menu.text[self.menu.current].size + i - 8]);

            self.hud.booltext[i] SetSafeText(self.menu.bool[self.menu.current][self.menu.bool[self.menu.current].size + i - 8]);
        }
       // self.hud.text[self.scroll - self.menu.text[self.menu.current].size + 10] SetSafeText("^0>>" + self.menu.text[self.menu.current][self.scroll] + "<<");

        self.hud.scroll.y = self.scrolly + 15 * ( self.scroll - self.menu.text[self.menu.current].size + 8 );
    }
}

DestroyMenus(type) {
    self endon("disconnect");
    for(;;) {
        self waittill(type);
        self.menu.isopen = false;
        self destroymenuhud();
    }
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