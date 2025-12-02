-- chunkname: @scripts/settings/dlc/archetypes/adamant_dlc_settings.lua

local DLCSettings = {
	dlc_id = "adamant",
	image = "content/ui/textures/dlc/adamant/dt_adamant_standard_store_large",
	loc_name = "loc_dlc_adamant_name",
	steam_dlc_target = 3710910,
	texture_package = "packages/ui/dlc/adamant",
	ids = {
		[Backend.AUTH_METHOD_NONE] = {
			id = 3710910,
		},
		[Backend.AUTH_METHOD_STEAM] = {
			id = 3710910,
		},
		[Backend.AUTH_METHOD_XBOXLIVE] = {
			id = "9NQ48H8FW60H",
		},
		[Backend.AUTH_METHOD_PSN] = {
			id = "0168620603438961",
		},
		[Backend.AUTH_METHOD_DEV_USER] = {
			id = 3710910,
		},
		[Backend.AUTH_METHOD_AWS] = {
			id = 3710910,
		},
	},
}

return DLCSettings
