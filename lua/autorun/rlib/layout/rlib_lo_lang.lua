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
local cvar                  = base.v

local cfg                   = base.settings

/*
    language
*/

local function ln( ... )
    return base:lang( ... )
end

/*
    prefix ids
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and base.manifest.prefix ) or false
    return base.get:pref( str, state )
end

/*
    panel
*/

local X = { }

/*
    accessorfunc
*/

AccessorFunc( X, 'm_bDraggable', 'Draggable', FORCE_BOOL )

/*
    _Declare
*/

function X:_Declare( )
    self._w, self._h                = 450 * rfs.w( ), 200 * rfs.h( )
    self.sz_min                     = 0.85
    self.sz_desc                    = 70 * rfs.h( )
    self.sz_cbo_h                   = 43 * rfs.h( )
    self.sz_hdr_h                   = 40 * rfs.h( )
end

/*
    _Call
*/

function X:_Call( )
    self.cv_lang                    = cvar:GetStr( 'rlib_language' )
    self.cv_lang_hu                 = cfg.langlst[ self.cv_lang ] or self.cv_lang

    /*
        localized declarations
    */

    self.bIsPopulated               = false
    self.bNoFocus                   = false

end

/*
    _Colorize
*/

function X:_Colorize( )
    self.clr_cbo_box_h              = rclr.Hex( 'FFFFFF', 2 )
    self.clr_cbo_item_n             = rclr.Hex( '191919' )
    self.clr_cbo_item_h             = rclr.Hex( 'FFFFFF', 2 )
    self.clr_cbo_txt_n              = rclr.Hex( '#FFFFFF' )

    self.clr_cbo_box_n_o            = rclr.Hex( '434343' )
    self.clr_cbo_box_n_i            = rclr.Hex( '141414' )

    self.clr_box_body               = rclr.Hex( '282828' )
    self.clr_box_header             = rclr.Hex( '1e1e1e' )
    self.clr_box_outline            = rclr.Hex( '4a4a4a', 255 )
    self.clr_btn_exit_n             = rclr.Hex( 'ededed' )
    self.clr_btn_exit_h             = rclr.Hex( 'c83737' )
    self.clr_txt                    = rclr.Hex( 'FFFFFF' )
    self.clr_title                  = rclr.Hex( 'f9456a' )
    self.clr_ico                    = rclr.Hex( 'f9456a' )
    self.clr_dt_txt                 = rclr.Hex( '#FFFFFF' )
    self.clr_dt_cur                 = rclr.Hex( '#e31d6e' )
    self.clr_dt_hli                 = rclr.Hex( '#9b2052' )
end

/*
    initialize
*/

