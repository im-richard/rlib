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
    timers
*/

base.c.timers =
{
    [ '__lib_initialize' ]                      = { '__lib.initialize' },
    [ '__lib_initialize_setup' ]                = { '__lib.initialize.setup' },
    [ '__lib_onready_delay' ]                   = { '__lib.onready.delay' },
    [ 'rlib_noroot_notice' ]                    = { 'rlib.noroot.notice' },
    [ 'rlib_about_run' ]                        = { 'rlib.about.run' },
    [ 'rlib_debug_delay' ]                      = { 'rlib.debug.delay' },
    [ 'rlib_rdo_rendermode' ]                   = { 'rlib.rdo.rendermode' },
    [ 'rlib_rdo_initialize' ]                   = { 'rlib.rdo.initialize' },
    [ 'rlib_pl_spawn' ]                         = { 'rlib.pl.spawn' },
    [ 'rlib_debug_doclean' ]                    = { 'rlib.debug.doclean' },
    [ 'rlib_cmd_srv_restart' ]                  = { 'rlib.cmd.srv.restart' },
    [ 'rlib_cmd_srv_restart_wait' ]             = { 'rlib.cmd.srv.restart.wait' },
    [ 'rlib_cmd_srv_restart_wait_s1' ]          = { 'rlib.cmd.srv.restart.wait.s1' },
    [ 'rlib_cmd_srv_restart_wait_s2' ]          = { 'rlib.cmd.srv.restart.wait.s2' },
    [ 'rlib_cmd_srv_restart_wait_s3_p1' ]       = { 'rlib.cmd.srv.restart.wait.s3.p1' },
    [ 'rlib_cmd_srv_restart_wait_s3_p2' ]       = { 'rlib.cmd.srv.restart.wait.s3.p2' },
    [ 'rlib_spew_run' ]                         = { 'rlib.spew.run' },
    [ 'rlib_rnet_register' ]                    = { 'rlib.rnet.register' },
}