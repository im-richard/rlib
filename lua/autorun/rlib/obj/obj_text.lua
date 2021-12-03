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
*   loalization > misc
*/

local mf                    = base.manifest
local cfg                   = base.settings

/*
    prefix
*/

local function pref( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and base.manifest.prefix ) or false
    return base.get:pref( str, state )
end

/*
*	panels
*/

local PANEL = { }

/*
*	init
*/

function PANEL:Init( )

    /*
    *	parent
    */

    self:DockMargin                 ( 0, 0, 0, 0                            )

    /*
    *	scroll
    */

    self.Scroll                     = ui.new( 'rlib.elm.sp.v2', self        )
    :fill                           (                                       )
    :param                          ( 'SetbElastic', true                   )
    :param                          ( 'SetGripColor', self:GetGripColor( )  )
    :param                          ( 'SetAlwaysVisible', true )

end

/*
*   data > set
*
*   @param  : str txt
*/

function PANEL:SetData( txt, ir )

    /*
    *   data > define
    */

    local content                   = self:SetContent( txt )
    local clr                       = self:GetTextColor( )
    local font                      = self:GetFont( )
    ir                              = isnumber( ir ) and ir or 0

    /*
    *   data > container
    */

    self.ct                         = ui.new( 'pnl', self.Scroll, 1         )
    :fill                           (                                       )

    /*
    *   data > entry
    */

    self.entry                      = ui.new( 'entry', self.ct              )
    :fill                           ( 'm', 0, 0, ir, 0                      )
    :text                           ( self.content                          )
    :mline                          ( true                                  )
    :drawbg                         ( false                                 )
    :enabled                        ( true                                  )
    :font                           ( font                                  )
    :textclr                        ( clr                                   )
    :canedit                        ( false                                 )

end

/*
*   FirstRun
*/

function PANEL:FirstRun( )
    if ui:ok( self.Scroll ) then
        self.Scroll:SetAlwaysVisible( self:GetAlwaysVisible( ) )
    end

    self.bInitialized = true
end

/*
*   HoverFill
*
*   animation to make buttons appear as if they are being filled
*   with color when player hovers over
*
*   @param  : pnl s
*   @param  : int w
*   @param  : int h
*   @param  : clr clr
*/

function PANEL:HoverFill( s, w, h, clr )
    local x, y, fw, fh = 0, 0, math.Round( w * s.OnHoverFill ), h
    design.box( x, y, fw - 10, fh, clr )
end

/*
*   PerformLayout
*
*   welcome to the hackiest way of screwing with a DTextEntry and
*   that stupid vscrollbar.
*
*   working on something more 'offical' with a new dtextentry element.
*   kinda see why developers dont really try to "reinvent it" now.
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:PerformLayout( w, h )

    /*
    *   initialize only
    */

    if not self.bInitialized then
        self:FirstRun( )
        return
    end

    /*
    *   calc sizes
    */

    surface.SetFont( self:GetFont( ) )

    local a, b              = helper.str:crop( self:GetContent( ), self:GetWide( ), self:GetFont( ) )

    local text_w, text_h    = surface.GetTextSize( a )
    text_h                  = text_h + self:GetOffsetTall( )

    self.ct:SetTall( text_h )
end

/*
*   GetOffsetTall
*
*   @return : int
*/

function PANEL:GetOffsetTall( )
    return isnumber( self.oset_h ) and self.oset_h or 0
end

/*
*   SetOffsetTall
*
*   @param  : int i
*/

function PANEL:SetOffsetTall( i )
    self.oset_h = i
end

/*
*   GetFont
*
*   @return : str
*/

function PANEL:GetFont( )
    return isstring( self.font ) and self.font or pref( 'elm_text' )
end

/*
*   SetFont
*
*   @param  : str str
*/

function PANEL:SetFont( str )
    self.font = str
end

/*
*   GetTextColor
*
*   @return : clr
*/

function PANEL:GetTextColor( )
    return IsColor( self.clr_txt ) and self.clr_txt or Color( 255, 255, 255, 255 )
end

/*
*   SetTextColor
*
*   @param  : clr clr
*/

function PANEL:SetTextColor( clr )
    self.clr_txt = clr
end

/*
*   SetGripColor
*
*   defines the slider ( grip ) color for scrollbar
*
*   @param  : clr clr
*/

function PANEL:SetGripColor( clr )
    self.clr_grip = IsColor( clr ) and clr or cfg.elm.clrs.sbar_grip_v2
end

/*
*   GetGripColor
*
*   returns current scrollbar slider ( grip ) color
*
*   @return : clr
*/

function PANEL:GetGripColor( )
    return IsColor( self.clr_grip ) and self.clr_grip or cfg.elm.clrs.sbar_grip_v2
end

/*
*   SetContent
*
*   @param  : str
*/

function PANEL:SetContent( str )
    self.content = str
end

/*
*   GetContent
*
*   @return : str
*/

function PANEL:GetContent( )
    return self.content
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
*   Paint
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:Paint( w, h ) end

/*
*	register
*/

vgui.Register( 'rlib.elm.text', PANEL )