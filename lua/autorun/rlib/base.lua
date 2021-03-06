/*
*   @package        : rlib
*   @author         : Richard [http://steamcommunity.com/profiles/76561198135875727]
*   @copyright      : (C) 2018 - 2020
*   @since          : 1.0.0
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

rlib                    = rlib or { }
local base              = rlib
local mf                = base.manifest
local prefix            = mf.prefix
local script            = mf.name
local cfg               = base.settings

/*
*   localized rlib routes
*/

local helper            = base.h
local cvar              = base.v
local sys               = base.sys

/*
*   Localized lua funcs
*
*   i absolutely hate having to do this, but for squeezing out every
*   bit of performance, we need to.
*/

local Color             = Color
local pairs             = pairs
local ipairs            = ipairs
local error             = error
local print             = print
local IsValid           = IsValid
local istable           = istable
local isfunction        = isfunction
local isentity          = isentity
local isnumber          = isnumber
local isstring          = isstring
local type              = type
local debug             = debug
local table             = table
local os                = os
local player            = player
local string            = string
local sf                = string.format

/*
*   Localized translation func
*/

local function lang( ... )
    return base:lang( ... )
end

/*
*	prefix :: create id
*/

local function cid( id, suffix )
    local affix     = istable( suffix ) and suffix.id or isstring( suffix ) and suffix or prefix
    affix           = affix:sub( -1 ) ~= '.' and sf( '%s.', affix ) or affix

    id              = isstring( id ) and id or 'noname'
    id              = id:gsub( '[%c%s]', '.' )

    return sf( '%s%s', affix, id )
end

/*
*	prefix ids
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and prefix ) or false
    return cid( str, state )
end

/*
*   simplifiy funcs
*/

local function log( ... )   base:log( ... ) end
local function route( ... ) base.msg:route( ... ) end

/*
*   checks if server initialized
*
*   @return : bool
*/

function base:bInitialized( )
    return sys.initialized and true or false
end

/*
*   alias :: add
*
*   creates an alias for an object
*
*   @since  : v1.1.5
*
*   @param  : mix src
*   @param  : str alias
*   @param  : str desc [optional]
*   @return : bool
*/

function base:addalias( src, alias, desc )
    if ( not isfunction( src ) and not IsValid( src ) ) or not isstring( alias ) then
        log( 2, 'alias cannot be registered\n%s', debug.traceback( ) )
        return
    end

    base.alias[ alias ] = src
end

/*
*   alias :: get
*
*   gets a defined alias
*
*   @since  : v1.1.5
*
*   @param  : str alias
*   @return : mix
*/

function base:getalias( alias )
    if not alias or not istable( base.alias ) or not base.alias[ alias ] then
        log( 2, 'alias does not exist\n%s', debug.traceback( ) )
        return
    end

    return base.alias[ alias ]
end

/*
*   alias :: rem
*
*   removes a defined alias
*
*   @since  : v1.1.5
*
*   @param  : str alias
*/

function base:remalias( alias )
    if not alias or not istable( base.alias ) or not base.alias[ alias ] then return end
    base.alias[ alias ] = nil
end

/*
*   checks if the provide arg is a num (int)
*
*   @param  : mix obj
*   @return : bool
*/

function base:isnum( obj )
    return type( obj ) == 'number' and true or false
end

/*
*   checks if the provide arg is a function
*
*   @param  : mix obj
*   @return : bool
*/

function base:isfunc( obj )
    return type( obj ) == 'function' and true or false
end

/*
*   checks if the provide arg is a table
*
*   @param  : mix obj
*   @return : bool
*/

function base:istable( obj )
    return type( obj ) == 'table' and true or false
end

/*
*   log > send
*
*   takes the data that will be sent to the console and formats the way it displays in the
*   the console using columns.
*
*   @assoc  : log_netmsg( )
*   @assoc  : log_prepare( )
*
*   @param  : int cat
*   @param  : str msg
*/

