/*
*   @package        : rlib
*   @author         : Richard [http://steamcommunity.com/profiles/76561198135875727]
*   @copyright      : (C) 2019 - 2020
*   @since          : 2.2.0
*   @website        : https://rlib.io
*   @docs           : https://docs.rlib.io
*
*   MIT License
*
*   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
*   LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
*   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
*   WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/*
*   standard tables and localization
*/

local base                  = rlib
local mf                    = base.manifest

/*
*   localized rlib routes
*/

local helper                = base.h

/*
*   Localized lua funcs
*
*   i absolutely hate having to do this, but for squeezing out every
*   bit of performance, we need to.
*/

local istable               = istable
local isfunction            = isfunction
local isnumber              = isnumber
local isstring              = isstring
local debug                 = debug
local util                  = util
local table                 = table
local math                  = math
local string                = string
local sf                    = string.format

/*
*   Localized cmd func
*/

local function call( t, ... )
    return rlib:call( t, ... )
end

/*
*   Localized translation func
*/

local function lang( ... )
    return base:lang( ... )
end

/*
*	prefix ids
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and mf.prefix ) or false
    return rlib.get:pref( str, state )
end

/*
*	prefix > getid
*
*   @param  : str id
*/

local function gid( id )
    id = isstring( id ) and id or nil
    if not isstring( id ) then
        local trcback = debug.traceback( )
        base:log( dcat, '[ %s ] :: invalid id\n%s', pkg_name, tostring( trcback ) )
        return
    end

    id = call( 'commands', id )

    return id
end

/*
*   pmeta
*/

local pmeta                 = FindMetaTable( 'Player' )

if SERVER then

/*
*   set alias
*
*   sets the nick for a player, also takes other gamemodes into consideration to support different
*   storage types and funcs
*
*   @param  : str nick
*/

function pmeta:setalias( nick )
    local setname = ( isstring( nick ) and nick ) or self:palias( )

    self:SetName( setname )

    if self.setRPName then
        self:setRPName( setname )
    end

    if self.setDarkRPVar then
        self:setDarkRPVar( 'rpname', setname )
    end
end

end

/*
*   alias
*
*   displays their real name (alias) to use on the server
*   override can be applied to check for valid string first
*
*   : priority      : override
*                   : bot
*                   : player name
*                   : steam name
*
*   @param  : str override
*/

function pmeta:palias( override )
    if self.IsIncognito and self:IsIncognito( ) then
        return self:IncognitoName( )
    end

    return ( helper.ok.any( self ) and ( isstring( override ) and override ) or ( helper.ok.str( self:Name( ) ) and self:Name( ) ) or ( self.SteamName and self:SteamName( ) ) )
end

/*
*	player model > revision 2
*
*   a fix for certain models displaying /models/models/
*
*   @return : tbl, str
*/

function pmeta:getmdl_rev2( )
    if self:GetModel( ):sub( 1, 13 ) == 'models/models' then
        return self:GetModel( ):sub( 8 )
    else
        return self:GetModel( )
    end
end

/*
*	player model > get
*
*   returns the current model for the job of a player
*
*	@param	: bool bCurrent
*   @return : tbl, str
*/

function pmeta:getmdl( bCurrent )
    local team      = self:Team( )
    local result    = 'models/error.mdl'
    if RPExtraTeams and RPExtraTeams[ team ] then
        local mdl = RPExtraTeams[ team ].model
        result = istable( mdl ) and mdl[ 1 ] or mdl
        util.PrecacheModel( result )
    else
        result = self:getmdl_rev2( )
    end

    if bCurrent then
        result = self:getmdl_rev2( )
    end

    return result
end
pmeta.getmodel = pmeta.getmdl

/*
*	uid > get
*
*   returns unique id or account id of ply
*
*	@param	: bool bUID
*	@return	: str
*/

function pmeta:uid( bUID )
    return ( not bUID and self:UniqueID( ) or self:AccountID( ) ) or 0
end

/*
*	sid > get
*
*   returns steam64 or steam32 id of ply
*
*	@param	: bool bS32
*	@return	: str
*/

function pmeta:sid( bS32 )
    return ( not bS32 and self:SteamID64( ) or self:SteamID( ) ) or 0
end

/*
*	generate id
*
*   returns an id based on the players account id
*   useful for ply specific timer ids, etc.
*
*   @ex     : timer_id = ply:gid( 'val', false || true )
*   @res    : val.4167188814
*           : val.765611983XXXXXXX
*
*	@param	: str suffix
*   @param  : bool bUseSteam
*	@return	: str
*/

