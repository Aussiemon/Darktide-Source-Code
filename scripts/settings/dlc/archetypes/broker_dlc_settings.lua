-- chunkname: @scripts/settings/dlc/archetypes/broker_dlc_settings.lua

local STEAM_APP_ID = 4013290
local XBOX_APP_ID = "9P9Z6BRXGBL8"
local PSN_APP_ID = "0270002574112453"
local DLCSettings = {
	dlc_id = "broker",
	image = "content/ui/textures/dlc/broker/dt_broker_standard_store_large",
	includes = nil,
	loc_name = "loc_dlc_broker_name",
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
}

return DLCSettings
