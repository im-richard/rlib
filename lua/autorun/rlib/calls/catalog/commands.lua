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
    associated commands

    :   parameters

        enabled     :   determines if the command be useable or not
        bInternal   :   for internal cmds like rlib_rnet_reload; otherwise function will be overwritten
        is_base     :   will be considered the base command of the lib.
        is_hidden   :   determines if the command should be shown or not in the main list
                    :   do not make more than one command the base or you may have issues.
        id          :   command that must be typed in console to access
        clr         :   color to display command in when searched / seen in console list
        pubc        :   public command to execute command
        desc        :   description of command
        args        :   additional args that command supports
        scope       :   what scope the command can be accessed from ( 1 = sv, 2 = sh, 3 = cl )
        showsetup   :   displays the command in the help info after the server owner has been recognized using ?setup
        official    :   official rlib command; displayed within console when 'rlib' command input
        ex          :   examples of how the command can be utilized; used as visual help for user
        flags       :   command arg flags that can be used to access different sub-features
        notes       :   important notes to display when user searches help for a command
        warn        :   displays a warning to the user about using this command and non-liability
        no_console  :   cannot be executed by server-console. must have a valid player running command
*/

base.c.commands =
{
    [ 'rlib_cs_new' ] =
    {
        enabled             = true,
        id                  = 'rlib.cs.new',
        name                = 'Checksum » New',
        desc                = 'write checksums and deploy lib',
        scope               = 1,
        official            = true,
        ex =
        {
            'rlib.cs.new',
        },
    },
    [ 'rlib_cs_verify' ] =
    {
        enabled             = true,
        id                  = 'rlib.cs.verify',
        name                = 'Checksum » Verify',
        desc                = 'checks the integrity of lib files',
        args                = '[ <command> ], [ <-flag> <search_keyword> ]',
        scope               = 1,
        official            = true,
        ex =
        {
            'rlib.cs.verify',
            'rlib.cs.verify -f rlib_core_sv',
        },
        flags =
        {
            [ 'all' ]       = { flag = '-a', desc = 'displays all results' },
            [ 'filter' ]    = { flag = '-f', desc = 'filter search results' },
        },
    },
    [ 'rlib_cs_obf' ] =
    {
        enabled             = true,
        id                  = 'rlib.cs.obf',
        name                = 'Checksum » Obf',
        desc                = 'Internal release prepwork',
        scope               = 1,
        official            = true,
        ex =
        {
            'rlib.cs.obf',
        },
    },
    [ 'rlib_languages' ] =
    {
        enabled             = true,
        id                  = 'rlib.languages',
        name                = 'Languages',
        desc                = 'language info',
        scope               = 2,
        official            = true,
    },
    [ 'rlib_modules' ] =
    {
        enabled             = true,
        id                  = 'rlib.modules',
        name                = 'rcore modules',
        desc                = 'all rcore modules',
        scope               = 1,
        showsetup           = true,
        official            = true,
        ex =
        {
            'rlib.modules',
            'rlib.modules -p',
        },
        flags =
        {
            [ 'paths' ]     = { flag = '-p', desc = 'display module install paths' },
        },
    },
    [ 'rlib_setup' ] =
    {
        enabled             = true,
        id                  = 'rlib.setup',
        name                = 'Setup library',
        desc                = 'setup lib | should be ran at first install',
        pubc                = '!setup',
        scope               = 1,
        official            = true,
    },
    [ 'rlib_workshops' ] =
    {
        enabled             = true,
        id                  = 'rlib.workshops',
        name                = 'Workshops',
        desc                = 'workshop ids loaded between modules / lib',
        scope               = 2,
        showsetup           = true,
        official            = true,
    },
}