local templates = {
	MinionOutlineExtension = {
		special_target = {
			priority = 2,
			material_layers = {
				"minion_outline_combat_ability",
				"minion_outline_combat_ability_reversed_depth"
			},
			visibility_check = function (unit)
				if not HEALTH_ALIVE[unit] then
					return false
				end

				return true
			end
		},
		smart_tagged_enemy = {
			priority = 1,
			material_layers = {
				"minion_outline",
				"minion_outline_reversed_depth"
			},
			color = {
				1,
				0.005,
				0
			},
			visibility_check = function (unit)
				if not HEALTH_ALIVE[unit] then
					return false
				end

				return true
			end
		},
		smart_tagged_enemy_passive = {
			priority = 1,
			color = {
				0.8,
				0.75,
				0
			},
			material_layers = {
				"minion_outline",
				"minion_outline_reversed_depth"
			},
			visibility_check = function (unit)
				if not HEALTH_ALIVE[unit] then
					return false
				end

				return true
			end
		}
	},
	PropOutlineExtension = {
		scanning = {
			priority = 2,
			material_layers = {
				"scanning"
			},
			visibility_check = function (unit)
				return true
			end
		},
		scanning_confirm = {
			priority = 1,
			material_layers = {
				"scanning",
				"scanning_reversed_depth"
			},
			visibility_check = function (unit)
				return true
			end
		}
	},
	PlayerUnitOutlineExtension = {
		buff = {
			priority = 1,
			material_layers = {
				"player_outline_target",
				""
			},
			visibility_check = function (unit)
				if not HEALTH_ALIVE[unit] then
					return false
				end

				return true
			end
		},
		knocked_down = {
			priority = 2,
			material_layers = {
				"player_outline_knocked_down",
				"player_outline_knocked_down_reversed_depth"
			},
			visibility_check = function (unit)
				if not HEALTH_ALIVE[unit] then
					return false
				end

				return true
			end
		},
		default_both_obscured = {
			priority = 3,
			material_layers = {
				"player_outline_general",
				"player_outline_general_depth"
			},
			visibility_check = function (unit)
				if not HEALTH_ALIVE[unit] then
					return false
				end

				return true
			end
		},
		default_both_always = {
			priority = 3,
			material_layers = {
				"player_outline_general",
				"player_outline_general_depth"
			},
			visibility_check = function (unit)
				if not HEALTH_ALIVE[unit] then
					return false
				end

				return true
			end
		},
		default_outlines_always = {
			priority = 3,
			material_layers = {
				"player_outline_general",
				""
			},
			visibility_check = function (unit)
				if not HEALTH_ALIVE[unit] then
					return false
				end

				return true
			end
		},
		default_outlines_obscured = {
			priority = 3,
			material_layers = {
				"player_outline_general",
				""
			},
			visibility_check = function (unit)
				if not HEALTH_ALIVE[unit] then
					return false
				end

				return true
			end
		},
		default_mesh_always = {
			priority = 3,
			material_layers = {
				"",
				"player_outline_general_depth"
			},
			visibility_check = function (unit)
				if not HEALTH_ALIVE[unit] then
					return false
				end

				return true
			end
		},
		default_mesh_obscured = {
			priority = 3,
			material_layers = {
				"",
				"player_outline_general_depth"
			},
			visibility_check = function (unit)
				if not HEALTH_ALIVE[unit] then
					return false
				end

				return true
			end
		}
	}
}

return settings("OutlineSettings", templates)
