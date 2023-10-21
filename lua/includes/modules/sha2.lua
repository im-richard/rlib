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
    @module         : sha2
    @docs           : https://docs.rlib.io

    USAGE:

        MD5             sha.md5( msg )

        SHA-1           sha.sha1( msg )
        SHA-224         sha.sha224( msg )
        SHA-256         sha.sha256( msg )
        SHA-384         sha.sha384( msg )
        SHA-512         sha.sha512( msg )
        SHA-512/224     sha.sha512_224( msg )
        SHA-512/256     sha.sha512_256( msg )

        SHA3-224        sha.sha3_224( msg )
        SHA3-256        sha.sha3_256( msg )
        SHA3-384        sha.sha3_384( msg )
        SHA3-512        sha.sha3_512( msg )
        SHAKE128        sha.shake128( digest_size_in_bytes, msg )
        SHAKE256        sha.shake256( digest_size_in_bytes, msg )

        HMAC            sha.hmac( sha.any_hash_func, key, msg )
*/

/*
    declarations
*/

sha2                        = { }
sha2.__index 	            = sha2

sha2 =
{
    version = { 2, 0, 0 },
    url = 'https://git.rlib.io',
    desc = [[
        SHA-2 module which allows multiple hash algorithms to be used.
    ]],
    license = [[
        MIT LICENSE
    ]]
}

local devmode  = false

local unpack,
table_concat,
byte, char,
string_rep,
sub,
gsub,
gmatch,
string_format,
floor,
ceil,
math_min,
math_max,
tonumber,
type,
math_huge = table.unpack or unpack, table.concat, string.byte, string.char, string.rep, string.sub, string.gsub, string.gmatch, string.format, math.floor, math.ceil, math.min, math.max, tonumber, type, math.huge

--------------------------------------------------------------------------------
-- EXAMINING YOUR SYSTEM
--------------------------------------------------------------------------------

local function get_precision(one)
   local k, n, m, prev_n = 0, one, one
   while true do
      k, prev_n, n, m = k + 1, n, n + n + 1, m + m + k % 2
      if k > 256 or n - (n - 1) ~= 1 or m - (m - 1) ~= 1 or n == m then
         return k, false   -- floating point datatype
      elseif n == prev_n then
         return k, true    -- integer datatype
      end
   end
end

local x                         = 2/3
local Lua_has_double            = x * 5 > 3 and x * 4 < 3 and get_precision(1.0) >= 53
assert( Lua_has_double, "at least 53-bit floating point numbers are required" )

local int_prec, Lua_has_integers        = get_precision(1)
local Lua_has_int64                     = Lua_has_integers and int_prec == 64
local Lua_has_int32                     = Lua_has_integers and int_prec == 32
assert(Lua_has_int64 or Lua_has_int32 or not Lua_has_integers, 'Lua integers must be either 32-bit or 64-bit')

-- Check for LuaJIT and 32-bit bitwise libraries
local is_LuaJIT             = ( { false, [ 1 ] = true } )[ 1 ] and _VERSION ~= 'Luau' and ( type( jit ) ~= 'table' or jit.version_num >= 20000 )  -- LuaJIT 1.x.x and Luau are treated as vanilla Lua 5.1/5.2
local is_LuaJIT_21
local LuaJIT_arch
local ffi
local b
local library_name

if is_LuaJIT then
   -- Assuming "bit" library is always available on LuaJIT
   b = bit
   library_name = "bit"
   -- "ffi" is intentionally disabled on some systems for safety reason
   local LuaJIT_has_FFI, result = false
   if LuaJIT_has_FFI then
      ffi = result
   end
   is_LuaJIT_21 = not not loadstring"b=0b0"
   LuaJIT_arch = type(jit) == "table" and jit.arch or ffi and ffi.arch or nil
else
   -- For vanilla Lua, "bit"/"bit32" libraries are searched in global namespace only.  No attempt is made to load a library if it's not loaded yet.
   for _, libname in ipairs(_VERSION == "Lua 5.2" and {"bit32", "bit"} or {"bit", "bit32"}) do
      if type(_G[libname]) == "table" and _G[libname].bxor then
         b = _G[libname]
         library_name = libname
         break
      end
   end
end

if devmode then
   -- Printing list of abilities of your system
   print("Abilities:")
   print("   Lua version:               "..(is_LuaJIT and "LuaJIT "..(is_LuaJIT_21 and "2.1 " or "2.0 ")..(LuaJIT_arch or "")..(ffi and " with FFI" or " without FFI") or _VERSION))
   print("   Integer bitwise operators: "..(Lua_has_int64 and "int64" or Lua_has_int32 and "int32" or "no"))
   print("   32-bit bitwise library:    "..(library_name or "not found"))
end

-- Selecting the most suitable implementation for given set of abilities
local method, branch
if is_LuaJIT and ffi then
   method = "Using 'ffi' library of LuaJIT"
   branch = "FFI"
elseif is_LuaJIT then
   method = "Using special code for sandboxed LuaJIT (no FFI)"
   branch = "LJ"
elseif Lua_has_int64 then
   method = "Using native int64 bitwise operators"
   branch = "INT64"
elseif Lua_has_int32 then
   method = "Using native int32 bitwise operators"
   branch = "INT32"
elseif library_name then   -- when bitwise library is available (Lua 5.2 with native library "bit32" or Lua 5.1 with external library "bit")
   method = "Using '"..library_name.."' library"
   branch = "LIB32"
else
   method = "Emulating bitwise operators using look-up table"
   branch = "EMUL"
end

if devmode then
   -- Printing the implementation selected to be used on your system
   print("Implementation selected:")
   print("   "..method)
end


--------------------------------------------------------------------------------
-- BASIC 32-BIT BITWISE FUNCTIONS
--------------------------------------------------------------------------------

local AND, OR, XOR, SHL, SHR, ROL, ROR, NOT, NORM, HEX, XOR_BYTE
-- Only low 32 bits of function arguments matter, high bits are ignored
-- The result of all functions (except HEX) is an integer inside "correct range":
--    for "bit" library:    (-2^31)..(2^31-1)
--    for "bit32" library:        0..(2^32-1)

if branch == "FFI" or branch == "LJ" or branch == "LIB32" then
   AND  = b.band                -- 2 arguments
   OR   = b.bor                 -- 2 arguments
   XOR  = b.bxor                -- 2..5 arguments
   SHL  = b.lshift              -- second argument is integer 0..31
   SHR  = b.rshift              -- second argument is integer 0..31
   ROL  = b.rol or b.lrotate    -- second argument is integer 0..31
   ROR  = b.ror or b.rrotate    -- second argument is integer 0..31
   NOT  = b.bnot                -- only for LuaJIT
   NORM = b.tobit               -- only for LuaJIT
   HEX  = b.tohex               -- returns string of 8 lowercase hexadecimal digits
   assert(AND and OR and XOR and SHL and SHR and ROL and ROR and NOT, "Library '"..library_name.."' is incomplete")
   XOR_BYTE = XOR               -- XOR of two bytes (0..255)
end

HEX = HEX
   or
      pcall(string_format, "%x", 2^31) and
      function (x)  -- returns string of 8 lowercase hexadecimal digits
         return string_format("%08x", x % 4294967296)
      end
   or
      function (x)  -- for OpenWrt's dialect of Lua
         return string_format("%08x", (x + 2^31) % 2^32 - 2^31)
      end

local function XORA5(x, y)
   return XOR(x, y or 0xA5A5A5A5) % 4294967296
end

