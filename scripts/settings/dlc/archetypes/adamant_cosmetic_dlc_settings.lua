-- chunkname: @scripts/settings/dlc/archetypes/adamant_cosmetic_dlc_settings.lua

local STEAM_APP_ID = 3710980
local XBOX_APP_ID = "9MVN99H63RQK"
local PSN_APP_ID = "0510635763510404"
local DLCSettings = {
	dlc_id = "adamant_cosmetic",
	image = "content/ui/textures/dlc/adamant/dt_adamant_deluxe_store_large",
	includes = nil,
	loc_name = "loc_dlc_adamant_name_cosmetic_upgrade",
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
