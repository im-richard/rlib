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
local m_blur                = Material( helper._mat[ 'pp_blur' ] )
local m_sms_bg              = mat2d( 'rlib/general/patterns/diag_w.png' )

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
    default colors
*/

local clr_empty             = Color( 0, 0, 0, 0 )
local clr_white             = Color( 255, 255, 255, 255 )
local clr_black             = Color( 0, 0, 0, 255 )
local clr_dgrey             = Color( 30, 30, 30, 255 )
local clr_blur              = Color( 5, 5, 5, 200 )
local clr_box3d_1           = Color( 0, 255, 255, 200 )
local clr_box3d_2           = Color( 255, 0, 0, 200 )
local clr_sms_1             = Color( 25, 25, 25, 255 )
local clr_sms_2             = Color( 29, 29, 29, 255 )
local clr_sms_mat           = Color( 125, 125, 125, 1 )
local clr_sms_push_title    = Color( 222, 31, 90, 255 )
local clr_sms_ico           = Color( 100, 100, 100, 255 )
local clr_sms_h             = Color( 0, 0, 0, 100 )

/*
    notifications > storage > clean
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
*/

local function loc_slot_push( obj )
    slot_storage_clean( )
    local pos_new           = 150

    for i = 1, 8, 1 do
        if base.push[ i ] then
            local id        = base.push[ i ]
            pos_new         = pos_new + id:GetTall( )
            pos_new         = pos_new + 5
            continue
        end
        return i, pos_new
    end
end

/*
    locate slot > sos
*/

local function loc_slot_sos( obj )
    slot_storage_clean( )
    local pos_new           = 5

    for i = 1, 8, 1 do
        if base.sos[ i ] then
            local id        = base.sos[ i ]
            pos_new         = pos_new + id:GetTall( )
            pos_new         = pos_new + 5
            continue
        end
        return i, pos_new
    end
end

/*
    design > blur
*/

function design.blur( pnl, amt, amplify )
    if not IsValid( pnl ) then return end

    amt                     = isnumber( amt ) and amt or 6
    amplify                 = isnumber( amplify ) and amplify or 3

    local x, y              = pnl:LocalToScreen( 0, 0 )
    local scr_w, scr_h      = ScrW( ), ScrH( )

    surface.SetDrawColor    ( 255, 255, 255, 255 )
    surface.SetMaterial     ( m_blur )

    for i = 1, ( amplify ) do
        m_blur:SetFloat     ( '$blur', ( i / amplify ) * amt )
        m_blur:Recompute    ( )

        if render then render.UpdateScreenEffectTexture( ) end
        surface.DrawTexturedRect( x * -1, y * -1, scr_w, scr_h )
    end
end

/*
    design > blur > trim
*/

function design.blur_trim( pnl, amt, amplify )
    if not IsValid( pnl ) then return end

    amt                     = isnumber( amt ) and amt or 6
    amplify                 = isnumber( amplify ) and amplify or 3

    local x, y              = pnl:LocalToScreen( 0, 0 )
    local scr_w, scr_h      = ScrW( ), ScrH( )

    x                       = x + 30
    scr_w                   = scr_w + 40

    y                       = y + 30
    scr_h                   = scr_h + 40

    surface.SetDrawColor    ( 255, 255, 255, 255 )
    surface.SetMaterial     ( m_blur )

    for i = 1, ( amplify ) do
        m_blur:SetFloat     ( '$blur', ( i / amplify ) * amt )
        m_blur:Recompute    ( )

        if render then render.UpdateScreenEffectTexture( ) end
        surface.DrawTexturedRect( x * -1, y * -1, scr_w, scr_h )
    end
end

/*
    design > blur > self
*/

function design.blurself( clr, amt, amplify )
    local x, y, frac        = 0, 0, 1

    clr                     = IsColor( clr ) and clr or clr_blur
    amt                     = isnumber( amt ) and amt or 6
    amplify                 = isnumber( amplify ) and amplify or 3

    DisableClipping         ( true )

    surface.SetMaterial     ( m_blur )
    surface.SetDrawColor    ( 255, 255, 255, 255 )

    for i = 1, ( amplify ) do
        m_blur:SetFloat     ( '$blur', ( i / amplify ) * amt )
        m_blur:Recompute    ( )

        if render then render.UpdateScreenEffectTexture( ) end
        surface.DrawTexturedRect( x * -1, y * -1, ScrW( ), ScrH( ) )
    end

    surface.SetDrawColor    ( clr.r, clr.g, clr.b, clr.a * frac )
    surface.DrawRect        ( x * -1, y * -1, ScrW(), ScrH() )

    DisableClipping         ( false )
end

/*
    design > rgb
*/

function design.rgb( state, r, g, b, a )
    state                   = state or 0
    r                       = isnumber( r ) and r or 0
    g                       = isnumber( g ) and g or 0
    b                       = isnumber( b ) and b or 0
    a                       = isnumber( a ) and a or 255

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
    design > line
*/

function design.line( x_start, y_start, x_end, y_end, clr )
    if not x_start or not y_start or not x_end or not y_end then return end

    clr                     = IsColor( clr ) and clr or clr_white

    surface.SetDrawColor	( clr           )
    surface.DrawLine		( x_start, y_start, x_end, y_end )
end

/*
    design > box
*/

function design.box( x, y, w, h, clr )
    h                       = isnumber( h ) and h or w
    clr                     = IsColor( clr ) and clr or clr_black

    surface.SetDrawColor    ( clr )
    surface.DrawRect        ( x, y, w, h )
end

/*
    design > poly
*/

function design.poly( data, clr )
    if not istable( data ) then return end

    clr                     = IsColor( clr ) and clr or clr_black

    draw.NoTexture          (       )
    surface.SetDrawColor    ( clr   )
    surface.DrawPoly        ( data  )
end

/*
    design > box > 3d
*/

