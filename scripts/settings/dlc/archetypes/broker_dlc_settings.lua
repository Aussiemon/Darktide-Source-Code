-- chunkname: @scripts/settings/dlc/archetypes/broker_dlc_settings.lua

local DLCSettings = {
	dlc_id = "broker",
	image = "content/ui/textures/dlc/broker/dt_broker_standard_store_large",
	loc_name = "loc_dlc_broker_name",
	steam_dlc_target = 4013290,
	texture_package = "packages/ui/dlc/broker",
	ids = {
		[Backend.AUTH_METHOD_NONE] = {
			id = 4013290,
		},
		[Backend.AUTH_METHOD_STEAM] = {
			id = 4013290,
		},
		[Backend.AUTH_METHOD_XBOXLIVE] = {
			id = "9P9Z6BRXGBL8",
		},
		[Backend.AUTH_METHOD_PSN] = {
			id = "0270002574112453",
		},
		[Backend.AUTH_METHOD_DEV_USER] = {
			id = 4013290,
		},
		[Backend.AUTH_METHOD_AWS] = {
			id = 4013290,
		},
	},
}

return DLCSettings
