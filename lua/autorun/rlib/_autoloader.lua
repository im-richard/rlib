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
    libraries
*/

rlib                        = rlib or { }
rlib.autoload               = rlib.autoload or { }
rlib.manifest               = rlib.manifest or { }

/*
    rlib > autoload > run

    execute loader for rlib
    typically called from rcore to start the loading process of rlib itself.

    @assoc  : _rcore_loader.lua
    @call   : rlib.autoload:Run( base )

    @param  : tbl parent
*/

function rlib.autoload:Run( parent )

    /*
        base definitions
    */

    local base                      = rlib
    local mf                        = base.manifest or { }
    mf.name                         = 'rlib'
    mf.author                       = 'Richard'
    mf.basecmd                      = 'rlib'
    mf.prefix                       = 'rlib.'
    mf.folder                       = 'autorun/rlib'
    mf.site                         = 'https://rlib.io/'
    mf.repo                         = 'https://github.com/im-richard/rlib/'
    mf.docs                         = 'https://docs.rlib.io/'
    mf.about                        = [[rlib is a glua library written for garrys mod which contains a variety of commonly used functions that are required for certain scripts to run properly. Package includes both rlib + rcore which act as the overall foundation which other scripts will rest within as a series of modules. ]]
    mf.released                     = 1700031495
    mf.version                      = { 3, 6, 2, 0 }
    mf.showcopyright                = false

    /*
        files
    */

    mf.files =
    {
        core =
        {
            { file = 'cfg',                     scope = 2 },
            { file = 'define',                  scope = 2 },
            { file = 'get',                     scope = 2 },
            { file = 'base',                    scope = 2 },
            { file = 'register',                scope = 2 },
            { file = 'permissions',             scope = 2 },
            { file = 'cvar/sh_cvar',            scope = 2 },
            { file = 'cvar/cl_cvar',            scope = 3 },
            { file = 'materials',               scope = 3 },
            { file = 'storage',                 scope = 2 },
            { file = 'modules',                 scope = 2 },
            { file = 'resources',               scope = 2 },
            { file = 'calls/sv_calls',          scope = 1 },
            { file = 'calls/sh_calls',          scope = 2 },
            { file = 'csv',                     scope = 1 },
            { file = 'csh',                     scope = 2 },
            { file = 'ccl',                     scope = 3 },
            { file = 'tools',                   scope = 3 },
            { file = 'commands',                scope = 1 },
            { file = 'rcc/sv_rcc_raw',          scope = 1 },
            { file = 'rcc/sv_rcc',              scope = 1 },
            { file = 'rcc/sh_rcc',              scope = 2 },
            { file = 'rcc/cl_rcc',              scope = 3 },
            { file = 'pmeta',                   scope = 2 },
            { file = 'emeta',                   scope = 2 },
            { file = 'uclass',                  scope = 3 },
            { file = 'global',                  scope = 2 },
            { file = 'fonts',                   scope = 3 },
            { file = 'design',                  scope = 3 },
        },
        post =
        {
            { file = 'rnet',                    scope = 2 },
        },
    }

    /*
        packages
    */

    mf.packages =
    {
        pre =
        {
            'rcc',
            'calc',
            'rhook',
            'timex',
            'rnet',
        },
        post =
        {
            'glon',
            'spew',
        },
    }

    /*
        license
    */

    mf.license =
    {
        type                        = 'MIT',
        text                        = [[THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.]],
        perms =
        {
            private                 = true,
            commercial              = false,
            resell                  = false,
        }
    }

    /*
        astra
    */

    mf.astra =
    {
        oort =
        {
            validated               = false,
            auth_id                 = 0,
            sess_id                 = 0,
            has_latest              = false,
            last_hb                 = 0,
            debug                   = false,
            url                     = 'https://oort.rlib.io',
        },
        udm =
        {
            branch                  = 'https://udm.rlib.io/rlib/%s',
            response                = { },
        },
        rpm =
        {
            uri                     = 'https://rpm.rlib.io/',
        },
        auth                        = 'https://auth.rlib.io/',
        svg                         =
        {
            stats                   = 'https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fim-richard%2Frlib&count_bg=%235A3DC8&title_bg=%23555555&icon=reasonstudios.svg',
            updated                 = 'https://img.shields.io/github/last-commit/im-richard/rlib.svg?label=updated',
            size                    = 'https://img.shields.io/github/repo-size/im-richard/rlib.svg?color=%23FF1B67&label=size&logo=lua',
        },
    }

    /*
        table of stored rlib paths related to be where certain data will be stored
    */

    mf.paths =
    {
        [ 'base' ]                  = 'rlib',
        [ 'bin' ]                   = 'rlib/bin',
        [ 'dir_mats' ]              = 'rlib/materials',
        [ 'dir_alogs' ]             = 'rlib/alogs',
        [ 'dir_debug' ]             = 'rlib/debug',
        [ 'dir_logs' ]              = 'rlib/logs',
        [ 'dir_modules' ]           = 'rlib/modules',
        [ 'dir_server' ]            = 'rlib/server',
        [ 'dir_uconn' ]             = 'rlib/uconn',
        [ 'dir_sys' ]               = 'rlib/sys',
        [ 'dir_obf' ]               = 'rlib/obf',
        [ 'data_checksum' ]         = 'rlib/checksum.txt',
        [ 'data_history' ]          = 'rlib/history.txt',
        [ 'data_manifest' ]         = 'rlib/manifest.txt',
        [ 'data_modules' ]          = 'rlib/modules.txt',
        [ 'data_users' ]            = 'rlib/users.txt',
    }

    /*
        this table lists developers who should have access to the debugging features. this doesnt give
        any special permissions that one person should not have, but is primarily used for advanced
        issues submitted via gms tickets and ensures that the built-in developer console doesnt pop up
        for people and annoy them

        if you happen to find this table, you may add your steam64 however keep in mind that you will
        see prints in-game which may get annoying real quick

        to remove these annoying msgs; open the developer console with keybind SHIFT + . (period)
        and in the chat-box like console, type 'exit' (without quotes). this will ensure that you
        will not see these msgs until your next connection to the server.

        @assoc  : access:bIsDev( )
                : access:bIsRoot( )
    */

    mf.developers =
    {
        '76561198321991757'
    }

    /*
        keep track of plugins controlled by rlib
    */

    base.plugins                        = base.plugins or { }
    base.parent, base.plugins[ parent ] = parent, parent

    /*
        these tables are associated to rlib and should be touched under any circumstance.
        if you decide to modify and/or remove these, issues will arise and I am not going to help you
        if that is the case.

        numerous aspects of this script rely on these tables.
    */

    base.settings = base.settings or { }

    /*
        table index

            base.a          : access
            base.c          : calls
            base.d          : design
            base f          : fonts
            base.h          : helpers
            base.i          : interface
            base.k          : konsole
            base.l          : languages
            base.m          : materials
            base.o          : owners
            base.p          : panels
            base.r          : resources             ( mdl, pnl, ptc, snd )
            base.s          : storage
            base.t          : tools
            base.v          : cvars
            base.w          : workshops

            base.calls      : registered calls
            base.checksum   : library checksum storage
            base.sys        : system
            base.package    : module packages
    */

        /*
            base > create
        */

        local ind_base = { 'a', 'c', 'd', 'f', 'i', 'k', 'l', 'm', 'o', 'p', 'r', 's', 't', 'v', 'w', 'calls', 'checksum', 'con', 'cvar', '_def', 'fonts', 'modules', 'msg', 'sys', 'register', 'resources', 'package', 'alias', 'get', 'oort', 'udm' }
        for k, v in ipairs( ind_base ) do
            base[ v ] = { }
        end

        /*
            calls > create
        */

        local ind_calls = { 'commands', 'hooks', 'net', 'timers' }
        for k, v in ipairs( ind_calls ) do
            base.calls[ v ] = { }
        end

        /*
            helper > create
        */

        if istable( base.h ) then
            base.h = base.h
        else
            base.h = { }
            local to_helper = { 'ent', 'get', 'msg', 'new', 'now', 'ok', 'ply', 'str', 'tbl', 'ui', 'util', 'who' }
            for k, v in ipairs( to_helper ) do
                base.h[ v ] = { }
            end
        end

        /*
            storage > create
        */

        base.s = base.s or { }
        local to_storage = { 'ent', 'json', 'glon', 'mft', 'dir', 'file', 'data', 'get' }
        for k, v in ipairs( to_storage ) do
            base.s[ v ] = { }
        end

        /*
            tools > create
        */

        base.t = base.t or { }
        local to_tools = { 'alogs', 'asay', 'diag', 'pco', 'rdo', 'lang', 'rlib', 'mdlv', 'welcome' }
        for k, v in ipairs( to_tools ) do
            base.t[ v ] = { }
        end

    /*
        console output > header
    */

    local con_hdr =
    {
        '\n\n',
        [[.................................................................... ]],
    }

    /*
        console output > body
    */

    local con_body =
    {
        [[[title]........... ]] .. mf.name .. [[ ]],
        [[[version]......... ]] .. ( istable( mf.version ) and string.format( '%i.%i.%i', mf.version[ 'major' ] or mf.version[ 1 ] or 1, mf.version[ 'minor' ] or mf.version[ 2 ] or 0, mf.version[ 'patch' ] or mf.version[ 3 ] or 0 ) ) or mf.version .. [[ ]],
        [[[released]........ ]] .. os.date( '%m.%d.%Y', mf.released ) .. [[ ]],
        [[[author].......... ]] .. mf.author .. [[ ]],
        [[[website]......... ]] .. mf.site .. [[ ]],
    }

    /*
        console output > tos
    */

    local con_tos =
    {
        [[
Copyright (C) 2018 - ]] .. os.date( '%Y' ) .. [[ :: developed by ]] .. mf.author .. [[

]] .. mf.name .. [[ ('the Library') is licensed under ]] .. mf.license.type .. [[.

This library provides support for outside modules which may not
be included in the distribution of this package. All such
supported modules and libraries adhere to their own license
agreements which should be provided at the time of download.

For more information related to this libraries' license, please
review the provided LICENSE file.

Seeing this message means that rlib and its core are properly
loaded and are now ready to install additional modules.
        ]],
    }

    /*
        console output > footer
    */

    local con_ftr =
    {
        [[.................................................................... ]],
    }

    /*
        console output > print
    */

    if mf.showcopyright then
        for _, i in ipairs( con_hdr ) do
            MsgC( Color( 255, 255, 0 ), i .. '\n' )
        end

        for _, i in ipairs( con_body ) do
            MsgC( Color( 255, 255, 255 ), i .. '\n' )
        end

        for _, i in ipairs( con_ftr ) do
            MsgC( Color( 255, 255, 0 ), i .. '\n' )
        end

        for _, i in ipairs( con_tos ) do
            MsgC( Color( 255, 255, 255 ), '\n' .. i .. '\n' )
        end

        for _, i in ipairs( con_ftr ) do
            MsgC( Color( 255, 255, 0 ), i .. '\n' )
        end
    end

    /*
        localization
    */

    local cfg               = base.settings
    local path_lib          = mf.folder

    /*
        load lua modules
    */

    local modules_lua =
    {
        'sha1',
        'json',
        'rcir',
        'rmem',
    }

    for k, v in ipairs( modules_lua ) do
        if file.Exists( 'includes/modules/' .. v .. '.lua', 'LUA' ) then
            include( 'includes/modules/' .. v .. '.lua' )
            if SERVER then AddCSLuaFile( 'includes/modules/' .. v .. '.lua' ) end
        end
    end

    /*
        calls

        these are definition types used within this script and should never be modified.
        changing the names within this table will not simply change the name, but many parts of the
        library rely on these being named properly.
    */

    parent.manifest.calls =
    {
        'hooks',
        'timers',
        'commands',
        'net',
        'pubc',
    }

    /*
        resources

        used to store particles, sounds, and/or model calls
        @todo   : materials will be migrated later
    */

    parent.manifest.resources =
    {
        'snd',
        'mdl',
        'ptc',
        'pnl',
    }

    /*
        setup calls
    */

    base._rcalls = { }

    /*
        setup resources
    */

    base._res = { }

    /*
        parent manifest > load calls
    */

    for _, v in ipairs( parent.manifest.calls ) do
        local path_c = string.format( '%s/%s/%s/%s.lua', path_lib, 'calls', 'catalog', v )
        if not file.Exists( path_c, 'LUA' ) then continue end
        if SERVER then AddCSLuaFile( path_c ) end
        include( path_c )
    end

    /*
        parent manifest > load resources
    */

    for _, v in ipairs( parent.manifest.resources ) do
        local path = string.format( '%s/%s/%s.lua', path_lib, 'resources', v )
        if not file.Exists( path, 'LUA' ) then continue end
        if SERVER then AddCSLuaFile( path ) end
        include( path )
    end

    /*
        packages > load > pre
    */

    for _, v in ipairs( mf.packages.pre ) do
        local path = string.format( '%s/%s/%s.lua', path_lib, 'packages', v )
        if not file.Exists( path, 'LUA' ) then continue end
        if SERVER then AddCSLuaFile( path ) end
        include( path )
    end

    /*
        core > load files

        do not modify these under any circumstance. we need certain stuff to load first before the
        recursive loader does its job. It's always nice to have a little more control.

        file names for the priority system dont matter and do not have to follow the prefix
        setup (sv_ sh_ cl_) since they are being defined in the string itself.

        : scope ref
            1       : server : sv
            2       : shared : sh
            3       : client : cl

        : values
            file    : file to inc
            scope   : scope to add file to
            seg     : dir of file [ excl filename ] [ def path_lib ]
    */

    self:Files( mf.files.core )

    /*
        packages > load > post
    */

    for _, v in ipairs( mf.packages.post ) do
        local path = string.format( '%s/%s/%s.lua', path_lib, 'packages', v )
        if not file.Exists( path, 'LUA' ) then continue end
        if SERVER then AddCSLuaFile( path ) end
        include( path )
    end

    /*
        load > languages
    */

    local path_lang     = string.format( '%s/%s', mf.folder, 'languages' )
    local files, _      = file.Find( path_lang .. '/*', 'LUA' )

    for v in base.h.get.data( files ) do
        local path = string.format( '%s/%s', path_lang, v )
        include( path )
        AddCSLuaFile( path )
        base:log( RLIB_LOG_DEBUG, '+ lang [ %s ]', path )
    end

    /*
        load > ui elements

        recursive loader for /obj/ folder to load client elements
    */

    local files_obj, _ = file.Find( path_lib .. '/obj/' .. '*', 'LUA' )
    for ui in base.h.get.data( files_obj ) do
        local path = string.format( '%s/%s/%s', path_lib, 'obj', ui )
        if SERVER then
            AddCSLuaFile( path )
        else
            include( path )
        end
        base:log( 6, '+ obj [ %s ]', path )
    end

    /*
        load > interface elements

        recursive loader for client interfaces
    */

    local files_inf, _ = file.Find( path_lib .. '/layout/' .. '*', 'LUA' )
    for inf in base.h.get.data( files_inf ) do
        local path = string.format( '%s/%s/%s', path_lib, 'layout', inf )
        if SERVER then
            AddCSLuaFile( path )
        else
            include( path )
        end
        base:log( 6, '+ lo [ %s ]', path )
    end

    /*
        rlib > system
    */

    base.sys.uptime         = CurTime( )
    base.sys.initialized    = false
    base.sys._cache         = { }

    /*
        Startup
    */

    if SERVER then
        base:Startup( )
    end

    /*
        @exec   : fn rlib.calls:register( rcore, rlib.c )
        @exec   : fn rlib.resources:register( rcore, rlib.r )

        @param  : tbl parent
        @param  : tbl base.c
    */

    base.calls:register     ( parent, base.c )
    base.resources:register ( parent, base.r )

    /*
        hook > rlib post loader
    */

    rhook.run.rlib( 'rlib_loader_post' )

    /*
        enable hibernation thinking
    */

    if SERVER then
        RunConsoleCommand( 'sv_hibernate_think', '1' )
    end

    /*
        files > post load
    */

    self:Files( mf.files.post )

