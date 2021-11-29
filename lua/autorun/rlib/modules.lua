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
local storage               = base.s

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
    prefix > create id
*/

local function cid( id, suffix )
    local affix     = istable( suffix ) and suffix.id or isstring( suffix ) and suffix or pf
    affix           = affix:sub( -1 ) ~= '.' and string.format( '%s.', affix ) or affix

    id              = isstring( id ) and id or 'noname'
    id              = id:gsub( '[%p%c%s]', '.' )

    return string.format( '%s%s', affix, id )
end

/*
    prefix > get id
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and pf ) or false
    return cid( str, state )
end

/*
    localize output functions
*/

local function log( ... )
    base:log( ... )
end

/*
    base > has dependency

    checks to see if a function has the required dependencies such as rlib, rcore + modules, or specified
    objects in general are available

    similar to rcore:bHasModule( ) but accepts other tables outside of rcore. use rcores version to confirm
    just a module

    @ex     : rlib.modules:bInstalled( mod )
            : rlib.modules:bInstalled( 'identix' )

    @param  : str, tbl mod
    @return : bool
*/

function base.modules:bInstalled( mod )
    if not mod then
        log( RLIB_LOG_DEBUG, 'dependency not specified\n%s', debug.traceback( ) )
        return false
    end

    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].enabled ) then
        return true
    elseif istable( mod ) and mod.enabled then
        return true
    elseif istable( mod ) then
        return true
    end

    mod = isstring( mod ) and mod or 'unknown'
    log( RLIB_LOG_DEBUG, 'error loading required dependency [ %s ]\n%s', mod, debug.traceback( ) )

    return false
end

/*
    base > module > exists

    check if the specified module is valid or not

    @param  : tbl, str mod
    @return : bool
*/

function base.modules:bExists( mod )
    if not mod then return false end
    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].enabled ) then
        return true
    elseif istable( mod ) then
        return true
    end

    return false
end

/*
    base > module > alpha

    returns if module is alpha release

    @param  : tbl, str mod
    @return : bool
*/

function base.modules:bIsAlpha( mod )
    if not mod then return false end
    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and ( rcore.modules[ mod ].build == 1 ) ) then
        return true
    elseif istable( mod ) and ( mod.build == 1 ) then
        return true
    end

    return false
end

/*
    base > module > beta

    returns if module is beta release

    @param  : tbl, str mod
    @return : bool
*/

function base.modules:bIsBeta( mod )
    if not mod then return false end
    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and ( rcore.modules[ mod ].build == 2 ) ) then
        return true
    elseif istable( mod ) and ( mod.build == 2 ) then
        return true
    end

    return false
end

/*
    modules > get build

    @param  : tbl, str mod
    @return : int
*/

function base.modules:Build( mod )
    if not mod then return false end

    local build
    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] ) then
        local resp  = rcore.modules[ mod ].build or 0
        build       = resp
    elseif istable( mod ) then
        local resp  = mod.build or 0
        build       = resp
    end

    if not build then return base._def.builds[ 0 ] end

    return base._def.builds[ build ]
end

/*
    base > module > build

    returns module build

    @param  : tbl, str mod
    @return : str
*/

function base.modules:build( mod )
    if not mod then return false end

    local build
    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].build ) then
        build       = rcore.modules[ mod ].build
    elseif istable( mod ) and mod.build then
        build       = mod.build or 0
    end

    if not build then return base._def.builds[ 0 ] end

    return base._def.builds[ build ]
end

/*
    module > version

    returns the version of the installed module as a table

    @call   : rlib.modules:ver( mod )
            : rlib.modules:ver( 'lunera' )

    @since  : v3.0.0
    @return : tbl
            : major, minor, patch, build
*/

