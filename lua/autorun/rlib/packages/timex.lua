/*
    @library        : rlib
    @package        : timex
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

/*
    library > localize
*/

local mf                    = base.manifest
local pf                    = mf.prefix
local script                = mf.name

/*
*   module declarations
*/

local dcat                  = 9

/*
    lua > localize
*/

local sf                    = string.format
local floor                 = math.floor

/*
    languages
*/

local function ln( ... )
    return base:lang( ... )
end

/*
    localize output functions
*/

local function con( ... ) base:console( ... ) end
local function log( ... ) base:log( ... ) end

/*
    call id > get

    @source : lua\autorun\libs\_calls
    @param  : str id
*/

local function g_CallID( id )
    return base:call( 'timers', id )
end

/*
    prefix > create id
*/

local function cid( id, suffix )
    local affix     = istable( suffix ) and suffix.id or isstring( suffix ) and suffix or mf.prefix
    affix           = affix:sub( -1 ) ~= '.' and sf( '%s.', affix ) or affix

    id              = isstring( id ) and id or 'noname'
    id              = id:gsub( '[%p%c%s]', '.' )

    return sf( '%s%s', affix, id )
end

/*
    prefix > get id
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and mf.prefix ) or false
    return cid( str, state )
end

/*
    define module
*/

module( 'timex', package.seeall )

/*
*   local declarations
*/

local pkg                   = timex
local pkg_name              = _NAME or 'timex'

/*
*   pkg declarations
*/

local manifest =
{
    author                  = 'richard',
    desc                    = 'timer registration and management tool',
    build                   = 042120,
    version                 = { 2, 3, 0 },
}

/*
*   required tables
*/

settings                    = settings  or { }
sys                         = sys       or { }
secs                        = secs      or { }
ts                          = ts        or { }
when                        = when      or { }
bw                          = bw        or { }

/*
*	pf > getid
*/

local function gid( id )
    id = isstring( id ) and id or tostring( id )
    if not isstring( id ) then
        local trcback = debug.traceback( )
        log( dcat, '[ %s ] :: invalid id\n%s', pkg_name, tostring( trcback ) )
        return
    end

    id = g_CallID( id )

    return id
end

/*
    rcc id

    creates rcc command with package name appended to the front
    of the string.

    @param  : str str
*/

function g_PackageId( str )
    str         = isstring( str ) and str ~= '' and str or false
                if not str then return pkg_name end

    return pid( str, pkg_name )
end

/*
    directory

    :   exists
    :   expire
    :   pause
    :   paused
    :   adjust
    :   resume
    :   remains
    :   reps
    :   only
    :   create
    :   unique
    :   simple
    :   source
    :   list
    :   count
    :   cleantime
    :   when.midnight
    :   when.mins
    :   when.mins_sv
    :   midnight_until
    :   midnight_human
    :   midnight_human_cl
    :   secs.curtime
    :   secs.ctime
    :   secs.duration
    :   secs.merged
    :   secs.sh_simple
    :   secs.sh_simple_nz
    :   secs.sh_hms
    :   secs.sh_secsonly
    :   secs.sh_uhour
    :   secs.sh_cols
    :   secs.sh_cols_steps
    :   secs.ms
    :   secs.benchmark
    :   secs.ago
    :   secs.sh_cols_steps_nz
    :   ts.pastdays
    :   ts.remains
    :   ts.remains_sv
    :   ts.past
    :   ts.past_sv
    :   ts.pasthours
    :   ts.pasthours_d
    :   bw.structtime
    :   bw.playtime
*/

/*
*   timex > exists
*
*   checks to see if a timer exists
*
*   @param  : str id
*   @return : bool
*/

function exists( id )
    id = gid( id )
    return isstring( id ) and timer.Exists( id ) and true or false
end
valid = exists

/*
*   timex > expire
*
*   destroys a timer if it exists
*
*   @param  : str id
*/

function expire( id )
    local bExists   = exists( id )
    id              = gid( id )

    if isstring( id ) and bExists then
        timer.Remove( id )
    end
end
kill        = expire
destroy     = expire

/*
*   timex > pause
*
*   pauses a timer if it exists
*
*   @param  : str id
*/

function pause( id )
    local bExists   = exists( id )
    id              = gid( id )

    if isstring( id ) and bExists then
        timer.Pause( id )
    end
end
stop = pause

/*
*   timex > check paused
*
*   check if timer is currently paused.
*   by default, paused timers return negative values.
*   may not be the most technical way, but works
*
*   @param  : str id
*/

function paused( id )
    id = gid( id )
    if not exists( id ) then return false end

    local remains = timex.remains( id )
    if remains < 0 then return true end

    return false
end

/*
*   timex > adjust
*
*   modifies a timer
*
*   @param  : str id
*   @param  : int delay
*   @param  : int reps
*   @param  : func fn
*/

function adjust( id, delay, reps, fn )
    local bExists   = exists( id )
    id              = gid( id )

    if not bExists then return end
    if not isnumber( delay ) then return end
    timer.Adjust( id, delay, reps, fn )