end

/*
    rlib > autoload > files

    load files for library

    @param  : tbl src
*/

function rlib.autoload:Files( src )

    local base                      = rlib
    local cfg                       = base.settings
    local mf                        = base.manifest or { }

    if not istable( src ) then
        MsgC( Color( 255, 0, 0 ), '[' .. mf.name .. '] [L] Error: invalid path ( autoload:Files( ) )\n' )
        return
    end

    for _, v in ipairs( src ) do
        if not v.file then continue end
        if not v.seg then v.seg = mf.folder end

        local path_prio = string.format( '%s/%s.lua', v.seg, v.file )

        if not v.scope then
            MsgC( Color( 255, 0, 0 ), '[' .. mf.name .. '] [L] ERR: ' .. path_prio .. ' :: [ missing scope ]\n' )
            continue
        end

        if v.scope == 1 then
            if not file.Exists( path_prio, 'LUA' ) then continue end
            if SERVER then include( path_prio ) end
            if cfg.debug.enabled then
                MsgC( Color( 255, 255, 0 ), '[' .. mf.name .. '] [L-SV] ' .. path_prio .. '\n' )
            end
        elseif v.scope == 2 then
            if not file.Exists( path_prio, 'LUA' ) then continue end
            include( path_prio )
            if SERVER then AddCSLuaFile( path_prio ) end
            if cfg.debug.enabled then
                MsgC( Color( 255, 255, 0 ), '[' .. mf.name .. '] [L-SH] ' .. path_prio .. '\n' )
            end
        elseif v.scope == 3 then
            if not file.Exists( path_prio, 'LUA' ) then continue end
            if SERVER then
                AddCSLuaFile( path_prio )
            else
                include( path_prio )
            end
            if cfg.debug.enabled then
                MsgC( Color( 255, 255, 0), '[' .. mf.name .. '] [L-CL] ' .. path_prio .. '\n' )
            end
        end
    end
end