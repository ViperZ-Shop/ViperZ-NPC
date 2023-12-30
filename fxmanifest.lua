fx_version 'cerulean'
games { 'gta5' }

author 'oowni'
descripton 'Interaction with NPC'

client_scripts {
    'Client/*.lua'
}

server_scripts {
    'Server/*.lua'
}

shared_scripts {
    'Shared/*.lua',
    '@es_extended/imports.lua'
}

dependency {
    'ox_target'
}
