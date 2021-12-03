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

/*
*   PANEL
*/

local PANEL = { }

/*
*   Init
*/

function PANEL:Init( )
    self:Declarations( )

    self:SetSize    ( 40, 15 )
    self:SetCursor  ( 'hand' )
    self.enabled    = false
end

/*
*   FirstRun
*/

function PANEL:FirstRun( )
    if ui:ok( self ) then
        self:RequestFocus( )
    end

    self.bInitialized = true
end

/*
*   IsEnabled
*
*   @return : bool
*/

function PANEL:IsEnabled( )
    return ( ( self.enabled == 1 or tostring( self.enabled ) == 'true' ) and true ) or false
end

/*
*   OnMousePressed
*/

function PANEL:OnMousePressed( )
    surface.PlaySound( 'ui/buttonclick.wav' )

    self.enabled = not self.enabled
    self:onOptionChanged( )
end

/*
*   onOptionChanged
*/

function PANEL:onOptionChanged( ) end

/*
*   PerformLayout
*/

function PANEL:PerformLayout( )
    /*
    *   initialize only
    */

    if not self.bInitialized then
        self:FirstRun( )
    end
end

/*
*   Paint
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:Paint( w, h )
    local clr_main      = self.hover and self.clr_main_h or self.clr_main_n
    local clr_togg_n    = ( self:IsEnabled( ) and self.clr_togg_e ) or self.clr_togg_n
    local clr_togg_h    = self.clr_togg_h

    draw.RoundedBox( 8, 0, 0, w, h, clr_main )

    if self:IsEnabled( ) then
        design.circle( w - 10, 10, 7, 25, clr_togg_n )
        if self.hover then
            design.circle( w - 10, 10, 7, 25, clr_togg_h )
        end
    else
        design.circle( 10, 10, 7, 25, clr_togg_n )
        if self.hover then
            design.circle( 10, 10, 7, 25, clr_togg_h )
        end
    end
end

/*
*   Declarations
*/

function PANEL:Declarations( )

    self.bInitialized = false

    /*
    *   declare > colors
    */

    self.clr_main_n     = Color( 255, 255, 255, 5 )
    self.clr_main_h     = Color( 255, 255, 255, 9 )
    self.clr_togg_n     = Color( 214, 103, 144 )
    self.clr_togg_e     = Color( 103, 136, 214 )
    self.clr_togg_h     = Color( 255, 255, 255, 30 )
end

/*
*   DefineControl
*/

derma.DefineControl( 'rlib.ui.toggle', 'rlib toggle', PANEL, 'EditablePanel' )