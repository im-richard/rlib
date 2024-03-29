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

/*
    library > localize
*/

local cfg                   = base.settings
local mf                    = base.manifest
local prefix                = mf.prefix
local script                = mf.name

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

/*
    languages
*/

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
*   helper :: internals :: pco cvars
*
*   command variables to be adjusted when pco is toggled
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
*   helper :: internals :: pco :: hooks
*
*   list of hooks to manage when pco toggled
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
*   helper :: predefined materials
*
*   list of internal gmod mat paths
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
*   helper :: predefined corners
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
*	helper :: bokeh material list
*
*	list of available bokeh effects
*/

    helper._bokehfx =
    {
        [ 'circles' ]	    = 'rlib/general/fx/bokeh/fx-bokeh-circles.png',
        [ 'gradients' ]	    = 'rlib/general/fx/bokeh/fx-bokeh-gradients.png',
        [ 'outlines' ]	    = 'rlib/general/fx/bokeh/fx-bokeh-outlines.png',
    }

/*
*   str_wrap
*
*   takes characters in a string and determines where they need to be 'word-wrapped' based on the length
*   provided in the parameters.
*
*   @param  : str phrase
*   @param  : int len
*   @return : tbl
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
*   str_crop
*
*   originally developed by FPtje in DarkRP and as time went on I made my own interpretation,
*   so credit goes to him.
*
*   @usage  : helper.str:crop( 'your test text', 200, 'Trebuchet18' )
*
*   @param  : str phrase
*   @param  : int len
*   @param  : str font
*   @return : str
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
*   failsafe check
*
*   checks to see if any theme properties are missing
*
*   @param  : tbl tbl
*   @param  : str val
*   @return : bool
*/

function helper:fscheck( tbl, val )
    for k, v in pairs( tbl ) do
        if ( istable( v ) ) and ( v.id == val ) then return true end
    end
    return false
end

/*
*   access :: initialize
*
*   on server start, load all permissions provided through a table.
*
*   if no table specified; will load base script permissions which are in rlib.permissions table
*
*   function is called both server and clientside due to different admin mods registering permissions
*   differently; as well as other functionality.
*
*   @call   : access:initialize( base.modules.permissions )
*   @param  : tbl perms
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
            *   permissions :: serverguard
            */

            id          = ( isstring( v.svg_id ) and v.svg_id ) or v.id or k
            serverguard.permission:Add( id )
            sw          = ln( 'perms_type_sg' )

        elseif SAM_LOADED and sam then

            /*
            *   permissions > sam
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
*   netlib :: debug :: ui
*
*   prompts an in-game notification for issues
*
*   @assoc  : konsole:send( )
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
*   netlib :: user management update
*
*   only update the table when it has been modified
*/

local function netlib_user( )
    if not helper.ok.ply( LocalPlayer( ) ) then return end
    local tbl_access    = net.ReadTable( )
    access.admins       = istable( tbl_access ) and tbl_access or { }
end
net.Receive( 'rlib.user', netlib_user )

/*
*   netlib :: user :: update
*
*   only update the table when it has been modified
*
*   @note   : 3 second delay from server
*/

local function netlib_user_update( )
    if not helper.ok.ply( LocalPlayer( ) ) then return end
    local pl = LocalPlayer( )

    cvar:Prepare( )

    /*
    *   create ply var table
    */

    pl.rlib         = pl.rlib or { }
end
net.Receive( 'rlib.user.update', netlib_user_update )

/*
*   rlib :: initialize
*
*   executes numerous processes including the updater, rdo, hooks, and workshop registration
*
*   @parent : hook, Initialize
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
*   rlib :: initialize :: post
*
*   called within gmod hook InitPostEntity which is after all steps related to rlib and rcore should be
*   loaded.
*
*   registration hooks include
*       : commands      rlib.cmd.register
*       : packages      rlib.pkg.register
*       : net           rlib.net.register
*       : fonts         rlib.fonts.register
*
*   commonly used for actions such as registering permissions, concommands, etc.
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
*	rlib :: think :: resolution
*
*	monitor resolution changes
*
*	@todo   : deprecate
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
*   cvars :: onchangecb
*
*   executed when a cvar has been modified
*   may not include all cvars; only important ones that require monitoring
*
*   @param  : str name
*   @param  : str old
*   @param  : str new
*/

local function cvar_cb_lang( name, old, new )
    local lang = cfg.langlst[ new ] or new
    design:nms( ln( 'lang_title' ), ln( 'lang_msg_change', lang ) )
end
cvars.AddChangeCallback( 'rlib_language', cvar_cb_lang )