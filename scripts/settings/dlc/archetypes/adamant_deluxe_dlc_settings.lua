-- chunkname: @scripts/settings/dlc/archetypes/adamant_deluxe_dlc_settings.lua

local STEAM_APP_ID = 3710950
local XBOX_APP_ID = "9P6MPZR3334D"
local PSN_APP_ID = "0092450731028132"
local DLCSettings = {
	dlc_id = "adamant_deluxe",
	image = "content/ui/textures/dlc/adamant/dt_adamant_deluxe_store_large",
	loc_name = "loc_dlc_adamant_name_deluxe",
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
	includes = {
		"adamant",
		"adamant_cosmetic",
	},
}

return DLCSettings