function base.modules:ver( mod )
    if not mod then
        return {
            [ 'major' ] = 1,
            [ 'minor' ] = 0,
            [ 'patch' ] = 0,
            [ 'micro' ] = 0,
            [ 'build' ] = 0,
        }
    end
    if isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].version then
        if isstring( rcore.modules[ mod ].version ) then
            local ver       = string.Explode( '.', rcore.modules[ mod ].version )
            local build     = rcore.modules[ mod ].build or 0
            return {
                [ 'major' ] = ver[ 'major' ] or ver[ 1 ] or 1,
                [ 'minor' ] = ver[ 'minor' ] or ver[ 2 ] or 0,
                [ 'patch' ] = ver[ 'patch' ] or ver[ 3 ] or 0,
                [ 'micro' ] = ver[ 'micro' ] or ver[ 4 ] or 0,
                [ 'build' ] = build,
            }
        elseif istable( rcore.modules[ mod ].version ) then
            return {
                [ 'major' ] = rcore.modules[ mod ].version.major or rcore.modules[ mod ].version[ 1 ] or 1,
                [ 'minor' ] = rcore.modules[ mod ].version.minor or rcore.modules[ mod ].version[ 2 ] or 0,
                [ 'patch' ] = rcore.modules[ mod ].version.patch or rcore.modules[ mod ].version[ 3 ] or 0,
                [ 'micro' ] = rcore.modules[ mod ].version.micro or rcore.modules[ mod ].version[ 4 ] or 0,
                [ 'build' ] = rcore.modules[ mod ].build or 0,
            }
        end
    elseif istable( mod ) and mod.version then
        if isstring( mod.version ) then
            local ver       = string.Explode( '.', mod.version )
            local build     = mod.build or 0
            return {
                [ 'major' ] = ver[ 'major' ] or ver[ 1 ] or 1,
                [ 'minor' ] = ver[ 'minor' ] or ver[ 2 ] or 0,
                [ 'patch' ] = ver[ 'patch' ] or ver[ 3 ] or 0,
                [ 'micro' ] = ver[ 'micro' ] or ver[ 4 ] or 0,
                [ 'build' ] = build or 0,
            }
        elseif istable( mod.version ) then
            return {
                [ 'major' ] = mod.version.major or mod.version[ 1 ] or 1,
                [ 'minor' ] = mod.version.minor or mod.version[ 2 ] or 0,
                [ 'patch' ] = mod.version.patch or mod.version[ 3 ] or 0,
                [ 'micro' ] = mod.version.micro or mod.version[ 4 ] or 0,
                [ 'build' ] = mod.build or 0,
            }
        end
    end
    return {
        [ 'major' ] = 1,
        [ 'minor' ] = 0,
        [ 'patch' ] = 0,
        [ 'micro' ] = 0,
        [ 'build' ] = 0,
    }
end

/*
    base > module > get list

    returns table of modules installed on server

    @return : tbl
*/

function base.modules:list( )
    if not rcore.modules then
        log( 2, 'modules table missing\n%s', debug.traceback( ) )
        return false
    end

    return rcore.modules
end

/*
    base > module > list > formatted

    returns list of delimited modules

    @return : str
*/

function base.modules:listf( )
    local lst, i = { }, 1
    for k, v in SortedPairs( self:list( ) ) do
        if not v.enabled then continue end

        lst[ i ]    = k
        i           = i + 1
    end

    local resp  = table.concat( lst, ', ' )
    resp        = resp:sub( 1, -1 )

    return resp
end

/*
    module > version to str

    returns the version of the installed module in a human readable string

    @call   : rlib.modules:ver2str( mod )
            : rlib.modules:ver2str( 'lunera' )

    @return : v2.x.x.x stable

    @return : str
*/

