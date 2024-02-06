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
	mask_face_cowl_b = {
		property_overrides = {
			positive_mask = {
				0,
				0.55,
				0,
				1
			},
			negative_mask = {
				0,
				0,
				0.045,
				0.29
			}
		}
	},
	mask_face_cowl_c = {
		property_overrides = {
			positive_mask = {
				0,
				0.55,
				0,
				0
			},
			negative_mask = {
				0,
				0,
				0.2,
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
	mask_face_hide_jaw_neck_nose = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.49,
				0.718
			},
			negative_mask = {
				0,
				0.999,
				0,
				0.314
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
	mask_face_bandana_b = {
		property_overrides = {
			positive_mask = {
				0.289,
				0,
				0.632,
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
	mask_face_rebreather_b = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.65,
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
	mask_face_rebreather_c = {
		property_overrides = {
			positive_mask = {
				0.35,
				0,
				0.52,
				1
			},
			negative_mask = {
				0.35,
				0.435,
				0,
				0
			}
		}
	},
	mask_face_hide_mouth_nose = {
		property_overrides = {
			positive_mask = {
				0,
				0,
				0.59,
				0
			},
			negative_mask = {
				0,
				0.501,
				0.285,
				0
			}
		}
	},
	mask_face_hide_mouth_neck = {
		property_overrides = {
			positive_mask = {
				0.31,
				0,
				0.674,
				0
			},
			negative_mask = {
				0.31,
				0,
				0.234,
				0
			}
		}
	},
	mask_face_hide_mouth_neck_cheek = {
		property_overrides = {
			positive_mask = {
				0,
				1,
				0,
				0.8
			},
			negative_mask = {
				0,
				0,
				0.203,
				0.35
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
	},
	mask_brow = {
		property_overrides = {
			positive_mask = {
				0,
				0.353,
				0.289,
				0
			},
			negative_mask = {
				0,
				0.487,
				0.617,
				0
			}
		}
	},
	mask_face_both_ears = {
		property_overrides = {
			positive_mask = {
				0,
				0.63,
				0.394,
				0
			},
			negative_mask = {
				0,
				0.248,
				0.407,
				0
			}
		}
	},
	mask_face_left_ear = {
		property_overrides = {
			positive_mask = {
				0.968,
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
	}
}

return material_overrides
