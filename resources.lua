resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

--[[
	#Muie Tibi
	#Muie Warof
]]

client_scripts {
	'client.lua',
	'lib/Proxy.lua'
}
server_scripts {
	'@vrp/lib/utils.lua',
	'server.lua'
}

dependencies {
	'vrp',
	'vrp_mysql'
}