function base.modules:ver2str( mod )
    if not mod then return '1.0.0.0 stable' end

    if isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].version then
        if isstring( rcore.modules[ mod ].version ) then
            return rcore.modules[ mod ].version
        elseif istable( rcore.modules[ mod ].version ) then
            local major, minor, patch, micro, build = rcore.modules[ mod ].version.major or rcore.modules[ mod ].version[ 1 ] or 1, rcore.modules[ mod ].version.minor or rcore.modules[ mod ].version[ 2 ] or 0, rcore.modules[ mod ].version.patch or rcore.modules[ mod ].version[ 3 ] or 0, rcore.modules[ mod ].version[ 4 ] or 0, rcore.modules[ mod ].build or 0
            return string.format( '%i.%i.%i.%i %s', major, minor, patch, micro, base._def.builds[ build ] )
        end
    elseif istable( mod ) and mod.version then
        if isstring( mod.version ) then
            return mod.version
        elseif istable( mod.version ) then
            local major, minor, patch, micro, build = mod.version.major or mod.version[ 1 ] or 1, mod.version.minor or mod.version[ 2 ] or 0, mod.version.patch or mod.version[ 3 ] or 0, mod.version.micro or mod.version[ 4 ] or 0, mod.build or 0
            return string.format( '%i.%i.%i.%i %s', major, minor, patch, micro, base._def.builds[ build ] )
        end
    end

    return '1.0.0.0 stable'
end

/*
    module > version to str > simple

    returns the version of the installed module in a human readable string.
    does not include build

    @call   : rlib.modules:ver2str_s( mod )
            : rlib.modules:ver2str_s( 'lunera' )

    @return : v2.x.x.x

    @return : str
*/

function base.modules:ver2str_s( mod )
    if not mod then return '1.0.0.0' end

    if isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].version then
        if isstring( rcore.modules[ mod ].version ) then
            return rcore.modules[ mod ].version
        elseif istable( rcore.modules[ mod ].version ) then
            local major, minor, patch, micro = rcore.modules[ mod ].version.major or rcore.modules[ mod ].version[ 1 ] or 1, rcore.modules[ mod ].version.minor or rcore.modules[ mod ].version[ 2 ] or 0, rcore.modules[ mod ].version.patch or rcore.modules[ mod ].version[ 3 ] or 0, rcore.modules[ mod ].version.micro or rcore.modules[ mod ].version[ 4 ] or 0
            return string.format( '%i.%i.%i.%i', major, minor, patch, micro )
        end
    elseif istable( mod ) and mod.version then
        if isstring( mod.version ) then
            return mod.version
        elseif istable( mod.version ) then
            local major, minor, patch, micro = mod.version.major or mod.version[ 1 ] or 1, mod.version.minor or mod.version[ 2 ] or 0, mod.version.patch or mod.version[ 3 ] or 0, mod.version.micro or mod.version[ 4 ] or 0
            return string.format( '%i.%i.%i.%i', major, minor, patch, micro )
        end
    end

    return '1.0.0.0'
end

/*
    base > module > get module

    returns specified module table

    @param  : str, tbl mod
    @return : tbl
*/

function base.modules:get( mod )
    if not mod then
        log( 2, 'specified module not available\n%s', debug.traceback( ) )
        return false
    end

    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].enabled ) then
        return rcore.modules[ mod ]
    elseif istable( mod ) then
        return mod
    end

    mod = isstring( mod ) and mod or 'unknown'
    log( RLIB_LOG_DEBUG, 'error loading required dependency [ %s ]\n%s', mod, debug.traceback( ) )

    return false
end

/*
    base > module > get prefix

    used for various things such as font names, etc.

    @param  : tbl mod
    @param  : str suffix
*/

function base.modules:prefix( mod, suffix )
    if not istable( mod ) then
        log( RLIB_LOG_DEBUG, 'warning: cannot create prefix with missing module in \n[ %s ]', debug.traceback( ) )
        return
    end

    suffix = suffix or ''

    return string.format( '%s%s.', suffix, mod.id )
end
base.modules.pf = base.modules.prefix

/*
    base > module > load module

    loads specified module table

    @param  : str, tbl mod
    @return : tbl
*/

function base.modules:require( mod )
    local bLoaded = false
    if mod and rcore.modules[ mod ] and rcore.modules[ mod ].enabled then
        bLoaded = true
        return rcore.modules[ mod ], self:prefix( rcore.modules[ mod ] )
    end

    if not bLoaded then
        mod = mod or 'unknown'
        log( RLIB_LOG_DEBUG, 'missing module [ %s ]\n%s', mod, debug.traceback( ) )
        return false
    end
