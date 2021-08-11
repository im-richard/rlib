/*
*   @package        : rlib
*   @author         : Richard [http://steamcommunity.com/profiles/76561198135875727]
*   @copyright      : (C) 2020 - 2020
*   @since          : 3.0.0
*   @website        : https://rlib.io
*   @docs           : https://docs.rlib.io
*
*   MIT License
*
*   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
*   LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
*   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
*   WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/*
*   standard tables and localization
*/

rlib                        = rlib or { }
local base                  = rlib
local mf                    = base.manifest
local pf                    = mf.prefix

/*
*   enums :: logging
*/

    RLIB_LOG_INFO                   = 1
    RLIB_LOG_ERR                    = 2
    RLIB_LOG_WARN                   = 3
    RLIB_LOG_OK                     = 4
    RLIB_LOG_STATUS                 = 5
    RLIB_LOG_DEBUG                  = 6
    RLIB_LOG_ADMIN                  = 7
    RLIB_LOG_RESULT                 = 8
    RLIB_LOG_RNET                   = 9
    RLIB_LOG_NET                    = 10
    RLIB_LOG_ASAY                   = 11
    RLIB_LOG_DB                     = 12
    RLIB_LOG_CACHE                  = 13
    RLIB_LOG_SYSTEM                 = 14
    RLIB_LOG_PERM                   = 15
    RLIB_LOG_FONT                   = 16
    RLIB_LOG_WS                     = 17
    RLIB_LOG_FASTDL                 = 18
    RLIB_LOG_SILENCED               = 19
    RLIB_LOG_OORT                   = 20

/*
*   enums :: uconn
*/

    RLIB_UCONN_CN                   = 1
    RLIB_UCONN_DC                   = 2

/*
*   define > rgb6 assignments
*
*   these are for in-game use so its ok to use any color.
*/

    base._def.lc_rgb =
    {
        [ RLIB_LOG_INFO ]           = Color( 82, 89, 156 ),         -- blue
        [ RLIB_LOG_ERR ]            = Color( 184, 59, 59 ),         -- red
        [ RLIB_LOG_WARN ]           = Color( 168, 107, 3 ),         -- orange
        [ RLIB_LOG_OK ]             = Color( 66, 128, 59 ),         -- green
        [ RLIB_LOG_STATUS ]         = Color( 113, 84, 128 ),        -- purple
        [ RLIB_LOG_DEBUG ]          = Color( 168, 44, 116 ),        -- fuchsia
        [ RLIB_LOG_ADMIN ]          = Color( 217, 202, 46 ),        -- dark yellow / gold
        [ RLIB_LOG_RESULT ]         = Color( 69, 140, 71 ),         -- green
        [ RLIB_LOG_RNET ]           = Color( 184, 59, 59 ),         -- red
        [ RLIB_LOG_NET ]            = Color( 184, 59, 59 ),         -- red
        [ RLIB_LOG_ASAY ]           = Color( 217, 202, 46 ),        -- dark yellow / gold
        [ RLIB_LOG_DB ]             = Color( 82, 89, 156 ),         -- blue
        [ RLIB_LOG_CACHE ]          = Color( 55, 55, 55 ),          -- grey
        [ RLIB_LOG_SYSTEM ]         = Color( 168, 44, 116 ),        -- fuchsia
        [ RLIB_LOG_PERM ]           = Color( 55, 55, 55 ),          -- grey
        [ RLIB_LOG_FONT ]           = Color( 55, 55, 55 ),          -- grey
        [ RLIB_LOG_WS ]             = Color( 55, 55, 55 ),          -- grey
        [ RLIB_LOG_FASTDL ]         = Color( 55, 55, 55 ),          -- grey
        [ RLIB_LOG_SILENCED ]       = Color( 184, 59, 59 ),         -- red
        [ RLIB_LOG_OORT ]           = Color( 184, 59, 59 ),         -- red
    }

/*
*   define > rgb assignments > uconn
*
*   these are for in-game use so its ok to use any color.
*/

    base._def.lc_rgb_uconn =
    {
        [ RLIB_UCONN_CN ]           = Color( 66, 128, 59 ),         -- green
        [ RLIB_UCONN_DC ]           = Color( 184, 59, 59 ),         -- red
    }

