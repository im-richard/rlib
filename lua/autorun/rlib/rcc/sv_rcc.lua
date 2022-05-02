/*
    @library        : rlib
    @package        : rcc
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
local access                = base.a
local storage               = base.s
local tools                 = base.t
local cvar                  = base.v
local sys                   = base.sys

/*
    Localized rlib routes
*/

local cfg                   = base.settings
local mf                    = base.manifest
local pf                    = mf.prefix
local script                = mf.name

/*
    Localized lua funcs
*/

local sf                    = string.format

/*
    manifest paths
*/

local path_logs             = mf.paths[ 'dir_logs' ]
local path_uconn            = mf.paths[ 'dir_uconn' ]
local path_server           = mf.paths[ 'dir_server' ]

/*
    localize clrs
*/

local clr_r                 = Color( 255, 0, 0 )
local clr_y                 = Color( 255, 255, 0 )
local clr_w                 = Color( 255, 255, 255 )
local clr_g                 = Color( 0, 255, 0 )
local clr_p                 = Color( 255, 0, 255 )

/*
    localize output functions
*/

local function con      ( ... ) base:console( ... ) end
local function log      ( ... ) base:log( ... ) end
local function route    ( ... ) base.msg:route( ... ) end

/*
    Localized translation func
*/

local function ln( ... )
    return base:lang( ... )
end

/*
    localized http.fetch
*/

local function oort( ... )
    return http.Fetch( ... )
end

/*
    rcc > user

    manages a players access with rlib

    : subargs
        : add < player >
        : remove < player >

    @call   : rlib.user < subarg > < player >
*/