end

/*
*   timex > resume
*
*   continues a timer where it left off
*
*   @param  : str id
*/

function resume( id )
    local bExists   = exists( id )
    id              = gid( id )

    if not isstring( id ) or not bExists then return end
    timer.UnPause( id )
end
start = resume

/*
*   timex > remains
*
*   returns the time in seconds remaining on an existing timer
*
*   @param  : str id
*   @param  : bool b
*   @return : int
*/

function remains( id, b )
    local bExists   = exists( id )
    id              = gid( id )

    return bExists and math.Round( timer.TimeLeft( id ) ) or ( b and 0 ) or false
end
left = remains

/*
*   timex > reps
*
*   returns the number of reps left on a timer
*
*   @param  : str id
*   @return : int
*/

function reps( id )
    local bExists   = exists( id )
    id              = gid( id )

    return bExists and math.Round( timer.RepsLeft( id ) ) or 0
end
life = reps

/*
*   timex > only
*
*   creates a timer. will force the timer to first expire if
*   one already exists with that same id
*
*   @param  : str id
*   @param  : int delay
*   @param  : int rep
*   @param  : func fn
*/

function only( id, delay, rep, fn )
    id          = gid( id )
    delay       = delay or 0.1
    rep         = rep or 1

    expire( id )

    if not fn or not base:isfunc( fn ) then
        log( RLIB_LOG_DEBUG, '[ %s ] :: timer created with no func', pkg_name )
        fn = function( ) end
    end

    timer.Create( id, delay, rep, fn )
end

/*
*   timex > create
*
*   create a detailed timer
*
*   @todo   : add timer logging
*
*   @param  : str id
*   @param  : int delay
*   @param  : int repscnt
*   @param  : func fn
*/

function create( id, delay, repscnt, fn )
    id          = gid( id )
    delay       = delay or 0.1
    repscnt     = repscnt or 1

    if not isfunction( fn ) then
        log( 1, '[ %s ] :: timer created with no func', pkg_name )
        fn = function( ) end
    end

    timer.Create( id, delay, repscnt, fn )
end
new = create

/*
*   timex > unique
*
*   create a detailed timer only if it currently doesnt exist
*
*   @param  : str id
*   @param  : int delay
*   @param  : int repscnt
*   @param  : func fn
*/

function unique( id, delay, repscnt, fn )
    local bExists   = exists( id )
    id              = gid( id )
    delay           = delay or 0.1
    repscnt         = repscnt or 1

    if bExists then return end

    if not isfunction( fn ) then
        log( 1, '[ %s ] :: unique timer created with no func', pkg_name )
        fn = function( ) end
    end

    timer.Create( id, delay, repscnt, fn )
end
uni = unique

/*
*   timex > simple
*
*   create a simple timer.
*   args a, b can be mixed to include or exclude a string id ( used for the lib calls function )
*
*   @usage  : timex.simple( pf .. 'action_name', 5, function( ) end )
*   @usage  : timex.simple( 5, function( ) end )
*
*   @todo   : add timer logging for c_id
*   @param  : str, int a
*   @param  : int b
*   @param  : func fn
*/

function simple( a, b, fn )
    local id        = isstring( a ) and a or nil
    local delay     = isnumber( b ) and b or isnumber( a ) and a or 0.1
    local func      = isfunction( fn ) and fn or isfunction( b ) and b or nil

    if not isfunction( func ) then
        log( 6, '[%s] :: simple timer created with no func', pkg_name )
        func = function( ) end
    end

    timer.Simple( delay, func )
end

/*
*   rnet > source
*
*   returns source tbl for timers
*
*   @return : tbl
*/

function source( )
    return base.calls:get( 'timers' ) or { }
end

/*
*   timex > list
*
*   returns a list of registered timers that are active for a complete list of both active and non, use
*   the concommand rlib.calls
*
*   @param  : bool bActiveOnly
*   @return : tbl, int
*/

function list( bActiveOnly )
    local t         = source( )
    local item      = { }
    local cnt       = 0
    for k, v in pairs( t ) do
        local id    = ( isstring( v[ 1 ] ) and v[ 1 ] ) or ( isstring( v.id ) and v.id )
        local desc  = ( isstring( v[ 2 ] ) and v[ 2 ] ) or ( isstring( v.desc ) and v.desc )

        if bActiveOnly and not exists( id ) then continue end

        item[ k ]               = { }
        item[ k ].id            = id
        item[ k ].desc          = desc
        item[ k ].remains       = remains( id )
        item[ k ].reps          = reps( id )
        item[ k ].bActive       = exists( id ) and 'yes' or 'no'

        cnt = cnt + 1
    end

    return item, cnt
end

/*
*   timex > count
*
*   returns total number of timers
*
*   @param  : bool bActiveOnly
*   @return : int
*/

function count( bActiveOnly )
    local t         = source( )
    local cnt       = 0
    for k, v in pairs( t ) do
        local id    = ( isstring( v[ 1 ] ) and v[ 1 ] ) or ( isstring( v.id ) and v.id )
        if bActiveOnly and not exists( id ) then continue end

        cnt = cnt + 1
    end

    return cnt
