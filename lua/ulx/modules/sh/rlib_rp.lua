/*
*   @package        : rcore
*   @module         : base
*	@extends		: ulx
*   @author         : Richard [http://steamcommunity.com/profiles/76561198135875727]
*   @copyright      : (c) 2018 - 2020
*   @since          : 1.0.0
*   @website        : https://rlib.io
*   @docs           : https://docs.rlib.io
*
*   MIT License
*
*   THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
*   LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
*   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
*   WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/*
*   standard tables and localization
*/

local base                  = rlib
local helper                = base.h
local access                = base.a

/*
*   module calls
*/

local mod, pf       	    = base.modules:req( 'base' )
local cfg               	= base.modules:cfg( mod )
local smsg                  = base.settings.smsg

/*
*   Localized translation func
*/

local function ln( ... )
    return base:translate( mod, ... )
end

/*
*   get access perm
*
*   @param  : str id
*	@return	: tbl
*/

local function perm( id )
    return access:getperm( id, mod )
end

/*
*   declare perm ids
*/

local id_job_set            = perm( 'rlib_rp_job_set' )
local id_job_set_cmd        = perm( 'rlib_rp_job_set_cmd' )
local id_job_get            = perm( 'rlib_rp_job_get' )
local id_money_set          = perm( 'rlib_rp_money_set' )
local id_money_add          = perm( 'rlib_rp_money_add' )

/*
*   check dependency
*
*   @param  : ply pl
*   @param  : str p
*/

local function checkDependency( pl, p )
    if not base or not base.modules:bInstalled( mod ) then
        p                   = isstring( p ) and helper.ok.str( p ) or istable( p ) and ( p.ulx or p.id ) or 'unknown command'
        local msg           = { smsg.clrs.t2, p, smsg.clrs.msg, '\nAn error has occured with the library. Contact the developer or sys admin.' }
        pl:push             ( msg, 'Critical Error', '' )
        return false
    end
    return true
end

/*
*   check gamemode
*
*   @param  : ply pl
*/

local function checkGamemode( pl, p )
    if not pl.getDarkRPVar and not DarkRP then
        p                   = isstring( p ) and helper.ok.str( p ) or istable( p ) and ( p.ulx or p.id ) or 'unknown command'
        base.msg:route      ( pl, p, 'Are you running', smsg.clrs.t1, 'darkrp', smsg.clrs.msg, '?' )
        return false
    end
    return true
end

/*
*   ulx > options > jobs
*/

ulx.lst_jobs = { }
local function populate_jobs( )
    if not RPExtraTeams then
        table.insert( ulx.lst_jobs, 'Not running RP gamemode' )
        return
    end
    for i, v in pairs( RPExtraTeams ) do
        table.insert( ulx.lst_jobs, v.command )
    end
end
rhook.new.rlib( 'rlib_initialize_post', 'rlib_ulx_jobs_populate', populate_jobs )

/*
*   ulx > rp > job > get
*
*	forces a player to a specified rp job based on the job command defined
*
*   this is an alternative to darkrp_setjob since that command relies on the name which can
*   cause complications of multiple jobs contain similar names. whereas this method ensures the
*   correct job is found
*
*   @param	: ply call_pl
*   @param  : ply targ_pl
*   @param  : str job
*/

function ulx.rlib_rp_job_get( call_pl, targ_pl, job )
    if not checkDependency( call_pl, id_job_get ) then return end
    if not checkGamemode( call_pl, id_job_get ) then return end

    if not RPExtraTeams then
        base.msg:route( call_pl, id_job_get.name, 'RP jobs table missing -- are you running darkrp?' )
        return
    end

    base.msg:route( call_pl, id_job_get.name, 'player:', smsg.clrs.t1, targ_pl:palias( ), smsg.clrs.msg, 'job id:', smsg.clrs.t1, tostring( targ_pl:Team( ) ), smsg.clrs.msg, 'job name:', smsg.clrs.t1, tostring( team.GetName( targ_pl:Team( ) ) ) )
end
local rlib_rp_job_get                   = ulx.command( id_job_get.category, id_job_get.ulx_id, ulx.rlib_rp_job_get, id_job_get.pubcmds )
rlib_rp_job_get:addParam                { type = ULib.cmds.PlayerArg }
rlib_rp_job_get:defaultAccess           ( access:ulx( id_job_get ) )
rlib_rp_job_get:help                    ( id_job_get.desc )

