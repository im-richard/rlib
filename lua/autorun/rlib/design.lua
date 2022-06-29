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
local design                = base.d
local ui                    = base.i
local mats                  = base.m
local font                  = base.f

/*
    library > localize
*/

local cfg                   = base.settings
local mf                    = base.manifest
local pf                    = mf.prefix

/*
    lua > localize
*/

local mat_def               = Material( 'pp/colour' )

/*
    languages
*/

local function ln( ... )
    return base:lang( ... )
end

/*
    prefix
*/

local function pref( str, suffix )
    local state = not suffix and mod or isstring( suffix ) and suffix or false
    return base.get:pref( str, state )
end

/*
    design > sub
*/

design.rcir                 = design.rcir or { }

/*
    constants > text align
*/

RLIB_TALIGN_L               = 4
RLIB_TALIGN_C               = 5
RLIB_TALIGN_R               = 6
RLIB_TALIGN_T               = 8
RLIB_TALIGN_B               = 2

/*
    notifications > storage > clean

    locates any panels that are invalid or no longer visible and removes them
    from the push notification storage table.
*/

local function slot_storage_clean( )
    if istable( base.push ) then
        for k, v in pairs( base.push ) do
            if v and ui:visible( v ) and k < 9 and tostring( v ) ~= '[NULL Panel]' then continue end
            base.push[ k ] = nil
        end
    end

    if istable( base.sos ) then
        for k, v in pairs( base.sos ) do
            if v and ui:visible( v ) and k < 9 and tostring( v ) ~= '[NULL Panel]' then continue end
            base.sos[ k ] = nil
        end
    end
end

/*
    locate slot > push notifications

    determines where an available slot is to place the notification
    on the players screen

    limit to 8 slots

    @param  : pnl obj
    @return : int, int
*/

local function loc_slot_push( obj )
    slot_storage_clean( )
    local pos_new = 150

    for i = 1, 8, 1 do
        if base.push[ i ] then
            local id    = base.push[ i ]
            pos_new     = pos_new + id:GetTall( )
            pos_new     = pos_new + 5
            continue
        end
        return i, pos_new
    end
end

/*
    locate slot > sos

    determines where an available slot is to place the notification
    on the players screen

    limit to 8 slots

    @param  : pnl obj
    @return : int, int
*/

local function loc_slot_sos( obj )
    slot_storage_clean( )
    local pos_new = 5

    for i = 1, 8, 1 do
        if base.sos[ i ] then
            local id    = base.sos[ i ]
            pos_new     = pos_new + id:GetTall( )
            pos_new     = pos_new + 5
            continue
        end
        return i, pos_new
    end
end

/*
*   design > blur
*
*   @param  : pnl pnl
*   @param  : int amt
*   @param  : int amplify
*/

local blur = Material( helper._mat[ 'pp_blur' ] )
function design.blur( pnl, amt, amplify )
    if not IsValid( pnl ) then return end

    amt                 = isnumber( amt ) and amt or 6
    amplify             = isnumber( amplify ) and amplify or 3

    local x, y          = pnl:LocalToScreen( 0, 0 )
    local scr_w, scr_h  = ScrW( ), ScrH( )

    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.SetMaterial ( blur )

    for i = 1, ( amplify ) do
        blur:SetFloat   ( '$blur', ( i / amplify ) * amt )
        blur:Recompute  ( )

        if render then render.UpdateScreenEffectTexture( ) end
        surface.DrawTexturedRect( x * -1, y * -1, scr_w, scr_h )
    end
end

/*
*   design > blur > trim
*
*   setting blur to certain panels can cause a "beveling affect".
*   this will extend the blur outside the edges of the panel in order to smooth
*   it out.
*
*   @param  : pnl pnl
*   @param  : int amt
*   @param  : int amplify
*/

function design.blur_trim( pnl, amt, amplify )
    if not IsValid( pnl ) then return end

    amt                 = isnumber( amt ) and amt or 6
    amplify             = isnumber( amplify ) and amplify or 3

    local x, y          = pnl:LocalToScreen( 0, 0 )
    local scr_w, scr_h  = ScrW( ), ScrH( )

    x                   = x + 30
    scr_w               = scr_w + 40

    y                   = y + 30
    scr_h               = scr_h + 40

    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.SetMaterial ( blur )

    for i = 1, ( amplify ) do
        blur:SetFloat   ( '$blur', ( i / amplify ) * amt )
        blur:Recompute  ( )

        if render then render.UpdateScreenEffectTexture( ) end
        surface.DrawTexturedRect( x * -1, y * -1, scr_w, scr_h )
    end
end

/*
*   design > blur > self
*
*   @param  : clr clr
*   @param  : int amt
*   @param  : int amplify
*/

function design.blurself( clr, amt, amplify )
    local x, y, frac = 0, 0, 1

    clr         = IsColor( clr ) and clr or Color( 5, 5, 5, 200 )
    amt         = isnumber( amt ) and amt or 6
    amplify     = isnumber( amplify ) and amplify or 3

    DisableClipping( true )

    surface.SetMaterial ( blur )
    surface.SetDrawColor( 255, 255, 255, 255 )

    for i = 1, ( amplify ) do
        blur:SetFloat   ( '$blur', ( i / amplify ) * amt )
        blur:Recompute  ( )

        if render then render.UpdateScreenEffectTexture( ) end
        surface.DrawTexturedRect( x * -1, y * -1, ScrW( ), ScrH( ) )
    end

    surface.SetDrawColor( clr.r, clr.g, clr.b, clr.a * frac )
    surface.DrawRect    ( x * -1, y * -1, ScrW(), ScrH() )

    DisableClipping( false )
end

/*
*   design > rgb
*
*   @param  : int state
*   @param  : int r
*   @param  : int g
*   @param  : int b
*   @param  : int a
*   @return : int, int, int, int
*/

function design.rgb( state, r, g, b, a )

    r = isnumber( r ) and r or 0
    g = isnumber( g ) and g or 0
    b = isnumber( b ) and b or 0
    a = isnumber( a ) and a or 255

    if ( state == 0 ) then
        g = g + 1
        if ( g >= 255 ) then state = 1 end
    elseif ( state == 1 ) then
        r = r - 1
        if ( r <= 0 ) then state = 2 end
    elseif ( state == 2 ) then
        b = b + 1
        if ( b >= 255 ) then state = 3 end
    elseif ( state == 3 ) then
        g = g - 1
        if ( g <= 0 ) then state = 4 end
    elseif ( state == 4 ) then
        r = r + 1
        if ( r >= 255 ) then state = 5 end
    elseif ( state == 5 ) then
        b = b - 1
        if ( b <= 0 ) then state = 0 end
    end

    return state, r, g, b, a

end

/*
*   design > line
*
*   @param  : int x
*   @param  : int y
*   @param  : int w
*   @param  : int h
*   @param  : clr clr
*/

function design.line( x_start, y_start, x_end, y_end, clr )
    if not x_start or not y_start or not x_end or not y_end then return end

    clr     = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )

    surface.SetDrawColor	( clr           )
    surface.DrawLine		( x_start, y_start, x_end, y_end )
end

/*
*   design > box
*
*   @param  : int x
*   @param  : int y
*   @param  : int w
*   @param  : int h
*   @param  : clr clr
*/

function design.box( x, y, w, h, clr )
    h       = isnumber( h ) and h or w
    clr     = IsColor( clr ) and clr or Color( 0, 0, 0, 255 )

    surface.SetDrawColor    ( clr )
    surface.DrawRect        ( x, y, w, h )
end

/*
*   design > poly
*
*   @param  : tbl data
*   @param  : clr clr
*/

function design.poly( data, clr )
    if not istable( data ) then return end

    clr     = IsColor( clr ) and clr or Color( 0, 0, 0, 255 )

    draw.NoTexture          (       )
    surface.SetDrawColor    ( clr   )
    surface.DrawPoly        ( data  )
end

/*
*   design > box > 3d
*
*   @param  : int w
*   @param  : int min
*   @param  : int max
*   @param  : clr clr
*/

function design.box3d( w, min, max, clr )
    local offset                = Vector( 2, 2, 2 )
    local mid, lmin, lmax       = calc.pos.midpoint( min, max )
    local angle_zero            = Angle( 0, 0, 0 )

    render.DrawBeam( min, Vector( min.x, max.y, min.z ), w, 0, 0, clr )  -- Back Face Top
    render.DrawBeam( min, Vector( max.x, min.y, min.z ), w, 0, 0, clr ) -- Left Face Top
    render.DrawBeam( min, Vector( min.x, min.y, max.z ), w, 0, 0, clr ) -- Left Face Left

    render.DrawBeam( max, Vector( max.x, max.y, min.z ), w, 0, 0, clr ) -- Front Face Right
    render.DrawBeam( max, Vector( max.x, min.y, max.z ), w, 0, 0, clr ) -- Front Face Bottom
    render.DrawBeam( max, Vector( min.x, max.y, max.z ), w, 0, 0, clr ) -- Right Face Bottom

    render.DrawBeam( Vector( min.x, min.y, max.z ), Vector( min.x, max.y, max.z ), w, 0, 0, clr ) -- Front Face Bottom
    render.DrawBeam( Vector( min.x, min.y, max.z ), Vector( max.x, min.y, max.z ), w, 0, 0, clr ) -- Left Face Bottom
    render.DrawBeam( Vector( max.x, min.y, max.z ), Vector( max.x, min.y, min.z ), w, 0, 0, clr ) -- Front Face Left

    render.DrawBeam( Vector( min.x, max.y, max.z ), Vector( min.x, max.y, min.z ), w, 0, 0, clr ) -- Back Face Right
    render.DrawBeam( Vector( max.x, max.y, min.z ), Vector( min.x, max.y, min.z ), w, 0, 0, clr ) -- Right Face Top
    render.DrawBeam( Vector( max.x, max.y, min.z ), Vector( max.x, min.y, min.z ), w, 0, 0, clr ) -- Front Face Top

    clr.a = clr.a - 50

    render.DrawBox( mid, angle_zero, lmin, lmax, clr )
    render.DrawBox( min, angle_zero, -offset, offset, Color( 0, 255, 255, 200 ), true )
    render.DrawBox( max, angle_zero, -offset, offset, Color( 255, 0, 0,200 ), true )

    return mid, lmin, lmax
end

/*
*   design > material
*
*   this function allows for a material to be a valid  imat OR string
*   which is the old method and may cause performance issues if only a string
*   is provided since Material( ) will be ran in the paint hook.
*
*   use design.imat instead
*
*   @param  : int x
*   @param  : int y
*   @param  : int w
*   @param  : int h
*   @param  : str, imaterial mat
*   @param  : clr clr
*/

function design.mat( x, y, w, h, mat, clr )
    local src   = mats:ok( mat ) and mat or istable( mat ) and mat.material or isstring( mat ) and mat
    src         = isstring( src ) and Material( src, 'noclamp smooth' ) or src or mat_def
    clr         = clr or Color( 255, 255, 255, 255 )

    surface.SetMaterial         ( src           )
    surface.SetDrawColor        ( clr           )
    surface.DrawTexturedRect    ( x, y, w, h    )
end

/*
*   design > imat
*
*   replaces design.mat
*   all materials passed are now required to be materials
*
*   @param  : int x
*   @param  : int y
*   @param  : int w
*   @param  : int h
*   @param  : imat mat
*   @param  : clr clr
*/

function design.imat( x, y, w, h, mat, clr )
    local src   = mats:ok( mat ) and mat or false
                if not src then return end

    clr         = clr or Color( 255, 255, 255, 255 )

    surface.SetMaterial         ( src           )
    surface.SetDrawColor        ( clr           )
    surface.DrawTexturedRect    ( x, y, w, h    )
end

/*
*   design > mat > rotated
*
*   @param  : int x
*   @param  : int y
*   @param  : int w
*   @param  : int h
*   @param  : int r
*   @param  : str, imaterial mat
*   @param  : clr clr
*/

