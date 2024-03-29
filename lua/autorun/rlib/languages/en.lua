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
*   translations
*/

base.language =
{
    [ 'en' ] =
    {
        lib_name                            = 'rlib',
        lib_cfg_invalid                     = 'cannot locate specified cfg file',
        lib_rdb_invalid                     = 'cannot locate specified database file',
        lib_cfg_missing                     = 'missing specified cfg file » [ %s ]',
        lib_initialized                     = 'server not initialized » connect to the server as a player',
        lib_session_id                      = 'current session id: [ #%i ]',
        lib_start_compl                     = 'Server Initialized ( session id: [ #%i ] )',
        lib_state_initialize                = 'Finalizing',
        lib_integrity_title                 = '%s » INTEGRITY CHECK » FAILED',
        lib_integrity_l1                    = 'Library has determined that numerous files have not passed the integrity check.',
        lib_integrity_l2                    = 'No support will be given until the original library is installed.',
        lib_integrity_cnt                   = '%i files failed integrity check',
        lib_integirty_ok                    = 'Integrity Check » [ %s ]',
        lib_oort                            = 'Oort Engine',
        lib_oort_disabled                   = 'Oort Engine » [ disabled ]',
        lib_oort_err                        = 'Oort Engine » returned code [ %i ]',
        lib_oort_missing_params             = 'Oort Engine » missing parameters',
        lib_oort_abt_status_ok              = 'connected',
        lib_oort_abt_status_err             = 'error connecting to server',
        lib_oort_abt_status_pending         = 'connecting ...',
        lib_oort_err_sid                    = 'Missing script_id or owner for module [ %s ]',
        lib_udm_ok                          = '[udm] » server has latest version » [ %s ]',
        lib_udm_chk_errcode                 = '[udm] » failed udm check » branch [ %s ] » code [ %i ]',
        lib_udm_chk_errmsg                  = '[udm] » failed udm check » branch [ %s ] » response [ %s ]',
        lib_udm_err_major                   = '[udm] » new major update available » current [ %s ] » latest [ %s ]',
        lib_udm_err_minor                   = '[udm] » new release available » current [ %s ] » latest [ %s ]',
        lib_udm_err_patch                   = '[udm] » new patch available » current [ %s ] » latest [ %s ]',
        lib_udm_active                      = '[udm] » active » next check [ %s ]',
        lib_udm_bad_dur                     = '[udm] » not a valid number for duration',
        lib_udm_started                     = '[udm] » started » executes every [ %i ] seconds',
        lib_udm_stopped                     = '[udm] » stopped',
        lib_udm_inactive                    = '[udm] » inactive',
        lib_udm_err_noinit                  = '[udm] » halted » player must connect to the server after first startup',
        lib_udm_run                         = '[udm] » executing manual run',
        lib_udm_nextchk                     = '[udm] » already running » next check [ %s ]',
        lib_udm_timer_ran                   = '[udm] » update timer ran',
        lib_udm_mismatch                    = '[udm] » version mismatch » latest: v[ %s ] » installed: v[ %s ]',
        lib_udm_checking                    = 'checking for updates ...',
        lib_udm_outdated                    = 'rlib outdated',
        lib_udm_latest                      = 'running latest version',
        lib_udm_misatch                     = 'running unrecognized version',
        lib_setup_title                     = '» Setup Notice [ %s ]',
        lib_setup_phrase_1                  = 'Connect to your server and wait until you are in-game.',
        lib_setup_phrase_2                  = '     Execute the console command',
        lib_setup_phrase_3                  = 'You will be assigned as \'root user\' with access to all library commands',
        lib_setup_phrase_4                  = 'Example:',
        lib_setup_phrase_5                  = ' If your in-game name is %s, you can type',
        lib_setup_alt_msg_1                 = '     Open up your chat box and type',
        lib_setup_alt_msg_2                 = 'within your in-game chat',
        lib_setup_alt_cmd                   = ' » ?setup',
        lib_setup_name_ex                   = '"John Doe"',
        lib_setup_opt_1                     = 'OPTION 1:',
        lib_setup_opt_2                     = 'OPTION 2:',
        lib_setup_opt_or                    = '   OR',
        lib_setup_chat_1                    = 'root user missing! type',
        lib_setup_chat_2                    = 'in chat to give the server owner root permissions',
        lib_addons_title                    = 'Module Management',
        lib_addons_opening                  = 'Addons interface opening ...',
        lib_addons_view_docs                = 'VIEW DOCS',
        lib_addons_view                     = 'VIEW',
        lib_cs_title                        = '» Checksum Result',
        lib_cs_desc                         = 'A new checksum has been generated for the final production release.',
        lib_cs_col_ver                      = 'Version',
        lib_cs_col_date                     = 'Date',
        lib_cs_col_files                    = 'Files',
        lib_cs_col_sha1                     = 'SHA-1',
        lib_devop_hooks_t                   = '» HOOKS » Faults',
        lib_devop_timers_t                  = '» TIMEX » Faults',
        lib_devop_rnet_t                    = '» RNET » Faults',
        lib_devop_cmds_t                    = '» COMMANDS » Faults',
        lib_devop_check_pass                = 'No issues found',
        rcc_commands_rehash                 = 'RCC commands rehashed',
        rcc_rehash_i                        = 'Successfully reloaded %i rcc commands » [ %s ]',
        access_recognized                   = ' I recognize you as',
        access_ugroup_dev                   = 'developer',
        access_ugroup_owner                 = 'owner',
        action_automatic                    = 'automatic action',
        action_requested                    = 'requested action',
        asay_disabled                       = 'asay disabled » server cvar disabled',
        calls                               = 'calls',
        calls_id_missing                    = 'id missing » [ %s ]',
        calls_tbl_invalid                   = 'cannot run calls without valid table',
        calls_tbl_missing_def               = 'missing definition table -- aborting',
        calls_found_cnt                     = '[ %i ] registered calls found',
        calls_register_tbl                  = '+ netlib calls table',
        calls_register_nlib                 = 'registering netlibs',
        calls_type_valid                    = 'valid types are [ %s ]',
        calls_type_missing                  = 'missing call type » [ %s ]',
        calls_type_missing_spec             = 'missing specified call type',
        calls_cmd_lib_base                  = '+ base lib cmd [ %s ]',
        calls_cmd_lib_missing               = 'missing base lib cmd »\n%s',
        calls_reg_params_missing            = 'missing table params specified for new command [ %s ]',
        calls_reg_cmd_id_missing            = 'invalid command id » canceling command registration [ %s ]',
        calls_cmd_added                     = '+ command [ %s ]',
        case_nofunc                         = 'case %s not a func',
        checksum_write_err                  = 'Error occured deploying packages -- check required modules',
        checksum_write_success              = 'Successfully wrote packages for deployment',
        checksum_validate_fail              = 'checksum validation failed',
        cmd_param_invalid                   = 'invalid command parameter specified',
        cmd_no_desc                         = '-',
        res_no_desc                         = '-',
        cmsg_missing                        = 'helper cmsg missing style table',
        con_checksum_verify                 = 'Checksum » Verify',
        con_checksum_obf                    = 'Checksum » Obf',
        col_author                          = 'author',
        col_current                         = 'current',
        col_data                            = 'data',
        col_desc                            = 'description',
        col_entries                         = 'entries',
        col_file                            = 'file',
        col_id                              = 'id',
        col_language                        = 'language',
        col_module                          = 'module',
        col_package                         = 'package',
        col_ref_id                          = 'ref_id',
        col_version                         = 'version',
        col_verified                        = 'verified',
        col_name_lib                        = 'library',
        col_name_rnet                       = 'rnet',
        col_name_timex                      = 'timex',
        col_name_spew                       = 'spew',
        copied_to_clipboard                 = 'Copied to clipboard',
        convert_toggle_idiot                = 'we have a confused kid over here who cannot make up their mind. Aborting, and so should you.',
        cvar_added                          = '+ cvar [ %s ]',
        cvar_changed                        = 'cvar [ %s ] modified :: %s » %s',
        cvar_missing_name                   = 'cannot create cl cvar » missing name',
        cvar_missing_def                    = 'cannot create cl cvar [ %s ] » missing default',
        cvar_nohelp                         = 'no text info available',
        datafolder_add                      = '+ datafolder » [ %s ]',
        datafolder_sub_add                  = '+ datafolder » sub » [ %s ]',
        datafolder_missing                  = 'missing valid dir » skipping',
        datafolder_inv_chars                = 'parent folder contains invalid characters, must be alpha-numerical',
        datafolder_sub_inv_chars            = 'sub folder contains invalid characters, must be alpha-numerical',
        db_failed                           = '[db] » [ %s ] failed to execute db query',
        dc_title                            = 'Disconnect?',
        dc_leave                            = 'Leave Server?',
        dc_msg                              = 'Would you like to disconnect?',
        dc_opt_stay                         = 'STAY',
        dc_opt_leave                        = 'LEAVE',
        logs_clean_threshold                = 'logs [ %i ] files and [ %i ] folders in [ data/%s ] Size: [ %s ]. Please clean folder using concommand [ %s ]',
        logs_dir_size                       = 'logs [ %i ] files and [ %i ] folders in [ data/%s ] Size: [ %s ]',
        debug_start_on                      = 'starting server with debug mode on',
        debug_disabled                      = 'debug » status » disabled',
        debug_enabled                       = 'debug » status » enabled',
        debug_status                        = 'debug » %s',
        debug_set_disabled                  = 'debug has been disabled',
        debug_set_notify_disabled           = 'debug » has been disabled',
        debug_set_enabled                   = 'debug has been enabled',
        debug_set_enabled_dur               = 'debug » now enabled » %is',
        debug_set_notify_enabled_dur        = 'debug » is now enabled for %is',
        debug_enabled_already               = 'debug already enabled » %s remaining',
        debug_enabled_time                  = 'debug » enabled » %s remaining',
        debug_auto_disable                  = 'debug » automatically disabled',
        debug_auto_notify_disable           = 'debug » has been automatically disabled',
        debug_auto_remains                  = 'debug » temporarily enabled » %s remaining',
        debug_err_duration                  = 'debug » duration not a invalid number',
        debug_help_info_1                   = 'rlib.debug < set:on|off > < dur:# >',
        debug_help_info_2                   = 'rlib.debug on 30',
        debug_receive_err                   = 'error receiving debug msg',
        debug_bc_title                      = 'DEBUG ENABLED',
        debug_bc_disabling                  = 'Debug now disabled',
        dialog_key_close                    = 'PRESS %s TO CLOSE',
        entries                             = 'entries',
        err                                 = 'err',
        files_listed_have_been_modified     = 'Files listed below have been modified. Any changes to the library may result in no \n support from the developer',
        files_modified_count                = '%i files modified',
        files_modified_none                 = 'All files verified',
        garbage_cleaned                     = 'dumped [ %i ] to garbage [ %s ]',
        garbage_err                         = 'cannot clean garbage for [ %s ]',
        glon_missing                        = '[glon] » module missing',
        glon_err_src                        = '[glon] » missing src',
        glon_err_path                       = '[glon] » failed to locate specified path » [ %s ]',
        glon_save                           = '[glon] » saved data to file » [ %s ]',
        glon_save_err_data                  = '[glon] » missing data',
        rcfg_title                          = 'configuration utility',
        hlp_who_rp_notable                  = 'darkrp table [ %s ] missing » check gamemode', 'RPExtraTeams',
        inf_load_id_invalid                 = 'cannot load interface with invalid id',
        inf_load_tbl_invalid                = 'no valid interface lib table',
        inf_registered                      = '+ interface » [ %s ]',
        inf_reg_id_invalid                  = 'cannot register interface with invalid id',
        inf_found_cnt                       = '[ %i ] registered interfaces found',
        inf_unregister                      = '- interface » [ %s ]',
        inf_unreg_id_invalid                = 'cannot unregister interface with invalid id',
        inf_unreg_tbl_invalid               = 'interface not valid » missing reference table',
        konsole_tooltip_clear               = 'clear text',
        konsole_tooltip_cfg                 = 'settings',
        console                             = 'Console',
        konsole_settings                    = 'Konsole » Settings',
        kick_invalid_perms                  = 'kick requested by user with insufficient permissions',
        kick_invalid_ply                    = 'cannot kick invalid player',
        kick_success                        = '[ %s ] » kicked » [ %s ] for [ %s ]',
        label_author                        = 'author',
        label_released                      = 'released',
        label_version                       = 'version',
        lang_title                          = 'Language',
        lang_sel_title                      = 'Select Language',
        lang_sel_desc                       = 'Select a language below to switch your interface translations. Changes take affect immediately when selected.',
        lang_msg_change                     = 'Switched to [ %s ]',
        lang_rcore_missing                  = 'cannot find registered languages » rcore missing or disabled',
        languages                           = 'languages',
        logs_cat_general                    = '[General]',
        logs_cat_uconn                      = '[UCONN]',
        logs_clean_cancel                   = 'Successfully cancelled clean logs action',
        logs_clean_scheduled                = 'Logs are scheduled for cleanup in [ %i ] seconds, type [ %sdebug.clean %s ] to abort',
        logs_clean_success                  = 'Successfully cleaned up [ %i ] log files in [ data/%s ]',
        logs_nopath                         = 'unable to write log, valid path not specified',
        manifest                            = 'manifest',
        modules_rehash_unknown              = 'Module name not specified',
        modules_rehash_rcore                = 'Reloading rcore base. This may cause issues',
        mat_tbl_invalid                     = 'material source table not specified',
        missing                             = 'missing',
        missing_item                        = '%s » missing',
        modules                             = 'modules',
        no_command_specified                = 'no command specified',
        errorlog                            = 'error log',
        mdlv_title                          = 'Model Viewer',
        mdlv_btn_copytoclip                 = 'Click to copy',
        mdlv_btn_copy                       = 'copy',
        mdlv_btn_path                       = 'path',
        mdlv_search_def                     = 'Search',
        mdlv_btn_tip_search                 = 'Search',
        mdlv_btn_tip_clear                  = 'Clear',
        module_unknown                      = 'unknown module',
        module_updates_error                = '[ %s ] » missing manifest id, script_id, or version param » cannot check for updates',
        module_updates_bad_sid              = '[ %s ] » %s not a valid script id, download a new copy from gmodstore.com',
        module_demomode                     = 'Demo Mode',
        module_outdated                     = '%s needs newer version of %s to run » download » [ %s ]',
        msg_invalid                         = 'invalid message',
        notify_title_def                    = 'Notice',
        not_specified                       = 'not specified',
        none                                = 'none',
        opt_disabled                        = 'disabled',
        opt_enabled                         = 'enabled',
        opt_no                              = 'no',
        opt_yes                             = 'yes',
        packages                            = 'packages',
        perms_add                           = '+ %s » [ %s ]',
        perms_type_base                     = 'base',
        perms_type_sg                       = 'serverguard',
        perms_type_ulx                      = 'ulx-p',
        perms_type_ulx_int                  = 'ulx-i',
        perms_flag_setup                    = 'setup',
        perms_flag_index                    = 'index',
        perms_invalid                       = 'invalid permission »',
        properties_setup                    = 'failed setup properties with missing parameters',
        reports_title                       = 'send report',
        reports_desc                        = 'Submit a report to the developer related to your server and its current operation status.\n\nProvide a brief comment and click the \'Send Report\' button',
        reports_no_access                   = 'invalid access to send reports',
        reports_auth_code                   = 'Authorization Code',
        reports_auth_code_req               = 'request auth code',
        reports_tooltip_clear               = 'clear text',
        reports_tooltip_submit              = 'submit report',
        reports_btn_submit                  = 'Submit',
        reports_err_auth_invalid            = 'Must supply valid auth id',
        reports_err_auth_length             = 'Auth id too long',
        reports_err_auth_lessthan           = 'Comment must be less than %i characters.',
        reports_err_send_delay              = 'You cannot send another report for %s seconds.',
        reports_err_unknown                 = 'Unknown error',
        reports_please_wait                 = 'Please wait...',
        reroute_rcore_missing               = 'reroute disabled » rcore missing or inactive',
        response_empty                      = 'response empty',
        response_err                        = 'unknown response error',
        response_none                       = 'no response from server',
        restart_canceled                    = 'cancelled an active server restart',
        restart_none_active                 = 'no scheduled restarts in progress',
        restart_now                         = 'Restarting server ...',
        rs_msg_none                         = 'No scheduled restarts active',
        rs_exists                           = 'Restart already scheduled',
        rs_msg_ulx                          = 'Server restart in [ %i ] %s',
        rs_msg                              = 'Server restart in [ %i ] %s',
        rs_msg_reason                       = 'Server restart in [ %i ] %s :: reason :: %s',
        rs_msg_admin                        = '[ %s ] has forced a timed server restart in [ %i ] %s',
        rs_msg_admin_reason                 = '[ %s ] has forced a timed server restart in [ %i ] %s :: reason :: %s',
        rs_scheduled_none                   = 'NO SCHEDULED RESTARTS',
        rs_in                               = 'RESTART IN ...',
        rs_scheduled                        = 'Restart Scheduled',
        rs_status                           = 'Restarting ...',
        rdo_info_ent                        = '%s [ %s ] » [ ent_index: %s » map_id: %s ]',
        rdo_invalid_mode                    = '[rdo] » invalid rendermode specified. [ %s ] reverting to rendermode transalpha [4]',
        rdo_set                             = '[rdo] » %s',
        rdo_set_ent                         = '[rdo] » set mode [ %s ] on entity',
        pco_set_debug_usr                   = '[pco] » [ %s ] set mode [ %s ]',
        pco_set_debug_usr_admin             = '[pco] » admin [ %s ] has [ %s ] this service on player [ %s ]',
        pco_disabled_debug                  = '[pco] » disabled » server cvar disabled',
        rnet_debug_help_info_1              = 'rnet.debug < set:on|off > < dur:# >',
        rnet_debug_help_info_2              = 'rnet.debug on 30',
        rnet_added                          = '+ net » [ %s ]',
        script_updated                      = '%s » server has latest version » v[ %s ]',
        script_outdated                     = '%s » outdated » Latest: v[ %s ] » Installed: v[ %s ]',
        script_update_err                   = '%s » failed to check for updates » returned code [ %i ]',
        script_unspecified                  = 'unspecified script',
        server_shutdown                     = 'Server shutting down / changing levels',
        server_uptime                       = 'server uptime',
        services_id_udm                     = 'udm',
        services_id_pco                     = 'pco',
        services_id_rdo                     = 'rdo',
        services_id_oort                    = 'oort',
        services_status_warn                = 'warning',
        services_status_running             = 'running',
        services_status_stopped             = 'stopped',
        services_found_cnt                  = '[ %i ] registered services',
        search_term                         = 'Searching term » [ %s ]',
        search_raw                          = 'Returning raw output',
        sort_badtable                       = 'cannot sort by key with invalid table',
        stats                               = 'stats',
        stats_errors                        = 'errors',
        stats_disabled                      = 'disabled',
        stats_reg_cnt                       = '%i registered',
        stats_registered                    = 'registered',
        stats_total                         = 'total',
        stats_total_cnt                     = '%i total',
        status_col_admins                   = 'admins',
        status_col_rnet_id                  = 'rnet id',
        status_col_branch                   = 'branch',
        status_col_calls                    = 'calls',
        status_col_basecmd                  = 'command base',
        status_col_gm                       = 'gamemode',
        status_col_init                     = 'initialized',
        status_col_conncnt                  = 'connections',
        status_col_debug                    = 'debug-mode',
        status_col_debug_mode               = 'debug mode',
        status_col_history                  = 'history',
        status_col_logs                     = 'logs',
        status_col_os                       = 'os',
        status_col_rnet_route               = 'rnet-router',
        status_col_rnet_debug               = 'rnet-debug',
        status_col_rcore                    = 'rcore',
        status_col_starttime                = 'start-time',
        status_col_startcnt                 = 'startups',
        status_col_uconn                    = 'uconn',
        status_col_uptime                   = 'uptime',
        status_col_validated                = 'validated',
        status_col_latest_ver               = 'running latest',
        status_col_heartbeat                = 'last heartbeat',
        status_col_sess_id                  = 'session id',
        status_col_auth_id                  = 'auth_id',
        status_col_owner                    = 'owner',
        status_rcore_missing                = 'cannot complete status report » rcore missing or disabled',
        storage                             = 'storage',
        sym_arrow                           = '»',
        time_hour_ln                        = 'hour',
        time_min_ln                         = 'minute',
        time_sec_ln                         = 'second',
        time_hour_sh                        = 'hr',
        time_min_sh                         = 'min',
        time_sec_sh                         = 'sec',
        time_hour_ti                        = 'h',
        time_min_ti                         = 'm',
        time_sec_ti                         = 's',
        title_about                         = 'About',
        diag_title                          = 'Diagnostics',
        diag_lbl_fps                        = 'FPS',
        diag_lbl_timers                     = 'Timers (A)',
        diag_lbl_cur                        = 'Curtime',
        diag_lbl_ply                        = 'Players',
        diag_lbl_net                        = 'Network',
        diag_lbl_hook                       = 'Hooks',
        title_konsole                       = 'Konsole',
        title_updates                       = 'Updates',
        tooltip_close                       = 'close',
        tooltip_act_refresh                 = 'refresh data',
        unknown                             = 'unknown',
        untitled                            = 'untitled',
        ui_tip_minimize                     = 'minimize',
        ui_tip_close                        = 'close',
        user_add                            = '+ user » [ %s ]',
        user_add_root                       = '+ root user » [ %s ]',
        user_edited                         = '% user » [ %s ]',
        user_remove                         = '- user » [ %s ]',
        user_updated                        = '~ user » [ %s ]',
        user_noremove_root                  = 'cannot remove protected root user » %s',
        user_add_success                    = 'successfully added player ',
        user_find_noply                     = 'no valid player found',
        user_find_noply_one                 = 'no valid player found » make sure you are fully loaded in-game and the name is spelt correctly',
        user_find_quotes_ex                 = '"John Doe"',
        user_find_multires                  = 'More than one result was found, type more of the name. Place in quotes for names with spaces. Example: ',
        user_find_nores                     = 'No results found! Place in quotes for names with spaces. Example: ',
        user_find_nores_one                 = 'No results found! » make sure you are fully loaded in-game and the name is spelt correctly',
        user_find_exists                    = 'user already has access',
        user_find_errmsg                    = 'You must supply at least a valid partial player name',
        util_nil                            = 'nil',
        util_s32_noconvert                  = 'cannot convert invalid steam32 » %s',
        util_s64_noconvert                  = 'cannot convert invalid steam64 » %s',
        updates_maxnum                      = '99+',
        setup_cmd_disabled                  = 'command has been disabled » contact the server owner',
        setup_root_exists                   = 'server is registered to user » ',
        setup_root_give_sa                  = 'must give yourself superadmin group first',
        search_no_results                   = 'no results found',
        welcome_title                       = 'Welcome',
        ws_no_steam_data                    = 'no steam data',
        ws_no_response                      = 'no response from steam workshop » %s',
        ws_no_json_response                 = 'bad workshop » %s',
        ws_response_empty                   = 'response from steam workshop empty -- down?',
        ws_registered                       = '+ %s » %s',
        sys_user_type                       = 'BOT',
        sys_gm_darkrp                       = 'DarkRP',
        sys_gm_sandbox                      = 'Sandbox',
        sys_gm_unknown                      = 'Unknown',
        sys_host_untitled                   = 'unnamed_server',
        sys_os_windows                      = 'Windows',
        sys_os_linux                        = 'Linux',
        sys_os_ukn                          = 'Unknown',
        timestamp_never                     = 'never',
        sym_sp                              = '------------------------------------------------------------------------------------------------------------------',
        sym_bracket_str                     = '[ %s ]',
        sym_bracket_int                     = '[ %i ]',
        sym_bracket_double                  = '[ %02d ]',
        logs_modules_total                  = '[ %02d ] ......... modules total',
        logs_modules_active                 = '[ %02d ] ......... modules active',
        logs_modules_err                    = '[ %02d ] ......... modules err',
        logs_modules_disabled               = '[ %02d ] ......... modules disabled',
        logs_modules_loadtime               = '%s to load modules',
        logs_rcore_mnfst_err                = 'missing module manifest',
        logs_rcore_id_err                   = 'missing id for module',
        logs_rcore_mt_err                   = 'error occured setting the metatable',
        logs_rcore_mt_ok                    = 'metatable generated',
        logs_rcore_func_err                 = '[ %s ] » missing function',
        logs_rcore_mod_disabled             = 'module disabled » %s',
        logs_rcore_mnfst_ok                 = '+ manifest » %s',
        logs_rcore_storage_ok               = '+ storage » [ %s ] » %s',
        logs_rcore_demomode                 = '  + demo » [ %s ]',
        logs_inf_pnl_assert                 = 'pnl registration failed » invalid class name %s',
        logs_inf_regclass_err               = 'cannot make interface element with missing class'
    },
}