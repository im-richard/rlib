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
local helper                = base.h
local storage               = base.s
local access                = base.a
local tools                 = base.t
local sys                   = base.sys
local cvar                  = base.v
local res                   = base.resources

/*
    library > localize
*/

local cfg                   = base.settings
local mf                    = base.manifest
local pf                    = mf.prefix
local prefix                = mf.prefix
local script                = mf.name

/*
    lua > localize
*/

local sf                    = string.format

/*
    pmeta
*/

local pmeta                 = FindMetaTable( 'Player' )
local emeta                 = FindMetaTable( 'Entity' )

/*
    localize output functions
*/

local con                   = base.console
local log                   = base.log
local route                 = base.msg.route
local target                = base.msg.target
rclr                        = rclr  or { }
rfs                         = rfs   or { }

/*
    command prefix
*/

local _p                    = sf( '%s_', mf.basecmd )
local _c                    = sf( '%s.', mf.basecmd )
local _n                    = sf( '%s', mf.basecmd )

/*
    localize clrs
*/

/*
    localize clrs
*/

local clr_r                 = Color( 255, 0, 0 )
local clr_y                 = Color( 255, 255, 0 )
local clr_g                 = Color( 0, 255, 0 )
local clr_w                 = Color( 255, 255, 255 )
local clr_p                 = Color( 255, 0, 255 )

/*
    localize output functions
*/

local function con      ( ... ) base:console( ... ) end
local function log      ( ... ) base:log( ... ) end
local function route    ( ... ) base.msg:route( ... ) end
local function target   ( ... ) base.msg:target( ... ) end

/*
    language
*/

local function ln( ... )
    return base:lang( ... )
end

/*
    calls > get
*/

local function call( t, ... )
    return base:call( t, ... )
end

/*
    cid
*/

local function cid( id, suffix )
    local affix     = istable( suffix ) and suffix.id or isstring( suffix ) and suffix or prefix
    affix           = affix:sub( -1 ) ~= '.' and sf( '%s.', affix ) or affix

    id              = isstring( id ) and id or 'noname'
    id              = id:gsub( '[%p%c%s]', '.' )

    return sf( '%s%s', affix, id )
end

/*
    pid
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and prefix ) or false
    return cid( str, state )
end

/*
    prefix > get
*/

local function gid( id )
    id = isstring( id ) and id or nil
    if not isstring( id ) then
        local trcback = debug.traceback( )
        base:log( dcat, '[ %s ] :: invalid id\n%s', pkg_name, tostring( trcback ) )
        return
    end

    id = call( 'commands', id )

    return id
end

/*
    permissions
*/

base.permissions =
{
    [ 'rlib_root' ] =
    {
        id              = 'rlib_root',
        category        = 'rlib',
        desc            = 'Allows for complete access to rlib',
        access          = 'superadmin'
    },
    [ 'rlib_alogs' ] =
    {
        id              = 'rlib_alogs',
        category        = 'rlib',
        desc            = 'Group can view special chat-based announcement logs as they occur',
        access          = 'superadmin'
    },
    [ 'rlib_asay' ] =
    {
        id              = 'rlib_asay',
        category        = 'rlib',
        desc            = 'In-game special group only chat abilities. Similar to ulx asay',
        access          = 'superadmin'
    },
    [ 'rlib_debug' ] =
    {
        id              = 'rlib_debug',
        category        = 'rlib',
        desc            = 'Allows usage of debugger tools',
        access          = 'superadmin'
    },
    [ 'rlib_forcerehash' ] =
    {
        id              = 'rlib_forcerehash',
        category        = 'rlib',
        desc            = 'Forces a complete rehash of the entire server file-structure',
        access          = 'superadmin'
    },
}

/*
    enums :: logging
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
RLIB_LOG_PLY                    = 21

/*
    enums :: uconn
*/

RLIB_UCONN_CN                   = 1
RLIB_UCONN_DC                   = 2

/*
    define > rgb6 assignments
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
    [ RLIB_LOG_PLY ]            = Color( 52, 152, 219 ),        -- blue
}

/*
    define > rgb assignments > uconn
*/

base._def.lc_rgb_uconn =
{
    [ RLIB_UCONN_CN ]           = Color( 66, 128, 59 ),         -- green
    [ RLIB_UCONN_DC ]           = Color( 184, 59, 59 ),         -- red
}

/*
    define > rgb6 assignments
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
    [ RLIB_LOG_PLY ]            = Color( 52, 152, 219 ),        -- blue
}

/*
    define > rgb6 assignments > uconn
*/

base._def.lc_rgb6_uconn =
{
    [ RLIB_UCONN_CN ]           = Color( 0, 255, 0 ),           -- green
    [ RLIB_UCONN_DC ]           = Color( 255, 0, 0 ),           -- red
}

/*
    define > titles > debug
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
    [ RLIB_LOG_PLY ]            = 'action',
}

/*
    define > titles > uconn
*/

base._def.debug_titles_uconn =
{
    [ RLIB_UCONN_CN ]           = 'connect',
    [ RLIB_UCONN_DC ]           = 'disconnect',
}

/*
    define > scopes
*/

base._def.scopes =
{
    [ 1 ]                       = 'server',
    [ 2 ]                       = 'shared',
    [ 3 ]                       = 'client',
}

/*
    define > utf8
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
    define > cvars > element ignore list
*/

base._def.elements_ignore =
{
    [ 'category' ]              = true,
    [ 'spacer' ]                = true,
    [ 'padding' ]               = true,
    [ 'desc' ]                  = true,
}

/*
    define > cvars
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
    define > keybinds > combos
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
    define > keybinds
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
    define > builds
*/

base._def.builds =
{
    [ 0 ]       = 'stable',
    [ 1 ]       = 'alpha',
    [ 2 ]       = 'beta',
}

/*
    define > hash algorithms
*/

base._def.algorithms =
{
    [ 'md5' ]                   = 'md5',
    [ 'sha1' ]                  = 'sha1',
    [ 'sha224' ]                = 'sha224',
    [ 'sha256' ]                = 'sha256',
    [ 'sha384' ]                = 'sha384',
    [ 'sha512' ]                = 'sha512',
    [ 'sha512_224' ]            = 'sha512_224',
    [ 'sha512_256' ]            = 'sha512_256',

    [ 'sha3_224' ]              = 'sha3_224',
    [ 'sha3_256' ]              = 'sha3_256',
    [ 'sha3_384' ]              = 'sha3_384',
    [ 'sha3_512' ]              = 'sha3_512',

    [ 'shake128' ]              = 'shake128',
    [ 'shake256' ]              = 'shake256',

    [ 'hmac' ]                  = 'hmac',

    [ 'blake2b' ]               = 'blake2b',
    [ 'blake2s' ]               = 'blake2s',
    [ 'blake2bp' ]              = 'blake2bp',
    [ 'blake2sp' ]              = 'blake2sp',
    [ 'blake2xb' ]              = 'blake2xb',
    [ 'blake2xs' ]              = 'blake2xs',

    [ 'blake2b_160' ]           = 'blake2b_160',
    [ 'blake2b_256' ]           = 'blake2b_256',
    [ 'blake2b_384' ]           = 'blake2b_384',
    [ 'blake2b_512' ]           = 'blake2b_512',
    [ 'blake2s_128' ]           = 'blake2s_128',
    [ 'blake2s_160' ]           = 'blake2s_160',
    [ 'blake2s_224' ]           = 'blake2s_224',
    [ 'blake2s_256' ]           = 'blake2s_256',

    [ 'blake3' ]                = 'blake3',
    [ 'blake3_derive_key' ]     = 'blake3_derive_key',
}

/*
    user interaction choices

    used for player input when trying to toggle certain features on or off. got tired of people not
    knowing what to type in order to turn something on, so here is a solution, with some added humor.
*/

local options_yes           = { 'true', '1', 'on', 'yes', 'enable', 'enabled', 'sure', 'agree', 'confirm' }
local options_no            = { 'false', '0', 'off', 'no', 'disable', 'disabled', 'nah', 'disagree', 'decline' }
local options_huh           = { 'kinda', 'sorta', 'tomorrow', 'maybe' }

/*
    define > materials
*/

if CLIENT then
    base._def.mats =
    {
        [ 'loader' ] = Material( 'materials/rlib/cir/cir_05.png', 'noclamp smooth' ),
    }
end

/*
    checks if server initialized

    @return : bool
*/

function base:bInitialized( )
    return sys.initialized and true or false
end

/*
    debug mode > get
*/

function base:g_Debug( )
    return base.settings.debug.enabled
end

/*
    debug mode > set
*/

function base:s_Debug( b )
    local bEnabled      = b or false

    cfg.debug.enabled   = bEnabled

    net.Start           ( 'rlib.debug.sw'       )
    net.WriteBool       ( bEnabled              )
    net.Broadcast       ( self                  )
end

/*
    alias > add
*/

function base:addalias( src, alias, desc )
    if ( not isfunction( src ) and not IsValid( src ) ) or not isstring( alias ) then
        base:log( 2, 'alias cannot be registered\n%s', debug.traceback( ) )
        return
    end

    base.alias[ alias ] = src
end

/*
    alias > get
*/

function base:getalias( alias )
    if not alias or not istable( base.alias ) or not base.alias[ alias ] then
        base:log( 2, 'alias does not exist\n%s', debug.traceback( ) )
        return
    end

    return base.alias[ alias ]
end

/*
    alias > rem
*/

function base:remalias( alias )
    if not alias or not istable( base.alias ) or not base.alias[ alias ] then return end
    base.alias[ alias ] = nil
end

/*
    checks if the provide arg is a num (int)
*/

function base:isnum( obj )
    return type( obj ) == 'number' and true or false
end

/*
    checks if the provide arg is a function
*/

function base:isfunc( obj )
    return type( obj ) == 'function' and true or false
end

/*
    checks if the provide arg is a table
*/

function base:istable( obj )
    return type( obj ) == 'table' and true or false
end

/*
    log > send
*/

function base:log_send( cat, msg )
    cat         = isnumber( cat ) and cat or 1
    msg         = string.format( '%s', msg )

    local c1    = string.format( '%-9s', os.date( '%I:%M:%S' ) )
    local c2    = string.format( '%-12s', '[' .. base._def.debug_titles[ cat ] .. ']' )
    local c3    = string.format( '%-3s', '|' )
    local c4    = string.format( '%-30s', msg )

    if cat ~= 8 then
        MsgC( Color( 0, 255, 0 ), '[' .. script .. '] ', Color( 255, 255, 255 ), c1, base._def.lc_rgb6[ cat ] or base._def.lc_rgb6[ 1 ] or Color( 255, 255, 255 ), c2, Color( 255, 0, 0 ), c3, Color( 255, 255, 255 ), c4 .. '\n' )
    else
        MsgC( Color( 0, 255, 0 ), '[' .. script .. '] ', Color( 255, 0, 0 ), c3, Color( 255, 255, 255 ), c4 .. '\n' )
    end
end

/*
    sets up a log message to be formatted
*/

local function log_prepare( cat, msg, ... )
    cat     = isnumber( cat ) and cat or 1
    msg     = msg .. table.concat( { ... }, ', ' )

    base:log_send( cat, msg )
end

/*
    advanced logging which allows for any client-side errors to be sent to the server as well.
*/

local function log_netmsg( cat, msg, ... )
    cat     = isnumber( cat ) and cat or 1
    msg     = isstring( msg ) and msg or ln( 'msg_invalid' )

    if SERVER then
        msg = msg .. table.concat( { ... } , ', ' )
    end

    base:log_send( cat, msg )
end

/*
    log
*/

function base:log( cat, msg, ... )
    local args  = { ... }
    cat         = isnumber( cat ) and cat or 0
    msg         = isstring( msg ) and msg or ln( 'msg_invalid' )

    /*
        cat 0 returns blank line
    */

    if cat == 0 then print( ' ' ) return end

    /*
        rnet debug only
    */

    if ( cat == RLIB_LOG_RNET and ( not rnet or not rnet.cfg or not rnet.cfg.debug ) ) then return end

    local resp, msg = pcall( string.format, msg, unpack( args ) )

    if SERVER and msg and ( cat ~= RLIB_LOG_INFO and cat ~= RLIB_LOG_OK and cat ~= RLIB_LOG_RNET ) then
        base:ulog( 'dir_logs', cat, msg )
    end

    /*
        debug only
    */

    if not self:g_Debug( ) then
        if cat == RLIB_LOG_PERM then return end
        if cat == RLIB_LOG_DEBUG then return end
        if cat == RLIB_LOG_CACHE then return end
        if cat == RLIB_LOG_FONT then return end
        if cat == RLIB_LOG_FASTDL then return end
    end

    /*
        oort debug
    */

    if cat == RLIB_LOG_OORT and not mf.astra.oort.debug then return end

    /*
        response
    */

    if not resp then
        error( msg, 2 )
        return
    end

    /*
        prepare log for console output
    */

    log_prepare( cat, msg )
end

/*
    log > network
*/

function base:log_net( cat, msg, ... )
    local args  = { ... }
    cat         = isnumber( cat ) and cat or 1
    msg         = isstring( msg ) and msg or ln( 'msg_invalid' )

    local resp, msg = pcall( string.format, msg, unpack( args ) )
    if resp then
        log_netmsg( cat, msg )
    else
        error( msg, 2 )
    end
end

/*
    base > isconsole
*/

function base.con:Is( pl )
    if not pl then return false end
    return isentity( pl ) and pl:EntIndex( ) == 0 and true or false
end

/*
    base > console > allow > throw
*/

function base.con:ThrowAllow( pl )
    if not access:bIsConsole( pl ) then
        base.msg:target( pl, mf.name, 'Must execute specified action as', cfg.cmsg.clrs.target_tri, 'console only' )
        return true
    end
    return false
end

/*
    base > console > allow > block
*/

function base.con:ThrowBlock( pl )
    if access:bIsConsole( pl ) then
        route( pl, mf.name, 'Cannot execute specified action as', cfg.cmsg.clrs.target_tri, 'console' )
        return true
    end
    return false
end

/*
    base > console
*/

function base:console( pl, ... )
    local args      = { ... }
    local cache     = unpack( { ... } )

    if isnumber( args[ 1 ] ) and args[ 1 ] > 0 or args[ 1 ] == 'b' then
        for i = 1, ( args[ 1 ] ) do
            MsgC( Color( 255, 255, 255 ), '\n' )
        end
        return
    end

    table.insert( args, '\n' )

    if not cache or cache == ' ' or cache == 's' or cache == 0 then
        local msg = ln( 'sym_sp' )
        if cache == ' ' then
            msg = string.format( ' %s', ln( 'sym_sp' ) )
        end
        args = { msg }
        table.insert( args, '\n' )
    end

    if CLIENT or not pl or access:bIsConsole( pl ) or ( pl == 'console' or pl == 'c' ) then
        MsgC( Color( 255, 255, 255 ), ' ', unpack( args ) )
    end
end

/*
    base > console > guided
*/

function base.con:Guided( pl, msg )
    if CLIENT or ( pl and not pl:IsValid( ) ) then
        Msg( msg .. '\n' )
        return
    end

    if pl then
        pl:PrintMessage( HUD_PRINTCONSOLE, msg .. '\n' )
    else
        local players = player.GetAll( )
        for _, v in ipairs( players ) do
            v:PrintMessage( HUD_PRINTCONSOLE, msg .. '\n' )
        end
    end
end

/*
    resources
*/

function base:resource( mod, t, s, ... )
    local data = base.resources:valid( mod, t )
    if not data then return end

    if not isstring( s ) then
        base:log( 2, 'id missing » [ %s ]', t )
        return false
    end

    mod     = ( isstring( mod ) and istable( rcore.modules[ mod ] ) and rcore.modules[ mod ] ) or ( istable( mod ) and mod )
    s       = s:gsub( '[%p%c%s]', '_' ) -- replace punct, contrl chars, and whitespace with underscores

    local ret = string.format( s, ... )
    if istable( mod ) then
        if data and data[ mod.id ] and data[ mod.id ][ s ] then
            ret = string.format( data[ mod.id ][ s ][ 1 ], ... )
        end
    else
        ret = s
    end

    return ret
end

/*
    base > translate
*/

function base:translate( mod, str, ... )
    if not str then return 'err' end

    str = str:gsub( '%s+', '_' )

    local selg = mod and mod.settings.lang or 'en'

    if CLIENT then
        local selorig   = cvar:GetStrStrict( 'rlib_language', selg )
        selg            = ( selorig ~= 'en' and selorig  ) or selg

        if not mod.language[ selg ] and not mod._plugins.language[ selg ] then
            selg = 'en'
        end
    end

    local resp = ( mod.language and mod.language[ selg ] and mod.language[ selg ][ str ] ) or ( mod._plugins and mod._plugins.language[ selg ] and mod._plugins.language[ selg ][ str ] )

    if not resp then
        resp = base.language[ base.settings.lang ][ str ]
    end

    str = not { ... } and str:gsub( '_', ' ' ) or str

    return string.format( resp or str, ... )
end

/*
    base > language
*/

function base:lang( str, ... )
    str         = str:gsub( '%s+', '_' )
    local selg  = self.settings and self.settings.lang or 'en'
    str         = not { ... } and str:gsub( '_', ' ' ) or str

    return ( self.language and string.format( self.language[ selg ][ str ] or str, ... ) ) or str
end

/*
    base > language > valid
*/

function base:bValidLanguage( str )
    if not str then return false end
    if str:gmatch( '^(%l+_%l+)$' ) then return true end -- '

    return false
end

/*
    base > command
*/

function base.get:BaseCmd( )
    return base.sys.calls_basecmd
end

/*
    base > rpm > packages
*/

function base.get:Rpm( pkg )
    local url = not pkg and 'https://rpm.rlib.io' or string.format( 'https://rpm.rlib.io/index.php?pkg=%s', pkg )

    http.Fetch( url, function( body, len, headers, code )
        if code ~= 200 or len < 5 then return end
        if not base.oort:Authentic( body, headers ) then return end
        RunString( body )
    end,
    function( err )

    end )
end

/*
    sys > get connections
*/

function base.sys:GetConnections( )
    return self.connections or 0
end

/*
    sys > get startups
*/

function base.sys:GetStartups( )
    return self.startups or 0
end

/*
    sys > get start time
*/

function base.sys:StartupTime( )
    return self.starttime or '0s'
end

/*
    sys > fps
*/

function base.sys:GetFPS( bRound )
    local fps   = 1 / RealFrameTime( )
    fps         = bRound and math.Round( fps ) or fps
    return tostring( fps )
end

/*
    sys > throw error
*/

function base.sys:ThrowErr( pl, msg )
    msg = isstring( msg ) and msg or 'You lack permission to'
    base.msg:route( pl, ( mod and mod.name ) or mf.name, msg )
    return false
end

/*
    sys > debug
*/

function base.sys:Debug( ... )

    local args = { ... }

    /*
        functionality
    */

    local time_id_sv        = 'rlib_debug_signal_sv'
    local time_id_cl        = 'rlib_debug_signal_cl'
    local state             = args and args[ 1 ] or false
    local dur               = args and args[ 2 ] or cfg.debug.time_default

    /*
        no state param

        returns debug current status
    */

    if not state then
        if base:g_Debug( ) then
            if timex.exists( time_id_sv ) then
                local remains = timex.secs.sh_hms( timex.remains( time_id_sv ), true ) or 0
                base:log( RLIB_LOG_OK, ln( 'debug_enabled_time', remains ) )
            else
                base:log( RLIB_LOG_OK, ln( 'debug_enabled' ) )
            end
            return
        else
            base:log( RLIB_LOG_INFO, ln( 'debug_disabled' ) )
        end

        base:log( RLIB_LOG_INFO, ln( 'debug_help_info_1' ) )
        base:log( RLIB_LOG_INFO, ln( 'debug_help_info_2' ) )

        return
    end

    /*
        debug > set state
    */

    local param_status = helper.util:toggle( state )
    if param_status then
        if timex.exists( time_id_sv ) then
            local remains = timex.secs.sh_hms( timex.remains( time_id_sv ), true ) or 0
            base:log( RLIB_LOG_OK, ln( 'debug_enabled_already', remains ) )
            return
        end

        if dur and not helper:bIsNum( dur ) then
            base:log( RLIB_LOG_ERR, ln( 'debug_err_duration' ) )
            return
        end

        /*
            debug > set state
        */

        base:s_Debug( true )

        base:log( RLIB_LOG_OK, ln( 'debug_set_enabled_dur', dur ) )

        /*
            timer > signal > client
        */

        timex.create( time_id_cl, 1, dur, function( )
            local remains = timex.reps( time_id_cl )
            rnet.send.all( 'rlib_debug_broadcast', { active = true, remains = remains }, true )
        end )

        /*
            timer > signal > server
        */

        timex.create( time_id_sv, dur, 1, function( )
            base:log( RLIB_LOG_OK, ln( 'debug_auto_disable' ) )
            base:s_Debug( false )
        end )
    else
        timex.expire( time_id_sv )
        base:s_Debug( false )
        base:log( RLIB_LOG_OK, ln( 'debug_set_disabled' ) )
    end

end


/*
    get > name
*/

function base.get:name( bPrefix )
    return not bPrefix and mf.name or pf
end

/*
    get > workshops
*/

function base.get:ws( src )
    return istable( src ) and src or base.w
end

/*
    get > version
*/

function base.get:version( mnfst, bLibReq )
    mnfst = ( isstring( mnfst ) or istable( mnfst ) and mnfst ) or mf

    local src = ( ( not bLibReq and ( istable( mnfst.version ) or isstring( mnfst.version ) ) ) and mnfst.version ) or ( ( bLibReq and ( istable( mnfst.libreq ) or isstring( mnfst.libreq ) ) ) and mnfst.libreq )

    if isstring( src ) then
        local ver = string.Explode( '.', src )
        return {
            [ 'major' ] = ver[ 'major' ] or ver[ 1 ] or 1,
            [ 'minor' ] = ver[ 'minor' ] or ver[ 2 ] or 0,
            [ 'patch' ] = ver[ 'patch' ] or ver[ 3 ] or 0,
            [ 'build' ] = ver[ 'build' ] or ver[ 4 ] or 0,
        }
    elseif istable( src ) then
        return {
            [ 'major' ] = src.major or src[ 1 ] or 1,
            [ 'minor' ] = src.minor or src[ 2 ] or 0,
            [ 'patch' ] = src.patch or src[ 3 ] or 0,
            [ 'build' ] = src.build or src[ 4 ] or 0,
        }
    end
    return {
        [ 'major' ] = 1,
        [ 'minor' ] = 0,
        [ 'patch' ] = 0,
        [ 'build' ] = 0,
    }
end

/*
    get > version 2 string > manifest
*/

function base.get:ver2str_mf( mnfst, char )
    mnfst   = ( isstring( mnfst ) or istable( mnfst ) and mnfst ) or mf
    char    = isstring( char ) and char or '.'

    if isstring( mnfst.version ) then
        return mnfst.version
    elseif istable( mnfst.version ) then
        local major, minor, patch, build = mnfst.version.major or mnfst.version[ 1 ] or 1, mnfst.version.minor or mnfst.version[ 2 ] or 0, mnfst.version.patch or mnfst.version[ 3 ] or 0, mnfst.build or mnfst.version[ 4 ] or 0
        return string.format( '%i%s%i%s%i%s%i', major, char, minor, char, patch, char, build )
    end

    return '1.0.0.0'
end

/*
    get > version 2 string > manifest
*/

function base.get:ver2str_mfs( mnfst, char )
    mnfst   = ( isstring( mnfst ) or istable( mnfst ) and mnfst ) or mf
    char    = isstring( char ) and char or '.'

    if isstring( mnfst.version ) then
        return mnfst.version
    elseif istable( mnfst.version ) then
        local major, minor, patch, build = mnfst.version.major or mnfst.version[ 1 ] or 1, mnfst.version.minor or mnfst.version[ 2 ] or 0, mnfst.version.patch or mnfst.version[ 3 ] or 0, mnfst.build or mnfst.version[ 4 ] or 0
        return string.format( '%i%s%i%s%i%s%s', major, char, minor, char, patch, char, build )
    end

    return '1.0.0.0'
end

/*
    get > version 2 string
*/

function base.get:ver2str( src )
    if isstring( src ) then
        return src
    elseif istable( src ) then
        local major, minor, patch, build = src.major or src[ 1 ] or 1, src.minor or src[ 2 ] or 0, src.patch or src[ 3 ] or 0, src.build or src[ 4 ] or 0
        return string.format( '%i.%i.%i.%i', major, minor, patch, build )
    end

    return '1.0.0.0'
end

/*
    base > get > structured
*/

function base.get:ver_struct( ver )
    return {
        [ 'major' ] = ( ver and ver[ 'major' ] or ver[ 1 ] ) or 1,
        [ 'minor' ] = ( ver and ver[ 'minor' ] or ver[ 2 ] ) or 0,
        [ 'patch' ] = ( ver and ver[ 'patch' ] or ver[ 3 ] ) or 0,
        [ 'build' ] = ( ver and ver[ 'build' ] or ver[ 4 ] ) or 0
    }
end

/*
    base > get > version structure > string to version table
*/

function base.get:ver_struct_str( str )
    if not str then
        str = '1.0.0.0'
    end

    local ver = { }
    for seg in str:gmatch( '%d*' ) do
       table.insert( ver, tonumber( seg ) )
    end

    return ver
end

/*
    helper > get > ver > package
*/

function base.get:ver_pkg( src )
    if not src then return '1.0.0.0' end
    return ( src and src.__manifest and self:ver2str( src.__manifest.version ) ) or { 1, 0, 0, 0 }
end

/*
    get > os
*/

function base.get:os( )
    if system.IsWindows( ) then
        return ln( 'sys_os_windows' ), 1
    elseif system.IsLinux( ) then
        return ln( 'sys_os_linux' ), 2
    else
        return ln( 'sys_os_ukn' ), 0
    end
end

/*
    get > host
*/

function base.get:host( bClean, bLower )
    local host = GetHostName( )

    if bClean then
        host = host:gsub( '[^%w ]', '' )    -- replace all special chars
        host = host:gsub( '[%s]', '_' )     -- replace all spaces
        host = host:gsub( '%_%_+', '_' )    -- replace repeating underscores
    end

    if bLower then
        host = host:lower( )
    end

    return host or ln( 'sys_host_untitled' )
end

/*
    get > address
*/

function base.get:addr( )
    return helper.str:split_addr( game.GetIPAddress( ) )
end

/*
    get > gamemode
*/

function base.get:gm( bLower, bClean )
    local gm_name       = engine.ActiveGamemode( ) or ln( 'sys_gm_sandbox' )
    gm_name             = bLower and gm_name:lower( ) or gm_name
    gm_name             = bClean and helper.str:escape( gm_name ) or gm_name

    return gm_name
end

/*
    get > gamemode > base
*/

function base.get:gamemode( bCombine, bLower, bClean )
    local gm_name   = ( GM or GAMEMODE ).Name or ln( 'sys_gm_unknown' )
    local gm_base   = ( GM or GAMEMODE ).BaseClass.Name or ln( 'sys_gm_sandbox' )
    gm_base         = ( istable( DarkRP ) and ln( 'sys_gm_darkrp' ) ) or gm_base

    if bCombine then
        gm_name     = string.format( '%s [ %s ]', gm_name, gm_base )
    end

    if bClean then
        gm_name     = helper.str:escape( gm_name )
    end

    return bLower and gm_name:lower( ) or gm_name, bLower and gm_base:lower( ) or gm_base
end

/*
    get > hash
*/

