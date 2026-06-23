-- chunkname: @scripts/settings/dlc/archetypes/cryptic_cosmetic_dlc_settings.lua

local STEAM_APP_ID = 4355590
local XBOX_APP_ID = "9P9KVV0CK9NR"
local PSN_APP_ID = "0181906436334516"
local DLCSettings = {
	dlc_id = "cryptic_cosmetic",
	image = "content/ui/textures/dlc/cryptic/dt_cryptic_deluxe_store_large",
	includes = nil,
	loc_name = "loc_dlc_cryptic_name_cosmetic",
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
}

return DLCSettings
