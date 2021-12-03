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

local base              = rlib
local helper            = base.h
local ui                = base.i
local cvar              = base.v

/*
*   localized routes
*/

local cfg               = base.settings
local mf                = base.manifest
local pf                = mf.prefix

/*
*   Localized lua funcs
*
*   i absolutely hate having to do this, but for squeezing out every
*   bit of performance, we need to.
*/

local Color             = Color
local pairs             = pairs
local GetConVar         = GetConVar
local istable           = istable
local isstring          = isstring
local type              = type
local Color             = Color
local table             = table
local string            = string
local sf                = string.format

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
*   cvar :: prepare
*
*   called client-side when cvars need to be registerd with a player
*/

function cvar:Prepare( )
    if not istable( ui.cvars ) then return end

    local _toregister = { }
    for k, v in helper:sortedkeys( ui.cvars ) do
        _toregister[ #_toregister + 1 ] = v
    end

    table.sort( _toregister, function( a, b ) return a.sid < b.sid end )

    for k, v in pairs( _toregister ) do
        if base._def.elements_ignore[ v.stype ] then continue end
        cvar:Setup( v.stype, v.id, v.default, v.values, v.forceset, v.desc )
    end
end

/*
*   cvar :: setup
*
*   assigns a clientconvar based on the parameters specified. these convars will then be used later in
*   order for the player.
*
*   forceset will ensure that if the server owner ever updates the core theme manifest that it will
*   auto-push the updated changes to the client on next connection
*
*   @param  : str flag
*   @param  : str id
*   @param  : str def
*   @param  : tbl vals
*   @param  : bool forceset
*   @param  : str help
*   @return : void
*/

function cvar:Setup( flag, id, def, vals, forceset, help )
    if not helper.str:valid( flag ) or not helper.str:valid( id ) then
        log( 2, lang( 'properties_setup' ) )
        return false
    end

    forceset    = forceset or false
    help        = isstring( help ) and help or 'no description'

    if flag ~= 'rgba' and flag ~= 'object' and flag ~= 'dropdown' then
        CreateClientConVar( id, def, true, false, help )
        if forceset then
            local cvar = GetConVar( id )
            cvar:SetString( def )
        end
    elseif flag == 'dropdown' then
        CreateClientConVar( id, def or '', true, false, help )
        if forceset then
            local cvar = GetConVar( id )
            cvar:SetString( def )
        end
    elseif flag == 'object' or flag == 'rgba' then
        if not istable( vals ) then return end
        for dn, dv in pairs( vals ) do
            local assign_id = id .. '_' .. dn
            CreateClientConVar( assign_id, dv, true, false, help )
            if forceset then
                local cvar = GetConVar( assign_id )
                cvar:SetString( dv )
            end
        end
    end
end

/*
*   cvar :: client create
*
*   create a client convar
*
*   @param  : str name
*   @param  : str default
*   @param  : bool save
*   @param  : bool udata
*   @param  : str help
*/

function cvar:CreateClient( name, default, save, udata, help )
    if not helper.str:valid( name ) then
        log( 2, lang( 'cvar_missing_name' ) )
        return false
    end

    if not ConVarExists( name ) then
        if not default then
            log( 2, lang( 'cvar_missing_def', name ) )
            return false
        end

        save        = save or true
        udata       = udata or false
        help        = help or 'auto-created by rlib'

        CreateClientConVar( name, default, save, udata, help )
        log( 6, lang( 'cvar_added', name ) )
    end
end