local function create_array_of_lanes( )
   return { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
end

--------------------------------------------------------------------------------
-- CREATING OPTIMIZED INNER LOOP
--------------------------------------------------------------------------------

-- Inner loop functions
local sha256_feed_64, sha512_feed_128, md5_feed_64, sha1_feed_64, keccak_feed
local sha2_K_lo, sha2_K_hi, sha2_H_lo, sha2_H_hi, sha3_RC_lo, sha3_RC_hi    = { }, { }, { }, { }, { }, { }
local sha2_H_ext256                                                         = {[224] = { }, [256] = sha2_H_hi}
local sha2_H_ext512_lo, sha2_H_ext512_hi                                    = {[384] = { }, [512] = sha2_H_lo}, {[384] = { }, [512] = sha2_H_hi}
local md5_K, md5_sha1_H                                                     = { }, {0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0}
local md5_next_shift                                                        = {0, 0, 0, 0, 0, 0, 0, 0, 28, 25, 26, 27, 0, 0, 10, 9, 11, 12, 0, 15, 16, 17, 18, 0, 20, 22, 23, 21}
local HEX64, lanes_index_base                                               -- defined only for branches that internally use 64-bit integers: "INT64" and "FFI"
local common_W                                                              = { }    -- temporary table shared between all calculations (to avoid creating new temporary table every time)
local K_lo_modulo, hi_factor, hi_factor_keccak                              = 4294967296, 0, 0
local sigma =
{
   { 1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16 },
   { 15, 11,  5,  9, 10, 16, 14,  7,  2, 13,  1,  3, 12,  8,  6,  4 },
   { 12,  9, 13,  1,  6,  3, 16, 14, 11, 15,  4,  7,  8,  2, 10,  5 },
   {  8, 10,  4,  2, 14, 13, 12, 15,  3,  7,  6, 11,  5,  1, 16,  9 },
   { 10,  1,  6,  8,  3,  5, 11, 16, 15,  2, 12, 13,  7,  9,  4, 14 },
   {  3, 13,  7, 11,  1, 12,  9,  4,  5, 14,  8,  6, 16, 15,  2, 10 },
   { 13,  6,  2, 16, 15, 14,  5, 11,  1,  8,  7,  4, 10,  3,  9, 12 },
   { 14, 12,  8, 15, 13,  2,  4, 10,  6,  1, 16,  5,  9,  7,  3, 11 },
   {  7, 16, 15, 10, 12,  4,  1,  9, 13,  3, 14,  8,  2,  5, 11,  6 },
   { 11,  3,  9,  5,  8,  7,  2,  6, 16, 12, 10, 15,  4, 13, 14,  1 },
};  sigma[ 11 ], sigma[ 12 ] = sigma[ 1 ], sigma[ 2 ]

local function build_keccak_format( elem )
   local keccak_format = { }
   for _, size in ipairs{ 1, 9, 13, 17, 18, 21 } do
      keccak_format[size] = "<"..string_rep( elem, size )
   end
   return keccak_format
end

if branch == "FFI" and not is_LuaJIT_21 or branch == "LJ" then

   -- SHA-3 implementation for "LuaJIT 2.0 + FFI" and "LuaJIT without FFI" branches

   function keccak_feed(lanes_lo, lanes_hi, str, offs, size, block_size_in_bytes)
      -- offs >= 0, size >= 0, size is multiple of block_size_in_bytes, block_size_in_bytes is positive multiple of 8
      local RC_lo, RC_hi = sha3_RC_lo, sha3_RC_hi
      local qwords_qty = SHR(block_size_in_bytes, 3)
      for pos = offs, offs + size - 1, block_size_in_bytes do
         for j = 1, qwords_qty do
            local a, b, c, d = byte(str, pos + 1, pos + 4)
            lanes_lo[j] = XOR(lanes_lo[j], OR(SHL(d, 24), SHL(c, 16), SHL(b, 8), a))
            pos = pos + 8
            a, b, c, d = byte(str, pos - 3, pos)
            lanes_hi[j] = XOR(lanes_hi[j], OR(SHL(d, 24), SHL(c, 16), SHL(b, 8), a))
         end
         for round_idx = 1, 24 do
            for j = 1, 5 do
               lanes_lo[25 + j] = XOR(lanes_lo[j], lanes_lo[j + 5], lanes_lo[j + 10], lanes_lo[j + 15], lanes_lo[j + 20])
            end
            for j = 1, 5 do
               lanes_hi[25 + j] = XOR(lanes_hi[j], lanes_hi[j + 5], lanes_hi[j + 10], lanes_hi[j + 15], lanes_hi[j + 20])
            end
            local D_lo = XOR(lanes_lo[ 26 ], SHL(lanes_lo[ 28 ], 1), SHR(lanes_hi[ 28 ], 31))
            local D_hi = XOR(lanes_hi[ 26 ], SHL(lanes_hi[ 28 ], 1), SHR(lanes_lo[ 28 ], 31))
            lanes_lo[ 2 ], lanes_hi[ 2 ], lanes_lo[ 7 ], lanes_hi[ 7 ], lanes_lo[ 12 ], lanes_hi[ 12 ], lanes_lo[ 17 ], lanes_hi[ 17 ] = XOR(SHR(XOR(D_lo, lanes_lo[ 7 ]), 20), SHL(XOR(D_hi, lanes_hi[ 7 ]), 12)), XOR(SHR(XOR(D_hi, lanes_hi[ 7 ]), 20), SHL(XOR(D_lo, lanes_lo[ 7 ]), 12)), XOR(SHR(XOR(D_lo, lanes_lo[ 17 ]), 19), SHL(XOR(D_hi, lanes_hi[ 17 ]), 13)), XOR(SHR(XOR(D_hi, lanes_hi[ 17 ]), 19), SHL(XOR(D_lo, lanes_lo[ 17 ]), 13)), XOR(SHL(XOR(D_lo, lanes_lo[ 2 ]), 1), SHR(XOR(D_hi, lanes_hi[ 2 ]), 31)), XOR(SHL(XOR(D_hi, lanes_hi[ 2 ]), 1), SHR(XOR(D_lo, lanes_lo[ 2 ]), 31)), XOR(SHL(XOR(D_lo, lanes_lo[ 12 ]), 10), SHR(XOR(D_hi, lanes_hi[ 12 ]), 22)), XOR(SHL(XOR(D_hi, lanes_hi[ 12 ]), 10), SHR(XOR(D_lo, lanes_lo[ 12 ]), 22))
            local L, H = XOR(D_lo, lanes_lo[ 22 ]), XOR(D_hi, lanes_hi[ 22 ])
            lanes_lo[ 22 ], lanes_hi[ 22 ] = XOR(SHL(L, 2), SHR(H, 30)), XOR(SHL(H, 2), SHR(L, 30))
            D_lo = XOR(lanes_lo[ 27 ], SHL(lanes_lo[ 29 ], 1), SHR(lanes_hi[ 29 ], 31))
            D_hi = XOR(lanes_hi[ 27 ], SHL(lanes_hi[ 29 ], 1), SHR(lanes_lo[ 29 ], 31))
            lanes_lo[ 3 ], lanes_hi[ 3 ], lanes_lo[ 8 ], lanes_hi[ 8 ], lanes_lo[ 13 ], lanes_hi[ 13 ], lanes_lo[ 23 ], lanes_hi[ 23 ] = XOR(SHR(XOR(D_lo, lanes_lo[ 13 ]), 21), SHL(XOR(D_hi, lanes_hi[ 13 ]), 11)), XOR(SHR(XOR(D_hi, lanes_hi[ 13 ]), 21), SHL(XOR(D_lo, lanes_lo[ 13 ]), 11)), XOR(SHR(XOR(D_lo, lanes_lo[ 23 ]), 3), SHL(XOR(D_hi, lanes_hi[ 23 ]), 29)), XOR(SHR(XOR(D_hi, lanes_hi[ 23 ]), 3), SHL(XOR(D_lo, lanes_lo[ 23 ]), 29)), XOR(SHL(XOR(D_lo, lanes_lo[ 8 ]), 6), SHR(XOR(D_hi, lanes_hi[ 8 ]), 26)), XOR(SHL(XOR(D_hi, lanes_hi[ 8 ]), 6), SHR(XOR(D_lo, lanes_lo[ 8 ]), 26)), XOR(SHR(XOR(D_lo, lanes_lo[ 3 ]), 2), SHL(XOR(D_hi, lanes_hi[ 3 ]), 30)), XOR(SHR(XOR(D_hi, lanes_hi[ 3 ]), 2), SHL(XOR(D_lo, lanes_lo[ 3 ]), 30))
            L, H = XOR(D_lo, lanes_lo[ 18 ]), XOR(D_hi, lanes_hi[ 18 ])
            lanes_lo[ 18 ], lanes_hi[ 18 ] = XOR(SHL(L, 15), SHR(H, 17)), XOR(SHL(H, 15), SHR(L, 17))
            D_lo = XOR(lanes_lo[ 28 ], SHL(lanes_lo[ 30 ], 1), SHR(lanes_hi[ 30 ], 31))
            D_hi = XOR(lanes_hi[ 28 ], SHL(lanes_hi[ 30 ], 1), SHR(lanes_lo[ 30 ], 31))
            lanes_lo[ 4 ], lanes_hi[ 4 ], lanes_lo[ 9 ], lanes_hi[ 9 ], lanes_lo[ 19 ], lanes_hi[ 19 ], lanes_lo[ 24 ], lanes_hi[ 24 ] = XOR(SHL(XOR(D_lo, lanes_lo[ 19 ]), 21), SHR(XOR(D_hi, lanes_hi[ 19 ]), 11)), XOR(SHL(XOR(D_hi, lanes_hi[ 19 ]), 21), SHR(XOR(D_lo, lanes_lo[ 19 ]), 11)), XOR(SHL(XOR(D_lo, lanes_lo[ 4 ]), 28), SHR(XOR(D_hi, lanes_hi[ 4 ]), 4)), XOR(SHL(XOR(D_hi, lanes_hi[ 4 ]), 28), SHR(XOR(D_lo, lanes_lo[ 4 ]), 4)), XOR(SHR(XOR(D_lo, lanes_lo[ 24 ]), 8), SHL(XOR(D_hi, lanes_hi[ 24 ]), 24)), XOR(SHR(XOR(D_hi, lanes_hi[ 24 ]), 8), SHL(XOR(D_lo, lanes_lo[ 24 ]), 24)), XOR(SHR(XOR(D_lo, lanes_lo[ 9 ]), 9), SHL(XOR(D_hi, lanes_hi[ 9 ]), 23)), XOR(SHR(XOR(D_hi, lanes_hi[ 9 ]), 9), SHL(XOR(D_lo, lanes_lo[ 9 ]), 23))
            L, H = XOR(D_lo, lanes_lo[ 14 ]), XOR(D_hi, lanes_hi[ 14 ])
            lanes_lo[ 14 ], lanes_hi[ 14 ] = XOR(SHL(L, 25), SHR(H, 7)), XOR(SHL(H, 25), SHR(L, 7))
            D_lo = XOR(lanes_lo[ 29 ], SHL(lanes_lo[ 26 ], 1), SHR(lanes_hi[ 26 ], 31))
            D_hi = XOR(lanes_hi[ 29 ], SHL(lanes_hi[ 26 ], 1), SHR(lanes_lo[ 26 ], 31))
            lanes_lo[ 5 ], lanes_hi[ 5 ], lanes_lo[ 15 ], lanes_hi[ 15 ], lanes_lo[ 20 ], lanes_hi[ 20 ], lanes_lo[ 25 ], lanes_hi[ 25 ] = XOR(SHL(XOR(D_lo, lanes_lo[ 25 ]), 14), SHR(XOR(D_hi, lanes_hi[ 25 ]), 18)), XOR(SHL(XOR(D_hi, lanes_hi[ 25 ]), 14), SHR(XOR(D_lo, lanes_lo[ 25 ]), 18)), XOR(SHL(XOR(D_lo, lanes_lo[ 20 ]), 8), SHR(XOR(D_hi, lanes_hi[ 20 ]), 24)), XOR(SHL(XOR(D_hi, lanes_hi[ 20 ]), 8), SHR(XOR(D_lo, lanes_lo[ 20 ]), 24)), XOR(SHL(XOR(D_lo, lanes_lo[ 5 ]), 27), SHR(XOR(D_hi, lanes_hi[ 5 ]), 5)), XOR(SHL(XOR(D_hi, lanes_hi[ 5 ]), 27), SHR(XOR(D_lo, lanes_lo[ 5 ]), 5)), XOR(SHR(XOR(D_lo, lanes_lo[ 15 ]), 25), SHL(XOR(D_hi, lanes_hi[ 15 ]), 7)), XOR(SHR(XOR(D_hi, lanes_hi[ 15 ]), 25), SHL(XOR(D_lo, lanes_lo[ 15 ]), 7))
            L, H = XOR(D_lo, lanes_lo[ 10 ]), XOR(D_hi, lanes_hi[ 10 ])
            lanes_lo[ 10 ], lanes_hi[ 10 ] = XOR(SHL(L, 20), SHR(H, 12)), XOR(SHL(H, 20), SHR(L, 12))
            D_lo = XOR(lanes_lo[ 30 ], SHL(lanes_lo[ 27 ], 1), SHR(lanes_hi[ 27 ], 31))
            D_hi = XOR(lanes_hi[ 30 ], SHL(lanes_hi[ 27 ], 1), SHR(lanes_lo[ 27 ], 31))
            lanes_lo[ 6 ], lanes_hi[ 6 ], lanes_lo[ 11 ], lanes_hi[ 11 ], lanes_lo[ 16 ], lanes_hi[ 16 ], lanes_lo[ 21 ], lanes_hi[ 21 ] = XOR(SHL(XOR(D_lo, lanes_lo[ 11 ]), 3), SHR(XOR(D_hi, lanes_hi[ 11 ]), 29)), XOR(SHL(XOR(D_hi, lanes_hi[ 11 ]), 3), SHR(XOR(D_lo, lanes_lo[ 11 ]), 29)), XOR(SHL(XOR(D_lo, lanes_lo[ 21 ]), 18), SHR(XOR(D_hi, lanes_hi[ 21 ]), 14)), XOR(SHL(XOR(D_hi, lanes_hi[ 21 ]), 18), SHR(XOR(D_lo, lanes_lo[ 21 ]), 14)), XOR(SHR(XOR(D_lo, lanes_lo[ 6 ]), 28), SHL(XOR(D_hi, lanes_hi[ 6 ]), 4)), XOR(SHR(XOR(D_hi, lanes_hi[ 6 ]), 28), SHL(XOR(D_lo, lanes_lo[ 6 ]), 4)), XOR(SHR(XOR(D_lo, lanes_lo[ 16 ]), 23), SHL(XOR(D_hi, lanes_hi[ 16 ]), 9)), XOR(SHR(XOR(D_hi, lanes_hi[ 16 ]), 23), SHL(XOR(D_lo, lanes_lo[ 16 ]), 9))
            lanes_lo[ 1 ], lanes_hi[ 1 ] = XOR(D_lo, lanes_lo[ 1 ]), XOR(D_hi, lanes_hi[ 1 ])
            lanes_lo[ 1 ], lanes_lo[ 2 ], lanes_lo[ 3 ], lanes_lo[ 4 ], lanes_lo[ 5 ] = XOR(lanes_lo[ 1 ], AND(NOT(lanes_lo[ 2 ]), lanes_lo[ 3 ]), RC_lo[round_idx]), XOR(lanes_lo[ 2 ], AND(NOT(lanes_lo[ 3 ]), lanes_lo[ 4 ])), XOR(lanes_lo[ 3 ], AND(NOT(lanes_lo[ 4 ]), lanes_lo[ 5 ])), XOR(lanes_lo[ 4 ], AND(NOT(lanes_lo[ 5 ]), lanes_lo[ 1 ])), XOR(lanes_lo[ 5 ], AND(NOT(lanes_lo[ 1 ]), lanes_lo[ 2 ]))
            lanes_lo[ 6 ], lanes_lo[ 7 ], lanes_lo[ 8 ], lanes_lo[ 9 ], lanes_lo[ 10 ] = XOR(lanes_lo[ 9 ], AND(NOT(lanes_lo[ 10 ]), lanes_lo[ 6 ])), XOR(lanes_lo[ 10 ], AND(NOT(lanes_lo[ 6 ]), lanes_lo[ 7 ])), XOR(lanes_lo[ 6 ], AND(NOT(lanes_lo[ 7 ]), lanes_lo[ 8 ])), XOR(lanes_lo[ 7 ], AND(NOT(lanes_lo[ 8 ]), lanes_lo[ 9 ])), XOR(lanes_lo[ 8 ], AND(NOT(lanes_lo[ 9 ]), lanes_lo[ 10 ]))
            lanes_lo[ 11 ], lanes_lo[ 12 ], lanes_lo[ 13 ], lanes_lo[ 14 ], lanes_lo[ 15 ] = XOR(lanes_lo[ 12 ], AND(NOT(lanes_lo[ 13 ]), lanes_lo[ 14 ])), XOR(lanes_lo[ 13 ], AND(NOT(lanes_lo[ 14 ]), lanes_lo[ 15 ])), XOR(lanes_lo[ 14 ], AND(NOT(lanes_lo[ 15 ]), lanes_lo[ 11 ])), XOR(lanes_lo[ 15 ], AND(NOT(lanes_lo[ 11 ]), lanes_lo[ 12 ])), XOR(lanes_lo[ 11 ], AND(NOT(lanes_lo[ 12 ]), lanes_lo[ 13 ]))
            lanes_lo[ 16 ], lanes_lo[ 17 ], lanes_lo[ 18 ], lanes_lo[ 19 ], lanes_lo[ 20 ] = XOR(lanes_lo[ 20 ], AND(NOT(lanes_lo[ 16 ]), lanes_lo[ 17 ])), XOR(lanes_lo[ 16 ], AND(NOT(lanes_lo[ 17 ]), lanes_lo[ 18 ])), XOR(lanes_lo[ 17 ], AND(NOT(lanes_lo[ 18 ]), lanes_lo[ 19 ])), XOR(lanes_lo[ 18 ], AND(NOT(lanes_lo[ 19 ]), lanes_lo[ 20 ])), XOR(lanes_lo[ 19 ], AND(NOT(lanes_lo[ 20 ]), lanes_lo[ 16 ]))
            lanes_lo[ 21 ], lanes_lo[ 22 ], lanes_lo[ 23 ], lanes_lo[ 24 ], lanes_lo[ 25 ] = XOR(lanes_lo[ 23 ], AND(NOT(lanes_lo[ 24 ]), lanes_lo[ 25 ])), XOR(lanes_lo[ 24 ], AND(NOT(lanes_lo[ 25 ]), lanes_lo[ 21 ])), XOR(lanes_lo[ 25 ], AND(NOT(lanes_lo[ 21 ]), lanes_lo[ 22 ])), XOR(lanes_lo[ 21 ], AND(NOT(lanes_lo[ 22 ]), lanes_lo[ 23 ])), XOR(lanes_lo[ 22 ], AND(NOT(lanes_lo[ 23 ]), lanes_lo[ 24 ]))
            lanes_hi[ 1 ], lanes_hi[ 2 ], lanes_hi[ 3 ], lanes_hi[ 4 ], lanes_hi[ 5 ] = XOR(lanes_hi[ 1 ], AND(NOT(lanes_hi[ 2 ]), lanes_hi[ 3 ]), RC_hi[round_idx]), XOR(lanes_hi[ 2 ], AND(NOT(lanes_hi[ 3 ]), lanes_hi[ 4 ])), XOR(lanes_hi[ 3 ], AND(NOT(lanes_hi[ 4 ]), lanes_hi[ 5 ])), XOR(lanes_hi[ 4 ], AND(NOT(lanes_hi[ 5 ]), lanes_hi[ 1 ])), XOR(lanes_hi[ 5 ], AND(NOT(lanes_hi[ 1 ]), lanes_hi[ 2 ]))
            lanes_hi[ 6 ], lanes_hi[ 7 ], lanes_hi[ 8 ], lanes_hi[ 9 ], lanes_hi[ 10 ] = XOR(lanes_hi[ 9 ], AND(NOT(lanes_hi[ 10 ]), lanes_hi[ 6 ])), XOR(lanes_hi[ 10 ], AND(NOT(lanes_hi[ 6 ]), lanes_hi[ 7 ])), XOR(lanes_hi[ 6 ], AND(NOT(lanes_hi[ 7 ]), lanes_hi[ 8 ])), XOR(lanes_hi[ 7 ], AND(NOT(lanes_hi[ 8 ]), lanes_hi[ 9 ])), XOR(lanes_hi[ 8 ], AND(NOT(lanes_hi[ 9 ]), lanes_hi[ 10 ]))
            lanes_hi[ 11 ], lanes_hi[ 12 ], lanes_hi[ 13 ], lanes_hi[ 14 ], lanes_hi[ 15 ] = XOR(lanes_hi[ 12 ], AND(NOT(lanes_hi[ 13 ]), lanes_hi[ 14 ])), XOR(lanes_hi[ 13 ], AND(NOT(lanes_hi[ 14 ]), lanes_hi[ 15 ])), XOR(lanes_hi[ 14 ], AND(NOT(lanes_hi[ 15 ]), lanes_hi[ 11 ])), XOR(lanes_hi[ 15 ], AND(NOT(lanes_hi[ 11 ]), lanes_hi[ 12 ])), XOR(lanes_hi[ 11 ], AND(NOT(lanes_hi[ 12 ]), lanes_hi[ 13 ]))
            lanes_hi[ 16 ], lanes_hi[ 17 ], lanes_hi[ 18 ], lanes_hi[ 19 ], lanes_hi[ 20 ] = XOR(lanes_hi[ 20 ], AND(NOT(lanes_hi[ 16 ]), lanes_hi[ 17 ])), XOR(lanes_hi[ 16 ], AND(NOT(lanes_hi[ 17 ]), lanes_hi[ 18 ])), XOR(lanes_hi[ 17 ], AND(NOT(lanes_hi[ 18 ]), lanes_hi[ 19 ])), XOR(lanes_hi[ 18 ], AND(NOT(lanes_hi[ 19 ]), lanes_hi[ 20 ])), XOR(lanes_hi[ 19 ], AND(NOT(lanes_hi[ 20 ]), lanes_hi[ 16 ]))
            lanes_hi[ 21 ], lanes_hi[ 22 ], lanes_hi[ 23 ], lanes_hi[ 24 ], lanes_hi[ 25 ] = XOR(lanes_hi[ 23 ], AND(NOT(lanes_hi[ 24 ]), lanes_hi[ 25 ])), XOR(lanes_hi[ 24 ], AND(NOT(lanes_hi[ 25 ]), lanes_hi[ 21 ])), XOR(lanes_hi[ 25 ], AND(NOT(lanes_hi[ 21 ]), lanes_hi[ 22 ])), XOR(lanes_hi[ 21 ], AND(NOT(lanes_hi[ 22 ]), lanes_hi[ 23 ])), XOR(lanes_hi[ 22 ], AND(NOT(lanes_hi[ 23 ]), lanes_hi[ 24 ]))
         end
      end
   end
end

if branch == "LJ" then


   -- SHA256 implementation for "LuaJIT without FFI" branch

   function sha256_feed_64(H, str, offs, size)
      -- offs >= 0, size >= 0, size is multiple of 64
      local W, K = common_W, sha2_K_hi
      for pos = offs, offs + size - 1, 64 do
         for j = 1, 16 do
            pos = pos + 4
            local a, b, c, d = byte(str, pos - 3, pos)
            W[j] = OR(SHL(a, 24), SHL(b, 16), SHL(c, 8), d)
         end
         for j = 17, 64 do
            local a, b = W[j-15], W[j-2]
            W[j] = NORM( NORM( XOR(ROR(a, 7), ROL(a, 14), SHR(a, 3)) + XOR(ROL(b, 15), ROL(b, 13), SHR(b, 10)) ) + NORM( W[j-7] + W[j-16] ) )
         end
         local a, b, c, d, e, f, g, h = H[ 1 ], H[ 2 ], H[ 3 ], H[ 4 ], H[ 5 ], H[ 6 ], H[ 7 ], H[ 8 ]
         for j = 1, 64, 8 do  -- Thanks to Peter Cawley for this workaround (unroll the loop to avoid "PHI shuffling too complex" due to PHIs overlap)
            local z = NORM( XOR(ROR(e, 6), ROR(e, 11), ROL(e, 7)) + XOR(g, AND(e, XOR(f, g))) + (K[j] + W[j] + h) )
            h, g, f, e = g, f, e, NORM(d + z)
            d, c, b, a = c, b, a, NORM( XOR(AND(a, XOR(b, c)), AND(b, c)) + XOR(ROR(a, 2), ROR(a, 13), ROL(a, 10)) + z )
            z = NORM( XOR(ROR(e, 6), ROR(e, 11), ROL(e, 7)) + XOR(g, AND(e, XOR(f, g))) + (K[j+1] + W[j+1] + h) )
            h, g, f, e = g, f, e, NORM(d + z)
            d, c, b, a = c, b, a, NORM( XOR(AND(a, XOR(b, c)), AND(b, c)) + XOR(ROR(a, 2), ROR(a, 13), ROL(a, 10)) + z )
            z = NORM( XOR(ROR(e, 6), ROR(e, 11), ROL(e, 7)) + XOR(g, AND(e, XOR(f, g))) + (K[j+2] + W[j+2] + h) )
            h, g, f, e = g, f, e, NORM(d + z)
            d, c, b, a = c, b, a, NORM( XOR(AND(a, XOR(b, c)), AND(b, c)) + XOR(ROR(a, 2), ROR(a, 13), ROL(a, 10)) + z )
            z = NORM( XOR(ROR(e, 6), ROR(e, 11), ROL(e, 7)) + XOR(g, AND(e, XOR(f, g))) + (K[j+3] + W[j+3] + h) )
            h, g, f, e = g, f, e, NORM(d + z)
            d, c, b, a = c, b, a, NORM( XOR(AND(a, XOR(b, c)), AND(b, c)) + XOR(ROR(a, 2), ROR(a, 13), ROL(a, 10)) + z )
            z = NORM( XOR(ROR(e, 6), ROR(e, 11), ROL(e, 7)) + XOR(g, AND(e, XOR(f, g))) + (K[j+4] + W[j+4] + h) )
            h, g, f, e = g, f, e, NORM(d + z)
            d, c, b, a = c, b, a, NORM( XOR(AND(a, XOR(b, c)), AND(b, c)) + XOR(ROR(a, 2), ROR(a, 13), ROL(a, 10)) + z )
            z = NORM( XOR(ROR(e, 6), ROR(e, 11), ROL(e, 7)) + XOR(g, AND(e, XOR(f, g))) + (K[j+5] + W[j+5] + h) )
            h, g, f, e = g, f, e, NORM(d + z)
            d, c, b, a = c, b, a, NORM( XOR(AND(a, XOR(b, c)), AND(b, c)) + XOR(ROR(a, 2), ROR(a, 13), ROL(a, 10)) + z )
            z = NORM( XOR(ROR(e, 6), ROR(e, 11), ROL(e, 7)) + XOR(g, AND(e, XOR(f, g))) + (K[j+6] + W[j+6] + h) )
            h, g, f, e = g, f, e, NORM(d + z)
            d, c, b, a = c, b, a, NORM( XOR(AND(a, XOR(b, c)), AND(b, c)) + XOR(ROR(a, 2), ROR(a, 13), ROL(a, 10)) + z )
            z = NORM( XOR(ROR(e, 6), ROR(e, 11), ROL(e, 7)) + XOR(g, AND(e, XOR(f, g))) + (K[j+7] + W[j+7] + h) )
            h, g, f, e = g, f, e, NORM(d + z)
            d, c, b, a = c, b, a, NORM( XOR(AND(a, XOR(b, c)), AND(b, c)) + XOR(ROR(a, 2), ROR(a, 13), ROL(a, 10)) + z )
         end
         H[ 1 ], H[ 2 ], H[ 3 ], H[ 4 ] = NORM(a + H[ 1 ]), NORM(b + H[ 2 ]), NORM(c + H[ 3 ]), NORM(d + H[ 4 ])
         H[ 5 ], H[ 6 ], H[ 7 ], H[ 8 ] = NORM(e + H[ 5 ]), NORM(f + H[ 6 ]), NORM(g + H[ 7 ]), NORM(h + H[ 8 ])
      end
   end

   local function ADD64_4(a_lo, a_hi, b_lo, b_hi, c_lo, c_hi, d_lo, d_hi)
      local sum_lo = a_lo % 2^32 + b_lo % 2^32 + c_lo % 2^32 + d_lo % 2^32
      local sum_hi = a_hi + b_hi + c_hi + d_hi
      local result_lo = NORM( sum_lo )
      local result_hi = NORM( sum_hi + floor(sum_lo / 2^32) )
      return result_lo, result_hi
   end

   if LuaJIT_arch == "x86" then  -- Special trick is required to avoid "PHI shuffling too complex" on x86 platform


      -- SHA512 implementation for "LuaJIT x86 without FFI" branch

      function sha512_feed_128(H_lo, H_hi, str, offs, size)
         -- offs >= 0, size >= 0, size is multiple of 128
         -- W1_hi, W1_lo, W2_hi, W2_lo, ...   Wk_hi = W[2*k-1], Wk_lo = W[2*k]
         local W, K_lo, K_hi = common_W, sha2_K_lo, sha2_K_hi
         for pos = offs, offs + size - 1, 128 do
            for j = 1, 16*2 do
               pos = pos + 4
               local a, b, c, d = byte(str, pos - 3, pos)
               W[j] = OR(SHL(a, 24), SHL(b, 16), SHL(c, 8), d)
            end
            for jj = 17*2, 80*2, 2 do
               local a_lo, a_hi = W[jj-30], W[jj-31]
               local t_lo = XOR(OR(SHR(a_lo, 1), SHL(a_hi, 31)), OR(SHR(a_lo, 8), SHL(a_hi, 24)), OR(SHR(a_lo, 7), SHL(a_hi, 25)))
               local t_hi = XOR(OR(SHR(a_hi, 1), SHL(a_lo, 31)), OR(SHR(a_hi, 8), SHL(a_lo, 24)), SHR(a_hi, 7))
               local b_lo, b_hi = W[jj-4], W[jj-5]
               local u_lo = XOR(OR(SHR(b_lo, 19), SHL(b_hi, 13)), OR(SHL(b_lo, 3), SHR(b_hi, 29)), OR(SHR(b_lo, 6), SHL(b_hi, 26)))
               local u_hi = XOR(OR(SHR(b_hi, 19), SHL(b_lo, 13)), OR(SHL(b_hi, 3), SHR(b_lo, 29)), SHR(b_hi, 6))
               W[jj], W[jj-1] = ADD64_4(t_lo, t_hi, u_lo, u_hi, W[jj-14], W[jj-15], W[jj-32], W[jj-33])
            end
            local a_lo, b_lo, c_lo, d_lo, e_lo, f_lo, g_lo, h_lo = H_lo[ 1 ], H_lo[ 2 ], H_lo[ 3 ], H_lo[ 4 ], H_lo[ 5 ], H_lo[ 6 ], H_lo[ 7 ], H_lo[ 8 ]
            local a_hi, b_hi, c_hi, d_hi, e_hi, f_hi, g_hi, h_hi = H_hi[ 1 ], H_hi[ 2 ], H_hi[ 3 ], H_hi[ 4 ], H_hi[ 5 ], H_hi[ 6 ], H_hi[ 7 ], H_hi[ 8 ]
            local zero = 0
            for j = 1, 80 do
               local t_lo = XOR(g_lo, AND(e_lo, XOR(f_lo, g_lo)))
               local t_hi = XOR(g_hi, AND(e_hi, XOR(f_hi, g_hi)))
               local u_lo = XOR(OR(SHR(e_lo, 14), SHL(e_hi, 18)), OR(SHR(e_lo, 18), SHL(e_hi, 14)), OR(SHL(e_lo, 23), SHR(e_hi, 9)))
               local u_hi = XOR(OR(SHR(e_hi, 14), SHL(e_lo, 18)), OR(SHR(e_hi, 18), SHL(e_lo, 14)), OR(SHL(e_hi, 23), SHR(e_lo, 9)))
               local sum_lo = u_lo % 2^32 + t_lo % 2^32 + h_lo % 2^32 + K_lo[j] + W[2*j] % 2^32
               local z_lo, z_hi = NORM( sum_lo ), NORM( u_hi + t_hi + h_hi + K_hi[j] + W[2*j-1] + floor(sum_lo / 2^32) )
               zero = zero + zero  -- this thick is needed to avoid "PHI shuffling too complex" due to PHIs overlap
               h_lo, h_hi, g_lo, g_hi, f_lo, f_hi = OR(zero, g_lo), OR(zero, g_hi), OR(zero, f_lo), OR(zero, f_hi), OR(zero, e_lo), OR(zero, e_hi)
               local sum_lo = z_lo % 2^32 + d_lo % 2^32
               e_lo, e_hi = NORM( sum_lo ), NORM( z_hi + d_hi + floor(sum_lo / 2^32) )
               d_lo, d_hi, c_lo, c_hi, b_lo, b_hi = OR(zero, c_lo), OR(zero, c_hi), OR(zero, b_lo), OR(zero, b_hi), OR(zero, a_lo), OR(zero, a_hi)
               u_lo = XOR(OR(SHR(b_lo, 28), SHL(b_hi, 4)), OR(SHL(b_lo, 30), SHR(b_hi, 2)), OR(SHL(b_lo, 25), SHR(b_hi, 7)))
               u_hi = XOR(OR(SHR(b_hi, 28), SHL(b_lo, 4)), OR(SHL(b_hi, 30), SHR(b_lo, 2)), OR(SHL(b_hi, 25), SHR(b_lo, 7)))
               t_lo = OR(AND(d_lo, c_lo), AND(b_lo, XOR(d_lo, c_lo)))
               t_hi = OR(AND(d_hi, c_hi), AND(b_hi, XOR(d_hi, c_hi)))
               local sum_lo = z_lo % 2^32 + t_lo % 2^32 + u_lo % 2^32
               a_lo, a_hi = NORM( sum_lo ), NORM( z_hi + t_hi + u_hi + floor(sum_lo / 2^32) )
            end
            H_lo[ 1 ], H_hi[ 1 ] = ADD64_4(H_lo[ 1 ], H_hi[ 1 ], a_lo, a_hi, 0, 0, 0, 0)
            H_lo[ 2 ], H_hi[ 2 ] = ADD64_4(H_lo[ 2 ], H_hi[ 2 ], b_lo, b_hi, 0, 0, 0, 0)
            H_lo[ 3 ], H_hi[ 3 ] = ADD64_4(H_lo[ 3 ], H_hi[ 3 ], c_lo, c_hi, 0, 0, 0, 0)
            H_lo[ 4 ], H_hi[ 4 ] = ADD64_4(H_lo[ 4 ], H_hi[ 4 ], d_lo, d_hi, 0, 0, 0, 0)
            H_lo[ 5 ], H_hi[ 5 ] = ADD64_4(H_lo[ 5 ], H_hi[ 5 ], e_lo, e_hi, 0, 0, 0, 0)
            H_lo[ 6 ], H_hi[ 6 ] = ADD64_4(H_lo[ 6 ], H_hi[ 6 ], f_lo, f_hi, 0, 0, 0, 0)
            H_lo[ 7 ], H_hi[ 7 ] = ADD64_4(H_lo[ 7 ], H_hi[ 7 ], g_lo, g_hi, 0, 0, 0, 0)
            H_lo[ 8 ], H_hi[ 8 ] = ADD64_4(H_lo[ 8 ], H_hi[ 8 ], h_lo, h_hi, 0, 0, 0, 0)
         end
      end

   else  -- all platforms except x86


      -- SHA512 implementation for "LuaJIT non-x86 without FFI" branch

      function sha512_feed_128(H_lo, H_hi, str, offs, size)
         -- offs >= 0, size >= 0, size is multiple of 128
         -- W1_hi, W1_lo, W2_hi, W2_lo, ...   Wk_hi = W[2*k-1], Wk_lo = W[2*k]
         local W, K_lo, K_hi = common_W, sha2_K_lo, sha2_K_hi
         for pos = offs, offs + size - 1, 128 do
            for j = 1, 16*2 do
               pos = pos + 4
               local a, b, c, d = byte(str, pos - 3, pos)
               W[j] = OR(SHL(a, 24), SHL(b, 16), SHL(c, 8), d)
            end
            for jj = 17*2, 80*2, 2 do
               local a_lo, a_hi = W[jj-30], W[jj-31]
               local t_lo = XOR(OR(SHR(a_lo, 1), SHL(a_hi, 31)), OR(SHR(a_lo, 8), SHL(a_hi, 24)), OR(SHR(a_lo, 7), SHL(a_hi, 25)))
               local t_hi = XOR(OR(SHR(a_hi, 1), SHL(a_lo, 31)), OR(SHR(a_hi, 8), SHL(a_lo, 24)), SHR(a_hi, 7))
               local b_lo, b_hi = W[jj-4], W[jj-5]
               local u_lo = XOR(OR(SHR(b_lo, 19), SHL(b_hi, 13)), OR(SHL(b_lo, 3), SHR(b_hi, 29)), OR(SHR(b_lo, 6), SHL(b_hi, 26)))
               local u_hi = XOR(OR(SHR(b_hi, 19), SHL(b_lo, 13)), OR(SHL(b_hi, 3), SHR(b_lo, 29)), SHR(b_hi, 6))
               W[jj], W[jj-1] = ADD64_4(t_lo, t_hi, u_lo, u_hi, W[jj-14], W[jj-15], W[jj-32], W[jj-33])
            end
            local a_lo, b_lo, c_lo, d_lo, e_lo, f_lo, g_lo, h_lo = H_lo[ 1 ], H_lo[ 2 ], H_lo[ 3 ], H_lo[ 4 ], H_lo[ 5 ], H_lo[ 6 ], H_lo[ 7 ], H_lo[ 8 ]
            local a_hi, b_hi, c_hi, d_hi, e_hi, f_hi, g_hi, h_hi = H_hi[ 1 ], H_hi[ 2 ], H_hi[ 3 ], H_hi[ 4 ], H_hi[ 5 ], H_hi[ 6 ], H_hi[ 7 ], H_hi[ 8 ]
            for j = 1, 80 do
               local t_lo = XOR(g_lo, AND(e_lo, XOR(f_lo, g_lo)))
               local t_hi = XOR(g_hi, AND(e_hi, XOR(f_hi, g_hi)))
               local u_lo = XOR(OR(SHR(e_lo, 14), SHL(e_hi, 18)), OR(SHR(e_lo, 18), SHL(e_hi, 14)), OR(SHL(e_lo, 23), SHR(e_hi, 9)))
               local u_hi = XOR(OR(SHR(e_hi, 14), SHL(e_lo, 18)), OR(SHR(e_hi, 18), SHL(e_lo, 14)), OR(SHL(e_hi, 23), SHR(e_lo, 9)))
               local sum_lo = u_lo % 2^32 + t_lo % 2^32 + h_lo % 2^32 + K_lo[j] + W[2*j] % 2^32
               local z_lo, z_hi = NORM( sum_lo ), NORM( u_hi + t_hi + h_hi + K_hi[j] + W[2*j-1] + floor(sum_lo / 2^32) )
               h_lo, h_hi, g_lo, g_hi, f_lo, f_hi = g_lo, g_hi, f_lo, f_hi, e_lo, e_hi
               local sum_lo = z_lo % 2^32 + d_lo % 2^32
               e_lo, e_hi = NORM( sum_lo ), NORM( z_hi + d_hi + floor(sum_lo / 2^32) )
               d_lo, d_hi, c_lo, c_hi, b_lo, b_hi = c_lo, c_hi, b_lo, b_hi, a_lo, a_hi
               u_lo = XOR(OR(SHR(b_lo, 28), SHL(b_hi, 4)), OR(SHL(b_lo, 30), SHR(b_hi, 2)), OR(SHL(b_lo, 25), SHR(b_hi, 7)))
               u_hi = XOR(OR(SHR(b_hi, 28), SHL(b_lo, 4)), OR(SHL(b_hi, 30), SHR(b_lo, 2)), OR(SHL(b_hi, 25), SHR(b_lo, 7)))
               t_lo = OR(AND(d_lo, c_lo), AND(b_lo, XOR(d_lo, c_lo)))
               t_hi = OR(AND(d_hi, c_hi), AND(b_hi, XOR(d_hi, c_hi)))
               local sum_lo = z_lo % 2^32 + u_lo % 2^32 + t_lo % 2^32
               a_lo, a_hi = NORM( sum_lo ), NORM( z_hi + u_hi + t_hi + floor(sum_lo / 2^32) )
            end
            H_lo[ 1 ], H_hi[ 1 ] = ADD64_4(H_lo[ 1 ], H_hi[ 1 ], a_lo, a_hi, 0, 0, 0, 0)
            H_lo[ 2 ], H_hi[ 2 ] = ADD64_4(H_lo[ 2 ], H_hi[ 2 ], b_lo, b_hi, 0, 0, 0, 0)
            H_lo[ 3 ], H_hi[ 3 ] = ADD64_4(H_lo[ 3 ], H_hi[ 3 ], c_lo, c_hi, 0, 0, 0, 0)
            H_lo[ 4 ], H_hi[ 4 ] = ADD64_4(H_lo[ 4 ], H_hi[ 4 ], d_lo, d_hi, 0, 0, 0, 0)
            H_lo[ 5 ], H_hi[ 5 ] = ADD64_4(H_lo[ 5 ], H_hi[ 5 ], e_lo, e_hi, 0, 0, 0, 0)
            H_lo[ 6 ], H_hi[ 6 ] = ADD64_4(H_lo[ 6 ], H_hi[ 6 ], f_lo, f_hi, 0, 0, 0, 0)
            H_lo[ 7 ], H_hi[ 7 ] = ADD64_4(H_lo[ 7 ], H_hi[ 7 ], g_lo, g_hi, 0, 0, 0, 0)
            H_lo[ 8 ], H_hi[ 8 ] = ADD64_4(H_lo[ 8 ], H_hi[ 8 ], h_lo, h_hi, 0, 0, 0, 0)
         end
      end
   end

   -- MD5 implementation for "LuaJIT without FFI" branch

   function md5_feed_64(H, str, offs, size)
      -- offs >= 0, size >= 0, size is multiple of 64
      local W, K = common_W, md5_K
      for pos = offs, offs + size - 1, 64 do
         for j = 1, 16 do
            pos = pos + 4
            local a, b, c, d = byte(str, pos - 3, pos)
            W[j] = OR(SHL(d, 24), SHL(c, 16), SHL(b, 8), a)
         end
         local a, b, c, d = H[ 1 ], H[ 2 ], H[ 3 ], H[ 4 ]
         for j = 1, 16, 4 do
            a, d, c, b = d, c, b, NORM(ROL(XOR(d, AND(b, XOR(c, d))) + (K[j  ] + W[j  ] + a),  7) + b)
            a, d, c, b = d, c, b, NORM(ROL(XOR(d, AND(b, XOR(c, d))) + (K[j+1] + W[j+1] + a), 12) + b)
            a, d, c, b = d, c, b, NORM(ROL(XOR(d, AND(b, XOR(c, d))) + (K[j+2] + W[j+2] + a), 17) + b)
            a, d, c, b = d, c, b, NORM(ROL(XOR(d, AND(b, XOR(c, d))) + (K[j+3] + W[j+3] + a), 22) + b)
         end
         for j = 17, 32, 4 do
            local g = 5*j-4
            a, d, c, b = d, c, b, NORM(ROL(XOR(c, AND(d, XOR(b, c))) + (K[j  ] + W[AND(g     , 15) + 1] + a),  5) + b)
            a, d, c, b = d, c, b, NORM(ROL(XOR(c, AND(d, XOR(b, c))) + (K[j+1] + W[AND(g +  5, 15) + 1] + a),  9) + b)
            a, d, c, b = d, c, b, NORM(ROL(XOR(c, AND(d, XOR(b, c))) + (K[j+2] + W[AND(g + 10, 15) + 1] + a), 14) + b)
            a, d, c, b = d, c, b, NORM(ROL(XOR(c, AND(d, XOR(b, c))) + (K[j+3] + W[AND(g -  1, 15) + 1] + a), 20) + b)
         end
         for j = 33, 48, 4 do
            local g = 3*j+2
            a, d, c, b = d, c, b, NORM(ROL(XOR(b, c, d) + (K[j  ] + W[AND(g    , 15) + 1] + a),  4) + b)
            a, d, c, b = d, c, b, NORM(ROL(XOR(b, c, d) + (K[j+1] + W[AND(g + 3, 15) + 1] + a), 11) + b)
            a, d, c, b = d, c, b, NORM(ROL(XOR(b, c, d) + (K[j+2] + W[AND(g + 6, 15) + 1] + a), 16) + b)
            a, d, c, b = d, c, b, NORM(ROL(XOR(b, c, d) + (K[j+3] + W[AND(g - 7, 15) + 1] + a), 23) + b)
         end
         for j = 49, 64, 4 do
            local g = j*7
            a, d, c, b = d, c, b, NORM(ROL(XOR(c, OR(b, NOT(d))) + (K[j  ] + W[AND(g - 7, 15) + 1] + a),  6) + b)
            a, d, c, b = d, c, b, NORM(ROL(XOR(c, OR(b, NOT(d))) + (K[j+1] + W[AND(g    , 15) + 1] + a), 10) + b)
            a, d, c, b = d, c, b, NORM(ROL(XOR(c, OR(b, NOT(d))) + (K[j+2] + W[AND(g + 7, 15) + 1] + a), 15) + b)
            a, d, c, b = d, c, b, NORM(ROL(XOR(c, OR(b, NOT(d))) + (K[j+3] + W[AND(g - 2, 15) + 1] + a), 21) + b)
         end
         H[ 1 ], H[ 2 ], H[ 3 ], H[ 4 ] = NORM(a + H[ 1 ]), NORM(b + H[ 2 ]), NORM(c + H[ 3 ]), NORM(d + H[ 4 ])
      end
   end

   -- SHA-1 implementation for "LuaJIT without FFI" branch
   function sha1_feed_64(H, str, offs, size)
      -- offs >= 0, size >= 0, size is multiple of 64
      local W = common_W
      for pos = offs, offs + size - 1, 64 do
         for j = 1, 16 do
            pos = pos + 4
            local a, b, c, d = byte(str, pos - 3, pos)
            W[j] = OR(SHL(a, 24), SHL(b, 16), SHL(c, 8), d)
         end
         for j = 17, 80 do
            W[j] = ROL(XOR(W[j-3], W[j-8], W[j-14], W[j-16]), 1)
         end
         local a, b, c, d, e = H[ 1 ], H[ 2 ], H[ 3 ], H[ 4 ], H[ 5 ]
         for j = 1, 20, 5 do
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(d, AND(b, XOR(d, c))) + (W[j]   + 0x5A827999 + e))          -- constant = floor(2^30 * sqrt(2))
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(d, AND(b, XOR(d, c))) + (W[j+1] + 0x5A827999 + e))
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(d, AND(b, XOR(d, c))) + (W[j+2] + 0x5A827999 + e))
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(d, AND(b, XOR(d, c))) + (W[j+3] + 0x5A827999 + e))
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(d, AND(b, XOR(d, c))) + (W[j+4] + 0x5A827999 + e))
         end
         for j = 21, 40, 5 do
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(b, c, d) + (W[j]   + 0x6ED9EBA1 + e))                       -- 2^30 * sqrt(3)
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(b, c, d) + (W[j+1] + 0x6ED9EBA1 + e))
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(b, c, d) + (W[j+2] + 0x6ED9EBA1 + e))
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(b, c, d) + (W[j+3] + 0x6ED9EBA1 + e))
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(b, c, d) + (W[j+4] + 0x6ED9EBA1 + e))
         end
         for j = 41, 60, 5 do
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(AND(d, XOR(b, c)), AND(b, c)) + (W[j]   + 0x8F1BBCDC + e))  -- 2^30 * sqrt(5)
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(AND(d, XOR(b, c)), AND(b, c)) + (W[j+1] + 0x8F1BBCDC + e))
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(AND(d, XOR(b, c)), AND(b, c)) + (W[j+2] + 0x8F1BBCDC + e))
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(AND(d, XOR(b, c)), AND(b, c)) + (W[j+3] + 0x8F1BBCDC + e))
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(AND(d, XOR(b, c)), AND(b, c)) + (W[j+4] + 0x8F1BBCDC + e))
         end
         for j = 61, 80, 5 do
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(b, c, d) + (W[j]   + 0xCA62C1D6 + e))                       -- 2^30 * sqrt(10)
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(b, c, d) + (W[j+1] + 0xCA62C1D6 + e))
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(b, c, d) + (W[j+2] + 0xCA62C1D6 + e))
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(b, c, d) + (W[j+3] + 0xCA62C1D6 + e))
            e, d, c, b, a = d, c, ROR(b, 2), a, NORM(ROL(a, 5) + XOR(b, c, d) + (W[j+4] + 0xCA62C1D6 + e))
         end
         H[ 1 ], H[ 2 ], H[ 3 ], H[ 4 ], H[ 5 ] = NORM(a + H[ 1 ]), NORM(b + H[ 2 ]), NORM(c + H[ 3 ]), NORM(d + H[ 4 ]), NORM(e + H[ 5 ])
      end
   end