function design.mat_r( x, y, w, h, r, mat, clr )
    r       = isnumber( r ) and r or 0
    mat     = isstring( mat ) and Material( mat, 'noclamp smooth' ) or mat
    clr     = clr or Color( 255, 255, 255, 255 )

    surface.SetMaterial( mat )
    surface.SetDrawColor( clr )
    surface.DrawTexturedRectRotated( x, y, w, h, r )
end

/*
*   design > imat > rotated
*
*   @param  : int x
*   @param  : int y
*   @param  : int w
*   @param  : int h
*   @param  : int r
*   @param  : str, imaterial mat
*   @param  : clr clr
*/

function design.imat_r( x, y, w, h, r, mat, clr )
    r       = isnumber( r ) and r or 0
    mat     = mats:ok( mat ) and mat or false
            if not mat then return end

    clr     = clr or Color( 255, 255, 255, 255 )

    surface.SetMaterial( mat )
    surface.SetDrawColor( clr )
    surface.DrawTexturedRectRotated( x, y, w, h, r )
end

/*
*   design > nat_rotated
*
*   @param  : int x
*   @param  : int y
*   @param  : int w
*   @param  : int h
*   @param  : int ang
*/

function design.mat_rotate( x, y, w, h, ang )
    surface.DrawTexturedRectRotated( x, y, w, h, ang )
end

/*
*   design > loader
*
*   @param  : int x
*   @param  : int y
*   @param  : int sz
*   @param  : clr clr
*/

function design.loader( x, y, sz, clr )
    x       = x or 0
    y       = y or 0
    sz      = sz or 100
    clr     = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )

    local a = math.abs( math.sin( CurTime( ) * 4 ) * 255 )
    a       = math.Clamp( a, 200, 255 )

    local color = ColorAlpha( clr, a )

    surface.SetMaterial     ( base._def.mats[ 'loader' ] )
    surface.SetDrawColor    ( color )

    design.mat_rotate( x, y, sz, sz, ( CurTime( ) % 360 ) * -100 )
end

/*
*   design > rounded box
*
*   @param  : int r
*   @param  : int x
*   @param  : int y
*   @param  : int w
*   @param  : int h
*   @param  : clr clr
*/

function design.rbox( r, x, y, w, h, clr )
    r       = r or 0
    x       = x or 0
    y       = y or 0
    w       = w or ScrW( )
    h       = h or ScrH( )
    clr     = IsColor( clr ) and clr or Color( 0, 0, 0, 255 )

    if r <= 0 then
        design.box( x, y, w, h, clr )
        return
    end

    draw.RoundedBox( r, x, y, w, h, clr )
end

/*
*   design > rounded box > advanced
*
*   @param  : int bsize
*   @param  : int x
*   @param  : int y
*   @param  : int w
*   @param  : int h
*   @param  : clr clr
*   @param  : bool tl
*   @param  : bool tr
*   @param  : bool bl
*   @param  : bool br
*/

function design.rbox_adv( bsize, x, y, w, h, clr, tl, tr, bl, br )

    clr = IsColor( clr ) and clr or Color( 0, 0, 0, 255 )

    surface.SetDrawColor( clr.r, clr.g, clr.b, clr.a )

    if bsize <= 0 then
        surface.DrawRect( x, y, w, h )
        return
    end

    x = math.Round( x )
    y = math.Round( y )
    w = math.Round( w )
    h = math.Round( h )

    bsize = math.min( math.Round( bsize ), math.floor( w / 2 ) )

    surface.DrawRect( x + bsize, y, w - bsize * 2, h )
    surface.DrawRect( x, y + bsize, bsize, h - bsize * 2 )
    surface.DrawRect( x + w - bsize, y + bsize, bsize, h - bsize * 2 )

    local tex_id = helper._corners[ 'corner_8' ]
    if ( bsize > 8 ) then tex_id = helper._corners[ 'corner_16' ] end
    if ( bsize > 16 ) then tex_id = helper._corners[ 'corner_32' ] end
    if ( bsize > 32 ) then tex_id = helper._corners[ 'corner_64' ] end
    if ( bsize > 64 ) then tex_id = helper._corners[ 'corner_512' ] end

    local tex = surface.GetTextureID( tex_id )
    surface.SetTexture( tex )

    if tl then
        surface.DrawTexturedRectUV( x, y, bsize, bsize, 0, 0, 1, 1 )
    else
        surface.DrawRect( x, y, bsize, bsize )
    end

    if tr then
        surface.DrawTexturedRectUV( x + w - bsize, y, bsize, bsize, 1, 0, 0, 1 )
    else
        surface.DrawRect( x + w - bsize, y, bsize, bsize )
    end

    if bl then
        surface.DrawTexturedRectUV( x, y + h -bsize, bsize, bsize, 0, 1, 1, 0 )
    else
        surface.DrawRect( x, y + h - bsize, bsize, bsize )
    end

    if br then
        surface.DrawTexturedRectUV( x + w - bsize, y + h - bsize, bsize, bsize, 1, 1, 0, 0 )
    else
        surface.DrawRect( x + w - bsize, y + h - bsize, bsize, bsize )
    end

end

/*
*   design > outlined box
*
*   @param  : int x
*   @param  : int y
*   @param  : int w
*   @param  : int h
*   @param  : clr m_clr
*   @param  : clr b_clr
*/

function design.obox( x, y, w, h, m_clr, b_clr )
    local i, n      = 1, 2
    m_clr           = IsColor( m_clr ) and m_clr or Color( 0, 0, 0, 255 )
    b_clr           = IsColor( b_clr ) and b_clr or Color( 255, 255, 255, 255 )

    surface.SetDrawColor        ( m_clr )
    surface.DrawRect            ( x + i, y + i, w - n, h - n )
    surface.SetDrawColor        ( b_clr )
    surface.DrawOutlinedRect    ( x, y, w, h )
end

/*
*   design > outlined box thick
*
*   @param  : int x
*   @param  : int y
*   @param  : int w
*   @param  : int h
*   @param  : clr m_clr
*   @param  : int b_wide
*/

function design.obox_th( x, y, w, h, m_clr, b_wide )
    m_clr           = IsColor( m_clr ) and m_clr or Color( 0, 0, 0, 255 )
    b_wide          = isnumber( b_wide ) and b_wide or 1

    surface.SetDrawColor( m_clr )
    for i = 0, b_wide - 1 do
        surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
    end
end

/*
*   design > text
*
*   to be deprecated
*
*   ::  align enums
*       0   ::  TEXT_ALIGN_LEFT
*       1   ::  TEXT_ALIGN_CENTER
*       2   ::  TEXT_ALIGN_RIGHT
*       3   ::  TEXT_ALIGN_TOP
*       4   ::  TEXT_ALIGN_BOTTOM
*
*   @param  : str text
*   @param  : int x
*   @param  : int y
*   @param  : clr clr
*   @param  : str fnt
*   @param  : enum aln_x
*   @param  : enum aln_y
*   @return : w, h
*/

function design.text( text, x, y, clr, fnt, aln_x, aln_y )
    text            = tostring( text )
    x               = isnumber( x ) and x or 0
    y               = isnumber( y ) and y or 0
    clr             = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
    fnt             = isstring( fnt ) and fnt or ( pref( 'design_text_default' ) )
    aln_x           = aln_x or TEXT_ALIGN_LEFT
    aln_y           = aln_y or TEXT_ALIGN_TOP

    surface.SetFont( fnt )
    local w, h = surface.GetTextSize( text )

    if ( aln_x == TEXT_ALIGN_CENTER or aln_x == RLIB_TALIGN_C ) then
        x = x - w / 2
    elseif ( aln_x == TEXT_ALIGN_RIGHT or aln_x == RLIB_TALIGN_R ) then
        x = x - w
    end

    if ( aln_y == TEXT_ALIGN_CENTER or aln_y == RLIB_TALIGN_C ) then
        y = y - h / 2
    elseif ( aln_y == TEXT_ALIGN_BOTTOM or aln_y == RLIB_TALIGN_B ) then
        y = y - h
    end

    surface.SetTextPos( math.ceil( x ), math.ceil( y ) )

    if IsColor( clr ) then
        local alpha = 255
        if ( clr.a ) then alpha = clr.a end
        surface.SetTextColor( clr.r, clr.g, clr.b, alpha )
    else
        surface.SetTextColor( 255, 255, 255, 255 )
    end

    surface.DrawText( text )

    return w, h
end

/*
*   design > txt
*
*   ::  align enums
*       0   ::  TEXT_ALIGN_LEFT
*       1   ::  TEXT_ALIGN_CENTER
*       2   ::  TEXT_ALIGN_RIGHT
*       3   ::  TEXT_ALIGN_TOP
*       4   ::  TEXT_ALIGN_BOTTOM
*
*   @param  : str text
*   @param  : int x
*   @param  : int y
*   @param  : clr clr
*   @param  : str fnt
*   @param  : enum aln_x
*   @param  : enum aln_y
*   @return : w, h
*/

function design.txt( text, x, y, clr, fnt, aln_x, aln_y )
    text            = tostring( text )
    x               = isnumber( x ) and x or 0
    y               = isnumber( y ) and y or 0
    clr             = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
    fnt             = isstring( fnt ) and fnt or ( pref( 'design_text_default' ) )
    aln_x           = aln_x or TEXT_ALIGN_LEFT
    aln_y           = aln_y or TEXT_ALIGN_TOP

    surface.SetFont( fnt )
    local w, h = surface.GetTextSize( text )

    if ( aln_x == TEXT_ALIGN_CENTER or aln_x == RLIB_TALIGN_C ) then
        x = x - w / 2
    elseif ( aln_x == TEXT_ALIGN_RIGHT or aln_x == RLIB_TALIGN_R ) then
        x = x - w
    end

    if ( aln_y == TEXT_ALIGN_CENTER or aln_y == RLIB_TALIGN_C ) then
        y = y - h / 2
    elseif ( aln_y == TEXT_ALIGN_BOTTOM or aln_y == RLIB_TALIGN_B ) then
        y = y - h
    end

    surface.SetTextPos( math.ceil( x ), math.ceil( y ) )

    if IsColor( clr ) then
        local alpha = 255
        if ( clr.a ) then alpha = clr.a end
        surface.SetTextColor( clr.r, clr.g, clr.b, alpha )
    else
        surface.SetTextColor( 255, 255, 255, 255 )
    end

    surface.DrawText( text )

    return w, h
end

/*
*   design > language
*
*   revision of draw.SimpleTet
*   supports font prefixes
*
*   >   align enums
*       0   ::  TEXT_ALIGN_LEFT
*       1   ::  TEXT_ALIGN_CENTER
*       2   ::  TEXT_ALIGN_RIGHT
*       3   ::  TEXT_ALIGN_TOP
*       4   ::  TEXT_ALIGN_BOTTOM
*
*   @param  : str, tbl pf
*   @param  : str text
*   @param  : str fnt
*   @param  : int x
*   @param  : int y
*   @param  : clr clr
*   @param  : enum aln_x
*   @param  : enum aln_y
*   @return : w, h
*/

function design.lng( pf, text, fnt, x, y, clr, aln_x, aln_y )
    text            = tostring( text )
    fnt             = fnt or ( pref( 'design_text_default' ) )
    x               = x and x or 0
    y               = y and y or 0
    clr             = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
    aln_x           = aln_x or TEXT_ALIGN_LEFT
    aln_y           = aln_y or TEXT_ALIGN_TOP

    local _f        = font.get( pf, fnt )
    local w, h      = helper.str:len( text, _f )

    if ( aln_x == TEXT_ALIGN_CENTER or aln_x == RLIB_TALIGN_C ) then
        x = x - w / 2
    elseif ( aln_x == TEXT_ALIGN_RIGHT or aln_x == RLIB_TALIGN_R ) then
        x = x - w
    end

    if ( aln_y == TEXT_ALIGN_CENTER or aln_y == RLIB_TALIGN_C ) then
        y = y - h / 2
    elseif ( aln_y == TEXT_ALIGN_BOTTOM or aln_y == RLIB_TALIGN_B ) then
        y = y - h
    end

    surface.SetTextPos( math.ceil( x ), math.ceil( y ) )

    if IsColor( clr ) then
        local a = 255
        if ( clr.a ) then a = clr.a end
        surface.SetTextColor( clr.r, clr.g, clr.b, a )
    else
        surface.SetTextColor( 255, 255, 255, 255 )
    end

    surface.DrawText( text )

    return w, h