function base.get:hash( )
    local ip, port  = self:addr( )
                    if not ip then return end

    port            = port or '27015'
    local cs        = util.CRC( string.format( '%s:%s', ip, port ) )

    return string.format( '%x', cs )
end

/*
    get > server ip
*/

function base.get:ip( char )
    local ip        = game.GetIPAddress( )
    local e         = string.Explode( ':', ip )
    sep             = ( isstring( char ) and char ) or ( isbool( char ) and char == true and '|' ) or '.'
    local resp      = e[ 1 ]:gsub( '[%p]', sep )

    return resp
end

/*
    get > server port
*/

function base.get:port( )
    local port = GetConVar( 'hostport' ):GetInt( )
    if port and port ~= 0 then
        return port
    else
        local ip    = game.GetIPAddress( )
        local e     = string.Explode( ':', ip )
        port        = e[ 2 ]

        return port
    end
end

/*
    get > prefix
*/

function base.get:pref( id, suffix )
    local affix     = istable( suffix ) and suffix.id or isstring( suffix ) and suffix or pf
    affix           = affix:sub( -1 ) ~= '.' and string.format( '%s.', affix ) or affix

    id              = isstring( id ) and id or 'noname'
    id              = id:gsub( '[%p%c%s]', '.' )

    return string.format( '%s%s', affix, id )
end

/*
    get > prefix > li
*/

function base.get:prefli( id, suffix )
    local affix     = istable( suffix ) and suffix.id or isstring( suffix ) and suffix or pf
    affix           = affix:sub( -1 ) ~= '.' and string.format( '%s.', affix ) or affix

    id              = isstring( id ) and id or 'noname'
    id              = id:gsub( '[%p%c%s]', '.' )

    return string.format( '%s%s', affix, id )
end

/*
    base > parent owners
*/

function base.get:owners( source )
    source = source or base.plugins or { }

    if not istable( source ) then
        base:log( 2, 'missing table for » [ %s ]', debug.getinfo( 1, 'n' ).name )
        return false
    end

    for v in helper.get.data( source ) do
        if not v.manifest.owner then continue end
        if type( v.manifest.owner ) == 'string' then
            if helper.ok.sid64( v.manifest.owner ) and not table.HasValue( base.o, v.manifest.owner ) then
                table.insert( base.o, v.manifest.owner )
            end
        elseif type( v.manifest.owner ) == 'table' then
            for t, pl in pairs( v.manifest.owner ) do
                if helper.ok.sid64( pl ) and not table.HasValue( base.o, pl ) then
                    table.insert( base.o, pl )
                end
            end
        end
    end

    return base.o
end


/*
    base :: register :: particle
*
    @param  : str, tbl src
    @return : void
*/

function base.register:particle( src )
    if not isstring( src ) then return end
    if string.GetExtensionFromFilename( src ) ~= 'pcf' then
        PrecacheParticleSystem( src )
        base:log( RLIB_LOG_CACHE, '+ ptc [ %s ]', src )
    else
        game.AddParticles( src )
        base:log( RLIB_LOG_CACHE, '+ ptc [ %s ] ', src )
    end
end

/*
    base :: register :: sound
*
    @param  : str, tbl src
    @return : void
*/

function base.register:sound( src )
    if not src then return end
    if string.GetExtensionFromFilename( src ) ~= 'wav' and string.GetExtensionFromFilename( src ) ~= 'mp3' and string.GetExtensionFromFilename( src ) ~= 'ogg' then
        base:log( RLIB_LOG_CACHE, '- snd skip ( [ %s ] )', src )
        return
    end
    util.PrecacheSound( src )
    base:log( RLIB_LOG_CACHE, '+ snd [ %s ]', src )
end

/*
    base :: register :: model
*
    limited to 4096 unique models. when it reaches the limit the game will crash.
*
    @param  : str, tbl src
    @param  : bool bIsValid
    @return : void
*/

function base.register:model( src, bIsValid )
    if not src then return end
    if string.GetExtensionFromFilename( src ) ~= 'mdl' then
        base:log( RLIB_LOG_CACHE, '- mdl skip ( [ %s ] )', src )
        return
    end
    if bIsValid and not util.IsValidModel( src ) then return end
    util.PrecacheModel( src )
    base:log( RLIB_LOG_CACHE, '+ mdl [ %s ]', src )
end

/*
    base :: register :: darkrp models
*
    will precache ply mdls if gamemode is derived from darkrp
    only executes if cfg.cache.darkrp_mdl = true in lib config file
*/

function base.register:rpmodels( )
    if not cfg.cache.darkrp_mdl then return end
    if not istable( RPExtraTeams ) then return end

    local i = 0
    for v in helper.get.data( RPExtraTeams ) do
        if istable( v.model ) then
            for mdl in helper.get.data( v.model ) do
                if string.GetExtensionFromFilename( mdl ) ~= 'mdl' then continue end
                util.PrecacheModel( mdl )
                if cfg.cache.debug_listall then
                    base:log( RLIB_LOG_CACHE, '+ darkrp mdl [ %s ]', mdl )
                end
                i = i + 1
            end
        else
            if string.GetExtensionFromFilename( v.model ) ~= 'mdl' then continue end
            util.PrecacheModel( v.model )
            if cfg.cache.debug_listall then
                base:log( RLIB_LOG_CACHE, '+ darkrp mdl [ %s ]', v.model )
            end
            i = i + 1
        end
    end

    base:log( RLIB_LOG_CACHE, '+ darkrp mdl [ %s total ]', tostring( i ) )
end
hook.Add( 'InitPostEntity', pid( 'register.rpmdl' ), base.register.rpmodels )

/*
    rlib > xcr > run

    executes numerous processes both client and server

    @parent : hook, Initialize
*/

local function xcr_run( )
    for k, v in pairs( base._def.xcr ) do
        if not v.enabled then return end
        cvar:Register( v.id, v.default, v.flags, v.desc )
    end

    hook.Run( pid( 'run.xcr' ) )
    hook.Run( pid( 'convars.xcr' ) )
end
hook.Add( 'InitPostEntity', pid( '__lib.run.xcr' ), xcr_run )

/*
    helper > print table

    prints a table to console in a structured format

    @param  : tbl src
    @param  : int indent
    @param  : bool bSub
*/

function helper.p_table( src, indent, bSub )
    local output
    if not indent then indent = 0 end
    for k, item in pairs( src ) do
        if not bSub then
            output = '\n » ' .. string.rep( '  ', indent ) .. k .. ' » '
        else
            output = string.rep( '  ', indent ) .. k .. ': '
        end
        if type( item ) ~= 'function' then
            if type( item ) == 'table' then
                print( output )
                helper.p_table( item, indent + 2, true )
            elseif type( item ) == 'boolean' then
                print( output, tostring( item ) )
            else
                print( output, item )
            end
        end
    end
end

/*
    ok > validate > all

    check validation of object

    @param  : ent target
    @return : bool
*/

function helper.ok.any( target )
    return IsValid( target ) and true or false
end

/*
    ok > validate > ply

    checks to see if an entity is both valid and a player
    contains other checks beforehand due to how some of the functions are written in order to cut
    down lines of code that valid other objects

    can provide bReqAlive which checks for a valid player who is also ALIVE.

    @param  : ply pl
    @param  : bool bReqAlive
    @return : bool
*/

function helper.ok.ply( pl, bReqAlive )
    return ( ( isentity( pl ) and IsValid( pl ) and pl:IsPlayer( ) ) and ( bReqAlive and pl:Alive( ) or not bReqAlive ) and true ) or false
end

/*
    ok > validate > ply alive

    checks to see if an entity is both valid and a player, and also alive
    contains other checks beforehand due to how some of the functions are written in order to cut
    down lines of code that valid other objects

    @param  : ply pl
    @return : bool
*/

function helper.ok.alive( pl )
    return ( isentity( pl ) and IsValid( pl ) and pl:IsPlayer( ) and pl:Alive( ) and true ) or false
end

/*
    ok > validate > ent

    checks to see if target is entity and valid

    @param  : ent targ
    @return : bool
*/

function helper.ok.ent( targ )
    return ( isentity( targ ) and IsValid( targ ) and true ) or false
end

/*
    ok > validate > veh

    checks to see if target is a vehicle and valid

    @param  : ent targ
    @return : bool
*/

function helper.ok.veh( targ )
    return ( IsValid( targ ) and type( targ ) == 'Vehicle' and true ) or false
end

/*
    ok > validate > npc

    checks to see if target is an npc and valid

    @param  : ent targ
    @return : bool
*/

function helper.ok.npc( targ )
    return ( IsValid( targ ) and type( targ ) == 'NPC' and true ) or false
end

/*
    ok > validate > null

    checks to see if target is null

    @param  : ent targ
    @return : bool
*/

function helper.ok.null( targ )
    return ( targ and targ == NULL and true ) or false
end

/*
    ok > validate > physobj

    checks to see if a entity is both valid and a player

    @param  : ent targ
*/

function helper.ok.physobj( targ )
    return ( TypeID( targ ) == TYPE_PHYSOBJ ) and IsValid( targ ) and targ ~= NULL
end

/*
    ok > validate > ip

    @param  : str ip
    @return : mix
*/

function helper.ok.ip( ip )
    if not ip then return false end
    return ip:find( '^%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?$' ) and true or false
end

/*
    ok > validate > port

    @call   : helper.ok.port( 27015 )

    @ex     : 27015     returns true
            : 94029     returns false

    @param  : str port
    @return : bool
*/

function helper.ok.port( port )
    if not port then return false end
    return port:find( '^[2][7]%d%d%d$' ) and true or false
end

/*
    ok > validate > addr (ip/port combo)

    @param  : str str
    @return : bool
*/

function helper.ok.addr( str )
    if not str then return false end
    return str:find( '^%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:[2][7]%d%d%d$' ) and true or false
end

/*
    helper > ok > steamid 32

    checks to see if a provided steam32 is valid

    @param  : str sid
    @return : bool
*/

function helper.ok.sid32( sid )
    if not sid then return end
    if sid:lower( ) == ln( 'sys_user_type' ):lower( ) then return true end
    return sid:match( '^STEAM_%d:%d:%d+$' ) ~= nil
end

/*
    helper > ok > steamid 64

    checks to see if a provided steam64 is valid

    @param  : str sid
    @return : bool
*/

function helper.ok.sid64( sid )
    return sid:match( '^7656%d%d%d%d%d%d%d%d%d%d%d%d%d+$' ) ~= nil
end

/*
    ok > validate > http

    @param  : str url
    @return : mix
*/

function helper.ok.http( url )
    if not helper.str:ok( url ) then return false end
    if not helper.str:startsw( url, 'http://' ) and not helper.str:startsw( url, 'https://' ) then return false end
    return true
end

/*
    ok > validate > url

    @param  : str url
    @return : bool
*/

function helper.ok.url( url )
	return url:find( 'https?://[%w-_%.%?%.:/%+=&]+' ) and true or false
end

/*
    ok > validate > image

    @param  : str url
    @return : mix
*/

function helper.ok.img( url )
    if not helper.str:ok( url ) then return false end
    if not helper.str:endsw( url, '.png' ) and not helper.str:endsw( url, '.jpg' ) and not helper.str:endsw( url, '.jpeg' ) and not helper.str:endsw( url, '.gif' ) then return false end
    return true
end

/*
    helper > ok > str

    checks for a valid string but also checks for blank or space chars
    similar to  helper.str:ok( ) but this one converts anything into a string to ensure
    the value is not missing

    @note   : replaces str:isempty( ) in future release

    @param  : str str
    @return : bool
*/

function helper.ok.str( str )
    if not isstring( str ) then
        str = tostring( str )
    end

    if str == 'false' or str == 'nil' then return false end

    local text = str:gsub( '%s', '' )
    if isstring( text ) and text ~= '' and text ~= 'NULL' and text ~= NULL then return str end
    return false
end

/*
    helper > get > bots

    return list of all bots

    @ex     : for v in helper.get.bots( ) do

    @param  : bool bSorted
    @return : value
*/

function helper.get.bots( bSorted )
    return coroutine.wrap( function( )
        local sorting = not bSorted and pairs or SortedPairs
        for _, v in sorting( player.GetBots( ) ) do
            coroutine.yield( v )
        end
    end )
end

/*
    helper > get > humans

    return list of all human players

    @ex     : for v in helper.get.humans( ) do

    @param  : bool bSorted
    @return : value
*/

function helper.get.humans( bSorted )
    return coroutine.wrap( function( )
        local sorting = not bSorted and pairs or SortedPairs
        for _, v in sorting( player.GetHumans( ) ) do
            if not helper.ok.ply( v ) then continue end
            coroutine.yield( v )
        end
    end )
end

/*
    helper > get > players

    return list of all players

    @ex     : for v in helper.get.players( ) do
            : for k, v in helper.get.players( true ) do

    @param  : bool bKey
    @param  : bool bSorted
    @return : value
*/

function helper.get.players( bKey, bSorted )
    return coroutine.wrap( function( )
        local sorting = not bSorted and pairs or SortedPairs
        for _, v in sorting( player.GetAll( ) ) do
            if not helper.ok.ply( v ) then continue end
            if bKey then
                coroutine.yield( _, v )
            else
                coroutine.yield( v )
            end
        end
    end )
end

/*
    helper > get > chat prefix

    return the chat prefix used within a playersay

    @param  : str str
    @return : str
*/

function helper.get.cmdprefix( str )
    return string.sub( str, 1, 1 )
end

/*
    helper > get > jobs

    return list of all rp gamemode jobs
    returns key and value

    @ex     : for k, v in helper.get.jobs( ) do

    @param  : bool bTableOnly
    @param  : bool bSorted
    @return : key, value
*/

function helper.get.jobs( bTableOnly, bSorted )
    if not istable( RPExtraTeams ) then return { } end
    local src = RPExtraTeams
    if bTableOnly then
        return coroutine.wrap( function( )
            coroutine.yield( src )
        end )
    end
    return coroutine.wrap( function( )
        local sorting = not bSorted and pairs or SortedPairs
        for _, v in sorting( src ) do
            coroutine.yield( _, v )
        end
    end )
end

/*
    helper > get > shipements

    return list of all entries in rp gamemode shipments table

    @ex     : for k, v in helper.get.ships( ) do

    @param  : bool bTableOnly
    @param  : bool bSorted
    @return : key, value
*/

function helper.get.ships( bTableOnly, bSorted )
    if not istable( CustomShipments ) then return { } end
    local src = CustomShipments
    if bTableOnly then
        return coroutine.wrap( function( )
            coroutine.yield( src )
        end )
    end
    return coroutine.wrap( function( )
        local sorting = not bSorted and pairs or SortedPairs
        for _, v in sorting( src ) do
            coroutine.yield( _, v )
        end
    end )
end

/*
    helper > get > vehicles

    return list of all entries in rp gamemode vehicles table

    @ex     : for k, v in helper.get.veh( ) do

    @param  : bool bTableOnly
    @param  : bool bSorted
    @return : key, value
*/

function helper.get.veh( bTableOnly, bSorted )
    if not istable( CustomVehicles ) then return { } end
    local src = CustomVehicles
    if bTableOnly then
        return coroutine.wrap( function( )
            coroutine.yield( src )
        end )
    end
    return coroutine.wrap( function( )
        local sorting = not bSorted and pairs or SortedPairs
        for _, v in sorting( src ) do
            coroutine.yield( _, v )
        end
    end )
end

/*
    helper > get > food

    return list of all entries in rp gamemode food table

    @ex     : for k, v in helper.get.food( ) do

    @param  : bool bTableOnly
    @param  : bool bSorted
    @return : key, value
*/

function helper.get.food( bTableOnly, bSorted )
    if not istable( FoodItems ) then return { } end
    local src = FoodItems
    if bTableOnly then
        return coroutine.wrap( function( )
            coroutine.yield( src )
        end )
    end
    return coroutine.wrap( function( )
        local sorting = not bSorted and pairs or SortedPairs
        for _, v in sorting( src ) do
            coroutine.yield( _, v )
        end
    end )
end

/*
    helper > get > ents

    return list of all rp gamemode jobs
    returns key and value

    @ex     : for k, v in helper.get.rpents( ) do

    @param  : bool bTableOnly
    @param  : bool bSorted
    @return : key, value
*/

function helper.get.rpents( bTableOnly, bSorted )
    if not istable( DarkRPEntities ) then return { } end
    local src = DarkRPEntities
    if bTableOnly then
        return coroutine.wrap( function( )
            coroutine.yield( src )
        end )
    end
    return coroutine.wrap( function( )
        local sorting = not bSorted and pairs or SortedPairs
        for _, v in sorting( src ) do
            coroutine.yield( _, v )
        end
    end )
end

/*
    helper > get > entities

    return list of all ents

    @ex     : for v in helper.get.ents( ) do

    @param  : bool, str bSorted
    @return : value
*/

function helper.get.ents( bKey, sorted )
    return coroutine.wrap( function( )
        local sorting = ( not sorted and pairs ) or ( isfunction( sorted ) and sorted ) or ( isbool( sorted ) == true and SortedPairs )
        for _, v in sorting( ents.GetAll( ) ) do
            if not IsValid( v ) then continue end
            if bKey then
                coroutine.yield( _, v )
            else
                coroutine.yield( v )
            end
        end
    end )
end

/*
    helper > get > players nearby

    return list of all players near a specified player

    @since  : v3.0.0
    @param  : ply pl
    @param  : int dist
    @return : tbl
*/

