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
    rlib
*/

local base                  = rlib
local helper                = base.h
local access                = base.a
local storage               = base.s

/*
    rcore
*/

local mf                    = rcore.manifest
local pf                    = mf.prefix
local cfg                   = rcore.settings
local sys                   = rcore.sys

/*
    Localized lua funcs
*/

local sf                    = string.format

/*
    Localized translation func
*/

local function lang( ... )
    return base:lang( ... )
end

/*
 	prefix ids
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( rcore and pf ) or false
    return base.get:pref( str, state )
end

/*
    module loader statistics
*/

local function modules_cstats( )
    base.l                      = { }
    sys.loadtime                = os.clock( )
    sys.modules.total           = 0
    sys.modules.registered      = 0
    sys.modules.err             = 0
    sys.modules.disabled        = 0
end

/*
    bHasModule

    check if the specified module is valid or not

    @param  : tbl, str mod
    @return : bool
*/

function rcore:bHasModule( mod )
    if not mod then return false end
    if isstring( mod ) and self.modules[ mod ] and self.modules[ mod ].enabled then
        return true
    elseif istable( mod ) and mod.enabled then
        return true
    end
    return false
end

/*
    bHasModule > throw error
*/

function rcore:bHasModule_throwError( mod, ply )
    if not mod then return false end
    if self:bHasModule( mod ) then
        return true
    else
        local mod_name = isstring( mod ) and mod or 'Unspecified'
        base:log( 2, 'you don\'t have access to this.' )
        base.msg:route( ply, false, base.manifest.name, 'WARNING:', base.settings.cmsg.clrs.target, mod_name:upper( ), base.settings.cmsg.clrs.msg, 'module has encountered an issue. Contact a server admin' )
        return false
    end
end

/*
    modules > autoloader > configs
*/

function rcore:autoloader_configs( loc, mod_id )

    /*
        modules > autoloader > configs > load_cfg
    */

    local function load_cfg( path, File, mod )
        local cfg_file = path .. '/' .. File
        if SERVER then
            if File:match( 'sh_' ) then
                AddCSLuaFile( cfg_file )
                include( cfg_file )
            elseif File:match( 'sv_' ) then
                include( cfg_file )
            elseif File:match( 'cl_' ) then
                AddCSLuaFile( cfg_file )
            end
            base:log( 1, '+ cfg [ %s ] %s', mod_id, File )
        elseif CLIENT then
            if File:match( 'sh_' ) then
                include( cfg_file )
            elseif File:match( 'cl_' ) then
                include( cfg_file )
            end
            base:log( 1, '+ cfg [ %s ] %s', mod_id, File )
        end
    end

    local files, _ = file.Find( loc .. '/' .. '*', 'LUA' )
    for _, File in ipairs( files ) do
        if not ( File:match( '.lua' ) ) then continue end
        if not File:match( 'config' ) and not File:match( 'cfg' ) and not File:match( 'settings' ) then continue end

        load_cfg( loc, File, mod_id )
    end

    for k, v in ipairs( _ ) do
        if v ~= 'cfg' and v ~= 'config' then continue end
        local path          = loc .. '/' .. v
        local sub, dir      = file.Find( path .. '/' .. '*', 'LUA' )

        /*
            load_cfg( path, File, mod_id )

            >   path                modules/xtask/cfg
            >   File                sh_cfg_ticker.lua
            >   mod_id              xtask
        */

        for _, File in ipairs( sub ) do
            if not ( File:match( '.lua' ) ) then continue end
            load_cfg( path, File, mod_id )
        end

        for _, Fol in ipairs( dir ) do
            local cfg_fol_path      = string.format( '%s/%s', path, Fol )
            local SubDir, SubFile   = file.Find( cfg_fol_path .. '/' .. '*', 'LUA' )

            /*
                load_cfg( cfg_fol_path, FileSub, mod_id )

                >   cfg_fol_path    modules/pirithous/cfg/layouts
                >   FileSub         cl_cfg_azerty.lua
                >   mod_id          pirithous
            */

            for _, FileSub in ipairs( SubDir ) do
                if not ( FileSub:match( '.lua' ) ) then continue end
                load_cfg( cfg_fol_path, FileSub, mod_id )
            end
        end
    end
end

/*
    modules > autoloader > assoc files
*/