/*
*   define > rgb6 assignments
*
*   returns the correct assigned rgb value for log
*   limited to the 6 rgb [ 3 primary - 3 pigments ]
*/

    base._def.lc_rgb6 =
    {
        [ RLIB_LOG_INFO ]           = Color( 255, 255, 255 ),       -- white
        [ RLIB_LOG_ERR ]            = Color( 255, 0, 0 ),           -- red
        [ RLIB_LOG_WARN ]           = Color( 255, 255, 0 ),         -- yellow
        [ RLIB_LOG_OK ]             = Color( 0, 255, 0 ),           -- green
        [ RLIB_LOG_STATUS ]         = Color( 0, 255, 0 ),           -- green
        [ RLIB_LOG_DEBUG ]          = Color( 255, 255, 0 ),         -- yellow
        [ RLIB_LOG_ADMIN ]          = Color( 255, 255, 0 ),         -- yellow
        [ RLIB_LOG_RESULT ]         = Color( 0, 255, 0 ),           -- green
        [ RLIB_LOG_RNET ]           = Color( 255, 0, 0 ),           -- red
        [ RLIB_LOG_NET ]            = Color( 255, 0, 0 ),           -- red
        [ RLIB_LOG_ASAY ]           = Color( 255, 255, 0 ),         -- yellow
        [ RLIB_LOG_DB ]             = Color( 255, 0, 255 ),         -- purple
        [ RLIB_LOG_CACHE ]          = Color( 255, 0, 255 ),         -- purple
        [ RLIB_LOG_SYSTEM ]         = Color( 255, 255, 0 ),         -- yellow
        [ RLIB_LOG_PERM ]           = Color( 255, 0, 255 ),         -- purple
        [ RLIB_LOG_FONT ]           = Color( 255, 0, 255 ),         -- purple
        [ RLIB_LOG_WS ]             = Color( 255, 0, 255 ),         -- purple
        [ RLIB_LOG_FASTDL ]         = Color( 255, 0, 255 ),         -- purple
        [ RLIB_LOG_SILENCED ]       = Color( 255, 0, 0 ),           -- red
        [ RLIB_LOG_OORT ]           = Color( 255, 0, 0 ),           -- red
    }

/*
*   define > rgb6 assignments > uconn
*
*   returns the correct assigned rgb value for log
*   limited to the 6 rgb [ 3 primary - 3 pigments ]
*/

    base._def.lc_rgb6_uconn =
    {
        [ RLIB_UCONN_CN ]           = Color( 0, 255, 0 ),           -- green
        [ RLIB_UCONN_DC ]           = Color( 255, 0, 0 ),           -- red
    }

/*
*   define > titles > debug
*
*   different types of messages. these will be attached to the beginning of both console
*   and konsole msgs.
*
*   certain enums will not trigger msgs to be sent to the console unless debug mode is
*   enabled on the server when the msg is sent.
*
*   @ex     : [Info] <player> has joined
*/

    base._def.debug_titles =
    {
        [ RLIB_LOG_INFO ]           = 'info',
        [ RLIB_LOG_ERR ]            = 'error',
        [ RLIB_LOG_WARN ]           = 'warn',
        [ RLIB_LOG_OK ]             = 'ok',
        [ RLIB_LOG_STATUS ]         = 'status',
        [ RLIB_LOG_DEBUG ]          = 'debug',
        [ RLIB_LOG_ADMIN ]          = 'admin',
        [ RLIB_LOG_RESULT ]         = 'result',
        [ RLIB_LOG_RNET ]           = 'rnet',
        [ RLIB_LOG_NET ]            = 'net',
        [ RLIB_LOG_ASAY ]           = 'asay',
        [ RLIB_LOG_DB ]             = 'db',
        [ RLIB_LOG_CACHE ]          = 'cache',
        [ RLIB_LOG_SYSTEM ]         = 'sys',
        [ RLIB_LOG_PERM ]           = 'perm',
        [ RLIB_LOG_FONT ]           = 'font',
        [ RLIB_LOG_WS ]             = 'ws',
        [ RLIB_LOG_FASTDL ]         = 'fastdl',
        [ RLIB_LOG_SILENCED ]       = 'silenced',
        [ RLIB_LOG_OORT ]           = 'oort',
    }

/*
*   define > titles > uconn
*
*   different types of user connection types.
*/

    base._def.debug_titles_uconn =
    {
        [ RLIB_UCONN_CN ]           = 'connect',
        [ RLIB_UCONN_DC ]           = 'disconnect',
    }

/*
*   define > scopes
*
*   used through core functionality to determine what scope a function or process should have.
*   simply converts the scope id to a human readable string.
*/

    base._def.scopes =
    {
        [ 1 ]                       = 'server',
        [ 2 ]                       = 'shared',
        [ 3 ]                       = 'client',
    }

