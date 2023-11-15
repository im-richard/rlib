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
local helper                = base.h
local storage               = base.s

/*
    library > localize
*/

local mf                    = base.manifest
local pf                    = mf.prefix

/*
    languages
*/

local function ln( ... )
    return base:lang( ... )
end

/*
    prefix > create id
*/

local function cid( id, suffix )
    local affix     = istable( suffix ) and suffix.id or isstring( suffix ) and suffix or pf
    affix           = affix:sub( -1 ) ~= '.' and string.format( '%s.', affix ) or affix

    id              = isstring( id ) and id or 'noname'
    id              = id:gsub( '[%p%c%s]', '.' )

    return string.format( '%s%s', affix, id )
end

/*
    prefix > get id
*/

local function pid( str, suffix )
    local state = ( isstring( suffix ) and suffix ) or ( base and pf ) or false
    return cid( str, state )
end

/*
*   storage > data > set
*
*   @usage  : storage:Set( mod, 'name', 1 )
*
*   @param  : tbl mod
*   @param  : str id
*   @param  : str val
*/

function storage:Set( mod, id, val )
    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] ) then
        rcore.modules[ mod ][ id ] = val
    elseif istable( mod ) then
        mod[ id ] = val
    end
end

/*
*   storage > data > get
*
*   @usage  : storage:Get( mod, 'name' )
*
*   @param  : tbl mod
*   @param  : str id
*   @return : mix
*/

function storage:Get( mod, id )
    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] ) then
        return rcore.modules[ mod ][ id ] or false
    elseif istable( mod ) then
        return mod[ id ] or false
    end
end

/*
*   storage > data > clear
*
*   @usage  : storage:clear( mod, 'name' )
*
*   @param  : tbl mod
*   @param  : str id
*/

function storage:Clear( mod, id )
    if istable( rcore ) and ( isstring( mod ) and rcore.modules[ mod ] ) then
        rcore.modules[ mod ][ id ] = nil
    elseif istable( mod ) then
        mod[ id ] = nil
    end
end

/*
*   storage > garbage
*
*   loops through the provided table and sets objects to nil rendering them deleted.
*   Used to cleanup objects no longer needed by the system.
*
*   @usage  : storage.garbage( 'id', { object_1, object2, ... } )
*   @ex     : storage.garbage( 'autoloader_manifest_modules', { sys.loadpriority, sys.loadtime } )
*
*   @param  : str id
*   @param  : tbl trash
*/

function storage.garbage( id, trash )
    id = id or ln( 'unknown' )

    if not trash or not istable( trash ) then
        rlib:log( 2, ln( 'garbage_err', id ) )
        return
    end

    local i = 0
    for _, v in pairs( trash ) do
        v = nil
        i = i + 1
    end

    rlib:log( 6, ln( 'garbage_cleaned', i, id ) )
end

/*
*   storage > exists
*
*   checks if a path / file exists
*   can support either a data folder path or a manifest path key
*
*   @ex     : storage.exists( 'path/to/file.txt' )
*
*   @param  : str path
*/

function storage.exists( path )
    return file.Exists( mf.paths[ path ] or path, 'DATA' ) and true or false
end

/*
*   storage > dir > create
*
*   creates a new directory based on the specified parameters
*
*   @param  : str name
*   @param  : str path
*/

function storage.dir.create( name, path )
    name = name or storage.mft:getpath( 'base' )
    path = path or 'DATA'
    if not file.Exists( name, path ) then
        file.CreateDir( name )
        rlib:log( RLIB_LOG_DEBUG, '+ dir » [ %s ]', name )
    end
end

/*
*   storage > dir > new structure
*
*   creates a new set of folders within the data folder for storage of a feature
*
*   @param  : str parent
*   @param  : str sub [optional]
*   @param  : str sub2 [optional]
*/

