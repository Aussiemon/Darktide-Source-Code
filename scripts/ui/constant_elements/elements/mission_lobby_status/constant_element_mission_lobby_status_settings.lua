local ready_slot_margin = 5
local constant_element_mission_lobby_status_settings = {
	ready_slot_size = {
		22 + ready_slot_margin,
		55
	},
	active_view_position = {
		inventory_view = {
			nil,
			0
		},
		talents_view = {
			nil,
			0
		},
		talent_builder_view = {
			nil,
			0
		}
	},
	hide_in_view = {
		inventory_background_view = true
	}
}

return settings("ConstantMissionLobbyStatusSettings", constant_element_mission_lobby_status_settings)
