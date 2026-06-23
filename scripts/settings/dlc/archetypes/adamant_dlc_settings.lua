-- chunkname: @scripts/settings/dlc/archetypes/adamant_dlc_settings.lua

local STEAM_APP_ID = 3710910
local XBOX_APP_ID = "9NQ48H8FW60H"
local PSN_APP_ID = "0168620603438961"
local DLCSettings = {
	dlc_id = "adamant",
	image = "content/ui/textures/dlc/adamant/dt_adamant_standard_store_large",
	includes = nil,
	loc_name = "loc_dlc_adamant_name",
	texture_package = "packages/ui/dlc/adamant",
	steam_dlc_target = STEAM_APP_ID,
	ids = {
		[Backend.AUTH_METHOD_NONE] = {
			id = STEAM_APP_ID,
		},
		[Backend.AUTH_METHOD_STEAM] = {
			id = STEAM_APP_ID,
		},
		[Backend.AUTH_METHOD_XBOXLIVE] = {
			id = XBOX_APP_ID,
		},
		[Backend.AUTH_METHOD_PSN] = {
			id = PSN_APP_ID,
		},
		[Backend.AUTH_METHOD_DEV_USER] = {
			id = STEAM_APP_ID,
		},
		[Backend.AUTH_METHOD_AWS] = {
			id = STEAM_APP_ID,
		},
	},
}

return DLCSettings
