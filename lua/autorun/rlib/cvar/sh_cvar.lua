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
local access                = base.a
local helper                = base.h
local cvar                  = base.v

/*
*   localized routes
*/

local cfg                   = base.settings
local mf                    = base.manifest
local pf                    = mf.prefix

/*
    localize > glua
*/

local sf                    = string.format

/*
    language
*/

local function lang( ... )
    return base:lang( ... )
end

/*
*   simplifiy funcs
*/

local function log( ... ) base:log( ... ) end

/*
*   convar :: validate
*
*   checks if the provided item is a convar
*
*   @param  : mix obj
*   @return : bool
*/

function cvar:valid( obj )
    return ( type( obj ) == 'ConVar' ) or false
end

/*
*   convar :: register
*
*   @param  : str name
*   @param  : str value
*   @param  : enum, tbl flags
*   @param  : str help
*/

function cvar:Register( name, value, flags, help )
    if not helper.str:valid( name ) or not helper.str:valid( name ) then
        log( 2, 'cannot register cvar with missing parameters' )
        return
    end

    if not ConVarExists( name ) then
        if not value then
            log( 2, 'cvar default missing » [ %s ]', name )
            return
        end

        if not flags then
            log( 2, 'cvar flags missing » [ %s ]', name )
            return
        end

        help = help or ''

        CreateConVar( name, value, flags, help )

        log( 6, lang( 'cvar_added', name ) )
    end
end

/*
*   convar :: get :: clr
*
*   fetches the proper clrs associated with a particular convar.
*
*   @param  : str id
*   @param  : tbl alt
*   @return : clr tbl
*/

function cvar:Clr( id, alt )
    local channels = { id .. '_red', id .. '_green', id .. '_blue', id .. '_alpha' }

    local i = 0
    for _, v in pairs( channels ) do
        if not ConVarExists( v ) then continue end
        i = i + 1
    end

    if i < 3 then
        return alt or Color( 255, 255, 255, 255 )
    elseif i == 3 then
        return Color( GetConVar( id .. '_red' ):GetInt( ), GetConVar( id .. '_green' ):GetInt( ), GetConVar( id .. '_blue' ):GetInt( ) )
    elseif i > 3 then
        return Color( GetConVar( id .. '_red' ):GetInt( ), GetConVar( id .. '_green' ):GetInt( ), GetConVar( id .. '_blue' ):GetInt( ), GetConVar( id .. '_alpha' ):GetInt( ) )
    end
end

/*
*   convar :: get
*
*   valides and returns a specified convar
*
*   @param  : str id
*   @return : cvar
*/

function cvar:Get( id )
    return ( isstring( id ) and ConVarExists( id ) and GetConVar( id ) ) or ( self:valid( id ) and id ) or false
end

/*
*   convar :: get :: name
*
*   valides and returns a specified convar
*   param accepts either a str; or the convar itself
*
*   @param  : str id
*   @return : cvar
*/

function cvar:Name( id )
    local cv = ( isstring( id ) and ConVarExists( id ) and GetConVar( id ) ) or ( self:valid( id ) and id ) or false
    return cv:GetName( )
end

/*
*   convar :: get :: helptext
*
*   returns the helptext for a registered convar
*
*   @param  : str id
*   @return : str
*/

function cvar:Help( id )
    local cv = self:Get( id )
    if not cv then return end
    return cv:GetHelpText( ) or lang( 'cvar_nohelp' )
end

/*
*   convar :: set :: int
*
*   @param  : str id
*   @param  : int val
*/

function cvar:SetInt( id, val )
    local cv = self:Get( id )
    if not cv then return end
    cv:SetInt( val )
end
cvar.Int = cvar.SetInt

/*
*   convar :: set :: str
*
*   @param  : str id
*   @param  : str val
*/

function cvar:SetStr( id, val )
    if not id then return end

    if ( isstring( id ) and self:Get( id ) ) then
        local cv = GetConVar( id )
        cv:SetString( val )
    elseif ( self:valid( id ) ) then
        id:SetString( val )
    end
