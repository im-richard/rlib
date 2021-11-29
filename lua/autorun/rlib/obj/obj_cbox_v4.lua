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
    standard tables and localization
*/

local base                  = rlib
local helper                = base.h
local design                = base.d
local ui                    = base.i
local cvar                  = base.v

/*
    PANEL
*/

local PANEL = { }

/*
    Initialize
*/

function PANEL:Init( )
    self                            = ui.get( self                          )
    :setup                          (                                       )
    :sz                             ( 40, 15                                )
    :cursor                         ( 'hand'                                )
end

/*
    FirstRun
*/

function PANEL:FirstRun( )
    if ui:ok( self ) then
        self:RequestFocus( )
    end

    self.bInitialized = true
end

/*
    bEnabled

    @return : bool
*/

function PANEL:bEnabled( )
    return self:GetCVar( ):GetBool( )
end

/*
    OnMousePressed
*/

function PANEL:OnMousePressed( )
    surface.PlaySound( 'ui/buttonclick.wav' )

    self:onOptionChanged( )
end

/*
    onOptionChanged
*/

function PANEL:onOptionChanged( )
    local cv                = self:GetCVar( )
    self.val                = not cv:GetBool( )

    cv:SetBool              ( self.val )
end

/*
    PerformLayout
*/

function PANEL:PerformLayout( )
    if not self.bInitialized then
        self:FirstRun( )
    end
end

/*
    Paint

    @param  : int w
    @param  : int h
*/

function PANEL:Paint( w, h )
    local clr_togg_h        = self:bEnabled( ) and self.clr_togg_y_h or self.clr_togg_n_h

    design.circle( ( w / 2 ), ( h / 2 ), 10, 25, self.clr_bg )

    if self:bEnabled( ) then
        design.circle( ( w / 2 ), ( h / 2 ), 9, 25, self:GetClrEnabled( ) )
    end

    if self:IsHovered( ) then
        design.circle( ( w / 2 ), ( h / 2 ), 7, 25, clr_togg_h )
    end
end

/*
    cvar > set

    @param  : str cvar
*/

function PANEL:SetCVar( cv )
    self.cvar = cv
end

/*
    cvar > get

    @return : str
*/

function PANEL:GetCVar( )
    return self.cvar
end

/*
    enabled > color > set

    @param  : clr clr
*/

function PANEL:SetClrEnabled( clr )
    if helper:clr_ishex( clr ) then
        clr = Hex( clr )
    end

    self.clr_enabled = clr
end

/*
    enabled > color > get

    @return : clr
*/

function PANEL:GetClrEnabled( )
    return self.clr_enabled or self.clr_togg_y
end

/*
    Colorize
*/

function PANEL:_Colorize( )
    self.clr_bg                     = Hex( 'FFFFFF' )
    self.clr_togg_y                 = Hex( 'FA0A5A' )
    self.clr_togg_y_h               = Hex( '000000', 200 )
    self.clr_togg_n_h               = Hex( '000000', 200 )
end

/*
    Deckare
*/

function PANEL:_Declare( )
    self.bInitialized               = false
end

/*
    register
*/

vgui.Register( 'rlib.ui.cbox.v4', PANEL, 'EditablePanel' )