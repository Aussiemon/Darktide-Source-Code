local StatConfigs = {
	session = {
		mission_name = {
			required = true
		},
		mission_type = {
			required = true
		},
		difficulty = {
			required = true
		},
		circumstance_name = {
			required = true
		},
		is_auric_mission = {
			default = false
		},
		is_flash_mission = {
			default = false
		},
		private_session = {
			default = false
		},
		is_hub = {
			default = false
		}
	},
	user = {
		archetype_name = {
			required = true
		},
		joined_at = {
			required = true,
			inherit = true
		},
		character_id = {
			default = "none"
		}
	}
}

return settings("StatConfigs", StatConfigs)