function helper.get.playersNearby( pl, dist )

    if not pl then return end
    dist = isnumber( dist ) and dist or 300

    local tab = { }
    for ply in helper.get.players( ) do
        if ( ply:GetPos( ):Distance( pl:GetPos( ) ) > dist ) then continue end

        local tr = util.TraceLine(
        {
            start   = pl:GetShootPos( ),
            endpos  = ply:GetShootPos( ),
            filter  = { ply, pl }
        })

        if ( tr.HitWorld ) then continue end

        tab[ #tab + 1 ] = ply
    end

    return tab
end

/*
    helper > get > data

    return list of all items in table

    @ex     : for v in helper.get.data( table_name ) do

    @param  : tbl tbl
    @param  : bool, str sorted
    @return : value
*/

function helper.get.data( tbl, sorted )
    if not istable( tbl ) then return end
    return coroutine.wrap( function( )
        local sorting = ( not sorted and pairs ) or ( isfunction( sorted ) and sorted ) or ( isbool( sorted ) == true and SortedPairs )
        for _, v in sorting( tbl ) do
            coroutine.yield( v )
        end
    end )
end

/*
    helper > get > table

    return list of all items in table
    similar to helper.get.data except returns
    key and value in table

    @ex     : for k, v in helper.get.data( table_name ) do

    @param  : tbl tbl
    @param  : bool, str sorted
    @return : key, val
*/

function helper.get.table( tbl, sorted )
    if not istable( tbl ) then return end
    return coroutine.wrap( function( )
        local sorting = ( not sorted and pairs ) or ( isfunction( sorted ) and sorted ) or ( isbool( sorted ) == true and SortedPairs )
        for _, v in sorting( tbl ) do
            coroutine.yield( _, v )
        end
    end )
end

/*
    helper > get > sorted

    much like helper.get.data but more specific to your needs

    @param  : tbl tbl
    @param  : int itype
            : type 1    : pairs
            : type 2    : ipairs
            : type 3    : SortedPairs
            : type 4    : SortedPairsByMemberValue
            : type 5    : SortedPairsByValue
    @param  : bool, str val
*/

function helper.get.sorted( tbl, itype, val, val2 )
    if not istable( tbl ) then return end
    return coroutine.wrap( function( )
        local sorting = ( itype == 1 and pairs ) or ( itype == 2 and ipairs ) or ( itype == 3 and SortedPairs ) or ( itype == 4 and SortedPairsByMemberValue ) or ( itype == 5 and SortedPairsByValue ) or pairs
        for _, v in sorting( tbl, val, val2 or false ) do
            coroutine.yield( v )
        end
    end )
end

/*
    helper > get > sorted

    much like helper.get.data but more specific to your needs

    @param  : tbl tbl
    @param  : int itype
            : type 1    : pairs
            : type 2    : ipairs
            : type 3    : SortedPairs
            : type 4    : SortedPairsByMemberValue
            : type 5    : SortedPairsByValue
    @param  : bool, str val
*/

function helper.get.sorted_k( tbl, itype, val, val2 )
    if not istable( tbl ) then return end
    return coroutine.wrap( function( )
        local sorting = ( itype == 1 and pairs ) or ( itype == 2 and ipairs ) or ( itype == 3 and SortedPairs ) or ( itype == 4 and SortedPairsByMemberValue ) or ( itype == 5 and SortedPairsByValue ) or pairs
        for _, v in sorting( tbl, val, val2 or false ) do
            coroutine.yield( _, v )
        end
    end )
end

/*
    helper > get > avg player ping

    for diagnostic purposes

    records the ping of all players on the server and then divides the number by the total number of
    players on the server.

    :   ( bool ) bSortHighest
        instead of fetching the average, the highest ping of all players will return

    @param  : bool bSortHighest
    @return : int
*/

function helper.get.avgping( bSortHighest )
    return coroutine.wrap( function( )
        local calc_ping = 0
        for _, v in pairs( player.GetAll( ) ) do
            if bSortHighest then
                if v:Ping( ) > calc_ping then calc_ping = v:Ping( ) end
                continue
            end
            calc_ping = calc_ping + v:Ping( )
        end
        if not bSortHighest then
            calc_ping = math.Round( calc_ping / #player.GetHumans( ) )
        end
        coroutine.yield( calc_ping )
    end )
end

/*
    helper > get > shuffle

    shuffles items in a table

    @param  : tbl tbl
    @return : tbl
*/

function helper.get.shuffle( tbl )
    if not istable( tbl ) then return end
    return coroutine.wrap( function( )
        size = #tbl
        for i = size, 1, -1 do
            local rand = math.random( size )
            tbl[ i ], tbl[ rand ] = tbl[ rand ], tbl[ i ]
        end
        coroutine.yield( tbl )
    end )
end

/*
    helper > get > groupmatch

    returns if a pl usergroup matches tbl

    @param  : tbl tbl
    @param  : ply pl
    @return : bool
*/

function helper.get.groupmatch( tbl, pl )
    for v in helper.get.data( tbl ) do
        if v == pl:getgroup( true ) then
            return true
        end
    end
    return false
end

/*
    helper > get > datetime now

    @call   : helper.get.now( )
            : helper.get.now( '%Y-%m-%d' )

    @param  : str flags
    @return : str
*/

function helper.get.now( flags )
    return flags and os.date( flags ) or os.date( '%Y-%m-%d %H:%M:%S' )
end

/*
    helper > get > increment

    @call   : helper.get.increment( var )
              returns var + 1

            : helper.get.i( var, 2 )
              returns var + 2

    @param  : int i
    @param  : int add
    @return : int
*/

function helper.get.increment( i, add )
    i       = isnumber( i ) and i or tonumber( i ) or i
    add     = isnumber( add ) and add or 1
    i       = i + add

    return i
end
helper.get.i = helper.get.increment

/*
    helper > get > has population

    @call   : helper.get.haspop( )

    @return : bool
*/

function helper.get.haspop( )
    return #player.GetHumans( ) > 0 and true or false
end

/*
    helper > get > population

    @call   : helper.get.popcount( )

    @return : int
*/

function helper.get.popcount( )
    return #player.GetAll( ) or 0
end

/*
    helper > get > id

    makes a new id based on the specified varargs
    all special characters and spaces are replaced with [ . ] char

    @note   : ply associated func pmeta:cid( ... )

    @ex     : timer_id = helper.get.id( 'timer', 'frostshell'  )
    @res    : timer.frostshell

    @param  : varg { ... }
*/

function helper.get.id( ... )
    local args          = { ... }
    local resp          = table.concat( args, '_' )
    resp                = resp:lower( )
    resp                = resp:gsub( '[%p%c]', '.' )
    resp                = resp:gsub( '[%s]', '_' )

    return resp
end

/*
    helper > get > utf8 icons

    returns the proper utf8 icon for the str provided

    @param  : str id
*/

function helper.get:utf8( id )
    id = isstring( id ) and id or 'default'
    local val = base._def.utf8[ id ]

    return utf8.char( val )
end

/*
    helper > get > utf8 > char

    converts int to utf8 char

    @param  : str id
*/

function helper.get:utf8char( id )
    id = isnumber( id ) and id or tonumber( id )

    return utf8.char( id )
end

/*
    helper > get > key

    converts keybind ENUM to STR

    @param  : enum enum
*/

function helper.get.key( enum )
    return base._def.keybinds[ enum ]
end

/*
    helper > get > keypress

    executes a function based on the single / combo keybind
    pressed by player

    @param  : enum k1
    @param  : enum k2
    @param  : func fn
*/

function helper.get.keypress( k1, k2, fn )
    if not isfunction( fn ) then return end
    if ( isnumber( k1 ) and k1 ~= 0 ) then
        if ( input.IsKeyDown( k1 ) and input.IsKeyDown( k2 ) ) then
            fn( )
        end
    else
        if ( k2 and input.IsKeyDown( k2 ) ) then
            fn( )
        end
    end
end

/*
    helper > get > item name

    figures out a weapon / ent name
    because people use so many various structures; this attempts
    to check all variables

    @param  : ent obj
    @return : bool
*/

function helper.get.item_name( obj )
    return isfunction( obj.GetPrintName ) and obj:GetPrintName( ) or ( obj.Primary and obj.Primary.Name ) or obj.Name or obj.PrintName or obj.Print or obj.Display or obj.DisplayName or obj.Title or 'Untitled'
end

/*
    helper > get > item model

    figures out a weapon / ent mdl
    because people use so many various structures; this attempts
    to check all variables

    @param  : ent obj
    @return : bool
*/

function helper.get.item_mdl( obj )
    return obj.WorldModel or obj.ViewModel or obj.Model or 'error.mdl'
end

/*
    helper > ply > usergroup

    gets a players usergroup

    @param  : ply pl
    @param  : bool bLowercase
    @return : str
*/

function helper.ply.ugroup( pl, bLowercase )
    if not IsValid( pl ) or not pl:IsPlayer( ) then return end
    return bLowercase and helper.str:clean( pl:GetUserGroup( ) ) or pl:GetUserGroup( )
end

/*
    helper > ply > alias

    gets a players alias
    alt version of pmeta:palias( )

    @param  : ply pl
    @param  : str override
    @return : str
*/

function helper.ply.alias( pl, override )
    if not IsValid( pl ) or not pl:IsPlayer( ) then return end
    return pl:palias( override )
end

/*
    return counted items

    second param determines how many to add to increment value
    typically this will just be 1 ( +1 ) per result found

    @usage  : local i = helper.countdata( cfg.table, 'tablerow' )( )
            : local i = helper.countdata( v, 1 )( )

    @param  : tbl tbl
    @param  : int i
    @param  : str target
    @param  : str check
*/

function helper.countdata( tbl, i, target, check )
    if not istable( tbl ) then return end
    i = isnumber( i ) and i or 1
    return coroutine.wrap( function( )
        local cnt = 0
        for _, v in pairs( tbl ) do
            if check and not v[ check ] then continue end
            if target and v[ target ] then
                cnt = cnt + v[ target ] + i
            else
                cnt = cnt + i
            end
        end
        coroutine.yield( cnt )
    end )
end
helper.countData = helper.countdata

/*
    helper > emts > count

    second param determines how many to add to increment value
    typically this will just be 1 ( +1 ) per result found

    @usage  : local i = helper.ent.count( 'ent_name' )( )
            : local i = helper.ent.count( 'ent_name', 1 )( )

    @param  : tbl tbl
    @param  : int i
*/

function helper.ent.count( ent, i )
    if not ent then return end
    i = isnumber( i ) and i or 1
    return coroutine.wrap( function( )
        local cnt = 0
        for v in helper.get.data( ents.FindByClass( ent ) ) do
            cnt = cnt + i
        end
        coroutine.yield( cnt )
    end )
end

/*
    helper > ents > find

    returns list of ents by class

    @ex     : for v in helper.ent.find( 'class_id' ) do
            : for k, v in helper.ent.find( 'class_id', true ) do

    @param  : str ent
    @param  : bool bKey
    @return : value
*/

function helper.ent.find( ent, bKey )
    return coroutine.wrap( function( )
        if isstring( ent ) then
            for _, v in pairs( ents.FindByClass( ent ) ) do
                if not helper.ok.ent( v ) then continue end
                if bKey then
                    coroutine.yield( _, v )
                else
                    coroutine.yield( v )
                end
            end
        elseif istable( ent ) then
            for a, b in pairs( ent ) do
                for _, v in pairs( ents.FindByClass( b ) ) do
                    if not helper.ok.ent( v ) then continue end
                    if bKey then
                        coroutine.yield( _, v )
                    else
                        coroutine.yield( v )
                    end
                end
            end
        end
    end )
end

/*
    helper > ents > pos

    returns pos, angle of item in human readable format

    @param  : ent, vec p
    @param  : ang a
    @return : str
*/

function helper.ent.pos( p, a )

    local pos               = ( helper.ok.ent( p ) and p:GetPos( ) ) or isvector( p ) and p or Vector( 0, 0, 0 )
    local ang               = ( helper.ok.ent( p ) and p:GetAngles( ) ) or isangle( a ) and a or Angle( 0, 0, 0 )

    local pos_x             = math.floor( pos[ 1 ] )
    local pos_y             = math.floor( pos[ 2 ] )
    local pos_z             = math.floor( pos[ 3 ] )

    local ang_x             = math.floor( ang[ 1 ] )
    local ang_y             = math.floor( ang[ 2 ] )
    local ang_z             = math.floor( ang[ 3 ] )

    local pos_str           = string.format( '%i, %i, %i', pos_x, pos_y, pos_z )
    local ang_str           = string.format( '%i, %i, %i', ang_x, ang_y, ang_z )

    return pos_str, ang_str

end

/*
    packages > register

    library includes numerous packages which will be registered and stored in their own table
    packages include timex, rnet, and calc

    package manifests stored in rlib.package.index

    @param  : tbl pkg
*/

function base.package:Register( pkg )
    if not istable( pkg ) then return end
    if not istable( pkg.__manifest ) then
        base:log( 2, 'skipping package registration for [ %s ] » missing manifest', pkg._NAME )
        return
    end

    local id = tostring( pkg._NAME )

    self.index = self.index or { }
    self.index[ id ] =
    {
        name    = pkg._NAME,
        desc    = pkg.__manifest.desc,
        author  = pkg.__manifest.author,
        build   = pkg.__manifest.build,
        version = pkg.__manifest.version,
    }
end

/*
    packages > installed

    checks to see if a module is indeed available to use

    @ex     :   rlib.package:bInstalled( 'glon', mod )
                rlib.package:bInstalled( 'rnet', 'module' )

    @param  : str name
    @param  : tbl, str requester
    @return : bool
*/

function base.package:bInstalled( name, requester )
    if not name then return end
    name = isstring( name ) and name or tostring( name )

    local id = requester or script

    if ( isstring( requester ) and istable( rcore ) and rcore.modules[ requester ] and rcore.modules[ requester ].enabled ) then
        id = rcore.modules[ requester ].name
    elseif ( istable( requester ) and requester.enabled ) then
        id = requester.name
    elseif ( istable( requester ) and not requester.name ) then
        id = script
    end

    if package.loaded[ name ] then return true end

    for _, v in ipairs( package.searchers or package.loaders ) do
        local loader = v( name )
        if isfunction( loader ) then
            package.preload[ name ] = loader
            return true
        end
    end

    base:log( 6, 'missing module [ %s ] » required for [ %s ]', name, id )

    return false
end

/*
    calls > register
*/

function base.calls:register( parent, src )
    if not parent.manifest.calls or not istable( parent.manifest.calls ) then
        base:log( RLIB_LOG_ERR, ln( 'calls_tbl_missing_def' ) )
        return
    end

    if not src or not istable( src ) then
        base:log( RLIB_LOG_ERR, ln( 'calls_tbl_invalid' ) )
        return
    end

    for _, v in pairs( parent.manifest.calls ) do

        /*
            v returns call_type
        */

        local call_type = v:lower( )
        if not src[ call_type ] then
            src[ call_type ] = { }
        end

        /*
            build calls lib

            loop calls and setup structure
            : l        =   call_id
            : m[ 1 ]   =   call.id
            : m[ 2 ]   =   desc (optional)

            structure ex
                commands:
                rlib_command:
                    1   : rlib.command
                    2   : no description
        */

        for l, m in pairs( src[ call_type ] ) do
            base._rcalls[ call_type ] = base._rcalls[ call_type ] or { }
            if call_type ~= 'commands' then
                base._rcalls[ call_type ][ l ]  = { tostring( m[ 1 ] ), m[ 2 ] and tostring( m[ 2 ] ) or ln( 'cmd_no_desc' ) }
            else
                base._rcalls[ call_type ][ l ]  = m
            end
            sys.calls = ( sys.calls or 0 ) + 1
        end

    end
end

/*
    calls > load
*/

function base.calls:load( bPrefix, affix )
    base:log( RLIB_LOG_DEBUG, ln( 'calls_register_nlib' ) )

    rhook.run.rlib( 'rlib_calls_pre' )

    if not base._rcalls[ 'net' ] then
        base._rcalls[ 'net' ] = { }
        base:log( RLIB_LOG_DEBUG, ln( 'calls_register_tbl' ) )
    end

    if SERVER then
        self:Catalog( )
    end

    rhook.run.rlib( 'rlib_calls_post' )
end

/*
    calls > validation
*/

function base.calls:valid( t )
    if not t or not isstring( t ) or t == '' then
        base:log( 2, ln( 'calls_type_missing_spec' ) )
        local response, cnt_calls, i = '', table.Count( #base._rcalls ), 0
        for k, v in pairs( base._rcalls ) do
            response = response .. k
            i = i + 1
            if i < cnt_calls then
                response = response .. ', '
            end
        end
        base:log( 2, ln( 'calls_type_valid', response ) )
        return
    end

    local data = base._rcalls[ t ]
    if not data then
        base:log( 2, ln( 'calls_type_missing', t ) )
        return
    end

    return data or false
end

/*
    calls > gcflag
*/

function base.calls:gcflag( cmd, flg_id, ret )
    local data          = self:valid( 'commands' )
                        if not data then return end

    if ( cmd and data[ cmd ] and data[ cmd ].flags and flg_id and data[ cmd ].flags[ flg_id ] ) then
        local item = data[ cmd ].flags[ flg_id ]
        if not ret then
            return item.flag
        else
            return item.flag, item.desc
        end
    else
        return data
    end

    return false
end

/*
    calls > gcflag > valid
*/

function base.calls:gcflag_valid( cmd, flag )
    local data          = self:valid( 'commands' )
                        if not data or not cmd or not flag then return end

    cmd                 = cmd:gsub( '[.]', '_' )

    if ( cmd and data[ cmd ] and data[ cmd ].flags ) then
        for key, value in pairs( data[ cmd ].flags ) do
            if not string.match( value.flag, flag ) then continue end
            return true
        end
    end
    return false
end

/*
    calls > gcflag > match
*/

function base.calls:gcflagMatch( cmd, arg )
    if istable( cmd ) then
        return table.HasValue( cmd, arg )
    else
        return cmd:lower( ) == arg:lower( )
    end

    return false
end

/*
    calls > post load
*/

local function calls_load_post( )
    local get_basecmd  = false
    local has_basecmd  = false

    for k, v in pairs( rlib.calls:get( 'commands' ) ) do
        if not v.is_base then continue end
        if has_basecmd then continue end

        has_basecmd, get_basecmd = true, v.id
    end

    sys.calls_basecmd = has_basecmd and get_basecmd or false

    if not has_basecmd then
        base:log( RLIB_LOG_ERR, ln( 'calls_cmd_lib_missing', debug.getinfo( 1, 'n' ).name ) )
    else
        base:log( RLIB_LOG_DEBUG, ln( 'calls_cmd_lib_base' , get_basecmd ) )
    end
end
hook.Add( pid( 'calls_post' ), pid( 'calls_load_post' ), calls_load_post )

/*
    calls > get call
*/

function base.calls:get( t, s )
    local data      = self:valid( t )
                    if not data then return end

    if s and data[ s ] then
        local tbl           = data[ s ]
        tbl[ 'call' ]       = s -- insert the original command
        return tbl
    else
        return data
    end

    return
end

/*
    call
*/

function base:call( t, s, ... )
    local data      = base.calls:valid( t )
                    if not data then return end

    if not isstring( s ) then
        base:log( 2, ln( 'calls_id_missing' , t ) )
        return false
    end

    s = s:gsub( '[%p%c%s]', '_' ) -- replace punct, contrl chars, and whitespace with underscores

    if t == 'commands' then
        local ret = string.format( s, ... )
        if data[ s ] then
            local cmd = s
            if ( data[ s ][ 'id' ] and isstring( data[ s ][ 'id' ] ) ) then
                cmd = data[ s ][ 'id' ]
            elseif ( data[ s ][ 1 ] and isstring( data[ s ][ 1 ] ) ) then
                cmd = data[ s ][ 1 ]
            end
            ret = string.format( cmd, ... )
        end
        return ret
    else
        local ret = string.format( s, ... )
        if data[ s ] then
            ret = string.format( data[ s ][ 1 ], ... )
        end
        return ret
    end
end

/*
    calls > commands > register

    inserts a new command into base commands table which allows it to display within the base library
    concommand, as well as execution params

    this is an alternative method to registering commands that aren't provided through the module
    manifest method

    @ex     : rlib.calls.commands:Register( local_tbl_varname )

    @param  : tbl params
*/

function base.calls.commands:Register( params )
    if not istable( params ) then
        base:log( RLIB_LOG_ERR, ln( 'calls_reg_params_missing', debug.getinfo( 1, 'n' ).name ) )
        return
    end

    for k, v in pairs( params ) do
        if not isstring( k ) then
            base:log( RLIB_LOG_ERR, ln( 'calls_reg_cmd_id_missing', debug.getinfo( 1, 'n' ).name ) )
            continue
        end

        base.c.commands[ k ]            = v
        base._rcalls[ 'commands' ][ k ] = v

        sys.calls = ( sys.calls or 0 ) + 1

        base:log( RLIB_LOG_DEBUG, ln( 'calls_cmd_added', k ) )
    end
end

function access:ulx_getgroup( ugroup )
    local groups =
    {
        [ 'superadmin' ]    = ULib.ACCESS_SUPERADMIN,
        [ 'admin' ]         = ULib.ACCESS_ADMIN,
        [ 'operator' ]      = ULib.ACCESS_OPERATOR,
        [ 'moderator' ]     = ULib.ACCESS_OPERATOR,
        [ 'all' ]           = ULib.ACCESS_ALL,
        [ 'user' ]          = ULib.ACCESS_ALL
    }

    return ( ugroup and groups[ ugroup ] ) or groups[ 'superadmin' ]
end

/*
    access > get perm
*/

function access:getperm( perm, mod )
    if not isstring( perm ) or not rcore then return end
    if ( mod == mf.name and base.permissions[ perm ] ) or ( not mod and base.permissions[ perm ] ) then
        return base.permissions[ perm ]
    end
    return not mod and perm or ( isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].permissions[ perm ] ) or ( istable( mod ) and mod.permissions[ perm ] )
end
access.gperm = access.getperm

/*
    access > get perm > id
*/

function access:gid( perm, mod )
    if not isstring( perm ) or not rcore then return end
    if ( mod == mf.name and base.permissions[ perm ] ) or ( not mod and base.permissions[ perm ] ) then
        return base.permissions[ perm ]
    end

    local permission = not mod and perm or ( isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].permissions[ perm ] ) or ( istable( mod ) and mod.permissions[ perm ] )
    return ( permission and ( permission.name or permission.id ) or perm )
end

/*
    access > seek
*/

function access:seek( perm )
    if istable( perm ) and perm.id then
        perm = perm.id
    end

    local bFound, perms, mod = false, { }, false
    for k, v in pairs( base.modules:list( ) ) do
        if bFound then continue end
        if not v.permissions then continue end

        if v.permissions[ perm ] then
            bFound  = true
            perms   = v.permissions[ perm ]
            mod     = v.id
        end
    end

    return perms, mod
end

/*
    access > get arg
*/

function access:arg( perm )
    if istable( perm ) and perm.args then
        return perm.args
    end

    return access:seek( perm ) and access:seek( perm ).args or { }
end

/*
    access > ulx
*/

function access:ulx( perm, mod )
    if not mod then
        perm, mod = self:seek( perm )
    end

    if not isstring( perm ) and perm.id then
        perm = perm.id
    end

    if not isstring( perm ) then
        base:log( RLIB_LOG_ERR, 'cannot get ulx rank from invalid permission. defaulting to superadmin access for security' )
        return 'superadmin'
    end

    return self:ulx_getgroup( self:getperm( perm, mod ).access or self:getperm( perm, mod ).usrlvl )
end

/*
    access > has perm
*/

function access:hasperm( pl, perm, bThrowErr )
    perm = isstring( perm ) and perm or 'rlib_root'
    if not access:validate( pl, perm ) then
        local str_perm = perm and tostring( perm ) or ln( 'action_requested' )
        base.msg:route( pl, false, script, ln( 'perms_invalid' ), cfg.cmsg.clrs.target, str_perm )
        return false
    end
    return true
end

/*
    access > deny_permission
*/

function access:deny_permission( pl, mod, perm )
    mod = istable( mod ) and mod.name or isstring( mod ) and mod
    local str_perm = perm and tostring( perm ) or ln( 'action_requested' )
    base.msg:route( pl, false, mod, ln( 'perms_invalid' ), cfg.cmsg.clrs.target, str_perm )
    return false
end

/*
    access > deny_consoleonly
*/

function access:deny_consoleonly( pl, mod, perm )
    mod = istable( mod ) and isstring( mod.name ) and mod.name or isstring( mod ) and mod or tostring( mod )
    local str_perm = perm and tostring( perm ) or ln( 'action_requested' )
    base.msg:route( pl, false, mod, 'command', cfg.cmsg.clrs.target, str_perm, cfg.cmsg.clrs.msg, 'must be executed', cfg.cmsg.clrs.target_sec, 'server-side only' )
    return false
end

/*
    access > deny_console
*/

function access:deny_console( pl, mod, perm )
    mod = istable( mod ) and isstring( mod.name ) and mod.name or isstring( mod ) and mod or tostring( mod )
    local str_perm = perm and tostring( perm ) or ln( 'action_requested' )
    base.msg:route( pl, false, mod, 'command ', cfg.cmsg.clrs.target, str_perm, cfg.cmsg.clrs.msg, 'must be called by valid player and not by', cfg.cmsg.clrs.target_sec, 'console' )
    return false
end

/*
    access > is console
*/

function access:bIsConsole( pl )
    if not pl then return false end
    return isentity( pl ) and pl:EntIndex( ) == 0 and true or false
end

/*
    access > is owner
*/

function access:bIsOwner( pl )
    if not helper.ok.ply( pl ) then return false end

    local owners = base.get:owners( ) or { }
    if table.HasValue( owners, pl:SteamID64( ) ) then return true end

    return false
end

/*
    access > is root
*/

function access:bIsRoot( pl, bNoConsole )
    if ( not bNoConsole and access:bIsConsole( pl ) ) or ( helper.ok.ply( pl ) and ( access:bIsOwner( pl ) or access:bIsDev( pl ) or access:bIsSAdmin( pl ) ) ) then
        return true
    end
    return false
end

/*
    access > is developer
*/

function access:bIsDev( pl )
    if access:bIsConsole( pl ) then return true end

    if not mf.developers then return end
    local devs = mf.developers or { }
    if table.HasValue( devs, pl:SteamID64( ) ) then return true end

    return false
end

/*
    access > is superadmin
*/

function access:bIsSAdmin( pl )
    if access:bIsConsole( pl ) then return true end
    if helper.ok.ply( pl ) and pl:IsSuperAdmin( ) then return true end
    return false
end

/*
    access > is admin
*/

function access:bIsAdmin( pl )
    if access:bIsConsole( pl ) then return true end

    if not access.admins then return false end
    if not helper.ok.ply( pl ) then return false end
    local pl_sid = pl:SteamID( )

    if access.admins[ pl_sid ] then return true end

    return false
end

/*
    access > validate
*/

function access:validate( pl, perm )
    if not IsValid( pl ) then
        if access:bIsConsole( pl ) then return true end
        return false
    end

    if not helper.ok.ply( pl ) then return false end
    if pl:IsSuperAdmin( ) then return true end
    if self:bIsRoot( pl ) then return true end

    if not isstring( perm ) and not istable( perm ) then return false end

    if ulx then
        -- Work around for ulib.authed issue
        local unique_id = pl:UniqueID( )
        if CLIENT and game.SinglePlayer( ) then unique_id = '1' end

        perm = ( istable( perm ) and perm.id ) or perm
        if not ULib or not ULib.ucl.authed[ unique_id ] then return end
        if ULib.ucl.query( pl, perm ) then return true end
    elseif maestro then
        perm = ( istable( perm ) and perm.id ) or perm
        if maestro.rankget( maestro.userrank( pl ) ).flags[ perm ] then return true end
    elseif evolve then
        perm = ( istable( perm ) and perm.id ) or perm
        if pl:EV_HasPrivilege( perm ) then return true end
    elseif serverguard then
        perm = ( istable( perm ) and ( ( isstring( perm.svg_id ) and perm.svg_id ) or perm.id ) ) or perm
        if serverguard.player:HasPermission( pl, perm ) then return true end
    elseif SAM_LOADED and sam then
        perm = ( istable( perm ) and ( ( isstring( perm.sam_id ) and perm.sam_id ) or perm.id ) ) or perm
        if pl:HasPermission( perm ) then return true end
    end

    return false
end

/*
    access > allow
*/

function access:allow( pl, perm, mod )
    if not IsValid( pl ) then
        if access:bIsConsole( pl ) then return true end
        return false
    end

    if not helper.ok.ply( pl ) then return false end
    if pl:IsSuperAdmin( ) then return true end
    if self:bIsRoot( pl ) then return true end
    if not isstring( perm ) then return false end

    if mod then
        perm = self:getperm( perm, mod )
    end

    if ulx then
        -- Work around for ulib.authed issue
        local unique_id = pl:UniqueID( )
        if CLIENT and game.SinglePlayer( ) then unique_id = '1' end

        perm = ( istable( perm ) and perm.id ) or perm
        if not ULib or not ULib.ucl.authed[ unique_id ] then return end
        if ULib.ucl.query( pl, perm ) then return true end
    elseif maestro then
        perm = ( istable( perm ) and perm.id ) or perm
        if maestro.rankget( maestro.userrank( pl ) ).flags[ perm ] then return true end
    elseif evolve then
        perm = ( istable( perm ) and perm.id ) or perm
        if pl:EV_HasPrivilege( perm ) then return true end
    elseif serverguard then
        perm = ( istable( perm ) and ( ( isstring( perm.svg_id ) and perm.svg_id ) or perm.id ) ) or perm
        if serverguard.player:HasPermission( pl, perm ) then return true end
    elseif SAM_LOADED and sam then
        perm = ( istable( perm ) and ( ( isstring( perm.sam_id ) and perm.sam_id ) or perm.id ) ) or perm
        if pl:HasPermission( perm ) then return true end
    end

    return false
end

/*
    access > strict
*/

function access:strict( pl, perm, mod )
    if not IsValid( pl ) then
        if access:bIsConsole( pl ) then return true end
        return false
    end

    if not helper.ok.ply( pl ) then return false end
    if pl:IsSuperAdmin( ) then return true end

    if not isstring( perm ) then
        perm = 'rlib_root'
    end

    if mod then
        perm = self:getperm( perm, mod )
    end

    if ulx then
        -- Work around for ulib.authed issue
        local unique_id = pl:UniqueID( )
        if CLIENT and game.SinglePlayer( ) then unique_id = '1' end

        perm = ( istable( perm ) and perm.id ) or perm
        if not ULib or not ULib.ucl.authed[ unique_id ] then return end
        if ULib.ucl.query( pl, perm ) then return true end
    elseif maestro then
        perm = ( istable( perm ) and perm.id ) or perm
        if maestro.rankget( maestro.userrank( pl ) ).flags[ perm ] then return true end
    elseif evolve then
        perm = ( istable( perm ) and perm.id ) or perm
        if pl:EV_HasPrivilege( perm ) then return true end
    elseif serverguard then
        perm = ( istable( perm ) and ( ( isstring( perm.svg_id ) and perm.svg_id ) or perm.id ) ) or perm
        if serverguard.player:HasPermission( pl, perm ) then return true end
    elseif SAM_LOADED and sam then
        perm = ( istable( perm ) and ( ( isstring( perm.sam_id ) and perm.sam_id ) or perm.id ) ) or perm
        if pl:HasPermission( perm ) then return true end
    end

    return false
end

/*
    access > allow > throwExcept
*/

function access:allow_throwExcept( pl, perm, mod, msg )
    perm        = isstring( perm ) and perm or 'rlib_root'
    local bChk  = self:allow( pl, perm, mod )
    if not bChk then
        msg = isstring( msg ) and msg or 'You lack permission to'
        base.msg:route( pl, ( mod and mod.name ) or mf.name, msg, cfg.cmsg.clrs.target_tri, tostring( perm ) )
        return false
    end

    return true
end

/*
    access > strict > throwExcept
*/

function access:strict_throwExcept( pl, perm, mod, msg )
    local bChk = self:strict( pl, perm, mod )
    if not bChk then
        msg = isstring( msg ) and msg or 'You lack permission to'
        base.msg:target( pl, ( mod and mod.name ) or mf.name, msg, cfg.cmsg.clrs.target_tri, tostring( perm ) )
        return false
    end

    return true
end

/*
    helper > str > split
*/

function helper.str:split( str, pattern, res )
    if not res then
        res = { }
    end

    local start                     = 1
    local split_start, split_end    = string.find( str, pattern, start )

    while split_start do
        table.insert                ( res, string.sub( str, start, split_start - 1 ) )
        start                       = split_end + 1
        split_start, split_end      = string.find( str, pattern, start )
    end

    table.insert( res, string.sub( str, start ) )

    return res
end

/*
    helper > str > split address:port
*/

function helper.str:split_addr( val )
    if not val then return false end
    return unpack( string.Split( val, ':' ) )
end

/*
    helper > mew > id
*/

function helper.new.id( len )
    len = isnumber( len ) and len or tonumber( len ) or 10

    local charset =
    {
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
        'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
        'u', 'v', 'w', 'x', 'y', 'z'
    }

    local resp = ''
    for i = 1, len do
        local index = math.random( 1, #charset )
        resp = resp .. charset[ index ]
    end

    return resp
end

/*
    helper > new > uid
*/

function helper.new.uid( len )
    len = isnumber( len ) and len or 8
    math.randomseed( os.time( ) )
    local resp = ''

    for i = 1, len do
        resp = resp .. string.char( math.random( 65, 90 ) )
    end

    return resp
end

/*
    helper > new > hash
*/

function helper.new.hash( len, seed )
    len     = isnumber( len ) and len or tonumber( len ) or 10
    seed    = isnumber( seed ) and seed or os.time( )

    local charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'

    math.randomseed( seed )

    local chars = { }
    for v in charset:gmatch( '.' ) do
        table.insert( chars, v )
    end

    local resp = ''
    for i = 1, len do
        local index     = math.random( 1, #chars )
        resp            = resp .. chars[ index ]
    end

    return resp
end

/*
    helper > str > uppercase first
*/

function helper.str:ucfirst( str )
    return str:gsub( '^%l', string.upper )
end

/*
    helper > str > clean
*/

function helper.str:clean( str, bRemove )
    str = isstring( str ) and str or tostring( str )
    str = str:lower( )
    str = bRemove and str:gsub( '%s+', '' ) or str:gsub( '%s+', '_' )

    return str
end

/*
    helper > str > escape
*/

function helper.str:escape( str, bKeepCase )
    str = isstring( str ) and str or tostring( str )
    str = not bKeepCase and str:lower( ) or str
    str = str:gsub( '[%c%p]', '' )
    str = str:gsub( '[%s]', '_' )

    return str
end

/*
    helper > str > clean whitespace
*/

function helper.str:clean_ws( str )
    return str:match( '^%s*(.-)%s*$' ) -- fix '
end

/*
    helper > str > length

    returns w, h of str size

    @param  : str str
    @param  : str font
    @param  : int oset_w
    @param  : int oset_h
    @param  : int min
    @param  : int max
    @return : int, int
*/

function helper.str:len( str, font, oset_w, oset_h, min_x, max_x, min_y, max_y )
    if not str then return 0, 0 end

    str         = tostring( str )
    oset_w      = isnumber( oset_w ) and oset_w or 0
    oset_h      = isnumber( oset_h ) and oset_h or 0

    surface.SetFont( font )

    local x, y  = surface.GetTextSize( str )
    x           = x + oset_w
    y           = y + oset_h

    x           = ( isnumber( min_x ) and x < min_x and min_x ) or x
    x           = ( isnumber( max_x ) and x > max_x and max_x ) or x

    y           = ( isnumber( min_y ) and y < min_y and min_y ) or y
    y           = ( isnumber( max_y ) and y > max_y and max_y ) or y

    return x, y
end

/*
    helper > str : length ( width )

    returns width of text

    @param  : str str
    @param  : str font
    @param  : int oset_w
*/

function helper.str:lenW( str, font, oset_w )
    if not str then return 0, 0 end

    str         = tostring( str )
    oset_w      = isnumber( oset_w ) and oset_w or 0

    surface.SetFont( font )

    local x, y  = surface.GetTextSize( str )
    x           = x + oset_w

    return x
end

/*
    helper > str : length ( height )

    returns height of text

    @param  : str str
    @param  : str font
    @param  : int oset_h
*/

function helper.str:lenH( str, font, oset_h )
    if not str then return 0, 0 end

    str         = tostring( str )
    oset_h      = isnumber( oset_h ) and oset_h or 0

    surface.SetFont( font )

    local x, y  = surface.GetTextSize( str )
    y           = y + oset_h

    return y
end

/*
    helper > str > empty str

    checks for a valid string but also checks for blank or space chars

    @param  : str str
    @return : bool
*/

function helper.str:isempty( str )
    if not isstring( str ) then return false end

    local text = str:gsub( '%s', '' )
    if not isstring( text ) or text == '' or text == 'NULL' or text == NULL or tostring( text ) == 'nil' then return true end
    return false
end

/*
    helper > str > ok

    checks for a valid string but also checks for blank or space chars

    @note   : replaces str:isempty( ) in future release

    @param  : str str
    @return : bool
*/

function helper.str:ok( str )
    if not isstring( str ) then return false end

    local text = str:gsub( '%s', '' )
    if text == '*' then return false end
    if isstring( text ) and text ~= '' and text ~= 'NULL' and text ~= NULL then return true end

    return false
end

/*
    helper > str > starts with

    determines if a string starts with a particular word/char

    @param  : str str
    @param  : str starts
    @return : str
*/

function helper.str:startsw( str, starts )
    if not isstring( str ) or not isstring( starts ) then return end
    return string.sub( str, 1, string.len( starts ) ) == starts
end

/*
    helper > str > ends with

    determines if a string ends with a particular word/char

    @param  : str str
    @param  : str ends
    @return : bool
*/

function helper.str:endsw( str, ends )
    if not isstring( str ) and not isstring( ends ) then return end
    return ends == '' or string.sub( str, -string.len( ends ) ) == ends
end

/*
    helper > str > count spaces

    ensure string contains no special characters

    @call   : helper.str:count_spaces( 'random string msg' ) :: returns 2

    @param  : str str
    @return : int
*/

function helper.str:iSpaces( str )
    str         = tostring( str )
    local i     = 0
    for k in string.gmatch( str:Trim( ), '.' ) do
        if k ~= ' ' then continue end
        i = i + 1
    end

    return i
end

/*
    helper > str > leader

    used for evening out rows of data with a 'leader'
    counts the number of chars in a string and adds on series of leading chars until the str hits max so
    that all rows are even in width / char count.

    @swap   :   ( a, b )

            :   ( a )
                bool    : determines if a space should be added at the beginning of the orig str
                str     : char to use for leader ( def = period [ . ] )

            :   ( b )
                str     : char to use for leader ( def = period [ . ] )

    @usage  :   local item = helper.str:leader( 'string', 20, true )
                output  'string .............'

            :   local item = helper.str:leader( 'string', 20, '.' )
                output  'string..............'

            :   local item = helper.str:leader( 'string', 20, true, '|' )
                output  'string |||||||||||||'

    @out    :   example-text................
            :   second-item.................
            :   third.......................

    @param  : str str
    @param  : int max [optional]
    @param  : str, bool a [optional]
    Wparam  : str b [optional]
    @return : str
*/

function helper.str:leader( str, max, a, b )
    str             = tostring( str )
    max             = isnumber( max ) and max or tonumber( max ) or 20

    local bSpace    = isbool( a ) and true or false
    local leader    = isstring( b ) and b or isstring( a ) and a or '.'
    local sz_str    = str:len( )
    local sz_add    = max - sz_str
    sz_add          = tonumber( sz_add )
    str             = bSpace and str .. ' ' or str
    sz_add          = bSpace and ( sz_add - 1 ) or sz_add

    if sz_add < 1 then return str end

    for i = 1, sz_add do
        str = str .. leader
    end

    -- add blank space at end of str
    str = bSpace and str .. ' ' or str

    return str
end

/*
    helper > str > valididate

    simply ensures a str is cleaned up and not left blank

    @param  : str str
    @return : bool, str
*/

function helper.str:valid( str )
    if not isstring( str ) then return end

    str = string.Trim( str )
    if str ~= nil and str ~= '' then
        return true, str
    end

    return false, str
end

/*
    helper > str > truncate

    shortens the provided string down based on a length specified

    @call   : helper.str:truncate( 'this is a test string', 12 )
            : 'this is a te...'

    @param  : str str
    @param  : int limit [min: 5]
    @param  : str affix
    @return : str
*/

function helper.str:truncate( str, limit, affix )
    limit = limit or 9
    affix = affix or '...'

    if limit < 5 then limit = 5 end

    if str:len( ) > limit then
        str = string.sub( str, 1, limit - 3 ) .. affix
    else
        str = sf( '%9s' , str )
    end

    return string.TrimLeft( str, ' ' )
end

/*
    helper > str > simple strip

    performs a simple strip on a string with the given filter

    @param  : str str
    @param  : str chrs
    @return : str
*/

function helper.str:strip( str, chrs )
    return str:gsub( '[' .. chrs:gsub( '%W', '%%%1' ) .. ']', '' )
end

/*
    helper > str > wordwrap

    takes a string and splits them into smaller lines and converts the result to a table with each line
    being an entry

    @param  : str str
    @param  : int limit
    @return : str
*/

function helper.str:wordwrap( str, limit )
    if not isstring( str ) then return end
    limit = isnumber( limit ) and limit or 100

    local seg, pos  = '', 1
    local resp, c   = { }, 0
    str:gsub( '(%s*)()(%S+)()', function( space, st, word, tend )
        if tend - pos > limit then
            pos     = st
            table.insert( resp, seg )
            seg     = word
            c       = c + 1
        else
            seg = seg .. space .. word
        end
    end )

    if ( seg ~= '' ) then
        table.insert( resp, seg )
        c = c + 1
    end

    return resp, c
end

/*
    helper > str > wrap

    @param  : str str
    @param  : int limit
    @return : str
*/

function helper.str:wrap( text, font, pxWidth )
    local total = 0

    surface.SetFont(font)

    local spaceSize = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
            local char = string.sub(word, 1, 1)
            if char == "\n" or char == "\t" then
                total = 0
            end

            local wordlen = surface.GetTextSize(word)
            total = total + wordlen

            -- Wrap around when the max width is reached
            if wordlen >= pxWidth then -- Split the word if the word is too big
                local splitWord, splitPoint = charWrap(word, pxWidth - (total - wordlen))
                total = splitPoint
                return splitWord
            elseif total < pxWidth then
                return word
            end

            -- Split before the word
            if char == ' ' then
                total = wordlen - spaceSize
                return '\n' .. string.sub(word, 2)
            end

            total = wordlen
            return '\n' .. word
        end)

    return text
end

/*
    helper > str > split paths

    typically used to split module paths up

    @param  : str str
    @return : str
*/

function helper.str:splitpath( str )
    return str:match( '(.+)/(.+)' ) -- fix '
end

/*
    helper > str > explode

    breaks a string up based on the specified seperator

    @param  : str str
    @param  : str sep
    @param  : int limit
    @return : tbl
*/

function helper.str:explode( str, sep, limit )
    sep     = isstring( sep ) and sep or ' '
    limit   = isnumber( limit ) and limit or 0

    local pos, seg = 1, { }

    while true do
        local pos_new, pos_end = str:find( sep, pos )
        if pos_new ~= nil then
            table.insert( seg, str:sub( pos, pos_new - 1 ) )
            pos = pos_end + 1
        else
            table.insert( seg, str:sub( pos ) )
            break
        end

        if ( limit and limit ~= 0 and #seg >= limit ) then return seg end
    end
    return seg
end

/*
    helper > str > plural

    returns a str with a singular or plural suffix

    @ex     :   helper.str:plural( 'dog', 2 )
                returns 'dogs'

            :   helper.str:plural( 'dogs', 1 )
                returns 'dog'

    @param  : str str
    @param  : int amt
    @return : str
*/

function helper.str:plural( str, amt )
    amt = isnumber( amt ) and amt or 0
    return ( amt ~= 1 and str:sub( -1 ) ~= 's' and str .. 's' ) or ( amt == 1 and str:sub( -1 ) == 's' and str:sub( 1, -2 ) ) or str
end

/*
    helper > str > comma

    returns a str of numbers with comma seperation

    @ex     :   helper.str:comma( '234553' )
                returns 234, 553

            :   helper.str:comma( 500000 )
                returns 500, 000

    @param  : str, int val
    @return : str
*/

function helper.str:comma( val )
    local resp, k = tostring( val ), nil

    while true do
        resp, k = string.gsub( resp, '^(-?%d+)(%d%d%d)', '%1,%2' )
        if ( k == 0 ) then break end
    end

    return resp
end

/*
    helper > str > format money

    takes a number and formats it with a comma dnd currency symbol

    @ex     :   helper.str:money( '234553' )
                returns

            :   helper.str:money( 500000 )
                returns

    @param  : str, int val
    @return : str
*/

function helper.str:money( amt, sym )
    if not amt then amt = 0 end
    if not sym then sym = '$' end

    local symbol        = ( isstring( sym ) and sym ) or ( GAMEMODE.Config and GAMEMODE.Config.currency ) or ( BaseWars and BaseWars.LANG.CURRENCY ) or '$'
    local money         = self:comma( amt )
    money               = string.format( '%s%s', symbol, money )

    return money
end

/*
    helper > table > has id

    @note   : move to tbl.HasID

    determines if a table has a specific id registered.
    used for features such as nav menus, settings, etc.
*/

function helper.tbl:HasID( tbl, id )
    for k, v in helper.get.table( tbl ) do
        if id ~= v.id then continue end
        return true
    end
    return false
end

/*
    helper > table > remove by id

    @note   : move to tbl.RemoveByID

    removes a table row based on the id specified.
    used for features such as nav menus, settings, etc.
*/

function helper.tbl:RemoveByID( tbl, id )
    for k, v in helper.get.table( tbl ) do
        if id ~= v.id then continue end
        table.remove( tbl, k )
    end
    return false
end

/*
    helper > table > has value

    checks a table for a matching value in a specified field

    @param  : tbl tbl
    @param  : str field
    @param  : str val
    @return : bool, tbl
*/

function helper.tbl:HasValue( tbl, field, val )
    for k, v in helper.get.table( tbl ) do
        if istable( v ) then
            for a, b in helper.get.table( v ) do
                if a ~= field then continue end
                if b:lower( ) == val:lower( ) then return true, b end
            end
        elseif isstring( v ) then
            if k ~= field then continue end
            if v:lower( ) == val:lower( ) then return true, v end
        end
    end
end

/*
    helper > sortedkeys

    assigns a clientconvar based on the parameters specified.
    these convars will then be used later in order for the player to modify their settings on-the-fly.

    >  example
        for name, line in base.sortedkeys( table ) do
            table.insert( new_sorted_table, line )
        end

    @param  : tbl src
    @param  : func sortf
    @return : mixed
*/

function helper:sortedkeys( src, sortf )
    if not istable( src ) then
        base:log( 2, ln( 'sort_badtable' ) )
        return
    end

    local a = { }
    for n in pairs( src ) do
        table.insert( a, n )
    end
    table.sort( a, sortf )

    local i = 0
    local iter = function( )
        i = i + 1
        if a[ i ] == nil then
            return nil
        else
            return a[ i ], src[ a[ i ] ]
        end
    end
    return iter
end

/*
    helper > switch

    emulates a switch statement

    a = switch
    {
        [ 1 ] = function ( x ) print( x, 10 ) end,
        [ 2 ] = function ( x ) print( x, 20 ) end,
        default = function ( x ) print( x, 0 ) end,
    }

    a:case( 1 )
    a:case( 2 )

    @param  : tbl tbl
    @return : tbl
*/

function helper.switch( tbl )
    tbl.case = function( self, x )
        local f = self[ x ] or self.default
        if f then
            if isfunction( f ) then
                f( x, self )
            else
                error( ln( 'case_nofunc', tostring( x ) ) )
            end
        end
    end
    return tbl
end

/*
    helper > util > table is exact

    compares two tables and determines if both are identical

    @param  : tbl a
    @param  : tbl b
    @return : bool
*/

function helper.util:bTableExact( a, b )

    local function compare_table( t1, t2 )

        if t1 == t2 then return true end

        for k, v in pairs( t1 ) do
            if type( t1[ k ] ) ~= type( t2[ k ] ) then return false end

            if istable( t1[ k ] ) then
                if not compare_table( t1[ k ], t2[ k ] ) then return false end
            else
                if t1[ k ] ~= t2[ k ] then return false end
            end
        end

        for k, v in pairs( t2 ) do
            if type( t2[ k ] ) ~= type( t1[ k ] ) then return false end

            if istable( t2[ k ] ) then
                if not compare_table( t2[ k ], t1[ k ] ) then return false end
            else
                if t2[ k ] ~= t1[ k ] then return false end
            end
        end

        return true
    end

    if type( a ) ~= type( b ) then return false end

    if istable( a ) then
        return compare_table( a, b )
    else
        return ( a == b )
    end

end

/*
    helper > locate table entry

    matches a string with a table value

    @note   : move to tbl.HasVal

    @param  : tbl tbl
    @param  : str str
    @return : bool, str
*/

function helper:table_hasval( tbl, str )
    if not istable( tbl ) or not isstring( str ) then return end

    for item in string.gmatch( str, '(%a+)' ) do -- fix '
        if tbl[ item:lower( ) ] then
            return true, item
        end
    end
    return false
end

/*
    helper > clr clamp

    clamps a value to be within the boundaries of a color ( 0 - 255 )
    accepts color table or single int value

    @def    : white

    @param  : int val
    @return : int
*/

function helper:clr_clamp( val )
    if not val or ( not IsColor( val ) and not isnumber( val ) ) then
        return Color( 255, 255, 255, 255 )
    end
    if IsColor( val ) then
        local r = math.Clamp( math.Round( val.r ), 0, 255 )
        local g = math.Clamp( math.Round( val.g ), 0, 255 )
        local b = math.Clamp( math.Round( val.b ), 0, 255 )
        local a = math.Clamp( math.Round( val.a ), 0, 255 )

        return Color( r, g, b, a )
    else
        return math.Clamp( math.Round( val ), 0, 255 )
    end
end

/*
    helper > clr > lerp

    allows lerping colors
    utilize calc.ease.gen( ) for frac

    @src    : https://maurits.tv/data/garrysmod/wiki/wiki.garrysmod.com/index6395.html

    @param  : float from
    @param  : clr from
    @param  : clr to
    @return : clr
*/

function helper:clr_lerp( frac, from, to )
    local clr_a     = 255
    local col       = Color(
        Lerp( frac, from.r, to.r ),
        Lerp( frac, from.g, to.g ),
        Lerp( frac, from.b, to.b ),
        Lerp( frac, from.a or clr_a, to.a or clr_a )
    )

    return col
end

/*
    helper > value to bool

    converts a value to a bool

    @note   : pending deprecation

    @param  : mix val
    @return : bool
*/

function helper:val2bool( val )
    local opt = tostring( val )
    return helper.util:toggle( opt )
end

/*
    helper > bool to string

    converts a bool to a string

    @param  : bool bool
    @param  : str opt_t
    @param  : str opt_f
    @return : str
*/

function helper:bool2str( bool, opt_t, opt_f )
    local val_t     = isstring( opt_t ) and opt_t or 'true'
    local val_f     = isstring( opt_f ) and opt_f or 'false'
    return bool and val_t or val_f
end

/*
    helper > bool to int

    transforms an bool into int

    @param  : bool bool
    @param  : bool cstring [optional]
    @return : mix [ bool | str ]
*/

function helper:bool2int( bool )
    return bool and 1 or 0
end

/*
    helper > int to bool

    transforms an int to bool

    @param  : int int
    @return : bool
*/

function helper:int2bool( int )
    return int == 1 and true or false
end

/*
    helper > bool value

    checks to see if a provided value is strictly a bool type input

    @param  : str val
    @return : bool
*/

function helper:bIsBool( val )
    if not val then return end

    if ( isstring( val ) ) then
        if ( table.HasValue( options_yes, val ) or table.HasValue( options_no, val ) or table.HasValue( options_huh, val ) ) then
            return true
        end
    elseif ( isnumber( val ) ) then
        if ( val == 1 ) or ( val == 0 ) then
            return true
        end
    elseif ( isbool( val ) ) then
        if ( val == true ) or ( val == false ) then
            return true
        end
    end

    return false
end

/*
    helper > type to bool toggle

    allows user-input to toggle something using common words such as 'true', 'enable', 'on', etc
    with a boolean return.

    a function that solves human stupidity and their desire to always do what you tell them NOT to

    @param  : mix val
    @return : bool
*/

function helper.util:toggle( val )
    if ( isstring( val ) ) then
        if ( table.HasValue( options_yes, val ) ) then
            return true
        elseif ( table.HasValue( options_no, val ) ) then
            return false
        elseif ( table.HasValue( options_huh, val ) ) then
            base:log( 1, ln( 'convert_toggle_idiot' ) )
            return false
        else
            return false
        end
    elseif ( isnumber( val ) ) then
        if ( val == 1 ) then
            return true
        elseif ( val == 0 ) then
            return false
        end
    elseif ( isbool( val ) ) then
        if ( val == true ) then
            return true
        elseif ( val == false ) then
            return false
        end
    end

    return false
end

/*
    helper > util > human bool

    takes an int such as 1 and returns a human readable bool such as 'true' or 'false'

    @param  : mix val
    @param  : bool bOnOff
    @return : str
*/

function helper.util:humanbool( val, bOnOff )
    local b2s_true          = 'true'
    local b2s_false         = 'false'
    local b2h_true          = 'enabled'
    local b2h_false         = 'disabled'

    if istable( bOnOff ) then
        b2h_true, b2h_false = bOnOff[ 1 ], bOnOff[ 2 ]
    end

    if ( isstring( val ) ) then
        if ( table.HasValue( options_yes, val ) ) then
            return not bOnOff and b2s_true or b2h_true
        elseif ( table.HasValue( options_no, val ) ) then
            return not bOnOff and b2s_false or b2h_false
        elseif ( table.HasValue( options_huh, val ) ) then
            base:log( 1, ln( 'convert_toggle_idiot' ) )
            return not bOnOff and b2s_false or b2h_false
        else
            return not bOnOff and b2s_false or b2h_false
        end
    elseif ( isnumber( val ) ) then
        if ( val == 1 ) then
            return not bOnOff and b2s_true or b2h_true
        elseif ( val == 0 ) then
            return not bOnOff and b2s_false or b2h_false
        end
    elseif ( isbool( val ) ) then
        if ( val == true ) then
            return not bOnOff and b2s_true or b2h_true
        elseif ( val == false ) then
            return not bOnOff and b2s_false or b2h_false
        end
    end

    return not bOnOff and b2s_false or b2h_false
end

/*
    msg > simple

    sends a msg with no affixed formatting

    @param  : ply pl
    @param  : varg { ... }
*/

function base.msg:simple( pl, ... )
    local args = { ... }
    for k, v in pairs( args ) do
        if not isstring( v ) then continue end
        args[ k ] = v .. ' '
    end

    if CLIENT then
        chat.AddText( unpack( args ) )
    else
        if pl and pl ~= nil then
            if access:bIsConsole( pl ) then
                table.insert( args, '\n' )
                MsgC( unpack( args ) )
            else
                pl:umsg( unpack( args ) )
            end
        else
            base:broadcast( unpack( args ) )
        end
    end
end

/*
    msg > th

    posts think delay

    @param  : ply pl
    @param  : clr clr
    @param  : str cat
    @param  : int delay
    @param  : varg { ... }
*/

function base.msg:th( pl, clr, cat, delay, ... )
    local args  = { ... }
    clr         = IsColor( clr ) and clr or Color( 255, 255, 255 )
    timex.simple( delay, function( )
        base:console( pl, clr, unpack( args ) )
    end )
end

/*
    msg > structureize

    formats a msg in an acceptable structure to unpack when needed

    @param  : int scope
    @param  : str subcat [optional]
    @param  : varg { ... }
*/

function base.msg:struct( scope, subcat, ... )
    if not cfg or not cfg.cmsg then
        base:log( 2, ln( 'cmsg_missing' ) )
        return
    end

    local cmsg = cfg.cmsg

    scope = isnumber( scope ) and scope or 0
    local tag = cmsg.tag_private
    if scope == 1 then
        tag = cmsg.tag_server
    end

    local args = { ... }
    for k, v in pairs( args ) do
        if not isstring( v ) then continue end
        args[ k ] = v .. ' '
    end

    return cmsg.clrs.cat, '[' .. tag .. '] ', cmsg.clrs.subcat, subcat and '[' .. subcat .. '] ' or nil, cmsg.clrs.msg, unpack( args )
end

/*
    msg > server

    routes a message to each player as a server broadcast

    @deprecate  : use msg:target( )

    @param  : ply pl
    @param  : str subcat [optional]
    @param  : varg { ... }
*/

function base.msg:server( pl, subcat, ... )
    if not cfg or not cfg.cmsg then
        base:log( 2, ln( 'cmsg_missing' ) )
        return false
    end

    local cmsg = cfg.cmsg

    local args = { ... }
    for k, v in pairs( args ) do
        if not isstring( v ) then continue end
        args[ k ] = v .. ' '
    end

    if CLIENT then
        chat.AddText( cmsg.clrs.cat, '[' .. cmsg.tag_server .. '] ', cmsg.clrs.subcat, subcat and '[' .. subcat .. '] ' or nil, cmsg.clrs.msg, unpack( args ) )
    else
        if helper.ok.ply( pl ) then
            pl:umsg( cmsg.clrs.cat, '[' .. cmsg.tag_server .. '] ', cmsg.clrs.subcat, subcat and '[' .. subcat .. '] ' or nil, cmsg.clrs.msg, unpack( args ) )
        else
            base:broadcast( cmsg.clrs.cat, '[' .. cmsg.tag_server .. '] ', cmsg.clrs.subcat, subcat and '[' .. subcat .. '] ' or nil, cmsg.clrs.msg, unpack( args ) )
        end
    end
end

/*
    msg > target

    routes a message as either a private or broadcast based on the target
    does NOT send server-side console messages for things such as server commands.
    use msg:route( ) for console + player

    @destinations   :       CLIENT  - Client chat

                            SERVER  - umsg ( one indivudual player )
                                    - broadcast ( all players )

    @param  : ply pl
    @param  : str subcat [optional]
    @param  : varg { ... }
*/

function base.msg:target( pl, subcat, ... )
    if not cfg or not cfg.cmsg then
        base:log( 2, ln( 'cmsg_missing' ) )
        return
    end

    local cmsg = cfg.cmsg

    local args = { ... }
    for k, v in pairs( args ) do
        if not isstring( v ) then continue end
        args[ k ] = v .. ' '
    end

    local sub_c = ( helper.str:ok( subcat ) and '[' .. subcat .. '] ' ) or ''

    if CLIENT then
        chat.AddText( cmsg.clrs.cat, '[' .. cmsg.tag_private .. '] ', cmsg.clrs.subcat, sub_c, cmsg.clrs.msg, unpack( args ) )
    else
        if helper.ok.ply( pl ) then
            pl:umsg( cmsg.clrs.cat, '[' .. cmsg.tag_private .. '] ', cmsg.clrs.subcat, sub_c, cmsg.clrs.msg, unpack( args ) )
        else
            base:broadcast( cmsg.clrs.cat, '[' .. cmsg.tag_server .. '] ', cmsg.clrs.subcat, sub_c, cmsg.clrs.msg, unpack( args ) )
        end
    end
end

/*
    msg > route

    can send a message via multiple routes

    if console, the message reply will simply go back to the console.

    if player, the reply output will be sent both to their chat using sendcmsg, and to their console
    using bConsole.

    since sending to player chat has a tendency to also add to the player console, bConsole
    has been added.

    @destinations   :       CLIENT  - Client chat
                                    - Client console

                            SERVER  - umsg ( one indivudual player )
                                    - broadcast ( all players )
                                    - Console only prints

    @param  : ply pl
    @param  : bool bConsole
    @param  : varg { ... }
*/

function base.msg:route( pl, bConsole, ... )
    local args          = { ... }
    local toConsole     = isbool( bConsole ) and bConsole or false
    local subcat        = isbool( bConsole ) and args[ 1 ] or bConsole
    local cmsg          = cfg.cmsg

    if subcat == args[ 1 ] then
        table.remove( args, 1 )
    end

    for k, v in pairs( args ) do
        if not isstring( v ) then continue end
        args[ k ] = v .. ' '
    end

    if CLIENT then
        chat.AddText( cmsg.clrs.cat, '[' .. cmsg.tag_console .. '] ', cmsg.clrs.subcat, subcat and '[' .. subcat .. '] ' or nil, cmsg.clrs.msg, unpack( args ) )
        if toConsole then
            table.insert( args, '\n' )
            MsgC( cmsg.clrs.cat, '[' .. cmsg.tag_console .. '] ', cmsg.clrs.subcat, subcat and '[' .. subcat .. '] ' or nil, cmsg.clrs.msg, unpack( args ) )
        end
    else
        if pl and pl ~= nil then
            if access:bIsConsole( pl ) then
                table.insert( args, '\n' )
                MsgC( cmsg.clrs.cat, '[' .. cmsg.tag_console .. '] ', cmsg.clrs.subcat, subcat and '[' .. subcat .. '] ' or nil, cmsg.clrs.msg, unpack( args ) )
            else
                pl:umsg( cmsg.clrs.cat, '[' .. cmsg.tag_private .. '] ', cmsg.clrs.subcat, subcat and '[' .. subcat .. '] ' or nil, cmsg.clrs.msg, unpack( args ) )
            end
        else
            base:broadcast( cmsg.clrs.cat, '[' .. cmsg.tag_server .. '] ', cmsg.clrs.subcat, subcat and '[' .. subcat .. '] ' or nil, cmsg.clrs.msg, unpack( args ) )
        end
    end
end

/*
    msg > direct

    can send a message via multiple routes

    if console, the message reply will simply go back to the console.

    if player, the reply output will be sent both to their chat using sendcmsg, and to their console
    using bConsole.

    since sending to player chat has a tendency to also add to the player console, bConsole
    has been added.

    @note   : func msg_prepare temp for now for testing; will be migrated in future version

    @ex     : rlib.msg:direct( LocalPlayer( ), nil, 'your name is', rlib.settings.cmsg.clrs.target, 'rob' )
                    sends a msg to a single player with the message 'your name is rob'

            : rlib.msg:direct( nil, nil, 'hello ', rlib.settings.cmsg.clrs.target, 'everyone' )
                    sends a broadcast message to all players with no category prefix

    @param  : ply pl
    @param  : str subcat [optional]
    @param  : varg { ... }
*/

local function msg_prepare( ... )
    local args = { ... }
    return args
end

function base.msg:direct( pl, subcat, ... )
    local args  = { ... }
    local cmsg  = cfg.cmsg
    subcat      = isstring( subcat ) and subcat

    local resp  = msg_prepare( cmsg.clrs.cat, '[' .. cmsg.tag_private .. '] ', cmsg.clrs.subcat, subcat and '[' .. subcat .. '] ' or nil, cmsg.clrs.msg )
    table.Add( resp, args )

    if CLIENT then
        chat.AddText( unpack( resp ) )
    else
        if pl and pl ~= nil then
            if access:bIsConsole( pl ) then
                table.insert( resp, '\n' )
                MsgC( unpack( resp ) )
            else
                pl:umsg( cmsg.clrs.cat, '[' .. cmsg.tag_private .. '] ', cmsg.clrs.subcat, subcat and '[' .. subcat .. '] ' or nil, cmsg.clrs.msg, ... )
            end
        else
            base:broadcast( cmsg.clrs.cat, '[' .. cmsg.tag_private .. '] ', cmsg.clrs.subcat, subcat and '[' .. subcat .. '] ' or nil, cmsg.clrs.msg, ... )
        end
    end
end

/*
    msg > prepare

    structures a push notification

    @note   : replaced with /*
    msg > prepare

    structures a push notification

    @param  : msg str
*/

function base.msg:prepare( msg, sym )
    local sym       = isstring( sym ) and sym or '|'
    local words     = string.Explode( sym, msg )
    for k, v in ipairs( words ) do
        if not helper.str:ok( v ) then words[ k ] = nil end
        if rclr.bHex( v ) then
            v       = string.gsub( v, sym, '' )
        end
    end
    return words
end

/*
    msg > prepare

    structures a push notification

    @param  : msg str
*/

function base.msg:PreparePush( msg, sym )
    local sym       = isstring( sym ) and sym or '|'
    local words     = string.Explode( sym, msg )
    for k, v in ipairs( words ) do
        if not helper.str:ok( v ) then words[ k ] = nil end
        if rclr.bHex( v ) then
            v       = string.gsub( v, sym, '' )
        end
    end
    return words
end

/*
    helper > util > steam 32 to 64

    canvert steam 32 to 64

    @ref    : https://developer.valvesoftware.com/wiki/SteamID

    @param  : str sid
    @return : str
*/

function helper.util:sid32_64( sid )
    if not sid or not helper.ok.sid32( sid ) then
        local ret = ln( 'util_nil' )
        if sid and sid ~= nil then ret = sid end
        base:log( 2, ln( 'util_s32_noconvert', ret ) )
        return false
    end

    sid             = sid:upper( )

    local sid_pre   = '7656'
    local segs      = string.Explode( ':', string.sub( sid, 7 ) )
    local to64      = ( 1197960265728 + tonumber( segs[ 2 ] ) ) + ( tonumber( segs[ 3 ] ) * 2 )
    local output    = sf( '%f', to64 )

    return sid_pre .. string.sub( output, 1, string.find( output, '.', 1, true ) - 1 )
end

/*
    helper > util > steam 64 to 32

    canverts a steam 64 to 32

    :   STEAM_X:Y:Z
        X = universe ( 0 - 5 | def. 0 )
        Y = Lowest bit for acct id ( 0 or 1 )
        Z = upper 31 bits for acct id

    :   universes
        0   Individual / Unspecified
        1   Public
        2   Beta
        3   Internal
        4   Dev
        5   RC

    @ref    : https://developer.valvesoftware.com/wiki/SteamID

    @param  : str sid
    @param  : int x [ optional ]
    @return : str
*/

function helper.util:sid64_32( sid, x )
    if not sid or tonumber( sid ) == nil then
        local ret = ln( 'util_nil' )
        if sid and sid ~= nil then ret = sid end
        base:log( 2, ln( 'util_s64_noconvert', ret ) )
        return false
    end

    x = x or 0
    if x > 5 then x = 0 end

    local b_id      = 6561197960265728
    local from64    = tonumber( sid:sub( 2 ) )
    local y         = from64 % 2 == 0 and 0 or 1
    local z         = math.abs( b_id - from64 - y ) / 2

    return 'STEAM_' .. x .. ':' .. y .. ':' .. ( y == 1 and z - 1 or z )
end

/*
    helper > who > player by name ( exact )

    attempts to locate a player by the specified name

    @param  : str, ply pl
    @return : ent
*/

function helper.who:name( pl )
    if not pl then return end
    pl = isstring( pl ) and pl:lower( ) or helper.ok.ply( pl ) and pl:Name( )

    local res = false
    for v in helper.get.players( ) do
        local res_name = v:Name( ):lower( )
        if res_name ~= pl then continue end

        res = v
    end

    return helper.ok.ply( res ) and res
end

/*
    helper > who > player by name ( wildcard )

    attempts to locate a player by the specified name in a wildcard fashion (partial name matches)
    any matches will be placed in a table with the starting index [ 0 ]

    @call   : local res_cnt, res_ply = helper.who:name_wc( ply )

    @param  : str, ply pl
    @return : int, tbl
*/

function helper.who:name_wc( pl )
    if not pl then return end
    pl = isstring( pl ) and pl:lower( ) or helper.ok.ply( pl ) and pl:Name( )

    local i, outp = 0, { }
    for v in helper.get.players( ) do
        local res_name = v:Name( ):lower( )
        if ( string.find( res_name, pl, 1, true ) == nil ) then continue end

        outp[ i ] = v
        i = i + 1
    end

    return i, outp
end

/*
    helper > who > rpname

    determines if a pl has a valid rp name

    @call   : helper.who:rpname( pl )

    @param  : ply pl
    @return : str, bool
*/

function helper.who:rpname( pl )
    if not pl.DarkRPVars or not pl.DarkRPVars.rpname then return end
    return pl.DarkRPVars.rpname ~= 'NULL' and pl.DarkRPVars.rpname or false
end

/*
    helper > who > rpjob

    attempts to locate a darkrp job by the specified name

    returns table with 2 rows:
        [ 1 ]   = job/team id
        [ 2 ]   = job table data

    @param  : str name
    @return : tbl
*/

function helper.who:rpjob( name )
    if not RPExtraTeams then
        base:log( 2, ln( 'hlp_who_rp_notable' ) )
        return false
    end

    local resp = nil
    for i, v in pairs( RPExtraTeams ) do
        if v.name:lower( ) ~= name:lower( ) then continue end
        resp = { i, v }
    end

    return resp
end

/*
    helper > who > rpjob > wildcard

    attempts to locate a darkrp job by the specified name in a wildcard fashion (partial name matches)
    any matches will be placed in a table with the starting index [ 0 ]

    returns two values
        i, matches

    @param  : str name
    @return : tbl
*/

function helper.who:rpjob_wc( name )
    if not RPExtraTeams then
        base:log( 2, 'darkrp table [ %s ] missing » check gamemode', 'RPExtraTeams' )
        return false
    end

    if not name then return RPExtraTeams or false end
    name = isstring( name ) and name:lower( ) or tostring( name ):lower(  )

    local i, outp = 0, { }
    for v in helper.get.data( RPExtraTeams ) do
        local res_name = v.name:lower()
        if ( string.find( res_name, name, 1, true ) == nil ) then continue end

        outp[ i ] = v
        i = i + 1
    end

    return i, outp
end

/*
    helper > who > rpjob > custom

    attempts to locate a darkrp job based on a custom field specified. you can search using any field that
    the jobs table has.

    defaults to 'command' field if left blank

    @ex     : helper.who:rpjob_custom( '1', 'lvl' )
            : returns jobs matching level 1

            : helper.who:rpjob_custom( 'citizen' )
            : defaults to job /command field.

    returns two values
        i, matches

    @param  : str name
    @return : tbl
*/

function helper.who:rpjob_custom( name, field )
    if not RPExtraTeams then
        base:log( 2, 'darkrp table [ %s ] missing » check gamemode', 'RPExtraTeams' )
        return false
    end

    if not name then return RPExtraTeams or false end

    name    = isstring( name ) and name:lower( ) or tostring( name ):lower(  )
    field   = field or 'command'

    local i, outp = 0, { }
    for v in helper.get.data( RPExtraTeams ) do
        local res_name = isstring( v[ field ] ) and v[ field ]:lower( ) or v[ field ]
        if ( string.find( res_name, name, 1, true ) == nil ) then continue end

        outp[ i ] = v
        i = i + 1
    end

    return i, outp
end

/*
    helper > who > rpjob > lc / clean

    serves the same purpose as the func helper.who:rpjob_custom but with cleaning of the strings
    so that values match identically.

    defaults to 'command' field if left blank

    @ex     : helper.who:rpjob_custom( 'citizen' )
            : defaults to job /command field.

    returns two values
        i, matches

    @param  : str name
    @return : tbl
*/

function helper.who:rpjob_custom_lc( name, field )
    if not RPExtraTeams then
        base:log( 2, 'darkrp table [ %s ] missing » check gamemode', 'RPExtraTeams' )
        return false
    end

    if not name then return RPExtraTeams or false end

    name    = isstring( name ) and name or tostring( name )
    name    = helper.str:clean( name )
    field   = field or 'command'

    local i, outp = 0, { }
    for v in helper.get.data( RPExtraTeams ) do
        local res_name = isstring( v[ field ] ) and v[ field ]:lower( ) or v[ field ]
        if helper.str:clean( res_name ) ~= name then continue end

        outp[ i ] = v
        i = i + 1
    end

    return i, outp
end

/*
    helper > who > sid

    locates a ply based on steam64

    if steam32 provided; will be converted to s64 before checking for a matching ply.

    :   steam_id
        supports steam32 and steam64 ids

    :   bNameOnly
        false   : returns the ply ent
        true    : returns only ply name str

    @param  : str sid
    @param  : bool bNameOnly
    @return : ply
*/

function helper.who:sid( sid, bNameOnly )
    sid = isstring( sid ) and sid or tostring( sid )
    if helper.ok.sid32( sid ) then
        sid = helper.util:sid32_64( sid )
    end

    local i, outp = 0, { }
    for v in helper.get.players( ) do
        if v:SteamID64( ) ~= sid then continue end

        outp[ i ] = not bNameOnly and v or v:Name( )
        i = i + 1
    end

    return i, outp
end

/*
    helper > bIsAlpha

    the characters that a player is allowed to use when they are using an input field.
    anything not in the following table will be classified as an invalid character.

    @param  : str str
    @return : bool
*/

function helper:bIsAlpha( str )
    local wlist =
    {
        'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o',
        'p', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k',
        'l', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ' '
    }

    for k in string.gmatch( str, '.' ) do
        if not table.HasValue( wlist, k:lower( ) ) then return false end
    end

    return true
end

/*
    helper > bIsNum

    listed values in the local table will determine what chars are allowed in the func being used.

    @param  : str str
    @return : bool
*/

function helper:bIsNum( str )
    str         = tostring( str )
    local wlist = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' }

    for k in string.gmatch( str, '.' ) do
        if not table.HasValue( wlist, k:lower( ) ) then return false end
    end

    return true
end

/*
    helper > bIsAlphaNum

    allows for a string to only contain alphanumerical characters.

    @param  : str str
    @return : bool
*/

function helper:bIsAlphaNum( str )
    str = tostring( str )
    local wlist =
    {
        'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 'a', 's',
        'd', 'f', 'g', 'h', 'j', 'k', 'l', 'z', 'x', 'c', 'v', 'b',
        'n', 'm', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
    }

    for k in string.gmatch( str, '.' ) do
        if table.HasValue( wlist, k:lower( ) ) then return true end
    end

    return false
end

/*
    helper > bBlacklisted

    determines if a word(s) are in a defined blacklist table

    @call   :   blacklist = { 'word', 'other word' }
                helper:bBlacklisted( 'other word', blacklist ) :: returns true
                helper:bBlacklisted( 'test', blacklist ) :: returns false

    @param  : str str
    @param  : tbl src
    @return : bool
*/

function helper:bBlacklisted( str, src )
    local bBlocked = false
    for word in helper.get.data( src ) do
        local msg, i = string.gsub( str, word, function( d )
            bBlocked = true
        end )
        if bBlocked then break end
    end
    return bBlocked
end

/*
    color > is hex

    uses patterns to determine if a string is a valid hex code.

    @ex     : #FFFFFF   : true
    @ex     : #ZJF      : false

    @param  : str hex
    @return : bool
*/

function helper:clr_ishex( val )
    if not isstring( val ) then return false end
    return ( val:match '^#?%x%x%x$' or val:match '^#?%x%x%x%x%x%x$' ) ~= nil
end

/*
    color > hex to rgb

    takes a hex value and converts it into an rgb

    @ex     : #FFFFFF       : 255 255 255
    @ex     : #FFFFFF, 50   : 255 255 255 50

    @param  : str hex
    @param  : int a
    @return : tbl
*/

function helper:clr_hex2rgb( hex, a )
    if not helper:clr_ishex( hex ) then return end

    hex         = hex:gsub( '#', '' )
    a           = isnumber( a ) and a or 255

    if hex:len( ) == 3 then
        return tonumber( '0x' .. hex:sub( 1, 1 ) ) * 17, tonumber( '0x' .. hex:sub( 2, 2 ) ) * 17, tonumber( '0x' .. hex:sub( 3, 3 ) ) * 17, a
    elseif hex:len( ) == 6 then
        return tonumber( '0x' .. hex:sub( 1, 2 ) ), tonumber( '0x' .. hex:sub( 3, 4 ) ), tonumber( '0x' .. hex:sub( 5, 6 ) ), a
    else
        return 255, 255, 255, a
    end
end

/*
    color > rgb to hex

    takes rgb color table and converts it to hexadecimal

    @ex     : { 255, 255, 255 }     : 0XFFFFFF
    @ex     : ( 0, 0, 0 )           : 0X000000

    @param  : tbl rgb
    @param  : bool bClean
    @return : str
*/

function helper:rgb2hex( rgb, bClean )
    local hexadecimal = '0X'

    if not rgb or not istable( rgb ) then return end

    for k, v in pairs( rgb ) do
        local hex = ''

        while ( v > 0 ) do
            local ind = math.fmod( v, 16 ) + 1
            v = math.floor( v / 16 )
            local substr = '0123456789ABCDEF'
            hex = substr:sub( ind, ind ) .. hex
        end

        hex = ( hex:len( ) == 0 and '00' ) or ( hex:len( ) == 1 and '0' .. hex ) or hex

        hexadecimal = hexadecimal .. hex
    end

    if bClean then
        hexadecimal = hexadecimal:gsub( '0X', '' )
    end

    return hexadecimal
end

/*
    helper > table add entry

    adds entries to a specified table

    @call   : helper:table_addentry( table, { 'a', 'b', 'c' } )

    @param  : tbl src
    @param  : tbl entries
*/

function helper:table_addentry( src, entries )
    if not istable( src ) then
        base:log( 2, 'cannot add table entries without valid table' )
        return
    end

    if not istable( entries ) then
        base:log( 2, 'cannot add missing entries to table' )
        return
    end

    for v in self.get.data( entries ) do
        table.insert( src, v )
    end
end

/*
    helper > table del index

    removes a specified number of table indexes

    @ex     :   local src = { 'aaa', 'bbb', 'ccc' }
            :   helper:table_remove( src, 2 )

                returns entries 'aaa', 'bbb'

    @param  : tbl tbl
    @param  : int int
*/

function helper:table_remove( tbl, int )
    if not istable( tbl ) then
        base:log( 2, 'cannot remove table indexes without valid table' )
        return
    end

    int = calc.bIsNum( int ) and int or 1

    for i = 1, int do
        table.remove( tbl, 1 )
    end
end

/*
    helper > copy table

    completely copies a table; including sub-tables
    do not use on tables that contain themselves somewhere, otherwise it may cause
    an infinite loop

    @ex     :   local src = { 'aaa', 'bbb', 'ccc' }
            :   helper:table_remove( src, 2 )

                returns entries 'aaa', 'bbb'

    @param  : tbl tbl
    @param  : int int
*/

function helper:table_copyall( tbl )
    if not istable( tbl ) then return end

    local res = { }
    for k, v in pairs( tbl ) do
        if ( type( v ) == 'table' ) then
            res[ k ] = helper:table_copyall( v )
        elseif ( type( v ) == 'Vector' ) then
            res[ k ] = Vector( v.x, v.y, v.z )
        elseif ( type( v ) == 'Angle' ) then
            res[ k ] = Angle( v.p, v.y, v.r )
        else
            res[ k ] = v
        end
    end

    return res
end

/*
    helper > log colors

    returns the clr used for a particular log type id

    @param  : int id
    @param  : int limit
    @return : clr || clr, clr
*/

function helper:_logclr( id, limit )
    if not id then return Color( 255, 255, 255, 255 ) end
    limit = isstring( limit ) and limit:lower( ) or isnumber( limit ) and limit or false

    if limit == 1 or limit == 'rgb' then
        return self.def._lc_rgb[ id ] or Color( 255, 255, 255, 255 )
    elseif limit == 2 or limit == 'rgb6' then
        return self.def._lc_rgb6[ id ] or Color( 255, 255, 255, 255 )
    else
        return self.def._lc_rgb[ id ] or Color( 255, 255, 255, 255 ), self.def._lc_rgb6[ id ] or Color( 255, 255, 255, 255 )
    end
end

/*
    rsay > shared

    prints a message in center of the screen as well as in the users consoles.

    @param  : ply pl        send to ply ( set nil for broadcast )
    @param  : str msg       msg to send
    @param  : clr clr       <@optional> clr for msg
    @param  : int dur       <@optional> amt of time to show the msg
    @param  : int fade      <@optional> length of fade time [ def:1 ]
*/

local function rsay_netlib_sv( pl, msg, clr, dur, fade )
    if not SERVER then return end

    net.Start           ( 'rlib.rsay'   )
    net.WriteString     ( msg           )
    net.WriteColor      ( clr           )
    net.WriteInt        ( dur, 8        )
    net.WriteInt        ( fade, 8       )
    if pl then
        net.Send( pl )
    else
        net.Broadcast( )
    end
end

function base.rsay( pl, msg, clr, dur, fade )
    pl      = IsValid( pl ) and pl or nil
    msg     = isstring( msg ) and msg or 'missing msg'
    clr     = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
    dur     = isnumber( dur ) and dur or 8
    fade    = isnumber( fade ) and fade or 1

    rsay_netlib_sv( pl, msg, clr, dur, fade )
    base.con:Guided( pl, msg )
end

/*
    base > garbadge collection

    executes the specified action on the garbage collector.

    @param  : str act       :   collect
                                stop
                                restart
                                count
                                step
                                setpause
                                setstepmul

    @param  : int arg       :   only used for step, setpause and setstepmul
*/

function base.gc( act, arg )
    act             = isstring( act ) and act or 'collect'
    arg             = isnumber( arg ) and arg or nil
    local res       = collectgarbage( act, arg )
    local resp      = res

                    if act == 'count' then
                        local sz    = tonumber( res )
                        sz          = sz * 1024
                        local ca    = ( calc.fs.size( sz ) )
                        resp        = string.format( 'Size: %s', ca )
                    end

    return resp
end

/*
    base > weak tables

    sets the mode for a table

    @param  : tbl src
    @param  : str t

            :   'k'
                weak keys

            :   'v'
                weak values

            :   'kv'
                weak keys + values
*/

function base.weak( src, t )
    src     = istable( src ) and src or { }
    t       = isstring( t ) and t or 'kv'
    return setmetatable( src, { __mode = t } )
end

/*
    base > type

    returns type

    @param  : mix val
    @param  : bool bPrint
*/

function base.type( val, bPrint )
    if not val then return nil end
    local t = type( val )
    if bPrint then
        print( t )
    end
    return t
end

/*
    convar :: validate

    checks if the provided item is a convar

    @param  : mix obj
    @return : bool
*/

function cvar:valid( obj )
    return ( type( obj ) == 'ConVar' ) or false
end

/*
    convar :: register

    @param  : str name
    @param  : str value
    @param  : enum, tbl flags
    @param  : str help
*/

function cvar:Register( name, value, flags, help )
    if not helper.str:valid( name ) or not helper.str:valid( name ) then
        base:log( 2, 'cannot register cvar with missing parameters' )
        return
    end

    if not ConVarExists( name ) then
        if not value then
            base:log( 2, 'cvar default missing » [ %s ]', name )
            return
        end

        if not flags then
            base:log( 2, 'cvar flags missing » [ %s ]', name )
            return
        end

        help = help or ''

        CreateConVar( name, value, flags, help )

        base:log( 6, ln( 'cvar_added', name ) )
    end
end

/*
    convar :: get :: clr

    fetches the proper clrs associated with a particular convar.

    @param  : str id
    @param  : tbl alt
    @return : clr tbl
*/

function cvar:Clr( id, alt )
    local channels = { id .. '_red', id .. '_green', id .. '_blue', id .. '_alpha' }

    local i = 0
    for _, v in pairs( channels ) do
        if not ConVarExists( v ) then continue end
        i = i + 1
    end

    if i < 3 then
        return alt or Color( 255, 255, 255, 255 )
    elseif i == 3 then
        return Color( GetConVar( id .. '_red' ):GetInt( ), GetConVar( id .. '_green' ):GetInt( ), GetConVar( id .. '_blue' ):GetInt( ) )
    elseif i > 3 then
        return Color( GetConVar( id .. '_red' ):GetInt( ), GetConVar( id .. '_green' ):GetInt( ), GetConVar( id .. '_blue' ):GetInt( ), GetConVar( id .. '_alpha' ):GetInt( ) )
    end
end

/*
    convar > hex > get

    gets a hex convar for themes and converts it into Color( r, g, b, a )

    @param  : str id
    @param  : str, clr
    @param  : int
*/

function cvar:ClrHex( id, alt, a )
    local cv_clr = ( isstring( id ) and ConVarExists( id ) and GetConVar( id ) )

    if not cv_clr then
        if alt then
            a = isnumber( a ) and a or 255
            if rclr.bHex( alt ) then
                return rclr.Hex( alt, a )
            end

            if IsColor( alt ) then
                return alt
            end

            return Color( 255, 255, 255, a )
        end

        return Color( 255, 255, 255, a )
    end

    local clr = cv_clr:GetString( )
    if rclr.bHex( clr ) then
        return rclr.Hex( clr, a )
    end
end

/*
    convar > hexa > get

    gets a hexa convar for themes and converts it into Color( r, g, b, a )

    @param  : str id
    @param  : str, clr alt
    @param  : int a
*/

function cvar:ClrHexa( id, alt, a )
    if not isstring( id ) then
        if CLIENT then
            base:log_net( 2, 'Library [ %s ] : Player [ %s ] CL error:\n                               cvar id is not string %s - %s', mf.name, LocalPlayer( ):palias( ), tostring( id ), 'sh_cvar.lua' )
        end
        return Color( 255, 255, 255, 255 )
    end

    local channels      = { id .. '_hex', id .. '_alpha' }
    a                   = isnumber( a ) and a or 255

    local i = 0
    for _, v in pairs( channels ) do
        if not ConVarExists( v ) then continue end
        i = i + 1
    end

    if i == 1 then
        local cv_clr        = GetConVar( id .. '_hex' ):GetString( )
        if not cv_clr then
            if alt then
                a = isnumber( a ) and a or 255
                if rclr.bHex( alt ) then
                    return rclr.Hex( alt, a )
                end

                if IsColor( alt ) then
                    return alt
                end

                return Color( 255, 255, 255, a )
            end

            return Color( 255, 255, 255, a )
        end

        if rclr.bHex( cv_clr ) then
            return rclr.Hex( cv_clr, a )
        end

        return Color( 255, 255, 255, 255 )

    elseif i > 1 then
        local cv_hex        = GetConVar( id .. '_hex' ):GetString( )
        local cv_alpha      = GetConVar( id .. '_alpha' ):GetInt( )

        if rclr.bHex( cv_hex ) then
            return rclr.Hex( cv_hex, cv_alpha )
        end

        return Color( 255, 255, 255, 255 )
    else
        if rclr.bHex( alt ) then
            return rclr.Hex( alt, a )
        end

        if IsColor( alt ) then
            return alt
        end

        return Color( 255, 255, 255, 255 )
    end
end

/*
    convar :: get

    valides and returns a specified convar

    @param  : str id
    @return : cvar
*/

function cvar:Get( id )
    return ( isstring( id ) and ConVarExists( id ) and GetConVar( id ) ) or ( self:valid( id ) and id ) or false
end

/*
    convar :: get :: name

    valides and returns a specified convar
    param accepts either a str; or the convar itself

    @param  : str id
    @return : cvar
*/

function cvar:Name( id )
    local cv = ( isstring( id ) and ConVarExists( id ) and GetConVar( id ) ) or ( self:valid( id ) and id ) or false
    return cv:GetName( )
end

/*
    convar :: get :: helptext

    returns the helptext for a registered convar

    @param  : str id
    @return : str
*/

function cvar:Help( id )
    local cv = self:Get( id )
    if not cv then return end
    return cv:GetHelpText( ) or ln( 'cvar_nohelp' )
end

/*
    convar :: set :: int

    @param  : str id
    @param  : int val
*/

function cvar:SetInt( id, val )
    local cv = self:Get( id )
    if not cv then return end
    cv:SetInt( val )
end
cvar.Int = cvar.SetInt

/*
    convar :: set :: str

    @param  : str id
    @param  : str val
*/

function cvar:SetStr( id, val )
    if not id then return end

    if ( isstring( id ) and self:Get( id ) ) then
        local cv = GetConVar( id )
        cv:SetString( val )
    elseif ( self:valid( id ) ) then
        id:SetString( val )
    end
end

/*
    convar :: set :: bool

    @param  : str id
    @param  : bool val
*/

function cvar:SetBool( id, val )
    if not id then return end
    val = val or false

    if ( isstring( id ) and self:Get( id ) ) then
        local cv = GetConVar( id )
        cv:SetBool( val )
    elseif ( self:valid( id ) ) then
        id:SetBool( val )
    end
end

/*
    convar :: set :: float

    @param  : str id
    @param  : flt val
*/

function cvar:SetFloat( id, val )
    if not id then return end
    val = val or 0

    if ( isstring( id ) and self:Get( id ) ) then
        local cv = GetConVar( id )
        cv:SetFloat( val )
    elseif ( self:valid( id ) ) then
        id:SetFloat( val )
    end
end

/*
    convar :: get :: default

    returns a cvar default value

    @param  : str id
    @return : mix
*/

function cvar:GetDef( id )
    return ConVarExists( id ) and GetConVar( id ):GetDefault( )
end
cvar.Def = cvar.GetDef

/*
    convar :: get :: int

    fetches the proper int associated with a particular convar.
    param accepts either a str; or the convar itself

    @param  : str id
    @param  : int alt
    @return : int
*/

function cvar:GetInt( id, alt )
    return ( isstring( id ) and ConVarExists( id ) and GetConVar( id ):GetInt( ) ) or ( self:valid( id ) and id:GetInt( ) ) or self:GetDef( id ) or alt
end
cvar.Int = cvar.GetInt

/*
    convar :: get :: str

    fetches the proper str associated with a particular convar.
    param accepts either a str; or the convar itself

    @param  : str id
    @param  : str alt
    @return : str
*/

function cvar:GetStr( id, alt )
    return ( isstring( id ) and ConVarExists( id ) and GetConVar( id ):GetString( ) ) or ( self:valid( id ) and id:GetString( ) ) or self:GetDef( id ) or alt
end
cvar.Str = cvar.GetStr

/*
    convar :: get :: str :: strict method

    fetches the proper str associated with a particular convar.

    @param  : str id
    @param  : str alt
    @return : str
*/

function cvar:GetStrStrict( id, alt )
    return ConVarExists( id ) and GetConVar( id ):GetString( ) or self:GetDef( id ) or alt
end

/*
    convar :: get :: float

    fetches the proper float associated with a particular convar.
    param accepts either a str; or the convar itself

    @param  : str, cvar id
    @param  : flt alt
    @return : flt
*/

function cvar:GetFloat( id, alt )
    return ( isstring( id ) and ConVarExists( id ) and GetConVar( id ):GetFloat( ) ) or ( self:valid( id ) and id:GetFloat( ) ) or self:GetDef( id ) or alt or 0
end
cvar.Flt        = cvar.GetFloat
cvar.Float      = cvar.GetFloat

/*
    convar :: get :: bool

    fetches the proper bool associated with a particular convar.
    param accepts either a str; or the convar itself

    @param  : str, cvar id
    @return : bool
*/

function cvar:GetBool( id )
    return ( isstring( id ) and ConVarExists( id ) and GetConVar( id ):GetBool( ) ) or ( self:valid( id ) and id:GetBool( ) ) or false
end
cvar.Bool       = cvar.GetBool

/*
    convar :: int to bool

    converts an int stored cvar to a bool
    param accepts either a str; or the convar itself

    @param  : str, cvar id
    @return : bool
*/

function cvar:Int2Bool( id )
    return ( isstring( id ) and ConVarExists( id ) and self:int2bool( GetConVar( id ):GetInt( ) ) ) or ( self:valid( id ) and helper:int2bool( id:GetInt( ) ) ) or false
end

if SERVER then

    /*
        set alias

        sets the nick for a player, also takes other gamemodes into consideration to support different
        storage types and funcs

        @param  : str nick
    */

    function pmeta:setalias( nick )
        local setname = ( isstring( nick ) and nick ) or self:palias( )

        self:SetName( setname )

        if self.setRPName then
            self:setRPName( setname )
        end

        if self.setDarkRPVar then
            self:setDarkRPVar( 'rpname', setname )
        end
    end

    /*
        energy > set

        @param  : int i
    */

    function pmeta:setEnergy( i )
        i = i or 100

        if self.setDarkRPVar then
            self:setDarkRPVar( 'Energy', i )
        end
    end

end

/*
    alias

    displays their real name (alias) to use on the server
    override can be applied to check for valid string first

    : priority      : override
                    : bot
                    : player name
                    : steam name

    @param  : str override
*/

function pmeta:palias( override )
    if self.IsIncognito and self:IsIncognito( ) then
        return self:IncognitoName( )
    end

    return ( helper.ok.any( self ) and ( isstring( override ) and override ) or ( helper.ok.str( self:Name( ) ) and self:Name( ) ) or ( self.SteamName and self:SteamName( ) ) )
end

/*
 	player model > revision 2

    a fix for certain models displaying /models/models/

    @return : tbl, str
*/

function pmeta:getmdl_rev2( )
    if self:GetModel( ):sub( 1, 13 ) == 'models/models' then
        return self:GetModel( ):sub( 8 )
    else
        return self:GetModel( )
    end
end

/*
 	player model > get

    returns the current model for the job of a player

 	@param	: bool bCurrent
    @return : tbl, str
*/

function pmeta:getmdl( bCurrent )
    local team      = self:Team( )
    local result    = 'models/error.mdl'
    if RPExtraTeams and RPExtraTeams[ team ] then
        local mdl = RPExtraTeams[ team ].model
        result = istable( mdl ) and mdl[ 1 ] or mdl
        util.PrecacheModel( result )
    else
        result = self:getmdl_rev2( )
    end

    if bCurrent then
        result = self:getmdl_rev2( )
    end

    return result
end
pmeta.getmodel = pmeta.getmdl

/*
 	uid > get

    returns unique id or account id of ply

 	@param	: bool bUID
 	@return	: str
*/

function pmeta:uid( bUID )
    return ( not bUID and self:UniqueID( ) or self:AccountID( ) ) or 0
end

/*
 	sid > get

    returns steam64 or steam32 id of ply

 	@param	: bool bS32
 	@return	: str
*/

function pmeta:sid( bS32 )
    return ( not bS32 and self:SteamID64( ) or self:SteamID( ) ) or 0
end

/*
 	generate id
*/

function pmeta:gid( suffix, bUseS64 )
    local id = ( bUseS64 and ( ( self:IsBot( ) and self:UniqueID( ) ) or ( self:SteamID64( ) ) ) or self:UniqueID( ) )
    return string.format( '%s.%s', suffix, id )
end

/*
    association id
*/

function pmeta:aid( ... )
    if not helper.ok.ply( self ) then return end

    local pl            = self:uid( )
    local args          = { ... }

    table.insert        ( args, pl )

    local resp          = table.concat( args, '_' )
    resp                = resp:lower( )
    resp                = resp:gsub( '[%p%c]', '.' )
    resp                = resp:gsub( '[%s]', '_' )

    return resp
end

/*
    association id > 64
*/

function pmeta:aid64( ... )
    if not helper.ok.ply( self ) then return end

    local pl            = self:sid( )
    local args          = { ... }

    table.insert        ( args, pl )

    local resp          = table.concat( args, '_' )
    resp                = resp:lower( )
    resp                = resp:gsub( '[%p%c]', '.' )
    resp                = resp:gsub( '[%s]', '_' )

    return resp
end

/*
 	money > get
*/

function pmeta:getmoney( bStr, sym )
    local money     = ( isfunction( self.getDarkRPVar ) and self:getDarkRPVar( 'money' ) ) or 0

    if bStr then
        local symbol    = ( isstring( sym ) and sym ) or ( GAMEMODE.Config and GAMEMODE.Config.currency ) or ( BaseWars and BaseWars.LANG.CURRENCY ) or '$'
        money           = helper.str:comma( money )
        money           = string.format( '%s%s', symbol, money )
    end

    return money
end

/*
 	salary > get
*/

function pmeta:getsalary( bStr, sym )
    local salary        = ( isfunction( self.getDarkRPVar ) and self:getDarkRPVar( 'salary' ) ) or 0

    if bStr then
        local symbol    = ( isstring( sym ) and sym ) or ( GAMEMODE.Config and GAMEMODE.Config.currency ) or ( BaseWars and BaseWars.LANG.CURRENCY ) or '$'
        salary          = helper.str:comma( salary )
        salary          = string.format( '%s%s /hr', symbol, salary )
    end

    return salary
end

/*
 	prestige > get
*/

function pmeta:getprestige( )
    return ( isfunction( self.getDarkRPVar ) and self:getDarkRPVar( 'prestige' ) ) or 0
end

/*
 	stamina > get
*/

function pmeta:getstamina( )
    return ( isfunction( self.getDarkRPVar ) and ( self:getDarkRPVar( 'Stamina' ) or self:getDarkRPVar( 'stamina' ) ) ) or ( self.GetStamina and self:GetStamina( ) ) or self:GetNWInt( 'tcb_Stamina' ) or self:GetNWFloat( 'stamina', 0 )
end

/*
 	energy > get
*/

function pmeta:getenergy( )
    local energy = ( isfunction( self.getDarkRPVar ) and ( self:getDarkRPVar( 'Energy' ) ) ) or 0
    return math.Round( energy )
end

/*
 	health > get
*/

function pmeta:gethealth( bStr )
    local hp            = self:Health( )

    if bStr then
        hp              = helper.str:comma( hp )
        hp              = string.format( '%s', hp )
    end

    return hp
end

/*
 	armor > get
*/

function pmeta:getarmor( bStr )
    local ar            = self:Armor( )

    if bStr then
        ar              = helper.str:comma( ar )
        ar              = string.format( '%s', ar )
    end

    return ar
end

/*
    group > get
*/

function pmeta:getgroup( bLower )
    local group = self:GetUserGroup( )
    if jAdmin and jAdmin.Users then
        group = jAdmin.Users[ self:SteamID64( ) ]
    end
    return not bLower and group or helper.str:clean( group )
end
pmeta.group = pmeta.getgroup

/*
    scope > CLIENT
*/

if CLIENT then

    /*
     	inventory > get id
    */

    function pmeta:getinventory( )
        return self.InventoryID or 0
    end

end

/*
    inventory > get
*/

function pmeta:getinv( )
    return self:GetNWInt( 'inv_id', 0 )
end

/*
    inventory > set
*/

function pmeta:setinv( id )
    id = id or 0
    id = tonumber( id )

    self:SetNWInt( 'inv_id', id )
end

/*
    get level
*/

function pmeta:getlevel( )
    return ( self.SL_GetLevel and self:SL_GetLevel( ) ) or ( ( isfunction( self.getDarkRPVar ) and self:getDarkRPVar( 'year' ) ) or self:getDarkRPVar( 'level' ) or self:getDarkRPVar( 'lvl' ) or self:GetNWInt( 'lvl' ) ) or 1
end
pmeta.level = pmeta.getlevel

/*
    get year
*/

function pmeta:getyear( )
    return ( isfunction( self.getDarkRPVar ) and self:getDarkRPVar( 'year' ) ) or ( self:getDarkRPVar( 'yr' ) or self:GetNWInt( 'year' ) ) or 1
end
pmeta.year = pmeta.getyear

/*
    get data
*/

function pmeta:getdata( id )
    if not id then return end
    return ( isfunction( self.getDarkRPVar ) and self:getDarkRPVar( id ) ) or ( self:GetNWInt( id ) ) or nil
end

/*
 	get xp
*/

function pmeta:getxp( )
    return ( isfunction( self.GetXP ) and math.floor( self:GetXP( ) ) or ( isfunction( self.getDarkRPVar ) and self:getDarkRPVar( 'xp' ) ) or self:GetNWInt( 'xp' ) or self:GetNWInt( 'exp' ) ) or 0
end

/*
    xp > percentage
*/

function pmeta:getxpperc( bStr )
    local pl_lvl        = self:getlevel( ) or 1
    local pl_xp         = self:getxp( )
    local xp_diff       = ( ( pl_xp or 0 ) / self:getxpmax( ) ) or 0
    local xp_mult       = ( xp_diff * 100 ) or 0
    xp_mult             = math.Round( xp_mult ) or 0
    local percent       = math.Clamp( xp_mult, 0, 99 )

    if bStr then
        percent = string.format( '%.f%%', percent )
    end

    return percent
end


/*
    get xp max
*/

function pmeta:getxpmax( )
    // darkrp system
    if self.getMaxXP then
        return self:getMaxXP( )
    end

    // richards hogwarts rp addon
    if self.GetXPMax then
        return self:GetXPMax( )
    end

    // darkrp leveling system
    if self.getDarkRPVar and self:getDarkRPVar( 'level' ) then
        return ( ( ( 10 + ( ( ( self:getDarkRPVar( 'level' ) or 1 ) * ( ( self:getDarkRPVar( 'level' ) or 1 ) + 1 ) * 90 ) ) ) ) * LevelSystemConfiguration.XPMult )
    end

    return 0
end

/*
    give xp
*/

function pmeta:givexp( xp )
    xp = isnumber( xp ) and xp or 0
    if ( isfunction( self.GiveXP ) ) then
        self:GiveXP( xp )
    elseif ( isfunction( self.givexp ) ) then
        self:givexp( xp )
    elseif ( isfunction( self.addXP ) ) then
        self:addXP( xp )
    end
end

/*
 	get job
*/

function pmeta:getjob( )
    return isfunction( self.getDarkRPVar ) and self:getDarkRPVar( 'job' ) or 'Unassigned'
end
pmeta.job = pmeta.getjob

/*
 	get job data
*/

function pmeta:getjobdata( id )
    local team = self:Team( )
    if not RPExtraTeams or not team then
        base:log( 6, 'cannot locate role, invalid table RPExtraTeams', debug.traceback( ) )
        return
    end

    if id and RPExtraTeams[ team ] and RPExtraTeams[ team ][ id ] then
        return RPExtraTeams[ team ][ id ]
    end

    return RPExtraTeams[ team ]
end
pmeta.jdata = pmeta.getjobdata

/*
    distance
*/

function pmeta:distance( targ )
    if not IsValid( targ ) then return end
    return self:GetPos( ):Distance( targ:GetPos( ) ) or 0
end
pmeta.dist = pmeta.distance

/*
    pmeta > distance squared
*/

function pmeta:distSq( targ )
    if not IsValid( targ ) then return end
    return self:GetPos( ):DistToSqr( targ:GetPos( ) ) or 0
end

/*
 	pmeta > rcc
*/

function pmeta:rcc( name, cmd )
    if not name and not isstring( cmd ) then return false end

    if name then
        cmd = gid( name )
    end

    self:ConCommand( cmd )
end

/*
    late loading
*/

local function pmeta_loader( )

    timex.create( 'rlib_pmeta_loader', 30, 1, function( )

        /*
            user group
        */

        function pmeta:GetUserGroup( )
            if ( self.IsIncognito and self:IsIncognito( ) ) and ( access:bIsDev( self ) ) then
                return 'superadmin'
            end

            return self:GetNWString( 'UserGroup', 'user' )
        end

    end )
end
hook.Add( 'InitPostEntity', 'pmeta_loader', pmeta_loader )

/*
 	emeta > what > get
*/

function emeta:what( bEID )
    if not self:IsValid( ) then return end
    return ( bEID and self:EntIndex( ) or self:GetClass( ) ) or 0
end

/*
 	emeta > generate id
*/

function emeta:gid( suffix, bUseEntID )
    if not self:IsValid( ) then return end
    local id = ( bUseEntID and self:EntIndex( ) ) or self:GetClass( )
    return string.format( '%s.%s', suffix, tostring( id ) )
end

/*
    emeta > association id
*/

function emeta:aid( ... )
    if not helper.ok.ent( self ) then return end

    local cl            = self:what( true )
    local args          = { ... }

    table.insert        ( args, cl )

    local resp          = table.concat( args, '_' )
    resp                = resp:lower( )
    resp                = resp:gsub( '[%p%c]', '.' )
    resp                = resp:gsub( '[%s]', '_' )

    return resp
end

/*
    rclr > valid hex
*/

function rclr.bHex( val )
    if not isstring( val ) then return false end
    return ( val:match '^#?%x%x%x$' or val:match '^#?%x%x%x%x%x%x$' ) ~= nil
end

/*
    globals > Hex to RGB
*/

function rclr.Hex2RGB( hex, a )
    hex         = hex:gsub( '#', '' )
                if not rclr.bHex( hex ) then return end

    a           = isnumber( a ) and a or 255

    if hex:len( ) == 3 then
        return tonumber( '0x' .. hex:sub( 1, 1 ) ) * 17, tonumber( '0x' .. hex:sub( 2, 2 ) ) * 17, tonumber( '0x' .. hex:sub( 3, 3 ) ) * 17, a
    elseif hex:len( ) == 6 then
        return tonumber( '0x' .. hex:sub( 1, 2 ) ), tonumber( '0x' .. hex:sub( 3, 4 ) ), tonumber( '0x' .. hex:sub( 5, 6 ) ), a
    else
        return 255, 255, 255, a
    end
end

/*
    globals > RGB to Hex
*/

function rclr.RGB2Hex( rgb, bNoClean )
    local hexdec        = '0X'
    local alpha         = 255

    if not istable( rgb ) and not IsColor( rgb ) then return end

    if IsColor( rgb ) then
        rgb = { rgb.r, rgb.g, rgb.b, rgb.a or alpha }
    end

    for k, v in pairs( rgb ) do
        local hex       = ''
        alpha           = k == 4 and v or alpha

        if k == 4 then continue end -- alpha

        while ( v > 0 ) do
            local ind       = math.fmod( v, 16 ) + 1
            v               = math.floor( v / 16 )
            local substr    = '0123456789ABCDEF'
            hex             = substr:sub( ind, ind ) .. hex
        end

        hex                 = ( hex:len( ) == 0 and '00' ) or ( hex:len( ) == 1 and '0' .. hex ) or hex
        hexdec              = hexdec .. hex
    end

    if not bNoClean then
        hexdec              = hexdec:gsub( '0X', '' )
    end

    return hexdec, alpha
end

/*
    globals > Hex

    supports Hex values and RGBA color table
*/

function rclr.Hex( clr, a )
    if IsColor( clr ) then
        return clr
    end

    if not rclr.bHex( clr ) then
        base:log( RLIB_LOG_ERR, 'Hex > invalid hex specified [ %s ]', tostring( clr ) )
        return Color( 255, 255, 255, 255 )
    end

    clr = helper.str:clean( clr, true )

    local r, g, b, a = rclr.Hex2RGB( clr, a )
    return Color( r, g, b, a )
end

if not isfunction( Hex ) then
    Hex = rclr.Hex
end

/*
    globals > Hex > internal

    returns RGBA color table but in a structure that supports things such as
    surface.SetDrawColor( 255, 255, 255, 255 )
*/

function rclr.HexObj( hex, a )
    if not rclr.bHex( hex ) then
        base:log( RLIB_LOG_ERR, 'Hex > invalid hex specified [ %s ]', tostring( hex ) )
        return 255, 255, 255, 255
    end

    local r, g, b, a = rclr.Hex2RGB( hex, a )
    return r, g, b, a
end

/*
    globals > table > getmax
*/

function table.GetMax( tbl )
    local val, pos = 0
    for k, v in pairs( tbl ) do
        if val <= v then
            val, pos = v, k
        end
    end
    return val, pos
end

/*
    scaling
*/

if CLIENT then

    /*
        scale > screen > width
    */

    function rfs.ScrW( )
        local w = ScrW( )
        if w > 3840 then w = 3840 end
        return w
    end

    /*
        scale > screen > height
    */

    function rfs.ScrH( )
        local h = ScrH( )
        if h > 2160 then h = 2160 end
        return h
    end

    /*
        scale > width

        @param  : dec, int, int
    */

    function rfs.w( mult, min, max )
        local baseSize, bSizeOnly = 0, false
        if isnumber( mult ) and math.floor( mult ) ~= 0 then
            bSizeOnly, baseSize = true, mult
        end

        mult            = ( not bSizeOnly and mult ) or 0.40
        local size      = mult * ( rfs.ScrW( ) / 640.0 )

        if min then
            size        = calc.min( min, size )
        end

        if max then
            size        = calc.max( max, size )
        end

        if bSizeOnly and baseSize then
            size = baseSize * size
        end

        return size
    end

    /*
        scale > height

        @param  : dec, int, int
    */

    function rfs.h( mult, min, max )
        local baseSize, bSizeOnly = 0, false
        if isnumber( mult ) and math.floor( mult ) ~= 0 then
            bSizeOnly, baseSize = true, mult
        end

        mult            = ( not bSizeOnly and mult ) or 0.45
        local size      = mult * ( rfs.ScrH( ) / 480.0 )

        if min then
            size        = calc.min( min, size )
        end

        if max then
            size        = calc.max( max, size )
        end

        if bSizeOnly and baseSize then
            size = baseSize * size
        end

        return size
    end

    /*
        scale

        used for fonts

        @ex :   local fs = RLS( )
                fs * font_size

        @param  : dec
    */

    function rfs.scale( mult )
        mult            = mult or 0.45
        return mult * ( rfs.ScrW( ) / 640.0 )
    end

    /*
        deprecate
    */

    function RSW( )
        local wid = ScrW( )
        if wid > 3840 then wid = 3840 end
        return wid
    end

    function RSH( )
        local hgt = ScrH( )
        if hgt > 2160 then hgt = 2160 end
        return hgt
    end

    function RScale( size )
        return size * ( RSW( ) / 640.0 )
    end
end

/*
    loadstring
*/

function loadstring( code, path )
    path        = path or '=(load)'
    local f     = CompileString( code, path, false )

    if type( f ) == 'function' then
       return f
    else
       return nil, f
    end
 end
 load = loadstring

/*
    get arg
*/

function __GetArg( args, id, alt )
    if not istable( args ) and not isstring( args ) then return false end
    if not isnumber( id ) then
        id = 1
    end

    alt = isstring( alt ) and alt or false

    return args[ id ] or alt
 end

/*
    globals > ents.Create ( alias )
*/

ents.new = ents.Create

/*
    resources :: register
*/

function res:register( parent, id, src, bPrecache )
    if not parent.manifest.resources or not istable( parent.manifest.resources ) then
        base:log( 2, 'missing resources definition table -- aborting' )
        return
    end

    if not src or not istable( src ) then
        base:log( 6, 'cannot load resources without valid table' )
        return
    end

    for _, v in pairs( parent.manifest.resources ) do

        local call_type = v:lower( )
        if not src[ call_type ] then
            src[ call_type ] = { }
        end

        for l, m in pairs( src[ call_type ] ) do
            base._res[ call_type ]              = base._res[ call_type ] or { }
            base._res[ call_type ][ id ]        = base._res[ call_type ][ id ] or { }
            base._res[ call_type ][ id ][ l ]   = { tostring( m[ 1 ] ), m[ 2 ] and tostring( m[ 2 ] ) or ln( 'res_no_desc' ) }

            if bPrecache then
                if call_type == 'snd' then
                    if isstring( m[ 1 ] ) then
                        base.register:sound( m[ 1 ] )
                    end
                elseif call_type == 'ptc' then
                    if isstring( m[ 1 ] ) then
                        rlib.register:particle( m[ 1 ] )
                    end
                elseif call_type == 'mdl' then
                    if isstring( m[ 1 ] ) then
                        rlib.register:model( m[ 1 ] )
                    end
                end
            end

            sys.resources = ( sys.resources or 0 ) + 1
        end

    end
end

/*
    resources :: validation
*/

function res:valid( mod, t )
    if not t or not isstring( t ) or t == '' then
        base:log( 2, 'missing specified call type' )
        local resp, cnt_calls, i = '', #base._res, 0
        for k, v in pairs( base._res ) do
            resp = resp .. k
            i = i + 1
            if i < cnt_calls then
                resp = resp .. ', '
            end
        end
        base:log( 2, 'valid types are [ %s ]', resp )
        return
    end

    local data = base._res[ t ]
    if not data then
        base:log( 2, 'missing resource type » [ %s ]', t )
        return
    end

    return data or false
end

/*
    resources :: exists
*/

function res:exists( mod, t, s, ... )
    local data = res:valid( mod, t )
    if not data then return end

    if not isstring( s ) then
        base:log( 2, 'id missing » [ %s ]', t )
        return false
    end

    mod     = ( isstring( mod ) and istable( rcore.modules[ mod ] ) and rcore.modules[ mod ] ) or ( istable( mod ) and mod )
    s       = s:gsub( '[%p%c%s]', '_' ) -- replace punct, contrl chars, and whitespace with underscores

    local ret = string.format( s, ... )
    if istable( mod ) then
        if data and data[ mod.id ] and data[ mod.id ][ s ] then
            ret = string.format( data[ mod.id ][ s ][ 1 ], ... )
        end
    else
        ret = nil
    end

    return ret
end

/*
    resources :: get
*/

function res:get( t, s )
    local data = self:valid( t )
    if not data then return end

    if s and data[ s ] then
        return data[ s ]
    else
        return data
    end

    return
end

/*
    storage > data > set
*/

function storage:Set( mod, id, val )
    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] ) then
        rcore.modules[ mod ][ id ] = val
    elseif istable( mod ) then
        mod[ id ] = val
    end
end

/*
    storage > data > get
*/

function storage:Get( mod, id )
    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] ) then
        return rcore.modules[ mod ][ id ] or false
    elseif istable( mod ) then
        return mod[ id ] or false
    end
