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
local access                = base.a
local helper                = base.h
local design                = base.d
local ui                    = base.i

/*
*   loalization > misc
*/

local mf                    = base.manifest
local prefix                = mf.prefix
local cfg                   = base.settings

/*
    language
*/

local function lang( ... )
    return base:lang( ... )
end

/*
*    fonts
*/

surface.CreateFont( prefix .. 'overlay.exit',           { size = 24, weight = 800, antialias = true, font = 'Roboto' } )
surface.CreateFont( prefix .. 'overlay.title',          { size = 16, weight = 600, antialias = true, font = 'Roboto Light' } )

/*
*   PANEL
*/

local PANEL = { }

/*
*   AccessorFunc
*/

AccessorFunc( PANEL, 'm_bDraggable', 'Draggable', FORCE_BOOL )

/*
*   initialize
*/

function PANEL:Init( )

    /*
    *   sizing
    */

    local pnl_w, pnl_h              = ScrW( ), ScrH( )
    local ui_w, ui_h                = pnl_w, pnl_h

    /*
    *   parent pnl
    */

    self:SetSize                    ( ui_w, ui_h                            )
    self:DockPadding                ( 2, 34, 2, 3                           )
    self:MakePopup                  (                                       )
    self:SetTitle                   ( ''                                    )
    self:SetSizable                 ( false                                 )
    self:ShowCloseButton            ( false                                 )
    self:SetScreenLock              ( true                                  )
    self:SetPaintShadow             ( true                                  )

    /*
    *   misc vars
    */

    self.title                      = ''

    /*
    *   display parent :: static || animated
    */

    self:SetPos( ( ScrW( ) / 2 ) - ( ui_w / 2 ), ( ScrH( ) / 2 ) - (  ui_h / 2 ) )

    /*
    *   titlebar
    */

    self.lblTitle = vgui.Create( 'DLabel', self )
    self.lblTitle:SetText( '' )
    self.lblTitle:SetFont( prefix .. 'overlay.title' )
    self.lblTitle:SetColor( Color( 255, 255, 255, 255 ) )
    self.lblTitle.Paint = function( s, w, h ) end

    /*
    *   close button
    *
    *   to overwrite existing properties from the skin; do not change this buttons name to anything other
    *   than btnClose otherwise it wont inherit position/size properties
    */

    self.btnClose = vgui.Create( 'DButton', self )
    self.btnClose:SetText( '' )
    self.btnClose:SetTooltip( lang( 'tooltip_close' ) )
    self.btnClose.OnCursorEntered = function( s ) s.hover = true end
    self.btnClose.OnCursorExited = function( s ) s.hover = false end
    self.btnClose.DoClick = function( s )
        self:Destroy( )
    end
    self.btnClose.Paint = function( s, w, h )
        local clr_txt = s.hover and Color( 200, 55, 55, 255 ) or Color( 237, 237, 237, 255 )
        draw.SimpleText( '', prefix .. 'overlay.exit', w / 2, h / 2 + 4, clr_txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

end

/*
*   GetTitle
*/

function PANEL:GetTitle( )
    return self.title or ''
end

/*
*   SetTitle
*/

function PANEL:SetTitle( strTitle )
    self.lblTitle:SetText( '' )
    self.title = strTitle or ''
end

/*
*   Think
*/

function PANEL:Think( )
    self.BaseClass.Think( self )

    if ( input.IsKeyDown( KEY_ESCAPE ) or gui.IsGameUIVisible( ) ) and not self:GetNoDestroy( ) then self:Destroy( ) end

    local mousex = math.Clamp( gui.MouseX( ), 1, ScrW( ) - 1 )
    local mousey = math.Clamp( gui.MouseY( ), 1, ScrH( ) - 1 )

    if self.Dragging then
        local x = mousex - self.Dragging[ 1 ]
        local y = mousey - self.Dragging[ 2 ]

        if self:GetScreenLock( ) then
            x = math.Clamp( x, 0, ScrW( ) - self:GetWide( ) )
            y = math.Clamp( y, 0, ScrH( ) - self:GetTall( ) )
        end

        self:SetPos( x, y )
    end

    if self.Sizing then
        local x = mousex - self.Sizing[ 1 ]
        local y = mousey - self.Sizing[ 2 ]
        local px, py = self:GetPos( )

        if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > ScrW( ) - px and self:GetScreenLock( ) ) then x = ScrW( ) - px end
        if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > ScrH( ) - py and self:GetScreenLock( ) ) then y = ScrH( ) - py end

        self:SetSize( x, y )
        self:SetCursor( 'sizenwse' )
        return
    end

    if ( self.Hovered and self.m_bSizable and mousex > ( self.x + self:GetWide( ) - 20 ) and mousey > ( self.y + self:GetTall( ) - 20 ) ) then
        self:SetCursor( 'sizenwse' )
        return
    end

    if ( self.Hovered and self:GetDraggable( ) and mousey < ( self.y + 24 ) ) then
        self:SetCursor( 'sizeall' )
        return
    end

    self:SetCursor( 'arrow' )

    if self.y < 0 then self:SetPos( self.x, 0 ) end

    if ui:ok( self ) then
        self:MoveToBack( )
    end

    if not IsValid( self:GetAttach( ) ) then
        self:Destroy( )
    end

