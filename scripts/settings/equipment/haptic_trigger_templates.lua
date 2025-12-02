-- chunkname: @scripts/settings/equipment/haptic_trigger_templates.lua

local HapticTriggerSettings = require("scripts/settings/equipment/haptic_trigger_settings")
local TRIGGER_INDEX = HapticTriggerSettings.trigger_index
local TRIGGER_MASK = HapticTriggerSettings.trigger_mask
local haptic_trigger_templates = {
	ranged = {},
	melee = {},
}

haptic_trigger_templates.melee.none = {
	right = {
		off = {},
	},
	left = {
		off = {},
	},
}
haptic_trigger_templates.melee.light = {
	right = {
		multi_position_feedback = {
			strength = {
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				1,
			},
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				0,
				0,
				0,
				0,
				0,
				1,
				1,
				1,
				1,
			},
		},
	},
}
haptic_trigger_templates.melee.medium = {
	right = {
		multi_position_feedback = {
			strength = {
				0,
				0,
				0,
				0,
				0,
				1,
				1,
				0,
				0,
				1,
			},
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				0,
				0,
				0,
				1,
				1,
				0,
				1,
				1,
				1,
			},
		},
	},
}
haptic_trigger_templates.melee.heavy = {
	right = {
		multi_position_feedback = {
			strength = {
				0,
				0,
				0,
				0,
				0,
				1,
				3,
				4,
				2,
				7,
			},
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				0,
				0,
				1,
				1,
				0,
				2,
				3,
				1,
				1,
			},
		},
	},
}
haptic_trigger_templates.melee.push = {
	right = {
		multi_position_feedback = {
			strength = {
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				1,
				3,
			},
		},
	},
}
haptic_trigger_templates.melee.ogryn_powermaul_slabshield = {
	right = {
		multi_position_feedback = {
			strength = {
				0,
				0,
				1,
				0,
				0,
				0,
				2,
				5,
				6,
				7,
			},
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				1,
				2,
				2,
				3,
				0,
				4,
				4,
				4,
				4,
			},
		},
	},
}
haptic_trigger_templates.melee.chainsword = {
	right = {
		multi_position_feedback = {
			strength = {
				0,
				0,
				0,
				1,
				0,
				0,
				0,
				0,
				0,
				1,
			},
		},
		vibration = {
			amplitude = 2,
			frequency = 0,
			position = 5,
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				0,
				0,
				0,
				1,
				0,
				0,
				1,
				1,
				1,
			},
		},
	},
}
haptic_trigger_templates.melee.chainsword_2h = {
	right = {
		multi_position_feedback = {
			strength = {
				0,
				0,
				2,
				2,
				0,
				0,
				0,
				5,
				6,
				7,
			},
		},
		vibration = {
			amplitude = 4,
			frequency = 0,
			position = 5,
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				0,
				0,
				1,
				1,
				0,
				1,
				1,
				1,
				1,
			},
		},
	},
}
haptic_trigger_templates.ranged.none = {
	right = {
		off = {},
	},
	left = {
		off = {},
	},
}
haptic_trigger_templates.ranged.spray_n_pray = {
	right = {
		scale_vibration_with_ammo = true,
		weapon = {
			end_position = 3,
			start_position = 2,
			strength = 8,
		},
		vibration = {
			amplitude = 5,
			frequency = 0,
			position = 2,
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				1,
				1,
				1,
				2,
				0,
				0,
				2,
				3,
				0,
			},
		},
	},
}
haptic_trigger_templates.ranged.heavy_stubber = {
	right = {
		scale_vibration_with_ammo = true,
		use_template_vibration_frequency = true,
		weapon = {
			end_position = 8,
			start_position = 2,
			strength = 3,
		},
		vibration = {
			amplitude = 7,
			frequency = 5,
			position = 2,
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				1,
				1,
				2,
				2,
				0,
				0,
				2,
				3,
				0,
			},
		},
	},
}
haptic_trigger_templates.ranged.heavy_stubber_braced = {
	right = {
		scale_vibration_with_ammo = true,
		weapon = {
			end_position = 4,
			start_position = 3,
			strength = 1,
		},
		vibration = {
			amplitude = 2,
			frequency = 0,
			position = 2,
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				1,
				1,
				2,
				2,
				0,
				0,
				2,
				3,
				0,
			},
		},
	},
}
haptic_trigger_templates.ranged.rippergun = {
	right = {
		scale_vibration_with_ammo = true,
		weapon = {
			end_position = 6,
			start_position = 2,
			strength = 8,
		},
		vibration = {
			amplitude = 8,
			frequency = 0,
			position = 2,
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				1,
				1,
				2,
				3,
				0,
				0,
				4,
				3,
				0,
			},
		},
	},
}
haptic_trigger_templates.ranged.thumper_p1_m1 = {
	right = {
		scale_vibration_with_ammo = true,
		multi_position_feedback = {
			strength = {
				8,
				8,
				8,
				8,
				4,
				0,
				0,
				0,
				0,
				0,
			},
		},
		vibration = {
			amplitude = 8,
			frequency = 0,
			position = 2,
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				1,
				1,
				1,
				1,
				0,
				0,
				4,
				3,
				0,
			},
		},
	},
}
haptic_trigger_templates.ranged.thumper_p1_m2 = {
	right = {
		scale_vibration_with_ammo = true,
		multi_position_feedback = {
			strength = {
				2,
				6,
				8,
				8,
				8,
				0,
				0,
				2,
				3,
				0,
			},
		},
		vibration = {
			amplitude = 8,
			frequency = 0,
			position = 2,
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				1,
				1,
				1,
				1,
				0,
				0,
				4,
				3,
				0,
			},
		},
	},
}
haptic_trigger_templates.ranged.assault = {
	right = {
		scale_vibration_with_ammo = true,
		weapon = {
			end_position = 4,
			start_position = 2,
			strength = 5,
		},
		vibration = {
			amplitude = 7,
			frequency = 0,
			position = 2,
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				1,
				1,
				1,
				2,
				0,
				0,
				2,
				3,
				0,
			},
		},
	},
}
haptic_trigger_templates.ranged.lasgun_p2 = {
	right = {
		multi_position_feedback = {
			strength = {
				0,
				0,
				1,
				6,
				0,
				0,
				0,
				0,
				8,
				8,
			},
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				1,
				1,
				1,
				2,
				0,
				0,
				2,
				3,
				0,
			},
		},
	},
}
haptic_trigger_templates.ranged.lasgun_p3 = {
	right = {
		scale_vibration_with_ammo = true,
		multi_position_feedback = {
			strength = {
				0,
				0,
				0,
				0,
				4,
				0,
				0,
				0,
				8,
				8,
			},
		},
		vibration = {
			amplitude = 7,
			frequency = 0,
			position = 3,
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				1,
				1,
				1,
				2,
				0,
				0,
				2,
				3,
				0,
			},
		},
	},
}
haptic_trigger_templates.ranged.forcestaff = {
	right = {
		scale_vibration_with_ammo = true,
		multi_position_feedback = {
			strength = {
				0,
				0,
				0,
				1,
				0,
				0,
				1,
				1,
				2,
				3,
			},
		},
		vibration = {
			amplitude = 5,
			frequency = 0,
			position = 5,
		},
	},
	left = {
		scale_vibration_with_ammo = true,
		multi_position_feedback = {
			strength = {
				0,
				4,
				4,
				6,
				3,
				0,
				6,
				6,
				6,
				6,
			},
		},
		vibration = {
			amplitude = 5,
			frequency = 0,
			position = 5,
		},
	},
}
haptic_trigger_templates.ranged.killshot_burst = {
	right = {
		scale_vibration_with_ammo = true,
		weapon = {
			end_position = 5,
			start_position = 2,
			strength = 4,
		},
		vibration = {
			amplitude = 6,
			frequency = 0,
			position = 2,
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				0,
				1,
				1,
				1,
				2,
				3,
				2,
				1,
				0,
			},
		},
	},
}
haptic_trigger_templates.ranged.killshot_semiauto = {
	right = {
		scale_vibration_with_ammo = true,
		weapon = {
			end_position = 3,
			start_position = 2,
			strength = 3,
		},
		vibration = {
			amplitude = 8,
			frequency = 80,
			position = 2,
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				0,
				1,
				1,
				1,
				2,
				3,
				2,
				1,
				0,
			},
		},
	},
}
haptic_trigger_templates.ranged.killshot_fast = {
	right = {
		scale_vibration_with_ammo = true,
		weapon = {
			end_position = 4,
			start_position = 3,
			strength = 1,
		},
		vibration = {
			amplitude = 7,
			frequency = 50,
			position = 3,
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				0,
				1,
				1,
				1,
				2,
				3,
				2,
				1,
				0,
			},
		},
	},
}
haptic_trigger_templates.ranged.bolter = {
	right = {
		scale_vibration_with_ammo = true,
		weapon = {
			end_position = 4,
			start_position = 2,
			strength = 8,
		},
		vibration = {
			amplitude = 8,
			frequency = 0,
			position = 5,
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				1,
				1,
				2,
				5,
				0,
				0,
				4,
				3,
				0,
			},
		},
	},
}
haptic_trigger_templates.ranged.demolition = {
	right = {
		scale_vibration_with_ammo = true,
		weapon = {
			end_position = 7,
			start_position = 2,
			strength = 6,
		},
		vibration = {
			amplitude = 8,
			frequency = 0,
			position = 2,
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				2,
				2,
				4,
				4,
				0,
				4,
				4,
				4,
				4,
			},
		},
	},
}
haptic_trigger_templates.ranged.gauntlet = {
	right = {
		scale_vibration_with_ammo = true,
		use_template_vibration_frequency = true,
		weapon = {
			end_position = 7,
			start_position = 2,
			strength = 6,
		},
		vibration = {
			amplitude = 8,
			frequency = 20,
			position = 2,
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				2,
				2,
				4,
				4,
				0,
				4,
				4,
				4,
				4,
			},
		},
	},
}
haptic_trigger_templates.ranged.flamer = {
	right = {
		scale_vibration_with_ammo = true,
		use_template_vibration_frequency = true,
		multi_position_feedback = {
			strength = {
				0,
				0,
				1,
				2,
				0,
				0,
				3,
				5,
				7,
				8,
			},
		},
		vibration = {
			amplitude = 4,
			frequency = 25,
			position = 5,
		},
	},
	left = {
		scale_vibration_with_ammo = true,
		use_template_vibration_frequency = true,
		multi_position_feedback = {
			strength = {
				0,
				2,
				2,
				4,
				3,
				0,
				3,
				5,
				7,
				8,
			},
		},
		vibration = {
			amplitude = 4,
			frequency = 25,
			position = 5,
		},
	},
}
haptic_trigger_templates.ranged.plasmagun = {
	right = {
		scale_vibration_with_ammo = true,
		multi_position_feedback = {
			strength = {
				0,
				0,
				6,
				7,
				0,
				0,
				3,
				5,
				7,
				8,
			},
		},
		vibration = {
			amplitude = 8,
			frequency = 0,
			position = 5,
		},
	},
	left = {
		scale_vibration_with_ammo = true,
		multi_position_feedback = {
			strength = {
				0,
				4,
				4,
				5,
				3,
				0,
				4,
				5,
				5,
				6,
			},
		},
		vibration = {
			amplitude = 5,
			frequency = 0,
			position = 5,
		},
	},
}
haptic_trigger_templates.ranged.shotgun_p2_single_shot = {
	right = {
		scale_vibration_with_ammo = true,
		weapon = {
			end_position = 5,
			start_position = 2,
			strength = 6,
		},
		vibration = {
			amplitude = 7,
			frequency = 0,
			position = 2,
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				1,
				1,
				1,
				2,
				2,
				1,
				1,
				1,
				0,
			},
		},
	},
}
haptic_trigger_templates.ranged.shotgun_p2_double_shot = {
	right = {
		scale_vibration_with_ammo = true,
		weapon = {
			end_position = 8,
			start_position = 2,
			strength = 8,
		},
		vibration = {
			amplitude = 8,
			frequency = 0,
			position = 2,
		},
	},
	left = {
		scale_vibration_with_ammo = true,
		multi_position_feedback = {
			strength = {
				0,
				1,
				1,
				1,
				2,
				1,
				1,
				1,
				1,
				0,
			},
		},
		vibration = {
			amplitude = 8,
			frequency = 0,
			position = 5,
		},
	},
}
haptic_trigger_templates.ranged.stubrevolver_p1_m2_special_shoot = {
	right = {
		scale_vibration_with_ammo = true,
		weapon = {
			end_position = 3,
			start_position = 2,
			strength = 3,
		},
		vibration = {
			amplitude = 6,
			frequency = 0,
			position = 2,
		},
	},
	left = {
		use_template_vibration_frequency = true,
		multi_position_feedback = {
			strength = {
				0,
				2,
				2,
				4,
				3,
				0,
				3,
				5,
				7,
				8,
			},
		},
		vibration = {
			amplitude = 8,
			frequency = 30,
			position = 1,
		},
	},
}
haptic_trigger_templates.ranged.dual_auto = {
	right = {
		scale_vibration_with_ammo = true,
		weapon = {
			end_position = 3,
			start_position = 2,
			strength = 8,
		},
		vibration = {
			amplitude = 5,
			frequency = 0,
			position = 2,
		},
	},
	left = {
		scale_vibration_with_ammo = true,
		weapon = {
			end_position = 4,
			start_position = 3,
			strength = 8,
		},
		vibration = {
			amplitude = 5,
			frequency = 0,
			position = 3,
		},
	},
}
haptic_trigger_templates.ranged.dual_stubpistol_right = {
	right = {
		optional_wwise_vibration_event = "wwise/events/weapon/play_ps5_rumble_dual_stub_right",
		scale_vibration_with_ammo = true,
		use_template_vibration_frequency = true,
		weapon = {
			end_position = 3,
			start_position = 2,
			strength = 5,
		},
		vibration = {
			amplitude = 8,
			frequency = 2,
			position = 2,
		},
	},
	left = {
		multi_position_feedback = {
			strength = {
				0,
				0,
				0,
				1,
				1,
				2,
				2,
				2,
				3,
				4,
			},
		},
	},
}
haptic_trigger_templates.ranged.dual_stubpistol_left = {
	right = {
		off = {},
	},
	left = {
		optional_wwise_vibration_event = "wwise/events/weapon/play_ps5_rumble_dual_stub_left",
		scale_vibration_with_ammo = true,
		use_template_vibration_frequency = true,
		weapon = {
			end_position = 8,
			start_position = 2,
			strength = 8,
		},
		vibration = {
			amplitude = 8,
			frequency = 3,
			position = 9,
		},
	},
}

local function _preprocess(settings_type)
	for name, template in pairs(haptic_trigger_templates[settings_type]) do
		template.settings_type = settings_type
		template.name = name

		local left = template.left

		if left then
			left.trigger_index = TRIGGER_INDEX.l2
			left.trigger_mask = TRIGGER_MASK.l2
		end

		local right = template.right

		if right then
			right.trigger_index = TRIGGER_INDEX.r2
			right.trigger_mask = TRIGGER_MASK.r2
		end
	end
end

_preprocess("melee")
_preprocess("ranged")

return settings("HapticTriggerTemplates", haptic_trigger_templates)
