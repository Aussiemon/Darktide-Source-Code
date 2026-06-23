-- chunkname: @scripts/settings/dlc/archetypes/broker_deluxe_dlc_settings.lua

local STEAM_APP_ID = 4013310
local XBOX_APP_ID = "9NFWZ1XDJFPR"
local PSN_APP_ID = "0920608558932472"
local DLCSettings = {
	dlc_id = "broker_deluxe",
	image = "content/ui/textures/dlc/broker/dt_broker_deluxe_store_large",
	loc_name = "loc_dlc_broker_name_deluxe",
	texture_package = "packages/ui/dlc/broker",
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
		"broker",
		"broker_cosmetic",
	},
}

return DLCSettings
