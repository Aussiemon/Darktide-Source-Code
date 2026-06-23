-- chunkname: @scripts/settings/dlc/archetypes/cryptic_dlc_settings.lua

local STEAM_APP_ID = 4355570
local XBOX_APP_ID = "9N203353G6K5"
local PSN_APP_ID = "0284341309902089"
local DLCSettings = {
	dlc_id = "cryptic",
	image = "content/ui/textures/dlc/cryptic/dt_cryptic_standard_store_large",
	includes = nil,
	loc_name = "loc_dlc_cryptic_name",
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