function rcore:modules_attachfile( loc, b_isext )

    /*
        define rcore path
    */

    local path_base = b_isext and loc or mf.modpath

    /*
        module autoloader > SERVER
    */

    if SERVER then

        local files, dirs = file.Find( path_base .. '/*', 'LUA' )

        /*
            module autoloader > serverside -> shared
        */

        local function inc_sv( path_root, id, term )
            local scope = { [ 1 ] = 'sv', [ 2 ] = 'sh', [ 3 ] = 'cl' }

            for _, File in SortedPairs( file.Find( path_root .. '/' .. term .. '_*.lua', 'LUA' ), true ) do
                if id == 1 or id == 2 then include( path_root .. '/' .. File ) end
                if id == 2 or id == 3 then AddCSLuaFile( path_root .. '/' .. File ) end

                base:log( RLIB_LOG_DEBUG, '+ file [ %s ] %s » %s', loc, scope[ id ], File )
            end

            local file_sub, dir_sub = file.Find( path_root .. '/' .. '*', 'LUA' )
            for l, m in pairs( dir_sub ) do
                for _, FileSub in SortedPairs( file.Find( path_root .. '/' .. m .. '/' .. term .. '_*.lua', 'LUA' ), true ) do
                    if id == 1 or id == 2 then include( path_root .. '/' .. m .. '/' .. FileSub ) end
                    if id == 2 or id == 3 then AddCSLuaFile( path_root .. '/' .. m .. '/' .. FileSub ) end

                    base:log( RLIB_LOG_DEBUG, '+ file [ %s ] %s » %s', loc, scope[ id ], FileSub )
                end

                if id == 2 then
                    if ( m == 'lang' or m == 'languages' or m == 'translations' ) then
                        for _, SubFile in SortedPairs( file.Find( path_root .. '/' .. m .. '/*.lua', 'LUA' ), true ) do
                            local path_inc  = path_root .. '/' .. m .. '/' .. SubFile
                            AddCSLuaFile    ( path_inc )
                            include         ( path_inc )

                            base:log( RLIB_LOG_DEBUG, '+ lang [ %s ] %s', loc, SubFile )
                        end
                    end
                end
            end
        end

        /*
            module autoloader > serverside -> load
        */

        for _, dir in SortedPairs( dirs, true ) do
            if dir == '.' or dir == '..' then continue end
            if dir ~= loc then continue end

            local path_mod = sf( '%s/%s', path_base, dir )

            inc_sv( path_mod, 1, 'sv'  )
            inc_sv( path_mod, 2, 'sh'  )
            inc_sv( path_mod, 3, 'cl'  )
            inc_sv( path_mod, 3, 'i'   )
        end

    end

    /*
        module autoloader > CLIENT
    */

    if CLIENT then

        local files, dirs = file.Find( path_base .. '/*', 'LUA' )

        /*
            module autoloader > clintside -> shared
        */

        local function inc_cl( path_root, id, term )
            local scope = { [ 2 ] = 'sh', [ 3 ] = 'cl' }

            for _, File in SortedPairs( file.Find( path_root .. '/' .. term .. '_*.lua', 'LUA' ), true ) do
                include( path_root .. '/' .. File )

                base:log( RLIB_LOG_DEBUG, '+ file [ %s ] %s » %s', loc, scope[ id ], File )
            end
            local file_sub, dir_sub = file.Find( path_root .. '/' .. '*', 'LUA' )
            for l, m in pairs( dir_sub ) do
                for _, FileSub in SortedPairs( file.Find( path_root .. '/' .. m .. '/' .. term .. '_*.lua', 'LUA' ), true ) do
                    include( path_root  .. '/' .. m .. '/' .. FileSub )

                    base:log( RLIB_LOG_DEBUG, '+ file [ %s ] %s » %s', loc, scope[ id ], FileSub )
                end
                if id == 2 then
                    if ( m == 'lang' or m == 'languages' or m == 'translations' ) then
                        for _, SubFile in SortedPairs( file.Find( path_root .. '/' .. m .. '/*.lua', 'LUA' ), true ) do
                            local path_inc = path_root .. '/' .. m .. '/' .. SubFile
                            include( path_inc )

                            base:log( RLIB_LOG_DEBUG, '+ lang [ %s ] %s', loc, SubFile )
                        end
                    end
                end
            end
        end

        /*
            module autoloader > clintside -> load
        */

        for _, dir in SortedPairs( dirs, true ) do
            if dir ~= loc then continue end
            if dir == '.' or dir == '..' then continue end

            local path_mod = sf( '%s/%s', path_base, dir )

            inc_cl( path_mod, 2, 'sh'  )
            inc_cl( path_mod, 3, 'cl'  )
            inc_cl( path_mod, 3, 'i'   )
        end

    end

end

/*
    modules > autoloader
*/

function rcore:autoloader_modules( loc, mod_id, b_isext )
    local _, folder = helper.str:splitpath( loc )
    self:modules_attachfile( folder, b_isext )
    base:log( RLIB_LOG_SYSTEM, '+ module » [ %s ]', mod_id )
end

/*
    modules > autoloader > manifest
*/