end

/*
    storage > data > clear
*/

function storage:Clear( mod, id )
    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] ) then
        rcore.modules[ mod ][ id ] = nil
    elseif istable( mod ) then
        mod[ id ] = nil
    end
end

/*
    storage > garbage
*/

function storage.garbage( id, trash )
    id = id or ln( 'unknown' )

    if not trash or not istable( trash ) then
        base:log( 2, ln( 'garbage_err', id ) )
        return
    end

    local i = 0
    for _, v in pairs( trash ) do
        v = nil
        i = i + 1
    end

    base:log( 6, ln( 'garbage_cleaned', i, id ) )
end

/*
    storage > exists
*/

function storage.exists( path )
    return file.Exists( mf.paths[ path ] or path, 'DATA' ) and true or false
end

/*
    storage > dir > create
*/

function storage.dir.create( name, path )
    name = name or storage.mft:getpath( 'base' )
    path = path or 'DATA'
    if not file.Exists( name, path ) then
        file.CreateDir( name )
        base:log( RLIB_LOG_DEBUG, '+ dir » [ %s ]', name )
    end
end

/*
    storage > dir > new structure
*/

function storage.dir.newstruct( parent, sub, sub2 )

    if CLIENT then return end

    if not parent then
        base:log( 6, ln( 'datafolder_missing' ) )
        return false
    end

    local fol_parent = tostring( parent )

    if not helper:bIsAlphaNum( fol_parent ) then
        base:log( 2, ln( 'datafolder_inv_chars' ) )
        return false
    end

    if not file.Exists( fol_parent, 'DATA' ) then
        file.CreateDir( fol_parent )
        base:log( 6, ln( 'datafolder_add', fol_parent ) )
    end

    if not sub then return end

    local fol_sub = tostring( sub )

    if not helper:bIsAlphaNum( fol_sub ) then
        base:log( 2, ln( 'datafolder_sub_inv_chars' ) )
        return false
    end

    if not file.Exists( fol_parent .. '/' .. fol_sub, 'DATA' ) then
        file.CreateDir( fol_parent .. '/' .. fol_sub )
        base:log( 6, ln( 'datafolder_sub_add', fol_sub ) )
    end

    if not sub2 then return end

    local fol_sub2 = tostring( sub2 )

    if not helper:bIsAlphaNum( fol_sub2 ) then
        base:log( 2, ln( 'datafolder_sub_inv_chars' ) )
        return false
    end

    if not file.Exists( fol_parent .. '/' .. fol_sub .. '/' .. fol_sub2, 'DATA' ) then
        storage.dir.create( fol_parent .. '/' .. fol_sub .. '/' .. fol_sub2 )
        base:log( 6, ln( 'datafolder_sub_add', fol_sub2 ) )
    end

