fx_version 'cerulean'
game 'gta5'

author 'Tonybyn_Mp4'
description 'Whiteboard script for the Qbox Framework'
repository 'https://github.com/TonybynMp4/qbx_whiteboard'
version '1.0.0'

ox_lib 'locale'
shared_script '@ox_lib/init.lua'

client_scripts {
    "@qbx_core/modules/playerdata.lua",
    "client/main.lua"
}
server_script "server/main.lua"

files {
    'locales/*.json',
    'config/shared.lua'
}

dependencies {
    'ox_target',
    'ox_lib'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'