local function autoloader_manifest_modules( )

    modules_cstats( )
    rcore.sys.loadpriority = cfg.loadpriority or { }

    local folder    = mf.modpath
    local _, dirs   = file.Find( folder .. '*', 'LUA' )

    /*
         prioritized loading for certain modules ( ie: rcore )
        usually configured in `lua\rlib\sh_config.lua`
    */

    for k, v in pairs( rcore.sys.loadpriority ) do
        local module_dir = sf( '%s/%s', folder, k )
        for _, sub in SortedPairs( file.Find( module_dir .. '/*.lua', 'LUA' ), true ) do
            if not sub:match( 'manifest' ) and not sub:match( 'env' ) and not sub:match( 'pkg' ) then continue end
            if sub:match( 'demo' ) then continue end

            local inc = sf( '%s/%s', module_dir, sub )
            if not inc then continue end

            if SERVER then AddCSLuaFile( inc ) end

            include( inc )
            rcore:Register( module_dir, sub )
        end
    end

    /*
        load the remainder of the modules not included in the module prioritizer.
    */

    local _, sub_dir = file.Find( folder .. '/' .. '*', 'LUA' )
    for l, m in pairs( sub_dir ) do
        if rcore.sys.loadpriority[ m ] then continue end
        local path_manifest = sf( '%s/%s', folder, m )
        for _, sub in SortedPairs( file.Find( path_manifest .. '/*.lua', 'LUA' ), true ) do
            if not sub:match( 'manifest' ) and not sub:match( 'env' ) and not sub:match( 'pkg' ) then continue end

            local inc = sf( '%s/%s', path_manifest, sub )
            if not inc then continue end

            if SERVER then AddCSLuaFile( inc ) end

            include( inc )
            rcore:Register( path_manifest, sub )
        end
    end

    /*
        garbage cleanup
    */

    storage.garbage( 'autoloader_manifest_modules', { rcore.sys.loadpriority, sys.loadtime } )

end

/*
    modules > prefix
*/

function rcore:modules_prefix( mod, suffix )
    if not istable( mod ) then
        base:log( RLIB_LOG_DEBUG, 'warning: cannot create prefix with missing module in \n[ %s ]', debug.traceback( ) )
        return
    end

    suffix = suffix or ''

    return suffix .. mod.id .. '.'
end

/*
    modules > settings
*/

function rcore:modules_settings( mod )
    local bLoaded = false
    if mod then
        if isstring( mod ) then
            if self.modules[ mod ] and self.modules[ mod ].enabled and self.modules[ mod ].settings then
                bLoaded = true
                return self.modules[ mod ].settings
            end
        elseif istable( mod ) then
            if mod.enabled and mod.settings then
                bLoaded = true
                return mod.settings
            end
        end
    end

    if not bLoaded then
        local mod_output = isstring( mod ) and mod or 'unspecified'
        base:log( RLIB_LOG_DEBUG, 'missing module settings [ %s ]\n%s', mod_output, debug.traceback( ) )
        return false
    end
end

/*
    load module
*/

function rcore:modules_load( mod, bPrefix )
    local bLoaded = false
    if mod and self.modules[ mod ] and self.modules[ mod ].enabled then
        if bPrefix then
            return self.modules[ mod ], self:modules_prefix( self.modules[ mod ] )
        else
            return self.modules[ mod ]
        end
        bLoaded = true
    end

    if not bLoaded then
        mod = mod or 'unknown'
        base:log( RLIB_LOG_DEBUG, 'missing module [ %s ]\n%s', mod, debug.traceback( ) )
        return false
    end
end

/*
    modules > in demo mode
*/

function rcore:bInDemoMode( mod )
    if not mod then return false end
    if isstring( mod ) and self.modules[ mod ] and ( self.modules[ mod ].demomode or self.modules[ mod ].demo ) then
        return true
    elseif istable( mod ) and ( mod.demomode or mod.demo ) then
        return true
    end
    return false
end

/*
    modules > logging
*/

function rcore:log( mod, cat, msg, ... )
    if not mod then
        rcore:log( 2, 'unable to log unspecified module' )
        return false
    end

    local mod_data          = { }
    local bLoaded           = false
    local bPostnow          = true
    local args              = { ... }
    local result, msg       = pcall( sf, msg, unpack( args ) )

    if isstring( mod ) then

        if self.modules[ mod ] and self.modules[ mod ].enabled then

            /*
                valid module > string
            */

            bLoaded         = true
            mod_data        = self.modules[ mod ]
        else

            /*
                custom folder > string
            */

            bLoaded         = true
            mod_data        = { id = mod, logging = true }
        end
    elseif istable( mod ) then
        if mod.enabled then
            bLoaded         = true
            mod_data        = mod
        end
    end

    if not bLoaded then
        local mod_output = isstring( mod ) and mod or 'unspecified'
        base:log( 2, 'missing module [ %s ] :: cannot write log\n%s', mod_output, debug.traceback( ) )
        return false
    end

    if not mod_data.logging then return end
    if not cat then cat = 1 end

    local c_type        = isnumber( cat ) and '[' .. helper.str:ucfirst( base._def.debug_titles[ cat ] ) .. ']' or isstring( cat ) and '[' .. cat .. ']' or cat
    local m_pf          = os.date( '%m%d%Y' )
    local m_id          = sf( 'RL_%s.txt', m_pf )

    local when          = '[' .. os.date( '%I:%M:%S' ) .. ']'
    local resp          = sf( '%s %s %s', when, c_type, msg )

    local _stdir        = storage.mft:getpath( 'dir_modules' )
    local i_boot        = base.sys.startups or 0

    if i_boot == 0 or i_boot == '0' then
        i_boot = '#boot'
    end

    local lpath     = sf( '%s/%s/logs/%s', _stdir, mod_data.id, i_boot )

    storage.file.append( lpath, m_id, resp )
end

/*
    modules > storage
*/

