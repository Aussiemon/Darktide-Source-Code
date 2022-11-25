local material_overrides = {
	mask_default = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0
			}
		}
	},
	mask_torso_keep_collar = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.8
			}
		}
	},
	mask_torso_keep_pecs = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.5
			}
		}
	},
	mask_arms_keep_forearms = {
		property_overrides = {
			mask_top_bottom = {
				0.25,
				0.4
			}
		}
	},
	mask_arms_keep_forearms_and_hands = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.4
			}
		}
	},
	mask_arms_keep_wrist_and_hands = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.65
			}
		}
	},
	mask_arms_keep_hands = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.8
			}
		}
	},
	mask_arms_keep_fingers = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.9
			}
		}
	},
	mask_arms_keep_finger_tops = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.915
			}
		}
	},
	mask_arms_shoulders_01 = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.05
			}
		}
	},
	mask_arms_shoulders_02 = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.1
			}
		}
	},
	mask_arms_shoulders_03 = {
		property_overrides = {
			mask_top_bottom = {
				0,
				0.2
			}
		}
	},
	mask_arms_keep_upperarms_forearms = {
		property_overrides = {
			mask_top_bottom = {
				0.19,
				0
			}
		}
	},
	mask_legs_keep_knees_and_shins = {
		property_overrides = {
			mask_top_bottom = {
				0.2,
				0.425
			}
		}
	},
	mask_legs_keep_knees = {
		property_overrides = {
			mask_top_bottom = {
				0.35,
				0.425
			}
		}
	}
}

return material_overrides
