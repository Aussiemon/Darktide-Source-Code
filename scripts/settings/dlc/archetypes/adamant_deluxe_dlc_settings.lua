-- chunkname: @scripts/settings/dlc/archetypes/adamant_deluxe_dlc_settings.lua

local DLCSettings = {
	dlc_id = "adamant_deluxe",
	image = "content/ui/textures/dlc/adamant/dt_adamant_deluxe_store_large",
	loc_name = "loc_dlc_adamant_name_deluxe",
	steam_dlc_target = 3710950,
	texture_package = "packages/ui/dlc/adamant",
	ids = {
		[Backend.AUTH_METHOD_NONE] = {
			id = 3710950,
		},
		[Backend.AUTH_METHOD_STEAM] = {
			id = 3710950,
		},
		[Backend.AUTH_METHOD_XBOXLIVE] = {
			id = "9P6MPZR3334D",
		},
		[Backend.AUTH_METHOD_PSN] = {
			id = "0092450731028132",
		},
		[Backend.AUTH_METHOD_DEV_USER] = {
			id = 3710950,
		},
		[Backend.AUTH_METHOD_AWS] = {
			id = 3710950,
		},
	},
	includes = {
		"adamant",
	},
}

return DLCSettings
