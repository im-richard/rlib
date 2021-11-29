/*
*   @package        : rlib
*   @author         : Richard [http://steamcommunity.com/profiles/76561198135875727]
*   @copyright      : (C) 2018 - 2020
*   @since          : 1.0.0
*   @website        : https://rlib.io
*   @docs           : https://docs.rlib.io
*
*   MIT License
*
*   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
*   LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
*   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
*   WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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

    self:SetMin                     ( 1 )
    self:SetMax                     ( 10 )
    self:SetDecimals                ( 0 )

    self.Dragging                   = true
    self.Knob.Depressed             = true

    self:SetValue                   ( self:GetMin( ) )
    self:SetSlideX                  ( self:GetFraction( ) )

    self.Dragging                   = false
    self.Knob.Depressed             = false

    function self.Knob:Paint( w, h )
        design.circle( ( w / 2 ), ( h / 2 ) + 3, 8, 25, self:GetParent( ).clr_knob_o )
        design.circle( ( w / 2 ), ( h / 2 ) + 3, 6, 25, self:GetParent( ):GetKnobColor( ) )
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
    Paint

    @param  : int w
    @param  : int h
*/

function PANEL:Paint( w, h )
    local barcolor = self:GetBarColor( )
    design.obox( 0, ( h / 2 ) - ( 2 / 2 ) + 3, w, 2, Color( 0, 0, 0, 0 ), barcolor )
end

/*
    PaintOver

    @param  : int w
    @param  : int h
*/

function PANEL:PaintOver( w, h )
    if ( self.Hovered or self.Knob.Hovered or self.Knob.Depressed ) and self:GetValue( ) and isnumber( self:GetValue( ) ) then
        surface.DisableClipping( true )
        draw.SimpleText( self:GetValue( ), 'rlib_ui_slider_hovertip', self.Knob.x + self.Knob:GetWide( ) / 2 - 2, self.Knob.y - 10, self.clr_text_h, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        surface.DisableClipping( false )
    end
end

/*
    declare
*/

function PANEL:_Declare( )

end

/*
    colorize
*/

function PANEL:_Colorize( )
    self.clr_knob_o         = Hex( 'FFFFFF' )
    self.clr_knob_i         = Hex( 'FFFFFF' )
    self.clr_bar            = Hex( 'FFFFFF' )
    self.clr_text_h         = Hex( 'FFFFFF' )
end

/*
    register
*/

derma.DefineControl( 'rlib.ui.slider.v2', 'rlib slider', PANEL, 'DSlider' )