function rcore:modules_storage( source )

    if source and not istable( source ) then
        base:log( 2, 'cannot manage storage for modules, bad table\n%s', debug.traceback( ) )
        return
    end

    source = source or rcore.modules

    /*
        modules > storage > create data dir
    */

    local function cdatafolder( data, mod_id )
        if not istable( data ) then
            base:log( 2, '[ %s ] bad data table provided for [ %s ]', 'modules_storage' )
            return
        end

        mod_id = mod_id or pf

        if not data[ 'parent' ] or not data[ 'sub' ] then
            base:log( 2, '[ %s ] failed to specify new datafolder in manifest', mod_id )
            return
        end

        local fol_parent    = tostring( data[ 'parent' ] )
        local fol_sub       = tostring( data[ 'sub' ] )

        if not file.Exists( fol_parent, 'DATA' ) then
            file.CreateDir( fol_parent )
            base:log( RLIB_LOG_DEBUG, '[ %s ] created datafolder parent [ %s ]', mod_id, fol_parent )
        end

        if not file.Exists( fol_parent .. '/' .. fol_sub, 'DATA' ) then
            file.CreateDir( fol_parent .. '/' .. fol_sub )
            base:log( RLIB_LOG_DEBUG, '[ %s ] created datafolder sub [ %s ]', mod_id, fol_sub )
        end
    end

    for v in helper.get.data( source ) do
        if v.enabled and v.datafolder and istable( v.datafolder ) then
            for d in helper.get.data( v.datafolder ) do
                cdatafolder( d, v.id )
            end
        end
    end

end
rhook.new.gmod( 'PostGamemodeLoaded', 'rcore_modules_storage', function( source ) rcore:modules_storage( source ) end )

/*
    modules > precache
*/

function rcore:Precache( source )
    if source and not istable( source ) then
        base:log( 2, 'cannot find entities for modules, bad table\n%s', debug.traceback( ) )
        return
    end

    source = source or rcore.modules

    /*
        precache various items such as sounds, models, particles
    */

    for v in helper.get.data( source ) do
        if not v.ents and not istable( v.ents ) then continue end

        for m in helper.get.data( v.ents ) do

            if isfunction( m ) then continue end

            /*
                models > string
            */

            if isstring( m.model ) or isstring( m.mdl ) then
                local src_mdl = isstring( m.model ) and m.model or isstring( m.mdl ) and m.mdl
                base.register:model( src_mdl, true )
            end

            /*
                models > table
            */

            if istable( m.model ) or istable( m.mdl ) then
                local src_mdl = istable( m.model ) and m.model or istable( m.mdl ) and m.mdl
                for s in helper.get.data( src_mdl ) do
                    base.register:model( s, true )
                end
            end

            /*
                sounds > string
            */

            if isstring( m.sound ) or isstring( m.snd ) then
                local src_snd = isstring( m.sound ) and m.sound or isstring( m.snd ) and m.snd
                base.register:sound( src_snd )
            end

            /*
                sounds > table
            */

            if istable( m.sound ) or istable( m.snd ) then
                local src_snd = istable( m.sound ) and m.sound or istable( m.snd ) and m.snd
                for s in helper.get.data( src_snd ) do
                    base.register:sound( s )
                end
            end

            /*
                particles > string
            */

            if isstring( m.particles ) or isstring( m.ptc ) then
                local src_ptc = isstring( m.particles ) and m.particles or isstring( m.ptc ) and m.ptc
                base.register:particle( src_ptc )
            end

            /*
                particles > table
            */

            if istable( m.particles ) or istable( m.ptc ) then
                local src_ptc = istable( m.particles ) and m.particles or istable( m.ptc ) and m.ptc
                for s in helper.get.data( src_ptc ) do
                    base.register:particle( s )
                end
            end

            /*
                particles > precache > table
            */

            if istable( m.particles_pc ) or istable( m.ptc_pc ) then
                local src_ptc = istable( m.particles_pc ) and m.particles_pc or istable( m.ptc_pc ) and m.ptc_pc
                for s in helper.get.data( src_ptc ) do
                    base.register:particle( s )
                end
            end

        end
    end
end
rhook.new.gmod( 'PostGamemodeLoaded', 'rcore_modules_precache', function( source ) rcore:Precache( source ) end )

/*
    modules > dependency check
*/

local function module_dependencies( source )
    source = source or rcore.modules

    if not source or ( source and not istable( source ) ) then
        base:log( 2, 'cannot check dependency for modules, bad table\n%s', debug.traceback( ) )
        return
    end

    for v in helper.get.data( source ) do
        if not v.id or not v.enabled then continue end

        if v.dependencies and istable( v.dependencies ) then
            for m in helper.get.data( v.dependencies ) do
                local name = isstring( m.name ) and m.name or 'unspecified dependency name'
                if not m.check then
                    base:log( 2, '[ %s ] failed dependency check missing func [ %s ]', v.id, name )
                    continue
                end
                local has_depen = m.check( )
                if has_depen then
                    base:log( RLIB_LOG_DEBUG, '[ %s ] found dependency [ %s ]', v.id, name )
                else
                    base:log( 2, '[ %s ] failed or missing dependency [ %s ]', v.id, name )
                end
            end
        end
    end
