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
*   PANEL
*/

local PANEL = { }

/*
*   Init
*/

function PANEL:Init( )

    /*
    *	declarations
    */

    self:Declarations( )

    /*
    *   scrollbar
    */

    self.slider                     = ui.new( 'grip', self                  )
    :box                            ( Color( 255, 255, 255, 20 )            )

    /*
    *   parent
    */

    self                            = ui.get( self                          )
    :size                           ( 4                                     )
    :param                          ( 'SetAlwaysVisible', false             )

end

/*
*   SetEnabled
*/

function PANEL:SetEnabled( b )
    if not b then
        self.Offset         = 0
        self:SetScroll      ( 0 )
        self.HasChanged     = true
    end

    self:SetMouseInputEnabled( b )

    if not self:GetAlwaysVisible( ) then
        ui:setvisible( self, b )
    end

    if self.Enabled ~= b then
        self:GetParent( ):InvalidateLayout( )

        if self:GetParent( ).OnScrollbarAppear then
            self:GetParent( ):OnScrollbarAppear( )
        end
    end

    self.Enabled = b
end

/*
*   GetEnabled
*/

function PANEL:GetEnabled( )
    return self.Enabled
end

/*
*   Value
*/

function PANEL:Value( )
    return self.Pos
end

/*
*   BarScale
*/

function PANEL:BarScale( )
    if self.BarSize == 0 then return 1 end
    return self.BarSize / ( self.CanvasSize + self.BarSize )
end

/*
*   set up
*
*   @param  : int sz_bar
*   @param  : int sz_canvas
*/

function PANEL:SetUp( sz_bar, sz_canvas )
    self.BarSize            = sz_bar
    self.CanvasSize         = math.max( sz_canvas - sz_bar, 1 )

    self:SetEnabled         ( sz_canvas > sz_bar )

    self:InvalidateLayout   ( )
end

/*
*   OnMouseWheeled
*/

function PANEL:OnMouseWheeled( dlta )
    if not self:IsVisible( ) then return false end

    return self:AddScroll( dlta * -2 )
end

/*
*   AddScroll
*/

function PANEL:AddScroll( dlta )
    local old               = self:GetScroll( )
    dlta                    = dlta * 25

    self:SetScroll          ( self:GetScroll( ) + dlta )

    return old ~= self:GetScroll( )
end

/*
*   SetScroll
*/

function PANEL:SetScroll( scrll )
    if not self.Enabled then self.Scroll = 0 return end

    self.Scroll = math.Clamp( scrll, 0, self.CanvasSize + ( self.elastic_i or 65 ) )
    self:InvalidateLayout( )

    local func = self:GetParent( ).OnVScroll
    if func then
        func( self:GetParent( ), self:GetOffset( ) )
    else
        self:GetParent( ):InvalidateLayout( )
    end
end

/*
*   LimitScroll
*/

function PANEL:LimitScroll( )
    if ( self.Scroll > self.CanvasSize ) or ( self.Scroll < 0 ) then
        self.Scroll = math.Clamp( self.Scroll, -self.clamp, self.CanvasSize + self.clamp )
    end
end

/*
*   AnimateTo
*/

function PANEL:AnimateTo( scrll, len, delay, ease )
    local anim              = self:NewAnimation( len, delay, ease )
    anim.StartPos           = self.Scroll
    anim.TargetPos          = scrll
    anim.Think = function( anim, pnl, frac )
        pnl:SetScroll( Lerp( frac, anim.StartPos, anim.TargetPos ) )
    end
end

/*
*   GetScroll
*/

function PANEL:GetScroll( )
    if not self.Enabled then self.Scroll = 0 end
    return self.Scroll
end

/*
*   GetOffset
*/

function PANEL:GetOffset( )
    if not self.Enabled then return 0 end
    return self.Scroll * -1
end

/*
*   OnMousePressed
*/

function PANEL:OnMousePressed( )
    local _, y              = self:CursorPos( )
    local sz_page           = self.BarSize

    self:SetScroll          ( ( y > self.slider.y and self:GetScroll( ) + sz_page ) or self:GetScroll( ) - sz_page )
end

/*
*   OnMouseReleased
*/

