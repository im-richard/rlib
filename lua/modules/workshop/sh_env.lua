/*
    @library        : rlib
    @module         : workshop
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
    module data
*/

    MODULE                  = { }
    MODULE.calls            = { }
    MODULE.resources        = { }

    MODULE.enabled		    = true
    MODULE.demo             = false
    MODULE.name			    = 'Workshop'
    MODULE.id			    = 'workshop'
    MODULE.author		    = 'Richard'
    MODULE.desc			    = 'workshop content downloader'
    MODULE.owner		    = false
    MODULE.version          = { 2, 0, 0, 0 }
    MODULE.libreq           = { 3, 6, 0, 0 }
    MODULE.released		    = 1663998734

/*
    fonts

    adding fonts to this list will ensure they are included when the server boots up
    utilizing resource.AddFile( )
*/

    MODULE.fonts = { }

/*
    workshops

    this section allows you to include workshop collections that
    will be automatically mounted when the server boots up and
    when players connect.
*/

    MODULE.fastdl 	            = false
    MODULE.precache             = false
    MODULE.ws_enabled 	        = false
    MODULE.ws_lst               = { }

/*
    storage
*/

    MODULE.storage = { }

/*
    ext files
*/

    MODULE.ext = { }

/*
    translations
*/

    MODULE.language = { }

/*
    materials
*/

    MODULE.materials = { }

/*
    datafolder
*/

    MODULE.datafolder = { }

/*
    permissions
*/

    MODULE.permissions = { }

/*
    entities
*/

    MODULE.ents = { }

/*
    module > calls > net
*/

    MODULE.calls.net =
    {
        [ 'workshop_fonts_reload' ]             = { 'workshop.fonts.reload' },
    }

/*
    module > calls > hooks
*/

    MODULE.calls.hooks =
    {
        [ 'workshop_rnet_register' ]            = { 'workshop.rnet.register' },
        [ 'workshop_fonts_register' ]           = { 'workshop.fonts.register' },
    }

/*
    module > calls > commands
*/

    MODULE.calls.commands =
    {
        [ 'workshop_rnet_reload' ]              = { 'workshop.rnet.reload' },
        [ 'workshop_fonts_reload' ]             = { 'workshop.fonts.reload' },
    }

/*
    module > calls > timers
*/

    MODULE.calls.timers = { }

/*
    resources > particles
*/

    MODULE.resources.ptc  = { }

/*
    resources > sounds
*/

    MODULE.resources.snd = { }

/*
    resources > models
*/

    MODULE.resources.mdl = { }

/*
    resources > panels
*/

    MODULE.resources.pnl = { }

/*
    doclick
*/

    MODULE.doclick = function( ) end

/*
    dependencies
*/

    MODULE.dependencies = { }