end
rhook.new.gmod( 'PostGamemodeLoaded', 'rcore_modules_dependencies', module_dependencies )

/*
    module > register > content
*/

local function module_register_content( source )

    if source and not istable( source ) then
        base:log( 2, 'cannot register workshops for modules, bad table\n%s', debug.traceback( ) )
        return
    end

    source = source or rcore.modules

    for v in helper.get.data( source ) do

        if not v.id or not v.enabled then continue end

        /*
            workshop resources
        */

        local ws_val = v.ws_lst or v.workshops or v.workshop
        if ( v.bWorkshop or v.ws_enabled ) and ws_val then
            local src   = istable( v.ws_lst ) and v.ws_lst or istable( v.workshops ) and v.workshops or istable( v.workshop ) and v.workshop
                        if not istable( src ) then
                            src             = { }
                            local ws_chk    = v.ws_lst or v.workshops or v.workshop
                                            if helper.str:isempty( ws_chk ) then continue end

                            table.insert( src, ws_chk )
                        end

            for m in helper.get.data( src ) do
                if SERVER then
                    resource.AddWorkshop( m )
                    base:log( RLIB_LOG_WS, '+ %s » [ %s ]', tostring( v.id ), m )
                elseif CLIENT then
                    steamworks.FileInfo( m, function( res )
                        if res and res.id then
                            steamworks.DownloadUGC( tostring( res.id ), function( name, f )
                                game.MountGMA( name or '' )
                                local size = res.size / 1024
                                base:log( RLIB_LOG_WS, '+ %s [ %s ] » %i KB', tostring( v.id ), res.title, math.Round( size ) )
                            end )
                        end
                    end )
                end

                base.w[ m ]         = { }
                base.w[ m ].id      = m
                base.w[ m ].src     = v.id or 'unknown'
            end
        end

        /*
            fastdl resources
        */

        if v.fastdl or v.fastdl_enabled then

            /*
                sounds
            */

            local r_path = mf.modpath
            local d_path = r_path .. '/' .. v.id .. '/' .. 'resource'
            if file.IsDir( d_path, 'LUA' ) then
                storage.data.recurv( v.id, d_path )
            else
                local lst_folders = { 'materials', 'sound', 'resource' }
                for l, m in pairs( lst_folders ) do
                    local module_folder     = v.fastdl_folder or v.id
                    local folder            = m .. '/' .. module_folder
                    storage.data.recurv( v.id, folder, 'GAME' )

                    base:log( RLIB_LOG_FASTDL, '+ %s » [ %s ]', v.id, folder )
                end
            end

            /*
                ( fonts ) > regular
            */

            if istable( v.fonts ) then
                local fonts = v.fonts
                if #fonts > 0 then
                    for _, f in pairs( fonts ) do
                        local src = string.format( 'resource/fonts/%s.ttf', f )
                        resource.AddSingleFile( src )
                        base:log( RLIB_LOG_FONT, '+ %s » [ %s ]', v.id, src )
                    end
                end
            end

            /*
                ( fonts ) > push internals
            */

            if v.fonts_push then
                local fonts = file.Find( 'resource/fonts/*', 'GAME' )
                if #fonts > 0 then
                    for _, f in pairs( fonts ) do
                        local src = string.format( 'resource/fonts/%s.ttf', f )
                        resource.AddSingleFile( src )
                        base:log( RLIB_LOG_FONT, '+ %s » [ %s ]', v.id, src )
                    end
                end
            end
        end

    end

end
rhook.new.rlib( 'rcore_modules_load_post', 'rcore_modules_res_register', module_register_content )

/*
    module > register > particles
*/

local function module_register_ptc( source )

    if source and not istable( source ) then
        base:log( 2, 'cannot register particles for modules, bad table\n%s', debug.traceback( ) )
        return
    end

    source = source or rcore.modules

    for v in helper.get.data( source ) do

        if not v.id or not v.enabled then continue end

        /*
            workshop resources
            determined through the module manifest file.
        */

        if v.particles then
            if istable( v.particles ) then
                for m in helper.get.data( v.particles ) do
                    base.register:particle( m )
                end
            elseif isstring( v.particles ) then
                base.register:particle( v.particles )
            end
        end
    end

end
rhook.new.rlib( 'rcore_modules_load_post', 'rcore_modules_ptc_register', module_register_ptc )

/*
    module > register > sounds
*/

local function module_register_snds( source )

    if source and not istable( source ) then
        base:log( 2, 'cannot register particles for modules, bad table\n%s', debug.traceback( ) )
        return
    end

    source = source or rcore.modules

    for v in helper.get.data( source ) do

        if not v.id or not v.enabled then continue end

        /*
            workshop resources
            determined through the module manifest file.
        */

        if v.sounds then
            if istable( v.sounds ) then
                for m in helper.get.data( v.sounds ) do
                    base.register:particle( m )
                end
            elseif isstring( v.sounds ) then
                base.register:particle( v.sounds )
            end
        end
    end

