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
local storage               = base.s
local access                = base.a

/*
    library > localize
*/

local cfg                   = base.settings
local mf                    = base.manifest
local pf                    = mf.prefix
local script                = mf.name

/*
    lua > localize
*/

local sf                    = string.format

/*
    languages
*/

local function ln( ... )
    return base:lang( ... )
end

/*
    localize output functions
*/

local function con( ... )
    base:console( ... )
end

/*
*   rcc :: materials :: list
*
*   lists materials that can be shared through-out scripts
*/

local function rcc_materials_list( pl, cmd, args )

    /*
    *   define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_mats' )

    /*
    *   scope
    */

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, script, ccmd.id )
        return
    end

    /*
    *   perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, script, ccmd.id )
        return
    end

    /*
    *   args
    */

    local arg_flag          = args and args[ 1 ] or false
    local arg_srch          = args and args[ 2 ] or nil

    /*
    *   declarations
    */

    local bCatListed        = false
    local cat_id            = ''
    local i_entries         = 0

    /*
    *   header
    */

    con( pl, 0 )
    con( pl, Color( 255, 0, 0 ), 'Registered Panels' )
    con( pl, 0 )

    /*
    *   header :: args
    */

    if arg_flag and arg_flag == '-s' and arg_srch then
        con( pl, Color( 255, 0, 0 ), ' ', Color( 255, 0, 0 ), ln( 'search_term', arg_srch ) )
    end

    /*
    *   loop modules
    */

    for a, b in pairs( rcore.modules ) do

        local i_fields = 0

        bCatListed = a ~= cat_id and false or bCatListed

        local mnfst = rlib.m:g_Manifest( b )
        if not mnfst then continue end

        local i = 0
        for c in helper.get.data( mnfst ) do
            i = i + 1
        end

        for k, v in pairs( mnfst ) do
            if not bCatListed then
                local cat       = sf( ' %s', a )

                con( pl, 0 )

                local c1_l      = sf( '%-15s',      cat:upper( ) )
                local c2_l      = sf( '%-35s',      ln( 'col_id' ) )
                local c3_l      = sf( '%-35s',      ln( 'col_ref_id' ) )
                local resp      = sf( '%s %s %s',   c1_l, c2_l, c3_l )

                con( pl, Color( 255, 255, 255 ), resp )
                con( pl, 0 )

                bCatListed, cat_id = true, a
            end

            for l, m in pairs( v ) do
                if arg_srch and not string.match( k, arg_srch ) then continue end
                i_fields        = i_fields + 1

                local c1_d      = sf( '%-15s',      tostring( '' ) )
                local c2_d      = sf( '%-35s',      tostring( k ) )
                local c3_d      = sf( '%-35s',      tostring( m ) )
                local resp      = sf( '%s %s %s ',  c1_d, c2_d, c3_d )

                if i_fields == i then
                    resp        = resp .. '\n'
                    i_fields    = 0
                else
                    i_entries   = i_entries + 1
                end

                con( pl, Color( 255, 255, 0 ), resp )
            end

        end

        bCatListed = false
    end
end
rcc.register( 'rlib_mats', rcc_materials_list )

/*
*   rcc :: panels :: registered
*
*   returns a list of registered panels
*
*   @usage  : rlib.panels <returns all panels>
*   @usage  : rlib.panels -s termhere <returns entries matching term>
*/

local function rcc_panels_registered( pl, cmd, args )

    /*
    *   define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_panels' )

    /*
    *   scope
    */

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, script, ccmd.id )
        return
    end

    /*
    *   perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, script, ccmd.id )
        return
    end

    /*
    *   functionality
    */

    local arg_flag          = args and args[ 1 ] or false
    local arg_srch          = args and args[ 2 ] or nil
    local i_entries         = 0
    local output            = '\n\n [' .. rlib.manifest.name .. '] :: registered panels'

    con( pl, output )

    /*
    *   declare
    */

    local tb_pnls           = base.p

    if arg_flag and arg_flag == '-s' and arg_srch then
        con( pl, Color( 255, 0, 0 ), ' ', Color( 255, 0, 0 ), ln( 'search_term', arg_srch ) )
    end

    /*
    *   loop > panels
    *
    *   a   : category ( str )
    *   b   : pnl data ( tbl )
    */

    local cat = nil
    for a, b in pairs( tb_pnls ) do

        local ent = 0
        for k, v in pairs( b ) do

            if not ent or ent == 0 then
                cat             = sf( ' %s', a )

                con( pl, 0 )

                local c1_l      = sf( '%-15s', cat )
                local c2_l      = sf( '%-35s', ln( 'col_id' ) )
                local c3_l      = sf( '%-35s', ln( 'col_data' ) )
                local resp      = sf( '%s %s %s', c1_l, c2_l, c3_l )

                con( pl, Color( 255, 255, 255 ), resp )
                con( pl, 0 )
            end

            ent = ent + 1

            local i             = 0
            local id, i_fields  = 0, 0
            for l, m in pairs( v ) do
                if arg_srch and not string.match( k, arg_srch ) then continue end
                i_fields        = i_fields + 1

                if i_fields ~= 1 then id = '' else id = k end

                local data      = tostring( m ) == '[NULL Panel]' and '-' or m

                local c1_d      = sf( '%-15s', tostring( '' ) )
                local c2_d      = sf( '%-35s', tostring( id ) )
                local c3_d      = sf( '%-35s', tostring( data ) )
                local resp      = sf( '%s %s %s ', c1_d, c2_d, c3_d )

                if i_fields == i then
                    resp        = resp .. '\n'
                    i_fields    = 0
                else
                    i_entries   = i_entries + 1
                end

                con( pl, Color( 255, 255, 0 ), resp )
            end

        end

    end

    con( pl, 1 )
    con( pl, Color( 0, 255, 0 ), sf( ln( 'inf_found_cnt', i_entries ) ) )
    con( pl, 1 )

end
rcc.register( 'rlib_panels', rcc_panels_registered )

/*
*   rcc :: terms
*
*   displays terms interface
*/

local function rcc_terms( pl, cmd, args )

    /*
    *   define command
    */

    local ccmd = base.calls:get( 'commands', 'rlib_terms' )

    /*
    *   scope
    */

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, script, ccmd.id )
        return
    end

    /*
    *   perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, script, ccmd.id )
        return
    end


end
rcc.register( 'rlib_terms', rcc_terms )