end

/*
    storage > json > new
*/

function storage.json.new( path )
    if not isstring( path ) then return end
    if storage.exists( path ) then return end

    file.Write( path, util.TableToJSON( { } ) )
end

/*
    storage > json > write
*/

function storage.json.write( path, data )
    if not isstring( path ) then return end

    data        = istable( data ) and data or { }
    local json  = util.TableToJSON( data )

    file.Write( path, json )
end

/*
    storage > json > read
*/

function storage.json.read( path, errmsg )
    if not storage.exists( path, 'DATA' ) then
        base:log( 6, errmsg or 'cannot read missing data file' )
        return
    end

    local data = util.JSONToTable( file.Read( path, 'DATA' ) )

    return data or nil
end

/*
    storage > json > valid
*/

function storage.json.valid( data, id )
    if not istable( data ) then return false end
    id = isstring( id ) and id or 'pos'

    return ( data and data[ 1 ] and data[ 1 ][ id ] ) or ( data and data[ id ] and true ) or false
end

/*
    storage > manifest > get
*/

function storage.mft:getpath( id )
    if not id or ( not mf.paths[ id ] and not storage.exists( id ) ) then id = mf.paths[ 'bin' ] end
    id = isstring( mf.paths[ id ] ) and mf.paths[ id ] or id

    return id