end

/*
*   clean time
*
*   strips zeros out of the front of times displayed
*
*   @ex     : timex.cleantime( os.date( '%I:%M %p' ) )
*           :   06:50 am changes to 6:50 am
*
*   @param  : str str
*   @return : str
*/

function cleantime( str )
    while true do
        if str:sub( 1, 1 ) == '0' then
            str = str:sub( 2 )
        else
            break
        end
    end
    return str
end

/*
*   midnight
*
*   @ex     : timex.midnight( 1 )
*/

function midnight( days )
    return os.time( ) - tonumber( os.date( '%H' ) ) * 3600 - tonumber( os.date( '%M' ) ) * 60 - tonumber( os.date( '%S' ) ) + 86400 * ( days or 1 )
end
when.midnight = midnight

/*
*   when > mins
*
*   returns the timestamp based on x number of minutes in the future
*
*   timex.when.mins( 5 )
*       >   returns time now + 5 minutes in the future
*
*   @ex     : timex.when.mins( 5 )
*/

function when.mins( min )
    mins        = mins or 1
    local prev  = os.time( ) - ( os.time( ) % ( mins * 60 ) )

    return prev + ( mins * 60 )
end

/*
*   when > mins > server
*
*   returns the timestamp based on x number of minutes in the future
*
*   @note   : This function returns utilizes SERVER TIME; not client.
*
*   timex.when.mins( 5 )
*       >   returns time now + 5 minutes in the future
*
*   @ex     : timex.when.mins( 5 )
*/

function when.mins_sv( min )
    mins                = mins or 1
    local sv_ost        = ( rlib.sys.time ) or 0
    local prev          = sv_ost - ( sv_ost % ( mins * 60 ) )

    return prev + ( mins * 60 )
end

/*
*   midnight > until
*
*   returns human readable structured time
*
*   @ex     : timex.midnight_until( 1 )
*/

function midnight_until( days )
    days                    = isnumber( days ) and days or 0
    local daily_time        = timex.midnight( days )
    local s_until           = timex.ts.remains( daily_time )

    return s_until
end

/*
*   midnight > human
*
*   returns human readable structured time
*
*   @ex     : timex.midnight( 1 )
*               >  04:07:20     ( 4 hours, 7 minutes until server midnight )
*/

function midnight_human( days, bSecs )
    days                    = isnumber( days ) and days or 0
    bSecs                   = helper:val2bool( bSecs )

    local daily_time        = timex.midnight( days )
    local ts_until          = timex.ts.remains( daily_time )
    local ts_human          = timex.secs.sh_hms( ts_until, bSecs )

    return ts_human
end

/*
*   midnight > human > client
*
*   returns human readable structured time
*
*   @ex     : timex.midnight( 1 )
*               >  04:07:20     ( 4 hours, 7 minutes until server midnight )
*/

function midnight_human_cl( days, bSecs )
    days                    = isnumber( days ) and days or 0
    bSecs                   = helper:val2bool( bSecs )

    local daily_time        = rlib.sys.midnight
    local ts_until          = timex.ts.remains_sv( daily_time )
    local ts_human          = timex.secs.sh_hms( ts_until, bSecs )

    return ts_human
end

/*
*   seconds > curtime
*
*   compares stored curtime to current and returns time remaining
*
*   @param  : str str
*   @return : str
*/

function secs.curtime( num )
    local  time = ( num and calc.min( 0, num - CurTime( ) ) ) or CurTime( )
    return math.Round( time, 0 ) or 0
end

/*
*   seconds > ctime
*
*   similar to timex.curtime but returns a string with the seconds appended
*
*   @param  : str str
*   @param  : bool bShort
*   @return : str
*/

function secs.ctime( num, bShort )
    local time  = ( num and calc.min( 0, num - CurTime( ) ) ) or CurTime( )
    time        = math.Round( time )
    if bShort then
        return string.format( '%is', time )
    else
        local s = tonumber( time ) == 1 and 'second' or 'seconds'
        return string.format( '%i %s', time, s )
    end
end

/*
*   seconds > duration
*
*   converts seconds to a human readable format with various different parameters so you can decide
*   on what you want to see.
*
*   @ex     :   timex.secs.duration( 30 )
*   @out    :   20 seconds
*
*   @param  : int i
*   @param  : bool bSLabel
*   @return : str
*/

function secs.duration( i, bSLabel )
    local str = ''

    i = tonumber( i ) or 0
    if i < 0 then i = 0 end
    i = math.Round( i )

    local days      = floor( ( i - i % 86400 ) / 86400 )
    local hours     = floor( ( i - i % 3600 ) / 3600 )
    local minutes   = floor( ( i - i % 60 ) / 60 )
    local seconds   = i

    if hours >= 24 then
        local affix = ( not bSLabel and ( days == 1 and 'day' or 'days' ) or 'd' ) or ''
        return days .. ' ' .. affix
    end

    if minutes >= 60 then
        local affix = ( not bSLabel and ( hours == 1 and 'hour' or 'hours' ) or 'h' ) or ''
        return hours .. ' ' .. affix
    end

    if seconds >= 60 then
        local affix = ( not bSLabel and ( minutes == 1 and 'minute' or 'minutes' ) or 'm' ) or ''
        return minutes .. ' ' .. affix
    end

    if seconds < 60 then
        local affix = ( not bSLabel and ( seconds == 1 and 'second' or 'seconds' ) or 's' ) or ''
        return seconds .. ' ' .. affix
    end

    return str