function storage.dir.newstruct( parent, sub, sub2 )

    if CLIENT then return end

    if not parent then
        rlib:log( 6, ln( 'datafolder_missing' ) )
        return false
    end

    local fol_parent = tostring( parent )

    if not helper:bIsAlphaNum( fol_parent ) then
        rlib:log( 2, ln( 'datafolder_inv_chars' ) )
        return false
    end

    if not file.Exists( fol_parent, 'DATA' ) then
        file.CreateDir( fol_parent )
        rlib:log( 6, ln( 'datafolder_add', fol_parent ) )
    end

    if not sub then return end

    local fol_sub = tostring( sub )

    if not helper:bIsAlphaNum( fol_sub ) then
        rlib:log( 2, ln( 'datafolder_sub_inv_chars' ) )
        return false
    end

    if not file.Exists( fol_parent .. '/' .. fol_sub, 'DATA' ) then
        file.CreateDir( fol_parent .. '/' .. fol_sub )
        rlib:log( 6, ln( 'datafolder_sub_add', fol_sub ) )
    end

    if not sub2 then return end

    local fol_sub2 = tostring( sub2 )

    if not helper:bIsAlphaNum( fol_sub2 ) then
        rlib:log( 2, ln( 'datafolder_sub_inv_chars' ) )
        return false
    end

    if not file.Exists( fol_parent .. '/' .. fol_sub .. '/' .. fol_sub2, 'DATA' ) then
        storage.dir.create( fol_parent .. '/' .. fol_sub .. '/' .. fol_sub2 )
        rlib:log( 6, ln( 'datafolder_sub_add', fol_sub2 ) )
    end

end

/*
*   storage > json > new
*
*   creates a basic blank json file
*
*	@call	: storage.json.new( path/to/file.txt )
*
*	@param	: str path
*/

function storage.json.new( path )
    if not isstring( path ) then return end
    if storage.exists( path ) then return end

    file.Write( path, util.TableToJSON( { } ) )
end

/*
*   storage > json > write
*
*   converts table to json and writes to the specified file
*
*	@call	: storage.json.write( path/to/file.txt, table )
*
*	@param	: str path
*   @param  : tbl data
*/

function storage.json.write( path, data )
    if not isstring( path ) then return end

    data        = istable( data ) and data or { }
    local json  = util.TableToJSON( data )

    file.Write( path, json )
end

/*
*   storage > json > read
*
*   returns data stored in a specified data file
*   converts the data from json to a lua table
*
*   custom error msg can be specified
*
*   @ex     : storage.json.read( 'path/to/file.txt' )
*
*   @param  : str path
*   @param  : str errmsg
*   @return : tbl
*/

function storage.json.read( path, errmsg )
    if not storage.exists( path, 'DATA' ) then
        rlib:log( 6, errmsg or 'cannot read missing data file' )
        return
    end

    local data = util.JSONToTable( file.Read( path, 'DATA' ) )

    return data or nil
end

/*
*   storage > json > valid
*
*   returns if valid data was found
*
*   accepts id param used for purposes outside of confirming
*   entities. default id param is 'pos'
*
*   @ex     : storage.json.valid( data )
*             storage.json.valid( data, 'pos' )
*
*   @param  : tbl data
*   @param  : str id
*   @return : tbl
*/

function storage.json.valid( data, id )
    if not istable( data ) then return false end
    id = isstring( id ) and id or 'pos'

    return ( data and data[ 1 ] and data[ 1 ][ id ] ) or ( data and data[ id ] and true ) or false
end

/*
*   storage > manifest > get
*
*   returns a storage path
*   will output to default bin folder if path does not exist
*
*   @ex     : storage.mft:getpath( 'dir_logs' )
*
*   @param  : str id
*/

function storage.mft:getpath( id )
    if not id or ( not mf.paths[ id ] and not storage.exists( id ) ) then id = mf.paths[ 'bin' ] end
    id = isstring( mf.paths[ id ] ) and mf.paths[ id ] or id

    return id
end

/*
*   storage > file > del
*
*   deletes a path
*   can support either a data folder path or a manifest path key
*
*   @ex     : storage.file.del( 'rlib/path' )
*
*   @param  : str src
*/

function storage.file.del( src )
    if not src or ( not mf.paths[ src ] and not storage.exists( src ) ) then return end
    src = isstring( mf.paths[ src ] ) and mf.paths[ src ] or src

    if storage.exists( src ) then
        file.Delete( src )
        return true
    end
    return false
end

/*
*   storage > file > append
*
*   adds additional data to eof
*
*   @param  : str name
*   @param  : str target
*   @param  : str data
*   @param  : str path
*/

function storage.file.append( name, target, data, path )
    if CLIENT then return end

    name = name or storage.mft:getpath( 'base' )
    path = path or 'DATA'

    if not target then
        rlib:log( 2, 'cannot append without filename' )
        return
    end

    if not data then
        rlib:log( 2, 'cannot append blank data' )
        return
    end

    if not file.Exists( name, path ) then
        storage.dir.create( name, path )
    end

    if file.Exists( name, path ) then
        file.Append( name .. '/' .. target, data )
        file.Append( name .. '/' .. target, '\r\n' )
    end
