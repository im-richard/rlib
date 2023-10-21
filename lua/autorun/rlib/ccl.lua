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
local storage               = base.s
local design                = base.d
local ui                    = base.i
local access                = base.a
local cvar                  = base.v
local tools                 = base.t
local font                  = base.f
local materials             = base.m
materials._cache            = { }

/*
    library > localize
*/

local cfg                   = base.settings
local mf                    = base.manifest
local prefix                = mf.prefix
local script                = mf.name

/*
    storage
*/

local path_mats             = mf.paths[ 'dir_mats' ]

/*
    lua > localize
*/

local sf                    = string.format
local log                   = base.log
local route                 = base.msg.route

/*
    localize output functions
*/

local function log( ... )
    base:log( ... )
end

local function route( ... )
    base.msg:route( ... )
end

local function ln( ... )
    return base:lang( ... )
end

/*
    prefix > create id
*/

local function cid( id, suffix )
    local affix     = istable( suffix ) and suffix.id or isstring( suffix ) and suffix or prefix
    affix           = affix:sub( -1 ) ~= '.' and string.format( '%s.', affix ) or affix

    id              = isstring( id ) and id or 'noname'
    id              = id:gsub( '[%p%c%s]', '.' )

    return string.format( '%s%s', affix, id )
end

/*
    prefix > get id
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and mf.prefix ) or false
    return cid( str, state )
end

/*
    library > localize
*/

local _f                    = surface.CreateFont

/*
    helper :: internals :: pco cvars

    command variables to be adjusted when pco is toggled
*/

    helper._pco_cvars =
    {
        { id = 'gmod_mcore_test',                   off = '0', on = '1'     },
        { id = 'mat_queue_mode',                    off = '0', on = '-1'    },
        { id = 'studio_queue_mode',                 off = '0', on = '1'     },
        { id = 'cl_threaded_bone_setup',            off = '0', on = '1'     },
        { id = 'cl_threaded_client_leaf_system',    off = '0', on = '1'     },
        { id = 'r_threaded_client_shadow_manager',  off = '0', on = '1'     },
        { id = 'r_threaded_particles',              off = '0', on = '1'     },
        { id = 'r_threaded_renderables',            off = '0', on = '1'     },
        { id = 'r_queued_ropes',                    off = '0', on = '1'     },
        { id = 'r_shadowfromworldlights',           off = '1', on = '0'     },
        { id = 'nb_shadow_dist',                    off = '1', on = '0'     },
        { id = 'mat_shadowstate',                   off = '1', on = '0'     },
        { id = 'r_shadowrendertotexture',           off = '1', on = '0'     },
        { id = 'r_shadowmaxrendered',               off = '1', on = '0'     },
    }

/*
    helper :: internals :: pco :: hooks

    list of hooks to manage when pco toggled
*/

    helper._pco_hooks =
    {
        { event = 'RenderScreenspaceEffects',       name = 'RenderSharpen'          },
        { event = 'RenderScreenspaceEffects',       name = 'RenderMaterialOverlay'  },
        { event = 'RenderScreenspaceEffects',       name = 'RenderMotionBlur'       },
        { event = 'RenderScreenspaceEffects',       name = 'RenderColorModify'      },
        { event = 'RenderScreenspaceEffects',       name = 'RenderSobel'            },
        { event = 'RenderScreenspaceEffects',       name = 'RenderBloom'            },
        { event = 'RenderScreenspaceEffects',       name = 'RenderSunbeams'         },
        { event = 'RenderScreenspaceEffects',       name = 'RenderToyTown'          },
        { event = 'RenderScreenspaceEffects',       name = 'RenderTexturize'        },
        { event = 'RenderScene',                    name = 'RenderStereoscopy'      },
        { event = 'RenderScene',                    name = 'RenderSuperDoF'         },
        { event = 'PostRender',                     name = 'RenderFrameBlend'       },
        { event = 'PreRender',                      name = 'PreRenderFrameBlend'    },
        { event = 'RenderScreenspaceEffects',       name = 'RenderBokeh'            },
        { event = 'NeedsDepthPass',                 name = 'NeedsDepthPass_Bokeh'   },
        { event = 'PostDrawEffects',                name = 'RenderWidgets'          },
        { event = 'Think',                          name = 'DOFThink'               },
    }

/*
    helper :: predefined materials

    list of internal gmod mat paths
*/

    helper._mat =
    {
        [ 'pp_blur' ]       = 'pp/blurscreen',
        [ 'pp_blur_m' ]     = 'pp/motionblur',
        [ 'pp_blur_x' ]     = 'pp/blurx',
        [ 'pp_blur_y' ]     = 'pp/blury',
        [ 'pp_blur_b' ]     = 'pp/bokehblur',
        [ 'pp_copy' ]       = 'pp/copy',
        [ 'pp_add' ]        = 'pp/add',
        [ 'pp_sub' ]        = 'pp/sub',
        [ 'pp_clr_mod' ]    = 'pp/colour',
        [ 'clr_white' ]     = 'vgui/white',
        [ 'circle' ]        = 'vgui/circle',
        [ 'grad_center']    = 'gui/center_gradient',
        [ 'grad' ]          = 'gui/gradient',
        [ 'grad_up']        = 'gui/gradient_up',
        [ 'grad_down' ]     = 'gui/gradient_down',
        [ 'grad_l']         = 'vgui/gradient-l',
        [ 'grad_r']         = 'vgui/gradient-r',
        [ 'grad_u' ]        = 'vgui/gradient-u',
        [ 'grad_d']         = 'vgui/gradient-d',
    }

/*
    helper :: predefined corners
*/

    helper._corners =
    {
        [ 'corner_8' ]      = 'gui/corner8',
        [ 'corner_16' ]     = 'gui/corner16',
        [ 'corner_32' ]     = 'gui/corner32',
        [ 'corner_64' ]     = 'gui/corner64',
        [ 'corner_512' ]    = 'gui/corner512',
    }

