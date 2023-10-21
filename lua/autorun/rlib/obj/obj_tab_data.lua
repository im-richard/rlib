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

/*
    prefix
*/

local function pref( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and mf.prefix ) or false
    return base.get:pref( str, state )
end

/*
*	panel
*/

local PANEL = { }

/*
*	init
*/

function PANEL:Init( )

    /*
    *	declarations
    */

    self:Declarations( )

    /*
    *	parent
    */

    self:DockMargin                 ( 0, 0, 0, 0                            )
end

/*
*	get type
*
*	@param	: str elm
*   @return : str
*/

function PANEL:GetType( elm )

    local types =
    {
        [ 'txt' ]    		        = 'entry',
        [ 'dtext' ]    		        = 'entry',
        [ 'entry' ]    		        = 'entry',
        [ 'lbl' ]      		        = 'lbl',
        [ 'label' ]     	        = 'lbl',
        [ 'html' ]       	        = 'html',
        [ 'htm' ]       	        = 'html',
    }

    return types[ elm ] or 'txt'

end

/*
*	set data
*
*	@param	: str txt
*	@param	: str elm
*/

function PANEL:SetData( txt, elm , clr )

    /*
    *	validate
    */

    if not txt then return end

    /*
    *	declare
    */

    local clr_txt                   = IsColor( clr ) and clr or self:GetTextColor( ) or Color( 255, 255, 255, 255 )
    local font                      = self:GetFont( )

    /*
    *	element > get
    */

    local element 	                = self:GetType( elm )
    self.data 	                    = ui.new( element, self )
    :nodraw                         ( )

    /*
    *	element > label
    */

    if element == 'lbl' then
        self.data 				    = ui.get( self.data 			        )
        :font						( font 	                                )
        :clr						( clr_txt 		                        )
        :wrap						( true							        )
        :text						( txt						            )
        :autoverticle				( true							        )

        return
    end

    /*
    *	element > entry
    */

    if element == 'entry' then
        self.data 				    = ui.new( 'rlib.elm.text', self         )
        :nodraw                     (                                       )
        :fill                       (                                       )
        :param                      ( 'SetTextColor', clr_txt               )
        :param                      ( 'SetFont', font                       )
        :param                      ( 'SetData', txt                        )
        :param                      ( 'SetAlwaysVisible', self:GetAlwaysVisible( ) )

        return
    end

    /*
    *	element > html
    */

    if element == 'html' then
        txt = [[
            <header>
                <link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Open%20Sans&display=swap'>

                <style>
                    body 						{ margin: 0; padding: 0; overflow: visible; color: rgb( ]] .. clr_txt.r .. [[, ]] .. clr_txt.g .. [[, ]] .. clr_txt.b .. [[ ); font-family: "Open Sans", sans-serif; font-size: 13px; }
                    .container 					{ width: 96%; height: 100%; }
                    ::-webkit-scrollbar 		{ width: 6px; }
                    ::-webkit-scrollbar-track 	{ background: none; }
                    ::-webkit-scrollbar-thumb 	{ background: rgb( 190, 78, 78 ); border-radius: 10px; }
                    a 							{ color: rgb( 190, 78, 78 ); }

                    h1, h2, h3, h4, h5, h6 		{ margin: 5px 0px 0px 0px; }
                    img							{ margin: 5px 0px 0px 0px; display: block; width: 100%; height: auto; }

                    ul 							{ margin-left: 10px; margin-top: 5px; padding-left: 20px; }
                    ul > li 					{ margin-left: 0px; padding-left: 0px; }
                    ul > li > ul 				{ margin-left: 0px; }

                    .d-block 					{ display: block; }
                    .d-none 					{ display: none; }

                    .mt-5 						{ margin-top: 5px; }
                    .mt-10 						{ margin-top: 10px; }
                    .pt-5 						{ padding-top: 5px; }
                    .pt-10 						{ padding-top: 10px; }
                </style>
            </header>
            <body>
                <div class="container">
                    ]] .. txt .. [[
                </div>
            </body>
        ]]

        self.data:SetHTML( txt )
    end

end

/*
*	PerformLayout
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:PerformLayout( w, h )
    if not ui:ok( self.data ) then return end
    self.data:SetSize( w, h )
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
*   SetFont
*
*   @param  : clr clr
*/

function PANEL:SetTextColor( clr )
    self.clr_txt = clr
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
*   Declarations
*
*   all definitions associated to this panel
*/

function PANEL:Declarations( )

    /*
    *   declare > general
    */

    self.bInitialize                = false

end

/*
*	register
*/

vgui.Register( 'rlib.ui.tab.data', PANEL )