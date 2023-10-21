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

local base                          = rlib
local helper                        = base.h
local design                        = base.d
local ui                            = base.i
local cvar                          = base.v
local font                          = base.f
local res                           = base.resources
local cfg                           = base.settings
local mf                            = base.manifest
local pf                            = mf.prefix

/*
    language
*/

local function ln( ... )
    return base:lang( ... )
end

/*
    localize output functions
*/

local function log( ... )
    base:log( ... )
end

/*
    prefix ids
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and base.manifest.prefix ) or false
    return base.get:pref( str, state )
end

/*
    helper > predefined materials

    list of internal gmod mat paths
*/

helper._vgui =
{
    [ 'avatar' ]                    = 'AvatarImage',
    [ 'av' ]                        = 'AvatarImage',
    [ 'binder' ]                    = 'DBinder',
    [ 'bubble' ]                    = 'DBubbleContainer',
    [ 'btn']                        = 'DButton',
    [ 'catlist' ]                   = 'DCategoryList',
    [ 'cbox' ]                      = 'DCheckBox',
    [ 'cb' ]                        = 'DCheckBox',
    [ 'cat' ]                       = 'DCollapsibleCategory',
    [ 'clrcbo' ]                    = 'DColorCombo',
    [ 'clrcube' ]                   = 'DColorCube',
    [ 'clrmixer' ]                  = 'DColorMixer',
    [ 'clrpal' ]                    = 'DColorPalette',
    [ 'colsheet' ]                  = 'DColumnSheet',
    [ 'cbo' ]                       = 'DComboBox',
    [ 'file' ]                      = 'DFileBrowser',
    [ 'form' ]                      = 'DForm',
    [ 'DFrame' ]                    = 'DFrame',
    [ 'frame' ]                     = 'DFrame',
    [ 'frm' ]                       = 'DFrame',
    [ 'grid' ]                      = 'DGrid',
    [ 'dhtml' ]                     = 'DHTML',
    [ 'html' ]                      = 'HTML',
    [ 'ctrls' ]                     = 'DHTMLControls',
    [ 'dico' ]                      = 'DIconLayout',
    [ 'il' ]                        = 'DIconLayout',
    [ 'img' ]                       = 'DImage',
    [ 'label' ]                     = 'DLabel',
    [ 'lbl' ]                       = 'DLabel',
    [ 'listlayout' ]                = 'DListLayout',
    [ 'listview' ]                  = 'DListView',
    [ 'menu' ]                      = 'DMenu',
    [ 'menubar' ]                   = 'DMenuBar',
    [ 'menuopt' ]                   = 'DMenuOption',
    [ 'menucvar' ]                  = 'DMenuOptionCVar',
    [ 'model' ]                     = 'DModelPanel',
    [ 'mdl' ]                       = 'DModelPanel',
    [ 'mdlimg' ]                    = 'ModelImage',
    [ 'mdl_img' ]                   = 'ModelImage',
    [ 'mdlsel' ]                    = 'DModelSelect',
    [ 'notify' ]                    = 'DNotify',
    [ 'scratch' ]                   = 'DNumberScratch',
    [ 'wang' ]                      = 'DNumberWang',
    [ 'numslider' ]                 = 'DNumSlider',
    [ 'dpanel' ]                    = 'DPanel',
    [ 'pnl' ]                       = 'DPanel',
    [ 'dpl' ]                       = 'DPanelList',
    [ 'progress' ]                  = 'DProgress',
    [ 'prop' ]                      = 'DProperties',
    [ 'propsheet' ]                 = 'DPropertySheet',
    [ 'rgb' ]                       = 'DRGBPicker',
    [ 'spnl' ]                      = 'DScrollPanel',
    [ 'dsp' ]                       = 'DScrollPanel',
    [ 'grip' ]                      = 'DScrollBarGrip',
    [ 'autosize' ]                  = 'DSizeToContents',
    [ 'slider' ]                    = 'DSlider',
    [ 'sico' ]                      = 'SpawnIcon',
    [ 'sprite' ]                    = 'DSprite',
    [ 'tab' ]                       = 'DTab',
    [ 'entry' ]                     = 'DTextEntry',
    [ 'txt' ]                       = 'DTextEntry',
    [ 'dt' ]                        = 'DTextEntry',
    [ 'tl' ]                        = 'DTileLayout',
    [ 'tip' ]                       = 'DTooltip',
    [ 'tooltip' ]                   = 'DTooltip',
    [ 'tree' ]                      = 'DTree',
    [ 'node' ]                      = 'DTree_Node',
    [ 'treebtn' ]                   = 'DTree_Node_Button',
    [ 'div' ]                       = 'DVerticalDivider',
    [ 'vsbar' ]                     = 'DVScrollBar',
    [ 'geditable' ]                 = 'EditablePanel',
    [ 'gpnl' ]                      = 'Panel',
    [ 'material' ]                  = 'Material',
    [ 'mat' ]                       = 'Material',
    [ 'pnllist' ]                   = 'PanelList',
    [ 'rt' ]                        = 'RichText',
}

/*
    helper > ui > id preferences
*/

helper._vgui_id =
{
    [ 1 ]                           = 'DFrame',
    [ 2 ]                           = 'DPanel',
    [ 3 ]                           = 'Panel',
    [ 4 ]                           = 'EditablePanel',
}

/*
    dock definitions

    in addition to default glua enums assigned to docking,
    the following entries can be used.
*/

helper._dock =
{
    [ 'fill' ]      = FILL,
    [ 'left' ]      = LEFT,
    [ 'top' ]       = TOP,
    [ 'right' ]     = RIGHT,
    [ 'bottom' ]    = BOTTOM,

    [ 'f' ]         = FILL,
    [ 'l' ]         = LEFT,
    [ 't' ]         = TOP,
    [ 'r' ]         = RIGHT,
    [ 'b' ]         = BOTTOM,
}

/*
    interface > cvars > define

    cvars to be used throughout the interface
*/

ui.cvars =
{
    { sid = 1, stype = 'dropdown', is_visible = false,  id = 'rlib_language',           name = 'Preferred language',            desc = 'default interface language',    forceset = false, default = 'en' },
    { sid = 1, stype = 'checkbox', is_visible = true,   id = 'rlib_animations_enabled', name = 'Animations enabled',            desc = 'interface animations',          forceset = false, default = 1 },
    { sid = 2, stype = 'checkbox', is_visible = true,   id = 'console_timestamps',      name = 'Show timestamps in console',    desc = 'show timestamp in logs',        forceset = false, default = 0 },
}

/*
    uclass / assoc tables
*/

local uclass                = { }
local assoc                 = { }

/*
    metatables
*/

local dmeta                 = FindMetaTable( 'Panel' )

/*
    New Assoc

    registers each uclass function

    DCheckBox:
            1	=	novalue
            2	=	notext
            3	=	checked
            4	=	textclr
            5	=	anim_click_ol
            6	=	ochg
    DCollapsibleCategory:
            1	=	wide|oset
            2	=	enginedraw
    DFrame:
            1	=	minwide
            2	=	mintall
    DMenuBar:
            1	=	enginedraw
    _index:
            1	=	wide|oset
            2	=	minwide
            3	=	mintall
            4	=	enginedraw
*/

function ui:NewAssoc( func, types )

    local t                 = types                             // str      'DFrame:, DMenuBar'
    local pnls              = helper.str:split( t, ',%s*' )     // tbl

    /*
        1	=	DCollapsibleCategory
        2	=	DPanelList
        3	=	DPropertySheet
        4	=	DScrollPanel
    */

    for i = 1, #pnls do

        /*
            register  panel type
        */

       local pnl                = pnls[ i ]                     // DPanel or DTextEntry or ...
       assoc[ pnl ]             = assoc[ pnl ] or { }           // create panel name in assoc table

        local alias             = func
        local aliases           = helper.str:split( alias, '|%s*' )
        local cmd_1st           = aliases[ 1 ]
        for i = 1, #aliases do
            local cmd           = aliases[ i ]                  // multiple commands separated by |
            table.insert        ( assoc[ pnl ], cmd )           // insert all aliases of command into panel name table
            uclass[ cmd ]       = uclass[ cmd_1st ]
        end

        /*
            register _index

            register all panels and commands so that we have a failsafe.
        */

        assoc[ '_index' ]       = assoc[ '_index' ] or { }

        for i = 1, #aliases do
            local cmd           = aliases[ i ]
            if not table.HasValue( assoc[ '_index' ], cmd ) then
                table.insert( assoc[ '_index' ], cmd )
                uclass[ cmd ] = uclass[ cmd_1st ]
            end
        end
    end
end

/*
    ui > element

    gets the correct element based on the class provided

    @param  : str class
    @return : str
*/

function ui.element( class )
    class = helper.str:clean( class )
    return ( class and helper._vgui and helper._vgui[ class ] or class ) or false
end

/*
    ui > getscale

    @note   : deprecate
*/

function ui:GetScale( )
    return math.Clamp( ScrH( ) / 1080, 0.75, 1 )
end

/*
    ui > scale

    standard scaling

    @param  : int iclamp
    @return : int

    @note   : deprecate
*/

function ui:scale( iclamp )
    return math.Clamp( ScrW( ) / 1920, iclamp or 0.75, 1 )
end

/*
    ui > Scale640

    works similar to glua ScreenScale( )

    @param  : int val
    @param  : int iMax
    @return : int

    @note   : deprecate
*/

function ui:Scale640( val, iMax )
    iMax = isnumber( iMax ) and iMax or ScrW( )
    return val * ( iMax / 640.0 )
end

/*
    ui > controlled scale

    a more controlled solution to screen scaling because I dislike how doing simple ScreenScaling never
    makes things perfect.

    @note   : deprecate
*/

function ui:cscale( bSimple, i800, i1024, i1280, i1366, i1600, i1920, i2xxx )
    if not isbool( bSimple ) then
        log( 2, 'func [ %s ]: bSimple not bool', debug.getinfo( 1, 'n' ).name )
    end

    if not i800 then
        log( 2, 'func [ %s ]: no scale int specified', debug.getinfo( 1, 'n' ).name )
    end

    if not i1024 then i1024, i1280, i1366, i1600, i1920, i2xxx = i800, i800, i800, i800, i800, i800 end
    if not i1280 then i1280, i1366, i1600, i1920, i2xxx = i800, i800, i800, i800, i800 end
    if not i1366 then i1366, i1600, i1920, i2xxx = i1280, i1280, i1280, i1280 end
    if not i1600 then i1600, i1920, i2xxx = i1366, i1366, i1366 end
    if not i1920 then i1920, i2xxx = i1600, i1600 end
    if not i2xxx then i2xxx = i1920 end

    if ScrW( ) <= 800 then
        return bSimple and i800 or ScreenScale( i800 )
    elseif ScrW( ) > 800 and ScrW( ) <= 1024 then
        return bSimple and i1024 or ScreenScale( i1024 )
    elseif ScrW( ) > 1024 and ScrW( ) <= 1280 then
        return bSimple and i1280 or ScreenScale( i1280 )
    elseif ScrW( ) > 1280 and ScrW( ) <= 1366 then
        return bSimple and i1366 or ScreenScale( i1366 )
    elseif ScrW( ) > 1366 and ScrW( ) <= 1600 then
        return bSimple and i1600 or ScreenScale( i1600 )
    elseif ScrW( ) > 1600 and ScrW( ) <= 1920 then
        return bSimple and i1920 or ScreenScale( i1920 )
    elseif ScrW( ) > 1920 and ScrW( ) <= 2560 then
        return bSimple and i2xxx or ScreenScale( i2xxx )
    elseif ScrW( ) > 2560 then
        return bSimple and i2xxx or self:Scale640( i2xxx, 2560 )
    end
end

/*
    a more controlled solution to screen scaling because I dislike how doing simple ScreenScaling never
    makes things perfect.

    @note   : deprecate
*/

function ui:SmartScale( bSimple, i640, i800, i1024, i1280, i1366, i1600, i1920, i2xxx )
    if not isbool( bSimple ) then
        log( 2, 'func [ %s ]: bSimple not bool', debug.getinfo( 1, 'n' ).name )
    end

    if not i640 then
        log( 2, 'func [ %s ]: no scale int specified', debug.getinfo( 1, 'n' ).name )
    end

    if istable( i640 ) then
        local vals  = i640
        local a1    = vals[ 1 ] or 0
        i640, i800, i1024, i1280, i1366, i1600, i1920, i2xxx = vals[ 1 ], vals[ 2 ] or a1, vals[ 3 ] or a1, vals[ 4 ] or a1, vals[ 5 ] or a1, vals[ 6 ] or a1, vals[ 7 ] or a1, vals[ 8 ] or a1
    end

    if not i800 then i800, i1024, i1280, i1366, i1600, i1920, i2xxx = i640, i640, i640, i640, i640, i640, i640, i640 end
    if not i1024 then i1024, i1280, i1366, i1600, i1920, i2xxx = i800, i800, i800, i800, i800, i800 end
    if not i1280 then i1280, i1366, i1600, i1920, i2xxx = i800, i800, i800, i800, i800 end
    if not i1366 then i1366, i1600, i1920, i2xxx = i1280, i1280, i1280, i1280 end
    if not i1600 then i1600, i1920, i2xxx = i1366, i1366, i1366 end
    if not i1920 then i1920, i2xxx = i1600, i1600 end
    if not i2xxx then i2xxx = i1920 end

    if ScrW( ) <= 640 then
        return bSimple and i640 or ScreenScale( i640 )
    elseif ScrW( ) > 640 and ScrW( ) <= 800 then
        return bSimple and i800 or ScreenScale( i800 )
    elseif ScrW( ) > 800 and ScrW( ) <= 1024 then
        return bSimple and i1024 or ScreenScale( i1024 )
    elseif ScrW( ) > 1024 and ScrW( ) <= 1280 then
        return bSimple and i1280 or ScreenScale( i1280 )
    elseif ScrW( ) > 1280 and ScrW( ) <= 1366 then
        return bSimple and i1366 or ScreenScale( i1366 )
    elseif ScrW( ) > 1366 and ScrW( ) <= 1600 then
        return bSimple and i1600 or ScreenScale( i1600 )
    elseif ScrW( ) > 1600 and ScrW( ) <= 1920 then
        return bSimple and i1920 or ScreenScale( i1920 )
    elseif ScrW( ) > 1920 and ScrW( ) <= 2560 then
        return bSimple and i2xxx or ScreenScale( i2xxx )
    elseif ScrW( ) > 2560 then
        return bSimple and i2xxx or self:Scale640( i2xxx, 2560 )
    end
end

/*
    a more controlled solution to screen scaling because I dislike how doing simple ScreenScaling never
    makes things perfect.

    @note   : deprecate
*/

function ui:SmartScaleH( bSimple, i480, i600, i768, i864, i960, i1024, i1080, i1440 )
    if not isbool( bSimple ) then
        log( 2, 'func [ %s ]: bSimple not bool', debug.getinfo( 1, 'n' ).name )
    end

    if not i480 then
        log( 2, 'func [ %s ]: no scale int specified', debug.getinfo( 1, 'n' ).name )
    end

    if istable( i480 ) then
        local vals  = i480
        local a1    = vals[ 1 ] or 0
        i480, i600, i768, i864, i960, i1024, i1080, i1440 = vals[ 1 ], vals[ 2 ] or a1, vals[ 3 ] or a1, vals[ 4 ] or a1, vals[ 5 ] or a1, vals[ 6 ] or a1, vals[ 7 ] or a1, vals[ 8 ] or a1
    end

    if not i600 then i600, i768, i864, i960, i1024, i1080, i1440 = i480, i480, i480, i480, i480, i480, i480, i480 end
    if not i768 then i768, i864, i960, i1024, i1080, i1440 = i600, i600, i600, i600, i600, i600 end
    if not i864 then i864, i960, i1024, i1080, i1440 = i600, i600, i600, i600, i600 end
    if not i960 then i960, i1024, i1080, i1440 = i864, i864, i864, i864 end
    if not i1024 then i1024, i1080, i1440 = i960, i960, i960 end
    if not i1080 then i1080, i1440 = i1024, i1024 end
    if not i1440 then i1440 = i1080 end

    if ScrH( ) <= 480 then
        return bSimple and i480 or ScreenScale( i480 )
    elseif ScrH( ) > 480 and ScrH( ) <= 600 then
        return bSimple and i600 or ScreenScale( i600 )
    elseif ScrH( ) > 600 and ScrH( ) <= 768 then
        return bSimple and i768 or ScreenScale( i768 )
    elseif ScrH( ) > 768 and ScrH( ) <= 864 then
        return bSimple and i864 or ScreenScale( i864 )
    elseif ScrH( ) > 864 and ScrH( ) <= 960 then
        return bSimple and i960 or ScreenScale( i960 )
    elseif ScrH( ) > 960 and ScrH( ) <= 1024 then
        return bSimple and i1024 or ScreenScale( i1024 )
    elseif ScrH( ) > 1024 and ScrH( ) <= 1080 then
        return bSimple and i1080 or ScreenScale( i1080 )
    elseif ScrH( ) > 1080 and ScrH( ) <= 1440 then
        return bSimple and i1440 or ScreenScale( i1440 )
    elseif ScrH( ) > 1440 then
        return bSimple and i1440 or self:Scale640( i1440, 1440 )
    end
end

/*
    ui > ScrW( )

    @note   : deprecate
*/

function ui:ScrW( )
    local w = ScrW( )
    if w > 3840 then w = 3840 end
    return w
end

/*
    ui > ScrH( )

    @note   : deprecate
*/

function ui:ScrH( )
    local h = ScrH( )
    if h > 2160 then h = 2160 end
    return h
end

/*
    ui > GetScaleW( )

    @note   : deprecate
*/

function ui:GetScaleW( mult, min, max )
    mult            = mult or 0.4
    local calcSize  = mult * ( self:ScrW( ) / 640.0 )

    if min then
        calcSize = calc.min( min, calcSize )
    end

    if max then
        calcSize = calc.max( max, calcSize )
    end

    return calcSize
end

/*
    ui > GetScaleH( )

    @note   : deprecate
*/

function ui:GetScaleH( mult )
    mult = mult or 0.4
    return mult * ( self:ScrH( ) / 480.0 )
end

/*
    ui > iScaleW( )

    @note   : deprecate
*/

function ui:iScaleW( size, min, max, mult )
    local m         = mult or 0.4
    local scale     = self:GetScaleW( m )
    local amt       = size * scale

    if min and amt < min then
        amt = min
    end

    if max and amt > max then
        amt = max
    end

    return amt
end

/*
    ui > iScaleH( )

    @note   : deprecate
*/

function ui:iScaleH( size, min, max, mult )
    local m         = mult or 0.4
    local scale     = self:GetScaleH( m )
    local amt       = size * scale

    if min and amt < min then
        amt = min
    end

    if max and amt > max then
        amt = max
    end

    return amt
end

/*
    ui > ClampScale( )

    @note   : deprecate
*/

function ui:ClampScale( w, h )
    h = isnumber( h ) and h or w
    return math.Clamp( 1920, 0, ScrW( ) / w ), math.Clamp( 1080, 0, ScrH( ) / h )
end

/*
    ui > scalesimple( )

    @note   : deprecate
*/

function ui:scalesimple( s, m, l )
    if not m then m = s end
    if not l then l = s end

    if ScrW( ) <= 1280 then
        return s
    elseif ScrW( ) >= 1281 and ScrW( ) <= 1600 then
        return m
    elseif ScrW( ) >= 1601 then
        return l
    else
        return s
    end
end

/*
    ui > position

    returns w, h position for a specified pnl
    based on the string, int pos desired

    @ex     : ui:GetPosition( pnl, 5, 20 )
              gets pnl pos based on center-screen with padding of 20

    @param  : pnl pnl
    @param  : str, int pos
    @param  : int pad
*/

function ui:GetPosition( pnl, pos, pad )

    if not self:valid( pnl ) then return 0, 0 end

    pos                     = isnumber( pos ) and pos or isstring( pos ) and pos or 5
    pad                     = isnumber( pad ) and pad or 0

    local pnl_w, pnl_h      = pnl:GetSize( )
    local w, h              = 0, 0

    if ( pos == 't' or pos == 8 ) then
        w, h        = ScrW( ) / 2 - pnl_w / 2, pad

    elseif ( pos == 'tr' or pos == 9 ) then
        w, h        = ScrW( ) - pnl_w - 20, pad

    elseif ( pos == 'r' or pos == 6 ) then
        w, h        = ScrW( ) - pnl_w - pad, ( ( ScrH( ) / 2 ) - ( pnl_h / 2 ) )

    elseif ( pos == 'br' or pos == 3 ) then
        w, h        = ScrW( ) - pnl_w - pad, ScrH( ) - pnl_h - pad

    elseif ( pos == 'b' or pos == 2 ) then
        w, h        = ScrW( ) / 2 - pnl_w / 2, ScrH( ) - pnl_h - pad

    elseif ( pos == 'bl' or pos == 1 ) then
        w, h        = pad, ScrH( ) - pnl_h - pad

    elseif ( pos == 'l' or pos == 4 ) then
        w, h        = pad, ( ( ScrH( ) / 2 ) - ( pnl_h / 2 ) )

    elseif ( pos == 'tl' or pos == 7 ) then
        w, h        = pad, pad

    elseif ( pos == 'c' or pos == 5 ) then
        w, h        = ( ( ScrW( ) / 2 ) - ( pnl_w / 2 ) ), ( ( ScrH( ) / 2 ) - ( pnl_h / 2 ) )
    end

    return w, h