end
rhook.new.rlib( 'rcore_modules_load_post', 'rcore_modules_snd_register', module_register_snds )

/*
    library > mount content
*/

local function lib_mount_content( )

    /*
        fastdl
    */

    if SERVER then

        if rcore.settings.fastdl_enabled then

            /*
                fonts
            */

            if istable( mf.fonts ) then
                local fonts = mf.fonts
                if #fonts > 0 then
                    for _, f in pairs( fonts ) do
                        local src = string.format( 'resource/fonts/%s.ttf', f )
                        resource.AddSingleFile( src )
                        base:log( RLIB_LOG_FONT, '+ %s » [ %s ]', 'font', src )
                    end
                end
            end

            /*
                resources
            */

            local path_base = mf.folder or ''

            for v in base.h.get.data( mf.fastdl ) do
                local r_path = v .. '/' .. path_base
                if v == 'resource' then
                    r_path = v .. '/fonts'
                end

                local r_files, r_dirs = file.Find( r_path .. '/*', 'GAME' )

                for File in base.h.get.data( r_files, true ) do
                    local r_dir_inc = r_path .. '/' .. File
                    resource.AddFile( r_dir_inc )
                    base:log( RLIB_LOG_FASTDL, '+ %s', r_dir_inc )
                end

                for d in base.h.get.data( r_dirs ) do
                    local r_subpath = r_path .. '/' .. d
                    local r_subfiles, r_subdirs = file.Find( r_subpath .. '/*', 'GAME' )
                    for _, subfile in SortedPairs( r_subfiles ) do
                        local r_path_subinc = r_subpath .. '/' .. subfile
                        resource.AddFile( r_path_subinc )
                        base:log( RLIB_LOG_FASTDL, '+ %s', r_path_subinc )
                    end
                end
            end
        end

    end

    /*
        workshop
    */

    if cfg.ws_enabled and mf.workshops then
        for v in base.h.get.data( mf.workshops ) do
            if SERVER then
                resource.AddWorkshop( v )
                base:log( RLIB_LOG_WS, '+ %s » [ %s ]', tostring( base.manifest.name ), v )
            else
                if CLIENT then
                    steamworks.FileInfo( v, function( res )
                        if res and res.id then
                            local ws_id = tostring( res.id )
                            steamworks.DownloadUGC( tostring( ws_id ), function( name, f )
                                game.MountGMA( name or '' )
                                local size = res.size / 1024
                                base:log( RLIB_LOG_WS, '+ %s [ %s ] » %i KB', tostring( base.manifest.name ), res.title, math.Round( size ) )
                            end )
                        end
                    end )
                end
            end

            base.w[ v ]         = { }
            base.w[ v ].id      = v
            base.w[ v ].src     = mf.name or 'unknown'
        end
    else
        base:log( RLIB_LOG_WARN, mf.name .. ' workshop mounting disabled'  )
    end

end
rhook.new.rlib( 'rcore_onloaded', 'rcore_mount_lib', lib_mount_content )

/*
    modules > storage > register defaults
*/

local function storage_struct_defs( mod_id )

    if not mod_id then
        base:log( 2, 'cannot create def storage tables for module, bad mod id\n%s', debug.traceback( ) )
        return
    end

    local source = rcore.modules

    /*
        storage > sh > rcore
    */

    local storage_sh_b =
    {
        bInitialized        = false,
        initialize          = { },
        action              = { },
        usrdef              = { },
        cc                  = { },
        rcc                 = { },
        ent                 = { },
        binds               = { },
        dev                 = { },
        settings            = { },
        themes =
        {
            list            = { },
            hash            = nil,
        },
    }

    for k, v in pairs( storage_sh_b ) do
        source[ mod_id ][ k ] = source[ mod_id ][ k ] or v
    end

    /*
        storage > cl > rcore
    */

    if CLIENT then
        local storage_cl =
        {
            pnl                 = { },
            ui                  = { },
            ctm                 = { },
        }

        for k, v in pairs( storage_cl ) do
            source[ mod_id ][ k ] = source[ mod_id ][ k ] or v
        end
    end

    /*
        storage > sh > cfg
    */

    local storage_sh_c =
    {
        initialize          = { },
        general             =
        {
            clrs            = { },
        },
        binds =
        {
            chat            = { },      -- deprecate
            console         = { },      -- deprecate
            key             = { },      -- deprecate
            admin =
            {
                chat        = { },
                console     = { },
                key         = { },
            },
            user =
            {
                chat        = { },
                console     = { },
                key         = { },
            },
        },
        sounds              = { },
        ui =
        {
            clrs            = { },
        },
        bg =
        {
            live            = { },
            static          = { },
            material        = { },
            filter          = { },
            bokeh           = { },
        },
        nav                 =
        {
            btn             = { },
            button          = { },      -- to be deprecated
            general         = { },
            list            = { },
        },
        ent                 = { },
        dev                 = { },
    }

    for k, v in pairs( storage_sh_c ) do
        source[ mod_id ][ 'settings' ][ k ] = source[ mod_id ][ 'settings' ][ k ] or v
    end

