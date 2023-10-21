/*
*   @package        : rlib
*   @module         : rcore
*   @author         : Richard [http://steamcommunity.com/profiles/76561198135875727]
*   @copyright      : (c) 2018 - 2020
*   @since          : 1.0.0
*   @website        : https://rlib.io
*   @docs           : https://docs.rlib.io
*   @file           : sv_init.lua
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
    standard tables and localization
*/

local base                  = rlib
local access                = base.a
local helper                = base.h
local storage               = base.s
local sys                   = base.sys
local rlib_mf               = base.manifest

/*
    Localized lua funcs
*/

local sf                    = string.format

/*
    Localized translation func
*/

local function ln( ... )
    return base:lang( ... )
end

/*
    prefix ids
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( rcore and rcore.manifest.prefix ) or false
    return base.get:pref( str, state )
end

/*
    module > write data
*/

local function module_writedata( )

    local manifest      = rlib_mf
    local mdata         = { }
    mdata.modules       = { }
    for k, v in pairs( rcore.modules ) do
        local ver   = ( istable( v.version ) and base.modules:ver2str( v.version ) ) or v.version

        mdata.modules[ k ]          = { }
        mdata.modules[ k ].name     = v.name
        mdata.modules[ k ].version  = ver
        mdata.modules[ k ].enabled  = v.enabled
    end
    table.sort( mdata, function( a, b ) return a[ 1 ] < b[ 1 ] end )

    file.Write( storage.mft:getpath( 'data_modules' ), util.TableToJSON( mdata ) )

    local mnfst = { }
    for k, v in pairs( manifest ) do
        mnfst[ k ] = v
    end

    file.Write( storage.mft:getpath( 'data_manifest' ), util.TableToJSON( mnfst ) )
end
rhook.new.rlib( 'rcore_modules_load_post', 'rcore_modules_writedata', module_writedata )

/*
    module > validate
*/

local function module_validate( source, bBypass )
    timex.simple( 'rcore_modules_validate', 0, function( )
        if source and not istable( source ) then
            local trcback = debug.traceback( )
            base:log( 2, 'cannot validate module, bad table\n[%s]', trcback )
            return
        end

        source = source or rcore.modules

        for v in helper.get.data( source ) do
            if not v.parent then continue end

            local mod_sys       = istable( v.parent.sys ) and v.parent.sys or { }
            mod_sys.validate    = true

            local libreq        = v.libreq
                                if not libreq then continue end
                                if not bBypass and ( v.errorlog and v.errorlog.bLibOutdated ) then continue end

            local bHasError     = false
            local mreq_ver      = base.get:version( v, true )
            local rlib_ver      = base.get:version( )

            if ( mreq_ver.major > rlib_ver.major ) then
                bHasError = true
            elseif ( mreq_ver.major == rlib_ver.major ) then
                if mreq_ver.minor > rlib_ver.minor then
                    bHasError = true
                elseif mreq_ver.minor == rlib_ver.minor then
                    if mreq_ver.patch > rlib_ver.patch then
                        bHasError = true
                    end
                end
            end

            if bHasError then
                base:log( 0 )
                base:log( 2, '--------------------------------------------------------------------------------' )
                base:log( 2, ln( 'module_outdated', v.name, rlib_mf.name, rlib_mf.site ) )
                base:log( 2, '--------------------------------------------------------------------------------' )
                base:log( 0 )

                v.errorlog = v.errorlog or { }
                v.errorlog.bLibOutdated = true
            end

        end
    end )
end
rhook.new.gmod( 'Initialize', 'rcore_modules_validate', module_validate )

/*
    module > register > permissions
*/

local function module_register_perms( source )
    if source and not istable( source ) then
        local trcback = debug.traceback( )
        base:log( 2, 'cannot register permissions for modules, bad table\n%s', trcback )
        return
    end

    source = source or rcore.modules

    for v in helper.get.data( source ) do
        if not v.enabled or not v.permissions then continue end
        base.a:initialize( v.permissions )
    end
end
rhook.new.gmod( 'PostGamemodeLoaded', 'rcore_modules_perms_register', module_register_perms )

/*
    initialize > stats
*/

local function initialize_stats( )
    if not base.settings.debug.stats then return end

    base:log( 0 )
    base:log( RLIB_LOG_SYSTEM, '[ %s ] to start server',  timex.secs.benchmark( SysTime( ) ) )
    base:log( RLIB_LOG_SYSTEM, '[ %i ] tickrate',         math.Round( 1 / engine.TickInterval( ) ) )
    base:log( RLIB_LOG_SYSTEM, '[ %s ] startups',         string.Comma( sys.startups or 0 ) )
    base:log( 0 )

    sys.starttime = timex.secs.benchmark( SysTime( ) )

    if storage.exists( 'data_crash' ) then
        base:log( RLIB_LOG_SYSTEM, 'recovering from unexpected server shutdown' )
        storage.file.del( 'data_crash' )
        base:log( 0 )
    end
end
hook.Add( pid( 'initialize.post', rlib_mf.prefix ), pid( 'server.initialize' ), initialize_stats )