function X:Init( )

    /*
        parent pnl
    */

    self                            = ui.get( self                          )
    :setup                          (                                       )
    :shadow                         ( true                                  )
    :sz                             ( self._w, self._h                      )
    :wmin                           ( self._w * self.sz_min                 )
    :hmin                           ( self._h * self.sz_min                 )
    :popup                          (                                       )
    :notitle                        (                                       )
    :canresize                      ( false                                 )
    :showclose                      ( false                                 )
    :scrlock                        ( true                                  )
    :padding                        ( 2, 34, 2, 3                           )
    :anim_fadein                    (                                       )

    /*
        titlebar
    */

    self.lblTitle                   = ui.new( 'lbl', self                   )
    :notext                         (                                       )
    :font                           ( pid( 'elm_hdr_title' )                )
    :clr                            ( self.clr_title                        )

                                    :draw( function( s, w, h )
                                        draw.SimpleText( helper.get:utf8( 'title' ), pid( 'elm_hdr_icon' ), 0, h / 2, self.clr_ico, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                        draw.SimpleText( self:GetEpithet( ), pid( 'elm_hdr_title' ), 28, h / 2 + 2, self.clr_title, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                                    end )

    /*
        close button

        to overwrite existing properties from the skin; do not change this
        buttons name to anything other than btnClose otherwise it wont
        inherit position/size properties
    */

    self.btnClose                   = ui.obj( 'btn', self                   )
    :bsetup                         (                                       )
    :notext                         (                                       )
    :tooltip                        ( ln( 'tip_close_window' )              )
    :ocr                            ( self                                  )

                                    :draw( function( s, w, h )
                                        local clr_txt = s.hover and self.clr_btn_exit_h or self.clr_btn_exit_n
                                        draw.SimpleText( helper.get:utf8( 'close' ), pid( 'elm_hdr_exit' ), w / 2 - 5, h / 2 + 8, clr_txt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

    /*
        sub
    */

    self.sub                        = ui.obj( 'pnl', self, 1                )
    :fill                           ( 'm', 0, 10, 0                         )

    /*
        body
    */

    self.body                       = ui.obj( 'pnl', self.sub, 1            )
    :fill                           ( 'm', 10, 5, 10, 5                     )

    /*
        txt > body
    */

    self.dt_body                    = ui.obj( 'pnl', self.body, 1           )
    :fill                           ( 'm', 0, 5, 0, 5                       )

    /*
        txt > body > sub
    */

    self.dt_sub                     = ui.obj( 'pnl', self.dt_body, 1        )
    :fill                           ( 'm', 8, 5, 8, 5                       )

    /*
        txt > desc
    */

    self.dt_desc                    = ui.obj( 'dt', self.dt_sub             )
    :top                            ( 'm', 0                                )
    :tall                           ( self.sz_desc                          )
    :drawbg                         ( false                                 )
    :mline	                        ( true 				                    )
    :canedit                        ( true                                  )
    :txt	                        ( ln( 'lang_sel_desc' ), self.clr_txt, pid( 'lang_desc' ) )
    :drawentry                      ( self.clr_text, self.clr_cur, self.clr_hl )
    :canedit                        (                                       )

    /*
        dcbox :: languages
    */

    self.cbo_lang                   = ui.obj( 'rlib.ui.cbo', self.dt_sub    )
    :top                            ( 'm', 0, 3, 0, 3                       )
    :tall                           ( self.sz_cbo_h                         )
    :val                            ( self.cv_lang_hu                       )
    :font                           ( pid( 'lang_item' )                    )
    :param                          ( 'SetOptionHeight', 32                 )
    :param                          ( 'SetDefault', 'en'                    )
    :param                          ( 'SetConvar', 'rlib_language'          )

                                    :draw( function( s, w, h )
                                        design.rbox( 4, 0, 0, w, h, self.clr_cbo_box_n_o )

                                        local clr_box = self.clr_cbo_box_n_i
                                        design.rbox( 4, 1, 1, w - 2, h - 2, clr_box )

                                        if s.hover then
                                            design.box( 0, 0, w, h, self.clr_cbo_box_h )
                                        end

                                        s:SetFont       ( pid( 'lang_cbo_sel' ) )
                                        s:SetTextColor  ( self.clr_cbo_txt_n    )
                                        s:SetTextInset  ( 10, 0                 )
                                    end )

    /*
        dcbox :: populate values
    *
        will display all available languages based on the translations provided
        only shows the language itself, which is only valid if in a table structure
    */

    local sel_langs = { }
    for k, v in SortedPairs( rcore.modules, false ) do
        if not v.language then continue end
        for t, l in SortedPairs( v.language, false ) do
            if not istable( l ) then continue end
            sel_langs[ t ] = t
        end
    end

    for i in helper.get.data( sel_langs ) do
        local lang = cfg.langlst[ i ] or i
        self.cbo_lang:AddChoice( lang, i )
    end
end

/*
    Think
*/

function X:Think( )
    self.BaseClass.Think( self )

    self.allow_resize = self:GetSizable( ) or false

    /*
        check focus and react accordingly
        if console is open and interface doesnt have focus, mouse cursor can disappear and make the
        activating player stuck. setting populated false will wait for dialog to have focus again and
        then make cursor re-appear
    */

    if input.IsKeyDown( KEY_ESCAPE ) or gui.IsGameUIVisible( ) then
        self.bIsPopulated = false
        self:ActionHide( )
        return
    end

    /*
        initial population
    */

    if not self.bIsPopulated then
        self:ActionShow( )
        self.bIsPopulated = true
    end

    self:MoveToFront( )

    local mousex = math.Clamp( gui.MouseX( ), 1, ScrW( ) - 1 )
    local mousey = math.Clamp( gui.MouseY( ), 1, ScrH( ) - 1 )

    if self.Dragging then
        local x         = mousex - self.Dragging[ 1 ]
        local y         = mousey - self.Dragging[ 2 ]
        local pos_s     = 0

        local clamping =
        {
            x = 0,
            y = ScrH( ) - self:GetTall( ),
        }

        if self:GetScreenLock( ) then
            x = math.Clamp( x, 0, ScrW( ) - self:GetWide( ) )
            y = math.Clamp( y, pos_s, clamping.y )
        end

        self:SetPos( x, y )
    end

    if self.Sizing then
        local x         = mousex - self.Sizing[ 1 ]
        local y         = mousey - self.Sizing[ 2 ]
        local px, py    = self:GetPos( )

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

    if ( self.Hovered and self:GetDraggable( ) and mousey < ( self.y + 24 + self.sz_hdr_h ) ) then
        self:SetCursor( 'sizeall' )
        return
    end

    self:SetCursor( 'arrow' )

    if self.y < 0 then self:SetPos( self.x, 0 ) end

end

/*
    OnMousePressed
*/

function X:OnMousePressed( )
    if ( self.m_bSizable and gui.MouseX( ) > ( self.x + self:GetWide( ) - 20 ) and gui.MouseY( ) > ( self.y + self:GetTall( ) - 20 ) ) then
        self.Sizing =
        {
            gui.MouseX( ) - self:GetWide( ),
            gui.MouseY( ) - self:GetTall( )
        }
        self:MouseCapture( true )
        return
    end

    if ( self:GetDraggable( ) and gui.MouseY( ) < ( self.y + self.sz_hdr_h ) ) then
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
    OnMouseReleased
*/

function X:OnMouseReleased( )
    self.Dragging   = nil
    self.Sizing     = nil
    self:MouseCapture( false )
end

/*
    PerformLayout
*/

function X:PerformLayout( )
    local pos = 0
    self.BaseClass.PerformLayout( self )

    self.lblTitle:SetPos    ( 15 + pos, 0 )
    self.lblTitle:SetSize   ( self:GetWide( ) - 25 - pos, self.sz_hdr_h + 4 )
    self.btnClose:SetSize   ( 29, 29 )
    self.btnClose:SetPos    ( self:GetWide( ) - 40 , 2 )
end

/*
    Paint
*/

function X:Paint( w, h )

    /*
        background blur
    */

    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )

    /*
        interface
    */

    design.rbox_adv( 4, 0, 0, w, h, self.clr_box_outline, true, true, true, true )
    design.rbox( 4, 4, 4, w - 8, h - 8, self.clr_box_body )
    design.rbox_adv( 4, 6, 6, w - 12, self.sz_hdr_h, self.clr_box_header, true, true, false, false )
end

/*
    epithet > set

    @param      :   str         str
*/

function X:SetEpithet( str )
    self.epithet_name = str
    self.lblTitle:SetText( '' )
end

/*
    epithet > get

    @return     :   str
*/

function X:GetEpithet( )
    return ( not helper.str:isempty( self.epithet_name ) and self.epithet_name ) or ln( 'lang_sel_title' )
end

/*
    ActionHide
*/

function X:ActionHide( )
    self:SetMouseInputEnabled( false )
    self:SetKeyboardInputEnabled( false )
end

/*
    ActionShow
*/

function X:ActionShow( )
    self:SetMouseInputEnabled( true )
    self:SetKeyboardInputEnabled( true )
end

/*
    Destroy
*/

function X:Destroy( )
    ui:destroy( self, true, true )
end

/*
    SetState
*
    @param  : bool bVisible
*/

function X:SetState( b )
    if b then
        ui:show( self, true )
        self:ActionShow( )
    else
        ui:hide( self, true )
        self:ActionHide( )
    end
end

/*
    register
*/

vgui.Register( 'rlib.lo.language', X, 'DFrame' )