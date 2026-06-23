-- chunkname: @scripts/settings/dlc/archetypes/cryptic_deluxe_dlc_settings.lua

local STEAM_APP_ID = 4355580
local XBOX_APP_ID = "9NTJRW4LNVSD"
local PSN_APP_ID = "0631061521035953"
local DLCSettings = {
	dlc_id = "cryptic_deluxe",
	image = "content/ui/textures/dlc/cryptic/dt_cryptic_deluxe_store_large",
	loc_name = "loc_dlc_cryptic_name_deluxe",
	texture_package = "packages/ui/dlc/cryptic",
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
		"cryptic",
		"cryptic_cosmetic",
	},
}

return DLCSettings