end

/*
*   design > text_adv
*
*   works like design.txt but with newlines & tabs
*   originally part of gmod lib
*
*   ::  align enums
*       0   ::  TEXT_ALIGN_LEFT
*       1   ::  TEXT_ALIGN_CENTER
*       2   ::  TEXT_ALIGN_RIGHT
*       3   ::  TEXT_ALIGN_TOP
*       4   ::  TEXT_ALIGN_BOTTOM
*
*   @param  : str text
*   @param  : int x
*   @param  : int y
*   @param  : clr clr
*   @param  : enum aln_x
*   @return : pos_x, pos_y
*/

function design.text_adv( text, x, y, clr, fnt, aln_x )
    text        = text or 'missing text'
    x           = isnumber( x ) and x or 0
    y           = isnumber( y ) and y or 0
    clr         = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
    fnt         = isstring( fnt ) and fnt or ( pref( 'design_text_default' ) )
    aln_x       = aln_x or TEXT_ALIGN_LEFT

    local pos_x, pos_y      = x, y
    local size_w, size_h    = helper.str:len( '\n', fnt )
    local tab_w             = 50

    for str in string.gmatch( text, '[^\n]*' ) do
        if #str > 0 then
            if string.find( str, '\t' ) then
                for tabs, str_alt in string.gmatch( str, '(\t*)([^\t]*)' ) do --'
                    pos_x = math.ceil( ( pos_x + tab_w * math.max( #tabs - 1, 0 ) ) / tab_w ) * tab_w

                    if #str_alt > 0 then
                        design.txt( str_alt, pos_x, pos_y, clr, fnt, aln_x )

                        local w, _ = surface.GetTextSize( str_alt )
                        pos_x = pos_x + w
                    end
                end
            else
                design.txt( str, pos_x, pos_y, clr, fnt, aln_x )
            end
        else
            pos_x = x
            pos_y = pos_y + ( size_h / 2 )
        end
    end

    return pos_x, pos_y

end

/*
*   design > title boxcat
*
*   displays a title and sets a category-style box to display to the right of the title with text being
*   autosized to fit within
*
*   @todo   : make a little more simple for next version
*
*   @param  : str title
*   @param  : str title_font
*   @param  : str cat
*   @param  : str cat_font
*   @param  : clr t_clr
*   @param  : clr b_clr
*   @param  : clr t_clr
*   @param  : int pos_x
*   @param  : int pos_y
*   @param  : int offset_x
*   @param  : int offset_y
*   @param  : int cat_w_os
*   @param  : int text_os_w
*/

function design.title_boxcat( title, title_fnt, cat, cat_fnt, t_clr, b_clr, c_clr, pos_x, pos_y, offset_x, offset_y, cat_w_os, text_os_w )
    if not title then return end
    if not title_fnt then return end

    cat                     = isstring( cat ) and cat or 'no category'
    cat_fnt                 = isstring( cat_fnt ) and cat_fnt or title_fnt
    t_clr                   = IsColor( t_clr ) and t_clr or Color( 255, 255, 255, 255 )
    b_clr                   = IsColor( b_clr ) and b_clr or Color( 0, 73, 156, 255 )
    c_clr                   = IsColor( c_clr ) and c_clr or Color( 255, 255, 255, 255 )
    pos_x                   = pos_x or 0
    pos_y                   = pos_y or 15
    offset_x                = offset_x or 0
    offset_y                = offset_y or 0
    cat_w_os                = cat_w_os or 20
    text_os_w               = text_os_w or 0

    /*
    *   title variables
    */

    surface.SetFont( title_fnt )

    title                   = isstring( title ) and title or tostring( title )
    local title_w, title_h  = surface.GetTextSize( title )
    title_w                 = title_w + offset_x + 10

    /*
    *   cat variables
    */

    surface.SetFont( cat_fnt )

    cat                     = isstring( cat ) and cat or tostring( cat )
    local cat_w, cat_h      = surface.GetTextSize( cat )
    cat_h                   = cat_h + offset_y
    cat_w                   = cat_w + cat_w_os

    /*
    *   draw
    */

    draw.SimpleText( title, title_fnt, pos_x, pos_y, t_clr, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.RoundedBox( 4, pos_x + title_w, pos_y - ( cat_h / 2 ), cat_w, cat_h, b_clr )
    draw.SimpleText( cat:upper( ), cat_fnt, pos_x + title_w + ( cat_w / 2 ) - text_os_w, pos_y, c_clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

/*
*   design > bokeh eff
*
*   @param  : int amt
*   @param  : int, tbl isize
*   @param  : int, tbl ispeed
*   @param  : clr, str clr
*   @return : int amt, tbl fx_bokeh
*/

function design:bokeh( amt, isize, ispeed, clr, alpha )
    amt = amt or 25

    if istable( isize ) then
        size_min, size_max = isize[ 1 ], isize[ 2 ]
    elseif isnumber( isize ) then
        size_min, size_max = isize, isize
    else
        size_min, size_max = 25, 25
    end

    if istable( ispeed ) then
        speed_min, speed_max = ispeed[ 1 ], ispeed[ 2 ]
    elseif isnumber( ispeed ) then
        speed_min, speed_max = ispeed, ispeed
    else
        speed_min, speed_max = 20, 20
    end

    alpha = isnumber( alpha ) and alpha or 100

    local fx_bokeh = { }

    local clr_r, clr_g, clr_b, clr_a = 255, 255, 255, alpha
    if ( amt >= 1 ) then
        local wsize, hsize = ScrW( ), ScrH( )
        for n = 1, amt do
            if IsColor( clr ) then
                clr_r, clr_g, clr_b, clr_a = clr.r, clr.g, clr.b, alpha
            elseif clr == 'random' then
                clr_r, clr_g, clr_b, clr_a = math.random( 0, 255 ), math.random( 0, 255 ), math.random( 0, 255 ), alpha
            end
            fx_bokeh[ n ] =
            {
                xpos    = math.random( 0, wsize ),
                ypos    = math.random( -hsize, hsize ),
                size    = math.random( size_min, size_max ),
                clr     = Color( clr_r, clr_g, clr_b, clr_a ),
                speed   = math.random( speed_min, speed_max ),
                area    = math.Round( math.random( -50, 150 ) ),
            }
        end
        return amt, fx_bokeh
    end
end

/*
*   design > bokeh fx
*
*   @assoc  : helper._bokehfx
*
*   @param  : int w
*   @param  : int h
*   @param  : int amt
*   @param  : tbl object
*   @param  : tbl fx
*   @param  : str selected
*   @param  : int speed
*   @param  : int offset
*/

function design:bokehfx( w, h, amt, object, fx, selected, speed, offset )
    fx = fx or helper._bokehfx
    local fx_type = fx[ selected or 'gradients' ]

    if not fx_type then return end

    speed       = speed or 30
    offset      = offset or 0

    surface.SetMaterial( Material( fx_type, 'noclamp smooth' ) )

    local count = table.Count( object )
    if count > 0 then
        for n = 1, amt do
            object[ n ].xpos = object[ n ].xpos + ( object[ n ].area * math.cos( n ) / count )
            object[ n ].ypos = object[ n ].ypos + ( math.sin( offset ) / ( speed + 10 ) + object[ n ].speed / speed )

            -- generate new fx when others go outside screen h
            if object[ n ].ypos > h then
                object[ n ].ypos = math.random( -100, 0 )
                object[ n ].xpos = math.random( 0, w )
            end
        end

        for n = 1, amt do
            local clr_r, clr_g, clr_b, clr_a = object[ n ].clr.r, object[ n ].clr.g, object[ n ].clr.b, object[ n ].clr.a
            surface.SetDrawColor( Color( clr_r, clr_g, clr_b, clr_a ) or Color( 255, 255, 255, 5 ) )
            surface.DrawTexturedRect( object[ n ].xpos, object[ n ].ypos, object[ n ].size, object[ n ].size )
        end
    end
end

/*
*   design > arc
*
*   @param  : int x
*   @param  : int y
*   @param  : int radius
*   @param  : int thickness
*   @param  : int pos_s
*   @param  : int pos_e
@   @param  : clr
*/

function design.arc( x, y, radius, thickness, pos_s, pos_e, clr )
    local cir_o     = { }
    local cir_i     = { }
    pos_s           = math.floor( pos_s )
    pos_e           = math.floor( pos_e )
    clr             = IsColor( clr ) and clr or Color( 0, 0, 0, 255 )

    if pos_s > pos_e then
        local swap  = pos_e
        pos_e       = pos_s
        pos_s       = swap
    end

    local inr = radius - thickness
    for i = pos_s, pos_e do
        local a = math.rad( i )
        table.insert( cir_i, { x = x + ( math.cos( a ) ) * inr, y = y + ( -math.sin( a ) ) * inr } )
    end

    for i = pos_s, pos_e do
        local a = math.rad( i )
        table.insert( cir_o, { x = x + ( math.cos( a ) ) * radius, y = y + ( -math.sin( a ) ) * radius } )
    end

    local comcir = { }
    for i = 0, #cir_i * 2 do
        local p, q, r
        p       = cir_o[ math.floor( i / 2 ) + 1 ]
        r       = cir_i[ math.floor( ( i + 1 ) / 2 ) + 1 ]
        if i % 2 == 0 then
            q   = cir_o[ math.floor( ( i + 1 ) / 2 ) ]
        else
            q   = cir_i[ math.floor( ( i + 1 ) / 2 ) ]
        end
        table.insert( comcir, { p, q, r } )
    end

    draw.NoTexture( )
    surface.SetDrawColor( clr )

    for k, v in ipairs( comcir ) do
        surface.DrawPoly( v )
    end

end

/*
*   design > arc > circle
*
*   @param  : int x
*   @param  : int y
*   @param  : int radius
*/

function design.arc_circle( x, y, radius )
    local cir   = { }
    local seg   = 100
    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
    for i = 0, seg do
        local a = math.rad( ( i / seg ) * -360 )
        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    end

    local a = math.rad( 0 )
    table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

    surface.DrawPoly( cir )
end

/*
*   design > arc > tri
*
*   @param  : int posx
*   @param  : int posy
*   @param  : int radius
*   @param  : int thickness
*   @param  : int roughness
@   @param  : clr
*/

function design.arc_tri( posx, posy, radius, thickness, startang, endang, roughness )
    local triarc        = { }
    local deg2rad       = math.pi / 180

    local startang, endang = startang or 0, endang or 0
    if startang < endang then
        local temp      = startang
        startang        = endang
        endang          = temp
        temp            = nil
    end

    roughness           = math.max( roughness or 1, 1 )
    local step          = roughness
    step                = math.abs( roughness ) * -1

    local inner = { }
    local r = radius - thickness
    for deg = startang, endang, step do
        local rad = deg2rad * deg
        table.insert( inner,
        {
            x = posx + ( math.sin( rad ) * r ),
            y = posy - ( math.cos( rad ) * r )
        })
    end

    local outer = { }
    for deg = startang, endang, step do
        local rad = deg2rad * deg
        table.insert( outer, {
            x = posx + ( math.sin( rad ) * radius ),
            y = posy - ( math.cos( rad ) * radius )
        })
    end

    for tri = 1, table.Count( inner ) * 2 do
        local p1, p2, p3
        p1 = outer[ math.floor( tri / 2 ) + 1 ]
        p3 = inner[ math.floor( ( tri + 1 ) / 2 ) + 1 ]
        if tri % 2 == 0 then
            p2 = outer[ math.floor( ( tri + 1 ) / 2 ) ]
        else
            p2 = inner[ math.floor( ( tri + 1 ) / 2 ) ]
        end

        table.insert( triarc, { p1, p2, p3 } )
    end

    return triarc

end

/*
*   design > arc > tri > draw poly
*/

function design.arc_drawpoly( arc )
    for k, v in ipairs( arc ) do
        surface.DrawPoly( v )
    end
end

/*
*   design > triarc > draw
*/

function design.arc_tri_draw( posx, posy, radius, thickness, startang, endang, roughness, color )
    surface.SetDrawColor( color )
    design.arc_drawpoly( design.arc_tri( posx, posy, radius, thickness, startang, endang, roughness ) )
end

/*
*   design > circle
*
*   @param  : int x
*   @param  : int y
*   @param  : int radius
*   @param  : int seg
*   @param  : clr
*/

function design.circle( x, y, radius, seg, clr )
    y           = isnumber( y ) and y or 0
    x           = isnumber( x ) and x or 0
    radius      = isnumber( radius ) and radius or 10
    seg         = isnumber( seg ) and seg or 20
    clr         = IsColor( clr ) and clr or Color( 0, 0, 0, 255 )

    local cir = { }
    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
    for i = 0, seg do
        local a = math.rad( ( i / seg ) * -360 )
        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    end

    local a = math.rad( 0 )
    table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

    surface.SetDrawColor( clr )
    draw.NoTexture( )
    surface.DrawPoly( cir )
end

/*
*   design > circle stencil
*
*   @param  : int x
*   @param  : int y
*   @param  : int radius
*   @param  : clr clr
*/

function design.circle_sten( x, y, radius, clr )
    local p     = { }
    local a     = 40
    local c     = 360
    local r     = radius

    for n = 0, a do
        p[ n + 1 ] =
        {
            x = math.sin(-math.rad( n / a * c ) ) * r + x,
            y = math.cos(-math.rad( n / a * c ) ) * r + y
        }
    end

    draw.NoTexture( )
    surface.SetDrawColor( clr )
    surface.DrawPoly( p )
end

/*
*   design > circle_t2_g
*
*   used in conjunction with ct2
*
*   @param  : int xpos
*   @param  : int ypos
*   @param  : int radius
*   @param  : int seg
*/

function design.circle_t2_g( xpos, ypos, radius, seg )
    local c     = { }
    local u     = 0.5
    local v     = 0.5
    local s     = seg
    local r     = radius

    surface.SetTexture( 0 )
    table.insert( c,
    {
        x       = xpos,
        y       = ypos,
        u       = u,
        v       = v
    })

    for n = 0, s do
        local a = math.rad( ( n / s ) * -360 )
        table.insert( c,
        {
            x   = xpos + math.sin( a ) * r,
            y   = ypos + math.cos( a ) * r,
            u   = math.sin( a ) / 2 + u,
            v   = math.cos( a ) / 2 + v
        })
    end

    local a = math.rad( 0 )
    table.insert( c,
    {
        x       = xpos + math.sin( a ) * r,
        y       = ypos + math.cos( a ) * r,
        u       = math.sin( a ) / 2 + u,
        v       = math.cos( a ) / 2 + v
    })

    return c
end

/*
*   design > circle_t2
*
*   used in conjunction with circle_t2_g
*
*   @param  : int x
*   @param  : int y
*   @param  : int radius
*   @param  : int seg
*   @param  : clr clr
*/

function design.circle_t2( x, y, radius, seg, clr )
    surface.SetDrawColor( clr or Color( 0, 0, 0, 0 ) )
    surface.DrawPoly( design.circle_t2_g( x, y, radius, seg ) )
end

/*
*   design > circle_anim_g
*
*   used in conjunction with circle_anim
*
*   @param  : int x
*   @param  : int y
*   @param  : int radius
*   @param  : int seg
*   @param  : int frac
*/

function design.circle_anim_g( x, y, radius, seg, frac )
    frac        = frac or 1
    local poly  = { }

    surface.SetTexture( 0 )
    table.insert( poly, { x = x, y = y, u = 0.5, v = 0.5 } )

    for i = 0, seg do
        local a = math.rad( ( i / seg ) * -360 * frac )
        table.insert( poly, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    end

    local a = math.rad( 0 )
    table.insert( poly, { x = x, y = y, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

    return poly
end

/*
*   design > circle_anim
*
*   used in conjunction with circle_anim_g
*
*   @note   : frac = curr / 100
*
*   @param  : int x
*   @param  : int y
*   @param  : int radius
*   @param  : int seg
*   @param  : clr clr
*   @param  : int frac
*/

function design.circle_anim( x, y, radius, seg, clr, frac )
    surface.SetDrawColor( clr or Color( 0, 0, 0, 0 ) )
    surface.DrawPoly( design.circle_anim_g( x, y, radius, seg, frac ) )
end

/*
*   design > circle > simple
*
*   draws a simple circle without performance impact
*
*   @param  : int x
*   @param  : int y
*   @param  : int radius
*   @param  : clr clr
*/

function design.circle_simple( x, y, radius, clr )
    local diam, poly    = 360, { }

    x                   = isnumber( x ) and x or 0
    y                   = isnumber( y ) and y or 0
    radius              = isnumber( radius ) and radius or 30

    for n = 1, diam do
        poly[ n ]       = { }
        poly[ n ].x     = x + math.cos( math.rad( n * diam ) / diam ) * radius
        poly[ n ].y     = y + math.sin( math.rad( n * diam ) / diam ) * radius
    end

    if clr then
        surface.SetDrawColor( clr or Color( 0, 0, 0, 255 ) )
        draw.NoTexture( )
    end

    surface.DrawPoly( poly )
end

/*
*   design > circle > simple
*
*   draws a circle with numerous layers pushing outward
*
*   @param  : int x
*   @param  : int y
*   @param  : int radius
*   @param  : clr clr
*   @param  : clr clr2
*   @param  : clr clr3
*/

function design.circle_ol( x, y, radius, clr, clr2, clr3 )
    local diam, poly, poly2, poly3 = 360, { }, { }, { }

    x                   = isnumber( x ) and x or 0
    y                   = isnumber( y ) and y or 0
    radius              = isnumber( radius ) and radius or 30

    for n = 1, diam do
        poly[ n ]       = { }
        poly[ n ].x     = x + math.cos( math.rad( n * diam ) / diam ) * radius
        poly[ n ].y     = y + math.sin( math.rad( n * diam ) / diam ) * radius
    end

    for n = 1, diam do
        poly2[ n ]      = { }
        poly2[ n ].x    = x + math.cos( math.rad( n * diam ) / diam ) * ( radius - 10 )
        poly2[ n ].y    = y + math.sin( math.rad( n * diam ) / diam ) * ( radius - 10 )
    end

    for n = 1, diam do
        poly3[ n ]      = { }
        poly3[ n ].x    = x + math.cos( math.rad( n * diam ) / diam ) * ( radius - 20 )
        poly3[ n ].y    = y + math.sin( math.rad( n * diam ) / diam ) * ( radius - 20 )
    end

    if clr then
        surface.SetDrawColor( clr )
        draw.NoTexture( )
    end

    surface.DrawPoly( poly )

    if clr2 then
        surface.SetDrawColor( clr2 )
        draw.NoTexture( )
    end

    surface.DrawPoly( poly2 )

    if clr3 then
        surface.SetDrawColor( clr3 )
        draw.NoTexture( )
    end

    surface.DrawPoly( poly3 )
end

/*
*   design > rcircle > fill
*
*   draws a filled circle using the rcir library
*
*   @param  : pnl pnl
*   @param  : clr clr
*   @param  : int rotate
*/

function design.rcir.fill( pnl, clr, rotate )
    if not pnl then return end

    clr         = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
    rotate      = isnumber( rotate ) and rotate or 0

    draw.NoTexture          (               )
    surface.SetDrawColor    ( clr           )

    pnl:SetRotation         ( rotate        )
    pnl                     (               )
end

/*
*   design > rcircle > outlined
*
*   @param  : pnl pnl
*   @param  : mat, str mat
*   @param  : clr clr
*   @param  : int rotate
*/

function design.rcir.line( pnl, mat, clr, rotate )
    if not pnl then return end

    mat         = mats:ok( mat ) and mat or nil
    clr         = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
    rotate      = isnumber( rotate ) and rotate or 0

    draw.NoTexture          (               )

    if mat then
        surface.SetMaterial ( mat           )
    end

    surface.SetDrawColor    ( clr           )
    pnl:SetRotation         ( rotate        )
    pnl                     (               )
end

/*
*   design > stencils
*/

function design.StencilStart( v )
    render.ClearStencil                 (                                   )
    render.SetStencilEnable             ( true                              )
    render.SetStencilWriteMask          ( 1                                 )
    render.SetStencilTestMask           ( 1                                 )
    render.SetStencilFailOperation      ( STENCILOPERATION_REPLACE          )
    render.SetStencilPassOperation      ( STENCILOPERATION_ZERO             )
    render.SetStencilZFailOperation     ( STENCILOPERATION_ZERO             )
    render.SetStencilCompareFunction    ( STENCILCOMPARISONFUNCTION_NEVER   )
    render.SetStencilReferenceValue     ( v or 1                            )
end

function design.StencilReplace( v )
    render.SetStencilFailOperation      ( STENCILOPERATION_ZERO             )
    render.SetStencilPassOperation      ( STENCILOPERATION_REPLACE          )
    render.SetStencilZFailOperation     ( STENCILOPERATION_ZERO             )
    render.SetStencilCompareFunction    ( STENCILCOMPARISONFUNCTION_EQUAL   )
    render.SetStencilReferenceValue     ( v or 1                            )
end

function design.StencilEnd( )
    render.SetStencilEnable             ( false                             )
end

/*
    design > notify

    displays a simple slide-in notification box that will allow players to see when something has happened.
    param 'startpos' determines pos to start from
        1   : top
        2   : bottom
        3   : middle

    [ SERVER ]

        pl:notify( 'This is a demo message', cat, startpos )

    [ CLIENT ]

        design:notify( 'This is a demo message', cat, startpos )

    @param  : int cat
    @param  : str msg
    @param  : int startpos
*/

function design:notify( msg, cat, startpos )
    msg                             = ( helper.ok.str( msg ) and msg ) or 'Error occured'
    cat                             = cat or 1
    startpos                        = ( isnumber( startpos ) and startpos ) or 1
    local dur                       = 10

    /*
        dispatch
    */

    ui:dispatch( base.notify )

    /*
        declare > fonts
    */

    local fnt_text                  = pref( 'design_notify_msg' )

    /*
        declare > colors
    */

    local clr_box_ol                = rclr.Hex( '000000', 255 )
    local clr_box_n                 = base._def.lc_rgb[ cat ] or rclr.Hex( '1E1E1E' )
    local clr_txt                   = rclr.Hex( 'FFFFFF' )

    /*
        declare > sizes
    */

    local ui_w, ui_h                = ScrW( ), draw.GetFontHeight( fnt_text ) + 18
    local sz_w, sz_h                = helper.str:len( msg, fnt_text )
    sz_w                            = sz_w + 100

    local pos_w                     = ( ui_w / 2 ) - ( sz_w / 2 )
    local pos_h                     = ( startpos == 2 and ( ScrH( ) - ui_h ) ) or ( startpos == 3 and ScrH( ) * 0.25 ) or 5
    local pos_m2                    = ( startpos == 2 and ( ScrH( ) ) ) or ( startpos == 3 and d ) or -ui_h

    /*
        object
    */

    local obj                       = ui.new( 'btn'                         )
    :bsetup                         (                                       )
    :size                           ( sz_w, ui_h                            )
    :pos                            ( pos_w, pos_h                          )
    :aligntop                       ( pos_m2                                )
    :textadv                        ( clr_txt, fnt_text, msg                )
    :drawtop                        ( true                                  )

                                    :oc( function ( s )
                                        if s.action_close then return end
                                        s.action_close = true
                                        s:Stop( )
                                        s:MoveTo( pos_w, pos_m2, 0.5, 0, -1, function( )
                                            ui:dispatch( s )
                                        end )
                                    end )

                                    :draw( function( s, w, h )
                                        local pulse     = math.abs( math.sin( CurTime( ) * 2 ) * 255 )
                                        pulse           = math.Clamp( pulse, 125, 255 )

                                        design.box( 3, 2, w - 6, h - 4, clr_box_ol )
                                        design.box( 4, 3, w - 8, h - 6, ColorAlpha( clr_box_n, pulse ) )
                                    end )

                                    :logic( function( s )
                                        s:SetZPos( 5000 )
                                    end )

    /*
        notice sound
    */

    surface.PlaySound( cfg.dialogs.audio )

    /*
        display notice
    */

    if ui:ok( obj ) then
        base.notify = obj

        obj:MoveTo( pos_w, pos_h, 0.5, 0, -1, function( )
            obj:MoveTo( pos_w, pos_m2, 0.5, dur, -1, function( )
                ui:dispatch( obj )
            end )
        end )
    end
end

/*
    design > notify > nms

    an advanced notification feature which displays a msg on-screen with borders on top and bottom
    has the ability to hold TAB in order to close out the notification before the destroy timer actually
    expires.

    will temp disable the scoreboard while active so that the KEY_TAB actually closes the notification
    instead of toggling the scoreboard. this however wont be needed if the server owner decides to change
    the key to something else besides the default tab key

    [ SERVER ]

        pl:nms( 'This is a demo message', 'Title','icon or *' )

    [ CLIENT ]

        design:nms( 'This is a demo message', 'Title', 'icon or *' )

    @param  : str msg
    @param  : str title
    @param  : str ico
*/

function design:nms( msg, title, ico )
    msg                     = msg or 'Error Occured'
    title                   = helper.str:ok( title ) and title or 'Notice'
    ico                     = helper.str:ok( ico ) and ico or ''

    local timer_id          = string.format( '%snotice.timer', pf )

    timex.expire( timer_id )

    /*
        localized vars
    */

    local dur                       = 8
    local i_fadein	                = 1             -- time to fade in
    local i_fadeout	                = 0.5           -- time to fade out
    local alpha			            = 255           -- starting alpha
    local start			            = CurTime( )    -- start time
    local m_ctime                   = CurTime( )
    local dtime			            = 0
    local key_close 	            = input.GetKeyName( KEY_TAB )

    /*
        materials
    */

    local m_grad                    = Material( cfg.dialogs.mat_gradient or 'gui/center_gradient' )

    /*
        fonts
    */

    local fnt_name                  = pref( 'design_nms_name' )
    local fnt_msg                   = pref( 'design_nms_msg' )
    local fnt_ico                   = pref( 'design_nms_ico' )
    local fnt_qclose                = pref( 'design_nms_qclose' )

    /*
        colors
    */

    local clr_txt                   = cfg.dialogs.clrs.primary_text
    local clr_pri                   = cfg.dialogs.clrs.primary
    local clr_sec                   = cfg.dialogs.clrs.secondary
    local clr_prog                  = cfg.dialogs.clrs.progress
    local clr_icon                  = cfg.dialogs.clrs.icons

    /*
        logic

        check to see if notice panel is valid and that binded cancel key is pressed. if both are true,
        kill timers, hooks, and the panel to cancel the entire active notice action
    */

    hook.Add( 'Think', pf .. 'design.key.cancel', function( )
        if input.IsKeyDown( KEY_TAB ) and ui:visible( ui.nms ) then
            timex.expire( timer_id )
            hook.Remove( 'Think', pf .. 'design.key.cancel' )
            hook.Remove( 'ScoreboardShow', pf .. 'design.key.cancel.scoreboard' )
            ui:dispatch( ui.nms )
        end
    end )

    /*
        scoreboardshow

        while a dialog is active, disallow the scoreboard from showing when the default cancel key
        is pressed ( KEY_TAB ). once the action has completed, return the scoreboard functionality back
        to normal.

        this hook isnt needed if the server owner changes the default keybind to any other key besides
        the default one ENUM:( KEY_TAB )
    */

    hook.Add( 'ScoreboardShow', pf .. 'design.key.cancel.scoreboard', function( )
        if ui:ok( ui.nms ) and input.IsKeyDown( KEY_TAB ) then
            return false
        end
        return true
    end )

    /*
        draw to screen
    */

    local function draw2screen( )
        ui:dispatch( ui.nms )

        ui.nms                      = ui.new( 'pnl'                         )
        :sz                         ( ScrW( ), ScrH( )                      )
        :pos                        ( 0                                     )
        :m2f                        (                                       )
        :popup                      (                                       )

                                    :draw( function( s, w, h )
                                        dur = math.Clamp( dur, 0, dur )
                                        dtime = CurTime( ) - start
                                        if alpha < 0 then
                                            alpha = 0
                                        end

                                        -- fade in math
                                        if i_fadein - dtime > 0 then
                                            alpha = ( i_fadein - dtime ) / i_fadein -- 0 to 1
                                            alpha = 1 - alpha -- Reverse
                                            alpha = alpha * 255
                                        end

                                        -- fade out math
                                        if dur - dtime < i_fadeout then
                                            alpha = ( dur - dtime ) / i_fadeout + i_fadeout -- 0 to 1
                                            alpha = alpha * 255
                                        end

                                        local c_alpha           = math.Clamp( alpha, 0, 255 )
                                        local c_alpha_box       = math.Clamp( alpha, 0, 255 )
                                        local c_alpha_obox      = math.Clamp( alpha, 0, 100 )
                                        local grad_w, grad_h    = w * 0.70, 100

                                        design.mat( w / 2 - ( grad_w / 2 ), h / 2 - ( grad_h / 2 ), grad_w, grad_h, m_grad, ColorAlpha( clr_pri, c_alpha ) )

                                        -- top and bottom primary rect
                                        design.box( 0, 0, w, h * .10, ColorAlpha( clr_pri, c_alpha_box ) )
                                        design.box( 0, h - h * .10, w, h * .10, ColorAlpha( clr_pri, c_alpha_box ) )

                                        -- 10% rect on edge of primary boxes
                                        local brder_h = 4
                                        design.box( 0, h * .10 - brder_h, w, brder_h, ColorAlpha( clr_sec, c_alpha_obox ) )
                                        design.box( 0, h - h * .10, w, brder_h, ColorAlpha( clr_sec, c_alpha_obox ) )

                                        -- icons
                                        if ico then
                                            draw.DrawText( ico, fnt_ico, w / 2, ( h / 2 ) - grad_h - 25, ColorAlpha( clr_icon, c_alpha ) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                        end

                                        -- text
                                        design.txt( title, w / 2, h / 2 - 19, ColorAlpha( clr_txt, c_alpha ), fnt_name, 1, 1 )
                                        design.txt( msg, w / 2, h / 2 + 19, ColorAlpha( clr_txt, c_alpha ), fnt_msg, 1, 1 )
                                        design.txt( ln( 'dialog_key_close', key_close ), w / 2, h - h * .10 / 2 + 15, ColorAlpha( clr_txt, c_alpha ), fnt_qclose, 1, 1 )

                                        local time          = math.Remap( CurTime( ) - m_ctime, 0, dur, w, 0 )
                                        local blk_w         = time * 0.20
                                        local blk_center    = w / 2 - ( blk_w / 2 )

                                        design.box( blk_center, h - h * .10 / 2 - 10, blk_w, 10, ColorAlpha( clr_prog, c_alpha ) )
                                    end )

    end
    draw2screen( )

    /*
        sound
    */

    surface.PlaySound( cfg.dialogs.audio )

    /*
        destroy hudpaint hook when timer has elapsed

        @param  : bool bForce
    */

    local function destroy_timer( bForce )
        if timex.exists( timer_id ) and not bForce then return end
        timex.create( timer_id, dur + 1, 1, function( )
            timex.expire( timer_id )
            hook.Remove( 'Think', pf .. 'design.key.cancel' )
            hook.Remove( 'ScoreboardShow', pf .. 'design.key.cancel.scoreboard' )
            ui:dispatch( ui.nms )
        end )
    end
    destroy_timer( )

end

/*
    design > bubble

    displays a simple bubble notification to the lower right.
    uses string for message.

    see rbubble for richtext version

    @param  : str msg
    @param  : int dur
    @param  : clr clr_box
    @param  : clr clr_txt
*/

function design:bubble( msg, dur, clr_box, clr_txt )

    /*
    *   destroy existing
    */

    ui:dispatch( base.bubble )

    /*
    *   check
    */

    if not msg then return end

    /*
        declare > fonts
    */

    local fnt_msg                   = pref( 'design_bubble_msg' )

    /*
    *   message cropping and length
    */

    local m_diag                    = Material( 'rlib/general/patterns/diag_w.png', 'smooth noclamp' )
    local message                   = helper.str:crop( msg, ui:cscale( true, 210, 240, 250, 240, 250, 250, 260 ), fnt_msg )
    local text_w, text_h            = helper.str:len( message, fnt_msg )

    dur                             = isnumber( dur ) and dur or 8
    clr_box                         = IsColor( clr_box ) and clr_box or Color( 20, 20, 20, 255 )
    clr_txt                         = IsColor( clr_txt ) and clr_txt or Color( 255, 255, 255, 255 )

    local pos_w, pos_h              = text_w + 155, 20 + text_h + 15
    pos_w                           = math.Clamp( pos_w, 150, 330 )

    /*
    *   obj > btn
    */

    local obj                       = ui.new( 'btn'                         )
    :bsetup                         (                                       )
    :size                           ( pos_w, pos_h                          )
    :pos                            ( ScrW( ) - pos_w - 5, ScrH( ) + pos_h  )
    :textadv                        ( clr_txt, fnt_msg, ''                  )
    :drawtop                        ( true                                  )
    :box                            ( Color( 45, 45, 45, 255 )              )
    :keeptop                        (                                       )
    :drawtop                        ( true                                  )
    :focustop                       ( true                                  )

    /*
    *   obj > bg
    */

    local sub                       = ui.new( 'pnl', obj                    )
    :nodraw                         (                                       )
    :fill                           ( 'm', 1                                )

                                    :draw( function( s, w, h )
                                        design.box( 0, 0, w, h, Color( 25, 25, 25, 255 ))
                                        design.imat( 0, 0, w, h * 1, m_diag, Color( 125, 125, 125, 1 ) )
                                    end )

    /*
    *   obj > body
    */

    local body                      = ui.new( 'btn', sub                    )
    :bsetup                         (                                       )
    :fill                           ( 'm', 0                                )

                                    :draw( function( s, w, h )
                                        draw.DrawText( message, fnt_msg, 65, ( h / 2 ) - ( text_h / 2 ), clr_txt , TEXT_ALIGN_LEFT )
                                    end )

                                    surface.SetFont( pref( 'design_bubble_ico' ) )
    local ico_w, ico_h              = surface.GetTextSize( utf8.char( 9873 ) )

    /*
    *   obj > btn > icon
    */

    local ico                       = ui.new( 'btn', body                   )
    :left                           ( 'm', 7, 0, 0, 0                       )
    :wide                           ( 50                                    )
    :notext                         (                                       )

                                    :draw( function( s, w, h )
                                        local i_pulse       = math.abs( math.sin( CurTime( ) * 3 ) * 255 )
                                        i_pulse			    = math.Clamp( i_pulse, 30, 255 )

                                        draw.DrawText( utf8.char( 10070 ), pref( 'design_bubble_ico' ), w / 2, ( obj:GetTall( ) / 2 ) - ( ico_h / 2 ) - 2, Color( 255, 255, 255, i_pulse ) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
    *   obj > btn > overlay
    */

    local b_ol                      = ui.new( 'btn', body                   )
    :bsetup                         (                                       )
    :fill                           ( 'm', 0                                )

                                    :oc( function ( s )
                                        if obj.action_close then return end
                                        obj.action_close = true
                                        obj:Stop( )
                                        obj:MoveTo( ScrW( ) - obj:GetWide( ) - 5, ScrH( ) + obj:GetTall( ) + 5, 0.5, 0, -1, function( )
                                            ui:dispatch( obj )
                                        end )
                                    end )

    /*
    *  display notice
    */

    if ui:ok( obj ) then
        base.bubble = obj

        obj:MoveTo( ScrW( ) - obj:GetWide( ) - 5, ScrH( ) - obj:GetTall( ) - 5, 0.5, 0, -1, function( )
            obj:MoveTo( ScrW( ) - obj:GetWide( ) - 5, ScrH( ) + obj:GetTall( ) + 5, 0.5, dur, -1, function( )
                ui:dispatch( obj )
            end )
        end )
    end

end

/*
    design > bubble > rich

    displays a bubble notification to the lower right.
    uses table for message.

    see bubble for standard version

    @param  : tbk msg
    @param  : clr clr_box
    @param  : clr clr_txt
*/

function design:rbubble( msg_a, clr_box, clr_txt )

    /*
        destroy existing
    */

    ui:dispatch( base.bubble )

    /*
        check
    */

    if not istable( msg_a ) then return end

    /*
        merge string values
    */

    local msg, i = '', 0
    for k, v in pairs( msg_a ) do
        if isstring( v ) then
            if i == 0 then
                msg = v
            else
                msg = msg .. v
            end
            i = i + 1
        end
    end

    /*
        define > message dimensions
    */

    local m_diag                    = mat2d( 'rlib/general/patterns/diag_w.png' )
    local message                   = helper.str:crop( msg, ui:cscale( true, 210, 240, 250, 240, 250, 250, 260 ), pref( 'design_bubble_msg_2' ) )
    local text_w, text_h            = helper.str:len( message, pref( 'design_bubble_msg_2' ) )

    local pos_w, pos_h              = text_w + 155, 20 + text_h + 15
    pos_w                           = math.Clamp( pos_w, 150, 330 )

    local dur                       = 8

    /*
        obj > btn
    */

    local obj                       = ui.new( 'btn'                         )
    :bsetup                         (                                       )
    :size                           ( pos_w, pos_h                          )
    :pos                            ( ScrW( ) - pos_w - 5, ScrH( ) + pos_h  )
    :textadv                        ( clr_txt, pref( 'design_bubble_msg_2' ), '' )
    :drawtop                        ( true                                  )
    :box                            ( Color( 45, 45, 45, 255 )              )
    :keeptop                        (                                       )
    :drawtop                        ( true                                  )
    :focustop                       ( true                                  )

    /*
        obj > bg
    */

    local bg                        = ui.new( 'dhtml', obj                  )
    :nodraw                         (                                       )
    :fill                           ( 'm', 1                                )
    :sbar                           ( false                                 )

    /*
        obj > sub
    */

    local sub                       = ui.new( 'pnl', bg                     )
    :fill                           ( 'm', 0                                )

                                    :draw( function( s, w, h )
                                        design.box( 0, 0, w, h, Color( 25, 25, 25, 255 ))
                                        design.imat( 0, 0, w, h * 2, m_diag, Color( 125, 125, 125, 1 ) )
                                    end )

    /*
        obj > get icon size
    */

                                    surface.SetFont( pref( 'design_bubble_ico' ) )
    local ico_w, ico_h              = surface.GetTextSize( utf8.char( 9873 ) )

    /*
        obj > btn > icon
    */

    local ico                       = ui.new( 'btn', sub                    )
    :left                           ( 'm', 7, 0, 7, 0                       )
    :wide                           ( 50                                    )
    :notext                         (                                       )

                                    :draw( function( s, w, h )
                                        local i_pulse       = math.abs( math.sin( CurTime( ) * 3 ) * 255 )
                                        i_pulse			    = math.Clamp( i_pulse, 30, 255 )

                                        draw.DrawText( utf8.char( 10070 ), pref( 'design_bubble_ico' ), w / 2, ( obj:GetTall( ) / 2 ) - ( ico_h / 2 ) - 2, Color( 255, 255, 255, i_pulse ) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
        obj > body
    */

    local body                      = ui.new( 'rtxt', sub                   )
    :fill                           ( 'm', 0, 15, 0, 0                      )
    :align                          ( 5                                     )
    :vsbar                          ( false                                 )
    :mline                          ( true                                  )
    :appendclr                      ( Color( 255, 255, 255, 255 )           )

                                    :pl( function( s )
                                        s:SetFontInternal( pref( 'design_bubble_msg_2' ) )
                                    end )

    /*
        obj > determine string and color keys
    */

    for k, v in pairs( msg_a ) do
        if IsColor( v ) then
            body:InsertColorChange( v.r, v.g, v.b, v.a  )
        elseif isstring( v ) then
            body:AppendText( v )
        end
    end

    /*
        obj > btn > overlay
    */

    local b_ol                      = ui.new( 'btn', body                   )
    :bsetup                         (                                       )
    :fill                           ( 'm', 0                                )

                                    :oc( function ( s )
                                        if obj.action_close then return end
                                        obj.action_close = true
                                        obj:Stop( )
                                        obj:MoveTo( ScrW( ) - obj:GetWide( ) - 5, ScrH( ) + obj:GetTall( ) + 5, 0.5, 0, -1, function( )
                                            ui:dispatch( obj )
                                        end )
                                    end )

    /*
        display notice
    */

    if ui:ok( obj ) then
        base.bubble = obj

        obj:MoveTo( ScrW( ) - obj:GetWide( ) - 5, ScrH( ) - obj:GetTall( ) - 5, 0.5, 0, -1, function( )
            obj:MoveTo( ScrW( ) - obj:GetWide( ) - 5, ScrH( ) + obj:GetTall( ) + 5, 0.5, dur, -1, function( )
                ui:dispatch( obj )
            end )
        end )
    end
end

/*
    design > push

    notification system that displays on the bottom right with icon

    [ SERVER ]

        local msg = { 'This is a demo message' }
        pl:push( msg, 'Demo Notification', 'icon or *' )

    [ CLIENT ]

        local msg = { 'This is a demo message' }
        design:push( msg, 'Demo Notification', 'icon or *' )

    @param  : tbl msgtbl
    @param  : str title
    @param  : str ico
    @param  : clr clr_title
    @param  : clr clr_box
*/

function design:push( msgtbl, title, ico, clr_title, clr_box )
    msgtbl                  = msgtbl or { 'Error Occured' }
    title                   = helper.str:ok( title ) and title or 'Notice'
    ico                     = helper.str:ok( ico ) and ico or ''

    /*
        destroy existing
    */

    base.push               = istable( base.push ) and base.push or { }

    /*
        merge string values
    */

    local msg, i = '', 0
    if istable( msgtbl ) then
        for k, v in pairs( msgtbl ) do
            if isstring( v ) then
                if i == 0 then
                    msg = v
                else
                    msg = msg .. v
                end
                i = i + 1
            end
        end
    else
        msg, i = msgtbl, 2
    end

    /*
        fonts
    */

    local fn_title                  = pref( 'design_push_name' )
    local fn_msg                    = pref( 'design_push_msg' )
    local fn_ico                    = pref( 'design_push_ico' )

    /*
        define > message dimensions
    */

    local _t, _t_li                 = helper.str:crop( title, 300, fn_title )
    local hdr_w, hdr_h              = helper.str:len( _t, fn_title )
    local fnt_w, fnt_h              = helper.str:len( ico, fn_ico )

    local _m, _m_li                 = helper.str:crop( msg, 290, fn_msg )
    local msg_w, msg_h              = helper.str:len( _m, fn_msg )

    local sz_w, sz_h                = 400, 20 + msg_h + hdr_h + 5
    local dur                       = 8

    clr_title                       = IsColor( clr_title ) and clr_title or Color( 46, 163, 67, 255 )


    /*
        obj > btn
    */

    local obj                       = ui.new( 'btn'                         )
    :bsetup                         (                                       )
    :size                           ( sz_w, sz_h                            )
    :drawtop                        ( true                                  )
    :keeptop                        (                                       )
    :drawtop                        ( true                                  )
    :focustop                       ( true                                  )

    /*
        obj > sub
    */

    local sub                       = ui.new( 'pnl', obj                    )
    :fill                           ( 'm', 0                                )

                                    :draw( function( s, w, h )
                                        design.rbox( 6, 0, 0, w, h, Color( 25, 25, 25, 255 ) )
                                        design.rbox( 6, 4, 4, w - 8, h - 8, Color( 29, 29, 29, 255 ))
                                    end )

    /*
        icon
    */

    local b_ico                     = ui.new( 'btn', sub                    )
    :left                           ( 'm', 9, 0, 7, 0                       )
    :wide                           ( 64                                    )
    :notext                         (                                       )

                                    :draw( function( s, w, h )
                                        local clr_a     = math.abs( math.sin( CurTime( ) * 3 ) * 255 )
                                        clr_a		    = math.Clamp( clr_a, 100, 255 )

                                        draw.DrawText( ico, fn_ico, w / 2, ( h / 2 ) - ( fnt_h / 2 ), Color( 100, 100, 100, clr_a ) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
        obj > title
    */

    local hdr_sub                   = ui.new( 'pnl', sub                    )
    :top                            ( 'm', 1, 9, 0, 0                       )
    :tall                           ( hdr_h                                 )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( title, fn_title, 0, h / 2, clr_title, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

    /*
        obj > body
    */

    local body                      = ui.new( 'rtxt', sub                   )
    :fill                           ( 'm', 0, 1, 14, 0                      )
    :align                          ( 4                                     )
    :vsbar                          ( false                                 )
    :mline                          ( true                                  )
    :appendclr                      ( Color( 255, 255, 255, 255 )           )

                                    :pl( function( s )
                                        s:SetFontInternal( fn_msg )
                                    end )

    /*
        obj > determine string and color keys
    */

    if istable( msgtbl ) then
        for k, v in pairs( msgtbl ) do
            local asd = helper:clr_ishex( v )
            if IsColor( v ) then
                body:InsertColorChange( v.r, v.g, v.b, v.a  )
            elseif helper:clr_ishex( v ) then
                local clr = rclr.Hex( v )
                body:InsertColorChange( clr.r, clr.g, clr.b, clr.a  )
            elseif isstring( v ) and v ~= '\n' and not helper:clr_ishex( v ) then
                local txt = v .. ' '
                body:AppendText( txt )
            elseif v == '\n' then
                local txt = v
                body:AppendText( txt )
            end
        end
    else
        body:AppendText( msgtbl )
    end

    /*
        obj > btn > overlay
    */

    local b_ol                      = ui.new( 'btn', obj                    )
    :bsetup                         (                                       )
    :fill                           ( 'm', 0                                )

                                    :draw( function( s, w, h )
                                        if s.hover then
                                            design.box( 0, 0, w, h, Color( 0, 0, 0, 100 ) )
                                        end
                                    end )

                                    :oc( function ( s )
                                        if obj.action_close then return end
                                        obj.action_close = true
                                        obj:Stop( )
                                        obj:MoveTo( ScrW( ) - obj:GetWide( ) - 5, ScrH( ) + obj:GetTall( ) + 5, 0.5, 0, -1, function( )
                                            ui:dispatch( obj )
                                        end )
                                    end )

    /*
        display notice
    */

    if ui:ok( obj ) then
        local where, pos            = loc_slot_push( obj )

        if ( where and where > 8 ) or not where then
            ui:dispatch( obj )
            return
        end

        /*
            height padding
        */

        obj:SetPos                  ( ScrW( ), pos                )
        obj:MoveTo                  ( ScrW( ) - obj:GetWide( ) - 30, pos, 0.5, 0, -1, function( )
                                        base.push[ where ] = obj
                                        obj:MoveTo( ScrW( ), pos, 0.5, dur, -1, function( )
                                            ui:dispatch( obj )
                                        end )
                                    end )
    end

end

/*
    design > sos

    notification system that displays on the bottom right with icon

    [ SERVER ]

        local msg = { 'This is a demo message' }
        pl:sos( msg, 'Demo Notification', 'icon or *' )

    [ CLIENT ]

        local msg = { 'This is a demo message' }
        design:sos( msg, 'Demo Notification', 'icon or *' )

    @param  : tbl msgtbl
    @param  : str title
    @param  : str ico
    @param  : int dur
*/

function design:sos( msgtbl, title, ico, dur )
    msgtbl                  = istable( msgtbl ) and msgtbl or { 'Error Occured' }
    title                   = helper.str:ok( title ) and title or 'Notice'
    ico                     = helper.str:ok( ico ) and ico or ''
    dur                     = isnumber( dur ) and dur or 10

    /*
        check
    */

    if not istable( msgtbl ) then return end

    /*
        destroy existing
    */

    base.sos                        = istable( base.sos ) and base.sos or { }

    /*
        merge string values
    */

    local msg, i = '', 0
    for k, v in pairs( msgtbl ) do
        if isstring( v ) then
            if i == 0 then
                msg = v
            else
                msg = msg .. v
            end
            i = i + 1
        end
    end

    /*
        fonts
    */

    local fn_title                  = pref( 'design_sos_name' )
    local fn_msg                    = pref( 'design_sos_msg' )
    local fn_ico                    = pref( 'design_sos_ico' )

    /*
        define > message dimensions
    */

    local _t, _t_li                 = helper.str:crop( title, 300, fn_title )
    local hdr_w, hdr_h              = helper.str:len( _t, fn_title )
    local fnt_w, fnt_h              = helper.str:len( ico, fn_ico )

    local _m, _m_li                 = helper.str:crop( msg, 290, fn_msg )
    local msg_w, msg_h              = helper.str:len( _m, fn_msg )
    local sz_w, sz_h                = 400, msg_h + hdr_h + 20

    /*
        colors
    */

    local clr_box_ol                = rclr.Hex( '191919' )
    local clr_box_in                = rclr.Hex( '1D1D1D' )
    local clr_box_h                 = rclr.Hex( '000000', 100 )
    local clr_txt_title             = rclr.Hex( 'E8B78E' )

    /*
        obj > btn
    */

    local obj                       = ui.new( 'btn'                         )
    :bsetup                         (                                       )
    :size                           ( sz_w, sz_h                            )
    :drawtop                        ( true                                  )
    :keeptop                        (                                       )
    :drawtop                        ( true                                  )
    :focustop                       ( true                                  )

    /*
        obj > sub
    */

    local sub                       = ui.new( 'pnl', obj                    )
    :fill                           ( 'm', 0                                )

                                    :draw( function( s, w, h )
                                        design.rbox( 8, 0, 0, w, h, clr_box_ol )
                                        design.rbox( 8, 4, 4, w - 8, h - 8, clr_box_in )
                                    end )

    /*
        icon
    */

    local b_ico                     = ui.new( 'btn', sub                    )
    :bsetup                         (                                       )
    :left                           ( 'm', 9, 0, 7, 0                       )
    :wide                           ( 64                                    )

                                    :draw( function( s, w, h )
                                        local clr_a     = math.abs( math.sin( CurTime( ) * 3 ) * 255 )
                                        clr_a		    = math.Clamp( clr_a, 100, 255 )

                                        draw.DrawText( ico, fn_ico, w / 2, ( h / 2 ) - ( fnt_h / 2 ), Color( 100, 100, 100, clr_a ) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
        obj > title
    */

    local hdr_sub                   = ui.new( 'pnl', sub                    )
    :top                            ( 'm', 1, 9, 0, 0                       )
    :tall                           ( hdr_h                                 )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( title, fn_title, 0, h / 2, clr_txt_title, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

    /*
        obj > body
    */

    local body                      = ui.new( 'rtxt', sub                   )
    :fill                           ( 'm', 0, 1, 14, 0                      )
    :align                          ( 4                                     )
    :vsbar                          ( false                                 )
    :mline                          ( true                                  )
    :appendclr                      ( Color( 255, 255, 255, 255 )           )

                                    :pl( function( s )
                                        s:SetFontInternal( fn_msg )
                                    end )

    /*
        obj > determine string and color keys
    */

    for k, v in pairs( msgtbl ) do
        if IsColor( v ) then
            body:InsertColorChange( v.r, v.g, v.b, v.a  )
        elseif isstring( v ) and v ~= '\n' then
            local txt = v .. ' '
            body:AppendText( txt )
        elseif v == '\n' then
            local txt = v
            body:AppendText( txt )
        end
    end

    /*
        obj > btn > overlay
    */

    local b_ol                      = ui.new( 'btn', obj                    )
    :bsetup                         (                                       )
    :fill                           ( 'm', 0                                )

                                    :draw( function( s, w, h )
                                        if s.hover then
                                            design.box( 0, 0, w, h, clr_box_h )
                                        end
                                    end )

                                    :oc( function ( s )
                                        if obj.action_close then return end
                                        obj.action_close = true
                                        obj:Stop( )
                                        obj:MoveTo( ScrW( ) - obj:GetWide( ) - 5, ScrH( ) + obj:GetTall( ) + 5, 0.5, 0, -1, function( )
                                            ui:dispatch( obj )
                                        end )
                                    end )

    /*
        display notice
    */

    if ui:ok( obj ) then
        local where, pos            = loc_slot_sos( obj )

        if ( where and where > 8 ) or not where then
            ui:dispatch( obj )
            return
        end

        /*
            height padding
        */

        obj:SetPos                  ( ( ScrW( ) / 2 ) - ( sz_w / 2 ), -sz_h             )
        obj:MoveTo                  ( ( ScrW( ) / 2 ) - ( sz_w / 2 ), pos, 0.5, 0, -1, function( )
                                        base.sos[ where ] = obj
                                        obj:MoveTo( ( ScrW( ) / 2 ) - ( sz_w / 2 ), -sz_h, 0.5, dur, -1, function( )
                                            ui:dispatch( obj )
                                        end )
                                    end )
    end

end

/*
*   design > notify > inform ( slider )
*
*   displays a notification that slides in from the right; shows for a set duration, and then
*   slides back out to the right
*
*   @call   : design:inform( 1, 'example msg', 'mytitle', 5 )
*
*   @param  : int, str, tbl, clr mtype
*   @param  : str msg
*   @param  : str title
*   @param  : int dur
*/

function design:inform( mtype, msg, title, dur )

    /*
    *   destroy existing
    */

    ui:dispatch( base.notify )

    /*
    *   mtype colorization
    */

    local clr_box, clr_txt          = Color( 30, 30, 30, 255 ), Color( 255, 255, 255, 255 )
    if mtype and mtype ~= 'def' then
        if IsColor( mtype ) then
            clr_box                 = mtype
        elseif isnumber( mtype ) then
            clr_box                 = base._def.lc_rgb[ mtype ]
        elseif istable( mtype ) and not IsColor( mtype ) then
            clr_box                 = mtype.clr_box or Color( 30, 30, 30, 255 )
            clr_txt                 = mtype.clr_txt or Color( 255, 255, 255, 255 )
        end
    end

    /*
    *   check > msg
    */

    if not msg then
        mtype, msg = 2, 'an error occured'
    end

    local font_id                   = pref( 'design_dialog_sli_msg' ) or 'Default'
    title                           = isstring( title ) and title or ln( 'notify_title_def' )
    dur                             = isnumber( dur ) and dur or 10

    local message                   = helper.str:crop( msg, ui:cscale( true, 220, 250, 260, 250, 260, 260, 270 ), font_id )
    local text_w, text_h            = helper.str:len( message, font_id )
    local m_ctime                   = CurTime( )

    local pos_w, pos_h              = text_w + 120, 50 + text_h + 15
    pos_w                           = math.Clamp( pos_w, 150, 300 )

    /*
    *   pnl > sub
    */

    local obj                       = ui.new( 'pnl'                         )
    :size                           ( pos_w, pos_h                          )
    :pos                            ( ScrW( ), 200                          )
    :drawtop                        ( true                                  )

                                    :draw( function( s, w, h )
                                        design.box( 0, 0, w, h, Color( 35, 35, 35, 255 ) )
                                    end )

    /*
    *   pnl > header
    */

    local hdr                       = ui.new( 'pnl', obj                    )
    :top                            ( 'm', 7, 0, 0, 0                       )
    :margin                         ( 0                                     )
    :tall                           ( 30                                    )

                                    :draw( function( s, w, h )
                                        design.box( 0, 0, w, h, Color( 206, 129, 28, 150 ) )
                                    end )

    /*
    *   pnl > header > sub
    */

    local hdr_sub                   = ui.new( 'pnl', hdr                    )
    :fill                           ( 'm', 0, 0, 6, 0                       )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( title, pref( 'design_dialog_sli_title' ), w / 2 - 5, 30 / 2 + 1, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
    *   btn > close
    */

    local b_close                   = ui.new( 'btn', hdr_sub                )
    :bsetup                         (                                       )
    :right                          ( 'm', 5                                )
    :size                           ( 21                                    )
    :onhover                        (                                       )
    :textadv                        ( Color( 255, 255, 255, 255 ), pref( 'design_dialog_sli_x' ), helper.get:utf8( 'close' ) )

                                    :draw( function( s, w, h )
                                        if s.hover then
                                            s:SetTextColor( Color( 25, 25, 25, 255 ) )
                                        end
                                    end )

                                    :oc( function ( s )
                                        gui.EnableScreenClicker( false )
                                        ui:dispatch( obj )
                                    end )

    /*
    *   pnl > body
    */

    local body                      = ui.new( 'pnl', obj                    )
    :nodraw                         (                                       )
    :fill                           ( 'm', 0                                )

    /*
    *   pnl > body > sub
    */

    local body_i                    = ui.new( 'pnl', body                   )
    :nodraw                         (                                       )
    :fill                           ( 'm', 0                                )

    /*
    *   lbl > msg
    */

    local contents                  = ui.new( 'lbl', body_i                 )
    :fill                           ( 'm', 0, 3, 0                          )
    :notext                         (                                       )
    :align                          ( 5                                     )

                                    :draw( function( s, w, h )
                                        draw.DrawText( message, font_id, s:GetWide( ) / 2, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
                                    end )

    /*
    *   pnl > ftr
    */

    local ftr                       = ui.new( 'pnl', obj                    )
    :nodraw                         (                                       )
    :bottom                         ( 'm', 0                                )
    :tall                           ( 6                                     )

                                    :draw( function( s, w, h )
                                        local time          = math.Remap( CurTime( ) - m_ctime, 0, dur, w, 0 )
                                        local blk_w         = time * 1
                                        local blk_center    = w / 2 - ( blk_w / 2 )
                                        local clr_prog      = cfg.dialogs.clrs.progress

                                        design.box( blk_center, h - h * .10 / 2 - 10, blk_w, 10, clr_prog )
                                    end )

    /*
    *  notice sound
    */

    surface.PlaySound( cfg.dialogs.audio )

    /*
    *  display notice
    */

    if ui:ok( obj ) then
        base.notify = obj

        obj:MoveTo( ScrW( ) - obj:GetWide( ) - 5, 200, 0.5, 0, -1, function( )
            obj:MoveTo( ScrW( ), 200, 0.5, dur, -1, function( )
                ui:dispatch( obj )
            end )
        end )
    end

end

/*
    design > restart
*/

function design:restart( msg )

    /*
        dispatch existing
    */

    ui:dispatch( base.restart )

    /*
        declare
    */

    msg                     = helper.ok.str( msg ) or ln( 'rs_in' )
    local sz_w              = RSW( ) * 0.10
    local sz_h              = RSH( ) * 0.10
    local sz_txt_h          = helper.str:lenH( msg, pref( 'design_rs_title' ), 10 )

    /*
        declare > colors
    */

    local clr_box_ol        = rclr.Hex( '282828' )
    local clr_box_n         = rclr.Hex( '232323' )
    local clr_header        = rclr.Hex( 'E06B6B' )
    local clr_img           = rclr.Hex( 'FFFFFF', 1 )
    local clr_txt_cntdown   = rclr.Hex( 'FFFFFF' )

    /*
        parent
    */

    local obj                       = ui.new( 'pnl'                         )
    :size                           ( sz_w, sz_h                            )
    :pos                            ( ScrW( ) / 2 - ( sz_w / 2 ), -sz_h     )
    :drawtop                        ( true                                  )

                                    :draw( function( s, w, h )
                                        design.rbox( 4, 0, 0, w, h, clr_box_ol )
                                        design.rbox( 4, 2, 2, w - 4, h - 4, clr_box_n )

                                        surface.SetDrawColor( clr_img )
                                        surface.DrawTexturedRectRotated( w + 50, 0, w, h * 3, -145 )
                                    end )

    /*
        header
    */

    local header                    = ui.new( 'pnl', obj                    )
    :top                            ( 'm', 0, 5, 0, 0                       )
    :tall                           ( sz_txt_h                              )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( msg, pref( 'design_rs_title' ), w / 2, h / 2, clr_header, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
        body
    */

    local body                      = ui.new( 'pnl', obj                    )
    :nodraw                         (                                       )
    :fill                           ( 'm', 0, 0, 0, 5                       )

    /*
        label > countdown
    */

    local l_cd                      = ui.new( 'lbl', body                   )
    :fill                           ( 'm', 0, 5, 0, 5                       )
    :notext                         (                                       )
    :align                          ( 5                                     )
    :font                           ( pref( 'design_rs_cntdown' )           )
    :textclr                        ( clr_txt_cntdown                       )
    :align                          ( 5                                     )

    /*
        create object
    */

    if ui:ok( obj ) then
        base.restart = obj
        obj:MoveTo( ScrW( ) / 2 - ( sz_w / 2 ), 5, 1.01, 1, -1 )
    end

    /*
        logic
    */

    local function logic_restart( )
        if not ui:ok( base.restart ) then
            rhook.drop.gmod( 'Think', 'rlib_design_notice_rs' )
            return
        end

        if ui:visible( l_cd ) then
            local remains   = base.sys.rs_remains
            local resp      = ( isnumber( remains ) and remains ) or 0
            resp            = resp > 0 and timex.secs.sh_simple( resp ) or ln( 'restart_status' )

            l_cd:SetText( resp )
            if resp == ln( 'restart_status' ) then
                l_cd:SetFont( pref( 'design_rs_status' ) )
            end
        end
    end
    rhook.new.gmod( 'Think', 'rlib_design_notice_rs', logic_restart )

end

/*
    design > debug

    shows debug mode visually clientside
*/

function design:debug( msg )

    /*
        dispatch existing
    */

    ui:dispatch( base.debug )

    /*
        declare
    */

    msg                     = helper.ok.str( msg ) or ln( 'debug_bc_title' )
    local sz_w              = RSW( ) * 0.10
    local sz_h              = RSH( ) * 0.10
    local sz_txt_h          = helper.str:lenH( msg, pref( 'design_debug_title' ), 10 )

    /*
        declare > colors
    */

    local clr_box_ol        = rclr.Hex( '282828' )
    local clr_box_n         = rclr.Hex( '232323' )
    local clr_header        = rclr.Hex( 'E06B6B' )
    local clr_img           = rclr.Hex( 'FFFFFF', 1 )
    local clr_txt_cntdown   = rclr.Hex( 'FFFFFF' )

    /*
        parent
    */

    local obj                       = ui.new( 'pnl'                         )
    :size                           ( sz_w, sz_h                            )
    :pos                            ( ScrW( ) / 2 - ( sz_w / 2 ), -sz_h     )
    :drawtop                        ( true                                  )

                                    :draw( function( s, w, h )
                                        design.rbox( 4, 0, 0, w, h, clr_box_ol )
                                        design.rbox( 4, 2, 2, w - 4, h - 4, clr_box_n )

                                        surface.SetDrawColor( clr_img )
                                        surface.DrawTexturedRectRotated( w + 50, 0, w, h * 3, -145 )
                                    end )

                                    :logic( function( s )
                                        if not base:g_Debug( ) then
                                            ui:dispatch( base.debug )
                                        end
                                    end )

    /*
        header
    */

    local header                    = ui.new( 'pnl', obj                    )
    :top                            ( 'm', 0, 5, 0, 0                       )
    :tall                           ( sz_txt_h                              )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( msg, pref( 'design_debug_title' ), w / 2, h / 2, clr_header, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
        body
    */

    local body                      = ui.new( 'pnl', obj                    )
    :nodraw                         (                                       )
    :fill                           ( 'm', 0, 0, 0, 5                       )

    /*
        label > countdown
    */

    local l_cd                      = ui.new( 'lbl', body                   )
    :fill                           ( 'm', 0, 5, 0, 5                       )
    :notext                         (                                       )
    :align                          ( 5                                     )
    :font                           ( pref( 'design_rs_cntdown' )           )
    :textclr                        ( clr_txt_cntdown                       )
    :align                          ( 5                                     )

    /*
        create object
    */

    if ui:ok( obj ) then
        base.debug = obj
        obj:MoveTo( ScrW( ) / 2 - ( sz_w / 2 ), 5, 1.01, 1, -1 )
    end

    /*
        logic
    */

    local function logic_debug( )
        if ( not ui:ok( base.debug ) ) then
            rhook.drop.gmod( 'Think', 'rlib_design_notice_debug' )
            return
        end

        if ui:visible( l_cd ) then
            local remains   = base.sys.debug
            local resp      = ( isnumber( remains ) and remains ) or 0
            resp            = resp > 0 and timex.secs.sh_simple( resp ) or ln( 'debug_bc_disabling' )

            l_cd:SetText( resp )
            if resp == ln( 'debug_bc_disabling' ) then
                l_cd:SetFont( pref( 'design_rs_status' ) )
            end
        end
    end
    rhook.new.gmod( 'Think', 'rlib_design_notice_debug', logic_debug )

end

/*
*   design > animted scrolling text
*
*   displays text from a starting position and forces the text to scroll upward as time passes with
*   fade in/out effects as it enters/leaves
*
*   returns the atime to a specified var which is used as the expiration time as part of the paint call.
*
*   @param  : str text
*   @param  : str uid
    @param  : tbl src
*   @param  : str font
*   @param  : clr clr
*   @param  : int dist
*   @param  : int atime
*   @return : int atime
*/

function design.anim_scrolltext( text, uid, src, font, clr, dist, atime )
    if not isstring( text ) then return end

    uid                 = uid or helper.new.id( 10 )
    src                 = istable( src ) and src or { }
    font                = font or pref( 'design_draw_textscroll' )
    clr                 = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
    dist                = isnumber( dist ) and dist or 0.5
    atime               = isnumber( atime ) and atime or 2

    local time_fade, time_start, alpha = 0.5, CurTime( ), 255
    local dur = atime

    local function draw2screen( )
        if not istable( src ) or #src < 1 then
            alpha, time_start, dur = 255, CurTime( ), atime
            return
        end

        local time_anim = CurTime( ) - time_start
        if alpha < 0 then alpha = 0 end

        if ( time_fade - time_anim ) > 0 then
            alpha = ( time_fade - time_anim ) / time_fade
            alpha = 1 - alpha
            alpha = alpha * 255
        end

        if ( dur - time_anim ) < time_fade then
            alpha = ( dur - time_anim ) / time_fade
            alpha = alpha * 255
        end

        local clr_alpha = math.Clamp( alpha, 0, 255 )

        for i = 1, #src do
            local item = src[ i ]

            if not item then return end

            design.txt( text, item.x, item.y, Color( clr.r, clr.g, clr.b, clr_alpha ), font, 1, 1 )

            item.x = item.pos
            item.y = item.y - dist

            if item.expires <= CurTime( ) then
                helper:table_remove( src, i )
            end
        end
    end
    hook.Add( 'DrawOverlay', uid .. 'd2s.scrolltext', draw2screen )

    return atime
end

/*
*   design > animted scrolling text
*
*   displays text from a starting position and forces the text to scroll upward as time passes with
*   fade in/out effects as it enters/leaves
*
*   @param  : str text
*   @param  : str uid
    @param  : tbl src
*   @param  : str fnt
*   @param  : clr clr
*   @param  : int dist
*   @param  : int atime
*   @return : int atime
*/

function design.anim_tscroll( text, uid, src, fnt, clr, dist, atime )
    if not isstring( text ) then return end

    uid                 = uid or helper.new.id( 10 )
    src                 = istable( src ) and src or { }
    fnt                 = fnt or pref( 'design_draw_textscroll' )
    clr                 = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
    dist                = isnumber( dist ) and dist or 0.5
    atime               = isnumber( atime ) and atime or 2

    local function draw2screen( )
        if not istable( src ) or #src < 1 then
            return
        end

        for i = 1, #src do
            local item      = src[ i ]
                            if not item then return end

            item.fnt_id     = isnumber( item.fnt_id  ) and item.fnt_id  or 1
            item.fnt_id     = math.Clamp( item.fnt_id + 1, 1, 60 )

            local txt_font  = string.format( '%s.%s', 'boost_anim', item.fnt_id )

            item.alpha      = ( isnumber( item.alpha ) and item.alpha > 0 and item.alpha ) or 255

            item.dur        = ( isnumber( item.dur ) and item.dur > 0 and item.dur ) or atime

            item.time_fade  = ( isnumber( item.time_fade ) and item.time_fade > 0 and item.time_fade ) or 0.1
                            if item.alpha < 0 then item.alpha = 0 end


            item.time_anim  = CurTime( ) - item.time_start

            if ( item.time_fade - item.time_anim ) > 0 then
                item.alpha = ( item.time_fade - item.time_anim ) / item.time_fade
                item.alpha = 1 - item.alpha
                item.alpha = item.alpha * 255
            end

            if ( item.dur - item.time_anim ) < item.time_fade then
                item.alpha = ( item.dur - item.time_anim ) / item.time_fade
                item.alpha = item.alpha * 255
            end

            local clr_alpha = math.Clamp( item.alpha, 0, 255 )
            design.txt( text, item.x, item.y, Color( clr.r, clr.g, clr.b, clr_alpha ), txt_font, 1, 1 )

            item.x = item.pos
            item.y = item.y - dist

            if item.expires <= CurTime( ) then
                helper:table_remove( src, i )
            end
        end
    end
    hook.Add( 'DrawOverlay', uid .. 'd2s.scrolltext', draw2screen )

    return atime
end

/*
*   design > rsay
*
*   displays text from a starting position and forces the text to scroll upward as time passes with
*   fade in/out effects as it enters/leaves
*
*   returns the atime to a specified var which is used as the expiration time as part of the paint call.
*
*   @param  : str msg
*   @param  : clr clr
*   @param  : int dur
*   @param  : int fade
*/

function design.rsay( msg, clr, dur, fade )
    msg                 = msg or 'missing msg'
    clr                 = clr or Color( 255, 255, 255, 255 )
    dur                 = dur or 10
    fade                = fade or 0.5

    local msg_table     = istable( msg ) and true or false
    local start         = CurTime( )

    local function rsay_draw( )
        local alpha = 255
        local dtime = CurTime( ) - start

        if dtime > dur then
            hook.Remove( 'HUDPaint', pf .. 'rsay.draw' )
            return
        end

        if fade - dtime > 0 then
            alpha = ( fade - dtime ) / fade
            alpha = 1 - alpha
            alpha = alpha * 255
        end

        if dur - dtime < fade then
            alpha = ( dur - dtime ) / fade
            alpha = alpha * 255
        end
        clr.a  = alpha

        if not msg_table then
            design.txt( msg, ScrW( ) * 0.5, ScrH( ) * 0.25, clr, pref( 'design_rsay_text' ), 1 )
        else
            design.txt( msg[ 1 ], ScrW( ) * 0.5, ScrH( ) * 0.25 - 15, clr, pref( 'design_rsay_text' ), 1 )
            design.txt( msg[ 2 ], ScrW( ) * 0.5, ScrH( ) * 0.25 + 15, clr, pref( 'design_rsay_text_sub' ), 1 )
        end
    end

    hook.Add( 'HUDPaint', pf .. 'rsay.draw', rsay_draw )
end

/*
    netlib > rsay
*/

local function netlib_rsay( )
    local msg       = net.ReadString( )
    local clr       = net.ReadColor( )
    local dur       = net.ReadInt( 8 )
    local fade      = net.ReadInt( 8 )

    design.rsay( msg, clr, dur, fade )
end
net.Receive( 'rlib.rsay', netlib_rsay )