end

/*
*   storage > data > manifest
*
*   creates new data folders
*   can support either a data folder path or a manifest path key
*   checks to ensure a shortcut from the manifest has not be used that is already a file name
*
*   @ex :   storage.data.manifest( 'rlib/path' )
*           >  creates folder rlib/path
*
*   @ex :   storage.data.manifest( 'dir_server' )
*           >  creates folder rlib/actions from manifest.paths table key
*
*   @param  : str path
*/

function storage.data.manifest( path )
    if not path then return end

    local src = isstring( mf.paths[ path ] ) and mf.paths[ path ] or path
    local ext = src:match( '^.+(%..+)$' )

    if ext then
        rlib:log( 2, 'manifest file or filename specified » not a folder » [ %s ]', src )
        return false
    end

    if not storage.exists( src ) then
        file.CreateDir( mf.paths[ path ] or path )
        rlib:log( RLIB_LOG_DEBUG, '+ dir [ %s ]', path )
    end
end

/*
*   storage > data > recursive loading
*
*   cycle through files and folders at root and sub levels
*
*   @param  : str name
*   @param  : str path
*   @param  : str loc [optional]
*/

function storage.data.recurv( name, path, loc )
    if CLIENT then return end

    name = name or storage.mft:getpath( 'base' )

    if not path then
        rlib:log( 6, 'cannot add resource files without path » %s', tostring( name ) )
        return false
    end

    loc = loc or 'LUA'

    local files, folders = file.Find( path .. '/*', loc )

    /*
    *   add folders
    */

    for _, v in pairs( folders ) do
        storage.data.recurv( name, path .. '/' .. v, loc )
    end

    /*
    *   add files
    */

    for _, v in pairs( files ) do
        resource.AddFile( path .. '/' .. v )
        rlib:log( RLIB_LOG_FASTDL, '+ %s » [ %s ]', tostring( name ), v )
    end
end

/*
*   storage > data > get
*
*   returns data from MODULE.datafolder table based on id provided
*
*	@call	: storage.data.get( mod, 1 )
*           : storage.data.get( mod, 2 )
*           : storage.data.get( mod, 1, ply:SteamID64( ) )
*           : storage.data.get( mod, 1, pl:SteamID64( ), false, true )
*
*   @ex     : local par, sub, txt = storage.data.get( mod, 1 )
*             local par, sub, txt = storage.data.get( mod, 'str_name' )
*
*   @param  : bReadOnly
*             if true, file will NOT be created if it doesnt exist.
*             used for functions that rely on the file to be there with valid data
*
*	@param	: tbl mod
*	@param	: int, str id
*   @param  : str fi
*   @param  : bool bCombine
*   @param  : bool bReadOnly
*   @return : str, str, str
*/

function storage.data.get( mod, id, fi, bCombine, bReadOnly )
    local parent, sub, txt
    local data = mod and mod.datafolder and mod.datafolder[ id ] or nil

    if not istable( data ) then
        rlib:log( 2, '[ %s ] datafolder id %s does not exist, misspelled, or missing datafolder in manifest\n\n%s', ( mod.id or 'unknown mod' ), tostring( id ), debug.traceback( ) )
        return
    end

    if not isstring( data.parent ) then
        rlib:log( 2, '[ %s ] data found but missing parent folder', ( mod.id or 'unknown mod' ) )
        return
    end

    if not isstring( data.sub ) then
        rlib:log( 2, '[ %s ] data found but missing sub folder', ( mod.id or 'unknown mod' ) )
        return
    end

    /*
    *   define > MODULE.datafolder[ parent ]
    */

    if data.parent then
        parent = data.parent
    end

    /*
    *   define > MODULE.datafolder[ sub ]
    */

    if data.sub then
        sub = data.sub
    end

    /*
    *   define > MODULE.datafolder[ file ]
    */

    if not fi and data.file then
        txt = data.file
    end

    /*
    *   define > custom file.txt if defined as param
    */

    if fi then
        txt = fi
    end

    /*
    *   check > parent folder blank
    */

    if not parent then
        rlib:log( 2, '[ %s ] error attempting to gather datafolder parent -- will not continue', ( mod.id or 'unknown mod' ) )
        return
    end

    /*
    *   create parent and sub folder (not file)
    */

    storage.dir.newstruct( parent, sub )

    /*
    *   create full path
    */

    local full_path = string.format( '%s/%s/%s.txt', parent, sub, txt )

    /*
    *   create file if not exists
    */

    if not bReadOnly then
        storage.json.new( full_path )
    end

    /*
    *   return
    */

    return ( not bReadOnly and bCombine and full_path ) or parent, sub, txt