local function rcc_user( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_user' )

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

    if not access:bIsRoot( pl ) then return end

    /*
        functionality
    */

    local subarg = args and args[ 1 ] or nil
    local target = args and args[ 2 ] or false

    if not target then
        route( pl, script, 'You must supply at least a valid partial', cfg.cmsg.clrs.target, 'player name' )
        return
    end

    local c_results, result = helper.who:name_wc( target )

    if c_results > 1 then
        route( pl, script, 'More than one result was found, type more of the name. Place in quotes for names with spaces. Example:', cfg.cmsg.clrs.target, '\"John Doe\"' )
        return
    elseif not c_results or c_results < 1 then
        if subarg == 'remove' or subarg == '-r' then
            local users = access:getusers( )

            local i, user, user_name = 0, false, 'unknown'
            for k, v in pairs( users ) do
                local ply_name = v.name:lower( )
                if ( string.find( ply_name, target, 1, true ) == nil ) then continue end
                user        = k
                user_name   = v.name
                i           = i + 1
            end

            if i > 1 then
                route( pl, script, 'More than one result was found, type more of the name. Place in quotes for names with spaces. Example:', cfg.cmsg.clrs.target, '\"John Doe\"' )
                return
            elseif i == 0 then
                route( pl, script, 'No valid player found' )
                return
            elseif i == 1 then
                local bRemoved = access:deluser( user )

                if bRemoved then
                    route( pl, script, 'Successfully removed player', cfg.cmsg.clrs.target, user_name, cfg.cmsg.clrs.msg, 'from rlib access' )
                else
                    route( pl, script, 'No access found for player', cfg.cmsg.clrs.target, user_name )
                end
            end
        else
            route( pl, script, 'No results found! Place in quotes for names with spaces. Example:', cfg.cmsg.clrs.target, '\"John Doe\"' )
            return
        end
    else
        if not helper.ok.ply( result[ 0 ] ) then
            route( pl, script, 'No valid player found' )
            return
        else
            result = result[ 0 ]
            if subarg == 'add' or subarg == '-a' then
                local bExists = access:writeuser( result )

                if bExists then
                    route( pl, script, 'user', cfg.cmsg.clrs.target, result:Name( ), cfg.cmsg.clrs.msg, 'already exists' )
                else
                    route( pl, script, 'Successfully added player', cfg.cmsg.clrs.target, result:Name( ), cfg.cmsg.clrs.msg, 'to rlib access' )
                end
            elseif subarg == 'remove' or subarg == '-r' then
                local bRemoved = access:deluser( result )

                if bRemoved then
                    route( pl, script, 'Successfully removed player', cfg.cmsg.clrs.target, result:Name( ), cfg.cmsg.clrs.msg, 'from rlib access' )
                else
                    route( pl, script, 'no access found for player', cfg.cmsg.clrs.target, result:Name( ) )
                end
            elseif subarg == 'status' or subarg == '-s' then
                local bExists = access:hasuser( result )
                if not bExists then
                    route( pl, script, cfg.cmsg.clrs.target, result:Name( ), cfg.cmsg.clrs.msg, 'does not have access' )
                else
                    route( pl, script, cfg.cmsg.clrs.target, result:Name( ), cfg.cmsg.clrs.msg, 'has admin access' )
                end
            end

            -- update admins list for perms
            net.Start       ( 'rlib.user'   )
            net.WriteTable  ( access.admins )
            net.Broadcast   (               )

        end
    end

end
rcc.register( 'rlib_user', rcc_user )

/*
    rcc > debug > clean

    cleans files in debug log folder
*/

local function rcc_debug_clean( pl, cmd, args, str )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_debug_clean' )

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

    local arg_flag          = args and args[ 1 ] or false
    arg_flag                = helper.str:ok( arg_flag ) and arg_flag:lower( ) or false

    local gcf_cancel        = base.calls:gcflag( 'rlib_debug_clean', 'cancel' )
    local timer_clean       = cfg.debug.clean_delaytime

    if ( arg_flag and ( arg_flag == gcf_cancel ) or ( arg_flag == '-cancel' or arg_flag == 'cancel' ) and timex.exists( 'rlib_debug_doclean' ) ) then
        timex.expire( 'rlib_debug_doclean' )
        log( 4, ln( 'logs_clean_cancel' ) )
        return
    end

    if arg_flag then
        log( 2, ln( 'cmd_param_invalid', timer_clean, pf ) )
        return
    end

    log( 4, ln( 'logs_clean_scheduled', timer_clean, pf, '-c' ) )

    timex.create( 'rlib_debug_doclean', timer_clean, 1, function( )
        local files, _ = file.Find( path_logs .. '/*', 'DATA' )

        local i_del = 0
        for v in helper.get.data( files ) do
            local file_path = sf( '%s/%s', path_logs, v )
            file.Delete( file_path )

            i_del = i_del + 1
        end

        log( 4, ln( 'logs_clean_success', i_del, path_logs ) )
    end )

end
rcc.register( 'rlib_debug_clean', rcc_debug_clean )

/*
    rcc > debug > diag

    checks a variety of areas to prep from dev -> production
*/

local function rcc_debug_diag( pl, cmd, args, str )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_debug_diag' )

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

    con( pl, '\n' )
    con( pl, clr_y, script, clr_p, ' » ', clr_w, 'Debug Diag' )
    con( pl, 0 )
    con( pl, clr_w, 'Information listed below is for the developer to utilize in order to determine what state\n the current build is configured in.' )
    con( pl, 0 )

    local h1_l = sf( '\n %s » %s', script, 'General' )
    con( pl, clr_r, h1_l .. '\n' )

    local get_state =
    {
        { id = ln( 'status_col_branch' ),         val = cvar:GetStr( 'rlib_branch', 'stable' ) },
        { id = ln( 'status_col_basecmd' ),        val = sys.calls_basecmd or ln( 'none' ) },
        { id = ln( 'status_col_debug' ),          val = base:g_Debug( ) and ln( 'opt_enabled' ) or ln( 'opt_disabled' ) },
        { id = ln( 'status_col_rnet_route' ),     val = rnet and rnet.sys.nrouter_enabled and ln( 'opt_enabled' ) or ln( 'opt_disabled' ) },
        { id = ln( 'status_col_rnet_debug' ),     val = rnet and rnet.cfg.debug and ln( 'opt_enabled' ) or ln( 'opt_disabled' ) },
        { id = ln( 'status_col_rcore' ),          val = istable( rcore ) and ln( 'opt_yes' ) or ln( 'opt_no' ) },
    }

    for m in helper.get.data( get_state ) do
        if not m.val then continue end

        local id    = tostring( m.id )
        local val   = tostring( m.val )

        local l1_d, l2_d, cs_data = '', '', ''
        l1_d        = sf( '%-20s', id )
        cs_data     = sf( '%-5s', ' » ' )
        l2_d        = sf( '%-15s', val )

        con( pl, clr_y, l1_d, clr_p, cs_data, clr_w, l2_d )
    end

    con( pl, 1 )
    con( pl, 0 )

    local h2_l = sf( '\n %s » %s', script, 'Versions' )
    con( pl, clr_r, h2_l .. '\n' )

    local get_versions =
    {
        { id = ln( 'col_name_lib' ),          val = base.get:ver2str_mf( ) or 'missing' },
        { id = ln( 'col_name_spew' ),         val = base.get:ver_pkg( base.spew ) },
        { id = rnet.__manifest.name,            val = base.get:ver_pkg( rnet ) },
        { id = timex.__manifest.name,           val = base.get:ver_pkg( timex ) },
        { id = rcc.__manifest.name,             val = base.get:ver_pkg( rcc ) },
        { id = rhook.__manifest.name,           val = base.get:ver_pkg( rhook ) },
    }

    for m in helper.get.data( get_versions ) do
        if not m.val then continue end

        local id    = m.id
        local val   = m.val

        local l1_d, l2_d, cs_data = '', '', ''
        l1_d        = sf( '%-20s', id )
        cs_data     = sf( '%-5s', ' » ' )
        l2_d        = sf( '%-15s', val )

        con( pl, clr_y, l1_d, clr_p, cs_data, clr_w, l2_d )
    end

    /*
        rcore output
    */

    if not istable( rcore ) then
        con( pl, 0 )
        con( pl, clr_r, '\n ', clr_r, ln( 'status_rcore_missing' ) )
        return
    end

    con( pl, 1 )
    con( pl, 0 )

    local c0_cat = sf( '\n %s » %s', 'rcore', 'Demo Mode Active\n' )

    con( pl, clr_r, c0_cat )

    local bIsDemo = false
    for v in helper.get.data( rcore.modules ) do
        if not v.demo and not v.demomode then continue end

        local name      = helper.str:truncate( v.name, 20, '...' ) or ln( 'err' )
        local ver       = base.get:ver2str( v.version )
        local author    = v.author
        local desc      = helper.str:truncate( v.desc, 40, '...' ) or ln( 'err' )

        local d1_d      = sf( '%-20s', name )
        local d2_d      = sf( '%-15s', ver )
        local d3_d      = sf( '%-15s', author )
        local d4_d      = sf( '%-20s', desc )
        local d1_r      = sf( '%s %s %s %s', d1_d, d2_d, d3_d, d4_d )

        bIsDemo = true

        con( pl, clr_y, d1_r )
    end

    if not bIsDemo then
        con( pl, 'No modules' )
    end

    con( pl, 1 )
    con( pl, 0 )

end
rcc.register( 'rlib_debug_diag', rcc_debug_diag )

/*
    rcc > checksum > new

    writes the lib checksums to data/rlib/checksum.txt
*/

local function rcc_checksum_new( pl, cmd, args, str )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_cs_new' )

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

    local deploy = base.checksum:new( true )

    /*
        confirm msg to pl
    */

    if pl and not access:bIsConsole( pl ) then
        base.msg:direct( pl, script, not deploy and ln( 'checksum_write_err' ) or ln( 'checksum_write_success' ) )
    end

    log( RLIB_LOG_SYSTEM, not deploy and ln( 'checksum_write_err' ) or ln( 'checksum_write_success' ) )

end
rcc.register( 'rlib_cs_new', rcc_checksum_new )

/*
    rcc > checksum > verify

    verifies released lib checksums with any files that may be modified on the server
    and reports the differences
*/

local function rcc_checksum_verify( pl, cmd, args, str )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_cs_verify' )

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
        check > see if checksums table valid
    */

    local checksums = base.checksum:verify( )
    if not istable( checksums ) then
        con( pl, clr_w, ln( 'checksum_validate_fail' ) )
        return
    end

    /*
        output > header
    */

    local i = table.Count( checksums )

    con( pl, 1 )
    con( pl, clr_y, script, clr_p, ' » ', clr_w, ln( 'con_checksum_verify' ) )
    con( pl, 0 )

    /*
        output > check > files verified
    */

    if i == 0 then
        con( pl, clr_w, ln( 'files_modified_none' ) )
        con( pl, 0 )
        return
    end

    /*
        output > subheader
    */

    con( pl, clr_w, ln( 'files_listed_have_been_modified' ) )
    con( pl, 1 )
    con( pl, 0 )

    /*
        columns
    */

    local l1_l      = sf( '%-40s',    ln( 'col_file'        ) )
    local l2_l      = sf( '%-20s',    ln( 'col_verified'    ) )
    local l3_l      = sf( '%-5s',     ln( 'sym_arrow'       ) )
    local l4_l      = sf( '%-20s',    ln( 'col_current'     ) )

    con( pl, clr_w, l1_l, Color( 0, 255, 0 ), l2_l, clr_w, l3_l, clr_r, l4_l )
    con( pl )

    local i = 0
    for k, v in pairs( checksums ) do
        if not v.verified or not v.current then continue end

        local verified  = v.verified:sub( 1, 15 )
        local current   = v.current:sub( 1, 15 )

        local l1_d      = sf( '%-40s',  k           )
        local l2_d      = sf( '%-20s',  verified    )
        local l3_d      = sf( '%-5s',   '»'         )
        local l4_d      = sf( '%-20s',  current     )

        con( pl, clr_y, l1_d, Color( 0, 255, 0 ), l2_d, clr_w, l3_d, clr_r, l4_d )

        i = i + 1
    end

    if i > 0 then
        con( pl, 0 )
        con( pl, 1 )
        con( pl, clr_w, ln( 'files_modified_count', i ) )
    end

    con( pl, 1 )

end
rcc.register( 'rlib_cs_verify', rcc_checksum_verify )

/*
    rcc > checksum > obf

    release prepwork
*/

local function rcc_checksum_obf( pl, cmd, args, str )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_cs_obf' )

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
        data > read
    */

    con( pl, 1 )
    con( pl, clr_y, script, clr_p, ' » ', clr_w, ln( 'con_checksum_obf' ) )
    con( pl, 0 )

    /*
        data > define
    */

    local _r                = string.format( '%s/dec.txt', mf.paths[ 'dir_obf' ] )
    local _w                = string.format( '%s/enc.txt', mf.paths[ 'dir_obf' ] )
    local _r_data           = file.Read( _r, 'DATA' )

    /*
        data > dec not found
    */

    if not _r_data then
        con( pl, clr_r, 'No data found in ', clr_y, _r )
        con( pl, 1 )
        return
    end

    /*
        data > enc
    */

    local enc               = _r_data:gsub( '.', function( bb ) return '\\' .. bb:byte( ) end ) or _r_data .. '\''

    /*
        data > write enc
    */

    file.Write( _w, enc )

    /*
        data > response
    */

    con( pl, clr_w, 'Wrote obf data to ', clr_y, _w )
    con( pl, 1 )

end
rcc.register( 'rlib_cs_obf', rcc_checksum_obf )

/*
    rcc > sap > encode
*/

local function rcc_sap_encode( pl, cmd, args, str )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_sap_encode' )

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
        output > header
    */

    con( pl, 3 )
    con( pl, clr_y, script, clr_p, ' » ', clr_w, 'SAP » Encode' )
    con( pl, 0 )

    /*
        arg
    */

    local arg_str           = args and args[ 1 ] or false

    if not arg_str then
        log( RLIB_LOG_ERR, 'aborting SAP encode -- missing value' )
        return
    end

    /*
        encode
    */

    local sha1val           = base.checksum:encode( arg_str )

    if not sha1val then
        log( RLIB_LOG_ERR, 'aborting checksum encode -- could not encode provided argument' )
        return
    end

    /*
        resp > header
    */

    local l1_l      = sf( '%-45s',      'String' )
    local l2_l      = sf( '%-35s',      'Output' )

    con( pl, clr_r, l1_l, l2_l )
    con( pl, 1 )

    /*
        resp > data
    */

    local r1_l      = sf( '%-45s',      arg_str )
    local r2_l      = sf( '%-35s',      sha1val )

    con( pl, clr_g, r1_l, clr_w, r2_l )

    con( pl, 0 )
    con( pl, 3 )
end
rcc.register( 'rlib_sap_encode', rcc_sap_encode )

/*
    rcc > udm

    toggles the update notification for the remainder of the session and will revert to default when
    the server is rebooted.
*/

local function rcc_udm( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_udm' )

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

    local timer_id          = 'rlib_udm_notice'
    local status            = args and args[ 1 ] or false
    local dur               = args and args[ 2 ] or cfg.udm.checktime or 1800

    if not base:bInitialized( ) then
        log( 1, ln( 'lib_udm_err_noinit' ) )
        con( pl, 1 )
        return
    end

    /*
        param > run updater
    */

    if status and status == 'run' then
        local task_udm = coroutine.create( function( )
            log( RLIB_LOG_INFO, ln( 'lib_udm_run' ) )
            base.udm:Check( true )
        end )
        coroutine.resume( task_udm )
        return
    end

    if status then
        local param_status = helper.util:toggle( status )
        if param_status then
            if timex.exists( timer_id ) then
                local next_chk  = timex.remains( timer_id )
                next_chk        = timex.secs.sh_simple( next_chk, false, true )
                log( RLIB_LOG_OK, ln( 'lib_udm_nextchk', next_chk ) )
                return
            end

            if dur and not helper:bIsNum( dur ) then
                log( RLIB_LOG_ERR, ln( 'lib_udm_bad_dur' ) )
                return
            end

            log( RLIB_LOG_OK, ln( 'lib_udm_started', dur ) )

            base.udm:Run( dur )
        else
            timex.expire( timer_id )
            log( RLIB_LOG_OK, ln( 'lib_udm_stopped', dur ) )
        end
    else
        if timex.exists( timer_id ) then
            local next_chk = timex.remains( timer_id )
            next_chk = timex.secs.sh_simple( next_chk, false, true )
            log( RLIB_LOG_OK, ln( 'lib_udm_active', next_chk ) )

            return
        else
            log( RLIB_LOG_INFO, ln( 'lib_udm_inactive' ) )
        end
    end

end
rcc.register( 'rlib_udm', rcc_udm )

/*
    rcc > calls

    returns a list of all registered calls associated to rlib / rcore

    @usage : rlib.calls <returns all calls>
    @usage : rlib.calls rlib <returns rlib only>
    @usage : rlib.calls -s termhere <returns entries matching term>
    @usage : rlib.calls -r <returns raw output>
*/

local function rcc_calls( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_calls' )

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

    if not access:bIsRoot( pl ) then return end

    /*
        functionality
    */

    local arg_flag          = args and args[ 1 ] or false
    local arg_srch          = args and args[ 2 ] or nil
    local i_entries         = 0

    local output = sf( '\n\n [%s] > call definitions', script )
    if arg_flag then
        if arg_flag == script then
            output = sf( '\n\n [%s] > call definitions [ %s library only ]', script, script )
        elseif arg_flag == '-r' then
            output = sf( '\n\n [%s] > call definitions > raw', script, script )
        end
    end

    con( pl, output )

    /*
        loop calls table
    */

    local cat_islisted, cat_id = false, ''
    local tbl_calls = base._rcalls

    if arg_flag then
        if arg_flag == script then
            tbl_calls = rlib.c
        else
            if arg_flag == '-s' and arg_srch then
                con( pl, clr_r, ' ' .. ln( 'search_term', arg_srch ) )
            elseif arg_flag == '-r' then
                con( pl, clr_r, ' ' .. ln( 'search_raw' ) )
                helper.p_table( tbl_calls )
                return
            end
        end
    end

    for a, b in pairs( tbl_calls ) do

        if a ~= cat_id then
            cat_islisted = false
        end

        for k, v in pairs( b ) do

            if not cat_islisted then
                local cat       = sf( ' %s', a )

                con( pl, 1 )
                con( pl, 0 )

                local l1_l      = sf( '%-15s',      cat )
                local l2_l      = sf( '%-35s',      ln( 'col_id' ) )
                local l3_l      = sf( '%-35s',      ln( 'col_data' ) )
                local l4_l      = sf( '%s %s %s',   l1_l, l2_l, l3_l )

                con( pl, clr_w, l4_l )
                con( pl, 0 )

                cat_islisted, cat_id = true, a
            end

            if istable( v ) then
                local i = helper.countdata( v, 1 )( )

                local id, i_fields = '', 0
                for l, m in pairs( v ) do
                    if arg_srch and not string.match( k, arg_srch ) then continue end
                    i_fields = i_fields + 1

                    id = k
                    if i_fields ~= 1 then id = '' end

                    local l1_d, l2_d, l3_d, c0_resp = '', '', '', ''
                    l1_d    = sf( '%-15s', tostring( '' ) )
                    l2_d    = sf( '%-35s', tostring( id ) )
                    l3_d    = sf( '%-35s', ln( 'missing_item' , tostring( l ) ) )

                    if m ~= '' then
                        l3_d = sf( '%-35s', tostring( l ) .. ' : ' .. helper.str:truncate( tostring( m ), 60, '...' ) )
                    end

                    c0_resp = sf( '%s%s %s %s', c0_resp, l1_d, l2_d, l3_d )

                    if i_fields == i then
                        i_entries   = i_entries + 1
                        c0_resp     = c0_resp .. '\n'
                        i_fields    = 0
                    end

                    con( pl, clr_y, c0_resp )
                end
            elseif isstring( v ) then
                if not arg_srch or arg_srch and string.match( v, arg_srch ) then
                    local l1_d      = sf( '%-15s', tostring( '' ) )
                    local l2_d      = sf( '%-35s', tostring( k ) )
                    local l3_d      = sf( '%-35s', tostring( v ) )

                    local c0_resp   = sf( '%s%s %s %s', c0_resp, l1_d, l2_d, l3_d )

                    i_entries       = i_entries + 1

                    con( pl, clr_y, c0_resp )
                end
            end

        end

    end

    con( pl, 1 )
    con( pl, 0 )

    local c_ftr     = sf( ln( 'calls_found_cnt', i_entries ) )
    con( pl,        Color( 0, 255, 0 ), c_ftr )

    con( pl, 0 )

end
rcc.register( 'rlib_calls', rcc_calls )

/*
    rcc > modules > error logs

    displays any registered errors with the specified module
*/

local function rcc_modules_errlog( pl, cmd, args )

    /*
        define command
    */

    local ccmd = rlib.calls:get( 'commands', 'rlib_modules_errlog' )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not rlib.con:Is( pl ) ) then
        access:deny_consoleonly( pl, base.manifest.name, ccmd.id )
        return
    end

    /*
        perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, base.manifest.name, ccmd.id )
        return
    end

    /*
        functionality
    */

    con             ( pl, 1 )
    con             ( pl, clr_y, rlib.manifest.name, clr_p, ' » ', clr_w, 'Errorlogs' )
    con             ( pl, 0 )

    /*
        outdated libraries
    */

    con             ( pl, clr_y, '» ', clr_w, 'Outdated\n' )
    con             ( pl, clr_w, 'The following modules require a more recent version of rlib to function properly' )
    con             ( pl, 0 )
    con             ( pl, 1 )

    local l1_l      = sf( '%-20s', 'Module'         )
    local l2_l      = sf( '%-20s', 'Module Version' )
    local l3_l      = sf( '%-20s', 'Lib Version'    )
    local l4_l      = sf( '%-20s', 'Lib Required'   )

    con             ( pl, clr_y, l1_l, clr_w, l2_l, clr_r, l3_l, clr_w, l4_l )
    con             ( pl, 0 )

    for v in helper.get.data( rcore.modules, true ) do
        if not v.errorlog then continue end

        if v.errorlog.bLibOutdated then
            local l1_d  = sf( '%-20s', v.name )
            local l2_d  = sf( '%-20s', rlib.get:ver2str_mf( v ) )
            local l3_d  = sf( '%-20s', rlib.get:ver2str_mf( ) )
            local l4_d  = sf( '%-20s', rlib.get:ver2str( v.libreq ) )

            con( pl, clr_y, l1_d, clr_w, l2_d, clr_r, l3_d, clr_w, l4_d )
        end
    end

end
rcc.register( 'rlib_modules_errlog', rcc_modules_errlog )

/*
    rcc > modules > reroute

    lists all installed modules
*/

local function rcc_modules( pl, cmd, args )

    /*
        define command
    */

    local ccmd = rlib.calls:get( 'commands', 'rlib_modules' )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not rlib.con:Is( pl ) ) then
        access:deny_consoleonly( pl, base.manifest.name, ccmd.id )
        return
    end

    /*
        perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, base.manifest.name, ccmd.id )
        return
    end

    /*
        declarations
    */

    local arg_flag  = args and args[ 1 ] or false
    local gcf_path  = rlib.calls:gcflag( 'rlib_modules', 'paths' )

    /*
        functionality
    */

    con             ( pl, '\n\n [' .. base.manifest.name .. '] Active Modules' )
    con             ( pl, 0 )

    local c1_l      = sf( '%-20s', 'Module'      )
    local c2_l      = sf( '%-17s', 'Version'     )
    local c3_l      = sf( '%-15s', 'Author'      )
    local c4_l      = sf( '%-20s', ( arg_flag == gcf_path and 'Path' ) or 'Description' )

    con             ( pl, sf( ' %s %s %s %s', c1_l, c2_l, c3_l, c4_l ) )
    con             ( pl, 0 )

    for v in helper.get.data( rcore.modules, true ) do
        local l1_d  = sf( '%-20s', tostring( helper.str:truncate( v.name, 20, '...' ) or 'err' ) )
        local l2_d  = sf( '%-17s', tostring( rlib.modules:ver2str( v ) or 'err' ) )
        local l3_d  = sf( '%-15s', tostring( v.author or 'err' ) )
        local l4_d  = sf( '%-20s', tostring( helper.str:truncate( ( arg_flag == gcf_path and v.path ) or v.desc, 40, '...' ) or 'err' ) )
        local resp  = sf( ' %s %s %s %s', l1_d, l2_d, l3_d, l4_d )

        con( pl, clr_y, resp )
    end

    con( pl, 0 )

end
rcc.register( 'rlib_modules', rcc_modules )

/*
    rcc > modules > reload

    reloads all modules
*/

local function rcc_modules_reload( pl, cmd, args )

    /*
        define command
    */

    local ccmd = rlib.calls:get( 'commands', 'rlib_modules_reload' )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not rlib.con:Is( pl ) ) then
        access:deny_consoleonly( pl, base.manifest.name, ccmd.id )
        return
    end

    /*
        perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, base.manifest.name, ccmd.id )
        return
    end

    /*
        functionality
    */

    rcore:modules_initialize( )