end

/*
*   convar :: set :: bool
*
*   @param  : str id
*   @param  : bool val
*/

function cvar:SetBool( id, val )
    if not id then return end
    val = val or false

    if ( isstring( id ) and self:Get( id ) ) then
        local cv = GetConVar( id )
        cv:SetBool( val )
    elseif ( self:valid( id ) ) then
        id:SetBool( val )
    end
end

/*
*   convar :: set :: float
*
*   @param  : str id
*   @param  : flt val
*/

function cvar:SetFloat( id, val )
    if not id then return end
    val = val or 0

    if ( isstring( id ) and self:Get( id ) ) then
        local cv = GetConVar( id )
        cv:SetFloat( val )
    elseif ( self:valid( id ) ) then
        id:SetFloat( val )
    end
end

/*
*   convar :: get :: default
*
*   returns a cvar default value
*
*   @param  : str id
*   @return : mix
*/

function cvar:GetDef( id )
    return ConVarExists( id ) and GetConVar( id ):GetDefault( )
end
cvar.Def = cvar.GetDef

/*
*   convar :: get :: int
*
*   fetches the proper int associated with a particular convar.
*   param accepts either a str; or the convar itself
*
*   @param  : str id
*   @param  : int alt
*   @return : int
*/

function cvar:GetInt( id, alt )
    return ( isstring( id ) and ConVarExists( id ) and GetConVar( id ):GetInt( ) ) or ( self:valid( id ) and id:GetInt( ) ) or self:GetDef( id ) or alt
end
cvar.Int = cvar.GetInt

/*
*   convar :: get :: str
*
*   fetches the proper str associated with a particular convar.
*   param accepts either a str; or the convar itself
*
*   @param  : str id
*   @param  : str alt
*   @return : str
*/

function cvar:GetStr( id, alt )
    return ( isstring( id ) and ConVarExists( id ) and GetConVar( id ):GetString( ) ) or ( self:valid( id ) and id:GetString( ) ) or self:GetDef( id ) or alt
end
cvar.Str = cvar.GetStr

/*
*   convar :: get :: str :: strict method
*
*   fetches the proper str associated with a particular convar.
*
*   @param  : str id
*   @param  : str alt
*   @return : str
*/

function cvar:GetStrStrict( id, alt )
    return ConVarExists( id ) and GetConVar( id ):GetString( ) or self:GetDef( id ) or alt
end

/*
*   convar :: get :: float
*
*   fetches the proper float associated with a particular convar.
*   param accepts either a str; or the convar itself
*
*   @param  : str, cvar id
*   @param  : flt alt
*   @return : flt
*/

function cvar:GetFloat( id, alt )
    return ( isstring( id ) and ConVarExists( id ) and GetConVar( id ):GetFloat( ) ) or ( self:valid( id ) and id:GetFloat( ) ) or self:GetDef( id ) or alt or 0
end
cvar.Flt = cvar.GetFloat
cvar.Float = cvar.GetFloat

/*
*   convar :: get :: bool
*
*   fetches the proper bool associated with a particular convar.
*   param accepts either a str; or the convar itself
*
*   @param  : str, cvar id
*   @return : bool
*/

function cvar:GetBool( id )
    return ( isstring( id ) and ConVarExists( id ) and GetConVar( id ):GetBool( ) ) or ( self:valid( id ) and id:GetBool( ) ) or false
end
cvar.Bool = cvar.GetBool

/*
*   convar :: int to bool
*
*   converts an int stored cvar to a bool
*   param accepts either a str; or the convar itself
*
*   @param  : str, cvar id
*   @return : bool
*/

function cvar:Int2Bool( id )
    return ( isstring( id ) and ConVarExists( id ) and self:int2bool( GetConVar( id ):GetInt( ) ) ) or ( self:valid( id ) and helper:int2bool( id:GetInt( ) ) ) or false
end