function pmeta:gid( suffix, bUseS64 )
    local id = ( bUseS64 and ( ( self:IsBot( ) and self:UniqueID( ) ) or ( self:SteamID64( ) ) ) or self:UniqueID( ) )
    return sf( '%s.%s', suffix, id )
end

/*
*   association id
*
*   makes an id based on the specified ply unique id
*       : special chars     => [ . ]
*       : spaces            => [ _ ]
*
*   @note   : non-ply associated func helper.get.id( ... )
*
*   @ex     : timer_id = ply:aid( 'timer', 'frostshell'  )
*   @res    : timer.frostshell.4167188814
*
*   @param  : varg { ... }
*   @return : str
*/

function pmeta:aid( ... )
    if not helper.ok.ply( self ) then return end

    local pl            = self:uid( )
    local args          = { ... }

    table.insert        ( args, pl )

    local resp          = table.concat( args, '_' )
    resp                = resp:lower( )
    resp                = resp:gsub( '[%p%c]', '.' )
    resp                = resp:gsub( '[%s]', '_' )

    return resp
end

/*
*   association id > 64
*
*   makes an id based on the specified ply unique id
*       : special chars     => [ . ]
*       : spaces            => [ _ ]
*
*   @note   : non-ply associated func helper.get.id( ... )
*
*   @ex     : timer_id = pl:aid64( mod.id, 'dc', 'string name id' )
*   @res    : xtask.dc.string_name_id.76561198321000000
*
*   @param  : varg { ... }
*   @return : str
*/

function pmeta:aid64( ... )
    if not helper.ok.ply( self ) then return end

    local pl            = self:sid( )
    local args          = { ... }

    table.insert        ( args, pl )

    local resp          = table.concat( args, '_' )
    resp                = resp:lower( )
    resp                = resp:gsub( '[%p%c]', '.' )
    resp                = resp:gsub( '[%s]', '_' )

    return resp
end

/*
*	rp money > get
*
*   returns current funds of player
*
*   @param  : bool bComma
*/

function pmeta:getmoney( bComma )
    return ( isfunction( self.getDarkRPVar ) and ( bComma and helper.str:comma( self:getDarkRPVar( 'money' ) ) or self:getDarkRPVar( 'money' ) ) ) or 0
end

/*
*	rp money > salary
*
*   returns current salary of player
*
*   @param  : bool bComma
*/

function pmeta:getsalary( bComma )
    return ( isfunction( self.getDarkRPVar ) and ( bComma and helper.str:comma( self:getDarkRPVar( 'salary' ) ) or self:getDarkRPVar( 'salary' ) ) ) or 0
end

/*
*	prestige > get
*
*   returns ply prestige from any addons adding such feature
*/

function pmeta:getprestige( )
    return ( isfunction( self.getDarkRPVar ) and self:getDarkRPVar( 'prestige' ) ) or 0
end

/*
*	stamina > get
*
*   returns pl stamina
*/

function pmeta:getstamina( )
    return ( isfunction( self.getDarkRPVar ) and ( self:getDarkRPVar( 'Stamina' ) or self:getDarkRPVar( 'stamina' ) ) ) or self:GetNWInt( 'tcb_Stamina' ) or self:GetNWFloat( 'stamina', 0 )
end

/*
*	energy > get
*
*   returns pl energy
*/

function pmeta:getenergy( )
    return ( isfunction( self.getDarkRPVar ) and ( math.Round( self:getDarkRPVar( 'Energy' ) ) ) ) or 0
end

/*
*   group > get
*
*   returns the group assigned to the player
*
*   @param  : bool bLower
*   @return : mixed
*/

function pmeta:getgroup( bLower )
    local group = self:GetUserGroup( )
    return not bLower and group or helper.str:clean( group )
end
pmeta.group = pmeta.getgroup

/*
*   scope > CLIENT
*/

if CLIENT then

    /*
    *	inventory > get id
    *
    *	id associated with the inventory system
    *   used with itemstore addon for gmodstore
    *
    *	@return	: int
    */

    function pmeta:getinventory( )
        return self.InventoryID or 0
    end

end

/*
*   inventory > get
*/

function pmeta:getinv( )
    return self:GetNWInt( 'inv_id', 0 )
end

/*
*   inventory > set
*/

function pmeta:setinv( id )
    if not id then id = 0 end
    id = tonumber( id )

    self:SetNWInt( 'inv_id', id )
end

/*
*   get level
*
*   Gets the current level of the player (relies on the DarkRP Leveling addon)
*
*   @support        : default darkrp leveling
*                   : sublime levels
*                   : gmodstore.com/market/view/darkrp-prestige-level-system
*
*   @return	: int
*/