function PANEL:OnMouseReleased( )
    self.Dragging           = false
    self.DraggingCanvas     = nil
    self:MouseCapture       ( false )

    self.slider.Depressed   = false
end

/*
*   OnCursorMoved
*/

function PANEL:OnCursorMoved( x, y )
    if not self.Enabled then return end
    if not self.Dragging then return end

    local _, y              = self:ScreenToLocal( 0, gui.MouseY( ) )
    y                       = y - self.HoldPos

    local sz_track          = self:GetTall( ) - self.slider:GetTall( )
    y                       = y / sz_track

    self:SetScroll          ( math.Clamp( y * self.CanvasSize, 0, self.CanvasSize ) )
end

/*
*   Grip
*/

function PANEL:Grip( )
    if not self.Enabled then return end
    if self.BarSize == 0 then return end

    self:MouseCapture       ( true )
    self.Dragging           = true

    local _, y              = self.slider:ScreenToLocal( 0, gui.MouseY( ) )
    self.HoldPos            = y

    self.slider.Depressed   = true
end

/*
*   PerformLayout
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:PerformLayout( w, h )

    /*
    *   initialize only
    */

    if not self.bInitialized then
        self.elastic_i      = self:GetbElastic( ) and 65 or 0

        self.bInitialized   = true
    end

    /*
    *   limit scrolling
    */

    self:LimitScroll( )

    /*
    *   calculate sizes
    */

    local sz_w              = self:GetWide( )
    local sz_btn_h          = sz_w
    local sz_scroll         = self:GetScroll( ) / self.CanvasSize
    local sz_bar            = 20
    local sz_track          = self:GetTall( ) - ( sz_btn_h * 2 ) - sz_bar
    sz_track                = sz_track + 1
    sz_scroll               = sz_scroll * sz_track

    local pos_h             = sz_btn_h + sz_scroll
    local pos_h_oset        = self:GetTall( ) - 20
    self.slider:SetPos      ( 0, math.Clamp( pos_h, 0, pos_h_oset ) )
    self.slider:SetSize     ( sz_w, sz_bar )
end

/*
*   Think
*/

function PANEL:Think( )
    if self:GetbForceAlpha( ) then
        self.Alpha          = 255
    end
end

/*
*   Paint
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:Paint( w, h )
    return true
end

/*
*   SetAlwaysVisible
*
*   sets if scrollbar will always be visible, even if
*   not enough content to scroll
*
*   @param  : bool b
*/

function PANEL:SetAlwaysVisible( b )
    self.bAlwaysVisible = helper:val2bool( b )
end

/*
*   GetAlwaysVisible
*
*   @return : bool
*/

function PANEL:GetAlwaysVisible( )
    return self.bAlwaysVisible or false
end

/*
*   SetbElastic
*
*   determines if scrollbar will use elastic scrolling
*
*   @param  : bool b
*/

function PANEL:SetbElastic( b )
    self.bElastic = helper:val2bool( b )
end

/*
*   GetbElastic
*
*   returns if scrollbar will use elastic scrolling
*
*   @return : bool
*/

function PANEL:GetbElastic( )
    return self.bElastic or false
end

/*
*   SetbForceAlpha
*
*   forces alpha for particular panels
*   should only be utilized in cirsumtances like
*   rlib konsole
*
*   @param  : bool b
*/

function PANEL:SetbForceAlpha( b )
    self.bForceAlpha = helper:val2bool( b )
end

/*
*   GetbForceAlpha
*
*   @return : bool
*/

function PANEL:GetbForceAlpha( )
    return self.bForceAlpha
end

/*
*   Rehash
*
*   resets initialization
*/

function PANEL:Rehash( )
    self.bInitialize = false
end

/*
*   Declarations
*
*   all definitions associated to this panel
*/

function PANEL:Declarations( )

    /*
    *   declare > general
    */

    self.bInitialized               = false
    self.Offset                     = 0
    self.Scroll                     = 0
    self.CanvasSize                 = 1
    self.BarSize                    = 1
    self.clamp                      = 100

end

/*
*   register
*/

vgui.Register( 'rlib.ui.sbar.v3', PANEL, 'DPanel' )
vgui.Register( 'rlib.elm.sb.v3', PANEL, 'DPanel' )