/*
    helper :: bokeh material list

 	list of available bokeh effects
*/

    helper._bokehfx =
    {
        [ 'circles' ]	    = 'rlib/general/fx/bokeh/fx-bokeh-circles.png',
        [ 'gradients' ]	    = 'rlib/general/fx/bokeh/fx-bokeh-gradients.png',
        [ 'outlines' ]	    = 'rlib/general/fx/bokeh/fx-bokeh-outlines.png',
    }

/*
    str_wrap

    takes characters in a string and determines where they need to be 'word-wrapped' based on the length
    provided in the parameters.

    @param  : str phrase
    @param  : int len
    @return : tbl
*/

local function str_wrap( phrase, len )
    local phrase_len    = 0
    local pattern       = '.'

    phrase = string.gsub( phrase, pattern, function( char )
        phrase_len = phrase_len + surface.GetTextSize( char )
        if phrase_len >= len then
            phrase_len = 0
            return '\n' .. char
        end
        return char
    end )

    return phrase, phrase_len
end

/*
    str_crop

    originally developed by FPtje in DarkRP and as time went on I made my own interpretation,
    so credit goes to him.

    @usage  : helper.str:crop( 'your test text', 200, 'Trebuchet18' )

    @param  : str phrase
    @param  : int len
    @param  : str font
    @return : str
*/

function helper.str:crop( phrase, len, font )
    local phrase_len        = 0
    local pattern           = '(%s?[%S]+)'
    local c                 = 1

    if not phrase or not len then
        local notfound = not phrase and 'phrase' or not len and 'length'
        log( 6, 'missing [ %s ] and unable to crop', notfound )
        return false
    end

    if phrase and phrase == '' then
        log( RLIB_LOG_DEBUG, 'phrase contains empty str' )
    end

    if not font then
        font = 'Marlett'
        log( RLIB_LOG_DEBUG, 'strcrop font not specified, defaulting to [%s]', font )
    end

    surface.SetFont( font )

    local excludes  = { '\n', '\t' }
    local spacer    = select( 1, surface.GetTextSize( ' ' ) )

    phrase = string.gsub( phrase, pattern, function( word )

        local char = string.sub( word, 1, 1 )

        for v in rlib.h.get.data( excludes ) do
            if char == v then phrase_len = 0 end
        end

        local str_len   = select( 1, surface.GetTextSize( word ) )
        phrase_len      = phrase_len + str_len

        if str_len >= len then
            local spl_phrase, spl_cursor = str_wrap( word, len )
            phrase_len = spl_cursor
            c = c + 1
            return spl_phrase
        elseif phrase_len < len then
            return word
        end

        if char == ' ' then
            phrase_len = str_len - spacer
            c = c + 1
            return '\n' .. string.sub( word, 2 )
        end
        phrase_len = str_len

        c = c + 1
        return '\n' .. word

    end )

    return phrase, c

end

/*
    str > structure

    formats the text to be properly formatted in a DTextEntry panel.
    returns a table populated with one line per table row, and then total
    number of lines the string has.

    @usage  : helper.str:struct( 'your test text', 200, 'Trebuchet18' )

    @param  :   str             str
    @param  :   int             str
    @param  :   str             fnt
    @param  :   str             ident
    @return : str
*/

