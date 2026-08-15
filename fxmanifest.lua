fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Snipz'
description 'Qbox admin menu with ACE permissions and NUI controls'
version '1.0.0'

ui_page 'web/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

files {
    'web/index.html',
    'web/style.css',
    'web/app.js',
    'web/map.jpg',
    'web/map.png',
    'web/assets/map.jpg',
    'web/assets/map.png',
    'web/assets/notification.mp3'
}

dependencies {
    'ox_lib',
    'qbx_core'
}
