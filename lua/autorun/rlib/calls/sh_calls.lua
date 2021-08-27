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

local base                  = rlib
local mf                    = base.manifest
local pf                    = mf.prefix
local cfg                   = base.settings

/*
*   localized rlib routes
*/

local helper                = base.h
local sys                   = base.sys

/*
*   Localized lua funcs
*
*   i absolutely hate having to do this, but for squeezing out every
*   bit of performance, we need to.
*/

local pairs                 = pairs
local tostring              = tostring
local istable               = istable
local isstring              = isstring
local debug                 = debug
local string                = string
local sf                    = string.format

/*
*   Localized translation func
*/

local function lang( ... )
    return base:lang( ... )
end

/*
*   simplifiy funcs
*/

local function log( ... ) base:log( ... ) end

/*
*	prefix > create id
*/

local function cid( id, suffix )
    local affix     = istable( suffix ) and suffix.id or isstring( suffix ) and suffix or pf
    affix           = affix:sub( -1 ) ~= '.' and sf( '%s.', affix ) or affix

    id              = isstring( id ) and id or 'noname'
    id              = id:gsub( '[%c%s]', '.' )

    return sf( '%s%s', affix, id )
end

/*
*	prefix ids
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and pf ) or false
    return cid( str, state )
end

/*
*   calls > register
*
*   grab call categories from main lib table which typically include:
*       : hooks
*       : timers
*       : commands
*       : net
*       : pubcmd
*
*   send regsitered calls from source table
*       rlib.c[ type ] => base._rcalls[ type ]
*
*   @param  : tbl parent
*   @param  : tbl src
*/

function base.calls:register( parent, src )
    if not parent.manifest.calls or not istable( parent.manifest.calls ) then
        log( RLIB_LOG_ERR, lang( 'calls_tbl_missing_def' ) )
        return
    end

    if not src or not istable( src ) then
        log( RLIB_LOG_ERR, lang( 'calls_tbl_invalid' ) )
        return
    end

    for _, v in pairs( parent.manifest.calls ) do

        /*
        *   v returns call_type
        */

        local call_type = v:lower( )
        if not src[ call_type ] then
            src[ call_type ] = { }
        end

        /*
        *   build calls lib
        *
        *   loop calls and setup structure
        *   : l        =   call_id
        *   : m[ 1 ]   =   call.id
        *   : m[ 2 ]   =   desc (optional)
        *
        *   structure ex
        *       commands:
        *       rlib_command:
        *           1   : rlib.command
        *           2   : no description
        */

        for l, m in pairs( src[ call_type ] ) do
            base._rcalls[ call_type ] = base._rcalls[ call_type ] or { }
            if call_type ~= 'commands' then
                base._rcalls[ call_type ][ l ]  = { tostring( m[ 1 ] ), m[ 2 ] and tostring( m[ 2 ] ) or lang( 'cmd_no_desc' ) }
            else
                base._rcalls[ call_type ][ l ]  = m
            end
            sys.calls = ( sys.calls or 0 ) + 1
        end

    end
end

/*
*   calls > load
*
*   takes all registered net calls and loads them to server
*
*   :   (bool) bPrefix
*       true adds lib prefix at front of all network entries
*       'rlib.network_string_id'
*
*   :   (str) affix
*       bPrefix must be true, determines what prefix to add to
*       the front of a netnw string. if none provided, lib prefix
*       will be used
*
*   @param  : bool bPrefix
*   @param  : str affix
*/

function base.calls:load( bPrefix, affix )
    log( 6, lang( 'calls_register_nlib' ) )

    rhook.run.rlib( 'rlib_calls_pre' )

    if not base._rcalls[ 'net' ] then
        base._rcalls[ 'net' ] = { }
        log( 6, lang( 'calls_register_tbl' ) )
    end

    if SERVER then
        self:Catalog( )
    end

    if rnet then
        rhook.run.gmod( 'rlib_rnet_register' )
    end

    rhook.run.rlib( 'rlib_calls_post' )
end

/*
*   calls > validation
*
*   checks a provided call id to see if it is registered within base._rcalls
*
*   @param  : str t
*   @return : tbl
*/

function base.calls:valid( t )
    if not t or not isstring( t ) or t == '' then
        log( 2, lang( 'calls_type_missing_spec' ) )
        local response, cnt_calls, i = '', #base._rcalls, 0
        for k, v in pairs( base._rcalls ) do
            response = response .. k
            i = i + 1
            if i < cnt_calls then
                response = response .. ', '
            end
        end
        log( 2, lang( 'calls_type_valid', response ) )
        return
    end

    local data = base._rcalls[ t ]
    if not data then
        log( 2, lang( 'calls_type_missing', t ) )
        return
    end

    return data or false
