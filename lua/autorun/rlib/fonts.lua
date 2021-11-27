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
local font                  = base.f

/*
    library > localize
*/

local _f                    = surface.CreateFont

/*
    prefix ids
*/

local function pref( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and base.manifest.prefix ) or false
    return base.get:pref( str, state )
end

/*
 	font > reg

    registers new font with no prefix at the beginning. whatever id is
    provided is what will be used.

    @param  : str id
    @param  : str name
    @param  : int sz
    @param  : int weight
    @param  : bool bShadow
    @param  : bool bExt
*/

function font.reg( id, name, sz, wt, bShadow, bExt, bSym )
    _f( id, { font = name, size = sz, weight = wt, bShadow or false, antialias = true, extended = bExt or false, symbol = bSyn or false } )
end

/*
 	fonts > new

    registers new font with prefix attahed to beginning of font id string

    @param  : str, tbl mod
    @param  : str id
    @param  : str name
    @param  : int sz
    @param  : int weight
    @param  : bool bShadow
    @param  : bool bExt
    @param  : bool bSym
*/

function font.new( mod, id, name, sz, wt, bShadow, bExt, bSym )
    local pf    = istable( mod ) and mod.id or isstring( mod ) and mod or false
    id          = pref( id, pf )

    _f( id, { font = name, size = sz, weight = wt, bShadow or false, antialias = true, extended = bExt or false, symbol = bSyn or false } )
end

/*
 	fonts > get

    returns font id
    all ids have rlib_suffix appended to the front

    @example:   general_name
                rlib.general.name

    @param  : str, tbl mod
    @param  : str id
    @return : str
*/

function font.get( mod, id )
    local pf    = istable( mod ) and mod.id or isstring( mod ) and mod or false
    id          = pref( id, pf )

    return id
end

/*
    new lib font
*/

local _new                  = font.new

/*
    fonts > register
*/