function design.box3d( w, min, max, clr )
    local offset            = Vector( 2, 2, 2 )
    local mid, lmin, lmax   = calc.pos.midpoint( min, max )
    local angle_zero        = Angle( 0, 0, 0 )

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
    render.DrawBox( min, angle_zero, -offset, offset, clr_box3d_1, true )
    render.DrawBox( max, angle_zero, -offset, offset, clr_box3d_2, true )

    return mid, lmin, lmax
end

/*
    design > material
*/

function design.mat( x, y, w, h, mat, clr )
    local src               = mats:ok( mat ) and mat or istable( mat ) and mat.material or isstring( mat ) and mat
    src                     = isstring( src ) and Material( src, 'noclamp smooth' ) or src or mat_def
    clr                     = clr or clr_white

    surface.SetMaterial         ( src           )
    surface.SetDrawColor        ( clr           )
    surface.DrawTexturedRect    ( x, y, w, h    )
end

/*
    design > imat
*/

function design.imat( x, y, w, h, mat, clr )
    local src               = mats:ok( mat ) and mat or false
                            if not src then return end

    clr                     = clr or clr_white

    surface.SetMaterial         ( src           )
    surface.SetDrawColor        ( clr           )
    surface.DrawTexturedRect    ( x, y, w, h    )
end

/*
    design > mat > rotated
*/

function design.mat_r( x, y, w, h, r, mat, clr )
    r                       = isnumber( r ) and r or 0
    mat                     = isstring( mat ) and Material( mat, 'noclamp smooth' ) or mat
    clr                     = clr or clr_white

    surface.SetMaterial     ( mat )
    surface.SetDrawColor    ( clr )
    surface.DrawTexturedRectRotated( x, y, w, h, r )
end

/*
    design > imat > rotated
*/

function design.imat_r( x, y, w, h, r, mat, clr )
    r                       = isnumber( r ) and r or 0
    mat                     = mats:ok( mat ) and mat or false
                            if not mat then return end

    clr                     = clr or clr_white

    surface.SetMaterial( mat )
    surface.SetDrawColor( clr )
    surface.DrawTexturedRectRotated( x, y, w, h, r )
end

/*
    design > nat_rotated
*/

function design.mat_rotate( x, y, w, h, ang )
    surface.DrawTexturedRectRotated( x, y, w, h, ang )
end

/*
    design > loader
*/

function design.loader( x, y, sz, clr )
    x                       = x or 0
    y                       = y or 0
    sz                      = sz or 100
    clr                     = IsColor( clr ) and clr or clr_white

    local a                 = math.abs( math.sin( CurTime( ) * 4 ) * 255 )
    a                       = math.Clamp( a, 200, 255 )

    local color             = ColorAlpha( clr, a )

    surface.SetMaterial     ( base._def.mats[ 'loader' ] )
    surface.SetDrawColor    ( color )

    design.mat_rotate       ( x, y, sz, sz, ( CurTime( ) % 360 ) * -100 )
end

/*
    design > rounded box
*/

function design.rbox( r, x, y, w, h, clr )
    r                       = r or 0
    x                       = x or 0
    y                       = y or 0
    w                       = w or ScrW( )
    h                       = h or ScrH( )
    clr                     = IsColor( clr ) and clr or clr_black

    if r <= 0 then
        design.box( x, y, w, h, clr )
        return
    end

    draw.RoundedBox( r, x, y, w, h, clr )
end

/*
    design > rounded box enhanced

    @param      :   r           int             corner radius
    @param      :   x           int             x coordinate
    @param      :   y           int             y coordinate
    @param      :   w           int             width
    @param      :   h           int             height
    @param      :   clr         clr             fill color
    @param      :   tl          bool            round top left
    @param      :   tr          bool            round top right
    @param      :   bl          bool            round btm left
    @param      :   br          bool            round btm right
*/

function design.erbox( r, x, y, w, h, clr, tl, tr, bl, br )
    r                       = r or 0
    x                       = x or 0
    y                       = y or 0
    w                       = w or ScrW( )
    h                       = h or ScrH( )
    clr                     = IsColor( clr ) and clr or clr_black
    tl                      = tl or false
    tr                      = tr or false
    bl                      = bl or false
    br                      = br or false

    if r <= 0 then
        design.box( x, y, w, h, clr )
        return
    end

    draw.RoundedBoxEx( r, x, y, w, h, clr, true, true, false, false )
end

/*
    design > rounded box > advanced
*/

function design.rbox_adv( bsize, x, y, w, h, clr, tl, tr, bl, br )

    clr = IsColor( clr ) and clr or clr_black

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
    design > outlined box
*/

function design.obox( x, y, w, h, m_clr, b_clr )
    local i, n      = 1, 2
    m_clr           = IsColor( m_clr ) and m_clr or clr_black
    b_clr           = IsColor( b_clr ) and b_clr or clr_white

    surface.SetDrawColor        ( m_clr )
    surface.DrawRect            ( x + i, y + i, w - n, h - n )
    surface.SetDrawColor        ( b_clr )
    surface.DrawOutlinedRect    ( x, y, w, h )
end

/*
    design > outlined box thick
*/

function design.obox_th( x, y, w, h, m_clr, b_wide )
    m_clr           = IsColor( m_clr ) and m_clr or clr_black
    b_wide          = isnumber( b_wide ) and b_wide or 1

    surface.SetDrawColor( m_clr )
    for i = 0, b_wide - 1 do
        surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
    end
end

/*
    design > text
*/

function design.text( text, x, y, clr, fnt, aln_x, aln_y )
    text                    = tostring( text )
    x                       = isnumber( x ) and x or 0
    y                       = isnumber( y ) and y or 0
    clr                     = IsColor( clr ) and clr or clr_white
    fnt                     = isstring( fnt ) and fnt or ( pref( 'design_text_default' ) )
    aln_x                   = aln_x or TEXT_ALIGN_LEFT
    aln_y                   = aln_y or TEXT_ALIGN_TOP

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
    design > txt
*/