function helper.str:struct( str, len, fnt, indent )
    str                     = str or 'err'
    len                     = len or 100
    fnt                     = fnt or 'Marlett'
    indent                  = indent or ''
    local t                 = { '' }

    if fnt then
        surface.SetFont( fnt )
    end

    local function clean( str )
        return str:gsub( '@x%d%d%d','' ):gsub( '','' )
    end

    for prefix, word, suffix, newline in str:gmatch( "([ \t]*)(%S*)([ \t]*)(\n?)" ) do

        if #( clean( t[ #t ] ) ) + #prefix + #clean( word ) > len and #t > 0 then
            table.insert( t, word .. suffix ) -- new element
        else -- add to the last element
            t[ #t ] = t[ #t ] .. prefix .. word .. suffix
        end

        if #newline > 0 then table.insert( t, '' ) end
    end

    local x, y      = surface.GetTextSize( ' ' )

    return indent .. table.concat( t, '\n' .. indent ), t, y
  end

/*
    failsafe check

    checks to see if any theme properties are missing

    @param  : tbl tbl
    @param  : str val
    @return : bool
*/

function helper:fscheck( tbl, val )
    for k, v in pairs( tbl ) do
        if ( istable( v ) ) and ( v.id == val ) then return true end
    end
    return false
end

/*
    access :: initialize

    on server start, load all permissions provided through a table.

    if no table specified; will load base script permissions which are in rlib.permissions table

    function is called both server and clientside due to different admin mods registering permissions
    differently; as well as other functionality.

    @call   : access:initialize( base.modules.permissions )
    @param  : tbl perms
*/

function access:initialize( perms )

    access.admins = { }

    if not perms then perms = base.permissions end

    local cat   = perms[ 'index' ] and perms[ 'index' ].category or script
    local sw    = ln( 'perms_type_base' )

    for k, v in pairs( perms ) do
        if ( k == ln( 'perms_flag_index' ) or k == ln( 'perms_flag_setup' ) ) then continue end
        local id = isstring( v.id ) and v.id or k

        if serverguard then

            /*
                permissions :: serverguard
            */

            id          = ( isstring( v.svg_id ) and v.svg_id ) or v.id or k
            serverguard.permission:Add( id )
            sw          = ln( 'perms_type_sg' )

        elseif SAM_LOADED and sam then

            /*
                permissions > sam
            */

            id          = ( isstring( v.sam_id ) and v.sam_id ) or v.id or k
            cat         = perms[ k ].category or cat
            local grp   = perms[ k ].access or perms[ k ].usrlvl or 'superadmin'

            sam.permissions.add( id, cat, grp )

            sw = ln( 'perms_type_sam' )

        end

        rlib:log( RLIB_LOG_PERM, ln( 'perms_add', sw, perms[ k ].id ) )
    end

end
hook.Add( pid( 'initialize.post' ), pid( 'initialize_perms' ), access.initialize )

/*
    rnet > debug > switch

    returns debug mode on / off for client
*/

local function netlib_debug_switch( len, pl )
    local b             = net.ReadBool( )

    base.settings.debug.enabled = b
end
net.Receive( 'rlib.debug.sw', netlib_debug_switch )

/*
    netlib :: debug :: ui

    prompts an in-game notification for issues

    @assoc  : konsole:send( )
*/

local function netlib_debug_ui( )
    if not helper.ok.ply( LocalPlayer( ) ) then return end

    local cat       = net.ReadInt( 4 )
    local msg       = net.ReadString( )

    cat             = cat or 1
    msg             = msg or ln( 'debug_receive_err' )

    design:notify( cat, msg )
    design:bubble( msg, 5 )
end
net.Receive( 'rlib.debug.ui.cl', netlib_debug_ui )

/*
    netlib :: user management update

    only update the table when it has been modified
*/

local function netlib_user( )
    if not helper.ok.ply( LocalPlayer( ) ) then return end
    local tbl_access    = net.ReadTable( )
    access.admins       = istable( tbl_access ) and tbl_access or { }
end
net.Receive( 'rlib.user', netlib_user )

/*
    netlib :: user :: update

    only update the table when it has been modified

    @note   : 3 second delay from server
*/

local function netlib_user_update( )
    if not helper.ok.ply( LocalPlayer( ) ) then return end
    local pl = LocalPlayer( )

    cvar:Prepare( )

    /*
        create ply var table
    */

    pl.rlib         = pl.rlib or { }
end
net.Receive( 'rlib.user.update', netlib_user_update )

/*
    rlib :: initialize

    executes numerous processes including the updater, rdo, hooks, and workshop registration

    @parent : hook, Initialize
*/

local function initialize( )
    timex.simple( '__lib_initialize', 1, function( )
        for l, m in SortedPairs( base.w ) do
            steamworks.FileInfo( l, function( res )
                if not res or not res.title then return end
                base.w[ l ].steamapi = { title = res.title }
                log( RLIB_LOG_WS, ln( 'ws_registered', res.title, l ) )
            end )
        end

        rhook.run.rlib( 'rlib_server_ready' )
    end )

    timex.simple( 10, function( )
        hook.Run( pid( '__lib_engine' ) )
    end )
end
hook.Add( 'Initialize', pid( '__lib_initialize' ), initialize )

/*
    rlib :: initialize :: post

    called within gmod hook InitPostEntity which is after all steps related to rlib and rcore should be
    loaded.

    registration hooks include
        : commands      rlib.cmd.register
        : packages      rlib.pkg.register
        : net           rlib.net.register
        : fonts         rlib.fonts.register

    commonly used for actions such as registering permissions, concommands, etc.
*/

local function __lib_initpostentity( )

    /*
        hooks > register
    */

    rhook.run.rlib( 'rlib_cmd_register' )
    rhook.run.rlib( 'rlib_pkg_register' )
    rhook.run.rlib( 'rlib_rnet_register' )
    rhook.run.rlib( 'rlib_fonts_register' )

    /*
        register commands
    */

    rcc.prepare( )

    /*
        hooks > initialize
    */

    rhook.run.rlib( 'rlib_initialize_post' )

    /*
        storage > materials
    */

    local path          = storage.mft:getpath( 'dir_mats' )
    storage.dir.create  ( path )

end
hook.Add( 'InitPostEntity', pid( '__lib_initpostentity' ), __lib_initpostentity )

/*
    library > post loader
*/

local function __lib_loader_post( )
    hook.Run( 'rlib.fonts.register' )
end
hook.Add( 'rlib.loader.post', pid( '__lib_loader_post' ), __lib_loader_post )

/*
 	rlib :: think :: resolution

 	monitor resolution changes

 	@todo   : deprecate
*/

local i_rlib_think = 0
local function th_pl_res( )
    if i_rlib_think > CurTime( ) then return end
    if not helper.ok.ply( LocalPlayer( ) ) then return end
    local pl = LocalPlayer( )

    -- rather than painting positions, just store the players old monitor resolution
    -- and reinit the ui if the monitor resolution changes.
    if not ( pl.scnres_w or pl.scnres_h ) or ( pl.scnres_w ~= ScrW( ) or pl.scnres_h ~= ScrH( ) ) then
        pl.scnres_w, pl.scnres_h = ScrW( ), ScrH( )
    end

    i_rlib_think = CurTime( ) + 0.5
end
hook.Add( 'Think', pid( 'think.pl.res' ), th_pl_res )

/*
    cvars :: onchangecb

    executed when a cvar has been modified
    may not include all cvars; only important ones that require monitoring

    @param  : str name
    @param  : str old
    @param  : str new
*/

local function cvar_cb_lang( name, old, new )
    local lang = cfg.langlst[ new ] or new
    design:nms( ln( 'lang_title' ), ln( 'lang_msg_change', lang ) )
end
cvars.AddChangeCallback( 'rlib_language', cvar_cb_lang )

/*
 	tools > lang > run
*/

function tools.lang:Run( )
    if ui:ok( tools.lang.pnl ) then
        ui:dispatch( tools.lang.pnl )
        return
    end

    tools.lang.pnl          = ui.new( 'rlib.lo.language'        )
    :actshow                (                                   )
end
rcc.new.gmod( pid( 'lang' ), tools.lang.Run )

/*
    tools > pco > run
*/

function tools.pco:Run( bEnable )
    bEnable = bEnable or false

    for k, v in pairs( helper._pco_cvars ) do
        local val = ( bEnable and ( v.on or 1 ) ) or ( v.off or 0 )
        rcc.run.gmod( v.id, val )
    end

    if cfg.pco.hooks then
        for k, v in pairs( helper._pco_hooks ) do
            if bEnable then
                hook.Remove( v.event, v.name )
            else
                hook.Add( v.event, v.name )
            end
        end
    end

    hook.Add( 'OnEntityCreated', 'rlib_widget_entcreated', function( ent )
        if ent:IsWidget( ) then
            hook.Add( 'PlayerTick', 'rlib_widget_tick', function( pl, mv )
                widgets.PlayerTick( pl, mv )
            end )
            hook.Remove( 'OnEntityCreated', 'rlib_widget_entcreated' )
        end
    end )
end

/*
 	tools > welcome > run

 	welcome interface for ?setup
*/

function tools.welcome:Run( )
    if not access:bIsRoot( LocalPlayer( ) ) then return end

    /*
        destroy existing pnl
    */

    if ui:ok( tools.welcome.pnl ) then
        ui:dispatch( tools.welcome.pnl )
        return
    end

    /*
        about > network update check
    */

    net.Start               ( 'rlib.welcome'    )
    net.SendToServer        (                   )

    /*
        create / show parent pnl
    */

    tools.welcome.pnl       = ui.new( 'rlib.lo.welcome'         )
    :title                  ( ln( 'welcome_title' )             )
    :actshow                (                                   )
end
rcc.new.gmod( pid( 'welcome' ), tools.welcome.Run, nil, nil, FCVAR_PROTECTED )

/*
    netlib > tools > lang

    initializes lang selector ui
*/

local function netlib_lang( )
    tools.lang:Run( )
end
net.Receive( 'rlib.tools.lang', netlib_lang )

/*
    netlib > tools > pco

    player-client-optimizations
*/

local function netlib_pco( )
    local b = net.ReadBool( )
    tools.pco:Run( b )
end
net.Receive( 'rlib.tools.pco', netlib_pco )

/*
    cvar :: prepare

    called client-side when cvars need to be registerd with a player
*/

function cvar:Prepare( )
    if not istable( ui.cvars ) then return end

    local _toregister = { }
    for k, v in helper:sortedkeys( ui.cvars ) do
        _toregister[ #_toregister + 1 ] = v
    end

    table.sort( _toregister, function( a, b ) return a.sid < b.sid end )

    for k, v in pairs( _toregister ) do
        if base._def.elements_ignore[ v.stype ] then continue end
        cvar:Setup( v.stype, v.id, v.default, v.values, v.forceset, v.desc )
    end
end

/*
    cvar :: setup

    assigns a clientconvar based on the parameters specified. these convars will then be used later in
    order for the player.

    forceset will ensure that if the server owner ever updates the core theme manifest that it will
    auto-push the updated changes to the client on next connection

    @param  : str flag
    @param  : str id
    @param  : str def
    @param  : tbl vals
    @param  : bool forceset
    @param  : str help
    @return : void
*/

function cvar:Setup( flag, id, def, vals, forceset, help )
    if not helper.str:valid( flag ) or not helper.str:valid( id ) then
        log( 2, ln( 'properties_setup' ) )
        return false
    end

    forceset    = forceset or false
    help        = isstring( help ) and help or 'no description'

    if ( flag ~= 'rgba' ) and ( flag ~= 'object' ) and ( flag ~= 'dropdown' ) and ( flag ~= 'hexa' ) then
        if not def then
            id = id or 'Unknown'
            base:log_net( 2, 'Library [ %s ] : Player [ %s ] CL error:\n                               No default value set for %s - %s', mf.name, LocalPlayer( ):palias( ), id, 'cl_cvar.lua' )
            return
        end

        CreateClientConVar( id, def, true, false, help )
        if forceset then
            local cvar = GetConVar( id )
            cvar:SetString( def )
        end
    elseif flag == 'dropdown' then
        CreateClientConVar( id, def or 'None', true, false, help )
        if forceset then
            local cvar = GetConVar( id )
            cvar:SetString( def )
        end
    elseif flag == 'object' or flag == 'rgba' or flag == 'hexa' then
        if not istable( vals ) then return end
        for dn, dv in pairs( vals ) do
            local assign_id = string.format( '%s_%s', id, dn )
            CreateClientConVar( assign_id, dv, true, false, help )
            if forceset then
                local cvar = GetConVar( assign_id )
                cvar:SetString( dv )
            end
        end
    end
end

/*
    cvar :: client create

    create a client convar

    @param  : str name
    @param  : str default
    @param  : bool save
    @param  : bool udata
    @param  : str help
*/

function cvar:CreateClient( name, default, save, udata, help )
    if not helper.str:valid( name ) then
        log( 2, ln( 'cvar_missing_name' ) )
        return false
    end

    if not ConVarExists( name ) then
        if not default then
            log( 2, ln( 'cvar_missing_def', name ) )
            return false
        end

        save        = save or true
        udata       = udata or false
        help        = help or 'auto-created by rlib'

        CreateClientConVar( name, default, save, udata, help )
        log( 6, ln( 'cvar_added', name ) )
    end
end


/*
    material ( global )

    @param  : str mat
    @param  : str params
*/

function mat2d( mat, params )
    mat             = isstring( mat ) and mat or false
                    if not mat then return end

    params          = isstring( params ) and params or 'noclamp smooth'

    return Material( mat, params )
end

/*
    materials > cached > get

    @param  : str path
    @return : material
*/

function materials.g_Cached( path )
	return Material( 'data/' .. path, 'smooth mips' )
end

/*
    materials > cached > get

    materials.g_Download( "https://cdn.rlib.io/wp/a/gmod.png", function( mat )
        mat:SetInt( "$flags", bit.bor( mat:GetInt( "$flags" ), 32768 ) )
        print( mat )
    end )

    materials.g_Download( "https://cdn.rlib.io/wp/a/gmod.png", function( mat )
        local mat_new = mat
    end )

    materials.g_Download( "https://cdn.rlib.io/wp/a/gmod.png" )

    @param  : str url
    @param  : func cb
    @param  : str cb_err
    @return : material
*/

function materials.g_Download( url, cb, cb_err )
	local uid           = util.CRC( url )
    cb                  = isfunction( cb ) and cb or false
    cb_err              = cb_err or string.format( 'Error downloading material from [ %s ]', url )

	if materials._cache[ uid ] then return cb( materials._cache[ uid ] ) end

    local path          = string.format( '%s/%s_%s', path_mats, uid, url:match( "([^/]+)$" ) )

	if file.Exists( path, 'DATA' ) then
		materials._cache[ uid ] = materials.g_Cached( path )
        if isfunction( cb ) then
            base:log( RLIB_LOG_DEBUG, '[ %s ] » material ( cache ) » [ %s ]', mf.name, url )
		    return cb( materials._cache[ uid ] )
        else
            base:log( RLIB_LOG_DEBUG, '[ %s ] » material ( cache ) » [ %s ]', mf.name, url )
            return materials._cache[ uid ]
        end
	end

	http.Fetch( url, function( body )
		if not helper.str:ok( body ) then return end

		file.Write( path, body )

		materials._cache[ uid ] = materials.g_Cached( path )

        if isfunction( cb ) then
            base:log( RLIB_LOG_DEBUG, '[ %s ] » material ( new ) » [ %s ]', mf.name, url )
		    cb( materials._cache[ uid ] )
        else
            base:log( RLIB_LOG_DEBUG, '[ %s ] » material ( new ) » [ %s ]', mf.name, url )
            return materials._cache[ uid ]
        end
	end, cb_err )
end

/*
    materials > get

    determines if the provided resource is a material

    @param  : str mat
    @return : bool
*/

function materials:get( mat, params )
    return mat2d( mat, params )
end

/*
    materials :: valid

    determines if the provided resource is a material

    @param  : str mat
    @return : bool
*/

function materials:valid( mat )
    return type( mat ) == 'IMaterial' and not mat:IsError( ) and tostring( mat ) ~= 'Material [debug/debugempty]' and mat or false
end
materials.ok = materials.valid

/*
    materials :: get source materials table

    returns specified module table

    @since  : v3.0.0

    @param  : str, tbl mod
    @return : tbl
*/

function materials:g_Manifest( mod )
    if not mod then
        log( 2, 'specified module not available\n%s', debug.traceback( ) )
        return false
    end

    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].enabled ) then
        return rcore.modules[ mod ].mats
    elseif istable( mod ) then
        return mod.mats
    end

    mod = isstring( mod ) and mod or 'unknown'
    log( 6, 'cannot fetch materials manifest table for invalid module [ %s ]\n%s', mod, debug.traceback( ) )

    return false
