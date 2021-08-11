/*
*   @package        : rlib
*   @author         : Richard [http://steamcommunity.com/profiles/76561198135875727]
*   @copyright      : (C) 2018 - 2020
*   @since          : 1.0.0
*   @website        : https://rlib.io
*   @docs           : https://docs.rlib.io
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
*   standard tables and localization
*/

local base                  = rlib

/*
*   associated hooks
*/

base.c.hooks =
{
    [ 'rlib_loader_post' ]                      = { 'rlib.loader.post' },
    [ 'rlib_initialize_post' ]                  = { 'rlib.initialize.post' },
    [ 'rlib_calls_pre' ]                        = { 'rlib.calls.pre' },
    [ 'rlib_calls_post' ]                       = { 'rlib.calls.post' },
    [ 'rlib_cmd_register' ]                     = { 'rlib.cmd.register' },
    [ 'rlib_pkg_register' ]                     = { 'rlib.pkg.register' },
    [ 'rlib_rnet_register' ]                    = { 'rlib.rnet.register' },
    [ 'rlib_fonts_register' ]                   = { 'rlib.fonts.register' },
    [ 'rlib_server_fjoin' ]                     = { 'rlib.server.fjoin' },
    [ 'rlib_server_welcome' ]                   = { 'rlib.server.welcome' },
    [ 'rlib_server_ready' ]                     = { 'rlib.server.ready' },
    [ 'rcore_rnet_register' ]                   = { 'rcore.rnet.register' },
    [ 'rcore_loader_post' ]                     = { 'rcore.loader.post' },
    [ 'rcore_onloaded' ]                        = { 'rcore.onloaded' },
    [ 'rcore_initialize_stats' ]                = { 'rcore.initialize.stats' },
    [ 'rcore_modules_initialize' ]              = { 'rcore.modules.initialize' },
    [ 'rcore_modules_register' ]                = { 'rcore.modules.register' },
    [ 'rcore_modules_onreload' ]                = { 'rcore.modules.onreload' },
    [ 'rcore_modules_writedata' ]               = { 'rcore.modules.writedata' },
    [ 'rcore_modules_storage' ]                 = { 'rcore.modules.storage' },
    [ 'rcore_modules_precache' ]                = { 'rcore.modules.precache' },
    [ 'rcore_modules_load_pre' ]                = { 'rcore.modules.load.pre' },
    [ 'rcore_modules_load_post' ]               = { 'rcore.modules.load.post' },
    [ 'rcore_modules_perms_register' ]          = { 'rcore.modules.perms.register' },
    [ 'rcore_modules_dependencies' ]            = { 'rcore.modules.dependencies' },
    [ 'rcore_modules_res_register' ]            = { 'rcore.modules.res.register' },
    [ 'rcore_modules_ptc_register' ]            = { 'rcore.modules.ptc.register' },
    [ 'rcore_modules_snd_register' ]            = { 'rcore.modules.snd.register' },
    [ 'rcore_modules_storage_struct' ]          = { 'rcore.modules.storage.struct' },
}