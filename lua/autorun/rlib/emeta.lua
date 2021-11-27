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
    languages
*/

local function ln( ... )
    return base:lang( ... )
end

/*
    prefix > get id
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and base.manifest.prefix ) or false
    return base.get:pref( str, state )
end

/*
    emeta
*/

local emeta                 = FindMetaTable( 'Entity' )

/*
 	emeta > what > get

    returns ent id or class name

 	@param	: bool bEID
 	@return	: str
*/

function emeta:what( bEID )
    if not self:IsValid( ) then return end
    return ( bEID and self:EntIndex( ) or self:GetClass( ) ) or 0
end

/*
 	emeta > generate id

    returns an id based on the ent
    useful for ent specific timer ids, etc.

    @ex     : timer_id = ent:gid( 'val', false || true )
    @res    : val.rlib_ent_class
            : val.1678

 	@param	: str suffix
    @param  : bool bUseSteam
 	@return	: str
*/

function emeta:gid( suffix, bUseEntID )
    if not self:IsValid( ) then return end
    local id = ( bUseEntID and self:EntIndex( ) ) or self:GetClass( )
    return string.format( '%s.%s', suffix, tostring( id ) )
end

/*
    emeta > association id

    makes an id based on the specified ent class
        : special chars     => [ . ]
        : spaces            => [ _ ]

    @ex     : timer_id = ent:aid( 'timer', 'frostshell'  )
    @res    : timer.frostshell.ent_class_name

    @param  : varg { ... }
    @return : str
*/

function emeta:aid( ... )
    if not helper.ok.ent( self ) then return end

    local cl            = self:what( true )
    local args          = { ... }

    table.insert        ( args, cl )

    local resp          = table.concat( args, '_' )
    resp                = resp:lower( )
    resp                = resp:gsub( '[%p%c]', '.' )
    resp                = resp:gsub( '[%s]', '_' )

    return resp
end