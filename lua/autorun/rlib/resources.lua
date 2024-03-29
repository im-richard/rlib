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
local sys                   = base.sys
local res                   = base.resources

/*
    library > localize
*/

local cfg                   = base.settings
local mf                    = base.manifest

/*
    languages
*/

local function ln( ... )
    return base:lang( ... )
end

/*
*   resources :: register
*
*   grab resource categories from main lib table which typically include:
*       : sounds
*       : particles
*       : models
*
*   send regsitered res from source table
*       rlib.resources[ type ] => rlib._res[ type ]
*
*   if resource is a recognized type such as sounds, particles, models;
*   the additional step of precaching will be executed
*
*   @param  : tbl parent
*   @param  : tbl src
*/

function res:register( parent, id, src, bPrecache )
    if not parent.manifest.resources or not istable( parent.manifest.resources ) then
        base:log( 2, 'missing resources definition table -- aborting' )
        return
    end

    if not src or not istable( src ) then
        base:log( 6, 'cannot load resources without valid table' )
        return
    end

    for _, v in pairs( parent.manifest.resources ) do

        /*
        *   v returns call_type
        */

        local call_type = v:lower( )
        if not src[ call_type ] then
            src[ call_type ] = { }
        end

        /*
        *   build resources lib
        *
        *   loop resources and setup structure
        *   : l        =   call_id
        *   : m[ 1 ]   =   call.id
        *   : m[ 2 ]   =   desc (optional)
        */

        for l, m in pairs( src[ call_type ] ) do
            base._res[ call_type ]              = base._res[ call_type ] or { }
            base._res[ call_type ][ id ]        = base._res[ call_type ][ id ] or { }
            base._res[ call_type ][ id ][ l ]   = { tostring( m[ 1 ] ), m[ 2 ] and tostring( m[ 2 ] ) or ln( 'res_no_desc' ) }

            if bPrecache then
                if call_type == 'snd' then
                    if isstring( m[ 1 ] ) then
                        base.register:sound( m[ 1 ] )
                    end
                elseif call_type == 'ptc' then
                    if isstring( m[ 1 ] ) then
                        rlib.register:particle( m[ 1 ] )
                    end
                elseif call_type == 'mdl' then
                    if isstring( m[ 1 ] ) then
                        rlib.register:model( m[ 1 ] )
                    end
                end
            end

            sys.resources = ( sys.resources or 0 ) + 1
        end

    end
end

/*
*   resources :: validation
*
*   checks a provided call id to see if it is registered within rlib.rcalls
*
*   @param  : str t
*   @return : tbl
*/

function res:valid( mod, t )
    if not t or not isstring( t ) or t == '' then
        rlib:log( 2, 'missing specified call type' )
        local resp, cnt_calls, i = '', #base._res, 0
        for k, v in pairs( base._res ) do
            resp = resp .. k
            i = i + 1
            if i < cnt_calls then
                resp = resp .. ', '
            end
        end
        rlib:log( 2, 'valid types are [ %s ]', resp )
        return
    end

    local data = base._res[ t ]
    if not data then
        rlib:log( 2, 'missing resource type » [ %s ]', t )
        return
    end

    return data or false
end

/*
*   resources :: exists
*
*   returns if associated call is valid
*
*   @param  : tbl mod
*   @param  : str t
*   @param  : str s
*   @param  : varg { ... }
*   @return : str
*/

function res:exists( mod, t, s, ... )
    local data = res:valid( mod, t )
    if not data then return end

    if not isstring( s ) then
        rlib:log( 2, 'id missing » [ %s ]', t )
        return false
    end

    mod     = ( isstring( mod ) and istable( rcore.modules[ mod ] ) and rcore.modules[ mod ] ) or ( istable( mod ) and mod )
    s       = s:gsub( '[%p%c%s]', '_' ) -- replace punct, contrl chars, and whitespace with underscores

    local ret = string.format( s, ... )
    if istable( mod ) then
        if data and data[ mod.id ] and data[ mod.id ][ s ] then
            ret = string.format( data[ mod.id ][ s ][ 1 ], ... )
        end
    else
        ret = nil
    end

    return ret
end

/*
*   resources :: get
*
*   returns the associated call data table
*
*   call using localized function in file that you require fetching needed resources.
*
*   @ex     : rlib.resources:get( 'calltype', 'id' )
*             rlib.resources:get( 'mdl', 'modname_mdl_combine' )
*
*   @param  : str t
*   @param  : str s
*   @return : tbl
*/

function res:get( t, s )
    local data = self:valid( t )
    if not data then return end

    if s and data[ s ] then
        return data[ s ]
    else
        return data
    end

    return
end