end

/*
*   seconds > merged
*
*   displays a human readable format from seconds which simply displays HH:MM:SS
*   does not support days
*
*   @ex     :   timex.secs.merged( 90 )
*   @out    :   1:30
*               m : s
*
*   @param  : int i
*   @return : str
*/

function secs.merged( i )
    local str = ''

    i = i and tonumber( i ) or 0

    local hours     = ( i - i % 3600 ) / 3600
    i               = i - hours * 3600

    local mins      = ( i - i % 60 ) / 60
    i               = i - mins * 60

    local sec       = sf( '%02d', i )

    if sec ~= 0 then
        str = sec
    end

    if mins ~= 0 then
        if sec == 0 then
            str = mins .. '' .. str
        else
            str = mins .. ':' .. str
        end
    end

    if hours ~= 0 then
        str = hours .. ':' .. str
    end

    return str
end

/*
*   seconds > shorthand > simple
*
*   calculates how many seconds are within the current timeframe.
*   with how the time is formatted, it the time exceeds a type, it will progress to the next one up
*
*   does not support hours or days, so only use it for clocks that need 60 minutes and less.
*
*   @ex     :   60      01:00
*                       displays as 1 min : 00 sec
*
*   @ex     :   3500    58:20
*                       displays as 58 min : 20 sec
*
*   @param  : int i
*   @return : str
*/

function secs.sh_simple( i )
    i = i and tonumber( i ) or 0
    i = math.Round( i )

    local min, sec = 0

    if i <= 0 then
        return '00:00'
    else
        min     = sf( '%02.f', floor( i / 60 ) )
        sec     = sf( '%02.f', floor( i - min * 60 ) )

        return min .. ':' .. sec
    end
end

/*
*   seconds > shorthand > simple ( non leading zeros )
*
*   calculates how many seconds are within the current timeframe.
*   with how the time is formatted, it the time exceeds a type, it will progress to the next one up
*
*   does not support hours or days, so only use it for clocks that need 60 minutes and less.
*
*   @ex     :   60      1:00
*                       displays as 1 min : 00 sec
*
*   @ex     :   3500    58:20
*                       displays as 58 min : 20 sec
*
*   @param  : int i
*   @return : str
*/

function secs.sh_simple_nz( i )
    i = i and tonumber( i ) or 0
    i = math.Round( i )

    local min, sec = 0

    if i <= 0 then
        return '00:00'
    else
        min     = sf( '%2.f', floor( i / 60 ) )
        sec     = sf( '%02.f', floor( i - min * 60 ) )

        return min .. ':' .. sec
    end
end

/*
*   seconds > shorthand > simple
*
*   calculates how many seconds are within the current timeframe.
*   with how the time is formatted, it the time exceeds a type, it will progress to the next one up
*
*   does not support hours or days, so only use it for clocks that need 60 minutes and less.
*
*   @ex     :   60      01:00
*                       displays as 1 min : 00 sec
*
*   @ex     :   3500    58:20
*                       displays as 58 min : 20 sec
*
*   @param  : int i
*   @return : str
*/

function secs.sh_hms( i, bSecs )
    i = i and tonumber( i ) or 0
    i = math.Round( i )

    local hour, min, sec = 0

    if i <= 0 then
        return '00:00:00'
    else
        hour	= sf( '%02.f', floor( i / 3600 ) )
        min	    = sf( '%02.f', floor( i / 60 - ( hour * 60 ) ) )
        sec	    = sf( '%02.f', floor( i - hour * 3600 - min * 60 ) )

        if bSecs then
            return hour .. ':' .. min .. ':' .. sec
        else
            return hour .. ':' .. min
        end
    end
end

/*
*   seconds > shorthand > seconds only
*
*   @ex     :   timex.secs.sh_secsonly( 300 )
*   @out    :   300
*               s
*
*   @param  : int i
*   @return : str
*/

function secs.sh_secsonly( i )
    i = i and tonumber( i ) or 0

    if i <= 0 then
        return 0
    else
        return i
    end
end

/*
*   seconds > shorthand > under hour
*
*   does not support hours or days, so only use it for clocks that need 60 minutes and less.
*
*   @ex     :   timex.secs.sh_uhour( 120, true )
*   @out    :   00:02:00
*               h : m : s
*
*   @ex     :   timex.secs.sh_uhour( 120 )
*   @out    :   00:02
*               h : m
*
*   @param  : int i
*   @param  : bool bSecs
*   @return : str
*/