end

/*
*   storage > data > read
*
*   returns data from MODULE.datafolder table based on id provided
*
*	@call	: storage.data.read( mod, 1 )
*           : storage.data.read( mod, 2 )
*           : storage.data.read( mod, 1, ply:SteamID64( ) )
*           : storage.data.read( mod, 1, pl:SteamID64( ), false, true )
*
*   @ex     : local par, sub, txt = storage.data.read( mod, 1 )
*             local par, sub, txt = storage.data.read( mod, 'str_name' )
*
*	@param	: tbl mod
*	@param	: int, str id
*   @param  : str fi
*   @param  : bool bCombine
*   @return : str, str, str
*/

function storage.data.read( mod, id, fi, bCombine )
    local parent, sub, txt
    local data = mod and mod.datafolder and mod.datafolder[ id ] or nil

    if not istable( data ) then
        rlib:log( 2, '[ %s ] datafolder id %s does not exist, misspelled, or missing datafolder in manifest\n\n%s', ( mod.id or 'unknown mod' ), tostring( id ), debug.traceback( ) )
        return
    end

    if not isstring( data.parent ) then
        rlib:log( 2, '[ %s ] data found but missing parent folder', ( mod.id or 'unknown mod' ) )
        return
    end

    if not isstring( data.sub ) then
        rlib:log( 2, '[ %s ] data found but missing sub folder', ( mod.id or 'unknown mod' ) )
        return
    end

    /*
    *   define > MODULE.datafolder[ parent ]
    */

    if data.parent then
        parent = data.parent
    end

    /*
    *   define > MODULE.datafolder[ sub ]
    */

    if data.sub then
        sub = data.sub
    end

    /*
    *   define > MODULE.datafolder[ file ]
    */

    if not fi and data.file then
        txt = data.file
    end

    /*
    *   define > custom file.txt if defined as param
    */

    if fi then
        txt = fi
    end

    /*
    *   check > parent folder blank
    */

    if not parent then
        rlib:log( 2, '[ %s ] error attempting to gather datafolder parent -- will not continue', ( mod.id or 'unknown mod' ) )
        return
    end

    /*
    *   create parent and sub folder (not file)
    */

    storage.dir.newstruct( parent, sub )

    /*
    *   create full path
    */

    local full_path = string.format( '%s/%s/%s.txt', parent, sub, txt )

    /*
    *   return
    */

    return ( bCombine and full_path ) or parent, sub, txt
end

/*
*   storage > ent > get
*
*   returns the table associated to a specified ent
*   data comes from module manifest file within MODULE.ents
*
*	@call	: storage.ent:get( mod, 1 )
*             storage.ent:get( mod, 'str_name' )
*
*	@param	: tbl mod
*	@param	: str, int id
*/

function storage.ent:get( mod, id )
    return mod and mod.ents and mod.ents[ id ] or nil
end

/*
*   storage > ent > data
*
*   looks for a valid manifest data_id value located in the MODULE.ents table.
*   if missing, will then search the MODULE.datafolder table for the raw table key
*   as an entry.
*
*	@call	: storage.ent:datafolder( mod, 'str_name' )
*           : storage.ent:datafolder( mod, 2 )
*           : storage.ent:datafolder( mod, 1, 'ent_name' )
*
*   @ex     : local par, sub, txt, en = storage.ent:datafolder( mod, ent )
*             local par, sub, txt, en = storage.ent:datafolder( mod, 'str_name' )
*
*   @since  : v3.0.0
*	@param	: tbl mod
*	@param	: int, str ent
*   @param  : str sub2
*   @return : str, str, str, tbl
*/