function design.txt( text, x, y, clr, fnt, aln_x, aln_y )
    text                    = tostring( text )
    x                       = isnumber( x ) and x or 0
    y                       = isnumber( y ) and y or 0
    clr                     = IsColor( clr ) and clr or clr_white
    fnt                     = isstring( fnt ) and fnt or ( pref( 'design_text_default' ) )
    aln_x                   = aln_x or TEXT_ALIGN_LEFT
    aln_y                   = aln_y or TEXT_ALIGN_TOP

    surface.SetFont         ( fnt )
    local w, h              = surface.GetTextSize( text )

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
    design > language
*/

function design.lng( pf, text, fnt, x, y, clr, aln_x, aln_y )
    text                    = tostring( text )
    fnt                     = fnt or ( pref( 'design_text_default' ) )
    x                       = x and x or 0
    y                       = y and y or 0
    clr                     = IsColor( clr ) and clr or clr_white
    aln_x                   = aln_x or TEXT_ALIGN_LEFT
    aln_y                   = aln_y or TEXT_ALIGN_TOP

    local _f                = font.get( pf, fnt )
    local w, h              = helper.str:len( text, _f )

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
    design > text_adv
*/

function design.text_adv( text, x, y, clr, fnt, aln_x )
    text                    = text or 'missing text'
    x                       = isnumber( x ) and x or 0
    y                       = isnumber( y ) and y or 0
    clr                     = IsColor( clr ) and clr or clr_white
    fnt                     = isstring( fnt ) and fnt or ( pref( 'design_text_default' ) )
    aln_x                   = aln_x or TEXT_ALIGN_LEFT

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
    design > title boxcat
*/