local function fonts_register( pl )

    /*
        perm > reload
    */

        if ( ( helper.ok.ply( pl ) or base.con:Is( pl ) ) and not access:allow_throwExcept( pl, 'rlib_root' ) ) then return end

    /*
        fonts > scale
    */

        local fs            = RScale( 0.4 )

    /*
        fonts > uclass
    */

        _f( pref( 'ucl_font_def' ),                     { size = 16, weight = 400, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'ucl_tippy' ),                        { size = 15, weight = 200, antialias = true, shadow = false, font = 'Roboto Light' } )

    /*
        fonts > design
    */

        _f( pref( 'design_dialog_title' ),	            { size = 36, weight = 100, antialias = true, shadow = true, font = 'Roboto Light' } )
        _f( pref( 'design_dialog_msg' ),		        { size = 20, weight = 100, antialias = true, shadow = false, font = 'Roboto' } )
        _f( pref( 'design_dialog_qclose' ),	            { size = 16, weight = 100, antialias = true, shadow = true, font = 'Roboto Light' } )
        _f( pref( 'design_dialog_sli_title' ),          { size = 23, weight = 100, antialias = true, shadow = true, font = 'Roboto Light' } )
        _f( pref( 'design_dialog_sli_msg' ),            { size = 17, weight = 300, antialias = true, shadow = true, font = 'Roboto' } )
        _f( pref( 'design_dialog_sli_x' ),              { size = 42, weight = 800, antialias = true, shadow = false, font = 'Segoe UI Light' } )
        _f( pref( 'design_text_default' ),              { size = 16, weight = 100, antialias = true, shadow = false, font = 'Roboto Light' } )
        _f( pref( 'design_rsay_text' ),                 { size = 30, weight = 100, antialias = true, shadow = true, font = 'Roboto Light' } )
        _f( pref( 'design_rsay_text_sub' ),             { size = 20, weight = 100, antialias = true, shadow = true, font = 'Roboto Light' } )
        _f( pref( 'design_s1_indc' ),                   { size = 22, weight = 400, antialias = true, shadow = true, font = 'Roboto Light' } )
        _f( pref( 'design_s2_indc' ),                   { size = 40, weight = 400, antialias = true, shadow = true, font = 'Roboto Light' } )
        _f( pref( 'design_s2_indc_sub' ),               { size = 70, weight = 800, antialias = true, shadow = true, font = 'Roboto' } )
        _f( pref( 'design_draw_textscroll' ),           { size = 14, weight = 100, antialias = true, shadow = true, font = 'Roboto Light' } )
        _f( pref( 'design_notify_text' ),               { size = 18, weight = 400, antialias = true, shadow = false, font = 'Roboto Light' } )
        _f( pref( 'design_bubble_msg' ),                { size = 18, weight = 200, antialias = true, shadow = true, font = 'Montserrat Medium' } )
        _f( pref( 'design_bubble_msg_2' ),              { size = 18, weight = 200, antialias = true, shadow = true, font = 'Montserrat Medium' } )
        _f( pref( 'design_bubble_ico' ),                { size = 48, weight = 400, antialias = true, shadow = true, font = 'Roboto Condensed' } )
        _f( pref( 'design_push_name' ),                 { size = 20, weight = 700, antialias = true, shadow = false, font = 'Segoe UI Light' } )
        _f( pref( 'design_push_msg' ),                  { size = 18, weight = 100, antialias = true, shadow = false, font = 'Segoe UI Light' } )
        _f( pref( 'design_push_ico' ),                  { size = 40, weight = 800, antialias = true, font = 'GSym Solid', extended = true } )

    /*
        fonts > elements
    */

        _f( pref( 'elm_tab_name' ),                     { size = 15, weight = 200, antialias = true, font = 'Raleway Light' } )
        _f( pref( 'elm_text' ),                         { size = 17, weight = 400, antialias = true, font = 'Segoe UI Light' } )

    /*
        fonts > lang
    */

        _f( pref( 'lang_close' ),                       { size = 24, weight = 800, antialias = true, font = 'Roboto' } )
        _f( pref( 'lang_icon' ),                        { size = 24, weight = 100, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'lang_title' ),                       { size = 16, weight = 600, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'lang_desc' ),                        { size = 16, weight = 400, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'lang_item' ),                        { size = 16, weight = 400, antialias = true, font = 'Roboto Light' } )

    /*
        fonts > mviewer
    */

        _f( pref( 'mdlv_exit' ),                        { size = 40, weight = 800, antialias = true, font = 'Roboto' } )
        _f( pref( 'mdlv_resizer' ),                     { size = 24, weight = 100, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'mdlv_icon' ),                        { size = 24, weight = 100, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'mdlv_name' ),                        { size = 44, weight = 100, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'mdlv_title' ),                       { size = 16, weight = 600, antialias = true, shadow = true, font = 'Roboto Light' } )
        _f( pref( 'mdlv_clear' ),                       { size = 20, weight = 800, antialias = true, font = 'Roboto' } )
        _f( pref( 'mdlv_enter' ),                       { size = 20, weight = 800, antialias = true, font = 'Roboto' } )
        _f( pref( 'mdlv_control' ),                     { size = 16, weight = 200, antialias = true, font = 'Roboto Condensed' } )
        _f( pref( 'mdlv_searchbox' ),                   { size = 18, weight = 100, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'mdlv_minfo' ),                       { size = 16, weight = 400, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'mdlv_copyclip' ),                    { size = 14, weight = 100, antialias = true, shadow = true, font = 'Roboto Light' } )

    /*
        fonts > servinfo
    */

        _f( pref( 'diag_icon' ),                        { size = 24, weight = 100, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'diag_ctrl_exit' ),                   { size = 40, weight = 200, antialias = true, font = 'Roboto' } )
        _f( pref( 'diag_ctrl_min' ),                    { size = 40, weight = 200, antialias = true, font = 'Roboto' } )
        _f( pref( 'diag_title' ),                       { size = 19, weight = 200, antialias = true, font = 'Segoe UI Light' } )
        _f( pref( 'diag_value' ),                       { size = 30, weight = 600, antialias = true, font = 'Segoe UI Light' } )
        _f( pref( 'diag_hdr_value' ),                   { size = 14, weight = 400, antialias = true, font = 'Segoe UI Light' } )
        _f( pref( 'diag_chart_legend' ),                { size = 14, weight = 400, antialias = true, font = 'Segoe UI Light' } )
        _f( pref( 'diag_chart_value' ),                 { size = 23, weight = 600, antialias = true, font = 'Segoe UI Light' } )
        _f( pref( 'diag_resizer' ),                     { size = 24, weight = 100, antialias = true, font = 'Roboto Light' } )

    /*
        fonts > welcome
    */

        _f( pref( 'welcome_exit' ),                     { size = 36, weight = 800, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'welcome_icon' ),                     { size = 24, weight = 100, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'welcome_title' ),                    { size = 16, weight = 600, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'welcome_name' ),                     { size = 40, weight = 100, antialias = true, font = 'Segoe UI Light' } )
        _f( pref( 'welcome_intro' ),                    { size = 20, weight = 100, antialias = true, font = 'Open Sans Light' } )
        _f( pref( 'welcome_ticker' ),                   { size = 14, weight = 100, antialias = true, font = 'Open Sans' } )
        _f( pref( 'welcome_btn' ),                      { size = 16, weight = 400, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'welcome_data' ),                     { size = 12, weight = 200, antialias = true, font = 'Roboto Light' } )
        _f( pref( 'welcome_fx' ),                       { size = 150, weight = 100, antialias = true, font = 'Roboto Light' } )

    /*
        concommand > reload
    */

        if helper.ok.ply( pl ) or base.con:Is( pl ) then
            base:log( 4, '[ %s ] reloaded fonts', mod.name )
            if not base.con.Is( pl ) then
                base.msg:target( pl, mod.name, 'reloaded fonts' )
            end
        end

end
hook.Add( 'rlib.fonts.register', '_lib_fonts_register', fonts_register )