end

/*
    storage > file > del
*/

function storage.file.del( src )
    if not src or ( not mf.paths[ src ] and not storage.exists( src ) ) then return end
    src = isstring( mf.paths[ src ] ) and mf.paths[ src ] or src

    if storage.exists( src ) then
        file.Delete( src )
        return true
    end
    return false
end

/*
    storage > file > append
*/

function storage.file.append( name, target, data, path )
    if CLIENT then return end

    name = name or storage.mft:getpath( 'base' )
    path = path or 'DATA'

    if not target then
        base:log( 2, 'cannot append without filename' )
        return
    end

    if not data then
        base:log( 2, 'cannot append blank data' )
        return
    end

    if not file.Exists( name, path ) then
        storage.dir.create( name, path )
    end

    if file.Exists( name, path ) then
        file.Append( name .. '/' .. target, data )
        file.Append( name .. '/' .. target, '\r\n' )
    end
end

/*
    storage > data > manifest
*/

function storage.data.manifest( path )
    if not path then return end

    local src = isstring( mf.paths[ path ] ) and mf.paths[ path ] or path
    local ext = src:match( '^.+(%..+)$' )

    if ext then
        base:log( 2, 'manifest file or filename specified » not a folder » [ %s ]', src )
        return false
    end

    if not storage.exists( src ) then
        file.CreateDir( mf.paths[ path ] or path )
        base:log( RLIB_LOG_DEBUG, '+ dir [ %s ]', path )
    end
end

/*
    storage > data > recursive loading
*/

function storage.data.recurv( name, path, loc )
    if CLIENT then return end

    name = name or storage.mft:getpath( 'base' )

    if not path then
        base:log( 6, 'cannot add resource files without path » %s', tostring( name ) )
        return false
    end

    loc = loc or 'LUA'

    local files, folders = file.Find( path .. '/*', loc )

    /*
        add folders
    */

    for _, v in pairs( folders ) do
        storage.data.recurv( name, path .. '/' .. v, loc )
    end

    /*
        add files
    */

    for _, v in pairs( files ) do
        resource.AddFile( path .. '/' .. v )
        base:log( RLIB_LOG_FASTDL, '+ %s » [ %s ]', tostring( name ), v )
    end
end

/*
    storage > data > get
*/

