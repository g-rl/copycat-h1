// H1 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

init()
{
    level thread onplayerconnect();
    level thread angora\copycat::Init();
}

onplayerconnect()
{
    for (;;)
    {
        level waittill( "connected", var_0 );

        if ( !isai( var_0 ) )
        {
            var_1 = 0;
            var_2 = 0;
            var_3 = 0;

            if ( maps\mp\_utility::invirtuallobby() )
            {
                var_4 = var_0 _meth_8568();
                var_1 = _func_2FA( var_4, common_scripts\utility::getstatsgroup_common(), "emblemPatchIndex" );
                var_3 = _func_2FA( var_4, common_scripts\utility::getstatsgroup_common(), "applyEmblemToCharacter" );
                var_2 = _func_2FA( var_4, common_scripts\utility::getstatsgroup_common(), "callingCardIndex" );
            }
            else
            {
                var_1 = var_0 getplayerdata( common_scripts\utility::getstatsgroup_common(), "emblemPatchIndex" );
                var_3 = var_0 getplayerdata( common_scripts\utility::getstatsgroup_common(), "applyEmblemToCharacter" );
                var_2 = var_0 getplayerdata( common_scripts\utility::getstatsgroup_common(), "callingCardIndex" );
            }

            var_0.playercardpatch = var_1;
            var_0 _meth_8577( var_3 );
            var_0.playercardbackground = var_2;
        }
    }
}