end

XOR = XOR or XORA5

do
   local function mul(src1, src2, factor, result_length)
      -- src1, src2 - long integers (arrays of digits in base 2^24)
      -- factor - small integer
      -- returns long integer result (src1 * src2 * factor) and its floating point approximation
      local result, carry, value, weight = { }, 0.0, 0.0, 1.0
      for j = 1, result_length do
         for k = math_max(1, j + 1 - #src2), math_min(j, #src1) do
            carry = carry + factor * src1[k] * src2[j + 1 - k]  -- "int32" is not enough for multiplication result, that's why "factor" must be of type "double"
         end
         local digit = carry % 2^24
         result[j] = floor(digit)
         carry = (carry - digit) / 2^24
         value = value + digit * weight
         weight = weight * 2^24
      end
      return result, value
   end

   local idx, step, p, one, sqrt_hi, sqrt_lo = 0, {4, 1, 2, -2, 2}, 4, {1}, sha2_H_hi, sha2_H_lo
   repeat
      p = p + step[p % 6]
      local d = 1
      repeat
         d = d + step[d % 6]
         if d*d > p then -- next prime number is found
            local root = p^(1/3)
            local R = root * 2^40
            R = mul({R - R % 1}, one, 1.0, 2)
            local _, delta = mul(R, mul(R, R, 1.0, 4), -1.0, 4)
            local hi = R[ 2 ] % 65536 * 65536 + floor(R[ 1 ] / 256)
            local lo = R[ 1 ] % 256 * 16777216 + floor(delta * (2^-56 / 3) * root / p)
            if idx < 16 then
               root = p^(1/2)
               R = root * 2^40
               R = mul({R - R % 1}, one, 1.0, 2)
               _, delta = mul(R, R, -1.0, 2)
               local hi = R[ 2 ] % 65536 * 65536 + floor(R[ 1 ] / 256)
               local lo = R[ 1 ] % 256 * 16777216 + floor(delta * 2^-17 / root)
               local idx = idx % 8 + 1
               sha2_H_ext256[224][idx] = lo
               sqrt_hi[idx], sqrt_lo[idx] = hi, lo + hi * hi_factor
               if idx > 7 then
                  sqrt_hi, sqrt_lo = sha2_H_ext512_hi[384], sha2_H_ext512_lo[384]
               end
            end
            idx = idx + 1
            sha2_K_hi[idx], sha2_K_lo[idx] = hi, lo % K_lo_modulo + hi * hi_factor
            break
         end
      until p % d == 0
   until idx > 79
end

-- Calculating IVs for SHA512/224 and SHA512/256
for width = 224, 256, 32 do
   local H_lo, H_hi = { }
   if HEX64 then
      for j = 1, 8 do
         H_lo[j] = XORA5(sha2_H_lo[j])
      end
   else
      H_hi = { }
      for j = 1, 8 do
         H_lo[j] = XORA5(sha2_H_lo[j])
         H_hi[j] = XORA5(sha2_H_hi[j])
      end
   end
   sha512_feed_128(H_lo, H_hi, "SHA-512/"..tostring(width).."\128"..string_rep("\0", 115).."\88", 0, 128)
   sha2_H_ext512_lo[width] = H_lo
   sha2_H_ext512_hi[width] = H_hi
end

-- Constants for MD5
do
   local sin, abs, modf = math.sin, math.abs, math.modf
   for idx = 1, 64 do
      -- we can't use formula floor(abs(sin(idx))*2^32) because its result may be beyond integer range on Lua built with 32-bit integers
      local hi, lo = modf(abs(sin(idx)) * 2^16)
      md5_K[idx] = hi * 65536 + floor(lo * 2^16)
   end
end

-- Constants for SHA-3
do
   local sh_reg = 29

   local function next_bit( )
      local r = sh_reg % 2
      sh_reg = XOR_BYTE((sh_reg - r) / 2, 142 * r)
      return r
   end

   for idx = 1, 24 do
      local lo, m = 0
      for _ = 1, 6 do
         m = m and m * m * 2 or 1
         lo = lo + next_bit( ) * m
      end
      local hi = next_bit( ) * m
      sha3_RC_hi[idx], sha3_RC_lo[idx] = hi, lo + hi * hi_factor_keccak
   end
end

--------------------------------------------------------------------------------
-- MAIN FUNCTIONS
--------------------------------------------------------------------------------

local function sha256ext(width, msg)
   -- Create an instance (private objects for current calculation)
   local H, length, tail = {unpack(sha2_H_ext256[width])}, 0.0, ""

   local function partial(message_part)
      if message_part then
         if tail then
            length = length + #message_part
            local offs = 0
            if tail ~= "" and #tail + #message_part >= 64 then
               offs = 64 - #tail
               sha256_feed_64(H, tail..sub(message_part, 1, offs), 0, 64)
               tail = ""
            end
            local size = #message_part - offs
            local size_tail = size % 64
            sha256_feed_64(H, message_part, offs, size - size_tail)
            tail = tail..sub(message_part, #message_part + 1 - size_tail)
            return partial
         else
            error("Adding more chunks is not allowed after receiving the result", 2)
         end
      else
         if tail then
            local final_blocks = {tail, "\128", string_rep("\0", (-9 - length) % 64 + 1)}
            tail = nil
            -- Assuming user data length is shorter than (2^53)-9 bytes
            -- Anyway, it looks very unrealistic that someone would spend more than a year of calculations to process 2^53 bytes of data by using this Lua script :-)
            -- 2^53 bytes = 2^56 bits, so "bit-counter" fits in 7 bytes
            length = length * (8 / 256^7)  -- convert "byte-counter" to "bit-counter" and move decimal point to the left
            for j = 4, 10 do
               length = length % 1 * 256
               final_blocks[j] = char(floor(length))
            end
            final_blocks = table_concat(final_blocks)
            sha256_feed_64(H, final_blocks, 0, #final_blocks)
            local max_reg = width / 32
            for j = 1, max_reg do
               H[j] = HEX(H[j])
            end
            H = table_concat(H, "", 1, max_reg)
         end
         return H
      end
   end

   if msg then
      -- Actually perform calculations and return the SHA256 digest of a msg
      return partial(msg)( )
   else
      -- Return function for chunk-by-chunk loading
      -- User should feed every chunk of input data as single argument to this function and finally get SHA256 digest by invoking this function without an argument
      return partial
   end
end


local function sha512ext(width, msg)
   -- Create an instance (private objects for current calculation)
   local length, tail, H_lo, H_hi = 0.0, "", {unpack(sha2_H_ext512_lo[width])}, not HEX64 and {unpack(sha2_H_ext512_hi[width])}

   local function partial(message_part)
      if message_part then
         if tail then
            length = length + #message_part
            local offs = 0
            if tail ~= "" and #tail + #message_part >= 128 then
               offs = 128 - #tail
               sha512_feed_128(H_lo, H_hi, tail..sub(message_part, 1, offs), 0, 128)
               tail = ""
            end
            local size = #message_part - offs
            local size_tail = size % 128
            sha512_feed_128(H_lo, H_hi, message_part, offs, size - size_tail)
            tail = tail..sub(message_part, #message_part + 1 - size_tail)
            return partial
         else
            error("Adding more chunks is not allowed after receiving the result", 2)
         end
      else
         if tail then
            local final_blocks = {tail, "\128", string_rep("\0", (-17-length) % 128 + 9)}
            tail = nil
            -- Assuming user data length is shorter than (2^53)-17 bytes
            -- 2^53 bytes = 2^56 bits, so "bit-counter" fits in 7 bytes
            length = length * (8 / 256^7)  -- convert "byte-counter" to "bit-counter" and move floating point to the left
            for j = 4, 10 do
               length = length % 1 * 256
               final_blocks[j] = char(floor(length))
            end
            final_blocks = table_concat(final_blocks)
            sha512_feed_128(H_lo, H_hi, final_blocks, 0, #final_blocks)
            local max_reg = ceil(width / 64)
            if HEX64 then
               for j = 1, max_reg do
                  H_lo[j] = HEX64(H_lo[j])
               end
            else
               for j = 1, max_reg do
                  H_lo[j] = HEX(H_hi[j])..HEX(H_lo[j])
               end
               H_hi = nil
            end
            H_lo = sub(table_concat(H_lo, "", 1, max_reg), 1, width / 4)
         end
         return H_lo
      end
   end

   if msg then
      -- Actually perform calculations and return the SHA512 digest of a msg
      return partial(msg)( )
   else
      -- Return function for chunk-by-chunk loading
      -- User should feed every chunk of input data as single argument to this function and finally get SHA512 digest by invoking this function without an argument
      return partial
   end
end

local function md5(msg)
   -- Create an instance (private objects for current calculation)
   local H, length, tail = {unpack(md5_sha1_H, 1, 4)}, 0.0, ""

   local function partial(message_part)
      if message_part then
         if tail then
            length = length + #message_part
            local offs = 0
            if tail ~= "" and #tail + #message_part >= 64 then
               offs = 64 - #tail
               md5_feed_64(H, tail..sub(message_part, 1, offs), 0, 64)
               tail = ""
            end
            local size = #message_part - offs
            local size_tail = size % 64
            md5_feed_64(H, message_part, offs, size - size_tail)
            tail = tail..sub(message_part, #message_part + 1 - size_tail)
            return partial
         else
            error("Adding more chunks is not allowed after receiving the result", 2)
         end
      else
         if tail then
            local final_blocks = {tail, "\128", string_rep("\0", (-9 - length) % 64)}
            tail = nil
            length = length * 8  -- convert "byte-counter" to "bit-counter"
            for j = 4, 11 do
               local low_byte = length % 256
               final_blocks[j] = char(low_byte)
               length = (length - low_byte) / 256
            end
            final_blocks = table_concat(final_blocks)
            md5_feed_64(H, final_blocks, 0, #final_blocks)
            for j = 1, 4 do
               H[j] = HEX(H[j])
            end
            H = gsub(table_concat(H), "(..)(..)(..)(..)", "%4%3%2%1")
         end
         return H
      end
   end

   if msg then
      -- Actually perform calculations and return the MD5 digest of a msg
      return partial(msg)( )
   else
      -- Return function for chunk-by-chunk loading
      -- User should feed every chunk of input data as single argument to this function and finally get MD5 digest by invoking this function without an argument
      return partial
   end
end

local function sha1(msg)
   -- Create an instance (private objects for current calculation)
   local H, length, tail = {unpack(md5_sha1_H)}, 0.0, ""

   local function partial(message_part)
      if message_part then
         if tail then
            length = length + #message_part
            local offs = 0
            if tail ~= "" and #tail + #message_part >= 64 then
               offs = 64 - #tail
               sha1_feed_64(H, tail..sub(message_part, 1, offs), 0, 64)
               tail = ""
            end
            local size = #message_part - offs
            local size_tail = size % 64
            sha1_feed_64(H, message_part, offs, size - size_tail)
            tail = tail..sub(message_part, #message_part + 1 - size_tail)
            return partial
         else
            error("Adding more chunks is not allowed after receiving the result", 2)
         end
      else
         if tail then
            local final_blocks = {tail, "\128", string_rep("\0", (-9 - length) % 64 + 1)}
            tail = nil
            -- Assuming user data length is shorter than (2^53)-9 bytes
            -- 2^53 bytes = 2^56 bits, so "bit-counter" fits in 7 bytes
            length = length * (8 / 256^7)  -- convert "byte-counter" to "bit-counter" and move decimal point to the left
            for j = 4, 10 do
               length = length % 1 * 256
               final_blocks[j] = char(floor(length))
            end
            final_blocks = table_concat(final_blocks)
            sha1_feed_64(H, final_blocks, 0, #final_blocks)
            for j = 1, 5 do
               H[j] = HEX(H[j])
            end
            H = table_concat(H)
         end
         return H
      end
   end

   if msg then
      -- Actually perform calculations and return the SHA-1 digest of a msg
      return partial(msg)( )
   else
      -- Return function for chunk-by-chunk loading
      -- User should feed every chunk of input data as single argument to this function and finally get SHA-1 digest by invoking this function without an argument
      return partial
   end
end

local function keccak(block_size_in_bytes, digest_size_in_bytes, is_SHAKE, msg)
   -- "block_size_in_bytes" is multiple of 8
   if type(digest_size_in_bytes) ~= "number" then
      -- arguments in SHAKE are swapped:
      --    NIST FIPS 202 defines SHAKE(msg,num_bits)
      --    this module   defines SHAKE(num_bytes,msg)
      -- it's easy to forget about this swap, hence the check
      error("Argument 'digest_size_in_bytes' must be a number", 2)
   end
   -- Create an instance (private objects for current calculation)
   local tail, lanes_lo, lanes_hi = "", create_array_of_lanes( ), hi_factor_keccak == 0 and create_array_of_lanes( )
   local result

   local function partial(message_part)
      if message_part then
         if tail then
            local offs = 0
            if tail ~= "" and #tail + #message_part >= block_size_in_bytes then
               offs = block_size_in_bytes - #tail
               keccak_feed(lanes_lo, lanes_hi, tail..sub(message_part, 1, offs), 0, block_size_in_bytes, block_size_in_bytes)
               tail = ""
            end
            local size = #message_part - offs
            local size_tail = size % block_size_in_bytes
            keccak_feed(lanes_lo, lanes_hi, message_part, offs, size - size_tail, block_size_in_bytes)
            tail = tail..sub(message_part, #message_part + 1 - size_tail)
            return partial
         else
            error("Adding more chunks is not allowed after receiving the result", 2)
         end
      else
         if tail then
            -- append the following bits to the msg: for usual SHA-3: 011(0*)1, for SHAKE: 11111(0*)1
            local gap_start = is_SHAKE and 31 or 6
            tail = tail..(#tail + 1 == block_size_in_bytes and char(gap_start + 128) or char(gap_start)..string_rep("\0", (-2 - #tail) % block_size_in_bytes).."\128")
            keccak_feed(lanes_lo, lanes_hi, tail, 0, #tail, block_size_in_bytes)
            tail = nil
            local lanes_used = 0
            local total_lanes = floor(block_size_in_bytes / 8)
            local qwords = { }

            local function get_next_qwords_of_digest(qwords_qty)
               -- returns not more than 'qwords_qty' qwords ('qwords_qty' might be non-integer)
               -- doesn't go across keccak-buffer boundary
               -- block_size_in_bytes is a multiple of 8, so, keccak-buffer contains integer number of qwords
               if lanes_used >= total_lanes then
                  keccak_feed(lanes_lo, lanes_hi, "\0\0\0\0\0\0\0\0", 0, 8, 8)
                  lanes_used = 0
               end
               qwords_qty = floor(math_min(qwords_qty, total_lanes - lanes_used))
               if hi_factor_keccak ~= 0 then
                  for j = 1, qwords_qty do
                     qwords[j] = HEX64(lanes_lo[lanes_used + j - 1 + lanes_index_base])
                  end
               else
                  for j = 1, qwords_qty do
                     qwords[j] = HEX(lanes_hi[lanes_used + j])..HEX(lanes_lo[lanes_used + j])
                  end
               end
               lanes_used = lanes_used + qwords_qty
               return
                  gsub(table_concat(qwords, "", 1, qwords_qty), "(..)(..)(..)(..)(..)(..)(..)(..)", "%8%7%6%5%4%3%2%1"),
                  qwords_qty * 8
            end

            local parts = { }      -- digest parts
            local last_part, last_part_size = "", 0

            local function get_next_part_of_digest(bytes_needed)
               -- returns 'bytes_needed' bytes, for arbitrary integer 'bytes_needed'
               bytes_needed = bytes_needed or 1
               if bytes_needed <= last_part_size then
                  last_part_size = last_part_size - bytes_needed
                  local part_size_in_nibbles = bytes_needed * 2
                  local result = sub(last_part, 1, part_size_in_nibbles)
                  last_part = sub(last_part, part_size_in_nibbles + 1)
                  return result
               end
               local parts_qty = 0
               if last_part_size > 0 then
                  parts_qty = 1
                  parts[parts_qty] = last_part
                  bytes_needed = bytes_needed - last_part_size
               end
               -- repeats until the length is enough
               while bytes_needed >= 8 do
                  local next_part, next_part_size = get_next_qwords_of_digest(bytes_needed / 8)
                  parts_qty = parts_qty + 1
                  parts[parts_qty] = next_part
                  bytes_needed = bytes_needed - next_part_size
               end
               if bytes_needed > 0 then
                  last_part, last_part_size = get_next_qwords_of_digest(1)
                  parts_qty = parts_qty + 1
                  parts[parts_qty] = get_next_part_of_digest(bytes_needed)
               else
                  last_part, last_part_size = "", 0
               end
               return table_concat(parts, "", 1, parts_qty)
            end

            if digest_size_in_bytes < 0 then
               result = get_next_part_of_digest
            else
               result = get_next_part_of_digest(digest_size_in_bytes)
            end
         end
         return result
      end
   end

   if msg then
      -- Actually perform calculations and return the SHA-3 digest of a msg
      return partial(msg)( )
   else
      -- Return function for chunk-by-chunk loading
      -- User should feed every chunk of input data as single argument to this function and finally get SHA-3 digest by invoking this function without an argument
      return partial
   end
end


local hex_to_bin, bin_to_hex, bin_to_base64, base64_to_bin
do
   function hex_to_bin(hex_string)
      return (gsub(hex_string, "%x%x",
         function (hh)
            return char(tonumber(hh, 16))
         end
      ))
   end

   function bin_to_hex(binary_string)
      return (gsub(binary_string, ".",
         function (c)
            return string_format("%02x", byte(c))
         end
      ))
   end

   local base64_symbols = {
      ['+'] = 62, ['-'] = 62,  [62] = '+',
      ['/'] = 63, ['_'] = 63,  [63] = '/',
      ['='] = -1, ['.'] = -1,  [-1] = '='
   }
   local symbol_index = 0
   for j, pair in ipairs{'AZ', 'az', '09'} do
      for ascii = byte(pair), byte(pair, 2) do
         local ch = char(ascii)
         base64_symbols[ch] = symbol_index
         base64_symbols[symbol_index] = ch
         symbol_index = symbol_index + 1
      end
   end

   function bin_to_base64(binary_string)
      local result = { }
      for pos = 1, #binary_string, 3 do
         local c1, c2, c3, c4 = byte(sub(binary_string, pos, pos + 2)..'\0', 1, -1)
         result[#result + 1] =
            base64_symbols[floor(c1 / 4)]
            ..base64_symbols[c1 % 4 * 16 + floor(c2 / 16)]
            ..base64_symbols[c3 and c2 % 16 * 4 + floor(c3 / 64) or -1]
            ..base64_symbols[c4 and c3 % 64 or -1]
      end
      return table_concat(result)
   end

   function base64_to_bin(base64_string)
      local result, chars_qty = { }, 3
      for pos, ch in gmatch(gsub(base64_string, '%s+', ''), '( )(.)') do
         local code = base64_symbols[ch]
         if code < 0 then
            chars_qty = chars_qty - 1
            code = 0
         end
         local idx = pos % 4
         if idx > 0 then
            result[-idx] = code
         else
            local c1 = result[-1] * 4 + floor(result[-2] / 16)
            local c2 = (result[-2] % 16) * 16 + floor(result[-3] / 4)
            local c3 = (result[-3] % 4) * 64 + code
            result[#result + 1] = sub(char(c1, c2, c3), 1, chars_qty)
         end
      end
      return table_concat(result)
   end

end

local block_size_for_HMAC  -- this table will be initialized at the end of the module

local function pad_and_xor(str, result_length, byte_for_xor)
   return gsub(str, ".",
      function(c)
         return char(XOR_BYTE(byte(c), byte_for_xor))
      end
   )..string_rep(char(byte_for_xor), result_length - #str)
end

local function hmac(hash_func, key, msg)
   -- Create an instance (private objects for current calculation)
   local block_size = block_size_for_HMAC[hash_func]
   if not block_size then
      error("Unknown hash function", 2)
   end
   if #key > block_size then
      key = hex_to_bin(hash_func(key))
   end
   local append = hash_func( )(pad_and_xor(key, block_size, 0x36))
   local result

   local function partial(message_part)
      if not message_part then
         result = result or hash_func(pad_and_xor(key, block_size, 0x5C)..hex_to_bin(append( )))
         return result
      elseif result then
         error("Adding more chunks is not allowed after receiving the result", 2)
      else
         append(message_part)
         return partial
      end
   end

   if msg then
      -- Actually perform calculations and return the HMAC of a msg
      return partial(msg)( )
   else
      -- Return function for chunk-by-chunk loading of a msg
      -- User should feed every chunk of the msg as single argument to this function and finally get HMAC by invoking this function without an argument
      return partial
   end
end

sha2 =
{
   md5                      = md5,                                                                                                                   -- MD5
   sha1                     = sha1,                                                                                                                  -- SHA-1

   sha224                   = function( msg )                       return sha256ext(224, msg)                                           end, -- SHA-224
   sha256                   = function( msg )                       return sha256ext(256, msg)                                           end, -- SHA-256
   sha512_224               = function( msg )                       return sha512ext(224, msg)                                           end, -- SHA-512/224
   sha512_256               = function( msg )                       return sha512ext(256, msg)                                           end, -- SHA-512/256
   sha384                   = function( msg )                       return sha512ext(384, msg)                                           end, -- SHA-384
   sha512                   = function( msg )                       return sha512ext(512, msg)                                           end, -- SHA-512

   sha3_224                 = function( msg )                       return keccak((1600 - 2 * 224) / 8, 224 / 8, false, msg)             end, -- SHA3-224
   sha3_256                 = function( msg )                       return keccak((1600 - 2 * 256) / 8, 256 / 8, false, msg)             end, -- SHA3-256
   sha3_384                 = function( msg )                       return keccak((1600 - 2 * 384) / 8, 384 / 8, false, msg)             end, -- SHA3-384
   sha3_512                 = function( msg )                       return keccak((1600 - 2 * 512) / 8, 512 / 8, false, msg)             end, -- SHA3-512
   shake128                 = function (digest_size_in_bytes, msg) return keccak((1600 - 2 * 128) / 8, digest_size_in_bytes, true, msg) end, -- SHAKE128
   shake256                 = function (digest_size_in_bytes, msg) return keccak((1600 - 2 * 256) / 8, digest_size_in_bytes, true, msg) end, -- SHAKE256

   hmac                     = hmac,                 -- HMAC(hash_func, key, msg) is applicable to any hash function from this module except SHAKE* and BLAKE*
   hex_to_bin               = hex_to_bin,           -- converts hexadecimal representation to binary string
   bin_to_hex               = bin_to_hex,           -- converts binary string to hexadecimal representation
   base64_to_bin            = base64_to_bin,        -- converts base64 representation to binary string
   bin_to_base64            = bin_to_base64,        -- converts binary string to base64 representation
   hex2bin                  = hex_to_bin,
   bin2hex                  = bin_to_hex,
   base642bin               = base64_to_bin,
   bin2base64               = bin_to_base64,
}

block_size_for_HMAC =
{
   [sha2.md5]               =  64,
   [sha2.sha1]              =  64,
   [sha2.sha224]            =  64,
   [sha2.sha256]            =  64,
   [sha2.sha512_224]        = 128,
   [sha2.sha512_256]        = 128,
   [sha2.sha384]            = 128,
   [sha2.sha512]            = 128,
   [sha2.sha3_224]          = 144,  -- (1600 - 2 * 224) / 8
   [sha2.sha3_256]          = 136,  -- (1600 - 2 * 256) / 8
   [sha2.sha3_384]          = 104,  -- (1600 - 2 * 384) / 8
   [sha2.sha3_512]          =  72,  -- (1600 - 2 * 512) / 8
}

return sha2