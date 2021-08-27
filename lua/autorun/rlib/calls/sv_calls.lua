/*
*   @module         : rlib
*   @docs           : https://rlib.io
*
*   YOU MAY NOT REDISTRIBUTE THESE FILES WITHOUT PERMISSION FROM THE DEVELOPER.
*
*   IF YOU HAVE NOT DIRECTLY RECEIVED THESE FILES FROM THE DEVELOPER, PLEASE CONTACT THE DEVELOPER
*   LISTED ABOVE.
*
*   THE WORK (AS DEFINED BELOW) IS PROVIDED UNDER THE TERMS OF THIS CREATIVE COMMONS PUBLIC LICENSE
*   ('CCPL' OR 'LICENSE'). THE WORK IS PROTECTED BY COPYRIGHT AND/OR OTHER APPLICABLE LAW. ANY USE OF
*   THE WORK OTHER THAN AS AUTHORIZED UNDER THIS LICENSE OR COPYRIGHT LAW IS PROHIBITED.
*
*   BY EXERCISING ANY RIGHTS TO THE WORK PROVIDED HERE, YOU ACCEPT AND AGREE TO BE BOUND BY THE TERMS
*   OF THIS LICENSE. TO THE EXTENT THIS LICENSE MAY BE CONSIDERED TO BE A CONTRACT, THE LICENSOR GRANTS
*   YOU THE RIGHTS CONTAINED HERE IN CONSIDERATION OF YOUR ACCEPTANCE OF SUCH TERMS AND CONDITIONS.
*
*   UNLESS OTHERWISE MUTUALLY AGREED TO BY THE PARTIES IN WRITING, LICENSOR OFFERS THE WORK AS-IS AND
*   ONLY TO THE EXTENT OF ANY RIGHTS HELD IN THE LICENSED WORK BY THE LICENSOR. THE LICENSOR MAKES NO
*   REPRESENTATIONS OR WARRANTIES OF ANY KIND CONCERNING THE WORK, EXPRESS, IMPLIED, STATUTORY OR
*   OTHERWISE, INCLUDING, WITHOUT LIMITATION, WARRANTIES OF TITLE, MARKETABILITY, MERCHANTIBILITY,
*   FITNESS FOR A PARTICULAR PURPOSE, NONINFRINGEMENT, OR THE ABSENCE OF LATENT OR OTHER DEFECTS, ACCURACY,
*   OR THE PRESENCE OF ABSENCE OF ERRORS, WHETHER OR NOT DISCOVERABLE. SOME JURISDICTIONS DO NOT ALLOW THE
*   EXCLUSION OF IMPLIED WARRANTIES, SO SUCH EXCLUSION MAY NOT APPLY TO YOU.
*/

/*
*   standard tables and localization
*/

local base                  = rlib
local mf                    = base.manifest

/*
*   localized rlib routes
*/

local helper                = base.h

/*
*   Localized translation func
*/

local function ln( ... )
    return base:lang( ... )
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
    base:log( 6, ln( 'calls_register_nlib' ) )

    rhook.run.rlib( 'rlib_calls_pre' )

    if not base._rcalls[ 'net' ] then
        base._rcalls[ 'net' ] = { }
        base:log( RLIB_LOG_RNET, ln( 'calls_register_tbl' ) )
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
*   calls > catalog
*
*   loads library calls catalog
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

function base.calls:Catalog( bPrefix, affix )
    for v in helper.get.data( base._rcalls[ 'net' ] ) do
        local aff       = isstring( affix ) and affix or mf.prefix
        local id        = bPrefix and tostring( aff .. v[ 1 ] ) or tostring( v[ 1 ] )

        util.AddNetworkString( id )
        base:log( 1, ln( 'rnet_added', id ) )
    end
end