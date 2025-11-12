fx_version 'cerulean'
game 'gta5'

author 'Flake Development'
description 'Ammunation Job Script GRIZZLEY WORLD INSPIRED'
discord 'https://discord.com/invite/kkP99Xzcue'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

-- Escrow Ignore
escrow_ignore {
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

dependencies {
    'es_extended',
    'ox_lib',
    'oxmysql'
}

lua54 'yes'