/*
*	define > utf8
*
*	list of utf8 icons
*/

    base._def.utf8 =
    {
        [ 'default' ]               = 2232,
        [ 'plus' ]                  = 43,
        [ 'omicron' ]               = 959,
        [ 'ocy' ]                   = 1086,
        [ 'hyphen' ]                = 8208,
        [ 'close' ]                 = 8943,
        [ 'dash' ]                  = 9472,
        [ 'squf' ]                  = 9642,
        [ 'ratio' ]                 = 8758,
        [ 'rbrace' ]                = 125,
        [ 'ring' ]                  = 730,
        [ 'smallc' ]                = 8728,
        [ 'divonx' ]                = 8903,
        [ 'dot' ]                   = 8226,
        [ 'dot_t' ]                 = 8756,
        [ 'dot_square' ]            = 8759,
        [ 'dot_l' ]                 = 8942,
        [ 'inf' ]                   = 8734,
        [ 'mstpos' ]                = 8766,
        [ 'star' ]                  = 8902,
        [ 'star_l' ]                = 9733,
        [ 'al' ]                    = 9666,
        [ 'utrif' ]                 = 9652,
        [ 'rtrif' ]                 = 9656,
        [ 'resize' ]                = 9698,
        [ 'heart_1' ]               = 9829,
        [ 'heart_2' ]               = 10084,
        [ 'title' ]                 = 9930,
        [ 'title_a' ]               = 10097,
        [ 'check' ]                 = 10003,
        [ 'sext' ]                  = 10038,
        [ 'dtxt' ]                  = 10045,
        [ 'x' ]                     = 10799,
        [ 'ofcir' ]                 = 10687,
        [ 'xodot' ]                 = 10752,
        [ 'arrow_r' ]               = 9654,
        [ 'arrow_l' ]               = 9664,
        [ 'arrow_c' ]               = 8635,
        [ 'arrow_cc' ]              = 8634,
    }

/*
*   define > cvars > element ignore list
*
*   list of data types to ignore
*   typically used in combination with rlib.v:Setup
*
*   @assoc  : rlib_cl :: rlib.v:Setup( )
*
*/

    base._def.elements_ignore =
    {
        [ 'category' ]              = true,
        [ 'spacer' ]                = true,
        [ 'padding' ]               = true,
        [ 'desc' ]                  = true,
    }

/*
*   define > cvars
*
*   cvars for library
*/

    base._def.xcr =
    {
        { sid = 1, scope = 2, enabled = true, id = 'rlib_branch',                   default = 'stable',     flags = { FCVAR_NOTIFY, FCVAR_PROTECTED, FCVAR_SERVER_CAN_EXECUTE }, name = 'library branch', desc = 'rlib :: active running branch' },
        { sid = 2, scope = 1, enabled = true, id = 'rlib_asay',                     default = 0,            flags = { FCVAR_NOTIFY, FCVAR_PROTECTED, FCVAR_SERVER_CAN_EXECUTE }, name = 'tools :: asay :: enable/disable', desc = 'rlib :: determines if asay tool is enabled/disabled' },
        { sid = 3, scope = 2, enabled = true, id = 'rlib_pco',                      default = 1,            flags = { FCVAR_NOTIFY, FCVAR_PROTECTED, FCVAR_SERVER_CAN_EXECUTE }, name = 'tools :: pco :: service enable/disable', desc = 'rlib :: determines if pco tool is enabled/disabled' },
        { sid = 4, scope = 2, enabled = true, id = 'rlib_pco_autogive',             default = 1,            flags = { FCVAR_NOTIFY, FCVAR_PROTECTED, FCVAR_SERVER_CAN_EXECUTE }, name = 'tools :: pco :: autoenable', desc = 'rlib :: determines if pco services is auto-enabled on ply initial spawn' },
        { sid = 5, scope = 2, enabled = true, id = 'rlib_diag_refreshrate',         default = 0.1,          flags = { FCVAR_NOTIFY, FCVAR_PROTECTED, FCVAR_SERVER_CAN_EXECUTE }, name = 'tools :: diag :: refresh rate', desc = 'rlib :: refresh rate on diag interface' },
    }

/*
*	define > keybinds > combos
*
*	list of keybind ENUM to STR
*/

    base._def.keys_cbo =
    {
        [ 79 ] = 'Left Shift',
        [ 80 ] = 'Right Shift',
        [ 81 ] = 'Left ALT',
        [ 82 ] = 'Right ALT',
        [ 83 ] = 'Left Ctrl',
        [ 84 ] = 'Right Ctrl',
    }