end

/*
    materials :: register

    takes a list of materials provided in a table and loads them into a system which can be used later
    to call a material client-side, without the need to define the material.

    source material folder takes 3 paramters:

        [ 1 ] unique name, [ 2 ] path to image, [ 3 ] parameters

    if [ 3 ] is not specified, it will automatically apply 'noclamp smooth' to each material.
    only use [ 3 ] if you wish to not use both noclamp and smooth as your material parameters.

    @src    :   materials =
                {
                    { 'uniquename', 'materials/folder/image.png', 'noclamp smooth' }
                }

    @call   : rlib.m.register( materials )
            : rlib.m.register( materials, 'base' )
            : rlib.m.register( materials, 'base', 'mat' )

    @result : m_rlib_uniquename
            : mbase_uniquename
            : matbase_uniquename

    @syntax : once your materials have been loaded, you can call for one such as the result examples above.
            : <append>_<suffix>_<src>
            : <m>_<rlib>_<uniquename
            : m_rlib_uniquename

    @since  : v1.0.0

    @param  : tbl src
    @param  : str suffix
    @param  : str append
    @return : void
*/

function materials:register_v1( src, suffix, append )
    if not src then return end
    if not suffix then suffix = base.id end
    if not append then append = 'm' end

    suffix  = suffix:lower( )
    append  = append:lower( )
    base.m  = base.m or { }

    for _, m in pairs( src ) do
        if m[ 3 ] then
            base.m[ append .. '_' .. suffix .. '_' .. m[ 1 ] ] =
            {
                material    = Material( m[ 2 ], m[ 3 ] ),
                path        = m[ 2 ],
            }
            log( 6, '[L] [' .. append .. '_' .. suffix .. '_' .. m[ 1 ] .. ']' )
        else
            base.m[ append .. '_' .. suffix .. '_' .. m[ 1 ] ] =
            {
                material    = Material( m[ 2 ], 'noclamp smooth' ),
                path        = m[ 2 ]
            }
            log( 6, '[L] [' .. append .. '_' .. suffix .. '_' .. m[ 1 ] .. ']' )
        end
    end
