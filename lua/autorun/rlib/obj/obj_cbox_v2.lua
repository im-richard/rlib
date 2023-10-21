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
    localization > misc
*/

local cfg                   = base.settings
local mf                    = base.manifest

/*
    declarations
*/

local state, r, g, b, a     = 0, 0, 0, 0, 255

/*
    PANEL
*/

local PANEL = { }

/*
    Init
*/

function PANEL:Init( )

    /*
        declarations
    */

    self                            = ui.get( self                          )
    :setup                          (                                       )
    :sz                             ( 50, 40                                )
    :cur                            ( 'hand'                                )
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
*
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
    local cvar              = self:GetCVar( )
    self.val                = not cvar:GetBool( )

    cvar:SetBool            ( self.val )
end

/*
    PerformLayout
*/

function PANEL:PerformLayout( )

    /*
        initialize only
    */

    if not self.bInitialized then
        self:FirstRun( )
    end

    self:SetWide( self:GetWidth( ) )
    self:SetTall( self:GetHeight( ) )
end

/*
    Paint

    @param  : int w
    @param  : int h
*/

function PANEL:Paint( w, h )
    state, r, g, b          = design.rgb( state, r, g, b )
    local clr_main          = self.hover and self:GetClrBGHover( ) or self:GetClrBG( )
    local clr_togg_n        = ( self:bEnabled( ) and self:GetClrEnabled( ) ) or self:GetClrDisabled( )

    if ( self:bEnabled( ) and self:GetRGB( ) ) then
        clr_togg_n          = Color( r, g, b, 255 )
    end

    local clr_togg_h        = self.clr_togg_h

    design.rbox( 8, 0, 0, w, h, clr_main )

    local sz_bullet_h       = h / 3
    local i_smooth          = 30
    local i_pad             = 13

    if self:bEnabled( ) then
        design.circle( w - i_pad, ( h / 2 ) + ( sz_bullet_h / 2 ) - ( sz_bullet_h / 2 ), sz_bullet_h, i_smooth, clr_togg_n )
        if self.hover then
            design.circle( w - i_pad, ( h / 2 ) + ( sz_bullet_h / 2 ) - ( sz_bullet_h / 2 ), sz_bullet_h, i_smooth, clr_togg_h )
        end
    else
        design.circle( i_pad, ( h / 2 ) + ( sz_bullet_h / 2 ) - ( sz_bullet_h / 2 ), sz_bullet_h, i_smooth, clr_togg_n )
        if self.hover then
            design.circle( i_pad, ( h / 2 ) + ( sz_bullet_h / 2 ) - ( sz_bullet_h / 2 ), sz_bullet_h, i_smooth, clr_togg_h )
        end
    end
end

/*
    cvar > set

    @param  : str cvar
*/

function PANEL:SetCVar( cvar )
    self.cvar = cvar
end

/*
    cvar > get

    @return : str
*/

function PANEL:GetCVar( )
    return self.cvar
end

/*
    width > set

    @param  :   int             i
*/

function PANEL:SetWidth( i )
    self.sz_w = i
end

/*
    width > get

    @return :   int
*/

function PANEL:GetWidth( )
    return self.sz_w or 50
end

/*
    height > set

    @param  :   int             i
*/

function PANEL:SetHeight( i )
    self.sz_h = i
end

/*
    height > get

    @return :   int
*/

function PANEL:GetHeight( )
    return self.sz_h or 40
end

/*
    background > color > set

    @param  :   clr             clr
*/

function PANEL:SetClrBG( clr )
    self.clr_bg_n = clr
end

/*
    background > color > get

    @param  :   clr             clr
*/

function PANEL:GetClrBG( )
    return self.clr_bg_n or self.clr_main_n
end

/*
    background > normal > color > set

    @param  :   clr             clr
*/

function PANEL:SetClrBGHover( clr )
    self.clr_bg_h = clr
end

/*
    background > hover > color > get

    @param  :   clr             clr
*/

function PANEL:GetClrBGHover( )
    return self.clr_bg_h or self.clr_main_h
end

/*
    enabled > color > set

    @param  :   clr             clr
*/

function PANEL:SetClrEnabled( clr )
    self.clr_enabled = clr
end

/*
    enabled > color > get

    @param  :   clr             clr
*/

function PANEL:GetClrEnabled( )
    return self.clr_enabled or self.clr_togg_e
end

/*
    disabled > color > set

    @param  :   clr             clr
*/

function PANEL:SetClrDisabled( clr )
    self.clr_disabled = clr
end

/*
    disabled > color > get

    @param  :   clr             clr
*/

function PANEL:GetClrDisabled( )
    return self.clr_disabled or self.clr_togg_n
end

/*
    rgb > set

    @param  :   clr             clr
*/

function PANEL:SetRGB( b )
    self.bRgb = helper:val2bool( b )
end

/*
    rgb > get

    @param  :   clr             clr
*/

function PANEL:GetRGB( )
    return self.bRgb or false
end



/*
    Declarations
*/

function PANEL:_Declare( )
    self.bInitialized               = false
end

/*
    colorize
*/

function PANEL:_Colorize( )
    self.clr_main_n                 = rclr.Hex( 'FFFFFF', 5 )
    self.clr_main_h                 = rclr.Hex( 'FFFFFF', 9 )
    self.clr_togg_n                 = rclr.Hex( 'bd3567' )
    self.clr_togg_e                 = rclr.Hex( '6788d6' )
    self.clr_togg_h                 = rclr.Hex( 'FFFFFF', 30 )
end

/*
    register
*/

vgui.Register( 'rlib.ui.cbox.v2', PANEL, 'EditablePanel' )