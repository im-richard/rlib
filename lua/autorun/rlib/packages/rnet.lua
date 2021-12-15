/*
    @library        : rlib
    @package        : rnet
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
local sf                    = string.format

/*
    languages
*/

local function ln( ... )
    return base:lang( ... )
end

/*
    call id > get

    @source : lua\autorun\libs\_calls
    @param  : str id
*/

local function g_CallID( id )
    return base:call( 'net', id )
end

/*
    localize output functions
*/

local function con( ... )
    base:console( ... )
end

/*
    enums

    RNET_UINT and RNET_INT allow for a specified num of bits to be written and read

    int     : –2147483648 to 2147483647
    uint    : 0 to 4294967295
*/

    RNET_STR                = 1
    RNET_FLOAT              = 2
    RNET_BOOL               = 3
    RNET_TBL                = 4
    RNET_CLR                = 5
    RNET_UINT               = 6
    RNET_UINT4              = 7
    RNET_UINT8              = 8
    RNET_UINT16             = 9
    RNET_UINT32             = 10
    RNET_INT                = 11
    RNET_INT4               = 12
    RNET_INT8               = 13
    RNET_INT16              = 14
    RNET_INT32              = 15
    RNET_VEC                = 16
    RNET_PLY                = 17
    RNET_ENT                = 18
    RNET_BIT                = 19
    RNET_ID                 = 20        -- uint32                   || item ids
    RNET_UID32              = 21        -- str                      || pl steam32
    RNET_UID64              = 22        -- str                      || pl steam64
    RNET_UID64D             = 23        -- double                   || pl steam64
    RNET_DATE               = 24        -- uint32                   || timestamps
    RNET_DATA               = 25        -- str
    RNET_IDX                = 50        -- development only

/*
    enum definitions

    determines how each net Read/Write should be handled
*/