function secs.sh_uhour( i, bSecs )
    i = i and tonumber( i ) or 0

    local min, sec, hour = 0

    if i <= 0 then
        return '00:00'
    else
        hour	= sf( '%02.f', floor( i / 3600 ) )
        min	    = sf( '%02.f', floor( i / 60 - ( hour * 60 ) ) )
        sec	    = sf( '%02.f', floor( i - hour * 3600 - min * 60 ) )

        if bSecs then
            return hour .. ':' .. min .. ':' .. sec
        else
            return hour .. ':' .. min
        end
    end
end

/*
*   seconds > shorthand > columnized
*
*   format seconds to short-hand readable format
*
*   @ex     :   timex.secs.sh_uhour( 175 )
*   @out    :   00w 00d 00h 02m 55s
*               w : d : h : m : s
*
*   @param  : int i
*   @param  : bool bSecs
*   @return : str
*/

function secs.sh_cols( i, bSecs )
    i = i and tonumber( i )

    local tmp   = i
    local s     = tmp % 60
    tmp         = floor( tmp / 60 )
    local m     = tmp % 60
    tmp         = floor( tmp / 60 )
    local h     = tmp % 24
    tmp         = floor( tmp / 24 )
    local d     = tmp % 7
    local w     = floor( tmp / 7 )

    return bSecs and sf( '%02iw %02id %02ih %02im %02is', w, d, h, m, s ) or sf( '%02iw %02id %02ih %02im', w, d, h, m )
end

/*
*   seconds > shorthand > columnized > steps
*
*   converts seconds to a human readable format with various different parameters so you can decide
*   on what you want to see.
*
*   time displays in steps based on the higher type
*   does not display seconds until the final 60 seconds
*
*   @ex     :   timex.secs.sh_cols_steps( 175 )
*   @out    :   02m
*               m
*
*   @ex     :   timex.secs.sh_cols_steps( 32 )
*   @out    :   32s
*               s
*
*   :   ( bool ) bShowEmpty
*       will show all segments even if they are at 00.
*
*   :   ( bool ) bSeconds
*       displays the seconds value on the end
*
*   @param  : int i
*   @param  : bool bShowEmpty
*   @param  : bool bSeconds
*   @return : str
*/

function secs.sh_cols_steps( i, bShowEmpty, bSeconds )
    local str = ''
    local set_format = '%02.f'

    i = tonumber( i ) or 0
    if i < 0 then i = 0 end
    i = math.Round( i )

    local bBelowMin = i < 60 and true or false

    local days      = sf( set_format, floor( ( i - i % 86400 ) / 86400 ) )
    i               = i - days * 86400

    local hours     = sf( set_format, floor( ( i - i % 3600 ) / 3600 ) )
    i               = i - hours * 3600

    local minutes   = sf( set_format, floor( ( i - i % 60 ) / 60 ) )
    i               = i - minutes * 60

    local seconds   = sf( '%02d', i )

    if ( bBelowMin and ( ( not bShowEmpty and seconds ~= 0 ) or bShowEmpty ) ) or bSeconds then
        seconds = sf( '%02d', math.abs( seconds ) )
        str         = seconds .. 's'
    end

    if ( not bBelowMin and ( ( not bShowEmpty and tonumber( minutes ) ~= 0 ) or bShowEmpty ) ) then
        str         = minutes .. 'm ' .. str
    end

    if ( not bBelowMin and ( ( not bShowEmpty and tonumber( hours ) ~= 0 ) or bShowEmpty ) ) then
        str         = hours .. 'h ' .. str
    end

    if ( not bBelowMin and ( ( not bShowEmpty and tonumber( days ) ~= 0 ) or bShowEmpty ) ) then
        str         = days .. 'd ' .. str
    end

    return str
end

/*
*   seconds > milliseconds
*
*   uses os.clock( ) with a specified starting point to determine the ms that have passed.
*
*   @ex     : 0.5 =>  0.5ms
*   @ex     : 60  =>  60 s
*   @ex     : 130 =>  130 s
*
*   @param  : int began
*   @return : str
*/

function secs.ms( began )
    began           = isnumber( began ) and began or os.clock( )
    local elapsed   = os.clock( ) - began
    local ms        = 1000 * elapsed

    return sf( '%dms', ms )
end

/*
*   seconds > benchmark
*
*   returns only in seconds
*
*   @ex     : 0.5 =>  0.5ms
*   @ex     : 60  =>  60 s
*   @ex     : 130 =>  130 s
*
*   @param  : int i
*   @param  : int offset [ optional ]
*   @return : str
*/

function secs.benchmark( i, offset )
    i       = i and tonumber( i ) or 0
    offset  = offset and tonumber( offset ) or 0

    if i < 1 then
        return math.Truncate( i, 3 ) .. 'ms'
    else
        local sec = math.Truncate( i, 2 )
        if offset and offset > 0 then
            sec = sec - offset
        end
        return math.Round( sec ) .. 's'
    end
end

/*
*   seconds > ago
*
*   returns how long in the past an event occured
*
*   @ex     : ts.remains( 1627113692 )
*             returns   56 minutes
*
*   @param  : int i
*   @return : int
*/

