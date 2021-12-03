/*
    @library        : rlib
    @module         : base
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
local storage               = base.s
local helper                = base.h
local access                = base.a
local font                  = base.f

/*
    module
*/

local mod, pf       	    = base.modules:req( 'base' )
local cfg               	= base.modules:cfg( mod )

/*
    language
*/

local function ln( ... )
    return base:translate( mod, ... )
end

/*
    misc localization
*/

local _f                    = font.new

/*
    fonts > primary
*/

local function fonts_register( pl )

    /*
        perm > reload
    */

        if ( ( helper.ok.ply( pl ) or access:bIsConsole( pl ) ) and not access:allow_throwExcept( pl, 'rlib_root' ) ) then return end

    /*
        scaling
    */

        local scale         = RScale( 0.4 )

    /*
    *	general
    */

        _f( pf, '{{ user_id }}',                    'Segoe UI Light', 34, 100 )
    /*
    *   concommand > reload
    */

        if helper.ok.ply( pl ) or access:bIsConsole( pl ) then
            base:log( 4, '[ %s ] reloaded fonts', mod.name )
            if not access:bIsConsole( pl ) then
                base.msg:target( pl, mod.name, 'reloaded fonts' )
            end
        end

end
rhook.new.rlib( 'base_fonts_register', fonts_register )
rcc.new.rlib( 'base_fonts_reload', fonts_register )

/*
    fonts > rnet > reload
*/

local function fonts_rnet_reload( data )
    fonts_register( LocalPlayer( ) )
end
rnet.call( 'base_fonts_reload', fonts_rnet_reload )