end
base.modules.req = base.modules.require

/*
    base > module > manifest

    returns stored modules.txt file

    @return : str
*/

function base.modules:Manifest( )
    local path      = storage.mft:getpath( 'data_modules' )
    local modules   = ''
    if file.Exists( path, 'DATA' ) then
        modules  = file.Read( path, 'DATA' )
    end

    return modules
end

/*
    base > module > ManifestList

    returns a list of modules in a simple string format

    @return : str
*/

function base.modules:ManifestList( )
    local lst       = ''
    local i, pos    = table.Count( rcore.modules ), 1
    for k, v in SortedPairs( rcore.modules ) do
        local name      = v.name:gsub( '[%s]', '' )
        name            = name:lower( )

        local ver       = ( istable( v.version ) and rlib.get:ver2str_mfs( v, '_' ) ) or v.version
        ver             = ver:gsub( '[%p]', '' )

        local enabled   = v.enabled and "enabled" or "disabled"

        local sep =     ( i == pos and '' ) or '-'
        lst            = string.format( '%s%s_%s_%s%s', lst, name, ver, enabled, sep )

        pos             = pos + 1
    end

    return lst
end

/*
    base > module > registered panels

    returns a list of registered pnls based on the specified module

    @param  : str, tbl mod
    @return : tbl
*/

function base.modules:RegisteredPnls( mod )
    local bLoaded = false
    if mod then
        if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] ) then
            return base.p[ mod ]
        elseif istable( mod ) then
            return base.p[ mod.id ]
        end
    end

    if not bLoaded then
        local mod_output = isstring( mod ) and mod or 'unspecified'
        rlib:log( RLIB_LOG_DEBUG, 'missing module [ %s ]\n%s', mod_output, debug.traceback( ) )
        return false
    end
end

/*
    base > module > log

    logs data to rlib\modules\module_name\logs

    @link   : rcore.log

    @param  : tbl, str mod
    @param  : int cat
    @param  : str msg
    @param  : varg varg
*/

base.modules.log = rcore.log

/*
    base > module > get cfg

    fetches config parameters from the specified module

    @ex :

        local cfg_mo 		= rlib and rlib.modules:cfg( 'module_name' )
 		local job_house		= cfg_mo.setting_name

    @param  : str, tbl mod
    @return : tbl
*/

function base.modules:cfg( mod )
    if not mod then
        log( RLIB_LOG_DEBUG, 'dependency not specified\n%s', debug.traceback( ) )
        return false
    end

    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].enabled ) then
        return rcore.modules[ mod ].settings
    elseif istable( mod ) then
        return mod.settings
    end

    mod = isstring( mod ) and mod or 'unknown'
    log( RLIB_LOG_DEBUG, 'error loading required dependency [ %s ]\n%s', mod, debug.traceback( ) )

    return false
end

/*
    base > module > ents

    fetches module ents

    @param  : str, tbl mod
    @return : tbl
*/

function base.modules:ents( mod )
    if not mod then
        log( RLIB_LOG_DEBUG, 'dependency not specified\n%s', debug.traceback( ) )
        return false
    end

    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].enabled ) then
        return rcore.modules[ mod ].ents
    elseif istable( mod ) then
        return mod.ents
    end

    mod = istable( mod ) and mod or 'unknown'
    log( RLIB_LOG_DEBUG, 'error fetching entities for module [ %s ]\n%s', mod, debug.traceback( ) )

    return false
end

/*
    base > modules > sap

    returns a list of registered hexes for module
*/

function base.modules:sap( mod )
    if not mod then
        log( 6, 'dependency not specified\n%s', debug.traceback( ) )
        return false
    end

    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] and rcore.modules[ mod ].enabled ) then
        return rcore.modules[ mod ].sap
    elseif istable( mod ) then
        return mod.sap
    end
end

/*
    base > module > count

    returns count of modules installed

    @return : str
*/

function base.modules:count( )
    return table.Count( rcore.modules ) or 0
end