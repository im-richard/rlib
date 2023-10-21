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

/*
    fonts
*/

surface.CreateFont( 'rlib_ui_slider_hovertip', { font = 'Roboto', size = 19, weight = 400, antialias = true } )

/*
    PANEL
*/

local PANEL = { }

/*
    AccessorFunc
*/

AccessorFunc( PANEL, 'm_iMin',          'Min'           )
AccessorFunc( PANEL, 'm_iMax',          'Max'           )
AccessorFunc( PANEL, 'm_iRange',        'Range'         )
AccessorFunc( PANEL, 'm_iValue',        'Value'         )
AccessorFunc( PANEL, 'm_iDecimals',     'Decimals'      )
AccessorFunc( PANEL, 'm_fFloatValue',   'FloatValue'    )

/*
    initialize
*/

function PANEL:Init( )

    self                            = ui.get( self                          )
    :setup                          (                                       )
    :minmax                         ( 1, 10                                 )
    :dec                            ( 0                                     )
    :val                            ( self:GetMin( )                        )
    :slide_x                        ( self:GetFraction( )                   )
    :knobstate                      ( false                                 )

    function self.Knob:Paint( w, h )
        local par                   = self:GetParent( )
        par.sz_bullet_h             = h / par:GetKnobSize( )

        design.circle( w - par.i_pad, ( h / 2 ) + ( par.sz_bullet_h / 2 ) - ( par.sz_bullet_h / 2 ), par.sz_bullet_h, self.i_smooth, par:GetKnobColor( ) or Color( 255, 255, 255, 255 ) )
    end
end

/*
    SetMinMax

    @param  : int min
    @param  : int max
*/

function PANEL:SetMinMax( min, max )
    self:SetMin( min )
    self:SetMax( max )
end

/*
    SetValue
*/

function PANEL:SetValue( val )
    val                     = math.Round( math.Clamp( tonumber( val ) or 0, self:GetMin( ), self:GetMax( ) ), self.m_iDecimals )
    self.m_iValue           = val

    self:SetFloatValue      ( val )
    self:OnValueChanged     ( val )
    self:SetSlideX          ( self:GetFraction( ) )

    function self.Knob:DoClick( s )
        SetClipboardText( val )
    end
end

/*
    GetFraction
*/

function PANEL:GetFraction( )
    return ( self:GetFloatValue( ) -self:GetMin( ) ) / self:GetRange( )
end

/*
    GetRange
*/

function PANEL:GetRange( )
    return self:GetMax( ) - self:GetMin( )
end

/*
    TranslateValues

    @param  : int x
    @param  : int y
*/

function PANEL:TranslateValues( x, y )
    self:SetValue( self:GetMin( ) + ( x * self:GetRange( ) ) )
    return self:GetFraction( ), y
end

/*
    OnValueChanged
*/

function PANEL:OnValueChanged( val ) end

/*
    GetKnobColor
*/

function PANEL:GetKnobColor( )
    return self.KnobColor or self.clr_knob_i
end

/*
    SetKnobColor

    @param  : clr clr
*/

function PANEL:SetKnobColor( clr )
    self.KnobColor = IsColor( clr ) and clr or self.clr_knob_i
end

/*
    GetBarColor
*/

function PANEL:GetBarColor( )
    return self.BarColor or self.clr_bar
end

/*
    SetBarColor

    @param  : clr clr
*/

function PANEL:SetBarColor( clr )
    local color = IsColor( clr ) and clr or self.clr_bar
    self.BarColor = color
end

/*
    size > set

    @param  :   int             i
*/

function PANEL:SetKnobSize( i )
    self.sz_knob = i
end

/*
    width > get

    @return :   int
*/

function PANEL:GetKnobSize( )
    return self.sz_knob or 3
end

/*
    bar height > set

    @param  :   int             i
*/

function PANEL:SetBarHeight( i )
    self.sz_bar = i
end

/*
    bar height > get

    @return :   int
*/

function PANEL:GetBarHeight( )
    return self.sz_bar or 2
end

/*
    Paint

    @param  : int w
    @param  : int h
*/

function PANEL:Paint( w, h )
    local barcolor  = self:GetBarColor( )
    local sz_bar_h  = self:GetBarHeight( )

    design.obox( 0, ( h / 2 ) - sz_bar_h, w, sz_bar_h, barcolor, barcolor )
end

/*
    PaintOver

    @param  : int w
    @param  : int h
*/

function PANEL:PaintOver( w, h )
    if ( self.Hovered or self.Knob.Hovered or self.Knob.Depressed ) and self:GetValue( ) and isnumber( self:GetValue( ) ) then
        self.sz_bullet_h            = h / self:GetKnobSize( )
        surface.DisableClipping     ( true )
        draw.SimpleText             ( self:GetValue( ), 'rlib_ui_slider_hovertip', self.Knob.x + ( self.Knob:GetWide( ) / 2 ) - ( self.Knob:GetWide( ) / 2 ), self.Knob.y - ( self.Knob:GetTall( ) ) - 5, self.clr_text_h, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        surface.DisableClipping     ( false )
    end
end

/*
    declare
*/

function PANEL:_Declare( )
    self.i_smooth                   = 30
    self.i_pad                      = 13
    self.sz_bullet_h                = 0
end

/*
    colorize
*/

function PANEL:_Colorize( )
    self.clr_knob_o                 = rclr.Hex( 'FFFFFF' )
    self.clr_knob_i                 = rclr.Hex( 'FFFFFF' )
    self.clr_bar                    = rclr.Hex( 'FFFFFF' )
    self.clr_text_h                 = rclr.Hex( 'FFFFFF' )
end

/*
    register
*/

derma.DefineControl( 'rlib.ui.slider.v2', 'rlib slider', PANEL, 'DSlider' )