end

/*
    materials :: register

    @since  : v3.0.0

    @param  : tbl, str src
    @return : void
*/

function materials:register( mod )
    if not mod then
        log( 2, 'specified module not available\n%s', debug.traceback( ) )
        return
    end

    local mnfst_mats    = self:g_Manifest( mod )
    mod._cache          = mod._cache or { }
    mod._cache.mats     = { }

    for id, m in pairs( mnfst_mats ) do
        if not m[ 1 ] then continue end

        local mpath     = m[ 1 ]
        local flag      = isstring( m[ 2 ] ) and m[ 2 ] or 'noclamp smooth'
        mod._cache.mats[ id ] =
        {
            material    = Material( mpath, flag ),
            path        = mpath
        }

        log( 6, '[L] [' .. mpath .. ']' )
    end
end

/*
    materials :: get cache

    returns registered materials for a specified module

    @since  : v3.0.0

    @param  : str, tbl mod
    @param  : tbl
    @return : tbl
*/

function materials:cache( mod, src )
    if not mod then
        log( 2, 'specified module not available\n%s', debug.traceback( ) )
        return
    end

    local bSuccess, m = false, nil
    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].enabled ) then
        bSuccess    = true
        m           = rcore.modules[ mod ]
    elseif istable( mod ) then
        bSuccess    = true
        m           = mod
    end

    if not bSuccess then
        log( 2, 'unspecified module called for material loader\n%s', debug.traceback( ) )
        return
    end

    src = ( istable( src ) or isstring( src ) and m[ src ] ) or m._cache.mats

    if not istable( src ) then
        log( 2, 'no cached materials registered with mod\n%s', debug.traceback( ) )
        return
    end

    return src