end
rhook.new.rlib( 'rcore_modules_storage_struct', storage_struct_defs )

/*
    register module
*/

function rcore:Register( path, mod, b_isext )

    if not isstring( path ) or not mod then
        base:log( 2, lang( 'logs_rcore_mnfst_err' ) )
        sys.modules.err = sys.modules.err + 1
        return
    end

    /*
        define > module
    */

    local _ENV              = { }
    local manifest          = path .. '/' .. mod
    local plugins           = path .. '/' .. 'plugins' .. '/' .. mod
    local tmp_id            = mod:gsub( '.lua', '' )

                            if not tmp_id then
                                base:log( 2, lang( 'logs_rcore_id_err' ) )
                                sys.modules.err = sys.modules.err + 1
                                return
                            end

    _ENV.MODULE             = self.modules[ tmp_id ]
    smt                     = setmetatable( _ENV, { __index = _G } )

                            if not smt or ( type( smt ) ~= 'table' ) then
                                base:log( RLIB_LOG_DEBUG, lang( 'logs_rcore_mt_err' ) )
                                sys.modules.err = sys.modules.err + 1
                                return
                            else
                                if sys.modules.registered <= 0 then
                                    base:log( RLIB_LOG_DEBUG, lang( 'logs_rcore_mt_ok' ) )
                                end
                            end

    /*
        compile env / manifest

        var( manifest )     : modules/base/sh_env.lua
    */

    local module_exec       = CompileFile( manifest )
    sys.modules.total       = sys.modules.total + 1

                            if not module_exec or not base:isfunc( module_exec ) then
                                sys.modules.err = sys.modules.err + 1
                                base:log( 2, lang( 'logs_rcore_func_err', mod ) )
                                return
                            end

    /*
        module not enabled
    */

    if not smt.MODULE.enabled then
        base:log( RLIB_LOG_DEBUG, lang( 'logs_rcore_mod_disabled', smt.MODULE.id ) )
        sys.modules.disabled = sys.modules.disabled + 1
        return
    end

    /*
        set environment > MODULE
    */

    debug.setfenv( module_exec, _ENV )
    module_exec( )

    /*
        plugins
    */

    if file.Exists( plugins, 'LUA' ) then
        local plugins_exec  = CompileFile( plugins )
                              debug.setfenv( plugins_exec, _ENV )
                              plugins_exec( )

        table.Merge( smt.MODULE, smt.PLUGIN )
    end

    /*
        set module values

        mod.modules[ 'module_id' ]
        mod.modules[ 'lunera' ]
    */

    local mod_id                                = smt.MODULE.id
    self.modules[ mod_id ]                      = _ENV.MODULE
    self.modules[ mod_id ].__                   = { }
    self.modules[ mod_id ].id                   = mod_id
    self.modules[ mod_id ].loadtime             = CurTime( )
    self.modules[ mod_id ].path                 = path
    self.modules[ mod_id ].settings             = { }

    self.modules[ mod_id ]._plugins             = { }
    self.modules[ mod_id ]._plugins.language    = { }
    self.modules[ mod_id ]._cache               = { }
    self.modules[ mod_id ]._cache.mats          = { }

    --base.l[ mod_id ]                    = smt.MODULE.language

    sys.modules.registered = sys.modules.registered + 1
    base:log( RLIB_LOG_DEBUG, lang( 'logs_rcore_mnfst_ok', mod ) )

    /*
        require
    */

    if istable( smt.MODULE.req ) then
        for k, v in pairs( smt.MODULE.req ) do
            pcall( require, v )
            base:log( RLIB_LOG_SYSTEM, '+ library %s', v )
        end
    elseif isstring( smt.MODULE.req ) then
        pcall( require, smt.MODULE.req )
        base:log( RLIB_LOG_SYSTEM, '+ library %s', smt.MODULE.req )
    end

    /*
        create storage tables > shared
    */

    if smt.MODULE.storage and istable( smt.MODULE.storage ) then
        for k, v in pairs( smt.MODULE.storage ) do
            self.modules[ mod_id ][ k ] = v
            base:log( RLIB_LOG_DEBUG, lang( 'logs_rcore_storage_ok', smt.MODULE.id, tostring( k ) ) )
        end
        storage.garbage( 'module_loader_storage', { smt.MODULE.storage } )
    else
        smt.MODULE.storage = { }
    end

    /*
        create storage tables > client
    */

    if CLIENT and smt.MODULE.storage_cl and istable( smt.MODULE.storage_cl ) then
        for k, v in pairs( smt.MODULE.storage_cl ) do
            self.modules[ mod_id ][ k ] = v
            base:log( RLIB_LOG_DEBUG, lang( 'logs_rcore_storage_ok', smt.MODULE.id, tostring( k ) ) )
        end
    end

    /*
        create storage tables > server
    */

    if SERVER and istable( smt.MODULE.storage_sv ) then
        for k, v in pairs( smt.MODULE.storage_sv ) do
            self.modules[ mod_id ][ k ] = v
            base:log( RLIB_LOG_DEBUG, lang( 'logs_rcore_storage_ok', smt.MODULE.id, tostring( k ) ) )
        end
    end

    /*
        add single
    */

    if SERVER and istable( smt.MODULE.addsingle ) then
        for k, v in ipairs( smt.MODULE.addsingle ) do
            resource.AddSingleFile( v )
            base:log( RLIB_LOG_FASTDL, '+ file [ %s ]', v )
        end
    end

    /*
        addfile
    */

    if SERVER and istable( smt.MODULE.addfile ) then
        for k, v in ipairs( smt.MODULE.addfile ) do
            resource.AddFile( v )
            base:log( RLIB_LOG_FASTDL, '+ single [ %s ]', v )
        end
    end

    /*
        create default storage tables
        these tables will be automatically created for every module to help save
        on repetitiveness of declaring these in the module manifest file
    */

    rhook.run.rlib( 'rcore_modules_storage_struct', mod_id )

    /*
        module sys tbl
    */

    smt.MODULE.sys = smt.MODULE.sys or { }

    /*
        create log folders
    */

    if SERVER and smt.MODULE.logging then
        local path = string.format( '%s/%s', storage.mft:getpath( 'dir_modules' ), mod_id )
        storage.dir.create( path )
    end

    /*
        create datafolders
    */

    if SERVER and smt.MODULE.datafolder and istable( smt.MODULE.datafolder ) then
        for v in helper.get.data( smt.MODULE.datafolder ) do
            if not v.parent then continue end
            storage.dir.create( v.parent )

            if not v.sub then continue end
            local path = string.format( '%s/%s', v.parent, v.sub )
            storage.dir.create( path )
        end
    end

    /*
        register calls
    */

    if smt.MODULE.calls then
        base.calls:register( rcore, smt.MODULE.calls )
    end

    /*
        register resources
    */

    if smt.MODULE.resources then
        base.resources:register( rcore, mod_id, smt.MODULE.resources, smt.MODULE.precache or false )
    end

    /*
        sql tables
    */

    if SERVER and ( smt.MODULE.ext or smt.MODULE.dbconn ) then
        smt.MODULE.database         = { }
        smt.MODULE.database.cfg     = { }
    end

    /*
        load other files in module after good manifest found
    */

    self:autoloader_configs( path, mod_id )
    self:autoloader_modules( path, mod_id, b_isext )

    /*
        check demo mode
    */

    if smt.MODULE.demo or smt.MODULE.demomode then
        base:log( 3, lang( 'logs_rcore_demomode', smt.MODULE.id ) )
    end

    /*
        register > rnet
    */

    if rnet then
        timex.simple( 1, function( )
            local name = pid( 'rnet_register', mod_id )
            if not rhook.exists( name ) then
                base:log( RLIB_LOG_ERR, 'missing rnet hook for module [ %s ] [ %s ]', mod_id, name )
            end
            rhook.run.gmod( name )
        end )
    end

    /*
        register > materials ( v1 )

        will be deprecated in a future update
    */

    if CLIENT and smt.MODULE.materials then
        base.m:register_v1( smt.MODULE.materials, mod_id )
    end

    /*
        register > materials ( v2 )
    */

    if CLIENT and smt.MODULE.mats then
        base.m:register( smt.MODULE )
    end

    /*
        register > fonts
    */

    if CLIENT then
        local name = pid( 'fonts_register', mod_id )
        if not rhook.exists( name ) then
            base:log( RLIB_LOG_ERR, 'missing font registration hook for module [ %s ]', mod_id )
        end
        rhook.run.rlib( name )
    end

    /*
        cleanup temp global
    */

    _G[ mod_id ] = nil