local netconst_lib =
{
    [ RNET_STR ] =
    {
        read                = function( ) return net.ReadString( ) end,
        write               = function( val ) net.WriteString( val ) end,
    },
    [ RNET_FLOAT ] =
    {
        read                = function( ) return net.ReadFloat( ) end,
        write               = function( val ) net.WriteFloat( val ) end,
    },
    [ RNET_BOOL ] =
    {
        read                = function( ) return net.ReadBool( ) end,
        write               = function( val ) net.WriteBool( val ) end,
    },
    [ RNET_TBL ] =
    {
        read                = function( ) return net.ReadTable( ) end,
        write               = function( val ) net.WriteTable( istable( val ) and val or { } ) end,
    },
    [ RNET_CLR ] =
    {
        read                = function( ) return net.ReadColor( ) end,
        write               = function( val ) net.WriteColor( IsColor( val ) and val or Color( 0, 0, 0, 255 ) ) end,
    },
    [ RNET_UINT ] =
    {
        read                = function( bits ) return net.ReadUInt( bits ) end,
        write               = function( val, bits ) net.WriteUInt( val, bits ) end,
    },
    [ RNET_UINT4 ] =
    {
        read                = function( ) return net.ReadUInt( 4 ) end,
        write               = function( val ) net.WriteUInt( val, 4 ) end,
    },
    [ RNET_UINT8 ] =
    {
        read                = function( ) return net.ReadUInt( 8 ) end,
        write               = function( val ) net.WriteUInt( val, 8 ) end,
    },
    [ RNET_UINT16 ] =
    {
        read                = function( ) return net.ReadUInt( 16 ) end,
        write               = function( val ) net.WriteUInt( val, 16 ) end,
    },
    [ RNET_UINT32 ] =
    {
        read                = function( ) return net.ReadUInt( 32 ) end,
        write               = function( val ) net.WriteUInt( val, 32 ) end,
    },
    [ RNET_INT ] =
    {
        read                = function( bits ) return net.ReadInt( bits ) end,
        write               = function( val, bits ) net.WriteInt( val, bits ) end,
    },
    [ RNET_INT4 ] =
    {
        read                = function( ) return net.ReadInt( 4 ) end,
        write               = function( val ) net.WriteInt( val, 4 ) end,
    },
    [ RNET_INT8 ] =
    {
        read                = function( ) return net.ReadInt( 8 ) end,
        write               = function( val ) net.WriteInt( val, 8 ) end,
    },
    [ RNET_INT16 ] =
    {
        read                = function( ) return net.ReadInt( 16 ) end,
        write               = function( val ) net.WriteInt( val, 16 ) end,
    },
    [ RNET_INT32 ] =
    {
        read                = function( ) return net.ReadInt( 32 ) end,
        write               = function( val ) net.WriteInt( val, 32 ) end,
    },
    [ RNET_VEC ] =
    {
        read                = function( ) return net.ReadVector( ) end,
        write               = function( val ) net.WriteVector( isvector( val ) and val or Vector( 0, 0, 0 ) ) end,
    },
    [ RNET_PLY ] =
    {
        read                = function( ) return Player( net.ReadUInt( 16 ) ) end,
        write               = function( val ) net.WriteUInt( IsValid( val ) and val:UserID( ) or 0, 16 ) end,
    },
    [ RNET_ENT ] =
    {
        read                = function( ) return net.ReadEntity( ) end,
        write               = function( val ) net.WriteEntity( helper.ok.any( val ) and val ) end,
    },
    [ RNET_BIT ] =
    {
        read                = function( ) return net.ReadBit( ) end,
        write               = function( val ) net.WriteBit( val ) end,
    },
    [ RNET_ID ] =
    {
        read                = function( ) return net.ReadUInt( 32 ) end,
        write               = function( val ) net.WriteUInt( val, 32 ) end,
    },
    [ RNET_UID32 ] =
    {
        read                = function( ) return net.ReadString( ) end,
        write               = function( val ) net.WriteString( val ) end,
    },
    [ RNET_UID64 ] =
    {
        read                = function( ) return net.ReadString( ) end,
        write               = function( val ) net.WriteString( val ) end,
    },
    [ RNET_UID64D ] =
    {
        read                = function( ) return net.ReadDouble( ) end,
        write               = function( val ) net.WriteDouble( val ) end,
    },
    [ RNET_DATE ] =
    {
        read                = function( ) return net.ReadUInt( 32 ) end,
        write               = function( val ) net.WriteUInt( val, 32 ) end,
    },
    [ RNET_DATA ] =
    {
        read                = function( bits ) return net.ReadData( bits ) end,
        write               = function( val )
                                local compressed = util.Compress( val )
                                net.WriteData( compressed, #compressed )
                            end,
    },
}

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

module( 'rnet', package.seeall )

/*
    local declarations
*/

local pkg                   = rnet
local pkg_name              = _NAME or 'rnet'

/*
    pkg declarations
*/

local manifest =
{
    author                  = 'richard',
    desc                    = 'network library',
    build                   = 110620,
    version                 = { 2, 2, 0 },
    debug_id                = 'rnet.debug.delay',
}

/*
    required tables
*/

cfg                         = cfg or { }
sys                         = sys or { }

index                       = index         or { }
directory                   = directory     or { }
session                     = session       or { }
execute                     = execute       or { }
routing                     = routing       or { }
routing.save                = routing.save  or { }
send                        = { }

/*
    net > debugging

    determines if debugging mode is enabled
*/

cfg.debug                   = cfg.debug or false

/*
    package id

    creates rcc command with package name appended to the front
    of the string.

    @param  : str str
*/

local function g_PackageId( str )
    str         = isstring( str ) and str ~= '' and str or false
                if not str then return pkg_name end

    return pid( str, pkg_name )
end

/*
    returns directory table
*/

function g_Directory( )
    return istable( directory ) and directory or { }
end

/*
    returns index table
*/

function g_Index( )
    return istable( index ) and index or { }
end

/*
    get session
*/

function g_Session( )
    return istable( session ) and session or { }
end

/*
    env

    returns registered net.
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

    returns if rnet was actually used within
        rnet.new
        rnet.create

    @param  : str id
    @return : bool
*/

function exists( id )
    return session and session[ id ] and true or false
end

/*
    reroute network functions

    @param  : func old_fn
    @param  : func new_fn
*/

local function reroute( old_fn, new_fn )
    if not isfunction( old_fn ) or not isfunction( new_fn ) then
        base:log( RLIB_LOG_RNET, '[ %s ] bad arg type for func [ %s ]', pkg_name, debug.getinfo( 1, 'n' ).name )
        return false
    end

    execute[ new_fn ] = old_fn
    return new_fn
end

/*
    rnet > reroute

    redirects netlib funcs to allow for prints to output to console and for logs to catch any data
    being transferred
        : enable   rnet:route( bEnable )
        : disable  rnet:route( )

    @param  : bool bEnable
*/

function rnet:route( bEnable )

    local restore = routing.save or { }

    if not bEnable then
        if sys.nrouter_enabled then
            net.Start       = restore[ 'start' ] or net.Start
            net.Receive     = restore[ 'receive' ] or net.Receive
            net.Incoming    = restore[ 'incoming' ] or net.Incoming

            sys.nrouter_enabled = false
            base:log( RLIB_LOG_NET, '[%s] Rerouting disabled', pkg_name )

            return false
        else
            base:log( RLIB_LOG_NET, '[%s] Rerouting is currently not enabled', pkg_name )
            return false
        end
    end

    execute = execute or { }

    if not sys.nrouter_f or sys.nrouter_f == nil then sys.nrouter_f = true end

    if sys.nrouter_f then
        restore[ 'start' ]        = not restore[ 'start' ] and net.Start or restore[ 'start' ]
        restore[ 'receive' ]      = not restore[ 'receive' ] and net.Receive or restore[ 'receive' ]
        restore[ 'incoming' ]     = not restore[ 'incoming' ] and net.Incoming or restore[ 'incoming' ]

        net.Start = reroute( net.Start, function( name, unreliable )
            --execute[ net.Start ]( name, unreliable )
            base:log( RLIB_LOG_RNET, 'net.Start :: [ %s ]', name )
        end )

        net.Receive = reroute( net.Receive, function( name, callback )
            --execute[ net.Receive ]( name, callback )
            base:log( RLIB_LOG_RNET, 'net.Receive :: [ %s ]', name )
        end )

        sys.nrouter_enabled, sys.nrouter_f = true, false
    end

    function net.Incoming( len, client )
        local i         = net.ReadHeader( )
        local name      = util.NetworkIDToString( i )

        if not name then
            base:log( RLIB_LOG_RNET, 'net.Incoming :: unpooled msg id for [ #%d ]', i )
            return false
        end

        local func = net.Receivers[ name:lower( ) ]

        if not func then
            base:log( RLIB_LOG_RNET, 'net.Incoming :: receiving func missing for [ %s ] net msg [ #%d ]', name, i )
            return false
        end

        len = len - 16

        base:log( RLIB_LOG_RNET, 'net.Incoming :: [ %s ] ( %d ) received ( %.2f kb ( %d b ) )', name, i, len / 8 / 1024, len / 8 )

        func( len, client )
    end

    cfg.debug = true
    base:log( RLIB_LOG_RNET, 'netlib functions being rerouted for debugging' )
end

/*
    status

    check status of routing
*/

function route_status( )
    local status = sys.nrouter_enabled and 'enabled' or 'disabled'
    base:log( RLIB_LOG_NET, 'routing [ %s ]', status )
end

/*
    table slot id

    creates a new id for directory / index entries

    @param  : tbl src
    @return : int
*/

local function g_SlotID( src )
    if not src or not istable( src ) then
        base:log( RLIB_LOG_RNET, 'cannot make id from invalid table' )
        return false
    end

    local id = table.Count( src ) + 1

    return id or 1
end

/*
    rnet > create

    creates a new netmsg data value

    @ex     :   rnet.create( 'network_string' )
                rnet.create( call( 'net', 'network_string' ) )

    @alias  :   new

    @param  : str id
*/

function create( id )
    if not isstring( id ) then
        base:log( RLIB_LOG_RNET, 'canceling net create - missing id' )
        return
    end

    local aid = GetGlobalString( 'rlib_sess', 0 )
    if tonumber( aid ) == 0 then
        timex.simple( 1, function( )
            create( id )
        end )
        return
    end

    session[ id ]   = id

    id              = g_CallID( id )
    local nid       = aid
    id              = string.format( '%s.%s', id, nid )

    local n_id      = g_SlotID( index )

    directory =
    {
        id          = id,
        nid         = n_id,
        params      = { },
    }

    if SERVER then
        util.AddNetworkString( id )
        base:log( RLIB_LOG_RNET, ln( 'rnet_added', id ) )
    end
end
new = create

/*
    rnet > write

    used to specify a new item to pass through the netmsg

    bits
        > number 1 to 32
            1 = bit
            4 = nibble
            8 = byte
            16 = short
            32 = long

    @ex     :   pass string:    rnet.write( 'item_name', RNET_STR )
                pass int:       rnet.write( 'item_name', RNET_INT, 4 )

    @param  : str name
    @param  : con enum
    @param  : int bits
*/

function write( name, enum, bits )
    local gid       = g_SlotID( directory.params )
    bits            = bits and math.Clamp( bits, 0, 32 ) or 0

    directory.params[ name ] =
    {
        id      = gid,
        enum    = enum,
        bits    = bits
    }
end
add = write

/*
    rnet > register

    called after setting up a new network entry.
    executes before base.calls:Catalog( )

    @ex     : rnet.register( )
*/

function register( )
    local id = directory.id

    if not isstring( id ) then
        base:log( RLIB_LOG_RNET, 'cannot register with invalid id' )
        return false
    end

    index[ id ] = table.Copy( directory )
end
run = register

/*
    rnet > read

    fetches the specified const from net const table

    @param  : int const
    @param  : int bits
    @return : tbl
*/

local function read( const, bits )
    if not netconst_lib[ const ] then
        base:log( RLIB_LOG_RNET, 'invalid read type specified' )
        return false
    end

    return netconst_lib[ const ].read( bits )
end

/*
    rnet > call / get

    requires id (str)

    a, b are shiftable between bool / func
    a specifies a bool for silencing the konsole or can be specified as a function but debugging
    will return a response in the console

    @param  : str id
    @param  : bool, func a
    @param  : func b
*/

function call( id, a, b )

    local bSilenced = false
    local action

    /*
        check > a, b exist
    */

    if not a and not b then
        base:log( RLIB_LOG_ERR, 'canceling netmsg call -- missing params for id [ %s ]', id )
        return false
    end

    local aid = GetGlobalString( 'rlib_sess', 0 )
    if tonumber( aid ) == 0 then
        timex.simple( 1, function( )
            call( id, a, b )
        end )
        return
    end

    /*
        get net id

        utilizes rlib.call
    */

    id                      = g_CallID( id )
    local nid               = aid
    id                      = string.format( '%s.%s', id, nid )

    /*
        a false but b provided
    */

    if not a and isfunction( b ) then
        action = b
    elseif isfunction( a ) then
        action = a
    elseif isbool( a ) and isfunction( b ) then
        bSilenced = a and true or false
        action = b
    end

    net.Receive( id, function( len, pl )
        local obj, data     = index[ id ], { }

        if istable( obj ) and obj.params then
            for item, param in SortedPairsByMemberValue( obj.params, 'id' ) do
                local bits      = param and param.bits or 0
                data[ item ]    = read( param.enum, bits )
            end
        end

        if not isfunction( action ) then
            base:log( RLIB_LOG_RNET, 'call :: net.Receive :: [ %s ] :: missing action', id )
            return false
        end

        action( data, pl )

        if not bSilenced then
            base:log( RLIB_LOG_RNET, 'call :: net.Receive :: [ %s ] :: %i b', id, len / 8 )
        end
    end )
end
get = call

/*
    rnet > setup

    runs during rnet prep to setup network structure including params and read/write bit sizes (if applic)

    @param  : con const
    @param  : str val
    @param  : int bits
*/

local function setup( const, val, bits )
    netconst_lib[ const ].write( val, bits )
end

/*
    rnet > prepare

    data are the items that will be passed through the netmsg

    @param  : str id
    @param  : tbl data
    @param  : bool bSilence
*/

local function prepare( id, data, bSilence )
    if not isstring( id ) then
        base:log( RLIB_LOG_ERR, 'prepare :: cannot prep an invalid id' )
        return
    end

    local obj   = index[ id ]

    if not istable( obj ) then
        base:log( RLIB_LOG_ERR, 'prepare [ %s ] :: unregistered object failed', id )
        return
    end

    net.Start( id )

    for item, param in SortedPairsByMemberValue( obj.params, 'id' ) do
        local bits = param and param.bits or 0
        setup( param.enum, data[ item ], bits )
    end

    if not bSilence then
        local sent = net.BytesWritten( ) or 0
        base:log( RLIB_LOG_RNET, 'prepare [ %s ] :: %i b', id, sent )
    end
end

if SERVER then

    /*
        rnet > send > player

        sends netmsg to specified player

        @ex     : rnet.send.player( ply, 'netmsg_str_id', { item_id = id } )
                : rnet.send.player( ply, 'netmsg_str_id' )

        @param  : ply pl
        @param  : str id
        @param  : tbl data
        @param  : bool bSilence
    */

    function send.player( pl, id, data, bSilence )
        if not helper.ok.ply( pl ) and not istable( pl ) then
            base:log( RLIB_LOG_RNET, '[ %s ] :: [ %s ] :: invalid pl', debug.getinfo( 1, 'n' ).name, id )
            return false
        end

        if not id then
            local trback = debug.traceback( )
            base:log( RLIB_LOG_RNET, 'bad rnet id specified\n%s', trback )
            return
        end

        local aid = GetGlobalString( 'rlib_sess', 0 )
        if tonumber( aid ) == 0 then
            timex.simple( 1, function( )
                send.player( pl, id, data, bSilence )
            end )
            return
        end

        id                  = g_CallID( id )
        local nid           = aid
        id                  = string.format( '%s.%s', id, nid )

        data                = istable( data ) and data or { }
        local bSilenced     = bSilence and true or false

        prepare( id, data, bSilenced )
        net.Send( pl )
    end

    /*
        rnet > send > all

        sends broadcasted netmsg to all players

        @ex     : rnet.send.all( 'netmsg_str_id', { item_id = id } )
                : rnet.send.all( 'netmsg_str_id' )

        @param  : str id
        @param  : tbl data
        @param  : bool bSilence
    */

    function send.all( id, data, bSilence )
        if not id then
            local trback = debug.traceback( )
            base:log( RLIB_LOG_RNET, 'bad rnet id specified\n%s', trback )
            return
        end

        local aid = GetGlobalString( 'rlib_sess', 0 )
        if tonumber( aid ) == 0 then
            timex.simple( 1, function( )
                send.all( id, data, bSilence )
            end )
            return
        end

        id                  = g_CallID( id )
        local nid           = aid
        id                  = string.format( '%s.%s', id, nid )

        data                = istable( data ) and data or { }
        local bSilenced     = bSilence and true or false

        prepare( id, data, bSilenced )
        net.Broadcast( )
    end

    /*
        rnet > send > pvs

        sends msg to players that can potentially see this position

        @ex     : rnet.send.pvs( pos, 'netmsg_str_id', { item_id = id } )
                : rnet.send.pvs( Vector( 0, 0, 0 ), 'netmsg_str_id' )

        @param  : vec vec
        @param  : str id
        @param  : tbl data
        @param  : bool bSilence
    */

    function send.pvs( vec, id, data, bSilence )
        if not isvector( vec ) then
            base:log( RLIB_LOG_RNET, '[ %s ] :: [ %s ] :: invalid PVS vector', debug.getinfo( 1, 'n' ).name, id )
            return false
        end

        if not id then
            local trback = debug.traceback( )
            base:log( RLIB_LOG_RNET, 'bad rnet id specified\n%s', trback )
            return
        end

        local aid = GetGlobalString( 'rlib_sess', 0 )
        if tonumber( aid ) == 0 then
            timex.simple( 1, function( )
                send.pvs( vec, id, data, bSilence )
            end )
            return
        end

        id                  = g_CallID( id )
        local nid           = aid
        id                  = string.format( '%s.%s', id, nid )

        data                = istable( data ) and data or { }
        local bSilenced     = bSilence and true or false

        prepare( id, data, bSilenced )
        net.SendPVS( vec )
    end

    /*
        rnet > send > pas

        adds all plys that can potentially hear sounds from this position.

        @ex     : rnet.send.pas( pos, 'netmsg_str_id', { item_id = id } )
                : rnet.send.pas( Vector( 0, 0, 0 ), 'netmsg_str_id' )

        @param  : vec vec
        @param  : str id
        @param  : tbl data
        @param  : bool bSilence
    */

    function send.pas( vec, id, data, bSilence )
        if not isvector( vec ) then
            base:log( RLIB_LOG_RNET, '[ %s ] :: [ %s ] :: invalid PAS vector', debug.getinfo( 1, 'n' ).name, id )
            return false
        end

        if not id then
            local trback = debug.traceback( )
            base:log( RLIB_LOG_RNET, 'bad rnet id specified\n%s', trback )
            return
        end

        local aid = GetGlobalString( 'rlib_sess', 0 )
        if tonumber( aid ) == 0 then
            timex.simple( 1, function( )
                send.pas( vec, id, data, bSilence )
            end )
            return
        end

        id                  = g_CallID( id )
        local nid           = aid
        id                  = string.format( '%s.%s', id, nid )

        data                = istable( data ) and data or { }
        local bSilenced     = bSilence and true or false

        prepare( id, data, bSilenced )
        net.SendPAS( vec )
    end

else

    /*
        rnet > send.server

        sends netmsg to server

        @ex     : rnet.send.server( 'netmsg_str_id', { item_id = id } )
                : rnet.send.server( 'netmsg_str_id' )

        @param  : str id
        @param  : tbl data
    */

    function send.server( id, data )
        if not id then
            local trback = debug.traceback( )
            base:log( RLIB_LOG_RNET, 'bad rnet id specified\n%s', trback )
            return
        end

        local aid = GetGlobalString( 'rlib_sess', 0 )
        if tonumber( aid ) == 0 then
            timex.simple( 1, function( )
                send.server( id, data )
            end )
            return
        end

        id                  = g_CallID( id )
        local nid           = aid
        id                  = string.format( '%s.%s', id, nid )
        data                = istable( data ) and data or { }

        prepare( id, data )
        net.SendToServer( )
    end
end

/*
    scope > server
*/

if SERVER then

    /*
        effect > add

        adds a particle

        @ex     : rnet.fx_add( 'particle_name', self, self:GetAngles( ), self:GetPos( ), nil, 1 )
                  rnet.fx_add( 'particle_name', ent, Vector( x, x, x ), Vector( x, x, x ), 'sound/path.wav', 1, 4 )
                  rnet.fx_add( 'particle_name', self )

        @params : eff               name of particle
                  snd               sound file to attach
                  parent            parent ent
                  ang               vector angle
                  pos               vector position
                  attach_id         id of the attachment to be used in the way specified by the attachType
                  attach_type       attachment type using PATTACH_Enums
                                    :   0   PATTACH_ABSORIGIN
                                    :   1   PATTACH_ABSORIGIN_FOLLOW
                                    :   2   PATTACH_CUSTOMORIGIN
                                    :   3   PATTACH_POINT
                                    :   4   PATTACH_POINT_FOLLOW
                                    :   5   PATTACH_WORLDORIGIN

        @param  : str eff
        @param  : ent parent
        @param  : vec ang
        @param  : vec pos
        @param  : str snd
        @param  : int attach_id
        @param  : int attach_type
    */

    function fx_add( eff, parent, ang, pos, snd, attach_id, attach_type )
        if not isstring( eff ) then return end
        if not IsValid( parent ) then return end

        local fx        = { }
        fx.eff          = eff
        fx.parent       = parent
        fx.ang          = isvector( ang ) and ang or IsValid( parent ) and parent:GetAngles( )
        fx.pos          = isvector( pos ) and pos or IsValid( parent ) and parent:GetPos( )
        fx.snd          = isstring( snd ) and snd or nil
        fx.attach_id    = isnumber( attach_id ) and attach_id or 1
        fx.attack_type  = isnumber( attach_type ) and attach_type or attach_type or 4

        rnet.send.all( 'rlib_eff_add', { src = fx } )
    end

    /*
        effect > remove

        removes a particle

        @ex     : rnet.fx_rem( self, 'particle_name', nil )
                  rnet.fx_rem( Vector( x, x, x ), 'particle_name', 'sound/file.wav' )

        @param  : vec, ent parent
        @param  : str eff
        @param  : str snd
    */

    function fx_rem( parent, eff, snd )
        if not helper.ok.ent( parent ) and not isvector( parent ) then return end
        local pos = isvector( parent ) and parent or helper.ok.ent( parent ) and parent:GetPos( ) or Vector( 0, 0, 0 )

        local fx    = { }
        fx.eff      = eff
        fx.parent   = parent
        fx.snd      = snd

        rnet.send.all( 'rlib_eff_rem', { src = fx } )
    end

end

/*
    scope > client
*/

if CLIENT then

    /*
        rnet > effect > add

        @param  : tbl data
    */

    local function fx_eff_add( data )
        local fx = data.src

        if not fx then return end
        if fx.parent == nil then return end
        if not IsValid( fx.parent ) then return end

        if fx.snd then
            fx.parent:EmitSound( fx.snd )
        end

        if fx.eff then
            if fx.attach then
                ParticleEffectAttach( fx.eff, fx.attach_type or 4 , fx.parent, fx.attach_id )
            else
                ParticleEffect( fx.eff, fx.pos, fx.ang, fx.parent )
            end
        end
    end
    rnet.call( 'rlib_eff_add', fx_eff_add )

    /*
        rnet > effect > remove

        @param  : tbl data
    */

    local function fx_eff_rem( data )
        local fx = data.src

        if not fx then return end
        if fx.parent == nil then return end
        if not IsValid( fx.parent ) then return end

        if fx.snd then
            fx.parent:StopSound( fx.snd )
        end

        if fx.eff then
            fx.parent:StopParticlesNamed( fx.eff )
        end
    end
    rnet.call( 'rlib_eff_rem', fx_eff_rem )

end

/*
    rnet > source

    returns source tbl for timers

    @return : tbl
*/

function source( )
    return base.calls:get( 'net' ) or { }
end

/*
    rnet > list

    returns a list of all registered rnet items.
*/

function list( )
    return g_Index( )
end

/*
    rnet > count

    returns a count of registered nets

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
    rcc > debug

    toggles rnet debug mode
*/

local function rcc_debug( pl, cmd, args )

    /*
        permissions
    */

    local ccmd = base.calls:get( 'commands', 'rnet_debug' )

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

    local time_id           = manifest.debug_id
    local status            = args and args[ 1 ] or false
    local dur               = args and args[ 2 ] or 300

    if status and status ~= 'status' then
        local param_status = helper.util:toggle( status )
        if param_status then
            if timex.exists( time_id ) then
                local remains = timex.secs.sh_cols_steps( timex.remains( time_id ) ) or 0
                base:log( RLIB_LOG_NET, ln( 'debug_enabled_already', remains ) )
                return
            end

            if dur and not helper:bIsNum( dur ) then
                base:log( RLIB_LOG_NET, ln( 'debug_err_duration' ) )
                return
            end

            cfg.debug = true
            base:log( RLIB_LOG_NET, ln( 'debug_set_enabled_dur', dur ) )

            timex.create( time_id, dur, 1, function( )
                base:log( RLIB_LOG_NET, ln( 'debug_auto_disable' ) )
                cfg.debug = false
            end )
        else
            timex.expire( time_id )
            base:log( RLIB_LOG_NET, ln( 'debug_set_disabled' ) )
            cfg.debug = false
        end
    else
        if cfg.debug then
            if timex.exists( time_id ) then
                local remains = timex.secs.sh_cols_steps( timex.remains( time_id ) ) or 0
                base:log( RLIB_LOG_NET, ln( 'debug_enabled_time', remains ) )
            else
                base:log( RLIB_LOG_NET, ln( 'debug_enabled' ) )
            end
            return
        else
            base:log( RLIB_LOG_NET, ln( 'debug_disabled' ) )
        end

        base:log( RLIB_LOG_NET, ln( 'rnet_debug_help_info_1' ) )
        base:log( RLIB_LOG_NET, ln( 'rnet_debug_help_info_2' ) )
    end
end

/*
    rcc > rehash

    refreshes all console commands
*/

local function rcc_rehash( pl, cmd, args )

    /*
        permissions
    */

    local ccmd = base.calls:get( 'commands', 'rnet_rcc_rehash' )

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
    rcc > base

    base package command
*/

local function rcc_base( pl, cmd, args )

    /*
        permissions
    */

    local ccmd = base.calls:get( 'commands', 'rnet' )

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
        output
    */

    base.msg:route( pl, false, pkg_name, mf.name .. ' package' )
    base.msg:route( pl, false, pkg_name, 'v' .. rlib.get:ver2str( manifest.version ) .. ' build-' .. manifest.build )
    base.msg:route( pl, false, pkg_name, 'developed by ' .. manifest.author )
    base.msg:route( pl, false, pkg_name, manifest.desc .. '\n' )

end

/*
    rcc > reload modules

    refreshes rnet for each installed module
*/

local function rcc_reload( pl, cmd, args )

    /*
        permissions
    */

    local ccmd = base.calls:get( 'commands', 'rnet_reload' )

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
        reload all rnet registration hooks
    */

    if not rcore then
        base.msg:route( pl, false, pkg_name, 'cannot reload rnet registration hooks -- rcore missing' )
        return
    end

    /*
        loop rcore modules
    */

    for k, v in pairs( rcore.modules ) do
        if not v.enabled then continue end

        local suffix    = rcore:modules_prefix( v )
        local id        = sf( '%srnet.register', suffix )

                        rhook.run.gmod( id )

        if rnet.cfg.debug then
            base:log( RLIB_LOG_RNET, 'registered module [ %s ]', id )
        end
    end

    base.msg:route( pl, false, pkg_name, 'reloaded all rnet packages' )

end

/*
    rcc > index

    returns index for rnet
*/

local function rcc_index( pl, cmd, args )

    /*
        permissions
    */

    local ccmd = base.calls:get( 'commands', 'rnet_index' )

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
        functionality
    */

    local output        = sf( '\n\n [ %s ] :: %s :: index', mf.name, pkg_name )
    base:console        ( pl, output )
    base:console        ( pl, '\n--------------------------------------------------------------------------------------------' )
    helper.p_table      ( index )
    base:console        ( pl, '\n--------------------------------------------------------------------------------------------' )

end

/*
    rcc > list

    returns list of registered rnet items
*/

local function rcc_list( pl, cmd, args )

    /*
        permissions
    */

    local ccmd = base.calls:get( 'commands', 'rnet_list' )

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
        functionality
    */

    local lst = { }
    for k, v in pairs( g_Index( ) ) do
        table.insert( lst, k )
    end
    table.sort( lst, function( a, b ) return a[ 1 ] < b[ 1 ] end )

    con( 'c', 3 )
    con( 'c', 0 )
    con( 'c',       sf( '%s » %s', mf.name, pkg_name ), Color( 255, 255, 255 ), ' » Registered Items' )
    con( 'c', 0 )
    con( 'c', 1 )

    local a1_l      = sf( '%-35s',  'Name'      )
    local a2_l      = sf( '%-5s',  '»'          )
    local a3_l      = sf( '%-35s',  'ID'        )

    con( 'c',       Color( 255, 255, 0 ), a1_l, Color( 255, 255, 255 ), a2_l, a3_l )
    con( 'c', 0 )
    con( 'c', 1 )

    for k, v in SortedPairs( lst ) do
        local a1_2      = sf( '%-35s',  v       )
        local a2_2      = sf( '%-5s',  '»'      )
        local a3_2      = sf( '%-35s',  k       )

        con( 'c',       Color( 255, 255, 0 ), a1_2, Color( 255, 255, 255 ), a2_2, a3_2 )
    end

    con( 'c', 3 )

end

/*
    rcc > reroute

    after being activated, all net msgs sent and received will be logged in the console.
*/

local function rcc_router( pl, cmd, args )

    /*
        permissions
    */

    local ccmd = base.calls:get( 'commands', 'rnet_router' )

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
        functionality
    */

    local arg_toggle        = args and args[ 1 ]
    arg_toggle              = helper.util:toggle( arg_toggle )

    if not rnet then
        base:log( 2, '%s module not found, cannot toggle routing', pkg_name )
        return false
    end

    rnet:route( arg_toggle )
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
            enabled     = true,
            warn        = true,
            id          = g_PackageId( ),
            desc        = 'information about module',
            scope       = 2,
            clr         = Color( 255, 255, 0 ),
            assoc       = function( ... )
                            rcc_base( ... )
                        end,
        },
        [ pkg_name .. '_debug' ] =
        {
            enabled     = true,
            warn        = true,
            id          = g_PackageId( 'debug' ),
            desc        = 'toggles debugging | view netmsg outputs',
            scope       = 1,
            clr         = Color( 255, 255, 0 ),
            assoc       = function( ... )
                            rcc_debug( ... )
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
        [ pkg_name .. '_reload' ] =
        {
            enabled     = true,
            warn        = true,
            id          = g_PackageId( 'reload' ),
            desc        = 'reload all module rnet registration hooks',
            scope       = 1,
            clr         = Color( 255, 255, 0 ),
            assoc       = function( ... )
                            rcc_reload( ... )
                        end,
        },
        [ pkg_name .. '_router' ] =
        {
            enabled     = true,
            warn        = true,
            id          = g_PackageId( 'router' ),
            desc        = 'toggles debug mode network routing',
            scope       = 1,
            clr         = Color( 255, 255, 0 ),
            assoc       = function( ... )
                            rcc_router( ... )
                        end,
        },
        [ pkg_name .. '_index' ] =
        {
            enabled     = true,
            warn        = true,
            id          = g_PackageId( 'index' ),
            desc        = 'returns rnet index',
            scope       = 1,
            clr         = Color( 255, 255, 0 ),
            assoc       = function( ... )
                            rcc_index( ... )
                        end,
        },
        [ pkg_name .. '_list' ] =
        {
            enabled     = true,
            warn        = true,
            id          = g_PackageId( 'list' ),
            desc        = 'returns registered rnet items',
            scope       = 1,
            clr         = Color( 255, 255, 0 ),
            assoc       = function( ... )
                            rcc_list( ... )
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
hook.Add( pid( 'cmd.register' ), pid( '__rnet.cmd.register' ), RegisterRCC )

/*
    localized netlibs
*/

local function register_rnet_libs( )
    new         ( 'rlib_eff_add'     )
        add     ( 'src', RNET_TBL    )
    run         (                    )

    new         ( 'rlib_eff_rem'     )
        add     ( 'src', RNET_TBL    )
    run         (                    )
end
hook.Add( pid( 'rnet.register' ), pid( '__rnet.rnet.register' ), register_rnet_libs )


/*
    register package
*/

local function register_pkg( )
    if not istable( _M ) then return end
    base.package:Register( _M )
end
hook.Add( pid( 'pkg.register' ), pid( '__rnet.pkg.register' ), register_pkg )

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
    class = class or { }
    self.__index = self
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