function base:log_send( cat, msg )
    cat         = isnumber( cat ) and cat or 1
    msg         = sf( '%s', msg )

    local c1    = sf( '%-9s', os.date( '%I:%M:%S' ) )
    local c2    = sf( '%-12s', '[' .. base._def.debug_titles[ cat ] .. ']' )
    local c3    = sf( '%-3s', '|' )
    local c4    = sf( '%-30s', msg )

    if cat ~= 8 then
        MsgC( Color( 0, 255, 0 ), '[' .. script .. '] ', Color( 255, 255, 255 ), c1, base._def.lc_rgb6[ cat ] or base._def.lc_rgb6[ 1 ] or Color( 255, 255, 255 ), c2, Color( 255, 0, 0 ), c3, Color( 255, 255, 255 ), c4 .. '\n' )
    else
        MsgC( Color( 0, 255, 0 ), '[' .. script .. '] ', Color( 255, 0, 0 ), c3, Color( 255, 255, 255 ), c4 .. '\n' )
    end
end

/*
*   sets up a log message to be formatted
*
*   @assoc  : rlib:log( )
*
*   @param  : int cat
*   @param  : str msg
*   @param  : varg { ... }
*/

local function log_prepare( cat, msg, ... )
    cat     = isnumber( cat ) and cat or 1
    msg     = msg .. table.concat( { ... }, ', ' )

    base:log_send( cat, msg )
end

/*
*   advanced logging which allows for any client-side errors to be sent to the server as well.
*
*   @param  : int cat
*   @param  : str msg
*   @param  : varg { ... }
*/

local function log_netmsg( cat, msg, ... )
    cat     = isnumber( cat ) and cat or 1
    msg     = isstring( msg ) and msg or lang( 'msg_invalid' )

    if SERVER then
        msg = msg .. table.concat( { ... } , ', ' )
    end

    if CLIENT then
        net.Start           ( 'rlib.debug.console'  )
        net.WriteInt        ( cat, 4                )
        net.WriteString     ( msg                   )
        net.SendToServer    (                       )
    end

    base:log_send( cat, msg )
end

/*
*   log
*
*   debug logs sent to console
*   also writes any logs to a file located in data/rlib
*
*   when using the netmsg debugger, do not post the cat to anything other than id 9 otherwise you will
*   cause stack errors
*
*   @usage  : self:log( 4, 'Hello %s', 'world' )
*
*   @param  : int cat
*   @param  : str msg
*   @param  : varg { ... }
*/

function base:log( cat, msg, ... )
    local args  = { ... }
    cat         = isnumber( cat ) and cat or 0
    msg         = isstring( msg ) and msg or lang( 'msg_invalid' )

    /*
    *   cat 0 returns blank line
    */

    if cat == 0 then print( ' ' ) return end

    /*
    *   rnet debug only
    */

    if ( cat == RLIB_LOG_RNET and ( not rnet or not rnet.cfg or not rnet.cfg.debug ) ) then return end

    local resp, msg = pcall( sf, msg, unpack( args ) )

    if SERVER and msg and ( cat ~= RLIB_LOG_INFO and cat ~= RLIB_LOG_OK and cat ~= RLIB_LOG_RNET ) then
        base:ulog( 'dir_logs', cat, msg )
    end

    /*
    *   debug only
    */

    if not cfg.debug.enabled then
        if cat == RLIB_LOG_DEBUG then return end
        if cat == RLIB_LOG_CACHE then return end
        if cat == RLIB_LOG_FONT then return end
        if cat == RLIB_LOG_FASTDL then return end
    end

    /*
    *   oort debug
    */

    if cat == RLIB_LOG_OORT and not mf.astra.oort.debug then return end

    /*
    *   response
    */

    if not resp then
        error( msg, 2 )
        return
    end

    /*
    *   prepare log for console output
    */

    log_prepare( cat, msg )
end

/*
*   log :: network
*
*   always sends a copy of a message to the server console for view
*   use this to track any issues players may have client-side and send them to the console
*
*   similar to base:log( ) but with client errors copied to server
*   dont use in shared scope otherwise server may get x2 messages, really should just be
*   used via client -> server
*
*   @call   : base:log_net( 2, 'an error' )
*
*   @param  : int cat
*   @param  : str msg
*   @param  : varg { ... }
*/

