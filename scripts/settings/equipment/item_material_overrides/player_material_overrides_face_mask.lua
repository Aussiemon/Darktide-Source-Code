local material_overrides = {
	mask_face_none = {
		property_overrides = {
			positive_mask = {
				1,
				0,
				0,
				0
			},
			negative_mask = {
				0,
				0,
				0,
				0
			}
		}
	},
	mask_face_right_half = {
		property_overrides = {
			positive_mask = {
				0.5,
				0,
				0,
				0
			},
			negative_mask = {
				0,
				0,
				0,
				0
			}
		}
	},
	mask_face_cowl = {
		property_overrides = {
			positive_mask = {
				0,
				0.53,
				0,
				0
			},
			negative_mask = {
				0,
				0,
				0.045,
				0
			}
		}
	},
	mask_face_cowl_keep_ears = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0,
				0.818
			},
			negative_mask = {
				0,
				0.899,
				0,
				0.35
			}
		}
	},
	mask_face_cowl_hide_mouth = {
		property_overrides = {
			positive_mask = {
				0,
				0.535,
				0,
				0.727
			},
			negative_mask = {
				0,
				0,
				0.203,
				0.42
			}
		}
	},
	mask_face_bandana = {
		property_overrides = {
			positive_mask = {
				0.289,
				0,
				0.486,
				0
			},
			negative_mask = {
				0.289,
				0.49,
				0.281,
				0
			}
		}
	},
	mask_face_rebreather_a = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.585,
				0
			},
			negative_mask = {
				0,
				0.481,
				0.235,
				0
			}
		}
	},
	mask_face_keep_neck = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0,
				0
			},
			negative_mask = {
				0,
				0,
				0.171,
				0
			}
		}
	}
}

return material_overrides
