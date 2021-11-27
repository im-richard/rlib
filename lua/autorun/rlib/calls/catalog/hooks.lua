/*
    @library        : rlib
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
    library
*/

local base                  = rlib

/*
    hooks
*/

base.c.hooks =
{
    [ 'rlib_loader_post' ]                      = { 'rlib.loader.post' },
    [ 'rlib_initialize_post' ]                  = { 'rlib.initialize.post' },
    [ 'rlib_calls_pre' ]                        = { 'rlib.calls.pre' },
    [ 'rlib_calls_post' ]                       = { 'rlib.calls.post' },
    [ 'rlib_cmd_register' ]                     = { 'rlib.cmd.register' },
    [ 'rlib_pkg_register' ]                     = { 'rlib.pkg.register' },
    [ 'rlib_rnet_register' ]                    = { 'rlib.rnet.register' },
    [ 'rlib_fonts_register' ]                   = { 'rlib.fonts.register' },
    [ 'rlib_server_fjoin' ]                     = { 'rlib.server.fjoin' },
    [ 'rlib_server_welcome' ]                   = { 'rlib.server.welcome' },
    [ 'rlib_server_ready' ]                     = { 'rlib.server.ready' },
    [ 'rcore_rnet_register' ]                   = { 'rcore.rnet.register' },
    [ 'rcore_loader_post' ]                     = { 'rcore.loader.post' },
    [ 'rcore_onloaded' ]                        = { 'rcore.onloaded' },
    [ 'rcore_initialize_stats' ]                = { 'rcore.initialize.stats' },
    [ 'rcore_modules_initialize' ]              = { 'rcore.modules.initialize' },
    [ 'rcore_modules_register' ]                = { 'rcore.modules.register' },
    [ 'rcore_modules_onreload' ]                = { 'rcore.modules.onreload' },
    [ 'rcore_modules_writedata' ]               = { 'rcore.modules.writedata' },
    [ 'rcore_modules_storage' ]                 = { 'rcore.modules.storage' },
    [ 'rcore_modules_precache' ]                = { 'rcore.modules.precache' },
    [ 'rcore_modules_load_pre' ]                = { 'rcore.modules.load.pre' },
    [ 'rcore_modules_load_post' ]               = { 'rcore.modules.load.post' },
    [ 'rcore_modules_perms_register' ]          = { 'rcore.modules.perms.register' },
    [ 'rcore_modules_dependencies' ]            = { 'rcore.modules.dependencies' },
    [ 'rcore_modules_res_register' ]            = { 'rcore.modules.res.register' },
    [ 'rcore_modules_ptc_register' ]            = { 'rcore.modules.ptc.register' },
    [ 'rcore_modules_snd_register' ]            = { 'rcore.modules.snd.register' },
    [ 'rcore_modules_storage_struct' ]          = { 'rcore.modules.storage.struct' },
}