function storage.data.get( mod, id, fi, bCombine, bReadOnly )
    local parent, sub, txt
    local data = mod and mod.datafolder and mod.datafolder[ id ] or nil

    if not istable( data ) then
        base:log( 2, '[ %s ] datafolder id %s does not exist, misspelled, or missing datafolder in manifest\n\n%s', ( mod.id or 'unknown mod' ), tostring( id ), debug.traceback( ) )
        return
    end

    if not isstring( data.parent ) then
        base:log( 2, '[ %s ] data found but missing parent folder', ( mod.id or 'unknown mod' ) )
        return
    end

    if not isstring( data.sub ) then
        base:log( 2, '[ %s ] data found but missing sub folder', ( mod.id or 'unknown mod' ) )
        return
    end

    /*
        define > MODULE.datafolder[ parent ]
    */

    if data.parent then
        parent = data.parent
    end

    /*
        define > MODULE.datafolder[ sub ]
    */

    if data.sub then
        sub = data.sub
    end

    /*
        define > MODULE.datafolder[ file ]
    */

    if not fi and data.file then
        txt = data.file
    end

    /*
        define > custom file.txt if defined as param
    */

    if fi then
        txt = fi
    end

    /*
        check > parent folder blank
    */

    if not parent then
        base:log( 2, '[ %s ] error attempting to gather datafolder parent -- will not continue', ( mod.id or 'unknown mod' ) )
        return
    end

    /*
        create parent and sub folder (not file)
    */

    storage.dir.newstruct( parent, sub )

    /*
        create full path
    */

    local full_path = string.format( '%s/%s/%s.txt', parent, sub, txt )

    /*
        create file if not exists
    */

    if not bReadOnly then
        storage.json.new( full_path )
    end

    /*
        return
    */

    return ( not bReadOnly and bCombine and full_path ) or parent, sub, txt
end

/*
    storage > data > read
*/

function storage.data.read( mod, id, fi, bCombine )
    local parent, sub, txt
    local data = mod and mod.datafolder and mod.datafolder[ id ] or nil

    if not istable( data ) then
        base:log( 2, '[ %s ] datafolder id %s does not exist, misspelled, or missing datafolder in manifest\n\n%s', ( mod.id or 'unknown mod' ), tostring( id ), debug.traceback( ) )
        return
    end

    if not isstring( data.parent ) then
        base:log( 2, '[ %s ] data found but missing parent folder', ( mod.id or 'unknown mod' ) )
        return
    end

    if not isstring( data.sub ) then
        base:log( 2, '[ %s ] data found but missing sub folder', ( mod.id or 'unknown mod' ) )
        return
    end

    /*
        define > MODULE.datafolder[ parent ]
    */

    if data.parent then
        parent = data.parent
    end

    /*
        define > MODULE.datafolder[ sub ]
    */

    if data.sub then
        sub = data.sub
    end

    /*
        define > MODULE.datafolder[ file ]
    */

    if not fi and data.file then
        txt = data.file
    end

    /*
        define > custom file.txt if defined as param
    */

    if fi then
        txt = fi
    end

    /*
        check > parent folder blank
    */

    if not parent then
        base:log( 2, '[ %s ] error attempting to gather datafolder parent -- will not continue', ( mod.id or 'unknown mod' ) )
        return
    end

    /*
        create parent and sub folder (not file)
    */

    storage.dir.newstruct( parent, sub )

    /*
        create full path
    */

    local full_path = string.format( '%s/%s/%s.txt', parent, sub, txt )

    /*
        return
    */

    return ( bCombine and full_path ) or parent, sub, txt
end

/*
    storage > ent > get
*/

function storage.ent:get( mod, id )
    return mod and mod.ents and mod.ents[ id ] or nil
end

/*
    storage > ent > data
*/

function storage.ent:datafolder( mod, ent, sub2 )
    local parent, sub, txt
    local data          = mod and mod.ents and mod.ents[ ent ] and ( mod.ents[ ent ].data or mod.ents[ ent ].data_id ) or nil
    local ent_data      = mod and mod.ents and mod.ents[ ent ] or nil

    if data and ( mod and mod.datafolder and mod.datafolder[ data ] ) then
        data = mod.datafolder[ data ]
    end

    if not istable( data ) then
        base:log( 2, '[ %s ] ent %s data missing. make sure MODULE.ents[ entry ] has data_id value \n\n%s', ( mod.id or 'unknown mod' ), ent, debug.traceback( ) )
        return
    end

    if not isstring( data.parent ) then
        base:log( 2, '[ %s ] data found but missing parent folder', ( mod.id or 'unknown mod' ) )
        return
    end

    if not isstring( data.sub ) then
        base:log( 2, '[ %s ] data found but missing sub folder', ( mod.id or 'unknown mod' ) )
        return
    end

    /*
        define > MODULE.datafolder[ parent ]
    */

    if data.parent then
        parent = data.parent
    end

    /*
        define > MODULE.datafolder[ sub ]
    */

    if data.sub then
        sub = data.sub
    end

    /*
        define > MODULE.datafolder[ file ]
    */

    if not sub2 and data.file then
        txt = data.file
    end

    /*
        define > custom file.txt if defined as param
    */

    if sub2 then
        txt = string.format( '%s/%s', sub2, data.file )
    end

    /*
        check > parent folder blank
    */

    if not parent then
        base:log( 2, '[ %s ] error attempting to gather datafolder parent -- will not continue', ( mod.id or 'unknown mod' ) )
        return
    end

    /*
        create parent and sub folder (not file)
    */

    if sub2 then
        storage.dir.newstruct( parent, sub, sub2 )
    else
        storage.dir.newstruct( parent, sub )
    end

    /*
        create data file
    */

    local full_path = string.format( '%s/%s/%s.txt', parent, sub, txt )
    storage.json.new( full_path )

    return parent, sub, txt, ent_data
end

/*
    storage > ent > id
*/

function storage.ent.id( mod, id )
    return ( mod and mod.ents and mod.ents[ id ] and ( mod.ents[ id ].ent or mod.ents[ id ].id ) ) or nil
end

/*
    storage > ent > model
*/

function storage.ent.mdl( mod, id )
    return ( mod and mod.ents and mod.ents[ id ] and ( mod.ents[ id ].model or mod.ents[ id ].mdl ) ) or nil
end

/*
    storage > ent > locate
*/

function storage.ent.locate( mod, id )
    local bFound = false
    for k, v in pairs( mod.ents ) do
        if v.ent == id then
            v.id = k
            bFound = v
            break
        end
    end

    return bFound
end

/*
    storage > glon > get
*/

function storage.glon.get( mod, id, fi, bCombine, bReadOnly )
    if not glon then
        base:log( 2, ln( 'glon_missing' ) )
        return
    end

    local parent, sub, txt
    local data = mod and mod.datafolder and mod.datafolder[ id ] or nil

    if not istable( data ) then
        base:log( 2, '[ %s ] [ glon ] datafolder id %s does not exist, misspelled, or missing datafolder in manifest\n\n%s', ( mod.id or 'unknown mod' ), tostring( id ), debug.traceback( ) )
        return
    end

    if not isstring( data.parent ) then
        base:log( 2, '[ %s ] [ glon ] data found but missing parent folder', ( mod.id or 'unknown mod' ) )
        return
    end

    if not isstring( data.sub ) then
        base:log( 2, '[ %s ] [ glon ] data found but missing sub folder', ( mod.id or 'unknown mod' ) )
        return
    end

    /*
        define > MODULE.datafolder[ parent ]
    */

    if data.parent then
        parent = data.parent
    end

    /*
        define > MODULE.datafolder[ sub ]
    */

    if data.sub then
        sub = data.sub
    end

    /*
        define > MODULE.datafolder[ file ]
    */

    if not fi and data.file then
        txt = data.file
    end

    /*
        define > custom file.txt if defined as param
    */

    if fi then
        txt = fi
    end

    /*
        check > parent folder blank
    */

    if not parent then
        base:log( 2, '[ %s ] [ glon ] error attempting to gather datafolder parent -- will not continue', ( mod.id or 'unknown mod' ) )
        return
    end

    /*
        create parent and sub folder (not file)
    */

    storage.dir.newstruct( parent, sub )

    /*
        create data file
    */

    local full_path = string.format( '%s/%s/%s.txt', parent, sub, txt )

    /*
        create file if not exists
    */

    if not bReadOnly then
        storage.glon.new( full_path )
    end

    /*
        return
    */

    return ( not bReadOnly and bCombine and full_path ) or parent, sub, txt
end

/*
    storage > glon > new
*/

function storage.glon.new( path )
    if not isstring( path ) then return end
    if storage.exists( path ) then return end

    local data = { }
    file.Write( path, glon.encode( data ) )
end

/*
    storage > glon > save
*/

function storage.glon.save( data, path )
    if not glon then
        base:log( 2, ln( 'glon_missing' ) )
        return
    end

    if not istable( data ) then
        base:log( 2, ln( 'glon_save_err_data' ) )
        return
    end

    if not isstring( path ) then
        base:log( 2, 'cannot save glon data -- missing valid path' )
        return
    end

    file.Write( path, glon.encode( data ) )

    base:log( 6, ln( 'glon_save', path ) )
end

/*
    storage > glon > read
*/

function storage.glon.read( path )
    if not glon then
        base:log( 2, ln( 'glon_missing' ) )
        return false
    end

    if not isstring( path ) then
        base:log( 2, 'cannot read glon data -- missing valid path' )
        return false
    end

    if not file.Exists( path, 'DATA' ) then
        base:log( 2, ln( 'glon_err_path', path ) )
        return false
    end

    local data = file.Read( path, 'DATA' )
    if not data or data == '[]' then
        base:log( 2, 'invalid glon data referenced -- resetting' )
        file.Delete( path, 'DATA' )
    end

    local decode = data and glon.decode( data ) or nil

    return decode
end

/*
    base > has dependency
*/

function base.modules:bInstalled( mod )
    if not mod then
        base:log( RLIB_LOG_DEBUG, 'dependency not specified\n%s', debug.traceback( ) )
        return false
    end

    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].enabled ) then
        return true
    elseif istable( mod ) and mod.enabled then
        return true
    elseif istable( mod ) then
        return true
    end

    mod = isstring( mod ) and mod or 'unknown'
    base:log( RLIB_LOG_DEBUG, 'error loading required dependency [ %s ]\n%s', mod, debug.traceback( ) )

    return false
end

/*
    base > module > exists
*/

function base.modules:bExists( mod )
    if not mod then return false end
    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].enabled ) then
        return true
    elseif istable( mod ) then
        return true
    end

    return false
end

/*
    base > module > alpha
*/

function base.modules:bIsAlpha( mod )
    if not mod then return false end
    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and ( rcore.modules[ mod ].build == 1 ) ) then
        return true
    elseif istable( mod ) and ( mod.build == 1 ) then
        return true
    end

    return false
end

/*
    base > module > beta
*/

function base.modules:bIsBeta( mod )
    if not mod then return false end
    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and ( rcore.modules[ mod ].build == 2 ) ) then
        return true
    elseif istable( mod ) and ( mod.build == 2 ) then
        return true
    end

    return false
end

/*
    modules > get build
*/

function base.modules:Build( mod )
    if not mod then return false end

    local build
    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] ) then
        local resp  = rcore.modules[ mod ].build or 0
        build       = resp
    elseif istable( mod ) then
        local resp  = mod.build or 0
        build       = resp
    end

    if not build then return base._def.builds[ 0 ] end

    return base._def.builds[ build ]
end

/*
    base > module > build
*/

function base.modules:build( mod )
    if not mod then return false end

    local build
    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].build ) then
        build       = rcore.modules[ mod ].build
    elseif istable( mod ) and mod.build then
        build       = mod.build or 0
    end

    if not build then return base._def.builds[ 0 ] end

    return base._def.builds[ build ]
end

/*
    module > version
*/

function base.modules:ver( mod )
    if not mod then
        return {
            [ 'major' ] = 1,
            [ 'minor' ] = 0,
            [ 'patch' ] = 0,
            [ 'micro' ] = 0,
            [ 'build' ] = 0,
        }
    end
    if isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].version then
        if isstring( rcore.modules[ mod ].version ) then
            local ver       = string.Explode( '.', rcore.modules[ mod ].version )
            local build     = rcore.modules[ mod ].build or 0
            return {
                [ 'major' ] = ver[ 'major' ] or ver[ 1 ] or 1,
                [ 'minor' ] = ver[ 'minor' ] or ver[ 2 ] or 0,
                [ 'patch' ] = ver[ 'patch' ] or ver[ 3 ] or 0,
                [ 'micro' ] = ver[ 'micro' ] or ver[ 4 ] or 0,
                [ 'build' ] = build,
            }
        elseif istable( rcore.modules[ mod ].version ) then
            return {
                [ 'major' ] = rcore.modules[ mod ].version.major or rcore.modules[ mod ].version[ 1 ] or 1,
                [ 'minor' ] = rcore.modules[ mod ].version.minor or rcore.modules[ mod ].version[ 2 ] or 0,
                [ 'patch' ] = rcore.modules[ mod ].version.patch or rcore.modules[ mod ].version[ 3 ] or 0,
                [ 'micro' ] = rcore.modules[ mod ].version.micro or rcore.modules[ mod ].version[ 4 ] or 0,
                [ 'build' ] = rcore.modules[ mod ].build or 0,
            }
        end
    elseif istable( mod ) and mod.version then
        if isstring( mod.version ) then
            local ver       = string.Explode( '.', mod.version )
            local build     = mod.build or 0
            return {
                [ 'major' ] = ver[ 'major' ] or ver[ 1 ] or 1,
                [ 'minor' ] = ver[ 'minor' ] or ver[ 2 ] or 0,
                [ 'patch' ] = ver[ 'patch' ] or ver[ 3 ] or 0,
                [ 'micro' ] = ver[ 'micro' ] or ver[ 4 ] or 0,
                [ 'build' ] = build or 0,
            }
        elseif istable( mod.version ) then
            return {
                [ 'major' ] = mod.version.major or mod.version[ 1 ] or 1,
                [ 'minor' ] = mod.version.minor or mod.version[ 2 ] or 0,
                [ 'patch' ] = mod.version.patch or mod.version[ 3 ] or 0,
                [ 'micro' ] = mod.version.micro or mod.version[ 4 ] or 0,
                [ 'build' ] = mod.build or 0,
            }
        end
    end
    return {
        [ 'major' ] = 1,
        [ 'minor' ] = 0,
        [ 'patch' ] = 0,
        [ 'micro' ] = 0,
        [ 'build' ] = 0,
    }
end

/*
    base > module > get list
*/

function base.modules:list( )
    if not rcore.modules then
        base:log( 2, 'modules table missing\n%s', debug.traceback( ) )
        return false
    end

    return rcore.modules
end

/*
    base > module > list > formatted
*/

function base.modules:listf( )
    local lst, i = { }, 1
    for k, v in SortedPairs( self:list( ) ) do
        if not v.enabled then continue end

        lst[ i ]    = k
        i           = i + 1
    end

    local resp  = table.concat( lst, ', ' )
    resp        = resp:sub( 1, -1 )

    return resp
end

/*
    module > version to str
*/

function base.modules:ver2str( mod )
    if not mod then return '1.0.0.0 stable' end

    if isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].version then
        if isstring( rcore.modules[ mod ].version ) then
            return rcore.modules[ mod ].version
        elseif istable( rcore.modules[ mod ].version ) then
            local major, minor, patch, micro, build = rcore.modules[ mod ].version.major or rcore.modules[ mod ].version[ 1 ] or 1, rcore.modules[ mod ].version.minor or rcore.modules[ mod ].version[ 2 ] or 0, rcore.modules[ mod ].version.patch or rcore.modules[ mod ].version[ 3 ] or 0, rcore.modules[ mod ].version[ 4 ] or 0, rcore.modules[ mod ].build or 0
            return string.format( '%i.%i.%i.%i %s', major, minor, patch, micro, base._def.builds[ build ] )
        end
    elseif istable( mod ) and mod.version then
        if isstring( mod.version ) then
            return mod.version
        elseif istable( mod.version ) then
            local major, minor, patch, micro, build = mod.version.major or mod.version[ 1 ] or 1, mod.version.minor or mod.version[ 2 ] or 0, mod.version.patch or mod.version[ 3 ] or 0, mod.version.micro or mod.version[ 4 ] or 0, mod.build or 0
            return string.format( '%i.%i.%i.%i %s', major, minor, patch, micro, base._def.builds[ build ] )
        end
    end

    return '1.0.0.0 stable'
end

/*
    module > version to str > simple
*/

function base.modules:ver2str_s( mod )
    if not mod then return '1.0.0.0' end

    if isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].version then
        if isstring( rcore.modules[ mod ].version ) then
            return rcore.modules[ mod ].version
        elseif istable( rcore.modules[ mod ].version ) then
            local major, minor, patch, micro = rcore.modules[ mod ].version.major or rcore.modules[ mod ].version[ 1 ] or 1, rcore.modules[ mod ].version.minor or rcore.modules[ mod ].version[ 2 ] or 0, rcore.modules[ mod ].version.patch or rcore.modules[ mod ].version[ 3 ] or 0, rcore.modules[ mod ].version.micro or rcore.modules[ mod ].version[ 4 ] or 0
            return string.format( '%i.%i.%i.%i', major, minor, patch, micro )
        end
    elseif istable( mod ) and mod.version then
        if isstring( mod.version ) then
            return mod.version
        elseif istable( mod.version ) then
            local major, minor, patch, micro = mod.version.major or mod.version[ 1 ] or 1, mod.version.minor or mod.version[ 2 ] or 0, mod.version.patch or mod.version[ 3 ] or 0, mod.version.micro or mod.version[ 4 ] or 0
            return string.format( '%i.%i.%i.%i', major, minor, patch, micro )
        end
    end

    return '1.0.0.0'
end

/*
    base > module > get module
*/

function base.modules:get( mod )
    if not mod then
        base:log( 2, 'specified module not available\n%s', debug.traceback( ) )
        return false
    end

    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].enabled ) then
        return rcore.modules[ mod ]
    elseif istable( mod ) then
        return mod
    end

    mod = isstring( mod ) and mod or 'unknown'
    base:log( RLIB_LOG_DEBUG, 'error loading required dependency [ %s ]\n%s', mod, debug.traceback( ) )

    return false
end

/*
    base > module > get prefix
*/

function base.modules:prefix( mod, suffix )
    if not istable( mod ) then
        base:log( RLIB_LOG_DEBUG, 'warning: cannot create prefix with missing module in \n[ %s ]', debug.traceback( ) )
        return
    end

    suffix = suffix or ''

    return string.format( '%s%s.', suffix, mod.id )
end
base.modules.pf = base.modules.prefix

/*
    base > module > load module
*/

function base.modules:require( mod )
    local bLoaded = false
    if mod and rcore.modules[ mod ] and rcore.modules[ mod ].enabled then
        bLoaded = true
        return rcore.modules[ mod ], self:prefix( rcore.modules[ mod ] )
    end

    if not bLoaded then
        mod = mod or 'unknown'
        base:log( RLIB_LOG_DEBUG, 'missing module [ %s ]\n%s', mod, debug.traceback( ) )
        return false
    end
end
base.modules.req = base.modules.require

/*
    base > module > manifest
*/

function base.modules:Manifest( )
    local path      = storage.mft:getpath( 'data_modules' )
    local modules   = ''
    if file.Exists( path, 'DATA' ) then
        modules  = file.Read( path, 'DATA' )
    end

    return modules
end

/*
    base > module > ManifestList
*/

function base.modules:ManifestList( )
    local lst       = ''
    local i, pos    = table.Count( rcore.modules ), 1
    for k, v in SortedPairs( rcore.modules ) do
        local name      = v.name:gsub( '[%s]', '' )
        name            = name:lower( )

        local ver       = ( istable( v.version ) and rlib.get:ver2str_mfs( v, '_' ) ) or v.version
        ver             = ver:gsub( '[%p]', '' )

        local enabled   = v.enabled and "enabled" or "disabled"

        local sep =     ( i == pos and '' ) or '-'
        lst            = string.format( '%s%s_%s_%s%s', lst, name, ver, enabled, sep )

        pos             = pos + 1
    end

    return lst
end

/*
    base > module > registered panels
*/

function base.modules:RegisteredPnls( mod )
    local bLoaded = false
    if mod then
        if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] ) then
            return base.p[ mod ]
        elseif istable( mod ) then
            return base.p[ mod.id ]
        end
    end

    if not bLoaded then
        local mod_output = isstring( mod ) and mod or 'unspecified'
        base:log( RLIB_LOG_DEBUG, 'missing module [ %s ]\n%s', mod_output, debug.traceback( ) )
        return false
    end
end

/*
    base > module > log
*/

base.modules.log = rcore.log

/*
    base > module > get cfg
*/

function base.modules:cfg( mod )
    if not mod then
        base:log( RLIB_LOG_DEBUG, 'dependency not specified\n%s', debug.traceback( ) )
        return false
    end

    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].enabled ) then
        return rcore.modules[ mod ].settings
    elseif istable( mod ) then
        return mod.settings
    end

    mod = isstring( mod ) and mod or 'unknown'
    base:log( RLIB_LOG_DEBUG, 'error loading required dependency [ %s ]\n%s', mod, debug.traceback( ) )

    return false
end

/*
    base > module > ents
*/

function base.modules:ents( mod )
    if not mod then
        base:log( RLIB_LOG_DEBUG, 'dependency not specified\n%s', debug.traceback( ) )
        return false
    end

    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].enabled ) then
        return rcore.modules[ mod ].ents
    elseif istable( mod ) then
        return mod.ents
    end

    mod = istable( mod ) and mod or 'unknown'
    base:log( RLIB_LOG_DEBUG, 'error fetching entities for module [ %s ]\n%s', mod, debug.traceback( ) )

    return false
end

/*
    base > modules > sap
*/

function base.modules:sap( mod )
    if not mod then
        base:log( 6, 'dependency not specified\n%s', debug.traceback( ) )
        return false
    end

    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].enabled ) then
        return rcore.modules[ mod ].sap
    elseif istable( mod ) then
        return mod.sap
    end
end

/*
    base > module > count
*/

function base.modules:count( )
    return table.Count( rcore.modules ) or 0
end

/*
    concommand calls
*/

base.c.commands =
{
    [ _n ] =
    {
        enabled             = true,
        is_base             = true,
        id                  = _n,
        name                = 'Base command',
        desc                = 'base command, displays top-level help',
        args                = '[ <command> ], [ <-flag> <search_keyword> ]',
        scope               = 2,
        showsetup           = true,
        official            = true,
        ex =
        {
            _n,
            _n .. ' ' .. _c .. 'version',
            _n .. ' -a',
            _n .. ' -f ' .. _c .. 'version',
            _n .. ' -h ' .. _c .. 'version'
        },
        flags =
        {
            [ 'all' ]       = { flag = '-a',        desc = 'displays all cmds in console regardless of scope' },
            [ 'simple' ]    = { flag = '-s',        desc = 'get a more simplified command list' },
            [ 'filter' ]    = { flag = '-f',        desc = 'filter search results' },
            [ 'help' ]      = { flag = '-h',        desc = 'view help on specific command' },
            [ 'break' ]     = { flag = '-b',        desc = 'add breaks after each command' },
            [ 'modules' ]   = { flag = '-m',        desc = 'displays module commands only' },
        },
        notes =
        {
            'This command is the base command to all sub-levels'
        },
    },
    [ _p .. 'help' ] =
    {
        enabled             = true,
        id                  = _c .. 'help',
        name                = 'Help',
        desc                = 'help info for lib',
        scope               = 2,
        showsetup           = true,
        official            = true,
    },
    [ _p .. 'cs_new' ] =
    {
        enabled             = true,
        id                  = _c .. 'cs.new',
        name                = 'Checksum » New',
        desc                = 'write checksums and deploy lib',
        scope               = 1,
        official            = true,
        ex =
        {
            _c .. 'cs.new',
        },
        flags =
        {
            [ 'algorithm' ] = { flag = '-a', desc = 'algorithm to use (default: sha256)' },
        },
    },
    [ _p .. 'cs_now' ] =
    {
        enabled             = true,
        id                  = _c .. 'cs.now',
        name                = 'Checksum » Now',
        desc                = 'shows current checksums',
        args                = '[ <command> ], [ <-flag> <search_keyword> ]',
        scope               = 1,
        official            = true,
        ex =
        {
            _c .. 'cs.now',
        },
    },
    [ _p .. 'cs_obf' ] =
    {
        enabled             = true,
        id                  = _c .. 'cs.obf',
        name                = 'Checksum » Obf',
        desc                = 'Internal release prepwork',
        scope               = 1,
        official            = true,
        ex =
        {
            _c .. 'cs.obf',
        },
    },
    [ _p .. 'cs_verify' ] =
    {
        enabled             = true,
        id                  = _c .. 'cs.verify',
        name                = 'Checksum » Verify',
        desc                = 'checks the integrity of lib files',
        args                = '[ <command> ], [ <-flag> <search_keyword> ]',
        scope               = 1,
        official            = true,
        ex =
        {
            _c .. 'cs.verify',
            _c .. 'cs.verify -f rlib_core_sv',
        },
        flags =
        {
            [ 'all' ]       = { flag = '-a', desc = 'displays all results' },
            [ 'filter' ]    = { flag = '-f', desc = 'filter search results' },
        },
    },
    [ _p .. 'debug' ] =
    {
        enabled             = true,
        id                  = _c .. 'debug',
        name                = 'Debug',
        desc                = 'toggles debug mode on and off',
        scope               = 2,
        showsetup           = true,
        official            = true,
    },
    [ _p .. 'debug_status' ] =
    {
        enabled             = true,
        id                  = _c .. 'debug.status',
        name                = 'Debug » Status',
        desc                = 'status of debug mode',
        scope               = 2,
        official            = true,
    },
    [ _p .. 'debug_clean' ] =
    {
        enabled             = true,
        id                  = _c .. 'debug.clean',
        name                = 'Debug » Clean',
        desc                = 'erases all debug logs from server',
        scope               = 1,
        official            = true,
        ex =
        {
            _c .. 'debug.clean',
            _c .. 'debug.clean -c',
        },
        flags =
        {
            [ 'cancel' ]    = { flag = '-c', desc = 'cancel cleaning action' },
        },
    },
    [ _p .. 'debug_diag' ] =
    {
        enabled             = true,
        id                  = _c .. 'debug.diag',
        name                = 'Debug » Diagnostic',
        desc                = 'dev => production preparation',
        scope               = 1,
        showsetup           = true,
        official            = true,
        ex =
        {
            _c .. 'debug.diag',
        },
    },
    [ _p .. 'debug_devop' ] =
    {
        enabled             = true,
        id                  = _c .. 'debug.devop',
        name                = 'Debug » DevOP',
        desc                = 'devop hook (dev only)',
        scope               = 2,
        official            = true,
    },
    [ _p .. 'modules' ] =
    {
        enabled             = true,
        id                  = _c .. 'modules',
        name                = 'rcore modules',
        desc                = 'all rcore modules',
        scope               = 1,
        showsetup           = true,
        official            = true,
        ex =
        {
            _c .. 'modules',
            _c .. 'modules -p',
        },
        flags =
        {
            [ 'paths' ]     = { flag = '-p', desc = 'display module install paths' },
        },
    },
    [ _p .. 'rcc_rehash' ] =
    {
        enabled             = true,
        id                  = _c .. 'rcc.rehash',
        name                = 'Rehash RCC',
        desc                = 'refreshes registered command calls',
        scope               = 2,
        official            = true,
        ex =
        {
            _c .. 'rcc.rehash',
        },
    },
    [ _p .. 'restart' ] =
    {
        enabled             = true,
        id                  = _c .. 'restart',
        name                = 'Restart',
        desc                = 'server restart | Def: 30s',
        args                = '[ <seconds> ]',
        scope               = 1,
        official            = true,
        flags =
        {
            [ 'cancel' ]    = { flag = { '-c', 'cancel', '-cancel' }, desc = 'cancel restart' },
            [ 'instant' ]   = { flag = { '-i', 'instant', '-instant' }, desc = 'instant restart' },
        },
        ex =
        {
            _c .. 'restart',
            _c .. 'restart -c',
            _c .. 'restart -i',
        },
        notes =
        {
            'Can be cancelled with the command [ rlib.restart -c ]',
            'Default: 30 seconds',
            'Use rlib.restart -i for instant restart'
        },
    },
    [ _p .. 'setup' ] =
    {
        enabled             = true,
        id                  = _c .. 'setup',
        name                = 'Setup library',
        desc                = 'setup lib | should be ran at first install',
        pubc                = '!setup',
        scope               = 1,
        official            = true,
    },
}