/*
*   ulx > rp > job > set
*
*	forces a player to a specified rp job based on the job command defined
*
*   this is an alternative to darkrp_setjob since that command relies on the name which can
*   cause complications of multiple jobs contain similar names. whereas this method ensures the
*   correct job is found
*
*   @param	: ply call_pl
*   @param  : ply targ_pl
*   @param  : str job
*/

function ulx.rlib_rp_job_set( call_pl, targ_pl, job )
    if not checkDependency( call_pl, id_job_set ) then return end
    if not checkGamemode( call_pl, id_job_set ) then return end

    if not RPExtraTeams then
        base.msg:route( call_pl, id_job_set.name, 'RP jobs table missing -- are you running darkrp?' )
        return
    end

    local job_c, job_res = helper.who:rpjob_custom( job )
    if not job_c or job_c == 0 then
        base.msg:route( call_pl, id_job_set.name, 'Specified job with command does not exist' )
        return
    end

    local job_new = job_res[ 0 ]

    local n_num, n_job = nil, nil
    for i, v in pairs( RPExtraTeams ) do
        if v.command:lower( ) == job_new.command:lower( ) then
            n_num = i
            n_job = v
        end
    end

    targ_pl:updateJob           ( n_job.name    )
    targ_pl:setSelfDarkRPVar    ( 'salary', n_job.salary )
    targ_pl:SetTeam             ( n_num         )

    GAMEMODE:PlayerSetModel     ( targ_pl       )
    GAMEMODE:PlayerLoadout      ( targ_pl       )

    base.msg:route( call_pl, id_job_set.name, 'Forced player', smsg.clrs.t1, targ_pl:palias( ), smsg.clrs.msg, 'to job', smsg.clrs.t1, n_job.name )
    base.msg:route( targ_pl, id_job_set.name, 'You have been forced to job', smsg.clrs.t1, n_job.name )

end
local rlib_rp_job_set                   = ulx.command( id_job_set.category, id_job_set.ulx_id, ulx.rlib_rp_job_set, id_job_set.pubcmds )
rlib_rp_job_set:addParam                { type = ULib.cmds.PlayerArg }
rlib_rp_job_set:addParam                { type = ULib.cmds.StringArg, completes = ulx.lst_jobs, hint = 'select job...', error = 'invalid option \'%s\' specified', ULib.cmds.restrictToCompletes }
rlib_rp_job_set:defaultAccess           ( access:ulx( id_job_set ) )
rlib_rp_job_set:help                    ( id_job_set.desc )

/*
*   ulx > rp > set job ( command )
*
*	forces a player to a specified rp job based on the job command defined
*
*   this is an alternative to darkrp_setjob since that command relies on the name which can
*   cause complications of multiple jobs contain similar names. whereas this method ensures the
*   correct job is found
*
*   @param	: ply call_pl
*   @param  : ply targ_pl
*   @param  : str job
*/

function ulx.rlib_rp_job_set_cmd( call_pl, targ_pl, job )
    if not checkDependency( call_pl, id_job_set_cmd ) then return end
    if not checkGamemode( call_pl, id_job_set_cmd ) then return end

    if not RPExtraTeams then
        base.msg:route( call_pl, id_job_set_cmd.name, 'RP jobs table missing -- are you running darkrp?' )
        return
    end

    local job_c, job_res = helper.who:rpjob_custom( job )
    if not job_c or job_c == 0 then
        base.msg:route( call_pl, id_job_set_cmd.name, 'Specified job with command does not exist' )
        return
    end

    local job_new = job_res[ 0 ]

    local n_num, n_job = nil, nil
    for i, v in pairs( RPExtraTeams ) do
        if v.command:lower( ) == job_new.command:lower( ) then
            n_num = i
            n_job = v
        end
    end

    targ_pl:updateJob           ( n_job.name    )
    targ_pl:setSelfDarkRPVar    ( 'salary', n_job.salary )
    targ_pl:SetTeam             ( n_num         )

    GAMEMODE:PlayerSetModel     ( targ_pl       )
    GAMEMODE:PlayerLoadout      ( targ_pl       )

    base.msg:route( call_pl, id_job_set_cmd.name, 'Forced player', smsg.clrs.t1, targ_pl:palias( ), smsg.clrs.msg, 'to job', smsg.clrs.t1, n_job.name )
    base.msg:route( targ_pl, id_job_set_cmd.name, 'You have been forced to job', smsg.clrs.t1, n_job.name )