function pmeta:getlevel( )
    return ( self.SL_GetLevel and self:SL_GetLevel( ) ) or ( ( isfunction( self.getDarkRPVar ) and self:getDarkRPVar( 'year' ) ) or self:getDarkRPVar( 'level' ) or self:getDarkRPVar( 'lvl' ) or self:GetNWInt( 'lvl' ) ) or 1
end
pmeta.level = pmeta.getlevel

/*
*   get year
*
*   Gets the current year of the player (relies on the DarkRP Leveling addon, for gamemodes such as
*	hogwartsrp
*
*   @return	: int
*/

function pmeta:getyear( )
    return ( isfunction( self.getDarkRPVar ) and self:getDarkRPVar( 'year' ) ) or ( self:getDarkRPVar( 'yr' ) or self:GetNWInt( 'year' ) ) or 1
end
pmeta.year = pmeta.getyear

/*
*   get data
*
*   returns data associated to the specified ply table
*
*	@param	: str id
*   @return	: mix
*/

function pmeta:getdata( id )
    if not id then return end
    return ( isfunction( self.getDarkRPVar ) and self:getDarkRPVar( id ) ) or ( self:GetNWInt( id ) ) or nil
end

/*
*	get xp
*
*   returns the current role of the player
*
*	@return	: int, str
*/

function pmeta:getxp( )
    return ( isfunction( self.GetXP ) and math.floor( self:GetXP( ) ) or ( isfunction( self.getDarkRPVar ) and self:getDarkRPVar( 'xp' ) ) or self:GetNWInt( 'xp' ) or self:GetNWInt( 'exp' ) ) or 0
end

/*
*   get xp max
*
*   returns the max xp a ply can have for a current level / year
*
*   @return	: int
*/

function pmeta:getxpmax( )
    return ( isfunction( self.getMaxXP ) and ( ( ( 10 + ( ( ( self:getDarkRPVar( 'level' ) or 1 ) * ( ( self:getDarkRPVar( 'level' ) or 1 ) + 1 ) * 90 ) ) ) ) * LevelSystemConfiguration.XPMult ) ) or ( isfunction( self.GetXPMax ) and self:GetXPMax( ) ) or 0
end

/*
*   give xp
*
*   gives the specified player xp
*
*	@param	: int xp
*/

function pmeta:givexp( xp )
    xp = isnumber( xp ) and xp or 0
    if ( isfunction( self.GiveXP ) ) then
        self:GiveXP( xp )
    elseif ( isfunction( self.givexp ) ) then
        self:givexp( xp )
    elseif ( isfunction( self.addXP ) ) then
        self:addXP( xp )
    end
end

/*
*	get job
*
*	returns ply current job
*
*	@ex		: pl:getjob( )
*
*   @return	: tbl
*/

function pmeta:getjob( )
    return isfunction( self.getDarkRPVar ) and self:getDarkRPVar( 'job' ) or 'Unassigned'
end
pmeta.job = pmeta.getjob

/*
*	get job data
*
*	returns the current role of the player
*	if id provided, you can return values related to that particular user role
*
*	@ex		: pl:getjobdata( )
*			: pl:getjobdata( 'command' )
*
*	@param	: str id
*   @return	: tbl
*/

function pmeta:getjobdata( id )
    local team = self:Team( )
    if not RPExtraTeams or not team then
        rlib:log( 6, 'cannot locate role, invalid table RPExtraTeams', debug.traceback( ) )
        return
    end

    if id and RPExtraTeams[ team ] and RPExtraTeams[ team ][ id ] then
        return RPExtraTeams[ team ][ id ]
    end

    return RPExtraTeams[ team ]
end
pmeta.jdata = pmeta.getjobdata

/*
*   distance
*
*   calculates distance between player and target
*
*   @param  : ent targ
*   @return : int
*/

function pmeta:distance( targ )
    if not IsValid( targ ) then return end
    return self:GetPos( ):Distance( targ:GetPos( ) ) or 0
end
pmeta.dist = pmeta.distance

/*
*	scope > SERVER
*/

if SERVER then

    /*
    *	rcc
    *
    *	executes a console command on the specify player
    *
    *   name = false if using gmod concommand, set cmd param
    *   to gmod command
    *
    *   @ref    : Player:ConCommand( )
    *
    *	@ex		: pl:rcc( 'module_cmd_id' )
    *           : pl:rcc( false, 'kill' )
    *
    *   @param  : str cmd
    */

    function pmeta:rcc( name, cmd )
        if not name and not isstring( cmd ) then return false end

        if name then
            cmd = gid( name )
        end

        self:ConCommand( cmd )
    end

end