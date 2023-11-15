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
local access                = base.a
local ui                    = base.i
local tools                 = base.t

/*
    library > localize
*/

local cfg                   = base.settings
local mf                    = base.manifest
local pf                    = mf.prefix

/*
    languages
*/

local function ln( ... )
    return base:lang( ... )
end

/*
    prefix > get id
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and pf ) or false
    return base.get:pref( str, state )
end

/*
*	tools > diag > run
*
*	diag interface
*/

function tools.diag:Run( )
    if not access:bIsDev( LocalPlayer( ) ) then return end
    if ui:ok( tools.diag.pnl ) then
        tools.diag.pnl:ActionToggle( )
        return
    end
    tools.diag.pnl = vgui.Create( 'rlib.lo.diag' )
end
rcc.new.gmod( pid( 'diag' ), tools.diag.Run )

/*
*	tools > lang > run
*
*	language selection interface
*/

function tools.lang:Run( )
    if ui:ok( tools.lang.pnl ) then
        ui:dispatch( tools.lang.pnl )
        return
    end

    tools.lang.pnl          = ui.new( 'rlib.lo.language'        )
    :title                  ( ln( 'lang_sel_title' )            )
    :actshow                (                                   )
end
rcc.new.gmod( pid( 'lang' ), tools.lang.Run )

/*
*	tools > mdlv > run
*
*	model viewer interface
*/

function tools.mdlv:Run( )
    if ui:visible( tools.mdlv.pnl ) then
        ui:dispatch( tools.mdlv.pnl )
    end

    tools.mdlv.pnl          = ui.new( 'rlib.lo.mdlv'        )
    :title                  ( ln( 'mdlv_title' )            )
    :actshow                (                               )
end
rcc.new.gmod( pid( 'mview' ), tools.mdlv.Run )

/*
*   tools > pco > run
*
*   optimization tool which helps adjust a few game vars in order to cut back and save frames.
*   should only be used if you actually know what changes this makes
*
*   @param  : bool bEnable
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
*	tools > welcome > run
*
*	welcome interface for ?setup
*/

function tools.welcome:Run( )
    if not access:bIsRoot( LocalPlayer( ) ) then return end

    /*
    *   destroy existing pnl
    */

    if ui:ok( tools.welcome.pnl ) then
        ui:dispatch( tools.welcome.pnl )
        return
    end

    /*
    *   about > network update check
    */

    net.Start               ( 'rlib.welcome'    )
    net.SendToServer        (                   )

    /*
    *   create / show parent pnl
    */

    tools.welcome.pnl       = ui.new( 'rlib.lo.welcome'         )
    :title                  ( ln( 'welcome_title' )             )
    :actshow                (                                   )
end
rcc.new.gmod( pid( 'welcome' ), tools.welcome.Run, nil, nil, FCVAR_PROTECTED )

/*
*   netlib > tools > lang
*
*   initializes lang selector ui
*/

local function netlib_lang( )
    tools.lang:Run( )
end
net.Receive( 'rlib.tools.lang', netlib_lang )

/*
*   netlib > tools > mviewer
*
*   net.Receive to open model viewer
*/

local function netlib_mdlv( )
    tools.mdlv:Run( )
end
net.Receive( 'rlib.tools.mdlv', netlib_mdlv )

/*
*   netlib > tools > pco
*
*   player-client-optimizations
*/

local function netlib_pco( )
    local b = net.ReadBool( )
    tools.pco:Run( b )
end
net.Receive( 'rlib.tools.pco', netlib_pco )

/*
*   netlib > tools > diag
*
*   initializes diag ui
*/

local function netlib_diag( )
    if not access:bIsRoot( LocalPlayer( ) ) then return end

    tools.diag:Run( )
end
net.Receive( 'rlib.tools.diag', netlib_diag )

/*
*	think > keybinds > diag
*
*	checks to see if the assigned keys are being pressed to activate the diag ui
*/

local i_th_diag = 0
local function th_binds_diag( )
    if not access:bIsRoot( LocalPlayer( ) ) then
        hook.Remove( 'Think', pid( 'keybinds.diag' ) )
        return
    end

    if gui.IsConsoleVisible( ) then return end

    local iKey1, iKey2      = cfg.diag.binds.key1, cfg.diag.binds.key2
    local b_Keybfocus       = vgui.GetKeyboardFocus( )

    if LocalPlayer( ):IsTyping( ) or b_Keybfocus then return end

    helper.get.keypress( iKey1, iKey2, function( )
        if i_th_diag > CurTime( ) then return end
        tools.diag:Run( )
        i_th_diag = CurTime( ) + 1
    end )
end
hook.Add( 'Think', pid( 'keybinds.diag' ), th_binds_diag )