end
rhook.new.rlib( 'rcore_modules_register', rcore.Register )

/*
    modules > initialize
*/

function rcore:modules_initialize( pl )
    if helper.ok.ply( pl ) or access:bIsConsole( pl ) then
        base:log( RLIB_LOG_SYSTEM, 'Reloading modules, please wait ...' )
    end

    rhook.run.rlib( 'rcore_modules_load_pre' )

    autoloader_manifest_modules( )

    base.calls:load     (   )

    base:log( RLIB_LOG_SYSTEM, lang( 'logs_modules_total',        sys.modules.total             ) )
    base:log( RLIB_LOG_SYSTEM, lang( 'logs_modules_active',       sys.modules.registered        ) )
    base:log( RLIB_LOG_SYSTEM, lang( 'logs_modules_err',          sys.modules.err               ) )
    base:log( RLIB_LOG_SYSTEM, lang( 'logs_modules_disabled',     sys.modules.disabled          ) )
    base:log( RLIB_LOG_SYSTEM, lang( 'logs_modules_loadtime',     timex.secs.ms( sys.loadtime ) ) )

    rhook.run.rlib( 'rcore_modules_load_post', rcore.modules )
    rhook.run.rlib( 'rcore_onloaded' )

end
rhook.new.rlib( 'rcore_loader_post', 'rcore_modules_initialize', rcore.modules_initialize )
rhook.new.gmod( 'OnReloaded', 'rcore_modules_onreload', rcore.modules_initialize )
rcc.new.rlib( 'rlib_modules_reload', rcore.modules_initialize )