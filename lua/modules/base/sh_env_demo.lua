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
    MODULE.parent		    = addonGlobalTable or { }
    MODULE.demo             = false
    MODULE.name             = 'Base'
    MODULE.id               = 'base'
    MODULE.desc             = 'base module'
    MODULE.author           = 'Richard'
    MODULE.icon             = ''
    MODULE.script_id	    = '{{ script_id }}'
    MODULE.owner		    = '{{ user_id }}'
    MODULE.version          = { 1, 0, 0, 0 }
    MODULE.libreq           = { 3, 1, 7, 0 }
    MODULE.released		    = 1597549923

/*
*   content distribution
*/

    MODULE.fastdl 	        = false
    MODULE.precache         = false
    MODULE.ws_enabled 	    = false
    MODULE.ws_lst           = { }

/*
*   fonts :: push
*/

    MODULE.fonts_push       = false

/*
*   fonts :: list
*/

    MODULE.fonts =
    {
        'fontname.ttf'
    }

/*
*   external config files
*/

    MODULE.ext =
    {
        [ 'database' ]      = 'database.rlib',
    }

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
*   entities
*/

    MODULE.ents =
    {
        [ 1 ] =
        {
            ent             = 'ent_name',
            model           = 'path/to/model.mdl',
            material        = 'path/to/material',
            ptc =
            {
                'particles/path/file_01.pcf',
                'particles/path/file_02.pcf',
            },
            ptc_pc =
            {
                'particle_name_id_01',
                'particle_name_id_02'
            },
            name            = 'Entity Name',
            desc            = 'Short description of ent',
            author          = 'Richard',
            category        = 'DarkRP',
            spawnable       = true,
            adminspawn      = true,
        },
    }

/*
*   calls :: commands
*/

    MODULE.calls.commands =
    {
        [ 'module_cmd' ] =
        {
            enabled     = true,
            id          = 'module.cmd',
            desc        = 'demo command example',
            scope       = 1,
            assoc = function( ... )
                module.cc_demo( ... )
            end,
        },
    }

/*
*   datafolder
*/

    MODULE.datafolder =
    {
        [ 1 ] =
        {
            parent          = 'rlib/modules',
            sub             = 'example',
            file            = game.GetMap( )
        },
    }

/*
*   permissions
*/

    MODULE.permissions =
    {
        [ 'demo_perm_ex' ] =
        {
            id              = 'demo_perm_ex',
            category        = 'Demo » Perm',
            desc            = 'Permission example',
            access          = 'superadmin',
            pubcmds         = { '!chatcmd', '!chatcmd2' },
            bExt            = true,
        },
    }

/*
*   mats
*/

    MODULE.mats =
    {
        [ 'mat_example' ]                   = { 'path/to/image.png' },
    }

/*
*   calls :: hooks
*/

    MODULE.calls.hooks =
    {
        [ 'hook_name_demo' ]                = { 'hook.name.demo' },
    }

/*
*   calls :: net
*/

    MODULE.calls.net =
    {
        [ 'net_name_demo' ]                 = { 'net.name.demo' },
    }

/*
*   calls :: timers
*/

    MODULE.calls.timers =
    {
        [ 'timer_name_demo' ]               = { 'timer.name.demo' },
    }

/*
*   resources :: particles
*/

    MODULE.resources.ptc =
    {
        [ 'particle_file_demo_call' ]       = { 'particles/path/to/particle.pcf' },
        [ 'particle_demo_call' ]            = { 'particle_name' },
    }

/*
*   resources :: sounds
*/

    MODULE.resources.snd =
    {
        [ 'snd_call_id' ]                   = { 'path/to/sound/file.mp3' },
    }

/*
*   resources :: models
*/

    MODULE.resources.mdl =
    {
        [ 'mdl_call_id' ]                   = { 'path/to/mdl/file.mdl' },
    }

/*
*   resources :: panels
*/

    MODULE.resources.pnl =
    {
        [ 'pnl_call_id' ]                   = { 'module.pnl.call.id' },
    }

/*
*   language
*/

    MODULE.language =
    {

        /*
        *   emglish
        */

        [ 'en' ] =
        {
            translated_string_id            = 'Example string in English',
        },
    }

/*
*   doclick
*/

    MODULE.doclick = function( ) end

/*
*   dependencies
*/

    MODULE.dependencies = { HpwRewrite, PS2 }