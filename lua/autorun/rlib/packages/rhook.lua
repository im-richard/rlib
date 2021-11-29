/*
    @library        : rlib
    @package        : rhook
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
local access                = base.a
local helper                = base.h

/*
    library > localize
*/

local mf                    = base.manifest

/*
    declare > category
*/

local dcat                  = 9
/*
    languages
*/

local function ln( ... )
    return base:lang( ... )
end


/*
    localize output functions
*/

local function con( ... ) base:console( ... ) end
local function log( ... ) base:log( ... ) end

/*
    call id > get

    @source : lua\autorun\libs\_calls
    @param  : str id
*/

local function g_CallID( id )
    return base:call( 'hooks', id )
end

/*
    prefix > create id
*/

local function cid( id, suffix )
    local affix     = istable( suffix ) and suffix.id or isstring( suffix ) and suffix or mf.prefix
    affix           = affix:sub( -1 ) ~= '.' and string.format( '%s.', affix ) or affix

    id              = isstring( id ) and id or 'noname'
    id              = id:gsub( '[%p%c%s]', '.' )

    return string.format( '%s%s', affix, id )
end

/*
    prefix > get id
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and mf.prefix ) or false
    return cid( str, state )
end

/*
    define module
*/

module( 'rhook', package.seeall )

/*
    local declarations
*/

local pkg                   = rhook
local pkg_name              = _NAME or 'rhook'

/*
    pkg declarations
*/

local manifest =
{
    author                  = 'richard',
    desc                    = 'hook management',
    build                   = 081920,
    version                 = { 2, 2, 0 },
    debug_id                = 'rhook.debug.delay',
}

/*
    required tables
*/

cfg                         = cfg   or { }
sys                         = sys   or { }
new                         = new   or { }
run                         = run   or { }
call                        = call  or { }
drop                        = drop  or { }
session                     = session or { }

/*
    net > debugging

    determines if debugging mode is enabled
*/

cfg.debug                   = cfg.debug or false

/*
 	prefix > getid
*/

local function gid( id )
    id = isstring( id ) and id or nil
    if not isstring( id ) then
        local tb = debug.traceback( )
        log( dcat, '[ %s ] :: invalid id\n%s', pkg_name, tostring( tb ) )
        return
    end

    id = g_CallID( id )

    return id
end

/*
    package id

    creates rcc command with package name appended to the front
    of the string.

    @param  : str str
*/

function g_PackageId( str )
    str         = isstring( str ) and str ~= '' and str or false
                if not str then return pkg_name end

    return pid( str, pkg_name )
end

/*
    env

    returns registered hooks.
    these are the entries added to the modules sh_env.lua file

    @param  : str id
    @return : bool
*/

function env( id )
    local src = source( )
    return src and src[ id ] and true or false
end

/*
    exists

    returns if hook was actually used within
        rhook.new.rlib
        rhook.new.gmod

    @param  : str id
    @return : bool
*/

function exists( id )
    return session and session[ id ] and true or false
end

/*
    drop > rlib

    @param  : str event
    @param  : str id
    @param  : fn fn
*/

function drop.rlib( event, id )
    event   = gid( event )
    id      = gid( id )
    hook.Remove( event, id )
end

/*
    drop > gmod

    @param  : str event
    @param  : str id
    @param  : fn fn
*/

function drop.gmod( event, id )
    id = gid( id )
    hook.Remove( event, id )
end

/*
    run > rlib

    @param  : str event
    @param  : varg ...
*/

function run.rlib( event, ... )
    event       = gid( event )
    hook.Run( event, ... )
end

/*
    run > gmod

    @param  : str event
    @param  : varg ...
*/

function run.gmod( event, ... )
    if not isstring( event ) then return end
    hook.Run( event, ... )
end

/*
    run > id

    similar to run.rlib however throws the event id back
    in order to fetch the proper id being called

    dont use unless you know what your doing

    @param  : str event
    @param  : varg ...
*/

function run.id( event, ... )
    event       = gid( event )
    local args  = { ... }

    if args and ( type( args[ 1 ] ) == 'boolean' ) then
        log( RLIB_LOG_STATUS, '[ %s ] > event id %s', pkg_name, event )
        hook.Run( event )

        return
    end

    hook.Run( event, ... )
end

/*
    call > rlib

    @param  : str event
    @param  : varg ...
*/

function call.rlib( event, ... )
    event = gid( event )
    hook.Call( event, ... )
end

/*
    call > gmod

    @param  : str event
    @param  : varg ...
*/

function call.gmod( event, ... )
    if not isstring( event ) then return end
    hook.Call( event, ... )
end

/*
    call > id

    @param  : str event
    @param  : varg ...
*/

function call.id( event, ... )
    event       = gid( event )
    local args  = { ... }

    if args and ( type( args[ 1 ] ) == 'boolean' ) then
        log( RLIB_LOG_STATUS, '[ %s ] > event id %s', pkg_name, event )
        hook.Call( event )

        return
    end

    hook.Call( event, ... )
end

/*
    new > rlib

    ( switching parameters )
        id      : can be either str or fn
                  if id is a function, id will match event name

    @ex     : rhook.new.rlib( 'identix_pl_authenticate', 'custom_id', pl_validate )
            : rhook.new.rlib( 'identix_pl_authenticate', pl_validate )

    @param  : str event
    @param  : varg ( ... )
*/

