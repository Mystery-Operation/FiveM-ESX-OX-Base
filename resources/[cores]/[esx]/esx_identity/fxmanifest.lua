fx_version 'adamant'

game 'gta5'

author 'Mercy Collective'
description 'Identity'
version '1.7.6'

shared_script '@es_extended/imports.lua'

server_scripts {
	'@es_extended/locale.lua',
	'@oxmysql/lib/MySQL.lua',
	'locales/*.lua',
	'shared/*.lua',
	'server/*.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'shared/*.lua',
	'client/*.lua'
}

ui_page 'nui/index.html'

files {
	'nui/index.html',
	'nui/js/*.js',
	'nui/css/*.css',
	'nui/img/*.png'
}

dependency 'es_extended'
