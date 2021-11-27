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

SAP                         = SAP or { }

/*
    libraries
*/

local base                  = rlib
local access                = base.a
local helper                = base.h

/*
    sap > registered

    returns if id registered in module's sap table

    @param  : str, tbl mod
    @param  : str id
*/

function SAP:Registered( mod, id )
    if not mod then base:log( RLIB_LOG_ERR, '[ %s ] » module missing » [ %s ]', 'SAP', id ) return end
    if not id then base:log( RLIB_LOG_ERR, '[ %s ] » id missing', 'SAP' ) return end
    if not sha1 then base:log( RLIB_LOG_ERR, '[ %s ] » SHA1 missing » [ %s ]', 'SAP', id ) return end

    local lst       = base.modules:sap( mod )
    local src       = sha1.encrypt( id )

    if table.HasValue( lst, src ) then return true end

    return false
end

/*
    globals > Hex

    hex to color

    @ex     : Hex( '#FFF' )
              return > Color( 255, 255, 255, 255 )

    @param  : str hex
    @param  : int a
    @return : tbl
*/

function Hex( hex, a )
    local r, g, b = helper:clr_hex2rgb( hex, a )
    return Color( r, g, b, a )
end

/*
    globals > Hex > internal

    used for internal color change, returns a table and not
    a color table.

    hex to color

    @ex     : Hex( '#FFF' )
              return > Color( 255, 255, 255, 255 )

    @param  : str hex
    @param  : int a
    @return : tbl
*/

function iHex( hex, a )
    if not hex then
        base:log( RLIB_LOG_ERR, 'Hex » invalid code specified' )
        return Color( 255, 255, 255, 255 )
    end

    local r, g, b, a = helper:clr_hex2rgb( hex, a )
    return r, g, b, a
end

/*
*   globals > table > getmax
*
*   gets the max value of a table
*
*   @ex     : tbl = { 1, 4, 5, 6 }
*             table.GetMax( tbl )
*
*   @ret    : 6 (val), 4 (pos)
*
*   @param  : tbl tbl
*   @return : int, int
*             val, pos
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
*   globals > ents.Create ( alias )
*/

ents.new = ents.Create