function secs.ago( i, bAgo )
    i           = math.abs( i )
    i           = ts.past( i )

    if i >= 86400 then
        return ( '%i day%s %s' ):format( math.floor( i / 86400 ), i >= 172800 and 's' or '', bAgo and 'ago' or '' )
    elseif i >= 3600 then
        return ( '%i hour%s %s' ):format( math.floor( i / 3600 ), i >= 7200 and 's' or '', bAgo and 'ago' or '' )
    elseif i >= 60 then
        return ( '%i minute%s %s' ):format( math.floor( i / 60 ), i >= 120 and 's' or '', bAgo and 'ago' or '' )
    else
        return ( '%i second%s %s' ):format( i, i >= 2 and 's' or '', bAgo and 'ago' or '' )
    end
end

/*
*   seconds > mins
*
*   converts seconds into seconds : minutes
*
*   @ex     : timex.secs.mins( 333 )
*             05:33
*
*   @param  : int i
*   @return : int
*/

function secs.mins( i )
    local min   = math.floor( i / 60 )
    i           = i - min * 60

    return string.format( '%02d:%02d', min, math.floor( i ) )
end

/*
*   seconds > shorthand > columnized > steps > no leading zeros
*
*   converts seconds to a human readable format with various different parameters so you can decide
*   on what you want to see.
*
*   time displays in steps based on the higher type
*   does not display seconds until the final 60 seconds
*
*   @ex     :   timex.secs.sh_cols_steps( 175 )
*   @out    :   02m
*               m
*
*   @ex     :   timex.secs.sh_cols_steps( 32 )
*   @out    :   32s
*               s
*
*   :   ( bool ) bShowEmpty
*       will show all segments even if they are at 00.
*
*   :   ( bool ) bSeconds
*       displays the seconds value on the end
*
*   @param  : int i
*   @param  : bool bShowEmpty
*   @param  : bool bSeconds
*   @return : str
*/

function secs.sh_cols_steps_nz( i, bShowEmpty, bSeconds )
    local str               = ''
    local set_format        = '%2.f'

    i                       = tonumber( i ) or 0
                            if i < 0 then i = 0 end
    i                       = math.Round( i )

    local bBelowMin = i < 60 and true or false

    local days      = sf( set_format, floor( ( i - i % 86400 ) / 86400 ) )
    i               = i - days * 86400

    local hours     = sf( set_format, floor( ( i - i % 3600 ) / 3600 ) )
    i               = i - hours * 3600

    local minutes   = sf( set_format, floor( ( i - i % 60 ) / 60 ) )
    i               = i - minutes * 60

    local seconds   = sf( '%02d', i )

    if ( bBelowMin and ( ( not bShowEmpty and seconds ~= 0 ) or bShowEmpty ) ) or bSeconds then
        seconds = sf( '%2d', math.abs( seconds ) )
        str         = seconds .. 's'
    end

    if ( not bBelowMin and ( ( not bShowEmpty and tonumber( minutes ) ~= 0 ) or bShowEmpty ) ) then
        str         = minutes .. 'm ' .. str
    end

    if ( not bBelowMin and ( ( not bShowEmpty and tonumber( hours ) ~= 0 ) or bShowEmpty ) ) then
        str         = hours .. 'h ' .. str
    end

    if ( not bBelowMin and ( ( not bShowEmpty and tonumber( days ) ~= 0 ) or bShowEmpty ) ) then
        str         = days .. 'd ' .. str
    end

    return str
end

/*
*   timestamp > past > days
*
*   returns how many days have past based on the timestamp provided.
*   used for activites that require checking last activity.
*
*   @param  : int i
*   @return : int
*/

function ts.pastdays( i )
    i           = math.abs( i )
    i           = ts.past( i )

    if i >= 86400 then
        return math.floor( i / 86400 )
    else
        return 0
    end
end

/*
*   timestamp > remains
*
*   gets difference between provided timestamp and current timestamp.
*   returns seconds
*
*   @ex     : ts.remains( 1627113692 )
*             returns   00:56:51
*
*   @param  : int i
*   @return : int
*/

function ts.remains( i )
    return i - os.time( )
end

/*
*   timestamp > remains > server
*
*   gets difference between provided timestamp and current timestamp.
*   returns seconds
*
*   @note   : This function returns utilizes SERVER TIME; not client.
*
*   @ex     : ts.remains( 1627113692 )
*             returns   00:56:51
*
*   @param  : int i
*   @return : int
*/

function ts.remains_sv( i )
    return i - ( rlib.sys.time or 0 )
end

/*
*   timestamp > past
*
*   used for timestamp ages which are in the past
*
*   @param  : int i
*   @return : int
*/

function ts.past( i )
    return os.time( ) - i
end

/*
*   timestamp > past > server
*
*   used for timestamp ages which are in the past.
*
*   @note   : This function returns utilizes SERVER TIME; not client.
*
*   @param  : int i
*   @return : int
*/

function ts.past_sv( i )
    return ( rlib.sys.time or 0 ) - i
