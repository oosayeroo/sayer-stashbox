fx_version 'cerulean'
game 'gta5'

author 'oosayeroo'
description 'sayer-stashbox'
version '2.0.0'

client_scripts {
	'client/stashes.lua',
	'client/utils.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua',
}

shared_scripts{
    'shared/config.lua',
}

files {
    'images/**/*.png',
}

lua54 'yes'
