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

/*
    library > localize
*/

local cfg                   = base.settings
local mf                    = base.manifest
local pf                    = mf.prefix

/*
    localize output functions
*/

local function log( ... )
    base:log( ... )
end

/*
    prefix > create id
*/

local function cid( id, suffix )
    local affix = istable( suffix ) and suffix.id or isstring( suffix ) and suffix or pf
    affix = affix:sub( -1 ) ~= '.' and string.format( '%s.', affix ) or affix

    id = isstring( id ) and id or 'noname'
    id = id:gsub( '[%p%c%s]', '.' )

    return string.format( '%s%s', affix, id )
end

/*
    prefix > get id
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and base.manifest.prefix ) or false
    return cid( str, state )
end

/*
*   base :: register :: particle
*
*   @param  : str, tbl src
*   @return : void
*/

function base.register:particle( src )
    if not isstring( src ) then return end
    if string.GetExtensionFromFilename( src ) ~= 'pcf' then
        PrecacheParticleSystem( src )
        log( RLIB_LOG_CACHE, '+ ptc [ %s ]', src )
    else
        game.AddParticles( src )
        log( RLIB_LOG_CACHE, '+ ptc [ %s ] ', src )
    end
end

/*
*   base :: register :: sound
*
*   @param  : str, tbl src
*   @return : void
*/

function base.register:sound( src )
    if not src then return end
    if string.GetExtensionFromFilename( src ) ~= 'wav' and string.GetExtensionFromFilename( src ) ~= 'mp3' and string.GetExtensionFromFilename( src ) ~= 'ogg' then
        rlib:log( RLIB_LOG_CACHE, '- snd skip ( [ %s ] )', src )
        return
    end
    util.PrecacheSound( src )
    log( RLIB_LOG_CACHE, '+ snd [ %s ]', src )
end

/*
*   base :: register :: model
*
*   limited to 4096 unique models. when it reaches the limit the game will crash.
*
*   @param  : str, tbl src
*   @param  : bool bIsValid
*   @return : void
*/

function base.register:model( src, bIsValid )
    if not src then return end
    if string.GetExtensionFromFilename( src ) ~= 'mdl' then
        rlib:log( RLIB_LOG_CACHE, '- mdl skip ( [ %s ] )', src )
        return
    end
    if bIsValid and not util.IsValidModel( src ) then return end
    util.PrecacheModel( src )
    log( RLIB_LOG_CACHE, '+ mdl [ %s ]', src )
end

/*
*   base :: register :: darkrp models
*
*   will precache ply mdls if gamemode is derived from darkrp
*   only executes if cfg.cache.darkrp_mdl = true in lib config file
*/

function base.register:rpmodels( )
    if not cfg.cache.darkrp_mdl then return end
    if not istable( RPExtraTeams ) then return end

    local i = 0
    for v in helper.get.data( RPExtraTeams ) do
        if istable( v.model ) then
            for mdl in helper.get.data( v.model ) do
                if string.GetExtensionFromFilename( mdl ) ~= 'mdl' then continue end
                util.PrecacheModel( mdl )
                if cfg.cache.debug_listall then
                    log( RLIB_LOG_CACHE, '+ darkrp mdl [ %s ]', mdl )
                end
                i = i + 1
            end
        else
            if string.GetExtensionFromFilename( v.model ) ~= 'mdl' then continue end
            util.PrecacheModel( v.model )
            if cfg.cache.debug_listall then
                log( RLIB_LOG_CACHE, '+ darkrp mdl [ %s ]', v.model )
            end
            i = i + 1
        end
    end

    log( RLIB_LOG_CACHE, '+ darkrp mdl [ %s total ]', tostring( i ) )
end
hook.Add( 'InitPostEntity', pid( 'register.rpmdl' ), base.register.rpmodels )