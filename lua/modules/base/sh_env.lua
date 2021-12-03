/*
    @library        : rlib
    @module         : base
    @docs           : https://docs.rlib.io

    IF YOU HAVE NOT DIRECTLY RECEIVED THESE FILES FROM THE DEVELOPER, PLEASE CONTACT THE DEVELOPER
    LISTED ABOVE.

    THE WORK (AS DEFINED BELOW) IS PROVIDED UNDER THE TERMS OF THIS CREATIVE COMMONS PUBLIC LICENSE
    ('CCPL' OR 'LICENSE'). THE WORK IS PROTECTED BY COPYRIGHT AND/OR OTHER APPLICABLE LAW. ANY USE OF
    THE WORK OTHER THAN AS AUTHORIZED UNDER THIS LICENSE OR COPYRIGHT LAW IS PROHIBITED.

    BY EXERCISING ANY RIGHTS TO THE WORK PROVIDED HERE, YOU ACCEPT AND AGREE TO BE BOUND BY THE TERMS
    OF THIS LICENSE. TO THE EXTENT THIS LICENSE MAY BE CONSIDERED TO BE A CONTRACT, THE LICENSOR GRANTS
    YOU THE RIGHTS CONTAINED HERE IN CONSIDERATION OF YOUR ACCEPTANCE OF SUCH TERMS AND CONDITIONS.

    UNLESS OTHERWISE MUTUALLY AGREED TO BY THE PARTIES IN WRITING, LICENSOR OFFERS THE WORK AS-IS AND
    ONLY TO THE EXTENT OF ANY RIGHTS HELD IN THE LICENSED WORK BY THE LICENSOR. THE LICENSOR MAKES NO
    REPRESENTATIONS OR WARRANTIES OF ANY KIND CONCERNING THE WORK, EXPRESS, IMPLIED, STATUTORY OR
    OTHERWISE, INCLUDING, WITHOUT LIMITATION, WARRANTIES OF TITLE, MARKETABILITY, MERCHANTIBILITY,
    FITNESS FOR A PARTICULAR PURPOSE, NONINFRINGEMENT, OR THE ABSENCE OF LATENT OR OTHER DEFECTS, ACCURACY,
    OR THE PRESENCE OF ABSENCE OF ERRORS, WHETHER OR NOT DISCOVERABLE. SOME JURISDICTIONS DO NOT ALLOW THE
    EXCLUSION OF IMPLIED WARRANTIES, SO SUCH EXCLUSION MAY NOT APPLY TO YOU.
*/

/*
*   module data
*/

    MODULE                  = { }
    MODULE.calls            = { }
    MODULE.resources        = { }

    MODULE.enabled          = true
    MODULE.name             = 'Base'
    MODULE.id               = 'base'
    MODULE.desc             = 'base module'
    MODULE.author           = 'Richard'
    MODULE.icon             = ''
    MODULE.version          = { 2, 0, 0, 0 }
    MODULE.libreq           = { 3, 2, 0, 0 }
    MODULE.released		    = 1607993054

/*
*   content distribution
*/

    MODULE.fastdl 	        = false
    MODULE.precache         = false
    MODULE.ws_enabled 	    = false
    MODULE.ws_lst           = { }

/*
*   storage :: sh
*/

    MODULE.storage =
    {
        settings = { },
    }

/*
*   storage :: sv
*/

    MODULE.storage_sv = { }

/*
*   storage :: cl
*/

    MODULE.storage_cl = { }

/*
*   calls :: commands
*/

    MODULE.calls.commands =
    {
        [ 'base_rnet_reload' ]                  = { 'base.rnet.reload' },
        [ 'base_fonts_reload' ]                 = { 'base.fonts.reload' },
    }

/*
*   calls :: hooks
*/

    MODULE.calls.hooks =
    {
        [ 'base_rnet_register' ]                = { 'base.rnet.register' },
        [ 'base_fonts_register' ]               = { 'base.fonts.register' },
    }

/*
*   calls :: net
*/

    MODULE.calls.net =
    {
        [ 'base_fonts_reload' ]                 = { 'base.fonts.reload' },
    }

/*
*   calls :: timers
*/

    MODULE.calls.timers =
    {
        [ 'base_sv_sys_runtime' ]               = { 'base.sv.sys.runtime' },
        [ 'base_sv_sys_loader' ]                = { 'base.sv.sys.loader' },
    }