end

/*
*   timestamp > past > hours
*
*   returns how many hours have past based on the timestamp provided.
*   used for activites that require checking last activity.
*
*   @param  : int i
*   @return : int
*/

function ts.pasthours( i )
    i           = math.abs( i )
    i           = ts.past( i )

    if i >= 3600 then
        return math.floor( i / 3600 )
    else
        return 0
    end
end

/*
*   timestamp > past > hours > dev
*
*   returns how many hours have past based on the timestamp provided.
*   used for activites that require checking last activity.
*
*   developer
*
*   @param  : int i
*   @param  : int now
*   @return : int
*/

function ts.pasthours_d( i, now )
    i           = math.abs( i )
    local n     = i - now

    if n >= 3600 then
        return math.floor( n / 3600 )
    else
        return 0
    end
end

/*
*   basewars > structure time
*
*   gamemode specific func that displays basewars playtime
*   for player.
*
*   formats table for playtime into human readable format
*
*   @ex     : timex.bw.structtime( { h = 0, m = 0, s = 52 } )
*   @out    : 52s
*
*   @param  : tbl tbl
*   @param  : bool bLong
*   @return : str
*/

function bw.structtime( tbl, bLong )
    local dat       = tbl
    local resp      = ''

    if dat.h > 0 then
        resp        = resp .. dat.h .. ( not bLong and BaseWars.LANG.HoursShort or ln( 'time_hour_sh' ) ) .. ' '
    end
    if dat.m > 0 then
        resp        = resp .. dat.m ..  ( not bLong and BaseWars.LANG.MinutesShort or ln( 'time_min_sh' ) ) .. ' '
    end
    if dat.s > 0 then
        resp        = resp .. dat.s  ..  ( not bLong and BaseWars.LANG.SecondsShort or ln( 'time_sec_sh' ) ) .. ' '
    end

    return #resp > 0 and resp or sf( '0%s', ( not bLong and BaseWars.LANG.SecondsShort or ln( 'time_sec_ti' ) ) )
end

/*
*   basewars > playtime
*
*   gamemode specific func that displays basewars playtime
*   for player.
*
*   gets player current playtime as int
*
*   @assoc  : bw.structtime( tbl )
*
*   @ex     : timex.bw.playtime( pl )
*   @out    : 4m 39s
*
*   @param  : ply pl
*   @param  : bool bLong
*   @return : str
*/

function bw.playtime( pl, bLong )
    local def = { h = 0, m = 0, s = 0 }
    if not helper.ok.ply( pl ) then return def end
    local playtime = pl.GetPlayTimeTable and pl:GetPlayTimeTable( ) or def
    return bw.structtime( playtime, bLong )
end

/*
    rcc id

    creates rcc command with package name appended to the front
    of the string.

    @param  : str str
*/

local function g_RccID( str )
    str         = isstring( str ) and str ~= '' and str or false
                if not str then return pkg_name end

    return pid( str, pkg_name )
end

/*
*   rcc > base
*
*   base package command
*/

local function rcc_timex_base( pl, cmd, args )

    /*
    *   permissions
    */

    local ccmd = base.calls:get( 'commands', 'timex' )

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, script, ccmd.id )
        return
    end

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, script, ccmd.id )
        return
    end

    /*
    *   output
    */

    con( pl, 1 )
    con( pl, 0 )
    con( pl, Color( 255, 255, 0 ), sf( 'Manifest » %s', pkg_name ) )
    con( pl, 0 )
    con( pl, manifest.desc )
    con( pl, 1 )

    local a1_l              = sf( '%-20s',  'Version'   )
    local a2_l              = sf( '%-5s',  '»'   )
    local a3_l              = sf( '%-35s',  sf( 'v%s build-%s', rlib.get:ver2str( manifest.version ), manifest.build )   )

    con( pl, Color( 255, 255, 0 ), a1_l, Color( 255, 255, 255 ), a2_l, a3_l )

    local b1_l              = sf( '%-20s',  'Author'    )
    local b2_l              = sf( '%-5s',  '»'          )
    local b3_l              = sf( '%-35s',  sf( '%s', manifest.author ) )

    con( pl, Color( 255, 255, 0 ), b1_l, Color( 255, 255, 255 ), b2_l, b3_l )

    con( pl, 2 )
end

/*
*   rcc > list registered timers
*
*   returns a list of registered timers within package
*/