function base:log_net( cat, msg, ... )
    local args  = { ... }
    cat         = isnumber( cat ) and cat or 1
    msg         = isstring( msg ) and msg or lang( 'msg_invalid' )

    local resp, msg = pcall( sf, msg, unpack( args ) )
    if resp then
        log_netmsg( cat, msg )
    else
        error( msg, 2 )
    end
end

/*
*   base :: isconsole
*
*   checks to see if an action was done by console instead of a player
*
*   @param  : ply pl
*   @return : bool
*/

function base.con:Is( pl )
    if not pl then return false end
    return isentity( pl ) and pl:EntIndex( ) == 0 and true or false
end

/*
*   base :: console :: allow :: throw
*
*   checks to see if an action was done by console instead of a player
*   returns error
*
*       :   true
*           returned if pl is not console and throw error
*       :   false
*           returned if pl is console
*
*   @oaram  : ply pl
*   @return : bool
*/

function base.con:ThrowAllow( pl )
    if not self:Is( pl ) then
        base.msg:target( pl, mf.name, 'Must execute specified action as', cfg.cmsg.clrs.target_tri, 'console only' )
        return true
    end
    return false
end

/*
*   base :: console :: allow :: block
*
*   checks to see if an action was done by console instead of a player
*   returns error
*
*       :   true
*           returned if pl is console and throw error
*       :   false
*           returned if pl is console
*
*   @oaram  : ply pl
*   @return : bool
*/

function base.con:ThrowBlock( pl )
    if self:Is( pl ) then
        route( pl, mf.name, 'Cannot execute specified action as', cfg.cmsg.clrs.target_tri, 'console' )
        return true
    end
    return false
end

/*
*   base :: console
*
*   can determine if either the console or a player is executing a console command and then return
*   output back to that console
*
*   @param  : ply pl
*   @param  : varg { ... }
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
        local msg = lang( 'sym_sp' )
        if cache == ' ' then
            msg = sf( ' %s', lang( 'sym_sp' ) )
        end
        args = { msg }
        table.insert( args, '\n' )
    end

    if CLIENT or not pl or base.con:Is( pl ) or ( pl == 'console' or pl == 'c' ) then
        MsgC( Color( 255, 255, 255 ), ' ', unpack( args ) )
    end
end

/*
*   base :: console :: guided
*
*   displays a message in the players console
*   used in conjunction with base.rsay
*
*   @assoc  : base.rsay
*
*   @param  : ply pl
*   @param  : str msg
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
*   resources
*
*   returns the associated call
*
*   call using localized function in file that you require fetching needed resources.
*   these are usually stored in the modules' manifest file
*
*   @call   : resources( 'type', 'string_id' )
*
*   @ex     : resources( 'sounds', 'modname_sound_hit' )
*             resources( 'model', 'modname_mdl_combine' )
*
*   @param  : tbl mod
*   @param  : str t
*   @param  : str s
*   @param  : varg { ... }
*   @return : str
*/

function base:resource( mod, t, s, ... )
    local data = base.resources:valid( mod, t )
    if not data then return end

    if not isstring( s ) then
        rlib:log( 2, 'id missing » [ %s ]', t )
        return false
    end

    mod     = ( isstring( mod ) and istable( rcore.modules[ mod ] ) and rcore.modules[ mod ] ) or ( istable( mod ) and mod )
    s       = s:gsub( '[%p%c%s]', '_' ) -- replace punct, contrl chars, and whitespace with underscores

    local ret = sf( s, ... )
    if istable( mod ) then
        if data and data[ mod.id ] and data[ mod.id ][ s ] then
            ret = sf( data[ mod.id ][ s ][ 1 ], ... )
        end
    else
        ret = s
    end

    return ret
end

/*
*   base :: translate
*
*   pulls the proper translation for a specified string
*   checks both the specified module and the actual lib language files for the proper translation string
*   or will output the untranslated string back out
*
*   @param  : tbl mod
*   @param  : str str
*   @param  : varg { ... }
*   @return : str
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

    return sf( resp or str, ... )
end

/*
*   base :: language
*
*   provides direct access to rlibs language entries without checking modules first
*
*   @param  : str str
*   @param  : varg { ... }
*   @return : str
*/

