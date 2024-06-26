-- chunkname: @scripts/settings/equipment/item_material_overrides/player_material_overrides_base_body_mask.lua

local material_overrides = {
	mask_default = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0,
			},
		},
	},
	mask_torso_keep_collar = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.8,
			},
		},
	},
	mask_torso_keep_pecs = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.5,
			},
		},
	},
	mask_torso_keep_armpits = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.35,
			},
		},
	},
	mask_arms_keep_forearms = {
		property_overrides = {
			mask_top_bottom = {
				0.25,
				0.4,
			},
		},
	},
	mask_arms_keep_forearms_right = {
		property_overrides = {
			mask_top_bottom = {
				0.25,
				0.4,
			},
			assymetry_right_left_body_mask = {
				1,
				0,
			},
		},
	},
	mask_arms_keep_forearms_left = {
		property_overrides = {
			mask_top_bottom = {
				0.25,
				0.4,
			},
			assymetry_right_left_body_mask = {
				1,
				1,
			},
		},
	},
	mask_hands = {
		property_overrides = {
			mask_top_bottom = {
				0.15,
				0,
			},
		},
	},
	mask_hands_right = {
		property_overrides = {
			mask_top_bottom = {
				0.15,
				0,
			},
			assymetry_right_left_body_mask = {
				1,
				0,
			},
		},
	},
	mask_hands_left = {
		property_overrides = {
			mask_top_bottom = {
				0.15,
				0,
			},
			assymetry_right_left_body_mask = {
				1,
				1,
			},
		},
	},
	mask_upperarms_hands_keep_wrist = {
		property_overrides = {
			mask_top_bottom = {
				0.15,
				0.45,
			},
		},
	},
	mask_upperarms_hands_keep_wrist_right = {
		property_overrides = {
			mask_top_bottom = {
				0.15,
				0.45,
			},
			assymetry_right_left_body_mask = {
				1,
				0,
			},
		},
	},
	mask_upperarms_hands_keep_wrist_left = {
		property_overrides = {
			mask_top_bottom = {
				0.15,
				0.45,
			},
			assymetry_right_left_body_mask = {
				1,
				1,
			},
		},
	},
	mask_half_upperarms_hands_keep_wrist = {
		property_overrides = {
			mask_top_bottom = {
				0.15,
				0.25,
			},
		},
	},
	mask_half_upperarms_hands_keep_wrist_right = {
		property_overrides = {
			mask_top_bottom = {
				0.15,
				0.25,
			},
			assymetry_right_left_body_mask = {
				1,
				0,
			},
		},
	},
	mask_half_upperarms_hands_keep_wrist_left = {
		property_overrides = {
			mask_top_bottom = {
				0.15,
				0.25,
			},
			assymetry_right_left_body_mask = {
				1,
				1,
			},
		},
	},
	mask_arms_keep_forearms_and_hands = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.4,
			},
		},
	},
	mask_arms_keep_forearms_and_hands_right = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.4,
			},
			assymetry_right_left_body_mask = {
				1,
				0,
			},
		},
	},
	mask_arms_keep_forearms_and_hands_left = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.4,
			},
			assymetry_right_left_body_mask = {
				1,
				1,
			},
		},
	},
	mask_arms_keep_wrist_and_hands = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.65,
			},
		},
	},
	mask_arms_keep_wrist_and_hands_right = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.65,
			},
			assymetry_right_left_body_mask = {
				1,
				0,
			},
		},
	},
	mask_arms_keep_wrist_and_hands_left = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.65,
			},
			assymetry_right_left_body_mask = {
				1,
				1,
			},
		},
	},
	mask_arms_keep_hands = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.8,
			},
		},
	},
	mask_arms_keep_hands_right = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.8,
			},
			assymetry_right_left_body_mask = {
				1,
				0,
			},
		},
	},
	mask_arms_keep_hands_left = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.8,
			},
			assymetry_right_left_body_mask = {
				1,
				1,
			},
		},
	},
	mask_arms_keep_fingers = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.9,
			},
		},
	},
	mask_arms_keep_fingers_right = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.9,
			},
			assymetry_right_left_body_mask = {
				1,
				0,
			},
		},
	},
	mask_arms_keep_fingers_left = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.9,
			},
			assymetry_right_left_body_mask = {
				1,
				1,
			},
		},
	},
	mask_arms_keep_finger_tops = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.915,
			},
		},
	},
	mask_arms_keep_finger_tops_right = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.915,
			},
			assymetry_right_left_body_mask = {
				1,
				0,
			},
		},
	},
	mask_arms_keep_finger_tops_left = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.915,
			},
			assymetry_right_left_body_mask = {
				1,
				1,
			},
		},
	},
	mask_arms_shoulders_01 = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.05,
			},
		},
	},
	mask_arms_shoulders_01_right = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.05,
			},
			assymetry_right_left_body_mask = {
				1,
				0,
			},
		},
	},
	mask_arms_shoulders_01_left = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.05,
			},
			assymetry_right_left_body_mask = {
				1,
				1,
			},
		},
	},
	mask_arms_shoulders_02 = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.1,
			},
		},
	},
	mask_arms_shoulders_02_right = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.1,
			},
			assymetry_right_left_body_mask = {
				1,
				0,
			},
		},
	},
	mask_arms_shoulders_02_left = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.1,
			},
			assymetry_right_left_body_mask = {
				1,
				1,
			},
		},
	},
	mask_arms_shoulders_03 = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.2,
			},
		},
	},
	mask_arms_shoulders_03_right = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.2,
			},
			assymetry_right_left_body_mask = {
				1,
				0,
			},
		},
	},
	mask_arms_shoulders_03_left = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.2,
			},
			assymetry_right_left_body_mask = {
				1,
				1,
			},
		},
	},
	mask_arms_keep_upperarms_forearms = {
		property_overrides = {
			mask_top_bottom = {
				0.19,
				0,
			},
		},
	},
	mask_arms_keep_upperarms_forearms_right = {
		property_overrides = {
			mask_top_bottom = {
				0.19,
				0,
			},
			assymetry_right_left_body_mask = {
				1,
				0,
			},
		},
	},
	mask_arms_keep_upperarms_forearms_left = {
		property_overrides = {
			mask_top_bottom = {
				0.19,
				0,
			},
			assymetry_right_left_body_mask = {
				1,
				1,
			},
		},
	},
	mask_arms_hands_keep_wrist = {
		property_overrides = {
			mask_top_bottom = {
				0.15,
				0.65,
			},
		},
	},
	mask_arms_hands_keep_wrist_right = {
		property_overrides = {
			mask_top_bottom = {
				0.15,
				0.65,
			},
			assymetry_right_left_body_mask = {
				1,
				0,
			},
		},
	},
	mask_arms_hands_keep_wrist_left = {
		property_overrides = {
			mask_top_bottom = {
				0.15,
				0.65,
			},
			assymetry_right_left_body_mask = {
				1,
				1,
			},
		},
	},
	mask_legs_keep_knees_and_shins = {
		property_overrides = {
			mask_top_bottom = {
				0.2,
				0.425,
			},
		},
	},
	mask_legs_keep_knees = {
		property_overrides = {
			mask_top_bottom = {
				0.35,
				0.425,
			},
		},
	},
	mask_feet_and_shins_keep_knees_and_thighs = {
		property_overrides = {
			mask_top_bottom = {
				0.3,
				0.3,
			},
		},
	},
	mask_legs_keep_knees_and_thighs = {
		property_overrides = {
			mask_top_bottom = {
				0.2,
				0.25,
			},
		},
	},
}

return material_overrides