local function rcc_timex_list( pl, cmd, args )

    /*
        permissions
    */

    local ccmd = base.calls:get( 'commands', 'timex_list' )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, mf.name, ccmd.id )
        return
    end

    /*
        perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, mf.name, ccmd.id )
        return
    end

    /*
        params
    */

    local arg_param         = args and args[ 1 ] or false
    local gcf_active        = base.calls:gcflag( 'timex_list', 'active' )

    /*
    *   bActiveOnly
    *       >  true returns only a list of active timers running
    *       >  false returns all timers registered
    */

    local bActiveOnly = false
    if ( arg_param == gcf_active ) then
        bActiveOnly = true
    end

    local res, cnt          = list( bActiveOnly )
    table.sort( res, function( a, b ) return a.id < b.id end )

    /*
        functionality
    */

    con( 'c', 3 )
    con( 'c', 0 )
    con( 'c',       sf( '%s » %s', mf.name, pkg_name ), Color( 255, 255, 255 ), ' » Registered Items' )
    con( 'c', 0 )
    con( 'c', 1 )

    local a1_l      = sf( '%-35s',  'Name'      )
    local a2_l      = sf( '%-5s',   '»'         )
    local a3_l      = sf( '%-10s',  'Active'    )
    local a4_l      = sf( '%-20s',  'Remains'   )
    local a5_l      = sf( '%-10s',  'Reps'      )
    local a6_l      = sf( '%-30s',  'Desc'      )

    con( 'c',       Color( 255, 255, 0 ), a1_l, Color( 255, 255, 255 ), a2_l, a3_l, a4_l, a5_l, a6_l )
    con( 'c', 0 )
    con( 'c', 1 )

    if table.IsEmpty( res ) then
        local resp  = ( bActiveOnly and 'No active timers found' ) or 'No timers found'
        con( 'c',    resp )
        con( 'c', 3 )
        return
    end

    for k, v in SortedPairs( res ) do
        local a1_2      = sf( '%-35s',  v.id        )
        local a2_2      = sf( '%-5s',   '»'         )
        local a3_2      = sf( '%-10s',  v.bActive   )
        local a4_2      = sf( '%-20s',  v.remains   )
        local a5_2      = sf( '%-10s',  v.reps      )
        local a6_2      = sf( '%-30s',  v.desc      )

        con( 'c',       Color( 255, 255, 0 ), a1_2, Color( 255, 255, 255 ), a2_2, a3_2, a4_2, a5_2, a6_2 )
    end

    con( 'c', 3 )

end

/*
    rcc > rehash

    refreshes all console commands
*/

local function rcc_rehash( pl, cmd, args )

    /*
        permissions
    */

    local ccmd = base.calls:get( 'commands', 'timex_rcc_rehash' )

    /*
        scope
    */

    if ( ccmd.scope == 1 and not access:bIsConsole( pl ) ) then
        access:deny_consoleonly( pl, mf.name, ccmd.id )
        return
    end

    /*
        perms
    */

    if not access:bIsRoot( pl ) then
        access:deny_permission( pl, mf.name, ccmd.id )
        return
    end

    /*
        execute
    */

    RegisterRCC( true )

end

/*
    rcc > register

    @param  : bool bOutput
*/

function RegisterRCC( bOutput )
    local pkg_commands =
    {
        [ pkg_name ] =
        {
            enabled     = true,
            warn        = true,
            id          = g_PackageId( ),
            name        = pkg_name,
            desc        = 'returns package information',
            scope       = 2,
            clr         = Color( 255, 255, 0 ),
            assoc       = function( ... )
                            rcc_timex_base( ... )
                        end,
        },
        [ pkg_name .. '_list' ] =
        {
            enabled     = true,
            warn        = true,
            id          = g_PackageId( 'list' ),
            name        = 'List',
            desc        = 'returns a list of registered timers',
            clr         = Color( 255, 255, 0 ),
            scope       = 2,
            flags =
            {
                [ 'active' ]    = { flag = '-a', desc = 'returns active only' },
            },
            assoc       = function( ... )
                            rcc_timex_list( ... )
                        end,
        },
        [ pkg_name .. '_rcc_rehash' ] =
        {
            enabled     = true,
            warn        = true,
            id          = g_PackageId( 'rcc_rehash' ),
            desc        = 'reload all module rcc commands',
            scope       = 1,
            clr         = Color( 255, 255, 0 ),
            assoc       = function( ... )
                            rcc_rehash( ... )
                        end,
        },
    }

    /*
        rcc > register
    */

    base.calls.commands:Register( pkg_commands )

    /*
        save output
    */

    if not bOutput then return end

    local i = table.Count( pkg_commands )
    base:log( RLIB_LOG_OK, ln( 'rcc_rehash_i', i, pkg_name ) )
end
hook.Add( pid( 'cmd.register' ), pid( '__timex.cmd.register' ), RegisterRCC )

/*
*   register package
*/

local function register_pkg( )
    if not istable( _M ) then return end
    base.package:Register( _M )
end
hook.Add( pid( 'pkg.register' ), pid( '__timex.pkg.register' ), register_pkg )

/*
*   module info > manifest
*/

function pkg:manifest( )
    return self.__manifest
end

/*
*   __tostring
*/

function pkg:__tostring( )
    return self:_NAME( )
end

/*
*   create new class
*/

function pkg:loader( class )
    class = class or { }
    self.__index = self
    return setmetatable( class, self )
end

/*
*   __index / manifest declarations
*/

pkg.__manifest =
{
    __index     = _M,
    name        = _NAME,
    build       = manifest.build,
    version     = manifest.version,
    author      = manifest.author,
    desc        = manifest.desc
}

pkg.__index     = pkg