end

/*
    ui > valid

    checks validation of a panel
    uses this vs isvalid for future control

    @param  : pnl pnl
    @return : bool
*/

function ui:valid( pnl )
    if not pnl or type( pnl ) ~= 'Panel' then return false end
    if not IsValid( pnl ) then return false end
    return true
end

/*
    ui > registered

    similar to ui:valid( ); however, checks it
    as a registered rlib panel

    @ex     : ui:registered( 'pnl_root', mod )
            : ui:registered( global_panel )

    @param  : str, pnl id
    @param  : tbl mod
    @return : bool
*/

function ui:registered( id, mod )
    if not helper.str:valid( id ) or not istable( mod ) then
        return self:ok( id ) and true or false
    end

    local pnl       = self:call( id, mod )

    return self:ok( pnl ) and true or false
end

/*
    ui > update

    executes invalidatelayout if pnl valid

    @alias  : rehash, invalidate

    @param  : str, pnl id
    @param  : tbl mod
    @return : void
*/

function ui:rehash( id, mod )
    if not helper.str:valid( id ) or not istable( mod ) then
        if not self:ok( id ) then return end
        id:InvalidateLayout( )
        return
    end

    local pnl       = self:call( id, mod )
                    if not self:ok( pnl ) then return false end

    pnl:InvalidateLayout( )
end
ui.invalidate = ui.rehash

/*
    ui > clear

    clears an interface

    @param  : str, pnl id
    @param  : tbl mod
*/

function ui:clear( id, mod )
    if not helper.str:valid( id ) or not istable( mod ) then
        if not self:ok( id ) then return end
        id:Clear( )
        return
    end

    local pnl       = self:call( id, mod )
                    if not self:ok( pnl ) then return false end

    pnl:Clear( )
end

/*
    ui > close

    hides or removes the DFrame, and calls DFrame:OnClose.
    to set whether the frame is hidden or removed, use DFrame:SetDeleteOnClose.

    @param  : str, pnl id
    @param  : tbl mod
*/

function ui:close( id, mod )
    if not helper.str:valid( id ) or not istable( mod ) then
        if not self:ok( id ) then return end
        id:Close( )
        return
    end

    local pnl       = self:call( id, mod )
                    if not self:ok( pnl ) then return false end

    pnl:Close( )
end

/*
    ui > visible

    checks a panel for validation and if currently visible

    @ex     : ui:visible( 'pnl_root', mod )
            : ui:visible( global_panel )

    @param  : str, pnl id
    @param  : tbl mod
    @return : bool
*/

function ui:visible( id, mod )
    if not helper.str:valid( id ) or not istable( mod ) then
        return self:ok( id ) and id:IsVisible( ) and true or false
    end

    local pnl       = self:call( id, mod )
                    if not self:ok( pnl ) then return false end

    return pnl:IsVisible( ) and true or false
end

/*
    ui > destroy

    checks a panel for validation and then removes it completely.

    @param  : pnl pnl
    @param  : bool halt
    @param  : bool bMouse [optional]
    @param  : pnl subpanel [optional]
*/

function ui:destroy( pnl, halt, bMouse, sub )
    if sub and not self:ok( sub ) then return end
    if self:ok( pnl ) then pnl:Remove( ) end
    if bMouse then
        gui.EnableScreenClicker( false )
    end
    if halt then return false end
end

/*
    ui > destroy visible

    checks a panel for validation and visible then removes it completely.


    @ex     : ui:destroy_visible( 'pnl_root', mod )
            : ui:destroy_visible( global_panel )

    @param  : str, pnl id
    @param  : tbl mod
*/

function ui:destroy_visible( id, mod )
    if not helper.str:valid( id ) or not istable( mod ) then
        if self:ok( id ) and self:visible( id ) then
            id:Remove( )
        end
        return
    end

    local pnl       = self:call( id, mod )
                    if not self:ok( pnl ) then return false end

    if self:visible( pnl ) then
        pnl:Remove( )
    end
end

/*
    ui > hide

    checks a panel for validation and if its currently visible and then sets panel visibility to false.

    @param  : pnl pnl
    @param  : bool bMouse
*/

function ui:hide( pnl, bMouse )
    if self:ok( pnl ) then
        pnl:SetVisible( false )
        if bMouse then
            gui.EnableScreenClicker( false )
        end
    end
end

/*
    ui > autosize

    applies SizeToContents( ) to specified pnl

    @param  : str, pnl id
    @param  : tbl mod
*/

function ui:autosize( id, mod )
    if not helper.str:valid( id ) or not istable( mod ) then
        if not self:ok( id ) then return end
        id:SizeToContents( )
        return
    end

    local pnl       = self:call( id, mod )
                    if not self:ok( pnl ) then return false end

    pnl:SizeToContents( )
end

/*
    ui > hide visible

    checks a panel for validation and if its currently visible and then sets panel visibility to false.

    @param  : pnl pnl
    @param  : bool bMouse
*/

function ui:hide_visible( pnl, bMouse )
    if self:ok( pnl ) and self:visible( pnl ) then
        pnl:SetVisible( false )
        if bMouse then
            gui.EnableScreenClicker( false )
        end
    end
end

/*
    ui > show

    checks a panel for validation and if its not currently visible and then sets panel to visible.

    @param  : pnl pnl
    @param  : bool bMouse
*/

function ui:show( pnl, bMouse )
    if self:ok( pnl ) and not self:visible( pnl ) then
        pnl:SetVisible( true )
        if bMouse then
            gui.EnableScreenClicker( true )
        end
    end
end

/*
    ui > visibility flip

    determines if a panel is currently either visible or not and then flips the panel visibility status.

    providing a sub panel will check both the parent and sub for validation, but only flip the sub panel
    if the parent panel is valid.

    @param  : pnl pnl
    @param  : pnl sub
*/

function ui:visible_flip( pnl, sub )
    if not self:ok( pnl ) then return end

    if sub then
        if not self:ok( sub ) then return end
    else
        sub = pnl
    end

    if self:visible( pnl ) then
        sub:SetVisible( false )
    else
        sub:SetVisible( true )
    end
end

/*
    ui > set visible

    allows for a bool to be passed to determine if the pnl should be visible or not

    @param  : pnl pnl
    @param  : bool b
*/

function ui:setvisible( pnl, b )
    if not self:ok( pnl ) then return end
    pnl:SetVisible( helper:val2bool( b ) or false )
end

/*
    ui > setpos

    checks an obj for validation and sets its position

    @param  : pnl pnl
    @param  : int x
    @param  : int y
*/

function ui:pos( pnl, x, y )
    x = x or 0
    y = y or 0

    if not self:visible( pnl ) then return end
    pnl:SetPos( x, y )
end

/*
    ui > setpos

    checks an obj for validation and sets its position

    @param  : pnl pnl
    @param  : int x
    @param  : int y
*/

function ui:spos( id, mod, x, y )
    if not helper.str:valid( id ) or not istable( mod ) then
        return self:ok( id ) and id:IsVisible( ) and true or false
    end

    local pnl       = self:call( id, mod )
                    if not self:ok( pnl ) then return false end

    x = x or 0
    y = y or 0

    if not self:visible( pnl ) then return end
    pnl:SetPos( x, y )
end

/*
    ui > settext

    method to setting text

    @param  : pnl pnl
    @param  : str text
    @param  : str face
*/

function ui:settext( pnl, text, face )
    if not self:ok( pnl ) then return end
    text = isstring( text ) and text or ''

    if face then
        pnl:SetFont( face )
    end
    pnl:SetText( text )
end

/*
    ui > get panel

    returns the call name of a registered panel from the module's manifest file
    returns nil if not registered

    registered pnls in > base.p[ mod ][ panel_id ]

    @ex     : ui:register( 'pnl_theme', mod )

    @param  : str id
    @param  : str mod
    @return : str
*/

function ui:getpnl( id, mod )
    if not helper.str:valid( id ) then
        log( 2, ln( 'inf_reg_id_invalid' ) )
        return false
    end

    local _cache    = id

    id              = helper.str:clean( id )
    mod             = ( isstring( mod ) and mod ) or ( istable( mod ) and mod.id ) or pf
    base.p          = istable( base.p ) and base.p or { }

    local name      = res:exists( mod, 'pnl', id )

    if not name then
        return id
    end

    return name
end

/*
    ui > register panel

    creates a usable panel that may need to be accessed globally. Do not store local panels using
    this method.

    places registered pnl in > base.p[ mod ][ panel_id ]

    @ex     : ui:register( 'themes', mod, pnl_theme, 'themes pnl' )

    @param  : str id
    @param  : str mod
    @param  : pnl pnl
    @param  : str desc
*/

function ui:register( id, mod, panel, desc )
    if not helper.str:valid( id ) then
        log( 2, ln( 'inf_reg_id_invalid' ) )
        return false
    end

    id              = helper.str:clean( id )
    mod             = ( isstring( mod ) and mod ) or ( istable( mod ) and mod.id ) or pf
    base.p          = istable( base.p ) and base.p or { }

    local name      = rlib:resource( mod, 'pnl', id )

    if ui:ok( panel ) then
        base.p[ mod ] = base.p[ mod ] or { }
        base.p[ mod ][ name ] =
        {
            pnl     = panel,
            desc    = desc or ln( 'none' )
        }
        log( 6, ln( 'inf_registered', name ) )
    end
end

/*
    ui > registered > load

    loads a previously registered panel

    @ex     :       local content = ui:load( 'pnl.parent.content', 'xtask' )
                    if not content or not ui:valid( content.pnl ) then return end
                    content.pnl:Clear( )

    @param  : str id
    @param  : str, tbl mod
    @return : tbl
*/

function ui:load( id, mod )
    if not helper.str:valid( id ) then
        log( 2, ln( 'inf_load_id_invalid' ) )
        return false
    end

    id              = helper.str:clean( id )
    mod             = ( isstring( mod ) and mod ) or ( istable( mod ) and mod.id ) or pf

    local name      = rlib:resource( mod, 'pnl', id )

    if not istable( base.p ) then
        log( 2, ln( 'inf_load_tbl_invalid' ) )
        return false
    end

    if not istable( base.p[ mod ] ) or not istable( base.p[ mod ][ name ] ) then return name end
    return self:ok( base.p[ mod ][ name ].pnl ) and base.p[ mod ][ name ] or false
end

/*
    ui > registered > call panel

    calls a previously registered panel similar to ui.load
    but this validates and calls just the panel.

    @ex     :   local pnl = ui:call( id, mod )
                if not pnl then return end

    @param  : str id
    @param  : str, tbl mod
    @return : tbl
*/

function ui:call( id, mod )
    if not helper.str:valid( id ) then
        log( 2, ln( 'inf_load_id_invalid' ) )
        return false
    end

    id              = helper.str:clean( id )
    mod             = ( isstring( mod ) and mod ) or ( istable( mod ) and mod.id ) or pf

    local name      = rlib:resource( mod, 'pnl', id )

    if not istable( base.p ) then
        log( 2, ln( 'inf_load_tbl_invalid' ) )
        return false
    end

    if not istable( base.p[ mod ] ) or not istable( base.p[ mod ][ name ] ) then return end -- return nothing since invalid pnl
    return self:ok( base.p[ mod ][ name ].pnl ) and base.p[ mod ][ name ].pnl or false
end

/*
    ui > unregister panel

    removes a registered panel from the library

    @param  : str id
    @param  : str, tbl mod
*/

function ui:unregister( id, mod )
    if not helper.str:valid( id ) then
        log( 2, ln( 'inf_unreg_id_invalid' ) )
        return false
    end

    mod = isstring( mod ) and mod or pf

    if not istable( base.p ) then
        log( 2, ln( 'inf_unreg_tbl_invalid' ) )
        return false
    end

    id              = helper.str:clean( id )
    local name      = rlib:resource( mod, 'pnl', id )

    if base.p[ mod ] and base.p[ mod ][ name ] then
        base.p[ mod ][ name ] = nil
        log( 6, ln( 'inf_unregister', name ) )
    end
end

/*
    ui > create

    utilities vgui.Register as a shortcut
    used for pnls registered under the rlib:resources( ) method

    if no class provided; defaults to DFrame

    @ex     : ui:create( mod, 'bg', PANEL, 'pnl' )
            : ui:create( mod, 'bg', PANEL )
            : ui:create( mod, 'bg', PANEL, 1 )
            : ui:create( mod, 'bg', PANEL, 2 )

    @param  : tbl mod
    @param  : str id
    @param  : pnl pnl
    @param  : str, int class
*/

function ui:create( mod, id, pnl, class )
    if not id or not pnl then return end

    local call = rlib:resource( mod, 'pnl', id )

    if isnumber( class ) then
        class = helper._vgui_id[ class ]
    elseif isstring( class ) then
        class = ( class and ui.element( class ) )
    else
        class = 'DFrame'
    end

    vgui.Register( call, pnl, class )
end

/*
    ui > validate registered pnl

    determines if a registered pnl is valid

    @param  : str, pnl id
    @param  : tbl mod
    @return : bool
*/

function ui:ok( id, mod )
    if mod then
        local pnl       = self:call( id, mod )
                        if self:ok( pnl ) then return true end
    end

    if self:valid( id ) then return true end
    return ( istable( id ) and self:valid( id.pnl ) and true ) or false
end

/*
    ui > registered > dispatch

    destroys a registered pnl
    ensures a pnl is a valid pnl first

    @param  : str id
    @param  : str, tbl mod
    @param  : bool bMouse
    @return : void
*/

function ui:dispatch( id, mod, bMouse )
    if not helper.str:valid( id ) or not istable( mod ) then
        self:destroy( id )

        if bMouse then
            gui.EnableScreenClicker( false )
        end
        return
    end

    local pnl       = self:call( id, mod )
                    if not self:ok( pnl ) then return false end

    self:unregister ( id, mod )
    self:destroy    ( pnl )

    if bMouse then
        gui.EnableScreenClicker( false )
    end
end

/*
    ui > stage

    shows a registered pnl
    supports both registered and default valid panels.

    @param  : str id
    @param  : str, tbl mod
    @param  : bool bMouse
    @return : void
*/

function ui:stage( id, mod, bMouse )
    if mod then
        local pnl       = self:call( id, mod )
                        if not self:ok( pnl ) then return false end

        self:show( pnl )

        if bMouse then
            gui.EnableScreenClicker( true )
        end

        return
    end

    if not self:ok( id ) then return end

    self:show( id )
    if bMouse then
        gui.EnableScreenClicker( true )
    end
end

/*
    ui > unstage

    hides a registered pnl
    supports both registered and default valid panels.

    @param  : str id
    @param  : str, tbl mod
    @param  : bool bMouse
    @return : void
*/

function ui:unstage( id, mod, bMouse )
    if mod then
        local pnl       = self:call( id, mod )
                        if not self:ok( pnl ) then return false end

        self:hide( pnl )

        if bMouse then
            gui.EnableScreenClicker( false )
        end

        return
    end

    if not self:ok( id ) then return end

    self:hide( id )

    if bMouse then
        gui.EnableScreenClicker( false )
    end
end

/*
    ui > state

    flips the state of a panel

    @param  :   bool            b
*/

function ui:state( pnl, b, bMouse )
    local state = helper:val2bool( b )
    if state then
        ui:show( pnl )
    else
        ui:hide( pnl )
    end

    bMouse = bMouse or false
    gui.EnableScreenClicker( bMouse )
end

/*
    ui > create fonts

    creates a generic set of fonts to be used with the library

    @param  : str suffix
    @param  : str face
    @param  : bool bShadow
    @param  : int scale [ optional ]
*/

function ui:fonts_register( suffix, face, bShadow, scale )
    suffix          = isstring( suffix ) and suffix or pf
    face            = isstring( face ) and face or pid( 'ucl_font_def' )
    bShadow         = bShadow or false
    scale           = isnumber( scale ) and scale or self:scale( )

    local char_last = string.sub( suffix, -1 )

    local font_sz =
    {
        [ 12 ] = '12',
        [ 14 ] = '14',
        [ 16 ] = '16',
        [ 18 ] = '18',
        [ 20 ] = '20',
        [ 22 ] = '22',
        [ 24 ] = '24',
        [ 32 ] = '32',
        [ 36 ] = '36',
    }

    local weights =
    {
        [ 100 ] = '100',
        [ 200 ] = '200',
        [ 400 ] = '400',
        [ 600 ] = '600',
        [ 800 ] = '800',
    }

    if char_last ~= '_' then
        suffix = suffix .. '_'
    end

    for sz, sz_name in pairs( font_sz ) do
        local calc_sz   = sz * scale
        local name      = string.format( '%s%s', suffix, sz_name )
        surface.CreateFont( name, { font = face, size = calc_sz, shadow = bShadow, antialias = true } )
        for wg, wg_name in pairs( weights ) do
            name        = string.format( '%s%s_%s', suffix, sz_name, wg_name )
            surface.CreateFont( name, { font = face, size = calc_sz, weight = wg_name, shadow = bShadow, antialias = true } )
        end
    end
end

/*
    ui > html > reset
*/

function ui:html_reset( )
    return [[
        <body style='overflow: hidden; height: 100%; width: 100%; margin:0px;'> </body>
    ]]
end

/*
    ui > html > img > full

    returns an html element supporting outside images
    typically used for ui backgrounds

    @param  : tbl, str src
    @param  : bool bRand
    @return : str
*/

function ui:html_img_full( src, bRand )
    local resp = bRand and table.Random( src ) or isstring( src ) and src or false

    if not resp then
        return self:html_reset( )
    end

    return [[
		<body style='overflow: hidden; height: auto; width: auto;'>
			<img src=']] .. resp .. [[' style='position: absolute; height: 100%; width: 100%; top: 0%; left: 0%; margin: auto; object-fit: fill;'>
		</body>
    ]]
end

/*
    ui > html > img

    returns an html element supporting outside images
    typically used for ui backgrounds

    @param  : tbl, str src
    @param  : bool bRand
    @return : str
*/

function ui:html_img( src, bRand )
    local resp = ( bRand and table.Random( src ) ) or ( isstring( src ) and src ) or false

    if not resp then
        return self:html_reset( )
    end

    return [[
        <body style='overflow: hidden; height: 100%; width: 100%; margin:0px;'>
            <img width='100%' height='100%' src=']] .. resp .. [['>
        </body>
    ]]
end

/*
    ui > html > size

    returns an html element supporting outside images
    allows for specific size to be provided

    @param  : str src
    @param  : int w
    @param  : int h
    @return : str
*/

function ui:html_img_sz( src, w, h )
    local resp = isstring( src ) and src or tostring( src )
    h = isnumber( h ) and h or w
    return [[
        <body style='overflow: hidden; height: 100%; width: 100%; margin:0px;'>
            <img width=']] .. w .. [[' height=']] .. h .. [[' src=']] .. resp .. [['>
        </body>
    ]]
end

/*
    ui > html > iframe

    returns an html element supporting outside sites
    typically used for ui backgrounds / live wallpapers

    @param  : tbl, str src
    @param  : bool bRand
    @return : str
*/

function ui:html_iframe( src, bRand )
    local resp = bRand and table.Random( src ) or isstring( src ) and src
    return [[
        <body style='overflow: hidden; height: 100%; width: 100%; margin:0px;'>
            <iframe width='100%' frameborder='0' height='100%' src=']] .. resp .. [['></iframe>
        </body>
    ]]
end

/*
    ui > get > svg

    utilized for svg resources

    @param  : tbl, str src
    @param  : bool bShow
    @return : str
*/

function ui:getsvg( src, bShow )
    src = isstring( src ) and src or ''
    local display = not bShow and 'display:none;' or ''
    return [[
        <body style='overflow: hidden; height: 100%; width: 100%; margin:0px;]] .. display .. [['>
            <iframe width='100%' frameborder='0' height='100%' src=']] .. src .. [['></iframe>
        </body>
    ]]
end

/*
    ui > ondown
*/

ui.OnDown = function( s )
    return s:IsDown( )
end

/*
    ui > onhover
*/

ui.OnHover = function( s )
    return s:IsHovered( )
end

ui.OnHoverChild = function( s )
    return s:IsHovered( ) or s:IsChildHovered( )
end

/*
    ui > append Override
*/

ui.SetAppendOverwrite = function( s, fn )
    s.AppendOverwrite = fn
end

ui.ClearAppendOverwrite = function( s )
    s.AppendOverwrite = nil
end

