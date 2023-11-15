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
        clr = rclr.Hex( clr )
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
    self.clr_bg                     = rclr.Hex( 'FFFFFF' )
    self.clr_togg_y                 = rclr.Hex( 'FA0A5A' )
    self.clr_togg_y_h               = rclr.Hex( '000000', 200 )
    self.clr_togg_n_h               = rclr.Hex( '000000', 200 )
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