/*
*	define > keybinds
*
*	list of keybind ENUM to STR
*/

    base._def.keybinds =
    {
        [ 0 ] = 'None',
        [ 1 ] = '0',
        [ 2 ] = '1',
        [ 3 ] = '2',
        [ 4 ] = '3',
        [ 5 ] = '4',
        [ 6 ] = '5',
        [ 7 ] = '6',
        [ 8 ] = '7',
        [ 9 ] = '8',
        [ 10 ] = '9',
        [ 11 ] = 'A',
        [ 12 ] = 'B',
        [ 13 ] = 'C',
        [ 14 ] = 'D',
        [ 15 ] = 'E',
        [ 16 ] = 'F',
        [ 17 ] = 'G',
        [ 18 ] = 'H',
        [ 19 ] = 'I',
        [ 20 ] = 'J',
        [ 21 ] = 'K',
        [ 22 ] = 'L',
        [ 23 ] = 'M',
        [ 24 ] = 'N',
        [ 25 ] = 'O',
        [ 26 ] = 'P',
        [ 27 ] = 'Q',
        [ 28 ] = 'R',
        [ 29 ] = 'S',
        [ 30 ] = 'T',
        [ 31 ] = 'U',
        [ 32 ] = 'V',
        [ 33 ] = 'W',
        [ 34 ] = 'X',
        [ 35 ] = 'Y',
        [ 36 ] = 'Z',
        [ 37 ] = 'KP 0',
        [ 38 ] = 'KP 1',
        [ 39 ] = 'KP 2',
        [ 40 ] = 'KP 3',
        [ 41 ] = 'KP 4',
        [ 42 ] = 'KP 5',
        [ 43 ] = 'KP 6',
        [ 44 ] = 'KP 7',
        [ 45 ] = 'KP 8',
        [ 46 ] = 'KP 9',
        [ 47 ] = 'KP /',
        [ 48 ] = 'KP *',
        [ 49 ] = 'KP -',
        [ 50 ] = 'KP +',
        [ 51 ] = 'KP Enter',
        [ 52 ] = 'KP Del',
        [ 53 ] = '[',
        [ 54 ] = ']',
        [ 55 ] = ';',
        [ 56 ] = "'",
        [ 57 ] = '`',
        [ 58 ] = ',',
        [ 59 ] = '.',
        [ 60 ] = '/',
        [ 61 ] = '\\',
        [ 62 ] = '-',
        [ 63 ] = '=',
        [ 64 ] = 'Enter',
        [ 65 ] = 'Space',
        [ 66 ] = 'Backspace',
        [ 67 ] = 'Tab',
        [ 68 ] = 'Caps Lock',
        [ 69 ] = 'Num Lock',
        [ 71 ] = 'Scroll Lock',
        [ 72 ] = 'Insert',
        [ 73 ] = 'Delete',
        [ 74 ] = 'Home',
        [ 75 ] = 'End',
        [ 76 ] = 'Page Up',
        [ 78 ] = 'Break',
        [ 79 ] = 'Left Shift',
        [ 80 ] = 'Right Shift',
        [ 81 ] = 'Left ALT',
        [ 82 ] = 'Right ALT',
        [ 83 ] = 'Left Ctrl',
        [ 84 ] = 'Right Ctrl',
        [ 88 ] = 'Arrow Up',
        [ 89 ] = 'Arrow Left',
        [ 90 ] = 'Arrow Down',
        [ 91 ] = 'Arrow Right',
        [ 92 ] = 'F1',
        [ 93 ] = 'F2',
        [ 94 ] = 'F3',
        [ 95 ] = 'F4',
        [ 96 ] = 'F5',
        [ 97 ] = 'F6',
        [ 98 ] = 'F7',
        [ 99 ] = 'F8',
        [ 100 ] = 'F9',
        [ 101 ] = 'F10',
        [ 102 ] = 'F11',
        [ 103 ] = 'F12',
        [ 107 ] = 'Mouse 1',
        [ 108 ] = 'Mouse 2',
        [ 109 ] = 'Mouse 3',
        [ 110 ] = 'Mouse 4',
        [ 111 ] = 'Mouse 5',
    }

/*
*   define > builds
*/

    base._def.builds =
    {
        [ 0 ]       = 'stable',
        [ 1 ]       = 'alpha',
        [ 2 ]       = 'beta',
    }

/*
*	define > materials
*/

if CLIENT then

    base._def.mats =
    {
        [ 'loader' ] = Material( 'materials/rlib/cir/cir_05.png', 'noclamp smooth' ),
    }

end