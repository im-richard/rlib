/*
    @library        : rlib
    @package        : rcc
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
local access                = base.a
local storage               = base.s

/*
    library > localize
*/

local mf                    = base.manifest

/*
    lua > localize
*/

local sf                    = string.format

/*
*   rcc > rp_setjob
*
*   forces a player to a specific job
*   requires darkrp
*/

local function rcc_rp_setjob( admin, cmd, args )

    /*
    *   perms
    */

    if not access:bIsRoot( admin ) then return end

    /*
    *   rcc id
    */

    local rcc_id = 'rp_setjob'

    /*
    *	check > rp gamemode
    */

    if not RPExtraTeams then
        base.msg:route( admin, rcc_id, 'Not a supported gamemode. Requires a darkrp derived.' )
        return ''
    end

    /*
    *	declare > arg > player
    */

    local _user = args[ 1 ] and args[ 1 ]:lower( )
    if not _user then
        base.msg:route( admin, rcc_id, 'Invalid player specified' )
        return ''
    end

    /*
    *	check > arg > job > empty
    */

    if _user:len( ) < 2 then
        base.msg:route( admin, rcc_id, 'player name must be at least two characters' )
        return ''
    end

    /*
    *	find player result
    */

    local i_user, user = helper.who:name_wc( _user )

    /*
    *	no results found
    */

    if i_user < 1 then
        base.msg:route( admin, rcc_id, 'No player found' )
        return ''
    end

    /*
    *	more than one user found
    */

    if i_user > 1 then
        base.msg:route( admin, rcc_id, 'More than one player found, please provide a full name' )
        return ''
    end

    /*
    *	extra check for invalid player user
    */

    if not helper.ok.ply( user[ 0 ] ) then
        base.msg:route( admin, rcc_id, 'Could not locate a valid player with the name, please try again' )
        return ''
    end

    /*
    *	declare > arg > player
    */

    user = user[ 0 ]

    /*
    *	declare > arg > job
    */

    local job = args and args[ 2 ] and args[ 2 ]:lower( )

    /*
    *	check > arg > job > empty
    */

    if not job then
        base.msg:route( admin, rcc_id, 'No job specified' )
        return ''
    end

    /*
    *	check > arg > job > empty
    */

    if job:len( ) < 2 then
        base.msg:route( admin, rcc_id, 'job must be at least two characters' )
        return ''
    end

    /*
    *	check > arg > job > no exist
    */

    local job_c, job_res    = helper.who:rpjob_custom( job )
    if not job_c or job_c == 0 then
        base.msg:route( admin, rcc_id, 'Specified job with command does not exist' )
        return
    end

    /*
    *	declare > arg > job
    */

    local job_new = job_res[ 0 ]

    local n_num, n_job = nil, nil
    for i, v in pairs( RPExtraTeams ) do
        if v.command:lower( ) == job_new.command:lower( ) then
            n_num = i
            n_job = v
        end
    end

    /*
    *	execute action
    */

    if n_job and n_num then
        local admin_name            = access:bIsConsole( admin ) and 'CONSOLE' or admin:palias( )
        local resp                  = sf( '%s switched %s to %s', admin_name  or 'a', user:palias( ), n_job.name )
                                    hook.Run( 'asay.broadcast', rcc_id, resp )

        user:updateJob              ( n_job.name                )
        user:setSelfDarkRPVar       ( 'salary', n_job.salary    )
        user:SetTeam                ( n_num                     )

        GAMEMODE:PlayerSetModel     ( user                      )
        GAMEMODE:PlayerLoadout      ( user                      )
    end

end
rcc.new.gmod( 'rlib_setjob', rcc_rp_setjob )

/*
*   rcc > rp_getjob
*
*   returns player current job
*   requires darkrp
*/

local function rcc_rp_getjob( admin, cmd, args )

    /*
    *   perms
    */

    if not access:bIsRoot( admin ) then return end

    /*
    *   rcc id
    */

    local rcc_id = 'rp_setjob'

    /*
    *	check > rp gamemode
    */

    if not RPExtraTeams then
        base.msg:route( admin, rcc_id, 'Not a supported gamemode. Requires a darkrp derived.' )
        return ''
    end

    /*
    *	declare > arg > player
    */

    local _user = args[ 1 ] and args[ 1 ]:lower( )
    if not _user then
        base.msg:route( admin, rcc_id, 'Invalid player specified' )
        return ''
    end

    /*
    *	check > arg > job > empty
    */

    if _user:len( ) < 2 then
        base.msg:route( admin, rcc_id, 'player name must be at least two characters' )
        return ''
    end

    /*
    *	find player result
    */

    local i_user, user = helper.who:name_wc( _user )

    /*
    *	no results found
    */

    if i_user < 1 then
        base.msg:route( admin, rcc_id, 'No player found' )
        return ''
    end

    /*
    *	more than one user found
    */

    if i_user > 1 then
        base.msg:route( admin, rcc_id, 'More than one player found, please provide a full name' )
        return ''
    end

    /*
    *	extra check for invalid player user
    */

    if not helper.ok.ply( user[ 0 ] ) then
        base.msg:route( admin, rcc_id, 'Could not locate a valid player with the name, please try again' )
        return ''
    end

    /*
    *	declare > arg > player
    */

    user = user[ 0 ]

    /*
    *	execute action
    */

    base.msg:route( admin, rcc_id, sf( '[PLAYER] %s [JOB] %s', user:palias( ), user:getjob( ) ) )

end
rcc.new.gmod( 'rlib_getjob', rcc_rp_getjob )