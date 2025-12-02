-- chunkname: @scripts/settings/dlc/archetypes/broker_deluxe_dlc_settings.lua

local DLCSettings = {
	dlc_id = "broker_deluxe",
	image = "content/ui/textures/dlc/broker/dt_broker_deluxe_store_large",
	loc_name = "loc_dlc_broker_name_deluxe",
	steam_dlc_target = 4013310,
	texture_package = "packages/ui/dlc/broker",
	ids = {
		[Backend.AUTH_METHOD_NONE] = {
			id = 4013310,
		},
		[Backend.AUTH_METHOD_STEAM] = {
			id = 4013310,
		},
		[Backend.AUTH_METHOD_XBOXLIVE] = {
			id = "9NFWZ1XDJFPR",
		},
		[Backend.AUTH_METHOD_PSN] = {
			id = "0920608558932472",
		},
		[Backend.AUTH_METHOD_DEV_USER] = {
			id = 4013310,
		},
		[Backend.AUTH_METHOD_AWS] = {
			id = 4013310,
		},
	},
	includes = {
		"broker",
		"broker_cosmetic",
	},
}

return DLCSettings