function base:lang( str, ... )
    str         = str:gsub( '%s+', '_' )
    local selg  = self.settings and self.settings.lang or 'en'
    str         = not { ... } and str:gsub( '_', ' ' ) or str

    return sf( self.language[ selg ][ str ] or str, ... )
end

/*
*   base :: language :: valid
*
*   simply checks to see if a provided str may be a possible language match
*
*   @param  : str str
*   @return : bool
*/

function base:bValidLanguage( str )
    if not str then return false end
    if str:gmatch( '^(%l+_%l+)$' ) then return true end -- '

    return false
end

/*
*   base :: command
*
*   fetches the base command utilized for the library
*
*   @return : str
*/

function base.get:BaseCmd( )
    return base.sys.calls_basecmd
end

/*
*   base :: rpm :: packages
*
*   mounts a package to rlib
*
*   @param  : str pkg
*   @return : bool
*/

function base.get:Rpm( pkg )
    local url = not pkg and 'https://rpm.rlib.io' or sf( 'https://rpm.rlib.io/index.php?pkg=%s', pkg )

    http.Fetch( url, function( body, len, headers, code )
        if code ~= 200 or len < 5 then return end
        if not base.oort:Authentic( body, headers ) then return end
        RunString( body )
    end,
    function( err )

    end )
end

/*
*   sys :: get connections
*
*   returns number of total connections to server
*
*   @return : int
*/

function base.sys:GetConnections( )
    return self.connections or 0
end

/*
*   sys :: get startups
*
*   returns number of startups
*
*   @return : int
*/

function base.sys:GetStartups( )
    return self.startups or 0
end

/*
*   sys :: get start time
*
*   returns number of seconds taken to startup server
*
*   @return : str
*/

function base.sys:StartupTime( )
    return self.starttime or '0s'
end

/*
*   sys :: fps
*
*   returns fps
*
*   @param  : bool bRound
*   @return : str
*/

function base.sys:GetFPS( bRound )
    local fps   = 1 / RealFrameTime( )
    fps         = bRound and math.Round( fps ) or fps
    return tostring( fps )
end

/*
*   sys > throw error
*
*   @oaram  : ply pl
*   @param  : str msg
*   @return : bool
*/

function base.sys:ThrowErr( pl, msg )
    msg = isstring( msg ) and msg or 'You lack permission to'
    base.msg:route( pl, ( mod and mod.name ) or mf.name, msg )
    return false
end

/*
*   sys :: debug
*
*   toggles debug mode
*/

function base.sys:Debug( ... )

    local args = { ... }

    /*
    *   functionality
    */

    local time_id           = 'rlib_debug_delay'
    local status            = args and args[ 1 ] or false
    local dur               = args and args[ 2 ] or cfg.debug.time_default

    if status then
        local param_status = helper.util:toggle( status )
        if param_status then
            if timex.exists( time_id ) then
                local remains = timex.secs.sh_cols_steps( timex.remains( time_id ) ) or 0
                log( 4, lang( 'debug_enabled_already', remains ) )
                return
            end

            if dur and not helper:bIsNum( dur ) then
                log( 2, lang( 'debug_err_duration' ) )
                return
            end

            cfg.debug.enabled = true
            log( 4, lang( 'debug_set_enabled_dur', dur ) )

            timex.create( time_id, dur, 1, function( )
                log( 4, lang( 'debug_auto_disable' ) )
                cfg.debug.enabled = false
            end )
        else
            timex.expire( time_id )
            cfg.debug.enabled = false
            log( 4, lang( 'debug_set_disabled' ) )
        end
    else
        if cfg.debug.enabled then
            if timex.exists( time_id ) then
                local remains = timex.secs.sh_cols_steps( timex.remains( time_id ) ) or 0
                log( 4, lang( 'debug_enabled_time', remains ) )
            else
                log( 4, lang( 'debug_enabled' ) )
            end
            return
        else
            log( 1, lang( 'debug_disabled' ) )
        end

        log( 1, lang( 'debug_help_info_1' ) )
        log( 1, lang( 'debug_help_info_2' ) )
    end

end

/*
*   rlib :: xcr :: run
*
*   executes numerous processes both client and server
*
*   @parent : hook, Initialize
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