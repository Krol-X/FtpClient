require "luaver"
local verdll  = '?'.._VERSION_I..".dll;"
package.path  = "./lib/?.lua;../lib/?.lua;" ..
                "./src/?.lua;../src/?.lua;" ..
                package.path
package.cpath = "./clibs/?.dll;../clibs/?.dll;" ..
                "./clibs/"..verdll ..
                "../clibs/"..verdll ..
                package.cpath
require "lfs"; require "ktools"; ktools.install()
extra.require {"conio", "sock", "config", "tools"}