end

/*
    materials :: call

    returns a registered material assigned via the id
    id is stored in the module manifest file

    @ex     : materials:call( mod, id )
            : materials:call( mod, 'pnl_test' )

    @since  : v3.0.0

    @param  : tbl, str mod
    @param  : str id
    @param  : str ref
*/

function materials:call( mod, id, ref )
    if not mod then
        log( 2, 'cannot call material; invalid module specified\n%s', debug.traceback( ) )
        return
    end

    if not id then
        log( 2, 'cannot call material; invalid id specified\n%s', debug.traceback( ) )
        return
    end

    ref = isstring( ref ) and ref or 'material'

    return mod._cache.mats[ id ] and mod._cache.mats[ id ][ ref ] or '__error'
end

/*
    ratio > height

    scales an image based on a new provided scale
    takes height as the primary

    ratio   = W / H
    W       = H * ratio
    H       = W / ratio
*/

function materials:ratioHeight( mat, h )
    local src               = materials:ok( mat ) and mat or istable( mat ) and mat.material or isstring( mat ) and mat
    src                     = isstring( src ) and Material( src, 'noclamp smooth' ) or src or mat_def
    h                       = h or 1

    local mat_w, mat_h      = mat:Width( ), mat:Height( )
    local ratio             = mat_w / mat_h     -- original width / original height
    local new_h             = h                 -- ratio * desired height
    local new_w             = ratio * new_h     -- desired height * ratio

    return new_w, new_h
end

/*
    ratio > width

    scales an image based on a new provided scale
    takes width as the primary

    ratio   = W / H
    W       = H * ratio
    H       = W / ratio
*/

