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
*   localization > misc
*/

local cfg                   = base.settings
local mf                    = base.manifest
local pf                    = mf.prefix

/*
*   fonts
*/

surface.CreateFont( pf .. 'ui.slider.hovertip', { font = 'Roboto', size = 20, weight = 100, antialias = true } )

/*
*   PANEL
*/

local PANEL = { }

/*
*   AccessorFunc
*/

AccessorFunc( PANEL, 'm_iMin',          'Min'           )
AccessorFunc( PANEL, 'm_iMax',          'Max'           )
AccessorFunc( PANEL, 'm_iRange',        'Range'         )
AccessorFunc( PANEL, 'm_iValue',        'Value'         )
AccessorFunc( PANEL, 'm_iDecimals',     'Decimals'      )
AccessorFunc( PANEL, 'm_fFloatValue',   'FloatValue'    )

/*
*   initialize
*/

function PANEL:Init( )
    self:SetMin             ( 2 )
    self:SetMax             ( 10 )
    self:SetDecimals        ( 0 )

    local minVal            = self:GetMin( )
    self.Dragging           = true
    self.Knob.Depressed     = true
    self.KnobColor          = Color( 255, 255, 255, 255 )

    self:SetValue           ( minVal )
    self:SetSlideX          ( self:GetFraction( ) )

    self.Dragging           = false
    self.Knob.Depressed     = false
    self.Knob:SetSize       ( 12, 16 )

    function self.Knob:Paint( w, h )
        draw.RoundedBox( 4, 1, ( h / 2 ) - ( ( h - 5 ) / 2 ) + 3, w - 2, h - 5, self:GetParent( ):GetKnobColor( ) )
    end
end

/*
*   SetMinMax
*
*   @param int min
*   @param int max
*/

function PANEL:SetMinMax( min, max )
    self:SetMin( min )
    self:SetMax( max )
end

/*
*   SetValue
*/

function PANEL:SetValue( value )
    value = math.Round( math.Clamp( tonumber( value ) or 0, self:GetMin( ), self:GetMax( ) ), self.m_iDecimals )

    self.m_iValue = value

    self:SetFloatValue( value )
    self:OnValueChanged( value )
    self:SetSlideX( self:GetFraction( ) )

    function self.Knob:DoClick( s )
        SetClipboardText( value )
    end
end

/*
*   GetFraction
*/

function PANEL:GetFraction( )
    return ( self:GetFloatValue( ) -self:GetMin( ) ) / self:GetRange( )
end

/*
*   GetRange
*/

function PANEL:GetRange( )
    return self:GetMax( ) - self:GetMin( )
end

/*
*   TranslateValues
*
*   @param int x
*   @param int y
*/

function PANEL:TranslateValues( x, y )
    self:SetValue( self:GetMin( ) + ( x * self:GetRange( ) ) )
    return self:GetFraction( ), y
end

/*
*   OnValueChanged
*/

function PANEL:OnValueChanged( value ) end

/*
*   GetKnobColor
*/

function PANEL:GetKnobColor( )
    return self.KnobColor or Color( 255, 255, 255, 255 )
end

/*
*   SetKnobColor
*
*   @param clr clr
*/

function PANEL:SetKnobColor( clr )
    self.KnobColor = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
end

/*
*   GetBarColor
*/

function PANEL:GetBarColor( )
    return self.BarColor or Color( 255, 255, 255, 100 )
end

/*
*   SetBarColor
*
*   @param clr clr
*/

function PANEL:SetBarColor( clr )
    local color = IsColor( clr ) and clr or Color( 255, 255, 255, 100 )
    self.BarColor = color
end

/*
*   Paint
*
*   @param int w
*   @param int h
*/

function PANEL:Paint( w, h )
    local barcolor = self:GetBarColor( )
    design.obox( 0, ( h / 2 ) - ( 2 / 2 ) + 3, w, 2, Color( 0, 0, 0, 0 ), barcolor )
end

/*
*   PaintOver
*
*   @param int w
*   @param int h
*/

function PANEL:PaintOver( w, h )
    if ( self.Hovered or self.Knob.Hovered or self.Knob.Depressed ) and self:GetValue( ) and isnumber( self:GetValue( ) ) then
        surface.DisableClipping( true )
        draw.SimpleText( self:GetValue( ), pf .. 'ui.slider.hovertip', self.Knob.x + self.Knob:GetWide( ) / 2, self.Knob.y - 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        surface.DisableClipping( false )
    end
end

derma.DefineControl( 'rlib.ui.slider.v1', 'rlib slider', PANEL, 'DSlider' )
derma.DefineControl( 'rlib.ui.slider', 'rlib slider', PANEL, 'DSlider' )