function design.title_boxcat( title, title_fnt, cat, cat_fnt, t_clr, b_clr, c_clr, pos_x, pos_y, offset_x, offset_y, cat_w_os, text_os_w )
    if not title then return end
    if not title_fnt then return end

    cat                     = isstring( cat ) and cat or 'no category'
    cat_fnt                 = isstring( cat_fnt ) and cat_fnt or title_fnt
    t_clr                   = IsColor( t_clr ) and t_clr or clr_white
    b_clr                   = IsColor( b_clr ) and b_clr or Color( 0, 73, 156, 255 )
    c_clr                   = IsColor( c_clr ) and c_clr or clr_white
    pos_x                   = pos_x or 0
    pos_y                   = pos_y or 15
    offset_x                = offset_x or 0
    offset_y                = offset_y or 0
    cat_w_os                = cat_w_os or 20
    text_os_w               = text_os_w or 0

    /*
        title variables
    */

    title                   = isstring( title ) and title or tostring( title )
    local title_w           = helper.str:lenW( title, title_fnt )
    title_w                 = title_w + offset_x + 10

    /*
        cat variables
    */

    cat                     = isstring( cat ) and cat or tostring( cat )
    local cat_w, cat_h      = helper.str:len( cat, cat_fnt )
    cat_h                   = cat_h + offset_y
    cat_w                   = cat_w + cat_w_os

    /*
        draw
    */

    draw.SimpleText( title, title_fnt, pos_x, pos_y, t_clr, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.RoundedBox( 4, pos_x + title_w, pos_y - ( cat_h / 2 ), cat_w, cat_h, b_clr )
    draw.SimpleText( cat, cat_fnt, pos_x + title_w + ( cat_w / 2 ) - text_os_w, pos_y, c_clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

/*
    design > bokeh eff
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
                xpos        = math.random( 0, wsize ),
                ypos        = math.random( -hsize, hsize ),
                size        = math.random( size_min, size_max ),
                clr         = Color( clr_r, clr_g, clr_b, clr_a ),
                speed       = math.random( speed_min, speed_max ),
                area        = math.Round( math.random( -50, 150 ) ),
            }
        end
        return amt, fx_bokeh
    end
end

/*
    design > bokeh fx
*/

function design:bokehfx( w, h, amt, object, fx, selected, speed, offset )
    fx                      = fx or helper._bokehfx
    local fx_type           = fx[ selected or 'gradients' ]

    if not fx_type then return end

    speed                   = speed or 30
    offset                  = offset or 0

    surface.SetMaterial     ( Material( fx_type, 'noclamp smooth' ) )

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
    design > arc
*/

function design.arc( x, y, radius, thickness, pos_s, pos_e, clr )
    local cir_o             = { }
    local cir_i             = { }
    pos_s                   = math.floor( pos_s )
    pos_e                   = math.floor( pos_e )
    clr                     = IsColor( clr ) and clr or clr_black

    if pos_s > pos_e then
        local swap          = pos_e
        pos_e               = pos_s
        pos_s               = swap
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
    design > arc > circle
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
    design > arc > tri
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
    design > arc > tri > draw poly
*/

function design.arc_drawpoly( arc )
    for k, v in ipairs( arc ) do
        surface.DrawPoly( v )
    end
end

/*
    design > triarc > draw
*/

function design.arc_tri_draw( posx, posy, radius, thickness, startang, endang, roughness, color )
    surface.SetDrawColor( color )
    design.arc_drawpoly( design.arc_tri( posx, posy, radius, thickness, startang, endang, roughness ) )
end

/*
    design > circle
*/

function design.circle( x, y, radius, seg, clr )
    y           = isnumber( y ) and y or 0
    x           = isnumber( x ) and x or 0
    radius      = isnumber( radius ) and radius or 10
    seg         = isnumber( seg ) and seg or 20
    clr         = IsColor( clr ) and clr or clr_black

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
    design > circle stencil
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
    design > circle_t2_g
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
    design > circle_t2
*/

function design.circle_t2( x, y, radius, seg, clr )
    surface.SetDrawColor( clr or clr_empty )
    surface.DrawPoly( design.circle_t2_g( x, y, radius, seg ) )
end

/*
    design > circle_anim_g
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
    design > circle_anim
*/

function design.circle_anim( x, y, radius, seg, clr, frac )
    surface.SetDrawColor( clr or Color( 0, 0, 0, 0 ) )
    surface.DrawPoly( design.circle_anim_g( x, y, radius, seg, frac ) )
end

/*
    design > circle > simple
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
        surface.SetDrawColor( clr or clr_black )
        draw.NoTexture( )
    end

    surface.DrawPoly( poly )
end

/*
    design > circle > simple
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
    design > rcircle > fill
*/

function design.rcir.fill( pnl, clr, rotate )
    if not pnl then return end

    clr         = IsColor( clr ) and clr or clr_white
    rotate      = isnumber( rotate ) and rotate or 0

    draw.NoTexture          (               )
    surface.SetDrawColor    ( clr           )

    pnl:SetRotation         ( rotate        )
    pnl                     (               )
end

/*
    design > rcircle > outlined
*/

function design.rcir.line( pnl, mat, clr, rotate )
    if not pnl then return end

    mat         = mats:ok( mat ) and mat or nil
    clr         = IsColor( clr ) and clr or clr_white
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
    design > stencils
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

    @ex     :   design:notify( 'the message', category  )
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
        declare > colors
    */

    local clr_box_ol                = rclr.Hex( '000000', 255 )
    local clr_box_n                 = base._def.lc_rgb[ cat ] or rclr.Hex( '1E1E1E' )
    local clr_txt                   = rclr.Hex( 'FFFFFF' )

    /*
        declare > fonts
    */

    local fnt_text                  = pref( 'design_notify_msg' )

    /*
        scale & sizes
    */

    local rfs_w                     = rfs.w( )
    local rfs_h                     = rfs.h( )
    local ui_w, ui_h                = ScrW( ), draw.GetFontHeight( fnt_text ) + ( 30 * rfs_h )
    local sz_w, sz_h                = helper.str:len( msg, fnt_text )
    sz_w                            = sz_w + ( 100 * rfs_w )

    local pos_w                     = ( ui_w / 2 ) - ( sz_w / 2 )
    local pos_h                     = ( startpos == 2 and ( ScrH( ) - ui_h ) ) or ( startpos == 3 and ScrH( ) * 0.25 ) or 5
    local pos_m2                    = ( startpos == 2 and ( ScrH( ) ) ) or ( startpos == 3 and d ) or -ui_h

    /*
        object
    */

    local obj                       = ui.new( 'btn'                         )
    :bsetup                         (                                       )
    :sz                             ( sz_w, ui_h                            )
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

    @ex     :   design:nms( 'Message', 'title' )
*/

function design:nms( msg, title, ico )
    msg                             = msg or 'Error Occured'
    title                           = helper.str:ok( title ) and title or 'Notice'
    ico                             = helper.str:ok( ico ) and ico or ''

    /*
        timer
    */

    local timer_id                  = string.format( '%snotice.timer', pf )
    timex.expire                    ( timer_id )

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
        colors
    */

    local clr_txt                   = cfg.dialogs.clrs.primary_text
    local clr_pri                   = cfg.dialogs.clrs.primary
    local clr_sec                   = cfg.dialogs.clrs.secondary
    local clr_prog                  = cfg.dialogs.clrs.progress
    local clr_icon                  = cfg.dialogs.clrs.icons

    /*
        fonts
    */

    local fnt_name                  = pref( 'design_nms_name' )
    local fnt_msg                   = pref( 'design_nms_msg' )
    local fnt_ico                   = pref( 'design_nms_ico' )
    local fnt_close                 = pref( 'design_nms_qclose' )

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
                                        dur         = math.Clamp( dur, 0, dur )
                                        dtime       = CurTime( ) - start
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
                                        design.txt( ln( 'dialog_key_close', key_close ), w / 2, h - h * .10 / 2 + 15, ColorAlpha( clr_txt, c_alpha ), fnt_close, 1, 1 )

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

    @ex     :   design:bubble( 'This is a really bigreenscali ling enabsad asdsd asda asda asd asdasd sadasd asdasd  asdsad asd asdas sadasdled', 10  )
*/

function design:bubble( msg, dur, clr_box, clr_txt )

    /*
        destroy existing
    */

    ui:dispatch( base.bubble )

    /*
        check
    */

    if not msg then return end

    /*
        colors
    */

    local clr_txt                   = IsColor( clr_txt ) and clr_txt or rclr.Hex( 'FFFFFF' )
    local clr_box                   = IsColor( clr_box ) and clr_box or rclr.Hex( '141414' )
    local clr_box_ol                = rclr.Hex( 'FFFFFF', 50 )
    local clr_ico                   = rclr.Hex( 'FFFFFF' )
    local clr_mat                   = rclr.Hex( '7d7d7d', 3 )

    /*
        fonts
    */

    local fnt_msg                   = pref( 'design_bubble_msg' )
    local fnt_ico                   = pref( 'design_bubble_ico' )

    /*
        scale & sizes
    */

    local rfs_w                     = rfs.w( )
    local rfs_h                     = rfs.h( )
    local sz_ico_w                  = ( 70 * rfs_w ) or 70
    local sz_ico_h                  = helper.str:lenH( utf8.char( 9873 ), fnt_ico )

    /*
        message cropping and length
    */

    local message                   = helper.str:crop( msg, 350 * rfs.w( ), fnt_msg )
    local text_w, text_h            = helper.str:len( message, fnt_msg )
    local pos_w, pos_h              = text_w + sz_ico_w + ( 55 * rfs_w ) + 20, text_h + ( 55 * rfs_h ) + 15
    dur                             = isnumber( dur ) and dur or 8

    /*
        obj > btn
    */

    local obj                       = ui.new( 'btn'                         )
    :bsetup                         (                                       )
    :sz                             ( pos_w, pos_h                          )
    :pos                            ( ScrW( ) - pos_w - 5, ScrH( ) + pos_h  )
    :textadv                        ( clr_txt, fnt_msg, ''                   )
    :drawtop                        ( true                                  )
    :box                            ( clr_box_ol                            )
    :keeptop                        (                                       )
    :drawtop                        ( true                                  )
    :focustop                       ( true                                  )

    /*
        obj > bg
    */

    local sub                       = ui.new( 'pnl', obj                    )
    :fill                           ( 'm', 1                                )

                                    :draw( function( s, w, h )
                                        design.box( 0, 0, w, h, clr_box )
                                        design.imat( 0, 0, w, h * 1, m_sms_bg, clr_mat )
                                    end )

    /*
        obj > body
    */

    local body                      = ui.new( 'btn', sub                    )
    :bsetup                         (                                       )
    :fill                           ( 'm', 0                                )

                                    :draw( function( s, w, h )
                                        draw.DrawText( message, fnt_msg, sz_ico_w + 15, ( h / 2 ) - ( text_h / 2 ), clr_txt , TEXT_ALIGN_LEFT )
                                    end )

    /*
        obj > btn > icon
    */

    local ico                       = ui.new( 'btn', body                   )
    :bsetup                         (                                       )
    :left                           ( 'm', 7, 0, 0, 0                       )
    :wide                           ( sz_ico_w                              )

                                    :draw( function( s, w, h )
                                        local i_pulse       = math.abs( math.sin( CurTime( ) * 3 ) * 255 )
                                        i_pulse			    = math.Clamp( i_pulse, 30, 255 )

                                        draw.DrawText( utf8.char( 10070 ), fnt_ico, w / 2, ( obj:GetTall( ) / 2 ) - ( sz_ico_h / 2 ) - 5, ColorAlpha( clr_ico, i_pulse ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

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
    design > bubble > rich
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
        declare > colors
    */

    local clr_txt                   = IsColor( clr_txt ) and clr_txt or rclr.Hex( 'FFFFFF' )
    local clr_box                   = IsColor( clr_box ) and clr_box or rclr.Hex( '141414' )
    local clr_box_ol                = rclr.Hex( 'FFFFFF', 50 )
    local clr_ico                   = rclr.Hex( 'FFFFFF' )
    local clr_mat                   = rclr.Hex( '7d7d7d', 3 )

    /*
        fonts
    */

    local fnt_msg                   = pref( 'design_bubble_msg' )
    local fnt_ico                   = pref( 'design_bubble_ico' )

    /*
        scale & sizes
    */

    local rfs_w                     = rfs.w( )
    local rfs_h                     = rfs.h( )
    local sz_ico_w                  = ( 70 * rfs_w ) or 70
    local sz_ico_h                  = helper.str:lenH( utf8.char( 9873 ), fnt_ico )
    local sz_rtxt_h                 = ( 30 * rfs_h ) or 70

    /*
        message cropping and length
    */

    local message                   = helper.str:crop( msg, 350 * rfs.w( ), fnt_msg )
    local text_w, text_h            = helper.str:len( message, fnt_msg )
    local pos_w, pos_h              = text_w + sz_ico_w + ( 55 * rfs_w ) + 20, text_h + ( 55 * rfs_h ) + 15
    dur                             = isnumber( dur ) and dur or 8

    /*
        obj > btn
    */
    // ssss
    local obj                       = ui.new( 'btn'                         )
    :bsetup                         (                                       )
    :sz                             ( pos_w, pos_h                          )
    :pos                            ( ScrW( ) - pos_w - 5, ScrH( ) + pos_h  )
    :textadv                        ( clr_txt, fnt_msg, ''                   )
    :drawtop                        ( true                                  )
    :box                            ( clr_box_ol                            )
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
    :fill                           ( 'm', 0, 0, 0, 0                       )

                                    :draw( function( s, w, h )
                                        design.rbox( 8, 0, 0, w, h, clr_box )
                                    end )

    /*
        obj > btn > icon
    */

    local ico                       = ui.new( 'btn', sub                    )
    :bsetup                         (                                       )
    :left                           ( 'm', 7, 0, 0, 0                       )
    :wide                           ( sz_ico_w                              )

                                    :draw( function( s, w, h )
                                        local i_pulse       = math.abs( math.sin( CurTime( ) * 3 ) * 255 )
                                        i_pulse			    = math.Clamp( i_pulse, 30, 255 )

                                        draw.DrawText( utf8.char( 10070 ), fnt_ico, w / 2, ( obj:GetTall( ) / 2 ) - ( sz_ico_h / 2 ) - 5, Color( 255, 255, 255, i_pulse ) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
        obj > body
    */

    local body                      = ui.new( 'rt', sub                     )
    :fill                           ( 'm', 0, sz_rtxt_h, 30, 0              )
    :align                          ( 5                                     )
    :vsbar                          ( false                                 )
    :mline                          ( true                                  )
    :appendclr                      ( clr_white                             )

                                    :pl( function( s )
                                        s:SetFontInternal( fnt_msg )
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

    @ex     :   design:push( { 'asdasdasd' }, 'dasdasd', '', Color( 255, 255, 0 ), Color( 45, 45, 45, 255 ) )
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

    local fnt_title                 = pref( 'design_push_name' )
    local fnt_msg                   = pref( 'design_push_msg' )
    local fnt_ico                   = pref( 'design_push_ico' )

    /*
        scale
    */

    local rfs_w                     = rfs.w( )
    local rfs_h                     = rfs.h( )
    local sz_ico_w                  = ( 60 * rfs_w ) or 70
    local sz_title_pad_t            = ( 9 * rfs.h( ) )
    local sz_body_pad_t             = ( 5 * rfs.h( ) )
    local sz_ico_pad_l              = ( 10 * rfs.w( ) )

    /*
        define > message dimensions
    */

    local _t, _t_li                 = helper.str:crop( title, 250 * rfs.w( ), fnt_title )
    local hdr_w, hdr_h              = helper.str:len( _t, fnt_title )
    local fnt_w, fnt_h              = helper.str:len( ico, fnt_ico )

    local _m, _m_li                 = helper.str:crop( msg, 240 * rfs.w( ), fnt_msg )
    local msg_w, msg_h              = helper.str:len( _m, fnt_msg )

    local sz_w, sz_h                = 350 * rfs.w( ), 20 + msg_h + hdr_h + ( 5 * rfs.h( ) )
    local dur                       = 8

    clr_title                       = IsColor( clr_title ) and clr_title or clr_sms_push_title


    /*
        obj > btn
    */

    local obj                       = ui.new( 'btn'                         )
    :bsetup                         (                                       )
    :sz                             ( sz_w, sz_h                            )
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
                                        design.rbox( 6, 0, 0, w, h, clr_sms_1 )
                                        design.rbox( 6, 4, 4, w - 8, h - 8, clr_sms_2 )
                                    end )

    /*
        icon
    */

    local b_ico                     = ui.new( 'btn', sub                    )
    :bsetup                         (                                       )
    :left                           ( 'm', sz_ico_pad_l, 0, 7, 0            )
    :wide                           ( sz_ico_w                              )

                                    :draw( function( s, w, h )
                                        local clr_a     = math.abs( math.sin( CurTime( ) * 3 ) * 255 )
                                        clr_a		    = math.Clamp( clr_a, 100, 255 )

                                        draw.DrawText( ico, fnt_ico, w / 2, ( h / 2 ) - ( fnt_h / 2 ), ColorAlpha( clr_sms_ico, clr_a ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
        obj > title
    */

    local hdr_sub                   = ui.new( 'pnl', sub                    )
    :top                            ( 'm', 1, sz_title_pad_t, 0, 0          )
    :tall                           ( hdr_h                                 )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( title, fnt_title, 0, h / 2, clr_title, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

    /*
        obj > body
    */

    local body                      = ui.new( 'rt', sub                     )
    :fill                           ( 'm', 0, sz_body_pad_t, 14, 0          )
    :align                          ( 4                                     )
    :vsbar                          ( false                                 )
    :mline                          ( true                                  )
    :appendclr                      ( clr_white                             )

                                    :pl( function( s )
                                        s:SetFontInternal( fnt_msg )
                                    end )

    /*
        obj > determine string and color keys
    */

    if istable( msgtbl ) then
        for k, v in pairs( msgtbl ) do
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
                                            design.box( 0, 0, w, h, clr_sms_h )
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

    @ex     :   design:sos( { 'message'}, 'title', '', 5 )
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

    local fnt_title                 = pref( 'design_sos_name' )
    local fnt_msg                   = pref( 'design_sos_msg' )
    local fnt_ico                   = pref( 'design_sos_ico' )

    /*
        scale
    */

    local rfs_w                     = rfs.w( )
    local rfs_h                     = rfs.h( )
    local sz_ico_w                  = ( 60 * rfs_w ) or 70

    /*
        define > message dimensions
    */

    local _t, _t_li                 = helper.str:crop( title, 300 * rfs.w( ), fnt_title )
    local hdr_w, hdr_h              = helper.str:len( _t, fnt_title )
    local fnt_w, fnt_h              = helper.str:len( ico, fnt_ico )

    local _m, _m_li                 = helper.str:crop( msg, 290 * rfs.w( ), fnt_msg )
    local msg_w, msg_h              = helper.str:len( _m, fnt_msg )
    local sz_w, sz_h                = 300 * rfs_w + sz_ico_w + 25 , msg_h + hdr_h + ( 20 * rfs_h )

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
    :sz                             ( sz_w, sz_h                            )
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
    :left                           ( 'm', 10 * rfs.w( ), 5, 5, 5           )
    :wide                           ( sz_ico_w                              )

                                    :draw( function( s, w, h )
                                        local clr_a     = math.abs( math.sin( CurTime( ) * 3 ) * 255 )
                                        clr_a		    = math.Clamp( clr_a, 100, 255 )

                                        draw.DrawText( ico, fnt_ico, w / 2, ( h / 2 ) - ( fnt_h / 2 ), ColorAlpha( clr_sms_ico, clr_a ) , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
        obj > title
    */

    local hdr_sub                   = ui.new( 'pnl', sub                    )
    :top                            ( 'm', 1, 5 * rfs.h( ), 0, 0            )
    :tall                           ( hdr_h                                 )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( title, fnt_title, 0, h / 2, clr_txt_title, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

    /*
        obj > body
    */

    local body                      = ui.new( 'rt', sub                     )
    :fill                           ( 'm', 0, 1, 14, 0                      )
    :align                          ( 4                                     )
    :vsbar                          ( false                                 )
    :mline                          ( true                                  )
    :appendclr                      ( clr_white                             )

                                    :pl( function( s )
                                        s:SetFontInternal( fnt_msg )
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
                                        obj:MoveTo( ( ScrW( ) / 2 ) - ( obj:GetWide( ) / 2 ), -obj:GetTall( ), 0.5, 0, -1, function( )
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
    design > notify > inform ( slider )

    @ex     :   design:inform( 1, 'This is a test notification', 'Welcome', 10 )
*/

function design:inform( mtype, msg, title, dur )

    /*
        destroy existing
    */

    ui:dispatch( base.notify )

    /*
        mtype colorization
    */

    local clr_box, clr_txt          = clr_dgrey, clr_white
    if mtype and mtype ~= 'def' then
        if IsColor( mtype ) then
            clr_box                 = mtype
        elseif isnumber( mtype ) then
            clr_box                 = base._def.lc_rgb[ mtype ]
        elseif istable( mtype ) and not IsColor( mtype ) then
            clr_box                 = mtype.clr_box or clr_dgrey
            clr_txt                 = mtype.clr_txt or clr_white
        end
    end

    /*
        check > msg
    */

    if not msg then
        mtype, msg = 2, 'an error occured'
    end

    /*
        colors
    */

    local clr_box_ol                = rclr.Hex( '232323' )
    local clr_header                = rclr.Hex( 'ce811c', 150 )

    /*
        fonts
    */

    local fnt_title                 = pref( 'design_dialog_sli_title' )
    local fnt_msg                   = pref( 'design_dialog_sli_msg' )
    local fnt_close                 = pref( 'design_dialog_sli_x' )

    /*
        scale
    */

    local rfs_w                     = rfs.w( )
    local rfs_h                     = rfs.h( )
    local sz_base_w                 = 300

    /*
        declarations
    */

    title                           = isstring( title ) and title or ln( 'notify_title_def' )
    dur                             = isnumber( dur ) and dur or 10

    local message                   = helper.str:crop( msg, sz_base_w * rfs_w, fnt_msg )
    local text_w, text_h            = helper.str:len( message, fnt_msg )
    local m_ctime                   = CurTime( )

    local sz_w, sz_h                = text_w + ( 50 * rfs_w ), ( 65 * rfs_h ) + text_h + 15
    sz_w                            = math.Clamp( sz_w, ( sz_base_w - 100 ) * rfs_w, ( sz_base_w + 100 ) * rfs_w )

    local pos_w                     = ScrW( )
    local pos_h                     = 200 * rfs_h

    /*
        pnl > sub
    */

    local obj                       = ui.new( 'pnl'                         )
    :sz                             ( sz_w, sz_h                            )
    :pos                            ( pos_w, pos_h                          )
    :drawtop                        ( true                                  )

                                    :draw( function( s, w, h )
                                        design.box( 0, 0, w, h, clr_box_ol )
                                    end )

    /*
        pnl > header
    */

    local hdr                       = ui.new( 'pnl', obj                    )
    :top                            ( 'm', 7, 0, 0, 0                       )
    :margin                         ( 0                                     )
    :tall                           ( 38 * rfs_h                            )

                                    :draw( function( s, w, h )
                                        design.box( 0, 0, w, h, clr_header )
                                    end )

    /*
        pnl > header > sub
    */

    local hdr_sub                   = ui.new( 'pnl', hdr                    )
    :fill                           ( 'm', 0, 0, 6, 0                       )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( title, fnt_title, w / 2 - 5, h / 2, clr_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
        btn > close
    */

    local b_close                   = ui.new( 'btn', hdr_sub                )
    :bsetup                         (                                       )
    :right                          ( 'm', 5, 5, 5, 5                       )
    :sz                             ( 21 * rfs_w                            )
    :textadv                        ( clr_white, fnt_close, helper.get:utf8( 'close' ) )
    :tip                            ( ln( 'tip_close' )                     )

                                    :draw( function( s, w, h )
                                        if s.hover then
                                            s:SetTextColor( clr_sms_1 )
                                        end
                                    end )

                                    :oc( function ( s )
                                        gui.EnableScreenClicker( false )
                                        ui:dispatch( obj )
                                    end )

    /*
        pnl > body
    */

    local body                      = ui.new( 'pnl', obj                    )
    :nodraw                         (                                       )
    :fill                           ( 'm', 0                                )

    /*
        pnl > body > sub
    */

    local body_i                    = ui.new( 'pnl', body                   )
    :nodraw                         (                                       )
    :fill                           ( 'm', 0                                )

    /*
        lbl > msg
    */

    local contents                  = ui.new( 'lbl', body_i                 )
    :fill                           ( 'm', 0, 3, 0                          )
    :notext                         (                                       )
    :align                          ( 5                                     )

                                    :draw( function( s, w, h )
                                        draw.DrawText( message, fnt_msg, w / 2, 10, clr_white, TEXT_ALIGN_CENTER )
                                    end )

    /*
        pnl > ftr
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
        notice sound
    */

    surface.PlaySound( cfg.dialogs.audio )

    /*
        display notice
    */

    if ui:ok( obj ) then
        base.notify = obj

        obj:MoveTo( ScrW( ) - obj:GetWide( ) - 5, pos_h, 0.5, 0, -1, function( )
            obj:MoveTo( ScrW( ), pos_h, 0.5, dur, -1, function( )
                ui:dispatch( obj )
            end )
        end )
    end

end

/*
    design > restart

    @ex     :   design:restart( 'Please save your props' )
*/

function design:restart( title )

    /*
        dispatch existing
    */

    ui:dispatch( base.restart )

    /*
        declare > colors
    */

    local clr_box_ol                = rclr.Hex( '282828', 222 )
    local clr_box_n                 = rclr.Hex( '343333' )
    local clr_header                = rclr.Hex( 'E06B6B' )
    local clr_img                   = rclr.Hex( 'FFFFFF', 1 )
    local clr_txt_cntdown           = rclr.Hex( 'FFFFFF' )
    local state, r, g, b, a         = 0, 0, 0, 0, 100

    /*
        fonts
    */

    local fnt_title                  = pref( 'design_rs_title' )
    local fn_cd                     = pref( 'design_rs_cntdown' )
    local fn_status                 = pref( 'design_rs_status' )

    /*
        scale
    */

    local rfs_w                     = rfs.w( )
    local rfs_h                     = rfs.h( )
    local sz_ico_w                  = ( 70 * rfs_w ) or 70
    local sz_hdr_p_t                = ( 15 * rfs_h ) or 15

    /*
        declare
    */

    local title                     = helper.ok.str     ( title ) or ln( 'rs_in' )
    local title_w, title_h          = helper.str:len    ( title, fnt_title )

    local msg                       = ln( 'restart_status' )
    local _m, _m_lines              = helper.str:crop   ( msg, 290 * rfs_w, fn_status )
    local msg_w, msg_h              = helper.str:len    ( _m, fn_status )

    local sz_w                      = ( ( title_w < msg_w ) and msg_w ) or title_w
    sz_w                            = sz_w + ( 100 * rfs_w )
    sz_w                            = calc.min( 400 * rfs_w, sz_w )
    local sz_h                      = 20 + msg_h + title_h + ( 50 * rfs.h( ) )

    /*
        parent
    */

    local obj                       = ui.new( 'pnl'                         )
    :sz                             ( sz_w, sz_h                            )
    :pos                            ( ScrW( ) / 2 - ( sz_w / 2 ), -sz_h     )
    :drawtop                        ( true                                  )

                                    :draw( function( s, w, h )
                                        design.blur( s, 15 )
                                        design.rbox( 4, 0, 0, w, h, clr_box_ol )
                                        state, r, g, b, a   = design.rgb( state, r, g, b, a )
                                        design.obox_th( 5, 5, w - 10, h - 10, Color( r, g, b, a ), 2 )
                                    end )

    /*
        title
    */

    local title                     = ui.new( 'pnl', obj                    )
    :top                            ( 'm', 0, sz_hdr_p_t, 0, 0              )
    :tall                           ( title_h                               )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( title, fnt_title, w / 2, h / 2, clr_header, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
        body
    */

    local body                      = ui.new( 'pnl', obj                    )
    :nodraw                         (                                       )
    :fill                           ( 'm', 0, 0, 0, 10                      )

    /*
        label > countdown
    */

    local l_cd                      = ui.new( 'lbl', body                   )
    :fill                           ( 'm', 0, 0, 0, 5                       )
    :notext                         (                                       )
    :align                          ( 5                                     )
    :font                           ( fn_cd                                 )
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
                l_cd:SetFont( fn_status )
            end
        end
    end
    rhook.new.gmod( 'Think', 'rlib_design_notice_rs', logic_restart )

end

/*
    design > debug

    appears when server is placed into debug mode
*/

function design:debug( msg )

    /*
        dispatch existing
    */

    ui:dispatch( base.debug )

    /*
        declare > colors
    */

    local clr_box_ol                = rclr.Hex( '282828' )
    local clr_box_n                 = rclr.Hex( '232323' )
    local clr_header                = rclr.Hex( 'E06B6B' )
    local clr_img                   = rclr.Hex( 'FFFFFF', 1 )
    local clr_txt_cntdown           = rclr.Hex( 'FFFFFF' )
    local state, r, g, b, a         = 0, 0, 0, 0, 100

    /*
        font
    */

    local fnt_title                  = pref( 'design_debug_title' )
    local fn_status                 = pref( 'design_debug_status' )
    local fn_countdown              = pref( 'design_debug_cntdown' )

    /*
        scale
    */

    local rfs_w                     = rfs.w( )
    local rfs_h                     = rfs.h( )
    local sz_hdr_p_t                = ( 15 * rfs_h ) or 15

    /*
        declare > title
    */

    local title                     = helper.ok.str     ( title ) or ln( 'debug_push_status_enabled' )
    local title_w, title_h          = helper.str:len    ( title, fnt_title )

    /*
        declare > msg
    */

    local msg                       = ln( 'debug_push_title' )
    local _m                        = helper.str:crop   ( msg, 290 * rfs_w, fn_status )
    local msg_w, msg_h              = helper.str:len    ( _m, fn_status )

    /*
        declare > interface
    */

    local sz_w                      = ( ( title_w < msg_w ) and msg_w ) or title_w
    sz_w                            = sz_w + ( 100 * rfs_w )
    sz_w                            = calc.min( 250 * rfs_w, sz_w )
    local sz_h                      = 20 + msg_h + title_h + ( 25 * rfs.h( ) )

    /*
        parent
    */

    local obj                       = ui.new( 'pnl'                         )
    :sz                             ( sz_w, sz_h                            )
    :pos                            ( ScrW( ) / 2 - ( sz_w / 2 ), -sz_h     )
    :drawtop                        ( true                                  )

                                    :draw( function( s, w, h )
                                        design.blur( s, 15 )
                                        design.rbox( 4, 0, 0, w, h, clr_box_ol )
                                        state, r, g, b, a   = design.rgb( state, r, g, b, a )
                                        design.obox_th( 5, 5, w - 10, h - 10, Color( r, g, b, a ), 2 )
                                    end )

                                    :logic( function( s )
                                        if not base:g_Debug( ) then
                                            ui:dispatch( base.debug )
                                        end
                                    end )

    /*
        title
    */

    local title                     = ui.new( 'pnl', obj                    )
    :top                            ( 'm', 0, sz_hdr_p_t, 0, 0              )
    :tall                           ( title_h                               )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( msg, fnt_title, w / 2, h / 2, clr_header, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
        body
    */

    local body                      = ui.new( 'pnl', obj                    )
    :nodraw                         (                                       )
    :fill                           ( 'm', 0, 0, 0, 20 * rfs_h              )

    /*
        label > countdown
    */

    local l_cd                      = ui.new( 'lbl', body                   )
    :fill                           ( 'm', 0, 0, 0, 0                       )
    :notext                         (                                       )
    :align                          ( 5                                     )
    :font                           ( fn_countdown                          )
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
            resp            = timex.cleantime( resp )

            l_cd:SetText    ( resp )

            if resp == ln( 'debug_bc_disabling' ) then
                l_cd:SetFont( fn_status )
            end
        end
    end
    rhook.new.gmod( 'Think', 'rlib_design_notice_debug', logic_debug )

end

/*
    design > animted scrolling text
*/

function design.anim_scrolltext( text, uid, src, font, clr, dist, atime )
    if not isstring( text ) then return end

    uid                 = uid or helper.new.id( 10 )
    src                 = istable( src ) and src or { }
    font                = font or pref( 'design_draw_textscroll' )
    clr                 = IsColor( clr ) and clr or clr_white
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
    design > animted scrolling text
*/

function design.anim_tscroll( text, uid, src, fnt, clr, dist, atime )
    if not isstring( text ) then return end

    uid                     = uid or helper.new.id( 10 )
    src                     = istable( src ) and src or { }
    fnt                     = fnt or pref( 'design_draw_textscroll' )
    clr                     = IsColor( clr ) and clr or clr_white
    dist                    = isnumber( dist ) and dist or 0.5
    atime                   = isnumber( atime ) and atime or 2

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
    design > rsay
*/

function design.rsay( msg, clr, dur, fade )
    msg                 = msg or 'missing msg'
    clr                 = clr or clr_white
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