function materials:ratioWidth( mat, w )
    local src               = materials:ok( mat ) and mat or istable( mat ) and mat.material or isstring( mat ) and mat
    src                     = isstring( src ) and Material( src, 'noclamp smooth' ) or src or mat_def
    w                       = w or 1

    local mat_w, mat_h      = mat:Width( ), mat:Height( )
    local ratio             = mat_w / mat_h     -- original width / original height
    local new_w             = w                 -- ratio * desired height
    local new_h             = new_w / ratio     -- desired height * ratio

    return new_w, new_h
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
    id          = pid( id, pf )

    _f( id, { font = name, size = sz, weight = wt, bShadow or false, antialias = true, extended = bExt or false, symbol = bSyn or false } )

    base:log( RLIB_LOG_FONT, '+ font » %s', id )
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
    id          = pid( id, pf )

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

        if ( ( helper.ok.ply( pl ) or access:bIsConsole( pl ) ) and not access:allow_throwExcept( pl, 'rlib_root' ) ) then return end

    /*
        fonts > scale
    */

        local fs            = rfs.scale( )

    /*
        fonts > uclass
    */

        _new( false, 'ucl_font_def',                    'Roboto Light',         16 * fs, 400, false )
        _new( false, 'ucl_tippy',                       'Segoe UI Light',       18 * fs, 200, false )
        _new( false, 'ucl_ddl_item',                    'Segoe UI',             15 * fs, 100, false )

    /*
        fonts > design
    */

        _new( false, 'design_dialog_sli_title',         'Segoe UI Light',       23 * fs, 100, true )
        _new( false, 'design_dialog_sli_msg',           'Segoe UI Light',       19 * fs, 100, true )
        _new( false, 'design_dialog_sli_x',             'Segoe UI Light',       42 * fs, 800, false )
        _new( false, 'design_text_default',             'Roboto Light',         16, 100, false )
        _new( false, 'design_rsay_text',                'Roboto Light',         30, 100, true )
        _new( false, 'design_rsay_text_sub',            'Roboto Light',         20, 100, true )
        _new( false, 'design_draw_textscroll',          'Roboto Light',         14, 100, true )
        _new( false, 'design_bubble_msg',               'Montserrat Medium',    16 * fs, 200, true )
        _new( false, 'design_bubble_ico',               'Roboto Condensed',     48 * fs, 400, true )

    /*
        fonts > notification > notify
    */

        _new( false, 'design_notify_msg',               'Roboto Light',         18 * fs, 200, false )

    /*
        fonts > notification > push
    */

        _new( false, 'design_push_name',                'Segoe UI Light',       18 * fs, 700, false )
        _new( false, 'design_push_msg',                 'Segoe UI Light',       16 * fs, 100, false )
        _new( false, 'design_push_ico',                 'GSym Solid',           28 * fs, 800, false, true )

    /*
        fonts > notification > sos
    */

        _new( false, 'design_sos_name',                 'Segoe UI Light',       20 * fs, 700, false, false )
        _new( false, 'design_sos_msg',                  'Segoe UI Light',       17 * fs, 100, false, false )
        _new( false, 'design_sos_ico',                  'GSym Solid',           27 * fs, 800, false, true )



    /*
        fonts > notification > nms
    */

        _new( false, 'design_nms_name',                 'Segoe UI Light',       46, 100, false, false )
        _new( false, 'design_nms_msg',                  'Segoe UI Light',       26, 100, false, false )
        _new( false, 'design_nms_qclose',               'Roboto Light',         20, 100, true, false )
        _new( false, 'design_nms_ico',                  'GSym Solid',           68, 800, false, true )

    /*
        fonts > notification > restart
    */

        _new( false, 'design_rs_title',                 'Segoe UI Light',       36 * fs, 400, false, false )
        _new( false, 'design_rs_cntdown',               'Segoe UI Light',       60 * fs, 200, false, false )
        _new( false, 'design_rs_status',                'Segoe UI Light',       34 * fs, 200, false, false )

    /*
        fonts > notification > debug
    */

        _new( false, 'design_debug_title',              'Segoe UI Light',       26 * fs, 800, false, false )
        _new( false, 'design_debug_cntdown',            'Segoe UI Light',       36 * fs, 800, false, false )
        _new( false, 'design_debug_status',             'Segoe UI Light',       30 * fs, 200, false, false )

    /*
        fonts > elements
    */

        _new( false, 'elm_tab_name',                    'Raleway Light',        15, 200, false, false )
        _new( false, 'elm_text',                        'Segoe UI Light',       17, 400, false, false )

    /*
        fonts > about
    */

        _new( false, 'about_exit',                      'Roboto', 24,           800, false, false )
        _new( false, 'about_resizer',                   'Roboto Light',         24, 100, false, false )
        _new( false, 'about_icon',                      'Roboto Light',         24, 100, false, false )
        _new( false, 'about_name',                      'Roboto Light',         44, 100, false, false )
        _new( false, 'about_title',                     'Roboto Light',         16, 600, false, false )
        _new( false, 'about_entry',                     'Roboto', 15,           300, false, false )
        _new( false, 'about_entry_label',               'Roboto', 17,           200, false, false )
        _new( false, 'about_entry_value',               'Roboto Light',         17, 200, false, false )
        _new( false, 'about_status',                    'Roboto', 14,           800, false, false )
        _new( false, 'about_status_conn',               'Roboto', 14,           400, false, false )

    /*
        fonts > rcfg
    */

        _new( false, 'rcfg_exit',                       'Roboto Light',         36, 800, false, false )
        _new( false, 'rcfg_refresh',                    'Roboto Light',         24, 800, false, false )
        _new( false, 'rcfg_resizer',                    'Roboto Light',         24, 100, false, false )
        _new( false, 'rcfg_icon',                       'Roboto Light',         24, 100, false, false )
        _new( false, 'rcfg_name',                       'Segoe UI Light',       40, 100, false, false )
        _new( false, 'rcfg_sub',                        'Roboto Light',         16, 100, false, false )
        _new( false, 'rcfg_title',                      'Roboto Light',         16, 600, false, false )
        _new( false, 'rcfg_entry',                      'Roboto',               15, 300, false, false )
        _new( false, 'rcfg_entry',                      'Roboto',               15, 300, false, false )
        _new( false, 'rcfg_entry',                      'Roboto',               14, 800, false, false )
        _new( false, 'rcfg_status_conn',                'Roboto',               14, 400, false, false )
        _new( false, 'rcfg_lst_name',                   'Roboto Lt',            18, 100, false, false )
        _new( false, 'rcfg_lst_ver',                    'Roboto Lt',            14, 500, false, false )
        _new( false, 'rcfg_lst_rel',                    'Segoe UI Light',       19, 100, false, false )
        _new( false, 'rcfg_lst_desc',                   'Roboto Lt',            13, 100, false, false )
        _new( false, 'rcfg_sel_name',                   'Roboto Lt',            32, 100, false, false )
        _new( false, 'rcfg_sel_ver',                    'Roboto Lt',            16, 600, false, false )
        _new( false, 'rcfg_sel_rel',                    'Segoe UI Light',       14, 100, false, false )
        _new( false, 'rcfg_sel_desc',                   'Roboto Lt',            17, 100, false, false )
        _new( false, 'rcfg_footer_i',                   'Roboto',               13, 400, false, false )
        _new( false, 'rcfg_symbol',                     'GSym Light',           48, 800, false, true )
        _new( false, 'rcfg_soon',                       'Segoe UI Light',       36, 100, false, false )
        _new( false, 'rcfg_ws',                         'Segoe UI Light',       20, 100, false, false )

    /*
        fonts > lang
    */

        _new( false, 'lang_close',                      'Roboto',               34 * fs, 800, false, false )
        _new( false, 'lang_icon',                       'Roboto Light',         24 * fs, 100, false, false )
        _new( false, 'lang_title',                      'Roboto Light',         16 * fs, 600, false, false )
        _new( false, 'lang_desc',                       'Segoe UI Light',       18 * fs, 200, false, false )
        _new( false, 'lang_item',                       'Roboto Light',         16 * fs, 400, false, false )
        _new( false, 'lang_cbo_sel',                    'Segoe UI Light',       20 * fs, 100, false, false )
        _new( false, 'lang_cbo_opt',                    'Segoe UI Light',       17 * fs, 100, false, false )

    /*
        fonts > reports
    */

        _new( false, 'report_exit',                     'Roboto',               24 * fs, 800, false, false )
        _new( false, 'report_resizer',                  'Roboto Light',         24 * fs, 100, false, false )
        _new( false, 'report_btn_clr',                  'Roboto',               15 * fs, 800, false, false )
        _new( false, 'report_btn_auth',                 'Roboto',               29 * fs, 800, false, false )
        _new( false, 'report_btn_send',                 'Roboto',               15 * fs, 800, false, false )
        _new( false, 'report_err',                      'Roboto',               14 * fs, 800, false, false )
        _new( false, 'report_icon',                     'Roboto Light',         24 * fs, 100, false, false )
        _new( false, 'report_title',                    'Roboto Light',         16 * fs, 600, false, false )
        _new( false, 'report_desc',                     'Roboto Light',         16 * fs, 400, false, false )
        _new( false, 'report_auth',                     'Roboto Light',         16 * fs, 400, false, false )
        _new( false, 'report_auth_icon',                'Roboto Light',         24 * fs, 100, false, false )

    /*
        fonts > mviewer
    */

        _new( false, 'mdlv_exit',                       'Roboto',               40 * fs, 800, false, false )
        _new( false, 'mdlv_resizer',                    'Roboto Light',         24 * fs, 100, false, false )
        _new( false, 'mdlv_icon',                       'Roboto Light',         24 * fs, 100, false, false )
        _new( false, 'mdlv_name',                       'Roboto Light',         44 * fs, 100, false, false )
        _new( false, 'mdlv_title',                      'Roboto Light',         16 * fs, 600, true, false )
        _new( false, 'mdlv_clear',                      'Roboto',               20 * fs, 800, false, false )
        _new( false, 'mdlv_enter',                      'Roboto',               20 * fs, 800, false, false )
        _new( false, 'mdlv_control',                    'Roboto Condensed',     16 * fs, 200, false, false )
        _new( false, 'mdlv_searchbox',                  'Roboto Light',         18 * fs, 100, false, false )
        _new( false, 'mdlv_minfo',                      'Roboto Light',         16 * fs, 400, false, false )
        _new( false, 'mdlv_copyclip',                   'Roboto Light',         14 * fs, 100, true, false )

    /*
        fonts > servinfo
    */

        _new( false, 'diag_icon',                       'Roboto Light',         24 * fs, 100, false, false )
        _new( false, 'diag_ctrl_exit',                  'Roboto',               40 * fs, 200, false, false )
        _new( false, 'diag_ctrl_min',                   'Roboto',               40 * fs, 200, false, false )
        _new( false, 'diag_title',                      'Segoe UI Light',       19 * fs, 200, false, false )
        _new( false, 'diag_value',                      'Segoe UI Light',       30 * fs, 600, false, false )
        _new( false, 'diag_hdr_value',                  'Segoe UI Light',       14 * fs, 400, false, false )
        _new( false, 'diag_chart_legend',               'Segoe UI Light',       14 * fs, 400, false, false )
        _new( false, 'diag_chart_value',                'Segoe UI Light',       23 * fs, 600, false, false )
        _new( false, 'diag_resizer',                    'Roboto Light',         24 * fs, 100, false, false )

    /*
        fonts > dc
    */

        _new( false, 'dc_exit',                         'Roboto',               24 * fs, 800, false, false )
        _new( false, 'dc_icon',                         'Roboto Light',         24 * fs, 100, false, false )
        _new( false, 'dc_name',                         'Roboto Light',         24 * fs, 100, false, false )
        _new( false, 'dc_title',                        'Roboto Light',         16 * fs, 600, false, false )
        _new( false, 'dc_msg',                          'Roboto Light',         16 * fs, 600, false, false )
        _new( false, 'dc_btn',                          'Roboto',               22 * fs, 200, false, false )

    /*
        fonts > welcome
    */

        _new( false, 'welcome_exit',                    'Roboto Light',         36 * fs, 800, false, false )
        _new( false, 'welcome_icon',                    'Roboto Light',         24 * fs, 100, false, false )
        _new( false, 'welcome_title',                   'Roboto Light',         16 * fs, 600, false, false )
        _new( false, 'welcome_name',                    'Segoe UI Light',       40 * fs, 100, false, false )
        _new( false, 'welcome_intro',                   'Open Sans Light',      20 * fs, 100, false, false )
        _new( false, 'welcome_ticker',                  'Open Sans',            14 * fs, 100, false, false )
        _new( false, 'welcome_btn',                     'Roboto Light',         16 * fs, 400, false, false )
        _new( false, 'welcome_data',                    'Roboto Light',         12 * fs, 200, false, false )
        _new( false, 'welcome_fx',                      'Roboto Light',         150 * fs, 100, false, false )

    /*
        fonts > elements
    */

        _new( false, 'elm_hdr_exit',                    'Roboto',               37 * fs, 800 )
        _new( false, 'elm_hdr_title',                   'Segoe UI Light',       18 * fs, 500 )
        _new( false, 'elm_hdr_icon',                    'Roboto Light',         24 * fs, 100 )
        _new( false, 'elm_diag_ftr_icon',               'Roboto Light',         31 * fs, 100 )
        _new( false, 'elm_resizer',                     'Roboto Light',         24, 100 )
        _new( false, 'elm_btn_x',                       'Roboto',               38 * fs, 800 )
        _new( false, 'elm_btn_ok',                      'Roboto',               16 * fs, 100 )
        _new( false, 'elm_txt_dt_1',                    'Segoe UI Light',       18 * fs, 100 )
        _new( false, 'elm_txt_dt_2',                    'Segoe UI Light',       27 * fs, 100 )
        _new( false, 'elm_txt_ftr',                     'Segoe UI Light',       20 * fs, 100 )
        _new( false, 'elm_ico_1',                       'GSym Solid',           14, 800, false, true )

    /*
        concommand > reload
    */

        if helper.ok.ply( pl ) or access:bIsConsole( pl ) then
            base:log( 4, '[ %s ] reloaded fonts', base.manifest.name )
            if not access:bIsConsole( pl ) then
                base.msg:target( pl, base.manifest.name, 'reloaded fonts' )
            end
        end

end
hook.Add( 'rlib.fonts.register', '_lib_fonts_register', fonts_register )
concommand.Add( 'rlib.fonts.reload', fonts_register )

/*
    resolution change

    called when a player changes their monitor resolution

    @param  : int old_w
    @param  : int old_h
*/

local function onResolutionChange( old_w, old_h )
    hook.Run( 'rlib.fonts.register' )
end
hook.Add( 'OnScreenSizeChanged', '_lib_onResolutionChange', onResolutionChange )