end
rcc.register( 'rlib_modules_reload', rcc_modules_reload )

/*
    rcc > tools > asay

    sends a message to all players in chat who have the permission 'rlib_asay'
    similar to ulx asay
*/

local function rcc_tools_asay( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_asay' )

    /*
        check > permissions
    */

    if ( ccmd.no_console and access:bIsConsole( pl ) ) then
        access:deny_console( pl, script, ccmd.id )
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

    local asay_message = table.concat( args, ' ' )

    /*
        check if asay str empty; return error
    */

    if not helper.str:ok( asay_message ) then
        route( pl, false, 'asay', 'cannot send empty message' )
        return
    end

    /*
        run asay hook
    */

    hook.Run( 'asay.broadcast', pl, asay_message )

end
rcc.register( 'rlib_asay', rcc_tools_asay )

/*
    rcc > tools > pco

    player client optimizations, which sets specific command variables for the calling player which
    helps increase frames ( if enabled )
*/

local function rcc_tools_pco( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_tools_pco' )

    /*
        check > permissions
    */

    if ( ccmd.no_console and access:bIsConsole( pl ) ) then
        access:deny_console( pl, script, ccmd.id )
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

    local arg_toggle    = args and args[ 1 ]
    local arg_state     = helper.util:toggle( arg_toggle )

    -- no arg specified, simply return pco status
    if not arg_toggle then
        local state = pl:GetNWBool( pf .. 'tools.pco' ) and ln( 'opt_enabled' ) or ln( 'opt_disabled' )
        route( pl, false, script, 'pco is currently', cfg.cmsg.clrs.target, state )
        return
    end

    tools.pco:Run( pl, arg_state )

end
rcc.register( 'rlib_tools_pco', rcc_tools_pco )

/*
    rcc > tools > rdo

    set the rendermode on entities

    @usage  : rlib.rdo <returns state>
    @usage  : rlib.rdo enable|disable <set rdo active state>
*/

local function rcc_tools_rdo( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_tools_rdo' )

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

    if not access:bIsRoot( pl ) then return end

    /*
        functionality
    */

    local arg_toggle    = args and args[ 1 ]
    local arg_state     = helper.util:toggle( arg_toggle )

    if not arg_toggle then
        local state = cfg.rdo.enabled and ln( 'opt_enabled' ) or ln( 'opt_disabled' )
        route( pl, false, script, 'rdo »', cfg.cmsg.clrs.target, state )
        return
    end

    cfg.rdo.enabled = arg_state
    rdo_rendermode( arg_state )

    local set_state = arg_state and ln( 'opt_enabled' ) or ln( 'opt_disabled' )
    route( pl, false, script, 'rdo »', cfg.cmsg.clrs.target, set_state )

end
rcc.register( 'rlib_tools_rdo', rcc_tools_rdo )

/*
    rcc > session

    returns the current session id
*/

local function rcc_session( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_session' )

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
        check > command disabled
    */

    if not ccmd.enabled then
        log( 3, ln( 'setup_cmd_disabled' ) )
        return
    end

    /*
        return session id
    */

    route( pl, false, script, ln( 'lib_session_id', sys.startups ) )

end
rcc.register( 'rlib_session', rcc_session )

/*
    rcc > setup

    sets up rlib after the initial install
*/

local function rcc_setup( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_setup' )

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
        check > command disabled
    */

    if not ccmd.enabled then
        log( 3, ln( 'setup_cmd_disabled' ) )
        return
    end

    /*
        check > already has root usr
    */

    local bHasRoot, rootuser = access:root( )
    if bHasRoot then
        route( pl, false, script, ln( 'setup_root_exists' ), clr_y, ( rootuser and rootuser.name ) or 'none' )
        return
    end

    /*
        check > server initialized
    */

    if not base:bInitialized( ) then
        route( pl, false, script, ln( 'lib_initialized' ) )
        return
    end

    /*
        functionality
    */

    local target = args and args[ 1 ] or false

    if not target then
        route( pl, false, script, ln( 'user_find_errmsg' ) )
        return
    end

    local c_results, result = helper.who:name_wc( target )

    if c_results > 1 then
        route( pl, false, script, ln( 'user_find_multires' ), cfg.cmsg.clrs.target, ln( 'user_find_quotes_ex' ) )
        return
    elseif not c_results or c_results < 1 then
        if sys.connections == 1 then
            route( pl, false, script, ln( 'user_find_nores_one' ) )
        else
            route( pl, false, script, ln( 'user_find_nores' ), cfg.cmsg.clrs.target, ln( 'user_find_quotes_ex' ) )
        end
        return
    else
        if not helper.ok.ply( result[ 0 ] ) then
            if sys.connections == 1 then
                route( pl, false, script, ln( 'user_find_noply_one' ) )
            else
                route( pl, false, script, ln( 'user_find_noply' ) )
            end
            return
        else
            result          = result[ 0 ]
            local bExists   = access:writeuser( result )

            if bExists then return end

            con( pl, 2 )
            con( pl, 0 )
            con( pl, clr_y, '» Library Setup' )
            con( pl, 0 )
            con( pl, 1 )
            con( pl, clr_w, 'User ', clr_p, result:Name( ), color_white, ' has been added with ', Color( 0, 255, 0 ), 'root access', color_white, ' and is protected.' )
            con( pl, clr_w, 'With root, you have access to all admin-based privledges and abilities that rlib utilizes.\n' )
            con( pl, clr_w, 'For more info; type ', Color( 0, 255, 0 ), 'rlib.manifest', color_white, ' in con and visit the docs URL\n' )
            con( pl, 0 )
            con( pl, 1 )
            con( pl, clr_w, 'Review the list of useful commands below to get started\n\n' )

            /*
                loop > setup > useful commands
            */

            for v in helper.get.data( rlib.calls:get( 'commands' ), true ) do
                if not v.enabled or not v.showsetup then continue end

                con( pl, clr_y, '   ' .. v.id )
            end

            con( pl, 1 )
            con( pl, 0 )

            -- update admins list for perms
            net.Start       ( 'rlib.user' )
            net.WriteTable  ( access.admins )
            net.Broadcast   ( )

            base:SetupKillTask( )
        end
    end

end
rcc.register( 'rlib_setup', rcc_setup )

/*
    rcc > status

    returns various types of information related to installed packages, library stats, debugging,
    installed modules and base core module
*/

local function rcc_status( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_status' )

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
        header output
    */

    con( pl, 1 )

    local cat       = script or ln( 'lib_name' )
    local subcat    = ccmd.title or ccmd.name or ln( 'untitled' )

    con( pl, sf( '%s » %s', cat, subcat ) )

    /*
        manifest output
    */

    con( pl, 1 )
    con( pl, 0 )

    local l0_l      = sf( '%s » %s', script, ln( 'manifest' ) )
    local l1_l      = sf( '%-20s', l0_l )
    local l2_l      = sf( '%-15s', '' )

    con( pl, clr_r, l1_l, l2_l )
    con( pl )

    local about_d   = helper.str:wordwrap( mf.about, 64 )

    for l, m in SortedPairs( mf ) do
        if istable( m ) then continue end

        local id    = tostring( l ) or nil
        local val   = tostring( m ) or ln( 'missing' )

        local l1_d, l2_d, s1_l = '', '', ''
        if id == 'about' then
            l1_d        = sf( '%-20s', tostring( id ) )
            s1_l        = sf( '%-5s', '»' )
            l2_d        = sf( '%-15s', about_d[ 1 ] )

            con( pl, clr_y, l1_d, clr_p, s1_l, clr_w, l2_d )

            for k, v in pairs( about_d ) do
                if k == 1 then continue end -- hide the first line, already called in the initial col
                val             = tostring( v ) or ln( 'missing' )

                local l3_d      = sf( '%-20s', '' )
                local l4_d      = sf( '%-15s', val )

                con( pl, clr_y, l3_d, clr_w, '    ', clr_w, l4_d )
            end
        else
            val         = ( id == 'released' and os.date( '%m.%d.%Y', val ) ) or val

            l1_d        = sf( '%-20s', id )
            s1_l        = sf( '%-5s', '»' )
            l2_d        = sf( '%-15s', val )

            con( pl, clr_y, l1_d, clr_p, s1_l, clr_w, l2_d )
        end
    end

    /*
        appends version to the manifest output
    */

    local v1_d          = sf( '%-20s', ln( 'label_version' ) )
    local v2_d          = sf( '%-5s', '»' )
    local v3_d          = sf( '%-15s', base.get:ver2str_mf( ) )

    con( pl, clr_y, v1_d, clr_p, v2_d, clr_w, v3_d )

    con( pl, 2 )
    con( pl, 0 )

    /*
        stats output
    */

    local s0_c          = sf( '%s » %s', script, ln( 'stats' ) )
    local s1_l          = sf( '%-20s', s0_c )
    local s2_l          = sf( '%-15s', '' )

    con( pl, clr_r, s1_l, clr_p, s2_l )
    con( pl )

    local tbl_stats =
    {
        { id = ln( 'status_col_os' ),             val = base.get:os( ) },
        { id = ln( 'status_col_gm' ),             val = base.get:gm( true ) },
        { id = ln( 'status_col_admins' ),         val = table.Count( access.admins ) or 0 },
        { id = ln( 'status_col_rnet_id' ),        val = GetGlobalString( 'rlib_sess') or 0 },
        { id = ln( 'status_col_calls' ),          val = ln( 'stats_reg_cnt', sys.calls or 0 ) },
        { id = ln( 'status_col_basecmd' ),        val = sys.calls_basecmd or ln( 'none' ) },
        { id = ln( 'status_col_init' ),           val = sys.initialized and ln( 'opt_yes' ) or ln( 'opt_no' ) },
        { id = ln( 'status_col_conncnt' ),        val = sys.connections or 0 },
        { id = ln( 'status_col_debug_mode' ),     val = base:g_Debug( ) and ln( 'opt_enabled' ) or ln( 'opt_disabled' ) },
        { id = ln( 'status_col_rnet_route' ),     val = rnet and rnet.sys.nrouter_enabled and ln( 'opt_enabled' ) or ln( 'opt_disabled' ) },
        { id = ln( 'status_col_rcore' ),          val = istable( rcore ) and ln( 'opt_yes' ) or ln( 'opt_no' ) },
        { id = ln( 'status_col_starttime' ),      val = sys.starttime or 0 },
        { id = ln( 'status_col_startcnt' ),       val = sys.startups or 0 },
        { id = ln( 'status_col_uptime' ),         val = timex.secs.sh_cols( SysTime( ) - sys.uptime ) },
    }

    for m in helper.get.data( tbl_stats ) do
        if not m.val then continue end

        local id, val       = tostring( m.id ), tostring( m.val )

        local s1_d          = sf( '%-20s', id )
        local s2_d          = sf( '%-5s', '»' )
        local s3_d          = sf( '%-15s', val )

        con( pl, clr_y, s1_d, clr_p, s2_d, clr_w, s3_d )
    end

    con( pl, 2 )
    con( pl, 0 )

    /*
        stats output
    */

    local o0_c          = sf( '%s » %s', script, ln( 'oort' ) )
    local o1_l          = sf( '%-20s', o0_c )
    local o2_l          = sf( '%-15s', '' )

    con( pl, clr_r, o1_l, clr_p, o2_l )
    con( pl )

    local bHasRoot,
    rootuser            = access:root( )
    local owner_id      = bHasRoot and istable( rootuser ) and rootuser.name or 'none'
    local hb            = ( math.Round( CurTime( ) - mf.astra.oort.last_hb ) ) or 0
    hb                  = sf( '%i seconds ago', hb )

    local tbl_oort =
    {
        { id = ln( 'status_col_owner' ),          val = bHasRoot and owner_id or 'unregistered' },
        { id = ln( 'status_col_validated' ),      val = base.oort:Validated( ) and ln( 'opt_yes' ) or ln( 'opt_no' ) },
        { id = ln( 'status_col_latest_ver' ),     val = mf.astra.oort.has_latest and ln( 'opt_yes' ) or ln( 'opt_no' ) },
        { id = ln( 'status_col_heartbeat' ),      val = hb or 0 },
        { id = ln( 'status_col_sess_id' ),        val = mf.astra.oort.sess_id or 'null' },
        { id = ln( 'status_col_auth_id' ),        val = mf.astra.oort.auth_id or 'null' },
        { id = ln( 'status_col_branch' ),         val = cvar:GetStr( 'rlib_branch', 'stable' ) },
    }

    for m in helper.get.data( tbl_oort ) do
        if not m.val then continue end

        local id, val       = tostring( m.id ), tostring( m.val )

        local s1_d          = sf( '%-20s', id )
        local s2_d          = sf( '%-5s', '»' )
        local s3_d          = sf( '%-15s', val )

        con( pl, clr_y, s1_d, clr_p, s2_d, clr_w, s3_d )
    end

    con( pl, 2 )
    con( pl, 0 )

    /*
        paths
    */

    local t1_c          = sf( '%s » %s', script, ln( 'storage' ) )
    local t1_l          = sf( '%-20s', t1_c )
    local t2_l          = sf( '%-15s', '' )

    con( pl, clr_r, t1_l, clr_r, t2_l )
    con( pl )

    for l, m in SortedPairs( mf.paths ) do
        local id        = tostring( l )
        local val       = tostring( m )

        local s1_data, s2_data, ss_data = '', '', ''
        s1_data         = sf( '%-20s', id )
        ss_data         = sf( '%-5s', '»' )
        s2_data         = sf( '%-15s', val )

        con( pl, clr_y, s1_data, clr_p, ss_data, clr_w, s2_data )
    end

    con( pl, 1 )

    local tbl_storage =
    {
        { id = ln( 'status_col_logs' ),           val = ( sys.log_ct or 0 ) .. ' ( ' .. ( sys.log_sz or 0 ) .. ' )' or 0 },
        { id = ln( 'status_col_uconn' ),          val = ( sys.uconn_ct or 0 ) .. ' ( ' .. ( sys.uconn_sz or 0 ) .. ' )' or 0 },
        { id = ln( 'status_col_history' ),        val = ( sys.history_ct or 0 ) .. ' ( ' .. ( sys.history_sz or 0 ) .. ' )' or 0 },
    }

    for m in helper.get.data( tbl_storage ) do
        if not m.val then continue end

        local id, val       = tostring( m.id ), tostring( m.val )

        local s1_d          = sf( '%-20s', id )
        local s2_d          = sf( '%-5s', '»' )
        local s3_d          = sf( '%-15s', val )

        con( pl, clr_y, s1_d, clr_p, s2_d, clr_w, s3_d )
    end

    con( pl, 2 )
    con( pl, 0 )

    /*
        packages output
    */

    local p1_c          = sf( '%s » %s', script, ln( 'packages' ) )
    local p1_l          = sf( '%-20s', p1_c )
    local p2_l          = sf( '%-25s', '' )
    local p3_l          = sf( '%-25s', '' )

    con( pl, clr_r, p1_l, p2_l, p3_l )
    con( pl, 0 )

    for i, m in SortedPairs( base.package.index ) do
        local id        = tostring( i )
        local ver       = sf( '%s : %s', base.get:ver2str( m.version ), m.build )
        local desc      = tostring( helper.str:truncate( m.desc, 50, '...' ) or ln( 'none' ) )

        local p1_d      = sf( '%-20s', id )
        local p2_d      = sf( '%-5s', '»' )
        local p3_d      = sf( '%-25s', ver )
        local p4_d      = sf( '%-25s', desc )

        con( pl, clr_y, p1_d, clr_p, p2_d, clr_w, p3_d, clr_w, p4_d )
    end

    con( pl, 2 )
    con( pl, 0 )

    /*
        rcore output
    */

    if not istable( rcore ) then
        con( pl, clr_r, ' ', clr_r, ln( 'status_rcore_missing' ) )
        return
    end

    local rc0_cat   = sf( 'rcore » %s', script, ln( 'modules' ) )
    local rc1_l     = sf( '%-20s', rc0_cat )
    local rc2_l     = sf( '%-15s', '' )

    con( pl, clr_r, rc1_l, rc2_l )
    con( pl )

    local tbl_modules =
    {
        { id = ln( 'stats_total' ),         val = rcore.sys.modules.total or 0 },
        { id = ln( 'stats_registered' ),    val = rcore.sys.modules.registered or 0 },
        { id = ln( 'stats_errors' ),        val = rcore.sys.modules.err or 0 },
        { id = ln( 'stats_disabled' ),      val = rcore.sys.modules.disabled or 0 },
    }

    for m in helper.get.data( tbl_modules ) do
        if not m.val then continue end

        local id    = tostring( m.id )
        local val   = tostring( m.val )

        r1_d        = sf( '%-20s', id )
        r2_d        = sf( '%-5s', '»' )
        r3_d        = sf( '%-15s', val )

        con( pl, clr_y, r1_d, clr_p, r2_d, clr_w, r3_d )
    end

    /*
        rcore > module list
    */

    con( pl, 2 )
    con( pl, 0 )

    local m1_l       = sf( '%-20s', ln( 'col_module' )    )
    local m2_l       = sf( '%-20s', ln( 'col_version' )   )
    local m3_l       = sf( '%-15s', ln( 'col_author' )    )
    local m4_l       = sf( '%-20s', ln( 'col_desc' )      )

    con( pl, clr_w, m1_l, m2_l, m3_l, m4_l )

    con( pl, 0 )

    local clr_status    = clr_y
    for v in helper.get.data( rcore.modules ) do
        clr_status      = not v.enabled and clr_r or clr_status

        local name      = tostring( helper.str:truncate( v.name, 20, '...' ) or ln( 'err' ) )
        local ver       = tostring( rlib.modules:ver2str( v ) )
        local author    = tostring( v.author )
        local desc      = tostring( helper.str:truncate( v.desc, 40, '...' ) or ln( 'err' ) )

        local m1_d      = sf( '%-20s', name )
        local m2_d      = sf( '%-20s', ver )
        local m3_d      = sf( '%-15s', author )
        local m4_d      = sf( '%-20s', desc )

        con( pl, clr_status, m1_d, m2_d, m3_d, m4_d )
    end

end
rcc.register( 'rlib_status', rcc_status )

/*
    rcc > list packages

    returns a list of installed / running packages
*/

local function rcc_packages( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_packages' )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not rlib.con:Is( pl ) ) then
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

    con( pl, 2 )

    local cat       = script or ln( 'lib_name' )
    local subcat    = ccmd.title or ccmd.name or ln( 'untitled' )

    con( pl, 1 )

    local c0_lbl    = sf( '%s » %s', cat, subcat )

    con( pl, clr_r, c0_lbl )

    local l1_l      = sf( '%-15s', ln( 'col_package' )   )
    local l2_l      = sf( '%-15s', ln( 'col_version' )   )
    local l3_l      = sf( '%-15s', ln( 'col_author' )    )
    local l4_l      = sf( '%-20s', ln( 'col_desc' )      )

    con( pl, 0 )

    con( pl, l1_l, l2_l, l3_l, l4_l )

    con( pl, 0 )

    for v in helper.get.data( base.package.index ) do
        local l1_d        = sf( '%-15s', tostring( helper.str:truncate( v.name, 20, '...' ) or ln( 'err' ) ) )
        local l2_d        = sf( '%-15s', base.get:ver2str( v.version ) or ln( 'err' ) )
        local l3_d        = sf( '%-15s', tostring( v.author ) or ln( 'err' ) )
        local l4_d        = sf( '%-20s', tostring( helper.str:truncate( v.desc, 40, '...' ) or ln( 'err' ) ) )

        con( pl, clr_y, l1_d, l2_d, l3_d, l4_d )
    end

    con( pl, 0 )

end
rcc.register( 'rlib_packages', rcc_packages )

/*
    rcc > license

    returns license information associated with the library
*/

local function rcc_license( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_license' )

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

    con( pl, 1 )

    local cat       = script or ln( 'lib_name' )
    local subcat    = ccmd.title or ccmd.name or ln( 'untitled' )

    local l1_l      = sf( '%s » %s', cat, subcat )
    local l2_l      = sf( '%-15s', '' )

    con( pl, clr_r, l1_l, l2_l )
    con( pl, 0 )

    local about_d   = helper.str:wordwrap( mf.license.text, 72 )

    for l, m in SortedPairs( mf.license ) do
        if istable( m ) then continue end

        local id    = tostring( l ) or nil
        local val   = tostring( m ) or ln( 'missing' )

        local l1_d, l2_d, s1_l = '', '', ''
        if id == 'text' then
            l1_d    = sf( '%-10s', tostring( id ) )
            s1_l    = sf( '%-5s', ' » ' )
            l2_d    = sf( '%-15s', about_d[ 1 ] )

            con( pl, clr_y, l1_d, clr_p, s1_l, clr_w, l2_d )

            for k, v in pairs( about_d ) do
                if k == 1 then continue end -- hide first line
                val = tostring( v ) or ln( 'missing' )

                local l3_d  = sf( '%-10s', '' )
                local l4_d  = sf( '%-15s', val )

                con( pl, clr_y, l3_d, clr_w, '    ', clr_w, l4_d )
            end
            con( pl, '' )
        else
            l1_d    = sf( '%-10s', id )
            s1_l    = sf( '%-5s', '»' )
            l2_d    = sf( '%-15s', val )

            con( pl, clr_y, l1_d, clr_p, s1_l, clr_w, l2_d )
        end

    end

    con( pl, 0 )

end
rcc.register( 'rlib_license', rcc_license )

/*
    rcc > map > ents

    returns list of map ents
*/

local function rcc_map_ents( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_map_ents' )

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

    local path          = storage.mft:getpath( 'dir_sys' )
    local file_id       = 'map_ents.txt'

    storage.file.del    ( path .. '/' .. file_id )
    storage.dir.create  ( path )

    con( pl, 1 )
    con( pl, 0 )
    con( 'c',       Color( 255, 255, 0 ), 'Please wait while a map ent list is generated ...' )

    local i = 0
    for k in helper.get.ents( ) do
        if not k:GetModel( ) or not helper.str:ok( k:GetModel( ) ) then continue end

        storage.file.append( path, file_id, k:GetModel( ) )

        i = i + 1
    end

    con( pl, 1 )
    con( 'c',       Color( 255, 255, 0 ), 'Write complete!' )
    con( pl, 1 )
    con( 'c',       Color( 255, 255, 0 ), 'Added ' .. i .. ' entities to ' .. path .. '/' .. file_id )
    con( pl, 0 )

end
rcc.register( 'rlib_map_ents', rcc_map_ents )

/*
    rcc > check oort

    checks the status of oort
*/

local function rcc_oort( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_oort' )

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
        args / flags
    */

    local arg_flag          = args and args[ 1 ] or false
    local arg_act           = args and args[ 2 ] or false
    local arg_arg           = args and args[ 3 ] or false
    local gcf_set           = base.calls:gcflag( 'rlib_oort', 'set' )

    /*
        flag > set
    */

    if arg_flag and arg_flag == gcf_set then

        /*
            rlib.oort -s debug
        */

        if arg_act == 'debug' then
            mf.astra.oort.debug = helper:val2bool( arg_arg )
            route( pl, false, script, 'Oort Engine debug is now', helper.util:humanbool( arg_arg, true ) )
            return
        else
            con( pl, 1 )
            con( pl, clr_y, 'Oort Engine » ', clr_r, 'Flag action not set!' )
            con( pl, clr_w, '       Example: ', clr_y, 'rlib.oort ' .. gcf_set .. ' debug off' )
            con( pl, 1 )
            return
        end
    else
        con( pl, 1 )
        con( pl, clr_y, 'Oort Engine » ', clr_r, 'Unknown flag' )
        con( pl, clr_w, '       Type: ', clr_y, 'rlib oort', clr_w, ' for information.' )
        con( pl, 1 )
    end

    /*
        functionality
    */

    local has_oort = cfg.oort.enabled and ln( 'opt_enabled' ) or ln( 'opt_disabled' )
    route( pl, false, script, 'Oort Engine', cfg.cmsg.clrs.target, '[' .. has_oort .. ']' )
end
rcc.register( 'rlib_oort', rcc_oort )

/*
    rcc > oort > update

    forces oort to update server stats to database
*/

local function rcc_oort_update( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_oort_update' )

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
        functionality
    */

    rlib.oort:Authorize( true )
end
rcc.register( 'rlib_oort_update', rcc_oort_update )

/*
    rcc > oort > next update

    returns the update timer duration for oort stats
*/

local function rcc_oort_next( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_oort_next' )

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
        functionality
    */

    local remains   = timex.remains( 'rlib.oort.stats' )
    local resp      = sf( '%s > oort > next update', script )

    con( pl, 1  )
    con( pl, 0  )
    con( pl, clr_y, resp )
    con( pl, 0  )
    con( pl, 1  )
    con( pl, 'Next stats update in ', clr_y, remains, clr_w, ' seconds' )
    con( pl, 1  )
    con( pl, 0  )
    con( pl, 1  )

end
rcc.register( 'rlib_oort_next', rcc_oort_next )

/*
    rcc > oort > sendlog

    returns the update timer duration for oort stats
*/

local function rcc_oort_sendlog( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_oort_sendlog' )

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
        prepare log
    */

    base.oort:PrepareLog( false )

end
rcc.register( 'rlib_oort_sendlog', rcc_oort_sendlog )

/*
    restart > action > cancel

    allows for a player/console to cancel a server restart
    using either the restart concommand or timed.
*/

local function rs_cancel( pl )
    local bIsActive = false
    local timers =
    {
        'rlib_rs',
        'rlib_rs_signal_cl',
        'rlib_rs_signal',
        'rlib_rs_delay_s2',
        'rlib_rs_delay_s3',
    }

    for v in helper.get.data( timers ) do
        if not timex.exists( v ) then continue end
        timex.expire( v )
        bIsActive = true
    end

    rhook.drop.gmod( 'Tick', 'rlib_rs' )

    rnet.send.all( 'rlib_rs_broadcast', { active = false, remains = 0 } )

    if not bIsActive then
        log( 1, ln( 'restart_none_active' ) )
        return false
    end

    local admin_name = access:bIsConsole( pl ) and ln( 'console' ) or pl:Name( )

    route( nil, true, script, 'Server restart', cfg.cmsg.clrs.target_tri, 'CANCELLED' )
    --storage:log( 7, false, '[ %s ] » cancelled an active server restart', admin_name )
    log( RLIB_LOG_OK, 'server restart cancelled by player [ %s ]', admin_name )

    return false
end

/*
    action > restart
*/

local function restart_action( )
    base:log( RLIB_LOG_OK, ln( 'restart_now' ) )
    rhook.drop.gmod( 'Tick', 'rlib_rs' )

    base:push( 'A server restart has been activated' )

    local cmd = string.format( '_restart%s', '\n' )
    game.ConsoleCommand( cmd )
end

/*
    rcc > restart

    gives a counter in public chat which forces a server restart after timer expires
    yes we know the method of used to restart is 'hacky', but most servers utilize some type of hosting
    that auto-detects a downed server and restarts it. this method basically crashes the server and then
    the hosting servers take over.
*/

local function rcc_restart( pl, cmd, args )

    /*
        get command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_restart' )

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
        params
    */

    local arg_a             = args and args[ 1 ] or 60
    local arg_flag          = arg_a or false
    arg_flag                = helper.str:ok( arg_flag ) and arg_flag:lower( ) or false

    /*
        params
    */

    local gcf_cancel        = base.calls:gcflag( ccmd.call, 'cancel' )
    local gcf_instant       = base.calls:gcflag( ccmd.call, 'instant' )

    /*
        params > cancel

        @ex     : rlib.restart -c
    */

    if base.calls:gcflagMatch( gcf_cancel, arg_flag ) then
        rs_cancel( pl )
        return false
    end

    /*
        params > instant

        @ex     : rlib.restart -i
    */

    if base.calls:gcflagMatch( gcf_instant, arg_flag ) then
        restart_action( )
        return false
    end

    /*
        unknown argument
    */

    if not helper:bIsNum( arg_a ) then

        con( pl, 3  )
        con( pl, 0  )
        con( pl, clr_y, sf( '%s » %s', script, ccmd.name ) )
        con( pl, 1  )
        con( pl, 'Unknown flag   ', clr_y, arg_a )
        con( pl, 1  )
        con( pl, clr_y, 'Help » ', clr_w, 'Type ', clr_r, sf( ' %s ', ccmd.id:gsub( '[%p]', ' ' ) ), clr_w, ' for information about this command'  )
        con( pl, 0  )
        con( pl, 3  )

        return
    end

    /*
        argument should be duration at this point; convert to number
    */

    arg_a = tonumber( arg_a )

    /*
        declare > times
    */

    local i_step2           = arg_a / 2      -- half of original arg time
    local i_last10          = 10                -- when to start the second-by-second last countdown
    local i_max             = 300               -- max allowed time
    local bStep2, bStep3    = false, false

    /*
        if delay greater than max allowed
    */

    if tonumber( arg_a ) > i_max then
        base:log( RLIB_LOG_ERR, 'Restart time cannot exceed %s', i_max )
        return
    end

    /*
        disallow starting a timed restart if one already active
    */

    if timex.exists( 'rlib_rs_signal' ) then
        base:log( RLIB_LOG_ERR, ln( 'rs_exists' ) )
        return
    end

    /*
        overall timer action to execute when timer runs out
        holds the final code to run when the restart takes place
    */

    timex.create( 'rlib_rs_signal', arg_a, 1, function( )
        restart_action( )
    end )

    /*
        tracking the remaining time client-side makes things too unreliable, especially on a laggy server.
        create timer with # of reps equal to restart time and broadcast to players
    */

    timex.create( 'rlib_rs_signal_cl', 1, arg_a, function( )
        local remains = timex.reps( 'rlib_rs_signal_cl' )
        rnet.send.all( 'rlib_rs_broadcast', { active = true, remains = remains }, true )
    end )

    /*
        restart > countdown from 10

        executes when the final 10 seconds are remaining in the countdown
    */

    local function rs_count10( )
        local i_remains = i_last10
        if timex.exists( 'rlib_rs' ) then return end

        timex.create( 'rlib_rs', 1, i_last10, function( )
            if i_remains ~= ( i_last10 + 1 ) then
                term = helper.str:plural( ln( 'time_sec_ln' ), i_remains )

                if ULib then ULib.csay( _, ln( 'rs_msg_ulx', i_remains, term ) ) end

                route( nil, true, 'RESTART', 'Server restart in', cfg.cmsg.clrs.target_tri, tostring( i_remains ), cfg.cmsg.clrs.msg, term )
                base:log( RLIB_LOG_OK, ln( 'rs_msg', i_remains, term ) )
            end
            i_remains = i_remains - 1
        end )
    end

    /*
        tick :: track restart progress
    */

    rhook.new.gmod( 'Tick', 'rlib_rs', function( )
        local rs_remains    = timex.remains( 'rlib_rs_signal' )
        rs_remains          = math.Round( rs_remains )

        /*
            restart > step 2

            shows a notification in chat when the restart hits the half-way mark
        */

        if ( rs_remains == i_step2 and not bStep2 ) and not timex.exists( 'rlib_rs_delay_s2' ) then
            timex.create( 'rlib_rs_delay_s2', 0.01, 1, function( )
                term = helper.str:plural( ln( 'time_sec_ln' ), i_remains )

                route( nil, true, 'RESTART', 'Server restart in', cfg.cmsg.clrs.target_tri, tostring( i_step2 ), cfg.cmsg.clrs.msg, 'seconds' )
                base:log( RLIB_LOG_OK, ln( 'rs_msg', i_step2, term ) )

                bStep2 = true
            end )
        end

        /*
            restart > step 3

            starts a 10 second countdown
        */

        if ( rs_remains == i_last10 and not bStep3 ) and not timex.exists( 'rlib_rs_delay_s3' ) then
            timex.create( 'rlib_rs_delay_s3', 0.01, 1, function( )
                rhook.drop.gmod( 'Tick', 'rlib_rs' )
                rs_count10( )

                bStep3 = true
            end )
        end
    end )

end
rcc.register( 'rlib_restart', rcc_restart )

/*
    rcc > rpm

    rlib package manager
*/

local function rcc_rpm( pl, cmd, args )

    /*
        define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_rpm' )

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

    local arg_flag          = args and args[ 1 ] or false
    arg_flag                = helper.str:ok( arg_flag ) and arg_flag:lower( ) or false

    local gcf_list          = base.calls:gcflag( 'rlib_rpm', 'list' )
    local gcf_inst          = base.calls:gcflag( 'rlib_rpm', 'install' )
    local resp              = sf( '%s > package manager', script )

    con( pl, 1  )
    con( pl, 0  )
    con( pl, clr_y, resp )
    con( pl, 1  )
    con( pl, 'Allows you to mount packages that are available for rlib.' )
    con( pl, 0  )
    con( pl, 1  )

    /*
        arg_flag : -l
    */

    if arg_flag and ( arg_flag == gcf_list ) then

        /*
            retrieval will start here

            @todo    : add promise
        */

        base.get:Rpm( )

        return
    end

    /*
        arg_flag : -i
    */

    if arg_flag and ( arg_flag == gcf_inst ) then
        local arg_pkg   = args and args[ 2 ] or false
        if not helper.str:ok( arg_pkg ) then
            con( pl, 'Requires package name to install' )

            con( pl, 1  )
            con( pl, 0  )
            con( pl, clr_y, 'Install package with ', clr_r, 'rlib.rpm -i <package>' )
            con( pl, 2  )
            return
        end
        base.get:Rpm( arg_pkg )
        return
    end

    con( pl, 'Requires parameter' )

    con( pl, 0  )
    con( pl, 1  )

    l1_d    = sf( '%-25s', 'rlib.rpm -l' )
    s1_l    = sf( '%-5s', '»' )
    l2_d    = sf( '%-15s', 'View packages' )

    con( pl, clr_y, l1_d, clr_p, s1_l, clr_w, l2_d )

    l1_d    = sf( '%-25s', 'rlib.rpm -i <pkg>' )
    s1_l    = sf( '%-5s', '»' )
    l2_d    = sf( '%-15s', 'Install a package' )

    con( pl, clr_y, l1_d, clr_p, s1_l, clr_w, l2_d )

    con( pl, 3  )

end
rcc.register( 'rlib_rpm', rcc_rpm )