function storage.ent:datafolder( mod, ent, sub2 )
    local parent, sub, txt
    local data          = mod and mod.ents and mod.ents[ ent ] and ( mod.ents[ ent ].data or mod.ents[ ent ].data_id ) or nil
    local ent_data      = mod and mod.ents and mod.ents[ ent ] or nil

    if data and ( mod and mod.datafolder and mod.datafolder[ data ] ) then
        data = mod.datafolder[ data ]
    end

    if not istable( data ) then
        rlib:log( 2, '[ %s ] ent %s data missing. make sure MODULE.ents[ entry ] has data_id value \n\n%s', ( mod.id or 'unknown mod' ), ent, debug.traceback( ) )
        return
    end

    if not isstring( data.parent ) then
        rlib:log( 2, '[ %s ] data found but missing parent folder', ( mod.id or 'unknown mod' ) )
        return
    end

    if not isstring( data.sub ) then
        rlib:log( 2, '[ %s ] data found but missing sub folder', ( mod.id or 'unknown mod' ) )
        return
    end

    /*
    *   define > MODULE.datafolder[ parent ]
    */

    if data.parent then
        parent = data.parent
    end

    /*
    *   define > MODULE.datafolder[ sub ]
    */

    if data.sub then
        sub = data.sub
    end

    /*
    *   define > MODULE.datafolder[ file ]
    */

    if not sub2 and data.file then
        txt = data.file
    end

    /*
    *   define > custom file.txt if defined as param
    */

    if sub2 then
        txt = string.format( '%s/%s', sub2, data.file )
    end

    /*
    *   check > parent folder blank
    */

    if not parent then
        rlib:log( 2, '[ %s ] error attempting to gather datafolder parent -- will not continue', ( mod.id or 'unknown mod' ) )
        return
    end

    /*
    *   create parent and sub folder (not file)
    */

    if sub2 then
        storage.dir.newstruct( parent, sub, sub2 )
    else
        storage.dir.newstruct( parent, sub )
    end

    /*
    *   create data file
    */

    local full_path = string.format( '%s/%s/%s.txt', parent, sub, txt )
    storage.json.new( full_path )

    return parent, sub, txt, ent_data
end

/*
*   storage > ent > id
*
*   returns the id ( str ) associated to a specified ent
*   data comes from module manifest file within MODULE.ents
*
*   returns either field named [ id ] or [ ent ]
*
*	@call	: storage.ent.id( mod, 1 )
*             storage.ent.id( mod, 'str_name' )
*             returns 'ent_name'
*
*	@param	: tbl mod
*	@param	: str, int id
*   @return : str
*/

function storage.ent.id( mod, id )
    return ( mod and mod.ents and mod.ents[ id ] and ( mod.ents[ id ].ent or mod.ents[ id ].id ) ) or nil
end

/*
*   storage > ent > model
*
*   returns the model ( str ) associated to a specified ent
*   data comes from module manifest file within MODULE.ents
*
*   returns either field named [ mdl ] or [ model ]
*
*	@call	: storage.get.mdl( mod, 1 )
*             storage.ent.mdl( mod, 'str_name' )
*             returns '/path/to/model.mdl'
*
*	@param	: tbl mod
*	@param	: str, int id
*   @return : str
*/

function storage.ent.mdl( mod, id )
    return ( mod and mod.ents and mod.ents[ id ] and ( mod.ents[ id ].model or mod.ents[ id ].mdl ) ) or nil
end

/*
    storage > ent > locate

    gets the registered env name of an ent based on the classname

    local ent = storage.ent.locate( mod, 'rlib_ent_classname' )
    returns table

    @param	: tbl mod
    @param	: str, int id
    @return : tbl
*/

function storage.ent.locate( mod, id )
    local bFound = false
    for k, v in pairs( mod.ents ) do
        if v.ent == id then
            v.id = k
            bFound = v
            break
        end
    end

    return bFound
end

/*
*   storage > glon > get
*
*   returns data from MODULE.datafolder table based on id provided
*   ensure that bReadOnly = true if performing functions such as
*   theme hash generation
*
*	@call	: storage.glon.get( mod, 1 )
*           : storage.glon.get( mod, 2 )
*           : storage.glon.get( mod, 1, ply:SteamID64( ) )
*
*   @ex     : local par, sub, txt = storage.glon.get( mod, 1 )
*             local par, sub, txt = storage.glon.get( mod, 'str_name' )
*
*	@param	: tbl mod
*	@param	: int, str id
*   @param  : str fi
*   @param  : bool bCombine
*   @param  : bool bReadOnly
*   @return : str || str, str, str
*/