end

/*
*   calls > gcflag
*
*   returns the flag for a specified command
*
*   :   (str) cmd
*       command name
*
*   :   (str) flg_id
*       name of the flag
*
*   :   (bool) ret
*       true, 2 will return flag, desc
*
*   @ex     : rlib.calls:gcflag( 'rlib', 'all' )
*   @ex     : rlib.calls:gcflag( 'timex_list', 'active' )
*
*   @param  : str cmd
*   @param  : str flg_id
*   @param  : bool ret
*   @return : tbl
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
*   calls > gcflag > valid
*
*   returns if a provided flag is valid for the specified command
*
*   @call   : rlib.calls:gcflag_valid( 'command_name', '-arg' )
*   @ex     : rlib.calls:gcflag_valid( 'rlib_debug_clean', '-cancel' )
*
*   @param  : str cmd
*   @param  : str flag
*   @return : bool
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
*   calls > post load
*
*   executed after all calls have been setup and loaded
*   typically utilized for processes such as checking for base command existence and various other tasks.
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
        log( RLIB_LOG_ERR, lang( 'calls_cmd_lib_missing', debug.getinfo( 1, 'n' ).name ) )
    else
        log( RLIB_LOG_DEBUG, lang( 'calls_cmd_lib_base' , get_basecmd ) )
    end
end
hook.Add( pid( 'calls_post' ), pid( 'calls_load_post' ), calls_load_post )

/*
*   calls > get call
*
*   returns the associated call data table
*
*   call using localized function in file that you require fetching needed calls.
*
*   @ex     : rlib.calls:get( 'calltype', 'id' )
*             rlib.calls:get( 'commands', 'rlib_modules' )
*
*   @param  : str t
*   @param  : str s
*   @return : tbl
*/

function base.calls:get( t, s )
    local data      = self:valid( t )
                    if not data then return end

    if s and data[ s ] then
        return data[ s ]
    else
        return data
    end

    return
end

/*
*   call
*
*   returns the associated call
*
*   call using localized function in file that you require fetching needed calls.
*   these are usually stored in the modules' manifest file
*
*   @call   : call( 'type', 'string_id' )
*
*   @ex     : call( 'commands', 'rlib_modules' )
*             call( 'hooks', 'lunera_initialize' )
*
*   @param  : str t
*   @param  : str s
*   @param  : varg { ... }
*   @return : str
*/

function base:call( t, s, ... )
    local data      = base.calls:valid( t )
                    if not data then return end

    if not isstring( s ) then
        log( 2, lang( 'calls_id_missing' , t ) )
        return false
    end

    s = s:gsub( '[%p%c%s]', '_' ) -- replace punct, contrl chars, and whitespace with underscores

    if t == 'commands' then
        local ret = sf( s, ... )
        if data[ s ] then
            local cmd = s
            if ( data[ s ][ 'id' ] and isstring( data[ s ][ 'id' ] ) ) then
                cmd = data[ s ][ 'id' ]
            elseif ( data[ s ][ 1 ] and isstring( data[ s ][ 1 ] ) ) then
                cmd = data[ s ][ 1 ]
            end
            ret = sf( cmd, ... )
        end
        return ret
    else
        local ret = sf( s, ... )
        if data[ s ] then
            ret = sf( data[ s ][ 1 ], ... )
        end
        return ret
    end
end

/*
*   calls > commands > register
*
*   inserts a new command into base commands table which allows it to display within the base library
*   concommand, as well as execution params
*
*   this is an alternative method to registering commands that aren't provided through the module
*   manifest method
*
*   @ex     : rlib.calls.commands:Register( local_tbl_varname )
*
*   @param  : tbl params
*/

function base.calls.commands:Register( params )
    if not istable( params ) then
        log( RLIB_LOG_ERR, lang( 'calls_reg_params_missing', debug.getinfo( 1, 'n' ).name ) )
        return
    end

    for k, v in pairs( params ) do
        if not isstring( k ) then
            log( RLIB_LOG_ERR, lang( 'calls_reg_cmd_id_missing', debug.getinfo( 1, 'n' ).name ) )
            continue
        end

        base.c.commands[ k ]            = v
        base._rcalls[ 'commands' ][ k ] = v

        sys.calls = ( sys.calls or 0 ) + 1

        log( RLIB_LOG_DEBUG, lang( 'calls_cmd_added', k ) )
    end
end