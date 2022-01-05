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
    libraries
*/

local base                  = rlib
local access                = base.a
local helper                = base.h

/*
    SAP
*/

SAP                         = SAP or { }
rclr                        = rclr or { }

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
    rclr > valid hex

    returns if string is valid hex color

    @ex     : rclr.bHex( 'FFFFFF' )
              true

            : rclr.bHex( '#FFF' )
              true

    @param  : str hex
    @param  : int a
    @return : tbl
*/

function rclr.bHex( val )
    if not isstring( val ) then return false end
    return ( val:match '^#?%x%x%x$' or val:match '^#?%x%x%x%x%x%x$' ) ~= nil
end

/*
    globals > Hex to RGB

    converts a valid hex color string into Color( x, x, x, x )

    @ex     : rclr.Hex2RGB( '#FFF' )
              return > 255, 255, 255, 255

    @param  : str hex
    @param  : int a
    @return : tbl
*/

function rclr.Hex2RGB( hex, a )
    hex         = hex:gsub( '#', '' )
                if not rclr.bHex( hex ) then return end

    a           = isnumber( a ) and a or 255

    if hex:len( ) == 3 then
        return tonumber( '0x' .. hex:sub( 1, 1 ) ) * 17, tonumber( '0x' .. hex:sub( 2, 2 ) ) * 17, tonumber( '0x' .. hex:sub( 3, 3 ) ) * 17, a
    elseif hex:len( ) == 6 then
        return tonumber( '0x' .. hex:sub( 1, 2 ) ), tonumber( '0x' .. hex:sub( 3, 4 ) ), tonumber( '0x' .. hex:sub( 5, 6 ) ), a
    else
        return 255, 255, 255, a
    end
end

/*
    globals > RGB to Hex

    converts gmod color object / table into hex color

    @note   : bNoClean removes 0X in front of string

    @ex     : rclr.RGB2Hex( Color( 0, 0, 0 ) )
              return > 000000

            : rclr.RGB2Hex( { 0, 0, 0 } )
              return > 000000

            : rclr.RGB2Hex( { 0, 0, 0, 200 } )
              return > 000000, 200

    @param  : clr || tbl rgb
    @param  : bool bClean

    @return : str, int
*/

function rclr.RGB2Hex( rgb, bNoClean )
    local hexdec        = '0X'
    local alpha         = 255

    if not istable( rgb ) and not IsColor( rgb ) then return end

    if IsColor( rgb ) then
        rgb = { rgb.r, rgb.g, rgb.b, rgb.a or alpha }
    end

    for k, v in pairs( rgb ) do
        local hex       = ''
        alpha           = k == 4 and v or alpha

        if k == 4 then continue end -- alpha

        while ( v > 0 ) do
            local ind       = math.fmod( v, 16 ) + 1
            v               = math.floor( v / 16 )
            local substr    = '0123456789ABCDEF'
            hex             = substr:sub( ind, ind ) .. hex
        end

        hex                 = ( hex:len( ) == 0 and '00' ) or ( hex:len( ) == 1 and '0' .. hex ) or hex
        hexdec              = hexdec .. hex
    end

    if not bNoClean then
        hexdec              = hexdec:gsub( '0X', '' )
    end

    return hexdec, alpha
end

/*
    globals > Hex

    hex to color

    @note   : deprecate Hex global func

    @ex     : rclr.Hex( '#FFF' )
              return > Color( 255, 255, 255, 255 )

    @param  : str hex
    @param  : int a
    @return : tbl
*/

function rclr.Hex( hex, a )
    if not rclr.bHex( hex ) then
        base:log( RLIB_LOG_ERR, 'Hex > invalid hex specified [ %s ]', tostring( hex ) )
        return Color( 255, 255, 255, 255 )
    end

    hex = helper.str:clean( hex, true )

    local r, g, b, a = rclr.Hex2RGB( hex, a )
    return Color( r, g, b, a )
end

if not isfunction( Hex ) then
    Hex = rclr.Hex
end

/*
    globals > Hex > internal

    used for internal color change, returns a table and not
    a color table.

    hex to color

    @ex     : rclr.HexObj( '#FFF' )
              return > Color( 255, 255, 255, 255 )

    @param  : str hex
    @param  : int a

    @return : int, int, int, int
*/

function rclr.HexObj( hex, a )
    if not rclr.bHex( hex ) then
        base:log( RLIB_LOG_ERR, 'Hex > invalid hex specified [ %s ]', tostring( hex ) )
        return Color( 255, 255, 255, 255 )
    end

    local r, g, b, a = rclr.Hex2RGB( hex, a )
    return r, g, b, a
end

/*
    globals > table > getmax

    gets the max value of a table

    @ex     : tbl = { 1, 4, 5, 6 }
              table.GetMax( tbl )

    @ret    : 6 (val), 4 (pos)

    @param  : tbl tbl
    @return : int, int
              val, pos
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
    globals > ents.Create ( alias )
*/

ents.new = ents.Create