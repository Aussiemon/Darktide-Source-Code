-- chunkname: @scripts/settings/equipment/item_material_overrides/player_material_overrides_face_mask.lua

local material_overrides = {
	mask_face_none = {
		property_overrides = {
			positive_mask = {
				1,
				0,
				0,
				0,
			},
			negative_mask = {
				0,
				0,
				0,
				0,
			},
		},
	},
	mask_accessory_remove_all = {
		property_overrides = {
			accessory_mask = {
				1,
			},
		},
	},
	mask_accessory_none = {
		property_overrides = {
			accessory_mask = {
				0,
			},
		},
	},
	mask_face_right_half = {
		property_overrides = {
			positive_mask = {
				0.5,
				0,
				0,
				0,
			},
			negative_mask = {
				0,
				0,
				0,
				0,
			},
		},
	},
	mask_face_left_half = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0,
				0,
			},
			negative_mask = {
				0.5,
				0,
				0,
				0,
			},
		},
	},
	mask_face_cowl = {
		property_overrides = {
			positive_mask = {
				0,
				0.53,
				0,
				0,
			},
			negative_mask = {
				0,
				0,
				0.045,
				0,
			},
		},
	},
	mask_face_cowl_b = {
		property_overrides = {
			positive_mask = {
				0,
				0.55,
				0,
				1,
			},
			negative_mask = {
				0,
				0,
				0.045,
				0.29,
			},
		},
	},
	mask_face_voicebox_a = {
		property_overrides = {
			positive_mask = {
				0.315,
				0.445,
				0.659,
				0,
			},
			negative_mask = {
				0.315,
				0.502,
				0.277,
				0,
			},
		},
	},
	mask_face_cowl_c = {
		property_overrides = {
			positive_mask = {
				0,
				0.55,
				0,
				0,
			},
			negative_mask = {
				0,
				0,
				0.2,
				0,
			},
		},
	},
	mask_face_cowl_d = {
		property_overrides = {
			positive_mask = {
				0.32,
				0.496,
				0,
				0,
			},
			negative_mask = {
				0.32,
				0.367,
				0.126,
				0,
			},
		},
	},
	mask_face_cowl_keep_ears = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0,
				0.818,
			},
			negative_mask = {
				0,
				0.899,
				0,
				0.35,
			},
		},
	},
	mask_face_cowl_keep_ears_b = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0,
				0.818,
			},
			negative_mask = {
				0,
				0.899,
				0,
				0.308,
			},
		},
	},
	mask_face_cowl_hide_mouth = {
		property_overrides = {
			positive_mask = {
				0,
				0.535,
				0,
				0.727,
			},
			negative_mask = {
				0,
				0,
				0.203,
				0.42,
			},
		},
	},
	mask_face_cowl_hide_mouth_01 = {
		property_overrides = {
			positive_mask = {
				0,
				0.506,
				0,
				0.727,
			},
			negative_mask = {
				0,
				0,
				0.203,
				0.368,
			},
		},
	},
	mask_face_cowl_hide_mouth_lower = {
		property_overrides = {
			positive_mask = {
				0,
				0.535,
				0,
				0.727,
			},
			negative_mask = {
				0,
				0,
				0.203,
				0.365,
			},
		},
	},
	mask_face_ski_low = {
		property_overrides = {
			positive_mask = {
				0,
				0.509,
				0,
				0,
			},
			negative_mask = {
				0,
				0,
				0.163,
				0,
			},
		},
	},
	mask_face_ski_low_01 = {
		property_overrides = {
			positive_mask = {
				0,
				0.509,
				0,
				0,
			},
			negative_mask = {
				0,
				0,
				0.215,
				0,
			},
		},
	},
	mask_face_ski_low_02 = {
		property_overrides = {
			positive_mask = {
				0,
				0.622,
				0.048,
				0.725,
			},
			negative_mask = {
				0,
				0.166,
				0.483,
				0.503,
			},
		},
	},
	mask_face_hide_jaw_neck_nose = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.49,
				0.718,
			},
			negative_mask = {
				0,
				0.999,
				0,
				0.314,
			},
		},
	},
	mask_face_hide_jaw_neck_nose_lower = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.41,
				0,
			},
			negative_mask = {
				0,
				0,
				0,
				0,
			},
		},
	},
	mask_face_hide_jaw_neck_nose_02 = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.6,
				0,
			},
			negative_mask = {
				0,
				0.35,
				0.244,
				0,
			},
		},
	},
	mask_face_hide_jaw_neck_nose_03 = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.55,
				0,
			},
			negative_mask = {
				0,
				0.35,
				0.244,
				0,
			},
		},
	},
	mask_face_bandana = {
		property_overrides = {
			positive_mask = {
				0.289,
				0,
				0.486,
				0,
			},
			negative_mask = {
				0.289,
				0.49,
				0.281,
				0,
			},
		},
	},
	mask_face_bandana_b = {
		property_overrides = {
			positive_mask = {
				0.289,
				0,
				0.632,
				0,
			},
			negative_mask = {
				0.289,
				0.49,
				0.281,
				0,
			},
		},
	},
	mask_face_rebreather_a = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.585,
				0,
			},
			negative_mask = {
				0,
				0.481,
				0.235,
				0,
			},
		},
	},
	mask_face_rebreather_b = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.65,
				0,
			},
			negative_mask = {
				0,
				0.481,
				0.235,
				0,
			},
		},
	},
	mask_face_rebreather_c = {
		property_overrides = {
			positive_mask = {
				0.35,
				0,
				0.52,
				1,
			},
			negative_mask = {
				0.35,
				0.435,
				0,
				0,
			},
		},
	},
	mask_face_rebreather_d = {
		property_overrides = {
			positive_mask = {
				0.355,
				0,
				0.434,
				1,
			},
			negative_mask = {
				0.355,
				0.423,
				0,
				0,
			},
		},
	},
	mask_face_rebreather_e = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.65,
				0,
			},
			negative_mask = {
				0,
				0.51,
				0.22,
				0,
			},
		},
	},
	mask_face_rebreather_f = {
		property_overrides = {
			positive_mask = {
				0.39,
				0,
				0.52,
				1,
			},
			negative_mask = {
				0.382,
				0.5,
				0.284,
				0,
			},
		},
	},
	mask_face_hide_face = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0,
				0,
			},
			negative_mask = {
				0,
				0.501,
				0,
				1,
			},
		},
	},
	mask_face_hide_face_b = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0,
				1,
			},
			negative_mask = {
				0,
				0.429,
				0,
				0,
			},
		},
	},
	mask_face_hide_mouth_nose = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.59,
				0,
			},
			negative_mask = {
				0,
				0.501,
				0.285,
				0,
			},
		},
	},
	mask_face_hide_mouth_nose_b = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.55,
				0,
			},
			negative_mask = {
				0,
				0.439,
				0.289,
				0,
			},
		},
	},
	mask_face_hide_mouth_nose_c = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.56,
				0,
			},
			negative_mask = {
				0,
				0.475,
				0.27,
				0,
			},
		},
	},
	mask_face_hide_mouth_nose_d = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.53,
				0.83,
			},
			negative_mask = {
				0,
				0.462,
				0,
				0.244,
			},
		},
	},
	mask_face_hide_mouth_neck = {
		property_overrides = {
			positive_mask = {
				0.31,
				0,
				0.674,
				0,
			},
			negative_mask = {
				0.31,
				0,
				0.234,
				0,
			},
		},
	},
	mask_face_hide_mouth_neck_cheek = {
		property_overrides = {
			positive_mask = {
				0,
				1,
				0,
				0.8,
			},
			negative_mask = {
				0,
				0,
				0.203,
				0.35,
			},
		},
	},
	mask_face_hide_mouth_nose_cheek = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.475,
				0,
			},
			negative_mask = {
				0,
				0,
				0.245,
				0,
			},
		},
	},
	mask_face_hide_mouth_nose_cheek_ear = {
		property_overrides = {
			positive_mask = {
				0,
				0.445,
				0.468,
				0,
			},
			negative_mask = {
				0,
				0.248,
				0.248,
				0,
			},
		},
	},
	mask_face_hide_mouth_nose_cheek_ear_01 = {
		property_overrides = {
			positive_mask = {
				0,
				0.445,
				0.468,
				0,
			},
			negative_mask = {
				0,
				0.303,
				0.266,
				0,
			},
		},
	},
	mask_face_hide_mouth_nose_cheek_ear_02 = {
		property_overrides = {
			positive_mask = {
				0,
				0.497,
				0.468,
				0,
			},
			negative_mask = {
				0,
				0.303,
				0.276,
				0,
			},
		},
	},
	mask_face_hide_lower_cheek = {
		property_overrides = {
			positive_mask = {
				0,
				0.489,
				0.575,
				0,
			},
			negative_mask = {
				0,
				0.424,
				0.288,
				0,
			},
		},
	},
	mask_face_keep_neck = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0,
				0,
			},
			negative_mask = {
				0,
				0,
				0.171,
				0,
			},
		},
	},
	mask_face_keep_neck_b = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0,
				0,
			},
			negative_mask = {
				0,
				0.398,
				0.242,
				0,
			},
		},
	},
	mask_face_keep_neck_c = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0,
				0,
			},
			negative_mask = {
				0,
				0,
				0.25,
				0,
			},
		},
	},
	mask_face_keep_neck_d = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0,
				0,
			},
			negative_mask = {
				0,
				0,
				0.22,
				0,
			},
		},
	},
	mask_face_keep_neck_e = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0,
				0,
			},
			negative_mask = {
				0,
				0.266,
				0.243,
				0,
			},
		},
	},
	mask_face_keep_neck_chin = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0,
				0,
			},
			negative_mask = {
				0,
				0.508,
				0.352,
				0,
			},
		},
	},
	mask_face_keep_neck_cap = {
		property_overrides = {
			positive_mask = {
				1,
				1,
				1,
				0.799,
			},
			negative_mask = {
				1,
				1,
				1,
				0.677,
			},
		},
	},
	mask_face_keep_neck_cap_b = {
		property_overrides = {
			positive_mask = {
				1,
				1,
				1,
				0.799,
			},
			negative_mask = {
				1,
				1,
				1,
				0.622,
			},
		},
	},
	mask_face_hide_chin_mouth_brow = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.61,
				0.355,
			},
			negative_mask = {
				0,
				0.328,
				0.242,
				1,
			},
		},
	},
	mask_brow = {
		property_overrides = {
			positive_mask = {
				0,
				0.353,
				0.289,
				0,
			},
			negative_mask = {
				0,
				0.487,
				0.617,
				0,
			},
		},
	},
	mask_brow_center = {
		property_overrides = {
			positive_mask = {
				0.353,
				0,
				0,
				0,
			},
			negative_mask = {
				0.351,
				0.566,
				0.649,
				0,
			},
		},
	},
	mask_face_left_ear = {
		property_overrides = {
			positive_mask = {
				0.968,
				0,
				0,
				0,
			},
			negative_mask = {
				0,
				0,
				0,
				0,
			},
		},
	},
	mask_face_left_ear_crown = {
		property_overrides = {
			positive_mask = {
				0.38,
				0.526,
				0,
				0,
			},
			negative_mask = {
				0,
				0.248,
				0.409,
				0,
			},
		},
	},
	mask_face_both_ears = {
		property_overrides = {
			positive_mask = {
				0,
				0.698,
				0.43,
				0,
			},
			negative_mask = {
				0,
				0.251,
				0.505,
				0.498,
			},
		},
	},
	mask_face_both_ears_01 = {
		property_overrides = {
			positive_mask = {
				0,
				0.698,
				0.43,
				0,
			},
			negative_mask = {
				0,
				0.251,
				0.434,
				0.498,
			},
		},
	},
	mask_face_both_ears_and_chin = {
		property_overrides = {
			positive_mask = {
				0,
				0.717,
				0.373,
				0.724,
			},
			negative_mask = {
				0,
				0.251,
				0.263,
				0.32,
			},
		},
	},
	mask_face_both_ears_and_chin_neck = {
		property_overrides = {
			positive_mask = {
				0,
				0.717,
				0.373,
				0.754,
			},
			negative_mask = {
				0,
				0.251,
				0.263,
				0.32,
			},
		},
	},
	mask_face_both_ears_chin_nose = {
		property_overrides = {
			positive_mask = {
				0,
				0.717,
				0.373,
				0.674,
			},
			negative_mask = {
				0,
				0.251,
				0.335,
				0.4,
			},
		},
	},
	mask_hide_goggles_and_ears = {
		property_overrides = {
			positive_mask = {
				0,
				0.67,
				0.264,
				0.37,
			},
			negative_mask = {
				0,
				0.158,
				0.269,
				0.703,
			},
		},
	},
	mask_brow_goggles_left_eye = {
		property_overrides = {
			positive_mask = {
				0.535,
				0,
				0.236,
				0,
			},
			negative_mask = {
				0.207,
				0,
				0.65,
				0,
			},
		},
	},
	mask_only_neck = {
		property_overrides = {
			positive_mask = {
				1,
				0,
				0,
				0.75,
			},
			negative_mask = {
				0,
				0,
				0,
				1,
			},
		},
	},
	mask_hide_neck_back = {
		property_overrides = {
			positive_mask = {
				0,
				0.704,
				0.73,
				0,
			},
			negative_mask = {
				0,
				0,
				0,
				0,
			},
		},
	},
	mask_face_hide_chin = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.7,
				0,
			},
			negative_mask = {
				0,
				0.397,
				0.235,
				0,
			},
		},
	},
	mask_face_keep_eyes_nose_scalp = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.55,
				0,
			},
			negative_mask = {
				0,
				0,
				0.203,
				0,
			},
		},
	},
	mask_hide_nose = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.45,
				0,
			},
			negative_mask = {
				0,
				0.99,
				0.37,
				0,
			},
		},
	},
	mask_hide_nose_01 = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0,
				0,
			},
			negative_mask = {
				0,
				0.88,
				0.37,
				0,
			},
		},
	},
	mask_hide_nose_02 = {
		property_overrides = {
			positive_mask = {
				0.483,
				0,
				0.531,
				0,
			},
			negative_mask = {
				0.483,
				0.995,
				0,
				0,
			},
		},
	},
	mask_full_face = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0,
				0,
			},
			negative_mask = {
				0,
				0,
				0,
				0,
			},
		},
	},
	mask_face_keep_left_eye = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0,
				0.726,
			},
			negative_mask = {
				0.509,
				0,
				0.198,
				0.503,
			},
		},
	},
	mask_hide_lower_neck = {
		property_overrides = {
			positive_mask = {
				0,
				0.61,
				0.77,
				0,
			},
			negative_mask = {
				0,
				0,
				0.05,
				0,
			},
		},
	},
	mask_top_keep_neck = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0,
				0,
			},
			negative_mask = {
				0,
				0.248,
				0.347,
				0,
			},
		},
	},
	mask_hide_all_keep_top_01 = {
		property_overrides = {
			positive_mask = {
				1,
				0,
				0,
				0.812,
			},
			negative_mask = {
				0.732,
				0.514,
				0.576,
				0.644,
			},
		},
	},
	mask_face_ogryn_head_plate_a = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0,
				0,
			},
			negative_mask = {
				0.551,
				0.369,
				0.635,
				0,
			},
		},
	},
}

return material_overrides
