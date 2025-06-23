-- chunkname: @scripts/settings/archetype/archetypes/adamant_archetype_dlc_settings.lua

local DLCSettings = {
	loc_name_generic = "loc_dlc_adamant_name",
	texture_package = "packages/ui/dlc/adamant",
	telemetry_id = "adamant",
	steam_dlc_target = 3710910,
	standard = {
		image = "content/ui/textures/dlc/adamant/dt_adamant_standard_store_large",
		loc_name = "loc_dlc_adamant_name",
		ids = {
			[Backend.AUTH_METHOD_NONE] = {
				id = 3710910
			},
			[Backend.AUTH_METHOD_STEAM] = {
				id = 3710910
			},
			[Backend.AUTH_METHOD_XBOXLIVE] = {
				id = "9NQ48H8FW60H"
			},
			[Backend.AUTH_METHOD_PSN] = {
				id = "0168620603438961"
			},
			[Backend.AUTH_METHOD_DEV_USER] = {
				id = 3710910
			},
			[Backend.AUTH_METHOD_AWS] = {
				id = 3710910
			}
		}
	},
	deluxe = {
		image = "content/ui/textures/dlc/adamant/dt_adamant_deluxe_store_large",
		loc_name = "loc_dlc_adamant_name_deluxe",
		ids = {
			[Backend.AUTH_METHOD_NONE] = {
				id = 3710950
			},
			[Backend.AUTH_METHOD_STEAM] = {
				id = 3710950
			},
			[Backend.AUTH_METHOD_XBOXLIVE] = {
				id = "9P6MPZR3334D",
				is_bundle = true
			},
			[Backend.AUTH_METHOD_PSN] = {
				id = "0092450731028132",
				is_bundle = true
			},
			[Backend.AUTH_METHOD_DEV_USER] = {
				id = 3710950
			},
			[Backend.AUTH_METHOD_AWS] = {
				id = 3710950
			}
		}
	}
}

DLCSettings.get_ids_for_auth_method = function (self, backend_auth_method)
	local ids = {
		self.standard.ids[backend_auth_method].id
	}

	if self.deluxe.ids[backend_auth_method].is_bundle then
		return ids
	end

	table.insert(ids, self.deluxe.ids[backend_auth_method].id)

	return ids
end

return DLCSettings
