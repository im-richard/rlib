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
    language
*/

local function lang( ... )
    return base:lang( ... )
end

/*
    prefix
*/

local function pref( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and mf.prefix ) or false
    return base.get:pref( str, state )
end

/*
*   panel
*/

local PANEL = { }

/*
*   StructureMsg
*/

function PANEL:StructureMsg( str )

    if not isstring( str ) then return '' end

    str         = str:Replace( '[VERSION]',     rlib.get:ver2str( mf.version ) )
    str         = str:Replace( '[LIB]',         mf.name )

    str         = str:upper( )

    return str

end

/*
*   Init
*/

function PANEL:Init( )

    /*
    *   localizations
    */

    local expire, exists, create = timex.expire, timex.exists, timex.create

    local rand              = math.random
    local count             = table.Count
    local msgs              = cfg.welcome.ticker.msgs
    local delay             = cfg.welcome.ticker.delay
    local clr               = cfg.welcome.ticker.clr
    local speed             = cfg.welcome.ticker.speed

    /*
    *   parent
    */

    self:Dock                   ( FILL                          )

    /*
    *   declarations
    */

    self.bInitialized           = false
    self.results                = rand( count( msgs ) )
    self.selected               = msgs[ self.results ]

    local entry                 = self:StructureMsg( self.selected )

    /*
    *   ticker
    */

    self.ticker                 = ui.new( 'lbl', self           )
    :static                     ( TOP                           )
    :margin                     ( 0, 0, 0                       )
    :textadv                    ( clr, pref( 'welcome_ticker' ), entry, true )

                                :think( function( s )
                                    if not self.bInitialized then
                                        expire( 'rlib_ticker' )
                                    end

                                    if exists( 'rlib_ticker' ) then return end

                                    self.bInitialized = true
                                    create( 'rlib_ticker', delay or 10, 0, function( )
                                        if not self.results then return end

                                        self.results = ( isnumber( self.results ) and self.results + 1 ) or 1
                                        if ( self.results > count( msgs ) ) then self.results = 1 end
                                        if not ui:ok( self ) or not ui:ok( s ) then return end

                                        local lbl   = msgs[ self.results ]
                                        lbl         = self:StructureMsg( lbl )
                                        s:AlphaTo( 0, speed, 0, function( )
                                            s:Dock              ( TOP                       )
                                            s:DockMargin        ( 0, 0, 0, 0               )
                                            s:SetText           ( lbl                       )
                                            s:SetFont           ( pref( 'welcome_ticker' )  )
                                            s:SizeToContents    (                           )
                                            s:SetColor          ( clr                       )
                                            s:AlphaTo           ( 255, speed, 0, function( ) end )
                                        end )
                                    end )
                                end )

end

/*
*   Paint
*
*   @param  : int w
*   @param  : int h
*/

function PANEL:Paint( w, h ) end

/*
*   DefineControl
*/

derma.DefineControl( 'rlib.ui.ticker', 'rlib ticker', PANEL, 'EditablePanel' )