function storage.glon.get( mod, id, fi, bCombine, bReadOnly )
    if not glon then
        rlib:log( 2, ln( 'glon_missing' ) )
        return
    end

    local parent, sub, txt
    local data = mod and mod.datafolder and mod.datafolder[ id ] or nil

    if not istable( data ) then
        rlib:log( 2, '[ %s ] [ glon ] datafolder id %s does not exist, misspelled, or missing datafolder in manifest\n\n%s', ( mod.id or 'unknown mod' ), tostring( id ), debug.traceback( ) )
        return
    end

    if not isstring( data.parent ) then
        rlib:log( 2, '[ %s ] [ glon ] data found but missing parent folder', ( mod.id or 'unknown mod' ) )
        return
    end

    if not isstring( data.sub ) then
        rlib:log( 2, '[ %s ] [ glon ] data found but missing sub folder', ( mod.id or 'unknown mod' ) )
        return
    end

    /*
    *   define > MODULE.datafolder[ parent ]
    */

    if data.parent then
        parent = data.parent
    end

    /*
    *   define > MODULE.datafolder[ sub ]
    */

    if data.sub then
        sub = data.sub
    end

    /*
    *   define > MODULE.datafolder[ file ]
    */

    if not fi and data.file then
        txt = data.file
    end

    /*
    *   define > custom file.txt if defined as param
    */

    if fi then
        txt = fi
    end

    /*
    *   check > parent folder blank
    */

    if not parent then
        rlib:log( 2, '[ %s ] [ glon ] error attempting to gather datafolder parent -- will not continue', ( mod.id or 'unknown mod' ) )
        return
    end

    /*
    *   create parent and sub folder (not file)
    */

    storage.dir.newstruct( parent, sub )

    /*
    *   create data file
    */

    local full_path = string.format( '%s/%s/%s.txt', parent, sub, txt )

    /*
    *   create file if not exists
    */

    if not bReadOnly then
        storage.glon.new( full_path )
    end

    /*
    *   return
    */

    return ( not bReadOnly and bCombine and full_path ) or parent, sub, txt
end

/*
*   storage > glon > new
*
*   creates a basic blank glon json file
*
*	@call	: storage.json.new( path/to/file.txt )
*
*	@param	: str path
*/

function storage.glon.new( path )
    if not isstring( path ) then return end
    if storage.exists( path ) then return end

    local data = { }
    file.Write( path, glon.encode( data ) )
end

/*
*   storage > glon > save
*
*   stores data using the glon module into the specified file in the data folder
*   if no path is specified, data will be saved in /data/rlib
*
*   requires glon module to be installed (comes with rlib)
*
*   @ex     : storage.glon.save( { }, 'path/to/file.txt' )
*           : storage.glon.save( data_var, 'file.text', 'folder' )
*
*   @param  : tbl data
*   @param  : str path
*/

function storage.glon.save( data, path )
    if not glon then
        rlib:log( 2, ln( 'glon_missing' ) )
        return
    end

    if not istable( data ) then
        rlib:log( 2, ln( 'glon_save_err_data' ) )
        return
    end

    if not isstring( path ) then
        rlib:log( 2, 'cannot save glon data -- missing valid path' )
        return
    end

    file.Write( path, glon.encode( data ) )

    rlib:log( 6, ln( 'glon_save', path ) )
end

/*
*   storage > glon > read
*
*   reads saved data using the glon module from a specified file in the data folder
*   if no path is specified, data will be saved in /data/rlib
*
*   requires glon module to be installed (comes with rlib)
*
*   @ex     : storage.glon.read( 'file.text' )
*           : storage.glon.read( 'file.text', 'folder' )
*
*   @param  : str src
*   @param  : str path [optional]
*   @return : tbl
*/

function storage.glon.read( path )
    if not glon then
        rlib:log( 2, ln( 'glon_missing' ) )
        return false
    end

    if not isstring( path ) then
        rlib:log( 2, 'cannot read glon data -- missing valid path' )
        return false
    end

    if not file.Exists( path, 'DATA' ) then
        rlib:log( 2, ln( 'glon_err_path', path ) )
        return false
    end

    local data = file.Read( path, 'DATA' )
    if not data or data == '[]' then
        rlib:log( 2, 'invalid glon data referenced -- resetting' )
        file.Delete( path, 'DATA' )
    end

    local decode = data and glon.decode( data ) or nil

    return decode
end