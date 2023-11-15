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

/*
    library > localize
*/

local cfg                   = base.settings
local mf                    = base.manifest
local pf                    = mf.prefix

/*
    languages
*/

local function ln( ... )
    return base:lang( ... )
end

/*
    localize output functions
*/

local function log( ... )
    base:log( ... )
end

/*
*   get > name
*
*   returns core lib name ( or prefix with bool bPrefix )
*
*   @param  : bool bPrefix
*   @return : str
*/

    function base.get:name( bPrefix )
        return not bPrefix and mf.name or pf
    end

/*
*   get > workshops
*
*   returns workshops that are loaded on the server through the various methods including rlib, rcore,
*   and individual modules.
*
*   @param  : tbl src
*   @return : tbl
*/

    function base.get:ws( src )
        return istable( src ) and src or base.w
    end

/*
*   get > version
*
*   returns the current running version of a specified manifest
*   no args = rlib version
*
*   @since  : v1.1.5
*   @param  : tbl, str mnfst
*   @param  : bool bLibReq
*   @return : tbl
*             major, minor, patch
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
*   get > version 2 string > manifest
*
*   returns the current running version of a specified manifest in human readable format
*
*   @param  : tbl mnfst
*   @param  : str char
*   @return : str
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
*   get > version 2 string > manifest
*
*   returns the current running version of a specified manifest in human readable format
*
*   @param  : tbl mnfst
*   @param  : str char
*   @return : str
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
*   get > version 2 string
*
*   converts an rlib version table to human readable format
*
*   @note   : will replace get:version and get:ver2str soon
*
*   @ex     : base.get:ver2str( { 3, 0, 2, 1 } )
*             3.0.2.1
*
*   @return : str
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
*   base > get > structured
*
*   returns version tbl as table with major, minor, patch keys
*
*   @ex     : rlib.get:ver_struct( { 1, 4, 5, 1 } )
*             return {
*                       'major' = 1,
*                       'minor' = 4,
*                       'patch' = 5,
*                       'build' = 1
*                   }
*
*   @since  : v3.0.0
*   @param  : tbl ver
*   @return : tbl
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
*   base > get > version structure > string to version table
*
*   takes a string with 4 segments and returns them as a structured version
*   table.
*
*   @ex     : rlib.get:ver_struct_str( '1.0.0.0' )
*             returns { 1.0.0.0 }
*
*   @since  : v3.3.0
*   @param  : str ver
*   @return : tbl
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
*   helper > get > ver > package
*
*   returns version tbl as string for rlib packages such as rhook,
*   timex, calc, etc.
*
*   @ex     : rlib.get.ver_pkg( { 1, 4, 5, 0 } )
*   @ret    : 1.4.5.0
*
*   @param  : tbl ver
*   @return : str
*/

    function base.get:ver_pkg( src )
        if not src then return '1.0.0.0' end
        return ( src and src.__manifest and self:ver2str( src.__manifest.version ) ) or { 1, 0, 0, 0 }
    end

/*
*   get > os
*
*   return the operating system for the server the script is running on
*
*   @return : str, int
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
*   get > host
*
*   return the server hostname
*
*   @param  : bool bClean
*   @param  : bool bLower
*   @return : str
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
*   get > address
*
*   return the current ip address and port for the server
*
*   @return : str
*/

    function base.get:addr( )
        return helper.str:split_addr( game.GetIPAddress( ) )
    end

/*
*   get > gamemode
*
*   return the server gamemode utilizing engine.ActiveGamemode
*
*   @param  : bool bLower
*   @param  : bool bClean
*   @return : str, str
*/

    function base.get:gm( bLower, bClean )
        local gm_name       = engine.ActiveGamemode( ) or ln( 'sys_gm_sandbox' )
        gm_name             = bLower and gm_name:lower( ) or gm_name
        gm_name             = bClean and helper.str:escape( gm_name ) or gm_name

        return gm_name
    end

/*
*   get > gamemode > base
*
*   return the server gamemode based on GM / GAMEMODE table
*
*   @param  : bool bCombine
*   @param  : bool bLower
*   @param  : bool bClean
*   @return : str, str
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
*   get > hash
*
*   create hash from server ip and port
*
*   @return : str
*/

    function base.get:hash( )
        local ip, port  = self:addr( )
                        if not ip then return end

        port            = port or '27015'
        local cs        = util.CRC( string.format( '%s:%s', ip, port ) )

        return string.format( '%x', cs )
    end

/*
*   get > server ip
*
*   return server ip
*
*           :   char
*               if bool and true; will replace separate segments with |
*               if str provided, that will be used as separator
*
*   @usage  : base.get:ip( '-' )
*             returns 127-0-0-1
*
*           : base.get:ip( true )
*             returns 127|0|0|1
*
*           : base.get:ip( )
*             returns 127.0.0.1
*
*   @param  : str, bool char
*   @return : str
*/

    function base.get:ip( char )
        local ip        = game.GetIPAddress( )
        local e         = string.Explode( ':', ip )
        sep             = ( isstring( char ) and char ) or ( isbool( char ) and char == true and '|' ) or '.'
        local resp      = e[ 1 ]:gsub( '[%p]', sep )

        return resp
    end

/*
*   get > server port
*
*   returns server port
*
*   @return : str
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
*   get > prefix
*
*   creates a proper str id based on the params provided
*
*   local function pref( str, suffix )
*       local state = not suffix and mod or isstring( suffix ) and suffix or false
*       return rlib.get:pref( str, state )
*   end
*
*   @call   : pref( 'pnl.root' )
*             returns 'modname.pnl.root'
*
*           : pref( 'pnl.root', true )
*             returns 'rlib.pnl.root'
*
*           : pref( 'pnl.root', 'test' )
*             returns 'test.pnl.root'
*
*   @param  : str id
*   @param  : tbl, str, bool suffix
*   @return : str
*/

    function base.get:pref( id, suffix )
        local affix     = istable( suffix ) and suffix.id or isstring( suffix ) and suffix or pf
        affix           = affix:sub( -1 ) ~= '.' and string.format( '%s.', affix ) or affix

        id              = isstring( id ) and id or 'noname'
        id              = id:gsub( '[%p%c%s]', '.' )

        return string.format( '%s%s', affix, id )
    end

/*
*   get > prefix > li
*
*   creates a proper str id based on the params provided
*   similar to base.get:pref but allows for underscores
*
*   @call   : pref( 'pnl_root' )
*             returns 'modname.pnl_root'
*
*           : pref( 'pnl.root', true )
*             returns 'rlib.pnl.root'
*
*           : pref( 'pnl_root', 'test' )
*             returns 'test.pnl_root'
*
*   @param  : str id
*   @param  : tbl, str, bool suffix
*   @return : str
*/

    function base.get:prefli( id, suffix )
        local affix     = istable( suffix ) and suffix.id or isstring( suffix ) and suffix or pf
        affix           = affix:sub( -1 ) ~= '.' and string.format( '%s.', affix ) or affix

        id              = isstring( id ) and id or 'noname'
        id              = id:gsub( '[%p%c%s]', '.' )

        return string.format( '%s%s', affix, id )
    end

/*
*   base > parent owners
*
*   fetches the parent script owners to use in a table
*
*   @ex     : local owners = rlib.get:owners( )
*
*   @param  : tbl source
*/

    function base.get:owners( source )
        source = source or base.plugins or { }

        if not istable( source ) then
            log( 2, 'missing table for » [ %s ]', debug.getinfo( 1, 'n' ).name )
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