/*
    ui classes

    credit to threebow for the idea as he utilized such a method in tdlib.
    it makes creating new panels a lot more clean thanks to metatables

    ive obviously made my own changes and taken a slightly different
    direction, but the original idea is thanks to him

    this dude is the apple to my pie; and the straw to my berry.

    @source :   https://github.com/Threebow/tdlib
*/

    /*
        uclass > Run

        @param  : str name
        @param  : func fn
    */

    function uclass.run( pnl, name, fn )
        if not name then return end
        if not isfunction( fn ) then return end

        name = pnl.AppendOverwrite or name

        local orig = pnl[ name ]
        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then
                orig( s, ... )
            end
            fn( s, ... )
        end
    end
    ui:NewAssoc         ( 'run', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > setup

        @param  : func fn
    */

    function uclass.setup( pnl, fn )
        pnl.bInitialized    = false

        if pnl._Fonts then
            pnl:_Fonts( )
        end

        if pnl._Lang then
            pnl:_Lang( )
        end

        if pnl._Declare then
            pnl:_Declare( )
        end

        if pnl._Mats then
            pnl:_Mats( )
        end

        if pnl._Colorize then
            pnl:_Colorize( )
        end

        if pnl._Call then
            pnl:_Call( )
        end

        if isfunction( fn ) then
            fn( pnl )
        end
    end
    ui:NewAssoc         ( 'setup', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > NoDraw
    */

    function uclass.nodraw( pnl )
        pnl.Paint = nil
    end
    ui:NewAssoc         ( 'nodraw', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Draw

        @param  : func fn
    */

    function uclass.draw( pnl, fn )
        if not isfunction( fn ) then return end
        uclass.nodraw( pnl )
        pnl[ 'Paint' ] = fn
    end
    ui:NewAssoc         ( 'draw', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > SaveDraw

        @param  : func fn
    */

    function uclass.savedraw( pnl )
        pnl.OldPaint = pnl.Paint
    end
    ui:NewAssoc         ( 'savedraw', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > GetDraw

        @param  : func fn
    */

    function uclass.getdraw( pnl )
        if not pnl.OldPaint then return end
        pnl[ 'Paint' ] = pnl.OldPaint
    end
    ui:NewAssoc         ( 'getdraw', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DrawManual

        @param  : bool b
    */

    function uclass.drawmanual( pnl, b )
        pnl:SetPaintedManually( helper:val2bool( b ) )
    end
    ui:NewAssoc         ( 'drawmanual', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > Name

        @param  : str name
    */

    function uclass.name( pnl, name )
        if not name then return end
        pnl:SetName( name )
    end
    ui:NewAssoc         ( 'name', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetConVar

        @param  : str id
    */

    function uclass.convar( pnl, name )
        name = isstring( name ) and name or ''
        pnl:SetConVar( name )
    end
    ui:NewAssoc         ( 'convar', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > ConVarChanged

        @param  : str val
    */

    function uclass.cvar_chg( pnl, val )
        val = isstring( val ) and val or ''
        pnl:ConVarChanged( val )
    end
    ui:NewAssoc         ( 'cvar_chg', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > ConVarNumberThink
    */

    function uclass.cvar_th_int( pnl )
        pnl:ConVarNumberThink( )
    end
    ui:NewAssoc         ( 'cvar_th_int', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > ConVarStringThink
    */

    function uclass.cvar_th_str( pnl )
        pnl:ConVarStringThink( )
    end
    ui:NewAssoc         ( 'cvar_th_str', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > convarname

        @param  : str name
    */

    function uclass.cvar( pnl, name )
        name = isstring( name ) and name or ''
        pnl.convarname = name
    end
    ui:NewAssoc         ( 'cvar', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > assign

        @param  : str id
        @param  : mix data
    */

    function uclass.assign( pnl, id, data )
        if not id then return end
        data        = data or ''
        pnl[ id ]   = data
    end
    ui:NewAssoc         ( 'assign', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > attach

        @param  : pnl child
        @param  : bool bNoDestroy
    */

    function uclass.attach( pnl, child, bNoDestroy )
        if not ui:ok( child ) then return end
        pnl:Attach( child )
        if bNoDestroy and pnl.NoDestroy then
            pnl:NoDestroy( true )
        end
    end
    ui:NewAssoc         ( 'attach', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > attach > parent

        @param  : pnl parent
        @param  : bool bNoDestroy
    */

    function uclass.attachpar( pnl, parent, bNoDestroy )
        if not ui:ok( parent ) then return end
        parent:Attach( pnl )
        if bNoDestroy and parent.NoDestroy then
            parent:NoDestroy( true )
        end
    end
    ui:NewAssoc         ( 'attachpar', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > action

        @param  : func fn
    */

    function uclass.action( pnl, fn )
        if not isfunction( fn ) then return end
        pnl:SetAction( fn )
    end
    ui:NewAssoc         ( 'action', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > slider > barcolor

        @param  : clr clr
    */

    function uclass.clr_bar( pnl, clr )
        if not clr then return end
        pnl.BarColor = clr
    end
    ui:NewAssoc         ( 'clr_bar', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > paint > over

        @param  : func fn
    */

    function uclass.drawover( pnl, fn )
        if not isfunction( fn ) then return end
        pnl[ 'PaintOver' ] = fn
    end
    ui:NewAssoc         ( 'drawover', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > paint > entry

        @param  : clr clr_text
        @param  : clr clr_cur
        @param  : clr clr_hl
    */

    function uclass.drawentry( pnl, clr_text, clr_cur, clr_hl )
        clr_text    = IsColor( clr_text ) and clr_text or Color( 255, 255, 255, 255 )
        clr_cur     = IsColor( clr_cur ) and clr_cur or Color( 150, 150, 150, 255 )
        clr_hl      = IsColor( clr_hl ) and clr_hl or Color( 25, 25, 25, 255 )

        pnl[ 'Paint' ] = function( s, w, h )
            s:SetTextColor      ( clr_text      )
            s:SetCursorColor    ( clr_cur       )
            s:SetHighlightColor ( clr_hl        )
            s:DrawTextEntryText ( s:GetTextColor( ), s:GetHighlightColor( ), s:GetCursorColor( ) )
        end
    end
    ui:NewAssoc         ( 'drawentry', 'DTextEntry' )

    /*
        uclass > paint > box

        @param  : clr clr
        @param  : int x
        @param  : int y
        @param  : int w
        @param  : int h
    */

    function uclass.box( pnl, clr, x, y, w, h )
        if isnumber( clr ) then
            clr = Color( clr, clr, clr, 255 )
        end

        clr         = rclr.Hex( clr )

        x           = isnumber( x ) and x or 0
        y           = isnumber( y ) and y or 0

        local sz_w  = w or 'f'
        local sz_h  = h or 'f'

        uclass.nodraw( pnl )
        pnl[ 'Paint' ] = function( s, w2, h2 )
            local def_w = ( ( sz_w ~= 'f' ) and sz_w ) or w2
            local def_h = ( ( sz_h ~= 'f' ) and sz_h ) or h2

            design.box( x, y, def_w, def_h, clr )
        end
    end
    ui:NewAssoc         ( 'box', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > paint > rounded box

        @param  : clr clr
        @param  : int x
        @param  : int y
        @param  : int w
        @param  : int h
    */

    function uclass.rbox( pnl, clr, r, x, y, w, h )
        clr         = ( IsColor( clr ) and clr or isnumber( clr ) and clr ) or Color( 25, 25, 25, 255 )

                    if isnumber( clr ) then
                        clr = Color( clr, clr, clr, 255 )
                    end

        r           = isnumber( r ) and r or 4
        x           = isnumber( x ) and x or 0
        y           = isnumber( y ) and y or 0

        local sz_w  = w or 'f'
        local sz_h  = h or 'f'

        uclass.nodraw( pnl )
        pnl[ 'Paint' ] = function( s, w2, h2 )
            local def_w = ( ( sz_w ~= 'f' ) and sz_w ) or w2
            local def_h = ( ( sz_h ~= 'f' ) and sz_h ) or h2

            design.rbox( r, x, y, def_w, def_h, clr )
        end
    end
    ui:NewAssoc         ( 'rbox', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > box > thick

        adds blur and a single box to the pnl paint hook

        @param  : clr clr
                  clr for box

        @param  : int th [ optional ]
                  thickness of line

        @param  : int x
        @param  : int y
        @param  : int w
        @param  : int h
    */

    function uclass.thbox( pnl, clr, th, x, y, w, h )
        clr         = ( IsColor( clr ) and clr or isnumber( clr ) and clr ) or Color( 25, 25, 25, 255 )

                    if isnumber( clr ) then
                        clr = Color( clr, clr, clr, 255 )
                    end

        th          = isnumber( th ) and th or 1
        x           = isnumber( x ) and x or 0
        y           = isnumber( y ) and y or 0

        local sz_w  = w or 'f'
        local sz_h  = h or 'f'

        uclass.nodraw( pnl )
        pnl[ 'Paint' ] = function( s, w2, h2 )
            local def_w = ( ( sz_w ~= 'f' ) and sz_w ) or w2
            local def_h = ( ( sz_h ~= 'f' ) and sz_h ) or h2

            design.obox_th( x, y, def_w, def_h, clr, th )
        end
    end
    ui:NewAssoc         ( 'thbox', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > debug > where

        applies a simple painted box to the specified element to determine
        location on the screen

        @param  : clr clr
    */

    function uclass.where( pnl, clr )
        clr = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )

        uclass.nodraw( pnl )
        pnl[ 'PaintOver' ] = function( s, w, h )
            design.box( 0, 0, w, h, clr )
        end
    end
    ui:NewAssoc         ( 'where', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > PerformLayout

        @param  : func fn
    */

    function uclass.pl( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'PerformLayout'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc             ( 'pl', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DoClick

        @param  : func fn
    */

    function uclass.oc( pnl, fn )
        if not isfunction( fn ) then return end

        local name      = 'DoClick'
        local orig      = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc                 ( 'oc', 'DButton, DComboBox, DColorPalette, DLabel, DTree, DTree_Node' )

    /*
        uclass > DoRightClick

        @param  : func fn
    */

    function uclass.orc( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'DoRightClick'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc                 ( 'orc', 'DButton, DLabel, DTree, DTree_Node' )

    /*
        uclass > DoMiddleClick

        @param  : func fn
    */

    function uclass.omc( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'DoMiddleClick'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc                 ( 'orc', 'DButton, DLabel, DTree, DTree_Node' )

    /*
        uclass > connect

        @param  : ply pl
        @param  : str ip
    */

    function uclass.connect( pnl, pl, ip )
        if not isstring( ip ) then return end
        if not helper.ok.ply( pl ) then return end

        pnl[ 'DoClick' ] = function( s, ... )
            pl:ConCommand( 'connect ' .. ip )
        end
    end
    ui:NewAssoc                 ( 'connect', 'DButton, DComboBox, DColorPalette, DLabel, DTree, DTree_Node' )

    /*
        uclass > onclick > rem

        @param  : pnl panel
        @param  : bool bHide
    */

    function uclass.ocr( pnl, panel, bHide )
        pnl[ 'DoClick' ] = function( s, ... )
            if not ui:ok( panel ) then return end
            if bHide then
                ui:hide( panel )
            else
                ui:destroy( panel )
            end
        end
    end
    ui:NewAssoc                 ( 'ocr', 'DButton, DComboBox, DColorPalette, DLabel, DTree, DTree_Node' )

    /*
        uclass > onclick > rem visible

        @param  : pnl panel
        @param  : bool bHide
    */

    function uclass.ocrv( pnl, panel, bHide )
        pnl[ 'DoClick' ] = function( s, ... )
            if not ui:ok( panel ) then return end
            if bHide then
                ui:hide( panel )
            else
                ui:destroy_visible( panel )
            end
        end
    end
    ui:NewAssoc                 ( 'ocrv', 'DButton, DComboBox, DColorPalette, DLabel, DTree, DTree_Node' )

    /*
        uclass > onclick > fade out

        @param  : pnl panel
        @param  : int delay
        @param  : bool bHide
    */

    function uclass.ocfo( pnl, panel, delay, bHide )
        pnl[ 'DoClick' ] = function( s, ... )
            if not ui:ok( panel ) then return end
            delay   = isnumber( delay ) and delay or 0.2

            panel:AlphaTo( 0, delay, 0, function( )
                if bHide then
                    ui:hide( panel )
                else
                    ui:destroy( panel )
                end
            end )
        end
    end
    ui:NewAssoc                 ( 'ocfo', 'DButton, DComboBox, DColorPalette, DLabel, DTree, DTree_Node' )

    /*
        uclass > onremove

        @param  : func fn
    */

    function uclass.orem( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'OnRemove'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc         ( 'orem', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > OnTextChanged

        @param  : func fn
    */

    function uclass.otch( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'OnTextChanged'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc         ( 'otch', 'DButton, DTextEntry' )

    /*
        uclass > OnLoseFocus

        @param  : func fn
    */

    function uclass.losefocus( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'OnLoseFocus'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc         ( 'losefocus', 'DTextEntry' )

    /*
        uclass > DTextEntry > locktxt

        supplying bNoEdit will automatically reset text each time text changed.
        used as a workaround for times when SetEditable simply doesnt work.

        @param  :   func        fn
    */

    function uclass.lockotc( pnl )
        pnl.OrigText = ( not pnl.OrigText and pnl:GetText( ) ) or pnl.OrigText

        pnl[ 'OnTextChanged' ] = function( s, ... )
            if isstring( s.OrigText ) then
                s:SetText( s.OrigText )
            end
        end
    end
    ui:NewAssoc             ( 'lockotc|txtlock', 'DTextEntry, DLabel, DLabelEditable' )

    /*
        uclass > DTextEntry > SetEditable

        @param  : bool b
    */

    function uclass.canedit( pnl, b )
        pnl:SetEditable( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'canedit', 'DTextEntry' )

    /*
        uclass > DTextEntry > No Edit
    */

    function uclass.noedit( pnl )
        pnl:SetEditable( false )
    end
    ui:NewAssoc         ( 'noedit', 'DTextEntry' )

    /*
        uclass > DTextEntry > SetEditable
    */

    function uclass.editable( pnl, b )
        local bool = helper:val2bool( b )
        pnl:SetEditable( bool )
    end
    ui:NewAssoc         ( 'editable', 'DTextEntry' )

    /*
        uclass > DTextEntry > no input

        uses AllowInput in order to restrict dtextentry text editing

        @param  : bool
    */

    function uclass.noinput( pnl )
        pnl[ 'AllowInput' ] = function( s, ... )
            return true
        end
    end
    ui:NewAssoc         ( 'noinput', 'DTextEntry' )

    /*
        uclass > DTextEntry > AllowInput

        @param  : func fn
    */

    function uclass.caninput( pnl, fn )
        local name = 'AllowInput'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc         ( 'caninput', 'DTextEntry' )

    /*
        uclass > openurl

        @param  : str uri
    */

    function uclass.openurl( pnl, uri )
        if not isstring( uri ) then return end
        pnl[ 'DoClick' ] = function( s )
            gui.OpenURL( uri )
        end
    end
    ui:NewAssoc                 ( 'openurl', 'DButton, DColorPalette, DLabel, DTree, DTree_Node' )

    /*
        uclass > OnSelect

        @param  : func fn
    */

    function uclass.osel( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'OnSelect'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc                 ( 'osel', 'DComboBox, DFileBrowser, DListView_Line, DMenu' )

    /*
        uclass > DComboBox > doclick

        @param  : func fn
    */

    function uclass.cboclick( pnl, fn )
        if not isfunction( fn ) then return end

        pnl[ 'DoClick' ] = function( s, ... )
            if s:IsMenuOpen( ) then return s:CloseMenu( ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc                 ( 'cboclick', 'DButton, DComboBox, DColorPalette, DLabel, DTree, DTree_Node' )

    /*
        uclass > DComboBox > OpenMenu

        @param  : func fn
    */

    function uclass.cbomenu( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'OpenMenu'
        pnl[ name ] = function( ... )
            fn( ... )
        end
    end
    ui:NewAssoc                 ( 'cbomenu', 'ContentHeader, ContentIcon, DComboBox, DMenuBar, SpawnIcon' )

    /*
        uclass > DTextEntry > m_bLoseFocusOnClickAway

        @param  : bool b
    */

    function uclass.ocnf( pnl, b )
        pnl.m_bLoseFocusOnClickAway = helper:val2bool( b ) or false
    end
    ui:NewAssoc                 ( 'ocnf', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > OnGetFocus

        @param  : func fn
    */

    function uclass.ogfo( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'OnGetFocus'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc         ( 'ogfo', 'DTextEntry' )

    /*
        uclass > DNum > OnValueChanged

        @param  : func fn
    */

    function uclass.ovc( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'OnValueChanged'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc         ( 'ovc', 'DColorCombo, DColorPalette, DNumberScratch, DNumberWang, DNumSlider, DSlider, DTextEntry' )

    /*
        uclass > DTextEntry > OnChange

        @param  : func fn
    */

    function uclass.ochg( pnl, fn )
        if not isfunction( fn ) then return end
        pnl[ 'OnChange' ] = fn
    end
    ui:NewAssoc         ( 'ochg', 'DAlphaBar, DBinder, DCheckBox, DCheckBoxLabel, DIconBrowser, DRGBPicker, DTextEntry' )

    /*
        uclass > onOptionChanged

        @param  : func fn
    */

    function uclass.ooc( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'onOptionChanged'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc         ( 'ooc', 'DCheckBox, DCheckBoxLabel, DComboBox, DTextEntry' )

    /*
        uclass > enabled > check

        @param  : func fn
    */

    function uclass.echk( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'enabled'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc         ( 'echk', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > onclose

        @param  : func fn
    */

    function uclass.onclose( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'OnClose'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc         ( 'onclose', 'DFrame' )

    /*
        uclass > logic

        @param  : func fn
    */

    function uclass.logic( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'Think'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc         ( 'logic', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > logic > slow

        calls 'think' but with a firing delay.
        used for calculations that dont need to happen every single tick

        either dur or fn can be the function
        dur defaults to 0.5 if actual fn not supplied

        @param  : int, func dur
        @param  : func fn
    */

    function uclass.logic_sl( pnl, dur, fn )
        if not isfunction( fn ) and not isfunction( dur ) then return end
        fn  = isfunction( fn ) and fn or isfunction( dur ) and dur
        dur = isnumber( dur ) and dur or 0.5

        local name = 'Think'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if s.nextlogic and s.nextlogic > CurTime( ) then return end
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
            s.nextlogic = CurTime( ) + dur
        end
    end
    ui:NewAssoc             ( 'logic_sl', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > logic > cast

        calls 'think' but with a firing delay.
        used for calculations that dont need to happen every single tick

        either dur or fn can be the function
        dur defaults to 0.5 if actual fn not supplied

        @param  : int, func dur
        @param  : func fn
    */

    function uclass.cast( pnl, dur, fn )
        if not isfunction( fn ) and not isfunction( dur ) then return end
        fn              = isfunction( fn ) and fn or isfunction( dur ) and dur
        dur             = isnumber( dur ) and dur or 5

        local name      = 'Think'
        local orig      = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if not s.cast_i then s.cast_i = 0 return end
            if s.cast_i > CurTime( ) then return end

            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )

            s.cast_delay            = s.bCastReady and dur or 0.1
            s.cast_i                = CurTime( ) + s.cast_delay
            s.bCastReady            = true
        end
    end
    ui:NewAssoc             ( 'cast', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DModelPanel > norotate

        forces dmodelpanel to not auto-rotate the model
    */

    function uclass.norotate( pnl )
        pnl[ 'LayoutEntity' ] = function( s, ... ) return end
    end
    ui:NewAssoc             ( 'norotate', 'DModelPanel' )

    /*
        uclass > DModelPanel > LayoutEntity
    */

    function uclass.le( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'LayoutEntity'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc             ( 'le', 'DModelPanel' )

    /*
        uclass > DModelPanel > onmousepress

        rerouted action to define particular mouse definitions
    */

    function uclass.omp( pnl )
        pnl[ 'OnMousePressed' ] = function( s, act )
            if pnl:IsHovered( ) or s.hover then
                if act == MOUSE_LEFT and pnl.DoClick then pnl:DoClick( ) end
                if act == MOUSE_RIGHT and pnl.DoRightClick then pnl:DoRightClick( ) end
                if act == MOUSE_MIDDLE and pnl.DoMiddleClick  then pnl:DoMiddleClick( ) end
            end
        end
    end
    ui:NewAssoc             ( 'omp', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DModelPanel > onmousepress > defined

        rerouted action to define particular mouse definitions
    */

    function uclass.ompd( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'OnMousePressed'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc             ( 'ompd', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Dock

        @param  : int pos
    */

    function uclass.dock( pnl, pos )
        pos = ( type( pos ) == 'number' and pos ) or ( helper._dock[ pos ] ) or FILL
        pnl:Dock( pos )
    end
    ui:NewAssoc             ( 'dock', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Dock > left

        @param  : str, int t
        @param  : int il
        @param  : int it
        @param  : int ir
        @param  : int ib
    */

    function uclass.left( pnl, t, il, it, ir, ib )
        pnl:Dock( LEFT )

        if isnumber( t ) then
            ib, ir, it, il, t = ir, it, il, t, 'm'
        end

        if ( t == 'm' or t == 1 ) or ( t == 'p' or t == 2 ) then
            il = isnumber( il ) and il or 0

            if not it then it, ir, ib = il, il, il end
            if not ir then ir, ib = it, it end
            if not ib then ib = ir end

            if t == 'm' or t == 1 then
                pnl:DockMargin( il, it, ir, ib )
            elseif t == 'p' or t == 2 then
                pnl:DockPadding( il, it, ir, ib )
            end
        end
    end
    ui:NewAssoc             ( 'left', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Dock > top

        @param  : str, int t
        @param  : int il
        @param  : int it
        @param  : int ir
        @param  : int ib
    */

    function uclass.top( pnl, t, il, it, ir, ib )
        pnl:Dock( TOP )

        if isnumber( t ) then
            ib, ir, it, il, t = ir, it, il, t, 'm'
        end

        if ( t == 'm' or t == 1 ) or ( t == 'p' or t == 2 ) then
            il = isnumber( il ) and il or 0

            if not it then it, ir, ib = il, il, il end
            if not ir then ir, ib = it, it end
            if not ib then ib = ir end

            if t == 'm' or t == 1 then
                pnl:DockMargin( il, it, ir, ib )
            elseif t == 'p' or t == 2 then
                pnl:DockPadding( il, it, ir, ib )
            end
        end
    end
    ui:NewAssoc             ( 'top', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Dock > right

        @param  : str, int t
        @param  : int il
        @param  : int it
        @param  : int ir
        @param  : int ib
    */

    function uclass.right( pnl, t, il, it, ir, ib )
        pnl:Dock( RIGHT )

        if isnumber( t ) then
            ib, ir, it, il, t = ir, it, il, t, 'm'
        end

        if ( t == 'm' or t == 1 ) or ( t == 'p' or t == 2 ) then
            il = isnumber( il ) and il or 0

            if not it then it, ir, ib = il, il, il end
            if not ir then ir, ib = it, it end
            if not ib then ib = ir end

            if t == 'm' or t == 1 then
                pnl:DockMargin( il, it, ir, ib )
            elseif t == 'p' or t == 2 then
                pnl:DockPadding( il, it, ir, ib )
            end
        end
    end
    ui:NewAssoc             ( 'right', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Dock > bottom

        @param  : str, int t
        @param  : int il
        @param  : int it
        @param  : int ir
        @param  : int ib
    */

    function uclass.bottom( pnl, t, il, it, ir, ib )
        pnl:Dock( BOTTOM )

        if isnumber( t ) then
            ib, ir, it, il, t = ir, it, il, t, 'm'
        end

        if ( t == 'm' or t == 1 ) or ( t == 'p' or t == 2 ) then
            il = isnumber( il ) and il or 0

            if not it then it, ir, ib = il, il, il end
            if not ir then ir, ib = it, it end
            if not ib then ib = ir end

            if t == 'm' or t == 1 then
                pnl:DockMargin( il, it, ir, ib )
            elseif t == 'p' or t == 2 then
                pnl:DockPadding( il, it, ir, ib )
            end
        end
    end
    ui:NewAssoc             ( 'bottom', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Dock > fill

        @param  : str, int t
        @param  : int il
        @param  : int it
        @param  : int ir
        @param  : int ib
    */

    function uclass.fill( pnl, t, il, it, ir, ib )
        pnl:Dock( FILL )

        if isnumber( t ) then
            ib, ir, it, il, t = ir, it, il, t, 'm'
        end

        if ( t == 'm' or t == 1 ) or ( t == 'p' or t == 2 ) then
            il = isnumber( il ) and il or 0

            if not it then it, ir, ib = il, il, il end
            if not ir then ir, ib = it, it end
            if not ib then ib = ir end

            if t == 'm' or t == 1 then
                pnl:DockMargin( il, it, ir, ib )
            elseif t == 'p' or t == 2 then
                pnl:DockPadding( il, it, ir, ib )
            end
        end
    end
    ui:NewAssoc             ( 'fill', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Dock, DockMargin

        @param  : int pos
        @param  : int il
        @param  : int it
        @param  : int ir
        @param  : int ib
    */

    function uclass.docker( pnl, pos, il, it, ir, ib )
        pos = ( type( pos ) == 'number' and pos ) or ( helper._dock[ pos ] ) or FILL

        il = isnumber( il ) and il or 0

        if not it then it, ir, ib = il, il, il end
        if not ir then ir, ib = it, it end
        if not ib then ib = ir end

        pnl:Dock( pos )
        pnl:DockMargin( il, it, ir, ib )
    end
    ui:NewAssoc         ( 'docker', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Dock, DockPadding

        @param  : int pos
        @param  : int il
        @param  : int it
        @param  : int ir
        @param  : int ib
    */

    function uclass.pdock( pnl, pos, il, it, ir, ib )
        pos = ( type( pos ) == 'number' and pos ) or ( helper._dock[ pos ] ) or FILL

        il = isnumber( il ) and il or 0

        if not it then it, ir, ib = il, il, il end
        if not ir then ir, ib = it, it end
        if not ib then ib = ir end

        pnl:Dock( pos )
        pnl:DockPadding( il, it, ir, ib )
    end
    ui:NewAssoc         ( 'pdock', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DockPadding

        @param  : int val
    */

    function uclass.spad( pnl, val )
        val = isnumber( val ) and val or 0

        pnl:SetPadding( val )
    end
    ui:NewAssoc         ( 'spad', 'DCollapsibleCategory, DPanelList, DPropertySheet, DScrollPanel' )

    /*
        uclass > DockPadding

        @param  : int il
        @param  : int it
        @param  : int ir
        @param  : int ib
    */

    function uclass.padding( pnl, il, it, ir, ib )
        il = isnumber( il ) and il or 0

        if not it then it, ir, ib = il, il, il end
        if not ir then ir, ib = it, it end
        if not ib then ib = ir end

        pnl:DockPadding( il, it, ir, ib )
    end
    ui:NewAssoc             ( 'padding', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DockMargin

        @param  : int il
        @param  : int it
        @param  : int ir
        @param  : int ib
    */

    function uclass.margin( pnl, il, it, ir, ib )
        il = isnumber( il ) and il or 0

        if not it then it, ir, ib = il, il, il end
        if not ir then ir, ib = it, it end
        if not ib then ib = ir end

        pnl:DockMargin( il, it, ir, ib )
    end
    ui:NewAssoc             ( 'margin', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetPadding

        @param  : int i
    */

    function uclass.offset( pnl, i )
        i = isnumber( i ) and i or 0
        pnl:SetPadding( i )
    end
    ui:NewAssoc         ( 'offset', 'DCollapsibleCategory, DPanelList, DPropertySheet, DScrollPanel' )

    /*
        uclass > SetWide

        @param  : int w
    */

    function uclass.wide( pnl, w, err )
        if isstring( w ) and w == 'screen' then
            pnl:SetWide( ScrW( ) )
            return
        end

        w = isnumber( w ) and w or 25
        pnl:SetWide( w )
    end
    ui:NewAssoc         ( 'wide', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > SetMinWidth

        @param  : int w
    */

    function uclass.wmin( pnl, w )
        w = isnumber( w ) and w or 30
        pnl:SetMinWidth( w )
    end
    ui:NewAssoc         ( 'wmin', 'DFrame, DTileLayout' )

    /*
        uclass > SetTall

        @param  : int h
    */

    function uclass.tall( pnl, h )
        if isstring( h ) and h == 'screen' then
            pnl:SetTall( ScrH( ) )
            return
        end

        h = isnumber( h ) and h or 25
        pnl:SetTall( h )
    end
    ui:NewAssoc             ( 'tall', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > SetMinHeight

        @param  : int h
    */

    function uclass.hmin( pnl, h )
        h = isnumber( h ) and h or 30
        pnl:SetMinHeight( h )
    end
    ui:NewAssoc             ( 'hmin', 'DFrame, DTileLayout' )

    /*
        uclass > SetSize

        term 'scr' || w, h blank        : autosize fullscreen based on resolution
        term 'scr'                      : autosize one particular dimension to full monitor resolution

        @param  : int w, str
        @param  : int h, str
    */

    function uclass.size( pnl, w, h )
        if not w or ( isstring( w ) and ( ( w == 'screen' ) or ( w == 'scr' ) ) ) then
            pnl:SetSize( ScrW( ), ScrH( ) )
            return
        end
        w = ( isnumber( w ) and w ) or ( isstring( w ) and ( w == 'screen' or w == 'scr' ) and ScrW( ) ) or 25
        h = ( isnumber( h ) and h ) or ( isstring( h ) and ( h == 'screen' or h == 'scr' ) and ScrH( ) ) or w
        pnl:SetSize( w, h )
    end
    ui:NewAssoc             ( 'size|sz', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > SetPos

        @param  : int x
        @param  : int y
    */

    function uclass.pos( pnl, x, y )
        x = isnumber( x ) and x or 0
        y = isnumber( y ) and y or isnumber( x ) and x or 0
        pnl:SetPos( x, y )
    end
    ui:NewAssoc             ( 'pos', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > SetSpaceX

        @param  : int i
    */

    function uclass.space_x( pnl, i )
        i = isnumber( i ) and i or 0
        pnl:SetSpaceX( i )
    end
    ui:NewAssoc         ( 'space_x', 'DIconLayout, DTileLayout' )

    /*
        uclass > SetSpaceY

        @param  : int i
    */

    function uclass.space_y( pnl, i )
        i = isnumber( i ) and i or 0
        pnl:SetSpaceY( i )
    end
    ui:NewAssoc             ( 'space_y', 'DIconLayout, DTileLayout' )

    /*
        uclass > SetSpaceX, SetSpaceY

        @param  : int x
        @param  : int y
    */

    function uclass.spacing( pnl, x, y )
        x = isnumber( x ) and x or 0
        y = isnumber( y ) and y or isnumber( x ) and x or 0
        pnl:SetSpaceX( x )
        pnl:SetSpaceY( y )
    end
    ui:NewAssoc             ( 'spacing', 'DIconLayout, DTileLayout' )

    /*
        uclass > DPanelList > SetSpacing

        sets distance between list items

        @param  : int amt
    */

    function uclass.dspace( pnl, amt )
        amt = isnumber( amt ) and amt or 0
        pnl:SetSpacing( amt )
    end
    ui:NewAssoc             ( 'dspace', 'DNotify, DPanelList' )

    /*
        uclass > SetPos

        positions based on table index / key

        @param  : int x
        @param  : int y
    */

    function uclass.pos_table_x( pnl, x, y )
        x = isnumber( x ) and x or 0
        y = isnumber( y ) and y or isnumber( x ) and x or 0
        x = x * ( pnl.pos_ind or 0 )
        pnl:SetPos( x, y )
    end
    ui:NewAssoc             ( 'pos_table_x', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > SetPos

        positions based on table index / key

        @param  : int x
        @param  : int y
    */

    function uclass.pos_table_y( pnl, x, y )
        x = isnumber( x ) and x or 0
        y = isnumber( y ) and y or isnumber( x ) and x or 0
        y = y * ( pnl.pos_ind or 0 )
        pnl:SetPos( x, y )
    end
    ui:NewAssoc             ( 'pos_table_y', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > insert to table

        @param  : func fn
        @param  : tbl tbl
        @param  : int pos
    */

    function uclass.insert( pnl, tbl, pos )
        if not istable( tbl ) then return end
        local where = 0
        if isnumber( pos ) then
            where = table.insert( tbl, pos, pnl )
        else
            where = table.insert( tbl, pnl )
        end
        pnl.pos_ind = where
    end
    ui:NewAssoc             ( 'insert|pos_ind', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DIconLayout > SetLayoutDir

        sets the direction that it will be layed out, using the DOCK_ Enums.
        currently only TOP and LEFT are supported.

        @param  : int enum
    */

    function uclass.lodir( pnl, enum )
        enum = isnumber( enum ) and enum or LEFT
        pnl:SetLayoutDir( enum )
    end
    ui:NewAssoc             ( 'lodir', 'DIconLayout' )

    /*
        uclass > SetColor

        @param  : clr clr
    */

    function uclass.clr( pnl, clr )
        clr = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
        pnl:SetColor( clr )
    end
    ui:NewAssoc             ( 'clr', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DTextEntry > SetHighlightColor

        @param  : clr clr
    */

    function uclass.hlclr( pnl, clr )
        clr = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
        pnl:SetHighlightColor( clr )
    end
    ui:NewAssoc             ( 'hlclr', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetSteamID

        @param  : int sid
                  64bit SteamID of the player to load avatar of

        @param  : int size
                  Size of the avatar to use. Acceptable sizes are 32, 64, 184.
    */

    function uclass.steamid( pnl, sid, size )
        pnl:SetSteamID( sid, size )
    end
    uclass.sid              = uclass.steamid
    ui:NewAssoc             ( 'steamid|sid', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetCursor

        @param  : str str
    */

    function uclass.cur( pnl, str )
        str = isstring( str ) and str or 'none'
        pnl:SetCursor( str )
    end
    ui:NewAssoc             ( 'cur', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetCursorColor

        @param  : clr clr
    */

    function uclass.curclr( pnl, clr )
        clr = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
        pnl:SetCursorColor( clr )
    end
    ui:NewAssoc             ( 'curclr', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetCursorColor, SetCursor

        @param  : clr clr
        @param  : str str
    */

    function uclass.scur( pnl, clr, str )
        clr = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
        str = isstring( str ) and str or 'none'
        pnl:SetCursorColor( clr )
        pnl:SetCursor( str )
    end
    ui:NewAssoc             ( 'scur', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > CursorPos
    */

    function uclass.curpos( pnl )
        pnl:CursorPos( )
    end
    ui:NewAssoc             ( 'curpos', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DHTML > SetScrollbars

        @param  : bool b
    */

    function uclass.sbar( pnl, b )
        pnl:SetScrollbars( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'sbar', 'DHTML' )

    /*
        uclass > DTextEntry, RichText > SetVerticalScrollbarEnabled

        @param  : bool b
    */

    function uclass.vsbar( pnl, b )
        pnl:SetVerticalScrollbarEnabled( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'vsbar', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DScrollPanel > GetVBar

        returns the vertical scroll bar of the panel.

        @param  : bool bRemove
                  removes vbar
    */

    function uclass.vbar( pnl, bRemove )
        if not bRemove then
            pnl:GetVBar( )
        else
            pnl:GetVBar( ):Remove( )
        end
    end
    ui:NewAssoc             ( 'vbar', 'DScrollPanel' )

    /*
        uclass > simple vbar

        paints a simple vbar

        @param  :   clr         clr
    */

    function uclass.newvbar( pnl, clr )
        local vclr                  = rclr.Hex( clr )

        pnl.VBar           = pnl:GetVBar( )
        pnl.VBar:SetWide( 70 )
        pnl.VBar.Paint              = function( s, ... ) end
        pnl.VBar.btnUp.Paint        = function( s, ... ) end
        pnl.VBar.btnDown.Paint      = function( s, ... ) end

        pnl.VBar.btnGrip.Paint = function( s, w, h )
            design.box( 2, 0, w * 0.50, h, vclr )
        end
    end
    ui:NewAssoc             ( 'newvbar', 'DListView, DScrollPanel' )

    /*
        uclass > DTextEntry, RichText > SetVerticalScrollbarEnabled
    */

    function uclass.noscroll( pnl )
        pnl:SetVerticalScrollbarEnabled( false )
    end
    ui:NewAssoc             ( 'noscroll', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetMultiline

        @param  : bool b
    */

    function uclass.mline( pnl, b )
        pnl:SetMultiline( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'mline', 'DTextEntry' )

    /*
        uclass > Panel > focus
    */

    function uclass.focus( pnl )
        pnl:RequestFocus( )
    end
    ui:NewAssoc             ( 'focus', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DTextEntry > OnEnter

        @param  : func fn
    */

    function uclass.focuschg( pnl, fn )
        if not isfunction( fn ) then return end
        pnl[ 'OnFocusChanged' ] = fn
    end
    ui:NewAssoc             ( 'focuschg', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DTextEntry > OnEnter

        @param  : func fn
    */

    function uclass.onenter( pnl, fn )
        local name = 'OnEnter'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc             ( 'onenter', 'DTextEntry' )

    /*
        uclass > DProgress > SetFraction

        @param  : int i
    */

    function uclass.frac( pnl, i )
        i = isnumber( i ) and i or 1
        pnl:SetFraction( i )
    end
    ui:NewAssoc             ( 'frac', 'DNumberScratch, DNumberWang, DProgress' )

    /*
        uclass > DLabel, DTextEntry > SetFont

        @param  : str str
    */

    function uclass.font( pnl, face )
        face = isstring( face ) and face or pid( 'ucl_font_def' )
        pnl:SetFont( face )
    end
    ui:NewAssoc             ( 'font', 'DCheckBoxLabel, DLabel, DLabelEditable, DTextEntry, DButton' )

    /*
        uclass > DLabel, DTextEntry > SetInternalFont

        @param  : str face
    */

    function uclass.fontint( pnl, face )
        face = isstring( face ) and face or pid( 'ucl_font_def' )
        pnl:SetFontInternal( face )
    end
    ui:NewAssoc             ( 'fontint', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > RichText > SetInternalFont

        @param  : str face
    */

    function uclass.fontrich( pnl, face )
        face = isstring( face ) and face or pid( 'ucl_font_def' )

        local name  = 'PerformLayout'
        local orig  = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            pnl:SetFontInternal( face )
        end
    end
    ui:NewAssoc             ( 'fontrich', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DLabel, DTextEntry > typeface

        sets a font, but with a registered font prefix

        @param  : str str
    */

    function uclass.face( pnl, mod, str )
        str         = isstring( str ) and str or pid( 'ucl_font_def' )
        local _f    = font.get( mod, str )

        pnl:SetFont( _f )
    end
    ui:NewAssoc             ( 'face', 'DButton, DLabel, DCheckBoxLabel, DCheckBox, DComboBox, DTextEntry' )

    /*
        uclass > DLabel, DTextEntry > Face

        @note   : supports rlib fonts or regular string fontname
        @note   : replaces uclass.face

        @param  : str face
        @param  : str, tbl mod
    */

    function uclass.rface( pnl, face, mod )
        local fnt       = isstring( face ) and face or pid( 'ucl_font_def' )
        local _f        = ( mod and font.get( mod, face ) ) or fnt

        pnl:SetFont( _f )
    end
    ui:NewAssoc             ( 'rface', 'DButton, DLabel, DCheckBoxLabel, DCheckBox, DComboBox, DTextEntry' )

    /*
        uclass > Panel > SizeToChildren

        resizes the panel to fit the bounds of its children

        panel must have its layout updated (Panel:InvalidateLayout) for this function to work properly
        size_w and size_h parameters are false by default. calling this function with no arguments will result in a no-op.

        @param  : int w
                : adjust width of pnl

        @param  : int h
                : adjust height of pnl
    */

    function uclass.autosizeCh( pnl, w, h )
        pnl:SizeToChildren( w, h )
    end
    ui:NewAssoc             ( 'autosizeCh', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SizeToContents

        resizes the panel so that its width and height fit all of the content inside

        must call AFTER setting text/font or adjusting child panels
    */

    function uclass.autosize( pnl )
        pnl:SizeToContents( )
    end
    ui:NewAssoc             ( 'autosize', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SizeToContentsX

        resizes the panel objects width to accommodate all child objects/contents

        only works on Label derived panels such as DLabel by default, and on any
        panel that manually implemented Panel:GetContentSize method.

        must call AFTER setting text/font or adjusting child panels

        @param  : int val
                : number of extra pixels to add to the width. Can be a negative number, to reduce the width.
    */

    function uclass.autosize_x( pnl, val )
        val = isnumber( val ) and val or 0
        pnl:SizeToContentsX( val )
    end
    ui:NewAssoc             ( 'autosize_x', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SizeToContentsY

        resizes the panel object's height to accommodate all child objects/contents

        only works on Label derived panels such as DLabel by default, and on any
        panel that manually implemented Panel:GetContentSize method

        must call AFTER setting text/font or adjusting child panels

        @param  : int val
                : number of extra pixels to add to the height. Can be a negative number, to reduce the height
    */

    function uclass.autosize_y( pnl, val )
        val = isnumber( val ) and val or 0
        pnl:SizeToContentsY( val )
    end
    ui:NewAssoc             ( 'autosize_y', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SizeTo

        uses animation to resize the panel to the specified size

        @param  : int w
                : arget width of the panel. Use -1 to retain the current width

        @param  : int h
                : target height of the panel. Use -1 to retain the current height

        @param  : int time
                : time to perform the animation within

        @param  : int delay
                : delay before the animation starts

        @param  : int ease
                : easing of the start and/or end speed of the animation. See Panel:NewAnimation for how this works

        @param  : fn cb
                : function to be called once the animation finishes. Arguments are:
                    ( tbl ) : animData - The AnimationData structure that was used
                    ( pnl ) : panel object that was resized
    */

    function uclass.tosize( pnl, w, h, time, delay, ease, cb )
        pnl:SizeTo( w, h, time, delay, ease, cb )
    end
    ui:NewAssoc             ( 'tosize', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetContentAlignment

        sets the alignment of the contents

        @param  : int int
                : direction of the content, based on the number pad.

                    1   : bottom-left
                    2   : bottom-center
                    3   : bottom-right
                    4   : middle-left
                    5   : center
                    6   : middle-right
                    7   : top-left
                    8   : top-center
                    9   : top-right
    */

    function uclass.align( pnl, int )
        int = isnumber( int ) and int or 4
        pnl:SetContentAlignment( int )
    end
    ui:NewAssoc             ( 'align', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > AlignTop

        aligns the panel on the top of its parent with the specified offset

        @param  : int int
                : align offset
    */

    function uclass.aligntop( pnl, int )
        int = isnumber( int ) and int or 0
        pnl:AlignTop( int )
    end
    ui:NewAssoc             ( 'aligntop', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > AlignBottom

        aligns the panel on the bottom of its parent with the specified offset

        @param  : int int
                : align offset
    */

    function uclass.alignbottom( pnl, int )
        int = isnumber( int ) and int or 0
        pnl:AlignBottom( int )
    end
    ui:NewAssoc             ( 'alignbottom', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > AlignLeft

        aligns the panel on the left of its parent with the specified offset

        @param  : int int
                : align offset
    */

    function uclass.alignleft( pnl, int )
        int = isnumber( int ) and int or 0
        pnl:AlignLeft( int )
    end
    ui:NewAssoc             ( 'alignleft', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > AlignRight

        aligns the panel on the right of its parent with the specified offset

        @param  : int int
                : align offset
    */

    function uclass.alignright( pnl, int )
        int = isnumber( int ) and int or 0
        pnl:AlignRight( int )
    end
    ui:NewAssoc             ( 'alignright', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > LocalToScreen

        absolute screen position of the position specified relative to the panel.

        @param  : int x
                : x coordinate of the position on the panel to translate

        @param  : int y
                : y coordinate of the position on the panel to translate
    */

    function uclass.l2s( pnl, x, y )
        x = isnumber( x ) and x or 0
        y = isnumber( y ) and y or 0
        pnl:LocalToScreen( x, y )
    end
    ui:NewAssoc             ( 'l2s', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > ScreenToLocal

        translates global screen coordinate to coordinates relative to the panel

        @param  : int x
                : x coordinate of the screen position to be translated

        @param  : int y
                : y coordinate of the screed position be to translated
    */

    function uclass.s2l( pnl, x, y )
        x = isnumber( x ) and x or 0
        y = isnumber( y ) and y or 0
        pnl:ScreenToLocal( x, y )
    end
    ui:NewAssoc             ( 's2l|scr2local', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetDrawOnTop

        @param  : bool b
                : whether or not to draw the panel in front of all others
    */

    function uclass.drawtop( pnl, b )
        pnl:SetDrawOnTop( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'drawtop', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetFocusTopLevel

        @param  : bool b
                : sets the panel that owns this FocusNavGroup to be the root in the focus traversal hierarchy.
    */

    function uclass.focustop( pnl, b )
        pnl:SetFocusTopLevel( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'focustop', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DHTML > SetHTML

        set HTML code within a panel

        @param  : str str
                : html code to set
    */

    function uclass.html( pnl, str )
        pnl:SetHTML( str )
    end
    ui:NewAssoc             ( 'html', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DHTML > Loader

        draws a loading material to display for dhtml panels

        @param  : int sz
        @param  : clr clr
    */

    function uclass.loader( pnl, sz, clr )
        sz  = isnumber( sz ) and sz or 100
        clr = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
        pnl[ 'Paint' ] = function( s, w, h )
            design.loader( w / 2, h / 2, sz, clr )
        end
    end
    ui:NewAssoc             ( 'loader', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DHTML > preload

        draws a loading material to display for dhtml panels

        @param  :   str         mat
        @param  :   pnl         par
    */

    function uclass.preload( pnl, mat, par )
        mat             = mat or '01'
        par             = par or pnl

        pnl:SetHTML([[<!DOCTYPE html>
        <html>
        <head>
        <style>
        @import url(https://fonts.googleapis.com/css?family=Roboto:500);

        body
        {
            background-color: #323232;
            font-family: 'Roboto', sans-serif;
            color: #CCC;
            font-size: 12px;
            background-attachment: fixed;
        }
        div
        {
            margin-left: auto;
            margin-right: auto;
            width: 530px;
            height: 530px;
            background-image: url(https://cdn.rlib.io/gmod/loader/]] .. mat .. [[.gif);
            background-position: center;
            background-attachment: fixed;
            background-repeat: no-repeat;
        }
        </style>
        </head>
        <body>
        <div></div>
        </body>
        </html>]])
    end
    ui:NewAssoc             ( 'preload', 'DFrame, DHTML, DHTMLControls, DPanel' )

    /*
        uclass > DHTML > OnBeginLoadingDocument
    */

    function uclass.beginload( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'OnBeginLoadingDocument'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc             ( 'beginload', 'DHTML, DHTMLControls' )

    /*
        uclass > DHTML > OnFinishLoadingDocument
    */

    function uclass.finishload( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'OnFinishLoadingDocument'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc             ( 'finishload', 'DHTML, DHTMLControls' )

    /*
        uclass > DHTML > AddressBar

        sets the address bar for a dhtml panel

        @param  : str str
                : address to set
    */

    function uclass.addr( pnl, addr )
        if not ui:ok( pnl.AddressBar ) then return end
        pnl.AddressBar:SetText( addr )
    end
    ui:NewAssoc             ( 'addr', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DHTML > SetHTML

        sets html code in DHTML pnl to display a full-size img from an external site

        @param  : str str
                : html code to set
    */

    function uclass.imgsrc( pnl, str )
        local code = ui:html_img( str )
        pnl:SetHTML( code )
    end
    ui:NewAssoc             ( 'imgsrc', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > svg

        loads an outside svg file
        typically used for stats

        @param  : str src
                : html code to set
    */

    function uclass.svg( pnl, src, bShow )
        src = isstring( src ) and src or ''
        local html = ui:getsvg( src, bShow )
        pnl:SetHTML( html )
    end
    ui:NewAssoc             ( 'svg', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > CenterHorizontal

        centers the panel horizontally with specified fraction

        @param  : flt flt
                : center fraction.
    */

    function uclass.center_h( pnl, flt )
        flt = flt or 0.5
        pnl:CenterHorizontal( flt )
    end
    ui:NewAssoc             ( 'focustop', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > CenterVertical

        centers the panel vertically with specified fraction

        @param  : flt flt
                : center fraction.
    */

    function uclass.center_v( pnl, flt )
        flt = flt or 0.5
        pnl:CenterVertical( flt )
    end
    ui:NewAssoc             ( 'center_v', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DTextEntry, DLabel > SetTextColor

        sets the text color of the DLabel. This will take precedence
        over DLabel:SetTextStyleColor

        @param  : clr clr
                : text color. Uses the Color structure.
    */

    function uclass.textclr( pnl, clr, bThink )
        clr = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
        pnl:SetTextColor( clr )

        if bThink then
            pnl[ 'Think' ] = function( s, ... )
                s:SetTextColor( clr )
            end
        end
    end
    ui:NewAssoc             ( 'textclr', 'DCheckBox, DCheckBoxLabel, DLabel, DLabelURL, DTextEntry, DButton' )

    /*
        uclass > DLabel > SetText

        sets the text value of a panel object containing text, such as a Label,
        TextEntry or RichText and their derivatives, such as DLabel, DTextEntry or DButton

        @param  : str str
                : text value to set.

        @param  : bool bautosz
                : enables SizeToContents( )
    */

    function uclass.text( pnl, str, bautosz )
        str = isstring( str ) and str or ''
        pnl:SetText( str )
        if bautosz then
            pnl:SizeToContents( )
        end
    end
    ui:NewAssoc             ( 'text', 'DCheckBox, DCheckBoxLabel, DLabel, DLabelURL, DListView_Column, DTextEntry' )

    /*
        uclass > DLabel > SetText, SetTextColor

        set text clr, font, and string

        @param  : clr clr
                : text color. Uses the Color structure

        @param  : str face
                : font of the label

        @param  : str text
                : text to display

        @param  : bool bautosz
                : enables SizeToContents( )

        @param  : int align
                : SetContentAlignment( )
    */

    function uclass.txt( pnl, text, clr, face, bautosz, align )
        text        = isstring( text ) and text or ''
        clr         = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
        face        = isstring( face ) and face or pid( 'ucl_font_def' )

        pnl:SetTextColor    ( clr   )
        pnl:SetFont         ( face  )
        pnl:SetText         ( text  )

        if bautosz then
            pnl:SizeToContents( )
        end

        if align then
            pnl:SetContentAlignment ( align )
        end

        pnl[ 'Think' ] = function( s, ... )
            s:SetTextColor( clr )
        end
    end
    ui:NewAssoc             ( 'txt', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DLabel > Language

        set text clr, font, and string
        supports registered fonts

        @param  : str face
                : font of the label

        @param  : clr clr
                : text color. Uses the Color structure

        @param  : str text
                : text to display

        @param  : bool bautosz
                : enables SizeToContents( )

        @param  : int align
                : SetContentAlignment( )
    */

    function uclass.lng( pnl, mod, text, face, clr, bautosz, align )
        text        = isstring( text ) and text or ''
        face        = isstring( face ) and face
        clr         = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )

        pnl:SetTextColor    ( clr   )

        if face then
            local _f        = font.get( mod, face )
            pnl:SetFont     ( _f    )
        end

        local lang          = base:translate( mod, text )
        pnl:SetText         ( lang  )

        if bautosz then
            pnl:SizeToContents( )
        end

        if align then
            pnl:SetContentAlignment ( align )
        end

        pnl[ 'Think' ] = function( s, ... )
            s:SetTextColor( clr )
        end
    end
    ui:NewAssoc             ( 'lng', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DLabel > SetText, SetTextColor

        set text clr, font, and string

        @param  : clr clr
                : text color. Uses the Color structure

        @param  : str face
                : font of the label

        @param  : str text
                : text to display

        @param  : bool bautosz
                : enables SizeToContents( )
    */

    function uclass.textadv( pnl, clr, face, text, bautosz )
        clr         = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
        face        = isstring( face ) and face or pid( 'ucl_font_def' )
        text        = isstring( text ) and text or ''

        pnl:SetTextColor    ( clr   )
        pnl:SetFont         ( face  )
        pnl:SetText         ( text  )

        if bautosz then
            pnl:SizeToContents( )
        end

        pnl[ 'Think' ] = function( s, ... )
            s:SetTextColor( clr )
        end
    end
    ui:NewAssoc             ( 'textadv', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DLabel > SetText, SetTextColor

        set text clr, font, and string

        @param  : str face
                : font of the label

        @param  : str text
                : text to display

        @param  : clr clr
                : text color. Uses the Color structure

        @param  : bool bautosz
                : enables SizeToContents( )
    */

    function uclass.lngadv( pnl, mod, face, text, clr, bautosz )
        face        = isstring( face ) and face or pid( 'ucl_font_def' )
        text        = isstring( text ) and text or ''
        clr         = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )

        local _f    = font.get( mod, face )

        pnl:SetTextColor    ( clr   )
        pnl:SetFont         ( _f    )
        pnl:SetText         ( text  )

        if bautosz then
            pnl:SizeToContents( )
        end

        pnl[ 'Think' ] = function( s, ... )
            s:SetTextColor( clr )
        end
    end
    ui:NewAssoc             ( 'lngadv', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DLabel > SetText, SetTextColor

        set text clr, font, and string

        @param  : str text
                : text to display

        @param  : clr clr
                : text color. Uses the Color structure

        @param  : str face
                : font of the label

        @param  : bool bautosz
                : enables SizeToContents( )

        @param  : int align
                : set content alignment
    */

    function uclass.label( pnl, text, clr, face, bautosz, align )
        text        = isstring( text ) and text or ''
        clr         = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
        face        = isstring( face ) and face or pid( 'ucl_font_def' )
        bautosz     = bautosz or false
        align       = isnumber( align ) and align or 4

        pnl:SetText             ( text  )
        pnl:SetColor            ( clr   )
        pnl:SetFont             ( face  )

        if bautosz then
            pnl:SizeToContents( )
        end

        if align then
            pnl:SetContentAlignment ( align )
        end

        pnl[ 'Think' ] = function( s, ... )
            s:SetColor( clr )
        end
    end
    ui:NewAssoc             ( 'label', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > AlphaTo

        animation to transition the current alpha value of a panel to a new alpha, over a set period of time and after a specified delay.

        @param  : int alpha
                : alpha value (0-255) to approach

        @param  : int dur
                : time in seconds it should take to reach the alpha

        @param  : int delay
                : delay before the animation starts.

        @param  : func cb
                : function to be called once the animation finishes
    */

    function uclass.alphato( pnl, alpha, dur, delay, cb )
        alpha   = isnumber( alpha ) and alpha or 255
        dur     = isnumber( dur ) and dur or 1
        delay   = isnumber( delay ) and delay or 0

        pnl:AlphaTo( alpha, dur, delay, cb )
    end
    ui:NewAssoc             ( 'alphato', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DLabel > SetText

        sets the text value of a panel object containing text, such as a Label,
        TextEntry or RichText and their derivatives, such as DLabel, DTextEntry or DButton
    */

    function uclass.notext( pnl )
        pnl:SetText( '' )
    end
    ui:NewAssoc             ( 'notext', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetEnabled

        Sets the enabled state of a disable-able panel object, such as a DButton or DTextEntry.
        See Panel:IsEnabled for a function that retrieves the "enabled" state of a panel

        @param  : bool b
                : Whether to enable or disable the panel object
    */

    function uclass.enabled( pnl, b )
        pnl:SetEnabled( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'enabled', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )


    /*
        uclass > DMenuBar, DPanel > SetDisabled

        sets whether or not to disable the panel

        @param  : bool b
                : true to disable the panel (mouse input disabled and background
                  alpha set to 75), false to enable it (mouse input enabled and background alpha set to 255).
    */

    function uclass.disabled( pnl, b )
        pnl:SetDisabled( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'disabled', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetParent

        sets the parent of the panel

        @param  : pnl parent
                : new parent of the panel
    */

    function uclass.parent( pnl, parent )
        pnl:SetParent( parent )
    end
    ui:NewAssoc             ( 'parent', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > HasFocus

        returns if the panel is focused

        @return : bool
                : hasFocus
    */

    function uclass.hasfocus( pnl )
        pnl:HasFocus( )
    end
    ui:NewAssoc             ( 'hasfocus', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > HasParent

        returns whether the panel is a descendent of the given panel

        @param  : pnl parent
                : parent pnl

        @return : bool
                : true if the panel is contained within parent
    */

    function uclass.hasparent( pnl, parent )
        pnl:HasParent( parent )
    end
    ui:NewAssoc             ( 'hasparent', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > HasChildren

        returns whenever the panel has child panels

        @return : bool
                : true if the panel has children
    */

    function uclass.haschild( pnl )
        pnl:HasChildren( )
    end
    ui:NewAssoc             ( 'haschild', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetWrap

        sets whether text wrapping should be enabled or disabled on Label and
        DLabel panels. Use DLabel:SetAutoStretchVertical to automatically correct
        vertical size; Panel:SizeToContents will not set the correct height

        @param  : bool b
                : true to enable text wrapping, false otherwise.
    */

    function uclass.wrap( pnl, b )
        pnl:SetWrap( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'wrap', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Label > SetAutoStretchVertical

        automatically adjusts the height of the label dependent of the height of the text inside of it.

        @param  : bool b
                : true to enable auto stretching, false otherwise.
    */

    function uclass.autoverticle( pnl, b )
        pnl:SetAutoStretchVertical( helper:val2bool( b ) )
    end
    ui:NewAssoc             ( 'autoverticle', 'DLabel, DLabelEditable' )

    /*
        uclass > Panel > OnCursorEntered, OnCursorExited

        shortcut for oncursor hover functions
            : s.hover
    */

    function uclass.onhover( pnl )
        pnl.OnCursorEntered = function( s ) s.hover = true end
        pnl.OnCursorExited = function( s ) s.hover = false end
    end
    ui:NewAssoc         ( 'onhover', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > isdown
            : s.down
    */

    function uclass.ondown( pnl )
        pnl.IsDown = function( s )
            if s.Depressed then
                s.down = true
            else
                s.down = false
            end
        end
    end
    ui:NewAssoc         ( 'ondown', 'DButton, DColorButton' )

    /*
        uclass > Panel > OnCursorEntered

        shortcut for oncursor enter functions
            : s.hover
    */

    function uclass.ocen( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'OnCursorEntered'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc             ( 'ocen', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > OnCursorEntered

        shortcut for oncursor enter functions
            : s.hover
    */

    function uclass.ocex( pnl, fn )
        if not isfunction( fn ) then return end

        local name = 'OnCursorExited'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            fn( s, ... )
        end
    end
    ui:NewAssoc             ( 'ocex', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > OnCursorEntered, OnCursorExited > dim

        dims the btn when mouse cursor hovers

        @param  : clr clr
    */

    function uclass.odim( pnl, clr, x, y, w, h )
        uclass.onhover( pnl )

        clr = IsColor( clr ) and clr or Color( 0, 0, 0, 200 )
        x   = isnumber( x ) and x or 0
        y   = isnumber( y ) and y or x or 0
        w   = isnumber( w ) and w or nil
        h   = isnumber( h ) and h or nil

        pnl.PaintOver = function( s, sz_w, sz_h )
            if s.hover then
                sz_w = isnumber( w ) and w or sz_w
                sz_h = isnumber( h ) and h or sz_h
                design.box( x, y, sz_w, sz_h, clr )
            end
        end
    end
    ui:NewAssoc             ( 'odim', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )


    /*
        uclass > Panel > OnDisabled

        sets a local pnl var to check if pnl is disabled or not
            :   s.disabled
    */

    function uclass.ondisabled( pnl )
        pnl.Think = function( s )
            if s:GetDisabled( ) then
                s.disabled = true
            else
                s.disabled = false
            end
        end
    end
    ui:NewAssoc         ( 'ondisabled', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Chkbox > GetChecked

        sets a local pnl var to check if pnl is disabled or not
            :   s.disabled
    */

    function uclass.onchk( pnl )
        pnl.Think = function( s )
            if s:GetChecked( ) then
                s.chk = true
            else
                s.chk = false
            end
        end
    end
    ui:NewAssoc             ( 'onchk', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DButton, DImage > SetImage

        sets an image to be displayed as the button's background.

        @param  : str img
                : image file to use, relative to /materials. If this is nil, the image background is removed.

        @param  : str img2
                : backup img
    */

    function uclass.img( pnl, img, img2 )
        img2 = isstring( img2 ) and img2 or 'vgui/avatar_default'
        pnl:SetImage( img, img2 )
    end
    ui:NewAssoc             ( 'img', 'DButton, DImage, DImageButton, DSlider' )

    /*
        uclass > DTextEntry > GetUpdateOnType

        returns whether the DTextEntry is set to run DTextEntry:OnValueChange every
        time a character is typed or deleted or only when Enter is pressed.
    */

    function uclass.autoupdate( pnl )
        pnl:GetUpdateOnType( )
    end
    ui:NewAssoc             ( 'autoupdate', 'DTextEntry' )

    /*
        uclass > DTextEntry > SetUpdateOnType

        sets whether we should fire DTextEntry:OnValueChange
        every time we type or delete a character or only when Enter is pressed.
    */

    function uclass.setautoupdate( pnl, b )
        pnl:SetUpdateOnType( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'setautoupdate', 'DTextEntry' )

    /*
        uclass > Panel > SetAllowNonAsciiCharacters

        configures a text input to allow user to type characters that are not included in
        the US-ASCII (7-bit ASCII) character set.

        characters not included in US-ASCII are multi-byte characters in UTF-8. They can be
        accented characters, non-Latin characters and special characters.

        @param  : bool b
                : true in order not to restrict input characters.
    */

    function uclass.ascii( pnl, b )
        pnl:SetAllowNonAsciiCharacters( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'ascii', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DPropertySheet > AddSheet

        adds a new tab.

        @param  : str name
                : name of the tab

        @param  : pnl panel
                : panel to be used as contents of the tab. This normally should be a DPanel

        @param  : str ico
                : icon for the tab. This will ideally be a silkicon, but any material name can be used.

        @param  : bool bnostretchx
                : should DPropertySheet try to fill itself with given panel horizontally.

        @param  : bool bnostretchy
                : should DPropertySheet try to fill itself with given panel vertically.

        @param  : str tip
                : tooltip for the tab when user hovers over it with his cursor
    */

    function uclass.newsheet( pnl, name, panel, ico, bnostretchx, bnostretchy, tip )
        name            = isstring( name ) and name or 'untitled'
        panel           = ui:ok( panel ) and panel or nil
        ico             = isstring( ico ) and ico or ''
        bnostretchx     = bnostretchx or false
        bnostretchy     = bnostretchy or false
        tip             = isstring( tip ) and tip or ''

        pnl:AddSheet( name, panel, ico, bnostretchx, bnostretchy, tip )
    end
    ui:NewAssoc             ( 'newsheet', 'DColumnSheet, DPropertySheet' )


    /*
        uclass > DColumnSheet > AddSheet

        adds a new column/tab.

        @param  : str name
                : name of the column/tab

        @param  : pnl panel
                : panel to be used as contents of the tab. This normally would be a DPanel

        @param  : str ico
                : icon for the tab. This will ideally be a silkicon, but any material name can be used.
    */

    function uclass.addsheet( pnl, name, panel, ico )
        name            = isstring( name ) and name or 'untitled'
        panel           = ui:ok( panel ) and panel or nil
        ico             = isstring( ico ) and ico or ''

        pnl:AddSheet( name, panel, ico )
    end
    ui:NewAssoc             ( 'addsheet', 'DColumnSheet, DPropertySheet' )

    /*
        uclass > Panel > Clear

        marks all of the panel's children for deletion.
    */

    function uclass.clear( pnl )
        pnl:Clear( )
    end
    ui:NewAssoc             ( 'clear', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DFrame > Close

        hides or removes DFrame, calls DFrame:OnClose.
    */

    function uclass.close( pnl )
        pnl:Close( )
    end
    ui:NewAssoc             ( 'close', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DFrame > DeleteOnClose

        destroys pnl when closed

        @param  : bool b
    */

    function uclass.delonclose( pnl, b )
        pnl:SetDeleteOnClose( helper:val2bool( b ) )
    end
    ui:NewAssoc             ( 'delonclose', 'DButton, DFrame' )

    /*
        uclass > DComboBox > SetValue

        sets the text shown in the combo box when the menu is not collapsed.

        @param  : str opt
    */

    function uclass.val( pnl, opt )
        if not opt then
            pnl:SetValue( '' )
            return
        end
        pnl:SetValue( opt )
    end
    ui:NewAssoc             ( 'val', 'DAlphaBar, DBinder, DCheckBox, DCheckBoxLabel, DComboBox, DMenuOptionCVar, DNumberScratch, DNumberWang, DNumSlider, DTextEntry' )

    /*
        uclass > DComboBox > SetValue

        @note   : deprecate
                  replaced by uclass.val
    */

    function uclass.noval( pnl )
        pnl:SetValue( '' )
    end
    ui:NewAssoc             ( 'noval', 'DAlphaBar, DBinder, DCheckBox, DCheckBoxLabel, DComboBox, DMenuOptionCVar, DNumberScratch, DNumberWang, DNumSlider, DTextEntry' )

    /*
        uclass > DCheckBox > SetValue

        sets checked state of checkbox, calls the checkbox's DCheckBox:OnChange and Panel:ConVarChanged methods.

        @param  : bool opt
    */

    function uclass.cbval( pnl, b )
        pnl:SetValue( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'cbval', 'DAlphaBar, DBinder, DCheckBox, DCheckBoxLabel, DComboBox, DMenuOptionCVar, DNumberScratch, DNumberWang, DNumSlider, DTextEntry' )

    /*
        uclass > DComboBox > choose

        sets the text shown in the combo box when the menu is not collapsed.

        @param  : str opt
        @param  : int ind
    */

    function uclass.option( pnl, opt, ind )
        pnl:ChooseOption( opt, ind )
    end
    ui:NewAssoc             ( 'option', 'DComboBox' )

    /*
        uclass > Panel > GetValue

        returns the value the obj holds

        @return : str
    */

    function uclass.getval( pnl )
        pnl:GetValue( )
    end
    ui:NewAssoc             ( 'getval', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DCheckBox > SetChecked

        sets the checked state of the checkbox. Does not call the checkbox's
        DCheckBox:OnChange and Panel:ConVarChanged methods, unlike DCheckBox:SetValue.

        @param  : bool b
    */

    function uclass.checked( pnl, b )
        pnl:SetChecked( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'checked', 'DCheckBox, DCheckBoxLabel, DMenuOption, ImageCheckBox' )

    /*
        uclass > DComboBox > AddChoice

        adds a choice to the combo box.

        @param  : str str
        @param  : mix data
        @param  : bool bsel
        @param  : pnl icon
    */

    function uclass.newchoice( pnl, str, data, bsel, icon )
        pnl:AddChoice( str, data, bsel, icon )
    end
    ui:NewAssoc             ( 'newchoice', 'DComboBox, DProperty_Combo' )

    /*
        uclass > Panel > Destroy

        completely removes the specified panel
    */

    function uclass.destroy( pnl )
        ui:destroy( pnl )
    end
    ui:NewAssoc             ( 'destroy', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > Show

        shows the specified panel
    */

    function uclass.show( pnl )
        ui:show( pnl )
    end
    ui:NewAssoc             ( 'show', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

   /*
        uclass > Panel > Hide

        hides the specified panel
    */

    function uclass.hide( pnl )
        ui:hide( pnl )
    end
    ui:NewAssoc             ( 'hide', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > state

        toggles panel based on bool
    */

    function uclass.state( pnl, b )
        local state = helper:val2bool( b )
        if state then
            ui:show( pnl )
        else
            ui:hide( pnl )
        end
    end
    ui:NewAssoc             ( 'state', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > onclick > dispatch

        @ex     : :dispatch( self, 'pnl.ticker', mod )
                  :dispatch( self, 'pnl.ticker', mod, 1 )

        @param  : pnl panel
        @param  : str id
        @param  : str, tbl mod
        @param  : int dur
        @param  : int delay
    */

    function uclass.dispatch( pnl, panel, id, mod, dur, delay )
        pnl[ 'DoClick' ] = function( s, ... )
            dur         = isnumber( dur ) and dur or 0
            delay       = isnumber( delay ) and delay or 0.1
            panel:AlphaTo( 0, dur, delay, function( )
                ui:dispatch( id, mod )
            end )
        end
    end
    ui:NewAssoc             ( 'dispatch', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > stage

        @param  : pnl panel
        @param  : str, tbl mod
        @param  : bool bMouse
    */

    function uclass.stage( pnl, mod, bMouse )
        ui:stage( pnl, mod, bMouse )
    end
    ui:NewAssoc             ( 'stage', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > unstage

        @param  : pnl panel
        @param  : str, tbl mod
        @param  : bool bMouse
    */

    function uclass.unstage( pnl, mod, bMouse )
        ui:unstage( pnl, mod, bMouse )
    end
    ui:NewAssoc             ( 'unstage', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > MakePopup

        focuses the panel and enables it to receive input.
        automatically calls Panel:SetMouseInputEnabled and Panel:SetKeyboardInputEnabled
        and sets them to true.

        :   bKeyDisabled
            set TRUE to disable keyboard input

        :   bMouseDisabled
            set TRUE to disable mouse input
    */

    function uclass.popup( pnl, bKeyDisabled, bMouseDisabled )
        pnl:MakePopup( )
        if bKeyDisabled then
            pnl:SetKeyboardInputEnabled( false )
        end
        if bMouseDisabled then
            pnl:SetMouseInputEnabled( false )
        end
    end
    ui:NewAssoc             ( 'popup', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DFrame > SetDraggable

        sets whether the frame should be draggable by the user.
        DFrame can only be dragged from its title bar.

        @param  : bool b
    */

    function uclass.candrag( pnl, b )
        pnl:SetDraggable( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'candrag', 'DFrame, DTree_Node' )

    /*
        uclass > DFrame > SetDraggable

        forces frame to not allow dragging
    */

    function uclass.nodrag( pnl )
        pnl:SetDraggable( false )
    end
    ui:NewAssoc             ( 'nodrag', 'DFrame, DTree_Node' )

    /*
        uclass > DFrame > SetSizable

        sets whether or not the DFrame can be resized by the user.
        this is achieved by clicking and dragging in the bottom right corner of the frame.

        @param  : bool b
    */

    function uclass.canresize( pnl, b )
        pnl:SetSizable( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'canresize', 'DFrame, DTree_Node' )

    /*
        uclass > DFrame > SetScreenLock

        sets whether the DFrame is restricted to the boundaries of the screen resolution.

        @param  : bool b
    */

    function uclass.scrlock( pnl, b )
        pnl:SetScreenLock( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'scrlock', 'DFrame' )

    /*
        uclass > DFrame > SetPaintShadow

        sets whether or not the shadow effect bordering the DFrame should be drawn.

        @param  : bool b
    */

    function uclass.shadow( pnl, b )
        pnl:SetPaintShadow( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'shadow', 'DFrame' )

    /*
        uclass > DFrame > IsActive

        determines if the frame or one of its children has the screen focus.
    */

    function uclass.isactive( pnl )
        pnl:IsActive( )
    end
    ui:NewAssoc             ( 'isactive', 'DFrame, DTab' )

    /*
        uclass > blur

        adds blur to the specified pnl

        @param  : int amt [ optional ]
                : how intense blur will be
    */

    function uclass.blur( pnl, amt )
        amt = isnumber( amt ) and amt or 10

        uclass.nodraw( pnl )
        pnl[ 'Paint' ] = function( s, w, h )
            design.blur( s, amt )
        end
    end
    ui:NewAssoc             ( 'blur', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > blurbox

        adds blur and a single box to the pnl paint hook

        @param  : clr, int clr
                : clr for box

        @param  : int amt [ optional ]
                : how intense blur will be
    */

    function uclass.blurbox( pnl, clr, amt )
        clr     = ( IsColor( clr ) and clr or isnumber( clr ) and clr ) or Color( 25, 25, 25, 255 )
        amt     = isnumber( amt ) and amt or 10

                if isnumber( clr ) then
                    clr = Color( clr, clr, clr, 255 )
                end

        uclass.nodraw( pnl )
        pnl[ 'Paint' ] = function( s, w, h )
            design.blur( s, amt )
            design.box( 0, 0, w, h, clr )
        end
    end
    ui:NewAssoc             ( 'blurbox', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DFrame > SetBackgroundBlur

        blurs background behind the frame.

        @param  : bool b
                : whether or not to create background blur or not.
    */

    function uclass.blur_bg( pnl, b )
        pnl:SetBackgroundBlur( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'blur_bg', 'DFrame' )

    /*
        uclass > DFrane > SetLabel

        sets the title of the frame.
        replaces uclass.title

        @param  : str str
                : text to set as title for frame
    */

    function uclass.lbl( pnl, str )
        str = isstring( str ) and str or ''

        if pnl.SetLabel then
            pnl:SetLabel( str )
        end

        if pnl.SetEpithet then
            pnl:SetEpithet( str )
        end
    end
    ui:NewAssoc             ( 'lbl|epithet', 'ControlPresets, DCollapsibleCategory, DColorMixer' )

    /*
        uclass > DFrane > SetTitle

        sets the title of the frame.

        @param  : str str
                : text to set as title for frame
    */

    function uclass.title( pnl, str )
        str = isstring( str ) and str or ''
        pnl:SetTitle( str )
    end
    ui:NewAssoc             ( 'title', 'DFrame' )

    /*
        uclass > DFrane > SetTitle

        clears the dframe title
    */

    function uclass.notitle( pnl )
        pnl:SetTitle( '' )
    end
    ui:NewAssoc             ( 'notitle', 'DFrame' )

    /*
        uclass > DFrame > ShowCloseButton

        determines whether the DFrame's control box (close, minimise and maximise buttons) is displayed.

        @param  : bool b
    */

    function uclass.showclose( pnl, b )
        pnl:ShowCloseButton( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'showclose', 'DFrame' )

    /*
        uclass > DFrame > ShowCloseButton

        automatically hides the close button on dframe pnls
    */

    function uclass.noclose( pnl )
        pnl:ShowCloseButton( false )
    end
    ui:NewAssoc             ( 'noclose', 'DFrame' )

    /*
        uclass > Panel > SetPaintBackground

        sets whether or not to paint/draw the panel background.

        @param  : bool b
    */

    function uclass.drawbg( pnl, b )
        pnl:SetPaintBackground( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'drawbg', 'DCollapsibleCategory, DMenuBar, DPanel, DTextEntry' )

    /*
        uclass > Panel > SetPaintBackgroundEnabled

        sets whenever all the default background of the panel should be drawn or not.

        @param  : bool b
    */

    function uclass.drawbg_on( pnl, b )
        pnl:SetPaintBackgroundEnabled( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'drawbg_on', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetPaintBorderEnabled

        sets whenever all the default border of the panel should be drawn or not.

        @param  : bool b
    */

    function uclass.drawborder( pnl, b )
        pnl:SetPaintBorderEnabled( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'drawborder', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetPaintBackgroundEnabled, SetPaintBorderEnabled, SetPaintBackground

        @param  : bool b
    */

    function uclass.enginedraw( pnl, b )
        local val = helper:val2bool( b ) or true
        pnl:SetPaintBackgroundEnabled   ( val )
        pnl:SetPaintBorderEnabled       ( val )
        pnl:SetPaintBackground          ( val )
    end
    ui:NewAssoc             ( 'enginedraw', 'DCollapsibleCategory, DMenuBar, DPanel, DTextEntry' )

    /*
        uclass > DFrame > Center

        centers the panel on its parent.
    */

    function uclass.center( pnl )
        pnl:Center( )
    end
    ui:NewAssoc             ( 'center', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > GetParent

        returns the parent of the panel, returns nil if there is no parent.
    */

    function uclass.getparent( pnl )
        pnl:GetParent( )
    end
    ui:NewAssoc             ( 'getparent', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > GetChild

        gets a child by its index.

        @param  : int id
    */

    function uclass.getchild( pnl, id )
        id = isnumber( id ) and id or 0
        pnl:GetChild( id )
    end
    ui:NewAssoc             ( 'getchild', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > GetChildren

        returns a table with all the child panels of the panel.
    */

    function uclass.getchildren( pnl )
        pnl:GetChildren( )
    end
    ui:NewAssoc             ( 'getchildren', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > InvalidateLayout

        causes the panel to re-layout in the next frame.
        during the layout process PANEL:PerformLayout will be called on the target panel.

        @param  : bool b
    */

    function uclass.nullify( pnl, b )
        pnl:InvalidateLayout( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'nullify', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > InvalidateChildren

        invalidates the layout of this panel object and all its children.
        this will cause these objects to re-layout immediately, calling PANEL:PerformLayout.
        if you want to perform the layout in the next frame, you will have loop manually through
        all children, and call Panel:InvalidateLayout on each.

        @param  : bool b
                : true = the method will recursively invalidate the layout of all children. Otherwise, only immediate children are affected.
    */

    function uclass.nullifyCh( pnl, b )
        pnl:InvalidateChildren( helper:val2bool( b ) or false )
    end
    ui:NewAssoc                 ( 'nullifyCh', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > InvalidateParent

        invalidates the layout of the parent of this panel object.
        this will cause it to re-layout, calling PANEL:PerformLayout.

        @param  : bool b
                : true = the re-layout will occur immediately, otherwise it will be performed in the next frame.
    */

    function uclass.nullifyPA( pnl, b )
        pnl:InvalidateParent( helper:val2bool( b ) or false )
    end
    ui:NewAssoc                 ( 'nullifyPA', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetCookieName, SetCookie

        @param  : str name
        @param  : str val
    */

    function uclass.cookie( pnl, name, val )
        if not name then return end
        pnl:SetCookieName( name )
        pnl:SetCookie( name, val )
    end
    ui:NewAssoc             ( 'cookie', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > DeleteCookie

        @param  : str name
    */

    function uclass.delcookie( pnl, name )
        if not name then return end
        pnl:DeleteCookie( name )
    end
    ui:NewAssoc             ( 'delcookie', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > MoveTo

        @param  : int x
        @param  : int y
        @param  : int time
        @param  : int delay
        @param  : int ease
        @param  : fn cb
    */

    function uclass.moveto( pnl, x, y, time, delay, ease, cb )
        pnl:MoveTo( x, y, time, delay, ease, cb )
    end
    ui:NewAssoc             ( 'moveto', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > MoveToBack

        @param  : bool b
    */

    function uclass.m2b( pnl, b )
        pnl:MoveToBack( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'm2b', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > MoveToFront
    */

    function uclass.m2f( pnl )
        pnl:MoveToFront( )
    end
    ui:NewAssoc             ( 'm2f', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > MoveToFront ( Think )
    */

    function uclass.keeptop( pnl, zpos )
        local name = 'Think'
        local orig = pnl[ name ]

        pnl[ name ] = function( s, ... )
            if isfunction( orig ) then orig( s, ... ) end
            pnl:MoveToFront( )
            if isnumber( zpos ) then
                pnl:SetZPos( zpos )
            elseif tostring( zpos ) == 'true' then
                pnl:SetZPos( 1000 )
            end
        end
    end
    ui:NewAssoc             ( 'keeptop', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > MoveToAfter

        @param  : pnl panel
    */

    function uclass.m2af( pnl, panel )
        if not panel then return end
        pnl:MoveToAfter( panel )
    end
    ui:NewAssoc             ( 'm2af', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > MoveToBefore

        @param  : pnl panel
    */

    function uclass.m2bf( pnl, panel )
        if not panel then return end
        pnl:MoveToBefore( panel )
    end
    ui:NewAssoc             ( 'm2bf', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > MoveBelow

        @param  : pnl panel
    */

    function uclass.below( pnl, panel )
        if not panel then return end
        pnl:MoveBelow( panel )
    end
    ui:NewAssoc             ( 'below', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetZPos

        @param  : int pos
    */

    function uclass.zpos( pnl, pos )
        pos = isnumber( pos ) and pos or 1
        pnl:SetZPos( pos )
    end
    ui:NewAssoc             ( 'zpos', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetKeyboardInputEnabled

        @param  : bool b
    */

    function uclass.allowkeys( pnl, b )
        pnl:SetKeyboardInputEnabled( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'allowkeys', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetMouseInputEnabled

        @param  : bool b
    */

    function uclass.allowmouse( pnl, b )
        pnl:SetMouseInputEnabled( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'allowmouse', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > EnableScreenClicker
    */

    function uclass.mouse0( )
        gui.EnableScreenClicker( false )
    end
    ui:NewAssoc             ( 'mouse0', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > EnableScreenClicker
    */

    function uclass.mouse1( )
        gui.EnableScreenClicker( true )
    end
    ui:NewAssoc             ( 'mouse1', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > MouseCapture

        allows the panel to receive mouse input even if the mouse cursor
        is outside the bounds of the panel.

        @param  : bool b
    */

    function uclass.mousecap( pnl, b )
        pnl:MouseCapture( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'mousecap', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetRounded

        @param  : bool b
    */

    function uclass.rounded( pnl, b )
        pnl:SetRounded( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'rounded', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetOpacity

        @param  : int i
    */

    function uclass.opacity( pnl, i )
        i = isnumber( i ) and i or 255
        pnl:SetOpacity( i )
    end
    ui:NewAssoc             ( 'opacity', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetAlpha

        @param  : int int
    */

    function uclass.alpha( pnl, int )
        int = isnumber( int ) and int or 255
        pnl:SetAlpha( int )
    end
    ui:NewAssoc             ( 'alpha', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetHeader

        @param  : str str
    */

    function uclass.header( pnl, str )
        str = isstring( str ) and str or 'Welcome'
        pnl:SetHeader( str )
    end
    ui:NewAssoc             ( 'header', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > ActionShow
    */

    function uclass.actshow( pnl )
        pnl:ActionShow( )
    end
    ui:NewAssoc             ( 'actshow', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > ActionHide
    */

    function uclass.acthide( pnl )
        pnl:ActionHide( )
    end
    ui:NewAssoc             ( 'acthide', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > Param

        can be used to call panel child function

        @ex     :   func in PANEL file:         PANEL:SetItemID( )
                :   call from pmeta:            :param( 'SetItemID', 293 )

        @param  : str name
        @param  : mix val
    */

    function uclass.param( pnl, name, val, bCast, dur )
        if not name or not pnl[ name ] then return end

        if not bCast then
            val = val or ''
            pnl[ name ]( pnl, val )

            return
        end

        dur             = isnumber( dur ) and dur or 5

        local fnName    = 'Think'
        local orig      = pnl[ fnName ]

        pnl[ fnName ] = function( s, ... )
            if not s.param_i then s.param_i = 0 return end
            if s.param_i > CurTime( ) then return end

            if isfunction( orig ) then orig( s, ... ) end

            val = val or ''
            pnl[ name ]( pnl, val )

            print('name')
            print( name )

            print('val')
            print( val )

            s.param_delay           = s.bPReady and dur or 0.1
            s.param_i               = CurTime( ) + s.param_delay
            s.bPReady               = true
        end

    end
    ui:NewAssoc             ( 'param', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > paramv

        @param  : str name
        @param  : varg { ... }
    */

    function uclass.paramv( pnl, name, ... )
        if not name or not pnl[ name ] then return end

        local args = { ... }
        pnl[ name ]( pnl, unpack( args ) )
    end
    ui:NewAssoc             ( 'paramv', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > var

        @ex     : var( 'health', 0 )

        @call   : self.item.health
                : item.health

        @param  : str name
        @param  : mix val
    */

    function uclass.var( pnl, name, val )
        val = val or ''
        pnl[ name ] = val
    end
    ui:NewAssoc             ( 'var', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > set knob state

        @param  : str name
        @param  : mix val
    */

        function uclass.knobstate( pnl, b )
            pnl.Knob.Depressed      = helper:val2bool( b )
            pnl.Dragging            = helper:val2bool( b )
        end
        ui:NewAssoc             ( 'knobstate', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > link

        @param  : pnl parent
        @param  : str id
    */

    function uclass.link( pnl, parent, id )
        parent[ id ] = pnl
    end
    ui:NewAssoc             ( 'link', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > SetTooltip

        displays tooltips via the default gmod method

        @assoc  : tooltip

        @param  : str str
    */

    function uclass.gtip( pnl, str )
        str = isstring( str ) and str or ''
        pnl:SetTooltip( str )
    end
    ui:NewAssoc             ( 'gtip', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > Tooltips

        displays tooltips
        custom tooltip alternative to the default gmod SetTooltip func

        @assoc  : gtooltip

        @param  : str str
        @param  : clr clr_t
        @param  : clr clr_i
        @param  : clr clr_o
    */

    local pnl_tippy = false
    function uclass.tip( pnl, str, clr_t, clr_i, clr_o )

        /*
            validate tip
        */

        if not isstring( str ) or helper.str:isempty( str ) then return end

        /*
            timer
        */

        local i_timer = 5
        if isnumber( clr_t ) then
            i_timer = clr_t
        end

        /*
            define clrs
        */

        local clr_text      = IsColor( clr_t ) and clr_t or cfg.tips.clrs.text
        local clr_box       = IsColor( clr_i ) and clr_i or cfg.tips.clrs.inner
        local clr_out       = IsColor( clr_o ) and clr_o or cfg.tips.clrs.outline

        /*
            fn > draw tooltip

            @param  : pnl parent
        */

        local function draw_tooltip( parent )

            /*
                check > existing tippy pnl
            */

            if pnl_tippy and ui:ok( pnl_tippy ) then return end

            /*
                define > cursor pos
            */

            local pos_x, pos_y      = input.GetCursorPos( )
            local fnt_tippy         = pid( 'ucl_tippy' )

            /*
                set / get font text size
            */

            local sz_w, sz_h        = helper.str:len( str, fnt_tippy )
            sz_w                    = sz_w + 50
            sz_h                    = sz_h + 8

            /*
                create pnl
            */

            pnl_tippy               = ui.new( 'btn', pnl                    )
            :bsetup                 (                                       )
            :nodraw                 (                                       )
            :pos                    ( pos_x + 10, pos_y - 35                )
            :sz                     ( sz_w, sz_h                            )
            :popup                  (                                       )
            :m2f                    (                                       )
            :var                    ( 'TipWidth', sz_w                      )
            :zpos                   ( 9999                                  )
            :drawtop                ( true                                  )

                                    :logic( function( s )

                                        /*
                                            requires parent pnl
                                        */

                                        if not ui:ok( parent ) then
                                            ui:destroy( pnl_tippy )
                                            return
                                        end

                                        /*
                                            update mouse pos
                                        */

                                        local wid       = s.TipWidth or 0
                                        pos_x, pos_y    = input.GetCursorPos( )
                                        pos_x           = math.Clamp( pos_x, ( sz_w / 2 ) - 10, ScrW( ) - ( sz_w / 2 ) )
                                        pos_y           = math.Clamp( pos_y, 45, ScrH( ) - 0 )

                                        if pos_y <= 50 then
                                            s:SetPos( pos_x + ( 15 / 2 ) - ( wid / 2 ), 50 + 15 )
                                        else
                                            s:SetPos( pos_x + ( 15 / 2 ) - ( wid / 2 ), pos_y - 45 )
                                        end
                                    end )

                                    :draw( function( s, w, h )
                                        design.rbox( 4, 0, 0, sz_w, sz_h, clr_out )
                                        design.rbox( 4, 1, 1, sz_w - 2, sz_h - 2, clr_box )

                                        draw.SimpleText( string.format( '%s' , str ), fnt_tippy, ( w / 2 ), ( sz_h / 2 ), clr_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                                    end )

        end

        /*
            tippy > OnCursorEntered
        */

        pnl.OnCursorEntered = function( s )
            timex.expire    ( pid( 'tippy_destroy' ) )

            draw_tooltip    ( s )
            s.hover         = true

            /*
                tippy > fade in
            */

            if ui:ok( pnl_tippy ) then
                pnl_tippy:SetAlpha  ( 0 )
                pnl_tippy:AlphaTo   ( 255, 0.2, 0.1, function( ) end )
            end

            /*
                tippy timer

                creates a timer which ensures that tippy is destroyed
            */

            timex.create( pid( 'tippy_destroy' ), i_timer, 1, function( this )
                if not ui:ok( pnl_tippy ) then return end
                if ui:ok( pnl_tippy ) then
                    pnl_tippy:AlphaTo( 0, 0.2, 0.1, function( )
                        ui:destroy( pnl_tippy )
                    end )
                end
            end )
        end

        /*
            tippy > OnCursorExited
        */

        pnl.OnCursorExited = function( s )
            if s:IsChildHovered( ) and ui:ok( pnl_tippy ) then
                pnl_tippy:AlphaTo( 0, 0.3, 0.1, function( )
                    ui:destroy( pnl_tippy )
                end )

                return
            end

            ui:destroy      ( pnl_tippy )
            s.hover         = false

            timex.expire    ( pid( 'tippy_destroy' ) )
            timex.expire    ( pid( 'tippy_autohide' ) )
        end
    end
    uclass.tooltip          = uclass.tip
    ui:NewAssoc             ( 'tip|tooltip', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DModel > SetModel

        @param  : str str
        @param  : int skin
        @param  : str bodygrp
    */

    function uclass.mdl( pnl, str, skin, bodygrp )
        skin        = isnumber( skin ) and skin or 0
        bodygrp     = isstring( bodygrp ) and bodygrp or ''
        pnl:SetModel( str, skin, bodygrp )
    end
    ui:NewAssoc             ( 'mdl', 'DFileBrowser, DModelPanel, DModelSelect, SpawnIcon' )

    /*
        uclass > DModel > model autosize

        @param  : str str
        @param  : int skin
        @param  : str bodygrp
    */

    function uclass.mdl_auto( pnl, fov, ofs )
        if not ui:ok( pnl.Entity ) then return end

        fov = isnumber( fov ) and fov or 40
        ofs = isnumber( ofs ) and ofs or 0.5

        local sz            = 0
        local mn, mx        = pnl.Entity:GetRenderBounds( )
        sz                  = math.max( sz, math.abs( mn.x ) + math.abs( mx.x ) )
        sz                  = math.max( sz, math.abs( mn.y ) + math.abs( mx.y ) )
        sz                  = math.max( sz, math.abs( mn.z ) + math.abs( mx.z ) )

        pnl:SetFOV          ( fov                   )
        pnl:SetCamPos       ( Vector( sz, sz, sz )  )
        pnl:SetLookAt       ( ( mn + mx ) * ofs     )
        pnl.Entity:SetPos   ( Vector( 0, 0, 0 )     )
    end
    ui:NewAssoc             ( 'mdl_auto', 'DModelPanel' )

    /*
        uclass > DModel > SetFOV

        @alias  : fov, setfov

        @param  : int i
    */

    function uclass.fov( pnl, i )
        i = isnumber( i ) and i or 120
        pnl:SetFOV( i )
    end
    ui:NewAssoc             ( 'fov', 'DModelPanel' )

    /*
        uclass > DModel > SetAmbientLight

        @param  : clr clr
    */

    function uclass.light( pnl, clr )
        clr = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
        pnl:SetAmbientLight( clr )
    end
    ui:NewAssoc             ( 'light', 'DModelPanel' )

    /*
        uclass > DModel > SetAnimSpeed

        @param  : int val
    */

    function uclass.anim_speed( pnl, val )
        val = isnumber( val ) and val or 1
        pnl:SetAnimSpeed( val )
    end
    ui:NewAssoc             ( 'anim_speed', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > anim > to center

        animation to move panel to center

        dframes may not allow top-down animations to work properly and start the panel off-screen, so the
        effect may not be as desired.

        @param  : pnl pnl
        @param  : int time
        @param  : str, int from > [optional] > default left
    */

    function uclass.anim_center( pnl, time, from )
        if not ui:ok( pnl ) then return end

        local bAnim     = cvar:GetBool( 'rlib_animations_enabled' )

        local w, h      = pnl:GetSize( )
        time            = ( bAnim and time or 0 ) or 0
        from            = ( bAnim and from or 3 ) or 3

        local sta_w, sta_h  = -w, ( ScrH( ) / 2 ) - ( h / 2 )
        local end_w, end_h  = ScrW( ) / 2 - w / 2, ScrH( ) / 2 - h / 2

        if ( from == 'top' or from == 2 ) then
            sta_w, sta_h    = ScrW( ) / 2 - w / 2, - h
        elseif ( from == 'right' or from == 3 ) then
            sta_w, sta_h    = ScrW( ) + w, ( ScrH( ) / 2 ) - ( h / 2 )
        elseif ( from == 'bottom' or from == 4 ) then
            sta_w, sta_h    = ScrW( ) / 2 - w / 2, ScrH( ) + h
        end

        -- just in case
        if not time then
            sta_w, sta_h    = end_w, end_h
        end

        pnl:SetPos  ( sta_w, sta_h )
        pnl:MoveTo  ( end_w, end_h, time, 0, -1 )
    end
    ui.anim_tocenter        = uclass.anim_center
    ui.anim_center          = uclass.anim_center
    ui:NewAssoc             ( 'anim_center', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > appear

        makes pnl appear on-screen
        supports fading effect

        @param  : pnl pnl
        @param  : int pos
        @param  : str, int from > [optional] > default center
        @param  : func fn
    */

    function uclass.appear( pnl, pos, time, fn )
        if not ui:ok( pnl ) then return end

        local bAnim         = cvar:GetBool( 'rlib_animations_enabled' )
        local pad           = 20

        pos                 = ( isnumber( pos ) and pos or isstring( pos ) and pos ) or 5
        time                = ( isnumber( time ) and time ) or 0.3

        /*
            declare > default size
        */

        local w, h          = ui:GetPosition( pnl, pos, pad )

        /*
            panel
        */

        pnl:SetAlpha        ( 0 )
        pnl:SetPos          ( w, h )
        pnl:AlphaTo         ( 255, bAnim and time or 0, 0,
                            function( )
                                if isfunction( fn ) then
                                    fn( )
                                else
                                    return
                                end
                            end )
    end
    ui:NewAssoc             ( 'appear', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Frame, Panel > fade in

        fades in a panel

        @param  : int dur
        @param  : int delay
        @param  : func fn
    */

    function uclass.anim_fadein( pnl, dur, delay, fn )
        if not ui:ok( pnl ) then return end

        dur     = isnumber( dur ) and dur or 0.2
        dur     = not cvar:GetBool( 'rlib_animations_enabled' ) and 0 or dur
        delay   = isnumber( delay ) and delay or 0
        fn      = isfunction( fn ) and fn or function( ) end

        pnl:SetAlpha        ( 0     )
        ui.anim_tocenter    ( pnl   )
        pnl:AlphaTo         ( 255, dur, delay, function( ) fn( ) end )
    end
    ui:NewAssoc             ( 'anim_fadein', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Frame, Panel > fade out

        fades out a panel

        @param  : int dur
        @param  : int delay
        @param  : func fn
    */

    function uclass.anim_fadeout( pnl, dur, delay, fn )
        if not ui:ok( pnl ) then return end

        dur     = dur or 0.2
        dur     = not cvar:GetBool( 'rlib_animations_enabled' ) and 0 or dur
        delay   = delay or 0
        fn      = isfunction( fn ) and fn or function( ) end

        pnl:SetAlpha        ( 255   )
        ui.anim_tocenter    ( pnl   )
        pnl:AlphaTo         ( 0, dur, delay, function( ) fn( ) end )
    end
    ui:NewAssoc             ( 'anim_fadeout', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Frame, Panel > fade in

        forces a pnl to center screen based on animation settings

        @param  : int time
        @param  : str, int from > [optional] > default left
    */

    function uclass.anim_center( pnl, time, from )
        if not ui:ok( pnl ) then return end

        time = time or 0.4
        from = from or 4

        if cvar:GetBool( 'rlib_animations_enabled' ) then
            ui.anim_tocenter( pnl, time, from )
        else
            ui.anim_tocenter( pnl )
        end
    end
    ui:NewAssoc             ( 'anim_center', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DNum > SetMin

        @alias  : min, setmin

        @param  : int min
    */

    function uclass.min( pnl, min )
        min = isnumber( min ) and min or 0
        pnl:SetMin( min )
    end
    ui:NewAssoc             ( 'min', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DListView_Column, DMenu, DNumberScratch, DNumberWang, DNumSlider' )

    /*
        uclass > DNum > SetMax

        @alias  : max, setmax

        @param  : int max
    */

    function uclass.max( pnl, max )
        max = isnumber( max ) and max or 1000
        pnl:SetMax( max )
    end
    ui:NewAssoc             ( 'max', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DListView_Column, DMenu, DNumberScratch, DNumberWang, DNumSlider' )

    /*
        uclass > DNum > minmax

        @alias  : minmax, setminmax

        @param  : int min
        @param  : int max
    */

    function uclass.minmax( pnl, min, max )
        min = isnumber( min ) and min or 0
        pnl:SetMin( min )
        if max then
            pnl:SetMax( max )
        end
    end
    ui:NewAssoc             ( 'minmax', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DListView_Column, DMenu, DNumberScratch, DNumberWang, DNumSlider' )

    /*
        uclass > DNum > SetDecimals

        @param  : int dec
    */

    function uclass.dec( pnl, dec )
        dec = dec or 0
        pnl:SetDecimals( dec )
    end
    ui:NewAssoc             ( 'dec', 'DNumberScratch, DNumberWang, DNumSlider' )

    /*
        uclass > DSlider > SetSlideX

        @param  : int x
    */

    function uclass.slide_x( pnl, x )
        x = x or 0
        pnl:SetSlideX( x )
    end
    ui:NewAssoc             ( 'slide_x', 'DSlider, DNumSlider' )

    /*
        uclass > DSlider > SetSlideX

        @param  : int x
    */

    function uclass.slide_y( pnl, x )
        x = x or 0
        pnl:SetSlideY( x )
    end
    ui:NewAssoc             ( 'slide_y', 'DSlider, DNumSlider' )

    /*
        uclass > DModel > SetCamPos

        @param  : vec pos
    */

    function uclass.cam( pnl, pos )
        pos = isvector( pos ) and pos or Vector( 0, 0, 0 )
        pnl:SetCamPos( pos )
    end
    ui:NewAssoc             ( 'cam', 'DModelPanel' )

    /*
        uclass > DModel > SetLookAt

        @param  : vec pos
    */

    function uclass.look( pnl, pos )
        pos = isvector( pos ) and pos or Vector( 0, 0, 0 )
        pnl:SetLookAt( pos )
    end
    ui:NewAssoc             ( 'look', 'DModelPanel' )

    /*
        uclass > DModel > SetLookAng

        @param  : vec pos
    */

    function uclass.lookang( pnl, pos )
        pos = isvector( pos ) and pos or Vector( 0, 0, 0 )
        pnl:SetLookAng( pos )
    end
    ui:NewAssoc             ( 'lookang', 'DModelPanel' )

    /*
        uclass > ItemStore > SetContainerID

        returns iventory id from itemstore addon from gmodstore

        @param  : int id
    */

    function uclass.inv_id( pnl, id )
        id = isnumber( id ) and id or 0
        pnl:SetContainerID( id )
    end
    ui:NewAssoc             ( 'inv_id', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > OpenURL

        returns iventory id from itemstore addon from gmodstore

        @param  : str uri
    */

    function uclass.url( pnl, uri )
        uri = isstring( uri ) and uri or 'https://get.rlib.io/'
        pnl:OpenURL( uri )
    end
    ui:NewAssoc             ( 'url', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DGrid > AddItem

        @param  : pnl panel
    */

    function uclass.additem( pnl, panel )
        if not panel then return end
        pnl:AddItem( panel )
    end
    ui:NewAssoc             ( 'additem', 'DCategoryList, DForm, DGrid, DNotify, DPanelList, DScrollPanel' )

    /*
        uclass > DGrid > SetCols

        number of columns this panel should have.

        @param  :   int         cols            desired number of columns
    */

    function uclass.col( pnl, cols )
        cols = isnumber( cols ) and cols or 1
        pnl:SetCols( cols )
    end
    ui:NewAssoc             ( 'col', 'DGrid' )

    /*
        uclass > DGrid > SetColWide

        number of columns this panel should have.

        @param  :   int         w               width of each column
    */

    function uclass.col_wide( pnl, w )
        w = isnumber( w ) and w or 1
        pnl:SetColWide( w )
    end
    ui:NewAssoc             ( 'col_wide', 'DGrid' )

    /*
        uclass > DGrid > colstall

        height of each row.
        cell panels (grid items) will not be resized or centered.

        @param  :   int         h               height of row.
    */

    function uclass.col_tall( pnl, h )
        h = isnumber( h ) and h or 20
        pnl:SetRowHeight( h )
    end
    ui:NewAssoc             ( 'col_tall', 'DGrid' )

    /*
        uclass > Set Height

        Sets the height of the panel.

        @param  :   int         h               height of each column.
    */

    function uclass.height( pnl, h )
        h = isnumber( h ) and h or 0
        pnl:SetHeight( h )
    end
    ui:NewAssoc             ( 'height', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Set Header Height

        Sets the height of the panel.

        @param  :   int         h               header height of header column.
    */

    function uclass.hdrheight( pnl, h )
        h = isnumber( h ) and h or 0
        pnl:SetHeaderHeight( h )
    end
    ui:NewAssoc             ( 'hdrheight', 'DCollapsibleCategory, DListView' )

    /*
        DListView:SetDataHeight( number height )

        Sets the height of all lines of the DListView except for the header line.

        @param  :   int         h               header height of each column.
    */

    function uclass.dataheight( pnl, h )
        h = isnumber( h ) and h or 0
        pnl:SetDataHeight( h )
    end
    ui:NewAssoc             ( 'dataheight', 'DListView' )

    /*
         DListView:SetMultiSelect( boolean allowMultiSelect )

        Sets whether multiple lines can be selected by the user by using the ctrl or ⇧ shift keys. When set to false, only one line can be selected.

        @param  :   bool        b
    */

    function uclass.multisel( pnl, b )
        pnl:SetMultiSelect( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'multisel', 'DListView' )

    /*
         DListView:SetSortable( boolean isSortable )

        Enables/disables the sorting of columns by clicking.

        @param  :   bool        b
    */

    function uclass.sortable( pnl, b )
        pnl:SetSortable( helper:val2bool( b ) or false )
    end
    ui:NewAssoc             ( 'sortable', 'DListView' )

    /*
        DListView:AddColumn( string column, number position )

        Adds a column to the listview.

        @param  :   name        str
                :   int         pos
    */

    function uclass.column( pnl, name, pos )
        name = name or 'untitled'
        pnl:AddColumn( name, pos )
    end
    ui:NewAssoc             ( 'column', 'DListView' )

    /*
        uclass > DHTML > img url

        sets the img url to use for a dhtml element
        supports both a string url or a table of strings

        @param  :   int         h               height of each column.
    */

    function uclass.imgurl( pnl, src, bRand )
        bRand = bRand or false
        local img = ui:html_img_full( src, bRand )
        pnl:SetHTML( img )
    end
    ui:NewAssoc             ( 'imgurl', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > RichText > AppendText

        @param  :   str         str
    */

    function uclass.appendtxt( pnl, str )
        str = isstring( str ) and str or ''
        pnl:AppendText( str )
    end
    ui:NewAssoc             ( 'appendtxt', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > RichText > InsertColorChange

        @param  :   clr         clr
    */

    function uclass.appendclr( pnl, clr )
        clr = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
        local clr_append = clr
        pnl:InsertColorChange( clr_append.r, clr_append.g, clr_append.b, clr_append.a )
    end
    ui:NewAssoc             ( 'appendclr', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > RichText > InsertColorChange

        @param  :   clr         clr
    */

    function uclass.appendfont( pnl, face, clr )
        face    = isstring( face ) and face or ''
        clr     = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
        pnl[ 'PerformLayout' ] = function( s, ... )
            s:SetFontInternal( face )
            s:SetFGColor( clr )
        end
    end
    ui:NewAssoc             ( 'appendfont', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > RichText > InsertColorChange, AppendText

        @param  :   str         str
        @param  :   clr         clr
    */

    function uclass.append( pnl, str, clr )
        str = isstring( str ) and str or ''
        clr = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
        if IsColor( clr ) then
            local clr_append = clr
            pnl:InsertColorChange( clr_append.r, clr_append.g, clr_append.b, clr_append.a )
        end
        pnl:AppendText( str )
    end
    ui:NewAssoc             ( 'append', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > SetupAnim

        setup of animations

        @ex     : anim     ( 'OnHoverFill', 5, function( s ) return s:IsHovered( ) end )

        @param  :   str         name
        @param  :   int         sp
        @param  :   func        fn
    */

    function uclass.anim( pnl, name, sp, fn )
        fn = pnl.FnAnim or fn

        pnl[ name ] = 0
        pnl[ 'Think' ] = function( s )
            s[ name ] = Lerp( FrameTime( ) * sp, s[ name ], fn( s ) and 1 or 0 )
        end
    end
    ui:NewAssoc             ( 'anim', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > anim > hover > fill

        animation causes box to slide in from the specified direction

        @ex     :anim_hover_fill( Color( 255, 255, 255, 255 ), LEFT, 10 )

        @param  :   clr         clr
        @param  :   int, enum   dir
        @param  :   int         sp
        @param  :   bool        bDrawRepl
    */

    function uclass.anim_hover_fill( pnl, clr, dir, sp, bDrawRepl )
        clr         = IsColor( clr ) and clr or Color( 5, 5, 5, 200 )
        dir         = dir or LEFT
        sp          = isnumber( sp ) and sp or 10
        mat         = isbool( mat )

        pnl:anim    ( 'OnHoverFill', sp, ui.OnHover )

        local function draw_action( s, w, h )
            local x, y, fw, fh
            if dir == LEFT then
                x, y, fw, fh    = 0, 0, math.Round( w * s.OnHoverFill ), h
            elseif dir == TOP then
                x, y, fw, fh    = 0, 0, w, math.Round( h * s.OnHoverFill )
            elseif dir == RIGHT then
                local prog      = math.Round( w * s.OnHoverFill )
                x, y, fw, fh    = w - prog, 0, prog, h
            elseif dir == BOTTOM then
                local prog      = math.Round( h * s.OnHoverFill )
                x, y, fw, fh    = 0, h - prog, w, prog
            end

            design.box( x, y, fw, fh, clr )
        end

        if not bDrawRepl then
            pnl:drawover( function( s, w, h )
                draw_action( s, w, h )
            end )
        else
            pnl:draw( function( s, w, h )
                draw_action( s, w, h )
            end )
        end
    end
    ui:NewAssoc             ( 'anim_hover_fill', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > anim > hover > fade

        displays a fade animation on hover

        @ex     :anim_hover_fade( Color( 255, 255, 255, 255 ), 5, 0, false )

        @param  :   clr         clr
        @param  :   int         sp
        @param  :   int         r
        @param  :   bool        bDrawRepl
    */

    function uclass.anim_hover_fade( pnl, clr, sp, r, bDrawRepl )
        clr         = IsColor( clr ) and clr or Color( 5, 5, 5, 200 )
        sp          = isnumber( sp ) and sp or 10

        pnl:anim    ( 'OnHoverFade', sp, ui.OnHover )

        local function draw_action( s, w, h )
            local da = ColorAlpha( clr, clr.a * s.OnHoverFade )

            if r and r > 0 then
                design.rbox( r, 0, 0, w, h, da )
            else
                design.box( 0, 0, w, h, da )
            end
        end

        if not bDrawRepl then
            pnl:drawover( function( s, w, h )
                draw_action( s, w, h )
            end )
        else
            pnl:draw( function( s, w, h )
                draw_action( s, w, h )
            end )
        end
    end
    ui:NewAssoc             ( 'anim_hover_fade', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > anim > onclick circle

        creates a simple onclick animation with a poly expanding outward while becoming transparent
        based on mouse position

        @param  :   clr         clr
        @param  :   int         sp_r
        @param  :   int         sp_a
        @param  :   int, bool   a1          ( switch )
        @param  :   bool        a2          ( switch )
    */

    function uclass.anim_click_circle( pnl, clr, sp_r, sp_a, ... )
        clr                 = IsColor( clr ) and clr or Color( 5, 5, 5, 200 )
        sp_r                = isnumber( sp_r ) and sp_r or 2
        sp_a                = isnumber( sp_a ) and sp_a or 1

        /*
            assign varargs
        */

        local args          = { ... }
        local r             = isnumber( args[ 1 ] ) and args[ 1 ] or 100
        local bNoDraw       = ( args[ 2 ] and helper:val2bool( args[ 2 ] ) ) or ( args[ 1 ] and helper:val2bool( args[ 1 ] ) ) or false
                            if bNoDraw then return end

        /*
            defaults
        */

        pnl.radius          = 0
        pnl.a               = 0
        pnl.pos_x           = 0
        pnl.pos_y           = 0

        /*
            PaintOver
        */

        pnl:run( 'PaintOver', function( s, w, h )
            if s.a < 1 then return end

            design.circle_simple( s.pos_x, s.pos_y, s.radius, ColorAlpha( clr, s.a ) )

            s.radius    = Lerp( FrameTime( ) * sp_r, s.radius, r or w )
            s.a         = Lerp( FrameTime( ) * sp_a, s.a, 0 )
        end )

        /*
            DoClick
        */

        pnl:run( 'DoClick', function( cir )
            cir.pos_x, cir.pos_y    = cir:CursorPos( )
            cir.radius              = 0
            cir.a                   = clr.a
        end )
    end
    ui:NewAssoc             ( 'anim_click_circle', 'DButton, DComboBox, DColorPalette, DLabel, DTree, DTree_Node' )

    /*
        uclass > anim > onclick outline

        creates a simple onclick animation with a poly expanding outward while becoming transparent
        based on mouse position

        @param  :   clr         clr
        @param  :   int         sp_r
        @param  :   int         sp_a
        @param  :   int, bool   a1          ( switch )
        @param  :   bool        a2          ( switch )
    */

    function uclass.anim_click_ol( pnl, clr, sp_r, sp_a, ... )
        clr                 = IsColor( clr ) and clr or Color( 5, 5, 5, 200 )
        sp_r                = isnumber( sp_r ) and sp_r or 2
        sp_a                = isnumber( sp_a ) and sp_a or 2

        /*
            assign varargs
        */

        local args          = { ... }
        local r             = isnumber( args[ 1 ] ) and args[ 1 ] or 125
        local bNoDraw       = ( args[ 2 ] and helper:val2bool( args[ 2 ] ) ) or ( args[ 1 ] and helper:val2bool( args[ 1 ] ) ) or false
                            if bNoDraw then return end

        /*
            defaults
        */

        pnl.radius          = 0
        pnl.a               = 0
        pnl.pos_x           = 0
        pnl.pos_y           = 0

        /*
            PaintOver
        */

        pnl:run( 'PaintOver', function( s, w, h )
            if s.a < 1 then return end

            design.circle_ol( s.pos_x, s.pos_y, s.radius, ColorAlpha( clr, s.a ), ColorAlpha( clr, s.a ), ColorAlpha( clr, s.a ) )

            s.radius    = Lerp( FrameTime( ) * sp_r, s.radius, r or w )
            s.a         = Lerp( FrameTime( ) * sp_a, s.a, 0 )
        end )

        /*
            DoClick
        */

        pnl:run( 'DoClick', function( cir )
            cir.pos_x, cir.pos_y    = cir:CursorPos( )
            cir.radius              = 0
            cir.a                   = clr.a
        end )

    end
    ui:NewAssoc             ( 'anim_click_ol', 'DButton, DCheckBox, DColorPalette, DLabel, DTree, DTree_Node' )

    /*
        uclass > anim > fade light

        animates a pnl by setting pnl opacity to X with fade effect

        @param  : int alpha
        @param  : int time
        @param  : func cb
    */

    function uclass.anim_light( pnl, alpha, time, cb )
        alpha   = isnumber( alpha ) and alpha or 255
        time    = isnumber( time ) and time or 0.5
        pnl:AlphaTo( alpha, time, 0, function( )
            cb( pnl )
        end )
    end
    ui:NewAssoc             ( 'anim_light', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > anim > dark

        animates a pnl by setting pnl opacity to X with fade effect

        @param  : int time
        @param  : func cb
    */

    function uclass.anim_dim( pnl, time, cb )
        time    = isnumber( time ) and time or 0.5
        pnl:AlphaTo( 0, time, 0, function( )
            cb( pnl )
        end )
    end
    ui:NewAssoc             ( 'anim_dim', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > anim > to color

        changes pnl color using animated fade

        @param  : clr clr
        @param  : int time
        @param  : func cb
    */

    function uclass.anim_clr( pnl, clr, time, cb )
        clr     = IsColor( clr ) and clr or Color( 255, 255, 255, 255 )
        time    = isnumber( time ) and time or 0.5
        pnl:ColorTo( clr, time, 0, function( )
            cb( pnl )
        end )
    end
    ui:NewAssoc             ( 'anim_clr', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > anim > lerp

        @note   : NewAnimation > OnEnd( )
                  /lua/includes/extensions/client/panel/animation.lua

        @param  : str id
        @param  : int to
        @param  : int dur
        @param  : func cb
    */

    function uclass.anim_lerp( pnl, id, to, dur, cb )
        dur = isnumber( dur ) and dur or 0.20

        local new       = pnl:NewAnimation( dur )
        new.lerp_to     = to
        new.Think       = function( anim, panel, frac )
            local frac_now = calc.ease.gen( frac, 0, 1, 1 )

            if not anim.lerp_from then
                anim.lerp_from = pnl[ id ]
            end

            pnl[ id ]   = Lerp( frac_now, anim.lerp_from, anim.lerp_to )
        end
        new.OnEnd = function( )
            if not cb then return end
            cb( pnl )
        end
    end
    ui:NewAssoc             ( 'anim_lerp', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > lerp > color

        @note   : NewAnimation > OnEnd( )
                  /lua/includes/extensions/client/panel/animation.lua

        @param  : str id
        @param  : int to
        @param  : int dur
        @param  : func cb
    */

    function uclass.anim_lerp_clr( pnl, id, to, dur, cb )
        dur    = isnumber( dur ) and dur or 0.20

        local color     = pnl[ id ]
        local new       = pnl:NewAnimation( dur )
        new.clr         = to
        new.Think       = function( anim, panel, frac )
            local frac_now = calc.ease.gen( frac, 0, 1, 1 )

            if not anim.StartColor then
                anim.StartColor = color
            end

            pnl[ id ]   = helper:clr_lerp( frac_now, anim.StartColor, anim.clr )
        end
        new.OnEnd = function( )
            if not cb then return end
            cb( pnl )
        end
    end
    ui:NewAssoc             ( 'anim_lerp_clr', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > anim > lerp x

        @note   : NewAnimation > OnEnd( )
                  /lua/includes/extensions/client/panel/animation.lua

        @param  : int pos
        @param  : int dur
        @param  : func cb
    */

    function uclass.anim_lerp_x( pnl, pos, dur, cb )
        pos = isnumber( pos ) and pos or 0
        dur = isnumber( dur ) and dur or 0.20

        local new       = pnl:NewAnimation( dur )
        new.pos         = pos
        new.Think       = function( anim, panel, frac )
            local frac_now = calc.ease.gen( frac, 0, 1, 1 )

            if not anim.pos_start then
                anim.pos_start = panel.x
            end

            pnl:SetPos  ( Lerp( frac_now, anim.pos_start, anim.pos ), panel.y )
        end
        new.OnEnd = function( )
            if not cb then return end
            cb( pnl )
        end
    end
    ui:NewAssoc             ( 'anim_lerp_x', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > anim > lerp y

        @note   : NewAnimation > OnEnd( )
                  /lua/includes/extensions/client/panel/animation.lua

        @param  : int pos
        @param  : int dur
        @param  : func cb
    */

    function uclass.anim_lerp_y( pnl, pos, dur, cb )
        pos = isnumber( pos ) and pos or 0
        dur = isnumber( dur ) and dur or 0.20

        local new       = pnl:NewAnimation( dur )
        new.pos         = pos
        new.Think       = function( anim, panel, frac )
            local frac_now = calc.ease.gen( frac, 0, 1, 1 )

            if not anim.pos_start then
                anim.pos_start = panel.y
            end

            pnl:SetPos  ( panel.x, Lerp( frac_now, anim.pos_start, anim.pos ) )
        end
        new.OnEnd = function( )
            if not cb then return end
            cb( pnl )
        end
    end
    ui:NewAssoc             ( 'anim_lerp_y', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > anim > to color

        changes pnl color using animated fade

        @note   : NewAnimation > OnEnd( )
                  /lua/includes/extensions/client/panel/animation.lua

        @param  : clr clr
        @param  : int dur
        @param  : func cb
        @param  : func fn
    */

    function uclass.anim_lerp_w( pnl, w, dur, cb, fn )
        if not dur then dur = 0.20 end
        if not fn then
            fn = function( a, b, c, d )
                return calc.ease.gen( a, b, c, d )
            end
        end

        local new       = pnl:NewAnimation( dur )
        new.w           = w
        new.Think       = function( anim, panel, frac )
            local frac_now = fn( frac, 0, 1, 1 )

            if not anim.w_start then
                anim.w_start = panel:GetWide( )
            end

            pnl:SetWide ( Lerp( frac_now, anim.w_start, anim.w ) )
        end
        new.OnEnd = function( )
            if not cb then return end
            cb( pnl )
        end
    end
    ui:NewAssoc             ( 'anim_lerp_w', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > lerp > fade in

        @ex     : anim_lerp_fi( 10 )
                  uses clr 10, 10, 10 > time 0.20

        @param  : clr clr
        @param  : int time
    */

    function uclass.anim_lerp_fi( pnl, clr, time )
        clr     = ( IsColor( clr ) and clr ) or isnumber( clr ) and Color( clr, clr, clr, 255 ) or Color( 10, 10, 10, 255 )
        time    = isnumber( time ) and time or 0.20

        pnl.ThinkAlpha = pnl.ThinkAlpha or 255

        pnl:anim_lerp( 'ThinkAlpha', 0, time, function( )
            pnl.PaintOver = nil
        end)

        pnl[ 'PaintOver' ] = function( s, w, h )
            design.box( 0, 0, w, h, ColorAlpha( clr, s.ThinkAlpha ) )
        end
    end
    ui:NewAssoc             ( 'anim_lerp_fi', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > Panel > lerp > fade out

        @ex     : anim_lerp_fo( 10 )
                  uses clr 10, 10, 10 > time 0.20

        @param  : clr clr
        @param  : int time
    */

    function uclass.anim_lerp_fo( pnl, clr, time )
        clr     = ( IsColor( clr ) and clr ) or isnumber( clr ) and Color( clr, clr, clr, 255 ) or Color( 10, 10, 10, 255 )
        time    = isnumber( time ) and time or 0.20

        pnl.ThinkAlpha = pnl.ThinkAlpha or 0

        pnl:anim_lerp( 'ThinkAlpha', 255, time, function( )
            pnl.PaintOver   = nil
            pnl:hide        ( )
        end)

        pnl[ 'PaintOver' ] = function( s, w, h )
            design.box( 0, 0, w, h, ColorAlpha( clr, s.ThinkAlpha ) )
        end
    end
    ui:NewAssoc             ( 'anim_lerp_fo', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > avatar

        @param  : ply pl
        @param  : int sz
    */

    function uclass.ply( pnl, pl, sz )
        if not helper.ok.ply( pl ) then return end
        sz = isnumber( sz ) and sz or 32
        pnl:SetPlayer( pl, sz )
    end
    ui:NewAssoc             ( 'ply', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > DFrame > frame

        sets up a frame using various classes
        should be the first thing executed when creating a new frm element
    */

    function uclass.frame( pnl, bPopup, bClose, title )
        if bPopup then
            pnl:popup   ( )
        end
        pnl:showclose   ( bClose )
        pnl:title       ( title )
    end
    ui:NewAssoc             ( 'frame', 'DFrame' )

    /*
        uclass > DButton > setup

        sets up a button using various classes
        should be the first thing executed when creating a new btn element
    */

    function uclass.bsetup( pnl )
        pnl:nodraw          ( )
        pnl:onhover         ( )
        pnl:ondown          ( )
        pnl:ondisabled      ( )
        pnl:notext          ( )
    end
    ui:NewAssoc             ( 'bsetup', 'DButton, DCheckBox' )

    /*
        uclass > combo setup

        sets up a button using various classes
        should be the first thing executed when creating a new btn element
    */

    function uclass.cbosetup( pnl )
        pnl:nodraw          ( )
        pnl:onhover         ( )
        pnl:ondisabled      ( )
        pnl:notext          ( )

        //pnl.DropButton.Paint = function( s, w, h )  end
    end
    ui:NewAssoc             ( 'cbosetup', 'DComboBox' )

    /*
        uclass > register

        @param  : str id
        @param  : str, tbl mod
        @param  : str desc
    */

    function uclass.register( pnl, id, mod, desc )
        if not isstring( id ) then return end
        ui:register( id, mod, pnl, desc )
    end
    ui:NewAssoc             ( 'register', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

    /*
        uclass > unregister

        @param  : str id
        @param  : str, tbl mod
    */

    function uclass.unregister( pnl, id, mod, desc )
        if not isstring( id ) then return end
        ui:unregister( id, mod )
    end
    ui:NewAssoc             ( 'unregister', 'DButton, DLabel, DLabelEditable, DCheckBox, DComboBox, DCategoryList, DCollapsibleCategory, DColorMixer, DColumnSheet, DForm, DFrame, DGrid, DHTML, DHTMLControls, DIconLayout, DImage, DImageButton, DListView, DMenu, DMenuBar, DModelPanel, DNumSlider, DPanel, DPanelList, DProgress, DProperties, DPropertySheet, DRGBPicker, DScrollPanel, DSlider, DTextEntry, DTileLayout, DTree, DVerticalDivider, IconEditor' )

/*
    metatable > ui

    mt registers new associated classes
*/

function dmeta:ui( )
    self.Class = function( pnl, name, ... )
        local fn = uclass[ name ]
        assert( fn, ln( 'logs_inf_pnl_assert', name ) )

        fn( pnl, ... )

        return pnl
    end

    for k, v in pairs( uclass ) do
        self[ k ] = function( pnl, ... )
            if not pnl then return end
            return pnl:Class( k, ... )
        end
    end

    return self
end

/*
    metatable > object

    calls a new object
    this replaces ui.new with a more optimized system
*/

function ui.obj( class, panel, a1, a2 )
    if not class then
        log( 2, ln( 'logs_inf_regclass_err' ) )
        return
    end

    class                   = helper._vgui[ class ] or class

    local bNoDraw           = false
    local name              = 'none'

    if helper:bIsBool( a1 ) then
        name                = isstring( a2 ) and a2 or name
        bNoDraw             = helper.util:toggle( a1 )
    end

    local obj               = vgui.Create( class, panel, name )
                            if not ui:ok( obj ) then return end

    if bNoDraw then
        obj.Paint = function( s, w, h ) end
    end

    obj.Object = function( pnl, name, ... )
        local fn            = uclass[ name ]
        assert( fn, ln( 'logs_inf_pnl_assert', name ) )
        fn( pnl, ... )
        return pnl
    end

    local item              = assoc[ class ] or assoc[ '_index' ]
//  local item              = smt[ class ] or smt[ '_index' ]

    for i = 1, #item, 1 do
        local v = item[ i ]
        obj[ v ] = function( pnl, ... )
            if not pnl then return end
            return pnl:Object( v, ... )
        end
    end

    return obj

end

/*
    ui > new

    creates a new vgui element

    @note   : alias deprecated in v3.1
              will be migrated to ui.new only

    @param  :   str             class
    @param  :   pnl             panel
    @param  :   str, bool       a1
    @param  :   str             a2
*/

function ui.new( class, panel, a1, a2 )
    if not class then
        log( 2, ln( 'logs_inf_regclass_err' ) )
        return
    end

    class           = ui.element( class ) or class

    local bNoDraw   = false
    local name      = 'none'

    if helper:bIsBool( a1 ) then
        name        = isstring( a2 ) and a2 or name
        bNoDraw     = helper.util:toggle( a1 )
    end

    local pnl       = vgui.Create( class, panel, name )
                    if not ui:ok( pnl ) then return end

    if bNoDraw then
        pnl.Paint = function( s, w, h ) end
    end

    return pnl:ui( )
end
ui.gmod = ui.new

/*
    ui > rlib

    creates new pnl for rlib
    pnl must be registered in the modules env / manifest file

    @ex     : ui.rlib( mod, 'rlib_module_pnl' )
            : ui.rlib( mod, 'rlib_module_pnl', parent )

    @param  :   tbl             mod
    @param  :   str             id
    @param  :   pnl             panel
    @param  :   str, bool       a1
    @param  :   str             a2
*/

function ui.rlib( mod, id, panel, a1, a2 )
    if not id then
        log( 2, ln( 'logs_inf_regclass_err' ) )
        return
    end

    local bNoDraw   = false
    local name      = 'none'

    if helper:bIsBool( a1 ) then
        name        = isstring( a2 ) and a2 or name
        bNoDraw     = helper.util:toggle( a1 )
    end

    local call      = rlib:resource( mod, 'pnl', id )
    name            = isstring( name ) and name or 'none'

    local pnl       = vgui.Create( call, panel, name )
                    if not ui:ok( pnl ) then return end

    if bNoDraw then
        pnl.Paint = function( s, w, h ) end
    end

    return pnl:ui( )
end
ui.reg = ui.rlib

/*
    ui > add

    creates a new vgui element, adds the specified object to the panel.
    similar to Panel:Add( )

    @param  :   str             class
    @param  :   pnl             parent
*/

function ui.add( class, parent )
    if not class then
        log( 2, ln( 'logs_inf_regclass_err' ) )
        return
    end

    class = ui.element( class ) or class

    local pnl = parent:Add( class )
    return pnl:ui( )
end

/*
    ui > route // relink

    routes one pnl to another while providing access to metatable classes

    @ex     : mod.pnl.root = ui.route( mod.pnl.root, self )
            : mod.pnl.root = ui.relink( mod.pnl.root, self )

    @param  :   pnl             parent
    @param  :   pnl             pnl
*/

function ui.route( parent, pnl )
    parent = pnl
    return pnl:ui( )
end
uclass.relink     = uclass.route
uclass.symlink    = uclass.route

/*
    ui > get

    returns the metatable for an existing pnl
    useful for continuing where you left off when setting values for a pnl

    @ex     :   local root_pnl  = ui.get( mod.pnl.root )
                :wide           ( 100 )

    @param  :   pnl             pnl
    @param  :   bool            b
*/

function ui.get( pnl, b )
    if not ui:ok( pnl ) then return end

    local bNoDraw           = helper:bIsBool( b ) and helper.util:toggle( b ) or false

                            if bNoDraw then
                                pnl.Paint = function( s, w, h ) end
                            end

    return pnl:ui( )
end

/*
    ui > edit

    allows you to edit a pnl on the fly
    validates the panel first prior and prevents random
    nil pnl errors from occuring

    @ex     : ui.edit( mod.pnl.root, 'wide', 500 )
            : ui.edit( mod.pnl.root, 'zpos', 1 )

    @param  :   pnl             pnl
    @param  :   str             fn_name
    @param  :   varg            ...
*/

function ui.edit( pnl, fn_name, ... )
    if not ui:ok( pnl ) then return end
    if not isstring( fn_name ) then return end

    uclass[ fn_name ]( pnl, ... )
end

/*
    ui > add control

    @ex     :   ui.addcontrol( 'agon_diag_overlay', 'overlay', PANEL, 'DFrame' )

    @param  :   str             name
    @param  :   str             desc
    @param  :   pnl             tab
    @param  :   str             base
*/

function ui.addcontrol( name, desc, tab, base )
    if not name or not tab then return end

    if isnumber( base ) then
        base = helper._vgui_id[ base ]
    elseif isstring( base ) then
        base = ( base and ui.element( base ) )
    else
        base = 'DFrame'
    end

    derma.DefineControl( name, desc, tab, base )
end

/*
    ui > register

    utilities vgui.Register as a shortcut
    used for pnls registered under the rlib:resources( ) method

    if no class provided; defaults to DFrame

    @ex     : ui.addpanel( mod, 'bg', PANEL, 'pnl' )
            : ui.addpanel( mod, 'bg', PANEL )
            : ui.addpanel( mod, 'bg', PANEL, 1 )
            : ui.addpanel( mod, 'bg', PANEL, 2 )

    @param  :   tbl             mod
    @param  :   str             id
    @param  :   pnl             pnl
    @param  :   str, int        class
*/

function ui.addpanel( mod, id, pnl, class )
    if not id or not pnl then return end

    local call = base:resource( mod, 'pnl', id )

    if isnumber( class ) then
        class = helper._vgui_id[ class ]
    elseif isstring( class ) then
        class = ( class and ui.element( class ) )
    else
        class = 'DFrame'
    end

    vgui.Register( call, pnl, class )
end