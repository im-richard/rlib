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

/*
    permissions
*/

    base.permissions =
    {
        [ 'rlib_root' ] =
        {
            id              = 'rlib_root',
            category        = 'rlib',
            desc            = 'Allows for complete access to rlib',
            access          = 'superadmin'
        },
        [ 'rlib_alogs' ] =
        {
            id              = 'rlib_alogs',
            category        = 'rlib',
            desc            = 'Group can view special chat-based announcement logs as they occur',
            access          = 'superadmin'
        },
        [ 'rlib_asay' ] =
        {
            id              = 'rlib_asay',
            category        = 'rlib',
            desc            = 'In-game special group only chat abilities. Similar to ulx asay',
            access          = 'superadmin'
        },
        [ 'rlib_debug' ] =
        {
            id              = 'rlib_debug',
            category        = 'rlib',
            desc            = 'Allows usage of debugger tools',
            access          = 'superadmin'
        },
        [ 'rlib_forcerehash' ] =
        {
            id              = 'rlib_forcerehash',
            category        = 'rlib',
            desc            = 'Forces a complete rehash of the entire server file-structure',
            access          = 'superadmin'
        },
    }