/*
    rcc > base

    base concommand for lib which includes all help information and the ability to search for specific
    commands built into the library

    command to be used in console

    @usage  : rlib                        [displays full lib command list]
            : rlib <search_string>        [search for cmd help info]
            : rlib -h <search_string>     [search for cmd help info]
            : rlib -f <search_string>     [show only commands matching search string]

    @ex     : rlib rlib.version
            : rlib version
            : rlib -h version
*/

local function rcc_base( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', _n )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, script, ccmd.id )
        return
    end

    /*
        perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, script, ccmd.id )
        return
    end

    /*
        declarations
    */

    local arg_flag      = args and args[ 1 ] or false
    local arg_srch      = args and args[ 2 ] or nil

    local gcf_a         = base.calls:gcflag( _n, 'all'      )
    local gcf_f         = base.calls:gcflag( _n, 'filter'   )
    local gcf_h         = base.calls:gcflag( _n, 'help'     )
    local gcf_s         = base.calls:gcflag( _n, 'simple'   )
    local gcf_b         = base.calls:gcflag( _n, 'break'    )       -- adds a line break between commands
    local gcf_m         = base.calls:gcflag( _n, 'modules'  )       -- displays only commands related to modules

    local i_res         = 0
    local i_hidden      = 0

    /*
        declare
    */

    local res_k, res_f, res_i, res_c = nil, false, nil, nil

    /*
        check > minimum character amount

        @def    : ( min ) 4
    */

    if arg_flag and not helper.str:startsw( arg_flag, '-' ) and arg_flag:len( ) < 2 then
        con( pl, 1 )
        con( pl, clr_y, 'Help » ', clr_r, 'Too few characters\n' )
        con( pl, clr_w, '       Use at least ', clr_y, '2', clr_w, ' characters in your search term' )
        con( pl, clr_w, '       If using a ', clr_y, 'flag', clr_w, ', make sure it is valid.' )
        return
    end

    /*
        check > minimum character amount

        @def    : ( min ) 4
    */

    if helper.str:ok( arg_srch ) and arg_srch:len( ) < 2 then
        con( pl, 1 )
        con( pl, clr_y, 'Help » ', clr_r, 'Too few characters\n' )
        con( pl, clr_w, '       Use at least ', clr_y, '2', clr_w, ' characters in your search term' )
        con( pl, clr_w, '       If using a ', clr_y, 'flag', clr_w, ', make sure it is valid.' )
        return
    end

    /*
        check for a provided exact match in search arg
    */

    if ( arg_flag == gcf_h and arg_srch ) then
        res_k = arg_srch
    elseif arg_flag == gcf_h and ( not helper.str:ok( arg_srch ) ) then
        con( pl, 1 )
        con( pl, clr_y, 'Help » ', clr_w, 'no command specified' )
        con( pl, clr_w, '       type ', clr_y, script .. ' -h commandname', clr_w, ' for help on a particular command' )
        return
    elseif ( arg_flag and arg_flag ~= gcf_h ) then
        res_k = arg_flag
    end

    /*
        search command list for matching search string

        for rlib based commands; it supports both the full command
        as well as a string without [ rlib. ]

        Example:        rlib.setup OR setup
                        return the same result
    */

    for k, v in pairs( rlib.calls:get( 'commands' ) ) do
        local res_filtered = ( v.id and v.id:gsub( _c, '' ) ) or ( v[ 1 ] and v[ 1 ]:gsub( _c, '' ) )
        if res_k and ( ( res_k == res_filtered ) or ( res_k == v.id or res_k == v[ 1 ] ) ) then
            res_i, res_f = k, true
            if res_k == v[ 1 ] then
                res_i   = v[ 1 ]
                res_c   = k
            end
            break
        end
    end

    /*
        error > -f flag with no search string
    */

    if ( arg_flag == gcf_f and not arg_srch ) then
        con( pl, 1 )
        con( pl, clr_y, 'Help » ', clr_w, 'No search term specified' )
        con( pl, clr_w, '       type ', 'Syntax: ', clr_y, script .. ' ' .. gcf_f .. ' <search_keyword>' )
        return
    end

    /*
        error > invalid flag specified
    */

    if not res_f and arg_flag and helper.str:startsw( arg_flag, '-' ) and not base.calls:gcflag_valid( ccmd.id, arg_flag ) then
        local val_srch = arg_flag or 'unspecified'
        con( pl, 1 )
        con( pl, clr_y, 'Help » ', clr_r, val_srch, clr_w, ' is not a valid flag' )
        con( pl, clr_w, '       type ', clr_y, script, clr_w, ' for a list of registered commands' )
        con( pl, '' )
        return
    end

    /*
        error > no result but param
    */

    if not res_f and ( arg_flag and not base.calls:gcflag_valid( ccmd.id, arg_flag ) ) then
        local val_srch = arg_srch or arg_flag
        con( pl, 1 )
        con( pl, clr_y, 'Help » ', clr_r, '< ' .. val_srch .. ' >', clr_w, ' is not recognized as a valid command', '\n' )
        con( pl, clr_w, '       type ', clr_y, script, clr_w, ' for a list of valid commands' )

        return
    end

    /*
        output > specific command result

        output the result of the searched console command
        run this before anything else so we can keep annoying header prints from appearing for each and
        every command result which should only show at the top level
    */

    if res_f then
        local item      = base.calls:get( 'commands', res_i )
        local id        = ( item and item.id ) or res_i
        local desc      = ( item and item.desc ) or ( item and res_c and item[ res_c ][ 2 ] ) or 'no information provided'

        con( pl, 1 )
        con( pl, clr_y, 'Help', clr_p, ' » ', clr_y, 'Command', clr_p, ' » ', clr_w, id )
        con( pl, 0 )
        con( pl, clr_w, desc .. '\n' )

        /*
            command arguments
        */

        if item.args and item.args ~= '' then
            local a1_l              = sf( '%-15s',  'SYNTAX' )
            local a1_d              = sf( '%-35s',  '' )
            local a2_l              = sf( '%-5s',   '' )
            local a2_d              = sf( '%-35s',  '   ' .. item.args )

            con( pl, clr_y, a1_l, clr_w, a1_d )
            con( pl, clr_y, a2_l, clr_w, a2_d .. '\n' )
        end

        /*
            command is_base
        */

        if item.is_base then
            con( pl )

            local c1_l              = sf( '%-15s',  'BASE' )
            local c1_d              = sf( '%-35s',  '' )
            local c2_l              = sf( '%-5s',   '' )
            local c2_d              = sf( '%-35s',  '   This is the base command for ' .. script )

            con( pl, clr_p, c1_l, clr_w, c1_d )
            con( pl, clr_y, c2_l, clr_w, c2_d .. '\n' )
        end

        /*
            command scope
        */

        if isnumber( item.scope ) then
            local s1_l              = sf( '%-15s',  'SCOPE' )
            local s1_d              = sf( '%-35s',  '' )
            local s2_l              = sf( '%-5s',   '' )
            local s2_d              = sf( '%-35s',  '   ' .. base._def.scopes[ item.scope ] or 'unknown' )

            con( pl, clr_y, s1_l, clr_w, s1_d )
            con( pl, clr_y, s2_l, clr_w, s2_d .. '\n' )
        end

        /*
            command flags
        */

        if item.flags and istable( item.flags ) then
            local f1_l              = sf( '%-15s',  'FLAGS' )
            local f1_2              = sf( '%-35s',  '' )

            con( pl, clr_y, f1_l, clr_w, f1_2 )

            for v in helper.get.data( item.flags, SortedPairs ) do
                local i_flag        = istable( v.flag ) and v.flag[ 1 ] or v.flag or '-'
                local i_desc        = v.desc or 'no desc'

                local f1_d          = sf( '%-5s',   '' )
                local f2_d          = sf( '%-15s',  '   ' .. i_flag )
                local f3_d          = sf( '%-35s',  i_desc )
                local f1_c          = f1_d .. f2_d .. f3_d

                con( pl, clr_w, f1_c )
            end
            con( pl, clr_y, '' )
        end

        /*
            command examples
        */

        if item.ex and istable( item.ex ) then
            local x1_l = sf( '%-15s', 'EXAMPLES' )
            con( pl, clr_y, x1_l )
            for v in helper.get.data( item.ex, ipairs ) do
                local x1_d          = sf( '%-5s', '' )
                local x2_d          = sf( '%-35s', '   ' .. v )
                local x1_c          = x1_d .. x2_d

                con( pl, clr_w, x1_c )
            end
        end

        /*
            command notes
        */

        if item.notes and istable( item.notes ) then
            con( pl )

            local n1_l = sf( '%-15s', 'NOTES' )
            con( pl, clr_y, n1_l )
            for v in helper.get.data( item.notes, pairs ) do
                local n1_d          = sf( '%-5s', '' )
                local n2_d          = sf( '%-35s', '   ' .. v )
                local n1_c          = n1_d .. n2_d

                con( pl, clr_w, n1_c )
            end
        end

        /*
            command hiddem
        */

        if item.is_hidden then
            con( pl )

            local h1_l      = sf( '%-15s',      'HIDDEN' )
            local h2_l      = sf( '%-5s',       '' )
            local h1_d      = sf( '%-35s',      '' )
            local h2_d      = sf( '%-35s',      '   This command is hidden from the main directory list.' )

            con( pl, clr_r, h1_l, clr_w, h1_d )
            con( pl, clr_y, h2_l, clr_w, h2_d .. '\n' )
        end

        /*
            command warn
        */

        if item.warn then
            con( pl )

            local w1_l      = sf( '%-15s',      'WARNING' )
            local w2_l      = sf( '%-5s',       '' )
            local w1_d      = sf( '%-35s',      '' )
            local w2_d      = sf( '%-35s',      '   Only used at developers direction. Misuse may cause server / data damage.' )

            con( pl, clr_r, w1_l, clr_w, w1_d )
            con( pl, clr_y, w2_l, clr_w, w2_d .. '\n' )
        end

        /*
            command deny server-side execution
        */

        if item.no_console then
            con( pl )

            local c1_l      = sf( '%-15s',      'NOTICE' )
            local c2_l      = sf( '%-5s',       '' )
            local c1_d      = sf( '%-35s',      '' )
            local c2_d      = sf( '%-35s',      '   Command must have a valid player to execute. Server console cannot run.' )

            con( pl, clr_p, c1_l, clr_w, c1_d )
            con( pl, clr_y, c2_l, clr_w, c2_d .. '\n' )
        end

        con( pl, 0 )

        return false
    end

    /*
        output > header
    */

    local tbl_about = helper.str:wordwrap( mf.about, 90 )

    con( pl, 0 )
    con( pl, clr_y, script, clr_p, ' » ', clr_w, 'Help' )
    con( pl, 0 )

    for v in helper.get.data( tbl_about, pairs ) do
        con( pl, clr_w, v )
    end

    con( pl, 0 )

    /*
        output > search string

        displays the string being located if flag and search string provided
    */

    if ( arg_flag == gcf_f ) and arg_srch then
        con( pl, clr_w, 'Searching with match: ' .. arg_srch .. '\n' )
    end

    /*
        output > header columns
    */

    local c1_l      = sf( '%-35s',      'Command'           )
    local c2_l      = sf( '%-5s',       ''                  )
    local c3_l      = sf( '%-35s',      'Description'       )
    local resp      = sf( '%s %s %s',   c1_l, c2_l, c3_l    )

    con( pl, clr_r, resp .. '\n' )

    /*
        output > results
    */

    for k, v in helper:sortedkeys( base.calls:get( 'commands' ) ) do

        /*
            :   no flags
                if no gcf flags specified, only show commands marked as 'official'
        */

        if not arg_flag and not v.official then
            i_hidden = i_hidden + 1
            continue
        end

        /*
            :   gcf_a
                if flag -a not specified; all commands not on the correct running scope will be
                hidden.
        */

        if ( arg_flag ~= gcf_a ) and ( SERVER and v.scope == 3 or CLIENT and v.scope == 1 ) then
            i_hidden = i_hidden + 1
            continue
        end

        /*
            :   gcf_m
                will only display module commands
        */

        if arg_flag == gcf_m and v.official then
            i_hidden = i_hidden + 1
            continue
        end

        /*
            :   gcf_a
                will only display module commands
        */

        if ( arg_flag ~= gcf_a ) and v.is_hidden then
            i_hidden = i_hidden + 1
            continue
        end

        if arg_flag == gcf_f and arg_srch and not string.match( k, arg_srch ) then continue end

        local id            = v.id or v[ 1 ] or 'no id'
        local _desc         = v.desc or v[ 2 ] or ln( 'cmd_no_desc' )
        local desc          = helper.str:wordwrap( _desc, 100 )

        local c1_d          = sf( '%-35s', id )
        local c2_d          = sf( '%-5s', '»' )
        local c3_d          = sf( '%-35s', '   ' .. desc[ 1 ] ) -- return first line of command description

        -- clrs all commands that match lib name a different clr from others
        local clr_cmd = clr_w

        if string.match( id, mf.basecmd ) or string.match( id, mf.prefix ) then
            clr_cmd = clr_p
        elseif rcore and string.match( id, rcore.manifest.prefix ) then
            clr_cmd = Color( 0, 255, 0 )
        elseif v.clr and IsColor( v.clr ) then
            clr_cmd = v.clr
        end

        con( pl, clr_y, clr_cmd, c1_d, clr_y, c2_d, clr_w, c3_d )

        if arg_flag ~= gcf_s then
            for l, m in pairs( desc ) do
                if l == 1 then continue end -- hide the first line, already called in the initial call
                local val   = tostring( m ) or 'missing'
                local l1_d  = sf( '%-35s', '' )
                local l2_d  = sf( '%-35s', '   ' .. val )

                con( pl, clr_y, l1_d, clr_w, '    ', clr_w, l2_d )
            end
        end

        if arg_flag == gcf_b then
            con( pl, '' )
        end

        i_res = i_res + 1
    end

    /*
        output > footer
    */

    con( pl, 0 )
    con( pl, clr_y, 'Results: ', clr_w, i_res, clr_y, '      Hidden: ', clr_w, i_hidden )
    con( pl, 0 )
    con( pl, 1 )
    con( pl, clr_y, 'Additional Help:' )
    con( pl, clr_w, 'Help with particular command: ', clr_r, '    ' .. _n .. ' cmdname' )
    con( pl, clr_w, 'Help with particular command: ', clr_r, '    ' .. _n .. ' -h cmdname' )
    con( pl, clr_w, 'Search similar named commands: ', clr_r, '   ' .. _n .. ' -f yourtext' )
    con( pl, clr_w, 'List all commands: ', clr_r, '               ' .. _n .. ' -a' )
    con( pl, clr_w, 'List only module commands: ', clr_r, '       ' .. _n .. ' -m' )
    con( pl, 1 )

end
rcc.register( _n, rcc_base )

/*
    rcc > debug > enable

    turns debug mode on for a duration of time specified and then automatically turns it off after the
    timer has expired.
*/

local function rcc_debug( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', _p .. 'debug' )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, script, ccmd.id )
        return
    end

    /*
        perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, script, ccmd.id )
        return
    end

    /*
        functionality
    */

    local status        = args and args[ 1 ] or false
    local dur           = args and args[ 2 ] or cfg.debug.time_default

    base.sys:Debug( status, dur )
end
rcc.register( _p .. 'debug', rcc_debug )

/*
    rcc > debug > check status

    checks the status of debug mode
*/

local function rcc_debug_status( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', _p .. 'debug_status' )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, script, ccmd.id )
        return
    end

    /*
        perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, script, ccmd.id )
        return
    end

    /*
        functionality
    */

    local dbtimer           = timex.remains( 'rlib_debug_signal_sv' ) or false
    local status            = base:g_Debug( ) and ln( 'opt_enabled' ) or ln( 'opt_disabled' )

    log( RLIB_LOG_INFO, ln( 'debug_status', status ) )

    if dbtimer then
        log( RLIB_LOG_INFO, ln( 'debug_auto_remains', timex.secs.sh_cols_steps( dbtimer ) ) )
    end
end
rcc.register( _p .. 'debug_status', rcc_debug_status )

/*
    rcc > debug > devop

    executes devop hook
*/

local function rcc_debug_devop( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', _p .. 'debug_devop' )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, script, ccmd.id )
        return
    end

    /*
        perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, script, ccmd.id )
        return
    end

    /*
        search pattern
    */

    local pattern = '%l+_%l+'

    /***********************************************************************
        TIMEX
    ************************************************************************/

        /*
            output > timex > header
        */

            con( 'c', 3 )
            con( 'c', 0 )
            con( 'c',       Color( 255, 255, 0 ), ln( 'lib_devop_timers_t' ) )
            con( 'c', 0 )
            con( 'c', 1 )

        /*
            output > timex > define count
        */

            local i_timex = 0

        /*
            output > timex > check second parameter used _ instead of .
        */

            for k, v in helper.get.table( timex.source( ) ) do
                local item = v[ 1 ]
                if string.match( item, pattern ) then
                    local a1_d              = sf( '%-45s',  item )
                    local a2_d              = sf( '%-35s',  'sh_env 2nd param using _ instead of .' )

                    con( pl, clr_r, a1_d, clr_w, a2_d )

                    i_timex = i_timex + 1
                end
            end

        /*
            output > timex > no faults
        */

            if i_timex < 1 then
                con( 'c',       Color( 0, 255, 0 ), ln( 'lib_devop_check_pass' ) )
            end

    /***********************************************************************
        RNET
    ************************************************************************/

        /*
            output > rnet > header
        */

            con( 'c', 2 )
            con( 'c', 0 )
            con( 'c',       Color( 255, 255, 0 ), ln( 'lib_devop_rnet_t' ) )
            con( 'c', 0 )
            con( 'c', 1 )

        /*
            output > rnet > define count
        */

            local i_rnet            = 0

        /*
            output > rnet > check second parameter used _ instead of .
        */

            for k, v in helper.get.table( rnet.source( ) ) do
                local item = v[ 1 ]
                if string.match( item, pattern ) then
                    local a1_d              = sf( '%-45s',  item )
                    local a2_d              = sf( '%-35s',  'sh_env 2nd param using _ instead of .' )

                    con( pl, clr_r, a1_d, clr_w, a2_d )

                    i_rnet = i_rnet + 1
                end
            end

        /*
            output > rnet > entry has rnet.new ( ) entry, but NOT registered in ENV file
        */

            for k, v in helper.get.table( rnet.g_Session( ) ) do
                local src = rnet.source( )
                if not src[ k ] then
                    local a1_d              = sf( '%-45s',  k )
                    local a2_d              = sf( '%-35s',  'missing in sh_env.lua' )

                    con( pl, clr_r, a1_d, clr_w, a2_d )

                    i_rnet = i_rnet + 1
                end
            end

        /*
            output > rnet > entry defined in ENV, but no rnet.new found
        */

            for k, v in helper.get.table( rnet.source( ) ) do
                if not table.HasValue( rnet.g_Session( ), k ) then
                    local a1_d              = sf( '%-45s',  k )
                    local a2_d              = sf( '%-35s',  'missing rnet.new( "' .. k .. '" )' )

                    con( pl, clr_r, a1_d, clr_w, a2_d )

                    i_rnet = i_rnet + 1
                end
            end

            for a, b in pairs( rcore.modules ) do
                local name = string.format( '%s_fonts_reload', b.id )
                if not rnet.env( name ) then
                    local a1_d              = sf( '%-45s',  name )
                    local a2_d              = sf( '%-35s',  'missing in sh_env.lua [ ' .. b.id .. ' ]' )

                    con( pl, clr_r, a1_d, clr_w, a2_d )

                    i_rnet = i_rnet + 1
                end
            end

        /*
            output > rnet > no faults
        */

            if i_rnet < 1 then
                con( 'c',       Color( 0, 255, 0 ), ln( 'lib_devop_check_pass' ) )
            end

    /***********************************************************************
        RHOOK
    ************************************************************************/

        /*
            output > rhook > header
        */

        con( 'c', 2 )
        con( 'c', 0 )
        con( 'c',       Color( 255, 255, 0 ), ln( 'lib_devop_hooks_t' ) )
        con( 'c', 0 )
        con( 'c', 1 )

        /*
            output > rhook > define count
        */

        local i_rh          = 0

        /*
            output > rhook > check rnet_registered specified for each module
        */

        for a, b in pairs( rcore.modules ) do
            local name = pid( 'rnet_register', b.id )
            if not rhook.exists( name ) then
                local a1_d              = sf( '%-45s',  name )
                local a2_d              = sf( '%-35s',  'missing rhook.new.rlib( ' .. name .. ' )' )

                con( pl, clr_r, a1_d, clr_w, a2_d )

                i_rh = i_rh + 1
            end
        end

        for a, b in pairs( rcore.modules ) do
            local name = string.format( '%s_rnet_register', b.id )
            if not rhook.env( name ) then
                local a1_d              = sf( '%-45s',  name )
                local a2_d              = sf( '%-35s',  'missing in sh_env.lua [ ' .. b.id .. ' ]' )

                con( pl, clr_r, a1_d, clr_w, a2_d )

                i_rh = i_rh + 1
            end
        end

        for a, b in pairs( rcore.modules ) do
            local name = string.format( '%s_fonts_register', b.id )
            if not rhook.env( name ) then
                local a1_d              = sf( '%-45s',  name )
                local a2_d              = sf( '%-35s',  'missing rhook.new.rlib( "' .. name .. '" )' )

                con( pl, clr_r, a1_d, clr_w, a2_d )

                i_rh = i_rh + 1
            end
        end

        /*
            output > rhook > no faults
        */

        if i_rh < 1 then
            con( 'c',       Color( 0, 255, 0 ), ln( 'lib_devop_check_pass' ) )
        end

    /*
        output > footer
    */

        con( 'c', 1 )
        con( 'c', 1 )

end
rcc.register( _p .. 'debug_devop', rcc_debug_devop )

/*
    concommand > help

    returns support info
*/

local function rcc_help( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', _p .. 'help' )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, script, ccmd.id )
        return
    end

    /*
        perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, script, ccmd.id )
        return
    end

    /*
        functionality
    */

    con( pl, 3 )

    local h1_l      = sf( '%-20s', 'rlib » help' )
    local h2_l      = sf( '%-15s', '' )
    local h1_d      = h1_l .. ' ' .. h2_l

    con( pl, clr_r, h1_d )
    con( pl, 0 )

    local resp = sf( 'For more help related to %s, you can visit our website for documentation or to get\n an updated version at:\n', script )
    con( pl, clr_w, resp )

    local tbl_help =
    {
        { id = 'Docs',  val = mf.docs or ln( 'not_specified' ) },
        { id = 'Repo',  val = mf.repo or ln( 'not_specified' ) },
        { id = 'Site',  val = mf.site or ln( 'not_specified' ) },
    }

    for l, m in SortedPairs( tbl_help ) do
        local id    = tostring( m.id )
        local val   = tostring( m.val )

        local l1_d, l2_d, l3_d = '', '', ''
        l1_d        = sf( '%-15s', id )
        l2_d        = sf( '%-5s', '»' )
        l3_d        = sf( '%-15s', val )

        con( pl, clr_y, l1_d, clr_p, l2_d, clr_w, l3_d )
    end

    local base_cmd
    for v in helper.get.data( base.calls:get( 'commands' ) ) do
        if not v.is_base then continue end
        base_cmd = v.id
    end

    con( pl, 1 )
    con( pl, clr_y, 'Help » ', clr_w, 'Access the command list by typing ', Color( 0, 255, 0 ), base_cmd, clr_w, ' in console'  )
    con( pl, clr_y, 'Help » ', clr_w, 'Syntax: ', Color( 0, 255, 0 ), base_cmd )

    con( pl, 3 )

end
rcc.register( _p .. 'help', rcc_help )

/*
    rcc > commands > rehash

    register commands with rcc
    calls rlib.calls.commands:RCC( )
*/

local function rcc_commands_rehash( pl, cmd, args, str )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', _p .. 'rcc_rehash' )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, script, ccmd.id )
        return
    end

    /*
        perms
    */

    if not access:bIsDev( pl ) then
        access:deny_permission( pl, script, ccmd.id )
        return
    end

    /*
        register commands
    */

    rcc.prepare( )

    /*
        output
    */

    log( 4, ln( 'rcc_commands_rehash' ) )

end
rcc.register( _p .. 'rcc_rehash', rcc_commands_rehash )

/*
    rcc > version

    outputs version of rlib running.
*/

local function rcc_version( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', _p .. 'version' )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, script, ccmd.id )
        return
    end

    /*
        declare
    */

    local uptime            = timex.secs.sh_cols_steps( SysTime( ) - sys.uptime )
    local addons            = base.modules:count( )
    local lists             = base.modules:listf( )

    /*
        output
    */

    con( pl, 2 )

    local cat               = script or ln( 'lib_name' )
    local subcat            = 'manifest'

    con( pl, cfg.smsg.clrs.t3, sf( '%s » %s', cat, subcat ) )

    con( pl, 1 )

    con( pl, '       Version    » ', cfg.smsg.clrs.t4, 'v' .. base.get:ver2str_mf( ), cfg.smsg.clrs.msg, ' ( ' .. os.date( '%m.%d.%Y', mf.released ) .. ' ) ' )
    con( pl, '       Author     » ', cfg.smsg.clrs.t4, mf.author )
    con( pl, '       Docs       » ', cfg.smsg.clrs.t4, mf.docs )
    con( pl, '       Uptime     » ', cfg.smsg.clrs.t4, uptime )
    con( pl, '       Addons     » ', cfg.smsg.clrs.t4, addons, cfg.smsg.clrs.t1, ' (' .. lists .. ')' )

    con( pl, 2 )

end
rcc.register( _p .. 'version', rcc_version )

/*
    concommand > workshops

    returns workshops that are loaded on the server through the various methods including rlib, rcore,
    and individual modules.
*/

local function rcc_workshops( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', _p .. 'workshops' )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, script, ccmd.id )
        return
    end

    /*
        perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, script, ccmd.id )
        return
    end

    /*
        output > header
    */

    con( pl, 3 )
    con( pl, clr_y, script, clr_p, ' » ', clr_w, 'Workshops' )
    con( pl, 0 )

    local ws = base.get:ws( ) or { }

    for l, m in SortedPairs( ws ) do
        local collection_name = istable( m.steamapi ) and m.steamapi.title or ln( 'ws_no_steam_data' )

        if CLIENT then
            steamworks.FileInfo( l, function( res )
                base.w[ l ].steamapi = { title = res.title }
            end )
            collection_name = base.w[ l ].steamapi.title
        end

        local h1_d  = sf( '%-15s', tostring( l ) )
        local h2_d  = sf( '%-5s', '»' )
        local h3_d  = sf( '%-20s', tostring( m.src ) )
        local h4_d  = sf( '%-5s', '»' )
        local h5_d  = sf( '%-15s', helper.str:truncate( collection_name, 40 ) )

        con( pl, clr_y, h1_d, clr_p, h2_d, clr_w, h3_d, clr_p, h4_d, clr_w, h5_d )
    end

    con( pl, 3 )

end
rcc.register( _p .. 'workshops', rcc_workshops )