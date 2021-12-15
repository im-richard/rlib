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
    DEVELOPER NOTE
    ---------------------------------------------------------------------------------------------
    rlib currently contains rmats v1 and v2

    v1 will be deprecated in a future release and is slowly being phased out
    for a more optimized system which caches the materials directly within
    the module they are associated with.
*/

/*
    library
*/

local base                  = rlib
local helper                = base.h
local materials             = base.m
materials._cache            = { }

/*
    library > localize
*/

local cfg                   = base.settings
local mf                    = base.manifest
local pf                    = mf.prefix

/*
    storage
*/

local path_mats             = mf.paths[ 'dir_mats' ]

/*
    languages
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