end
local rlib_rp_job_set_cmd               = ulx.command( id_job_set_cmd.category, id_job_set_cmd.ulx_id, ulx.rlib_rp_job_set_cmd, id_job_set_cmd.pubcmds )
rlib_rp_job_set_cmd:addParam            { type = ULib.cmds.PlayerArg }
rlib_rp_job_set_cmd:addParam            { type = ULib.cmds.StringArg, hint = 'job cmd', ULib.cmds.takeRestOfLine }
rlib_rp_job_set_cmd:defaultAccess       ( access:ulx( id_job_set_cmd ) )
rlib_rp_job_set_cmd:help                ( id_job_set_cmd.desc )

/*
*   ulx > rp > money > add
*
*	adds money to a players wallet
*
*   @param	: ply call_pl
*   @param  : ply targ_pl
*   @param  : int amt
*/

function ulx.rlib_rp_money_add( call_pl, targ_pl, amt )
    if not checkDependency( call_pl, id_money_add ) then return end
    if not checkGamemode( call_pl, id_money_add ) then return end

    local total             = targ_pl:getDarkRPVar( 'money' ) + math.floor( amt )
    total                   = hook.Call( 'playerWalletChanged', GAMEMODE, targ_pl, amt, targ_pl:getDarkRPVar( 'money' ) ) or total
    targ_pl:setDarkRPVar    ( 'money', total )

    if targ_pl.DarkRPUnInitialized then return end

    DarkRP.storeMoney       ( targ_pl, total )

    local i_amt             = string.format( '%s%i', GAMEMODE.Config.currency, amt )

    base.msg:route( call_pl, id_money_add.name, 'Gave', smsg.clrs.t1, i_amt, smsg.clrs.msg, 'to player', smsg.clrs.t1, targ_pl:palias( ) )
    base.msg:route( targ_pl, id_money_add.name, 'You were given', smsg.clrs.t1, i_amt )
end
local rlib_rp_money_add                 = ulx.command( id_money_add.category, id_money_add.ulx_id, ulx.rlib_rp_money_add, id_money_add.pubcmds )
rlib_rp_money_add:addParam              { type = ULib.cmds.PlayerArg }
rlib_rp_money_add:addParam              { type = ULib.cmds.NumArg, hint = 'money' }
rlib_rp_money_add:defaultAccess         ( access:ulx( id_money_add ) )
rlib_rp_money_add:help                  ( id_money_add.desc )

/*
*   ulx > rp > money > set
*
*	sets a players rp wallet sum
*
*   @param	: ply call_pl
*   @param  : ply targ_pl
*   @param  : int amt
*/

function ulx.rlib_rp_money_set( call_pl, targ_pl, amt )
    if not checkDependency( call_pl, id_money_set ) then return end
    if not checkGamemode( call_pl, id_money_set ) then return end

    if not targ_pl.getDarkRPVar then
        base.msg:route( targ_pl, id_money_set.name, 'Are you running', smsg.clrs.t1, 'darkrp', smsg.clrs.msg, '?' )
        return
    end

    local total             = math.floor( amt )
    total                   = hook.Call( 'playerWalletChanged', GAMEMODE, targ_pl, amt, targ_pl:getDarkRPVar( 'money' ) ) or total
    targ_pl:setDarkRPVar    ( 'money', total )

    if targ_pl.DarkRPUnInitialized then return end

    DarkRP.storeMoney       ( targ_pl, total )

    local i_amt             = string.format( '%s%i', GAMEMODE.Config.currency, total )

    base.msg:route( call_pl, id_money_set.name, 'Set money for player', smsg.clrs.t1, targ_pl:palias( ), smsg.clrs.msg, 'to', smsg.clrs.t1, i_amt )
    base.msg:route( targ_pl, id_money_set.name, 'Your money has been set to', smsg.clrs.t1, i_amt )
end
local rlib_rp_money_set                 = ulx.command( id_money_set.category, id_money_set.ulx_id, ulx.rlib_rp_money_set, id_money_set.pubcmds )
rlib_rp_money_set:addParam              { type = ULib.cmds.PlayerArg }
rlib_rp_money_set:addParam              { type = ULib.cmds.NumArg, hint = 'money' }
rlib_rp_money_set:defaultAccess         ( access:ulx( id_money_set ) )
rlib_rp_money_set:help                  ( id_money_set.desc )