-- chunkname: @scripts/settings/dlc/archetypes/broker_cosmetic_dlc_settings.lua

local DLCSettings = {
	dlc_id = "broker_cosmetic",
	image = "content/ui/textures/dlc/broker/dt_broker_deluxe_store_large",
	loc_name = "loc_dlc_broker_name_cosmetic_upgrade",
	steam_dlc_target = 4013300,
	texture_package = "packages/ui/dlc/broker",
	ids = {
		[Backend.AUTH_METHOD_NONE] = {
			id = 4013310,
		},
		[Backend.AUTH_METHOD_STEAM] = {
			id = 4013300,
		},
		[Backend.AUTH_METHOD_XBOXLIVE] = {
			id = "9NTGFSGF675Q",
		},
		[Backend.AUTH_METHOD_PSN] = {
			id = "0379884819085244",
		},
		[Backend.AUTH_METHOD_DEV_USER] = {
			id = 4013310,
		},
		[Backend.AUTH_METHOD_AWS] = {
			id = 4013310,
		},
	},
}

return DLCSettings