/*
*   resources :: particles
*/

    MODULE.resources.ptc = { }

/*
*   resources :: sounds
*/

    MODULE.resources.snd = { }

/*
*   resources :: models
*/

    MODULE.resources.mdl = { }

/*
*   resources :: panels
*/

    MODULE.resources.pnl = { }

/*
*   permissions
*/

    MODULE.permissions =
    {
        [ 'rlib_user_gag_timed' ] =
        {
            id              = 'rlib_user_gag_timed',
            category        = 'RLib » User',
            name            = 'User » Timed Gag',
            desc            = 'Gags a player for a certain duration and then auto un-gags them',
            ulx_id          = 'ulx rlib_user_gag_timed',
            sam_id          = 'rlib_user_gag_timed',
            xam_id          = 'rlib_user_gag_timed',
            access          = 'superadmin',
            pubcmds         = { '!timedgag', '!tgag' },
            bExt            = true,
        },
        [ 'rlib_user_mute_timed' ] =
        {
            id              = 'rlib_user_mute_timed',
            category        = 'RLib » User',
            name            = 'User » Timed Mute',
            desc            = 'Mutes a player for a certain duration and then auto un-mutes them',
            ulx_id          = 'ulx rlib_user_mute_timed',
            sam_id          = 'rlib_user_mute_timed',
            xam_id          = 'rlib_user_mute_timed',
            access          = 'superadmin',
            pubcmds         = { '!timedmute', '!tmute' },
            bExt            = true,
        },
        [ 'rlib_user_team_set' ] =
        {
            id              = 'rlib_user_team_set',
            category        = 'RLib » User',
            name            = 'User » Set Team',
            desc            = 'Sets team for player',
            ulx_id          = 'ulx rlib_user_team_set',
            sam_id          = 'rlib_user_team_set',
            xam_id          = 'rlib_user_team_set',
            access          = 'superadmin',
            pubcmds         = { '!setteam' },
            bExt            = true,
        },
        [ 'rlib_user_team_get' ] =
        {
            id              = 'rlib_user_team_get',
            category        = 'RLib » User',
            name            = 'User » Get Team',
            desc            = 'Returns team of player',
            ulx_id          = 'ulx rlib_user_team_get',
            sam_id          = 'rlib_user_team_get',
            xam_id          = 'rlib_user_team_get',
            access          = 'superadmin',
            pubcmds         = { '!getteam' },
            bExt            = true,
        },
        [ 'rlib_user_frags_set' ] =
        {
            id              = 'rlib_user_frags_set',
            category        = 'RLib » User',
            name            = 'User » Set Frags',
            ulx_id          = 'ulx rlib_user_frags_set',
            sam_id          = 'rlib_user_frags_set',
            xam_id          = 'rlib_user_frags_set',
            desc            = 'Forces a player to have a specific amount of frags/kills',
            access          = 'superadmin',
            pubcmds         = { '!setfrags' },
            bExt            = true,
        },
        [ 'rlib_tools_mdlv' ] =
        {
            id              = 'rlib_tools_mdlv',
            category        = 'RLib » Tools',
            name            = 'Tools » MDLV',
            desc            = 'Model viewer',
            ulx_id          = 'ulx rlib_tools_mdlv',
            sam_id          = 'rlib_tools_mdlv',
            xam_id          = 'rlib_tools_mdlv',
            access          = 'superadmin',
            pubcmds         = { '!mdlview','!mdlv' },
            bExt            = true,
        },
        [ 'rlib_tools_pco' ] =
        {
            id              = 'rlib_tools_pco',
            category        = 'RLib » Tools',
            name            = 'Tools » PCO',
            desc            = 'Player-client-optimization service',
            ulx_id          = 'ulx rlib_tools_pco',
            sam_id          = 'rlib_tools_pco',
            xam_id          = 'rlib_tools_pco',
            access          = 'superadmin',
            pubcmds         = { '!setpco' },
            bExt            = true,
        },
        [ 'rlib_rp_job_set' ] =
        {
            id              = 'rlib_rp_job_set',
            category        = 'RLib » RP',
            name            = 'RP » Set Job',
            desc            = 'Set rp job from dropdown list',
            ulx_id          = 'ulx rlib_rp_job_set',
            sam_id          = 'rlib_rp_job_set',
            xam_id          = 'rlib_rp_job_set',
            access          = 'superadmin',
            pubcmds         = { '!setjob' },
            bExt            = true,
        },
        [ 'rlib_rp_job_set_cmd' ] =
        {
            id              = 'rlib_rp_job_set_cmd',
            category        = 'RLib » RP',
            name            = 'RP » Set Job',
            desc            = 'Set rp job based on command',
            ulx_id          = 'ulx rlib_rp_job_set_cmd',
            sam_id          = 'rlib_rp_job_set_cmd',
            xam_id          = 'rlib_rp_job_set_cmd',
            access          = 'superadmin',
            pubcmds         = { '!setjobcmd' },
            bExt            = true,
        },
        [ 'rlib_rp_job_get' ] =
        {
            id              = 'rlib_rp_job_get',
            category        = 'RLib » RP',
            name            = 'RP » Get Job',
            desc            = 'Get rp job id',
            ulx_id          = 'ulx rlib_rp_job_get',
            sam_id          = 'rlib_rp_job_get',
            xam_id          = 'rlib_rp_job_get',
            access          = 'superadmin',
            pubcmds         = { '!getjob' },
            bExt            = true,
        },
        [ 'rlib_rp_money_add' ] =
        {
            id              = 'rlib_rp_money_add',
            category        = 'RLib » RP',
            name            = 'RP » Add Money',
            desc            = 'Adds money for player',
            ulx_id          = 'ulx rlib_rp_money_add',
            sam_id          = 'rlib_rp_money_add',
            xam_id          = 'rlib_rp_money_add',
            access          = 'superadmin',
            pubcmds         = { '!addmoney' },
            bExt            = true,
        },
        [ 'rlib_rp_money_set' ] =
        {
            id              = 'rlib_rp_money_set',
            category        = 'RLib » RP',
            name            = 'RP » Set Money',
            desc            = 'Set money for player',
            ulx_id          = 'ulx rlib_rp_money_set',
            sam_id          = 'rlib_rp_money_set',
            xam_id          = 'rlib_rp_money_set',
            access          = 'superadmin',
            pubcmds         = { '!setmoney' },
            bExt            = true,
        },
        [ 'rlib_ents_pos' ] =
        {
            id              = 'rlib_ents_pos',
            category        = 'RLib » Ents',
            name            = 'Ent » Pos',
            desc            = 'Get ent position',
            ulx_id          = 'ulx rlib_ents_pos',
            sam_id          = 'rlib_ents_pos',
            xam_id          = 'rlib_ents_pos',
            access          = 'superadmin',
            pubcmds         = { '!entpos' },
            bExt            = true,
        },
        [ 'rlib_ents_goto' ] =
        {
            id              = 'rlib_ents_goto',
            category        = 'RLib » Ents',
            name            = 'Ent » Goto',
            desc            = 'Goto specified ent',
            ulx_id          = 'ulx rlib_ents_goto',
            sam_id          = 'rlib_ents_goto',
            xam_id          = 'rlib_ents_goto',
            access          = 'superadmin',
            pubcmds         = { '!entgoto' },
            bExt            = true,
        },
        [ 'rlib_ents_id' ] =
        {
            id              = 'rlib_ents_id',
            category        = 'RLib » Ents',
            name            = 'Ent » ID',
            desc            = 'Get ent id',
            ulx_id          = 'ulx rlib_ents_id',
            sam_id          = 'rlib_ents_id',
            xam_id          = 'rlib_ents_id',
            access          = 'superadmin',
            pubcmds         = { '!entid' },
            bExt            = true,
        },
        [ 'rlib_ents_class' ] =
        {
            id              = 'rlib_ents_class',
            category        = 'RLib » Ents',
            name            = 'Ent » Class',
            desc            = 'returns ent class',
            ulx_id          = 'ulx rlib_ents_class',
            sam_id          = 'rlib_ents_class',
            xam_id          = 'rlib_ents_class',
            access          = 'superadmin',
            pubcmds         = { '!entclass' },
            bExt            = true,
        },
    }

/*
*   doclick
*/

    MODULE.doclick = function( ) end

/*
*   dependencies
*/

    MODULE.dependencies =
    {

    }