end

/*
*   OnMousePressed
*/

function PANEL:OnMousePressed( )
    if ( self.m_bSizable and gui.MouseX( ) > ( self.x + self:GetWide( ) - 20 ) and gui.MouseY( ) > ( self.y + self:GetTall( ) - 20 ) ) then
        self.Sizing =
        {
            gui.MouseX( ) - self:GetWide( ),
            gui.MouseY( ) - self:GetTall( )
        }
        self:MouseCapture( true )
        return
    end

    if ( self:GetDraggable( ) and gui.MouseY( ) < ( self.y + 24 ) ) then
        self.Dragging =
        {
            gui.MouseX( ) - self.x,
            gui.MouseY( ) - self.y
        }
        self:MouseCapture( true )
        return
    end
end

/*
*   OnMouseReleased
*/

function PANEL:OnMouseReleased( )
    self.Dragging = nil
    self.Sizing = nil
    self:MouseCapture( false )
end

/*
*   PerformLayout
*/

function PANEL:PerformLayout( )
    local titlePush = 0
    self.BaseClass.PerformLayout( self )

    self.lblTitle:SetPos( 11 + titlePush, 7 )
    self.lblTitle:SetSize( self:GetWide( ) - 25 - titlePush, 20 )
end

/*
*   Paint
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:Paint( w, h )
    design.blur( self, 10 )
    local clr_box = Color( 15, 15, 15, 200 )
    design.box( 0, 0, w, h, Color( clr_box.r, clr_box.g, clr_box.b, clr_box.a ) )
end

/*
*   GetNoDestroy
*
*   @return : bool
*/

function PANEL:GetNoDestroy( )
    return self.bNoDestroy or false
end

/*
*   NoDestroy
*
*   @param  : bool b
*/

function PANEL:NoDestroy( b )
    self.bNoDestroy = helper:val2bool( b )
end

/*
*   GetAttach
*/

function PANEL:GetAttach( )
    return self.pnl_attached
end

/*
*   Attach
*/

function PANEL:Attach( pnl )
    self.pnl_attached = pnl
end

/*
*   ActionShow
*/

function PANEL:ActionShow( )
    self:SetMouseInputEnabled( true )
    self:SetKeyboardInputEnabled( true )
end

/*
*   Destroy
*/

function PANEL:Destroy( )
    ui:destroy( self, true, true )
end

/*
*   SetState
*
*   @param  : bool bVisible
*/

function PANEL:SetState( bVisible )
    if bVisible then
        ui:show( self, true )
    else
        ui:hide( self, true )
    end
end

/*
*   register
*/

derma.DefineControl( 'rlib.ui.overlay', 'rlib overlay', PANEL, 'DFrame' )