function new.rlib( event, ... )
    event           = gid( event )
    s_Session       ( event )

    local a1        = select( 1, ... )
    local a2        = select( 2, ... )

    local id        = isfunction( a1 ) and event or isstring( a1 ) and a1
    local fn        = isfunction( a1 ) and a1 or isstring( a1 ) and a2 or nil

    if isstring( id ) then
        id = gid( id )
    end

    if not isfunction( fn ) then
        log( 1, '[ %s ] :: invalid func\n%s', pkg_name, tostring( trcback ) )
        return
    end

    if cfg.debug then
        con( nil, event )
        con( nil, id )
        con( nil, 0 )
    end

    drop.rlib   ( event, id     )
    hook.Add    ( event, id, fn )
end

/*
    new > gmod

    @param  : str event
    @param  : str id
    @param  : fn fn
*/

function new.gmod( event, id, fn )
    if not isstring( id ) then
        rlib:log( RLIB_LOG_ERR, '[ %s ] new.gmod invalid hook id\n%s', 'rhook', debug.traceback( ) )
        return
    end

    id              = gid( id )
    s_Session       ( id )

    drop.gmod       ( event, id     )
    hook.Add        ( event, id, fn )
end

/*
    new > base

    @param  : varg ( ... )
*/

function new.base( ... )
    hook.Add( ... )
end

/*
    rnet > source

    returns source tbl for timers

    @return : tbl
*/

function source( )
    return base.calls:get( 'hooks' ) or { }
end

/*
    hook > count

    returns a count of registered hooks

    @return : int
*/

function count( )
    local t     = source( )
    local cnt   = 0
    for k, v in pairs( t ) do
        cnt = cnt + 1
    end

    return cnt
end

/*
    hook > session > set
*/

function s_Session( id, val )
    session             = session or { }
    session[ id ]       = val or id
end

/*
    hook > get session
*/

function g_Session( )
    return session or { }
end

/*
    rcc > base

    base package command
*/

local function rcc_rhook_base( pl, cmd, args )

    /*
        permissions
    */

    local ccmd = base.calls:get( 'commands', 'rhook' )

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, script, ccmd.id )
        return
    end

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, script, ccmd.id )
        return
    end

    /*
        output
    */

    con( pl, 1 )
    con( pl, 0 )
    con( pl, Color( 255, 255, 0 ), string.format( 'Manifest » %s', pkg_name ) )
    con( pl, 0 )
    con( pl, manifest.desc )
    con( pl, 1 )

    local a1_l              = string.format( '%-20s',  'Version'   )
    local a2_l              = string.format( '%-5s',  '»'   )
    local a3_l              = string.format( '%-35s',  string.format( 'v%s build-%s', rlib.get:ver2str( manifest.version ), manifest.build )   )

    con( pl, Color( 255, 255, 0 ), a1_l, Color( 255, 255, 255 ), a2_l, a3_l )

    local b1_l              = string.format( '%-20s',  'Author'    )
    local b2_l              = string.format( '%-5s',  '»'          )
    local b3_l              = string.format( '%-35s',  string.format( '%s', manifest.author ) )

    con( pl, Color( 255, 255, 0 ), b1_l, Color( 255, 255, 255 ), b2_l, b3_l )

    con( pl, 2 )

end

/*
    rcc > rehash

    refreshes all console commands
*/

local function rcc_rehash( pl, cmd, args )

    /*
        permissions
    */

    local ccmd = base.calls:get( 'commands', 'rhook_rcc_rehash' )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, mf.name, ccmd.id )
        return
    end

    /*
        perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, mf.name, ccmd.id )
        return
    end

    /*
        execute
    */

    RegisterRCC( true )

end

/*
    rcc > register

    @param  : bool bOutput
*/

function RegisterRCC( bOutput )

    local pkg_commands =
    {
        [ pkg_name ] =
        {
            enabled         = true,
            warn            = true,
            id              = g_PackageId( ),
            name            = pkg_name,
            desc            = 'returns package information',
            scope           = 2,
            clr             = Color( 255, 255, 0 ),
            assoc           = function( ... )
                                rcc_rhook_base( ... )
                            end,
        },
        [ pkg_name .. '_rcc_rehash' ] =
        {
            enabled     = true,
            warn        = true,
            id          = g_PackageId( 'rcc_rehash' ),
            desc        = 'reload all module rcc commands',
            scope       = 1,
            clr         = Color( 255, 255, 0 ),
            assoc       = function( ... )
                            rcc_rehash( ... )
                        end,
        },
    }

    /*
        rcc > register
    */

    base.calls.commands:Register( pkg_commands )

    /*
        save output
    */

    if not bOutput then return end

    local i = table.Count( pkg_commands )
    base:log( RLIB_LOG_OK, ln( 'rcc_rehash_i', i, pkg_name ) )
end
hook.Add( pid( 'cmd.register' ), pid( '__rhook.cmd.register' ), RegisterRCC )

/*
    register package
*/

local function register_pkg( )
    if not istable( _M ) then return end
    base.package:Register( _M )
end
hook.Add( pid( 'pkg.register' ), pid( '__rhook.pkg.register' ), register_pkg )

/*
    manifest
*/

function pkg:manifest( )
    return self.__manifest
end

/*
    __tostring
*/

function pkg:__tostring( )
    return self:_NAME( )
end

/*
    loader
*/

function pkg:loader( class )
    class               = class or { }
    self.__index        = self
    return setmetatable( class, self )
end

/*
    __index / manifest declarations
*/

pkg.__manifest =
{
    __index     = _M,
    name        = _NAME,
    build       = manifest.build,
    version     = manifest.version,
    author      = manifest.author,
    desc        = manifest.desc
}

pkg.__index     = pkg