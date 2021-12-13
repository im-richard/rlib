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
local access                = base.a
local helper                = base.h

/*
    languages
*/

local function ln( ... )
    return base:lang( ... )
end

/*
    prefix > get id
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and base.manifest.prefix ) or false
    return base.get:pref( str, state )
end

/*
    register net libraries
*/

local function rnet_register( pl )

    /*
        permission > rnet refresh
    */

    if ( ( helper.ok.ply( pl ) or access:bIsConsole( pl ) ) and not access:allow_throwExcept( pl, 'rlib_root' ) ) then return end

    /*
        rnet > restart > broadcast
    */

    rnet.new		( 'rlib_rs_broadcast'           )
        rnet.add    ( 'active',     RNET_BOOL       )
        rnet.add    ( 'remains',    RNET_UINT32     )
    rnet.run	    (                               )

    /*
        rnet > debug > broadcast
    */

    rnet.new		( 'rlib_debug_broadcast'        )
        rnet.add    ( 'active',     RNET_BOOL       )
        rnet.add    ( 'remains',    RNET_UINT32     )
    rnet.run	    (                               )

    /*
        concommand > reload
    */

    if helper.ok.ply( pl ) or access:bIsConsole( pl ) then
        base:log( RLIB_LOG_OK, '[ %s ] rnet reloaded', base.manifest.name )
        if not access:bIsConsole( pl ) then
            base.msg:target( pl, base.manifest.name, 'rnet module successfully rehashed.' )
        end
    end

end
rhook.new.rlib( 'rlib_rnet_register', rnet_register )
rcc.new.rlib( 'rlib_rnet_reload', rnet_register )

/*
    CLIENT
*/

if CLIENT then

    local ui            = base.i
    local design        = base.d

    /*
        broadcast > restart
    */

    local function rnet_rs_broadcast( data )
        local bActive       = data.active or false
        local remains       = data.remains or 0

        base.sys.rs_remains = remains

        if not bActive then
            ui:dispatch( base.restart )
            return
        end

        if not ui:ok( base.restart ) then
            design:restart( msg )
        end
    end
    rnet.call( 'rlib_rs_broadcast', rnet_rs_broadcast )

    /*
        broadcast > debug
    */

    local function rnet_debug_broadcast( data )
        local bActive       = data.active or false
        local remains       = data.remains or 0

        base.sys.debug      = remains

        if not bActive then
            ui:dispatch( base.debug )
            return
        end

        if not ui:ok( base.debug ) then
            design:debug( )
        end
    end
    rnet.call( 'rlib_debug_broadcast', rnet_debug_broadcast )

end