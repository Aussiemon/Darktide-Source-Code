local MissionSettings = require("scripts/settings/mission/mission_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local gib_overrides_template = GibbingSettings.gib_overrides
local zone_ids = MissionSettings.mission_zone_ids
local basic_renegade_melee_template = {
	slot_upperbody = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a"
		}
	},
	slot_lowerbody = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a"
		}
	},
	slot_face = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_tattoo_01",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_tattoo_02"
		}
	},
	slot_hair = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b_var_01",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b_var_02",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b_var_03",
			"content/items/characters/minions/generic_items/empty_minion_item",
			"content/items/characters/minions/generic_items/empty_minion_item",
			"content/items/characters/minions/generic_items/empty_minion_item",
			"content/items/characters/minions/generic_items/empty_minion_item",
			"content/items/characters/minions/generic_items/empty_minion_item"
		}
	},
	slot_melee_weapon = {
		drop_on_death = true,
		is_weapon = true,
		items = {
			"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_02",
			"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_04",
			"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_01"
		}
	},
	slot_decal = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_a",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_d",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_e"
		}
	},
	slot_variation_gear = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a"
		}
	},
	slot_flesh = {
		starts_invisible = true,
		items = {
			"content/items/characters/minions/gib_items/traitor_guard_flesh"
		}
	},
	envrionmental_override = {
		is_material_override_slot = true,
		items = {
			"content/items/characters/minions/generic_items/empty_minion_item"
		}
	},
	skin_color_override = {
		is_material_override_slot = true,
		items = {
			"content/items/characters/minions/generic_items/empty_minion_item",
			"content/items/characters/minions/skin_color_overrides/chaos_skin_color_01",
			"content/items/characters/minions/skin_color_overrides/chaos_skin_color_02",
			"content/items/characters/minions/skin_color_overrides/chaos_skin_color_03"
		}
	}
}
local templates = {
	renegade_melee = {
		has_gib_overrides = true,
		default = {},
		[zone_ids.tank_foundry] = {}
	}
}
templates.renegade_melee.default[1] = table.clone(basic_renegade_melee_template)
local default_2 = table.clone(basic_renegade_melee_template)
default_2.slot_variation_gear = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_01"
	}
}
local default_2_gibs = table.clone(gib_overrides_template)
default_2_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_2_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_2_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_2_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib"
default_2_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_2_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_2.gib_overrides = default_2_gibs
templates.renegade_melee.default[2] = default_2
local default_3 = table.clone(basic_renegade_melee_template)
default_3.slot_variation_gear = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_02"
	}
}
local default_3_gibs = table.clone(gib_overrides_template)
default_3_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_3_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_3_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_3_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib"
default_3_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_3_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_3.gib_overrides = default_3_gibs
templates.renegade_melee.default[3] = default_3
local default_4 = table.clone(basic_renegade_melee_template)
default_4.slot_variation_gear = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_03"
	}
}
local default_4_gibs = table.clone(gib_overrides_template)
default_4_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_4_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_4_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_4_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib"
default_4_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_4_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_4.gib_overrides = default_4_gibs
templates.renegade_melee.default[4] = default_4
local default_5 = table.clone(basic_renegade_melee_template)
default_5.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02"
	}
}
local default_5_gibs = table.clone(gib_overrides_template)
default_5_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_01_b/head_gib"
default_5.gib_overrides = default_5_gibs
templates.renegade_melee.default[5] = default_5
local default_6 = table.clone(basic_renegade_melee_template)
default_6.slot_variation_gear = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_01"
	}
}
default_6.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02"
	}
}
local default_6_gibs = table.clone(gib_overrides_template)
default_6_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_6_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_6_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_6_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib"
default_6_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_6_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_6_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_01_b/head_gib"
default_6.gib_overrides = default_6_gibs
templates.renegade_melee.default[6] = default_6
local default_7 = table.clone(basic_renegade_melee_template)
default_7.slot_variation_gear = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_02"
	}
}
default_7.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02"
	}
}
local default_7_gibs = table.clone(gib_overrides_template)
default_7_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_7_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_7_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_7_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib"
default_7_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_7_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_7_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_01_b/head_gib"
default_7.gib_overrides = default_7_gibs
templates.renegade_melee.default[7] = default_7
local default_8 = table.clone(basic_renegade_melee_template)
default_8.slot_variation_gear = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_03"
	}
}
default_8.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02"
	}
}
local default_8_gibs = table.clone(gib_overrides_template)
default_8_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_8_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_8_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_8_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib"
default_8_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_8_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_8_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_01_b/head_gib"
default_8.gib_overrides = default_8_gibs
templates.renegade_melee.default[8] = default_8
local default_9 = table.clone(basic_renegade_melee_template)
default_9.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_02"
	}
}
local default_9_gibs = table.clone(gib_overrides_template)
default_9_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_02/head_gib"
default_9.gib_overrides = default_9_gibs
templates.renegade_melee.default[9] = default_9
local default_10 = table.clone(basic_renegade_melee_template)
default_10.slot_variation_gear = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_01"
	}
}
default_10.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_02"
	}
}
local default_10_gibs = table.clone(gib_overrides_template)
default_10_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_10_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_10_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_10_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib"
default_10_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_10_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_10_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_02/head_gib"
default_10.gib_overrides = default_10_gibs
templates.renegade_melee.default[10] = default_10
local default_11 = table.clone(basic_renegade_melee_template)
default_11.slot_variation_gear = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_02"
	}
}
default_11.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_02"
	}
}
local default_11_gibs = table.clone(gib_overrides_template)
default_11_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_11_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_11_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_11_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib"
default_11_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_11_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_11_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_02/head_gib"
default_11.gib_overrides = default_11_gibs
templates.renegade_melee.default[11] = default_11
local default_12 = table.clone(basic_renegade_melee_template)
default_12.slot_variation_gear = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_03"
	}
}
default_12.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_02"
	}
}
local default_12_gibs = table.clone(gib_overrides_template)
default_12_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_12_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_12_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_12_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib"
default_12_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_12_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_12_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_02/head_gib"
default_12.gib_overrides = default_12_gibs
templates.renegade_melee.default[12] = default_12
local default_13 = table.clone(basic_renegade_melee_template)
default_13.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_02"
	}
}
local default_13_gibs = table.clone(gib_overrides_template)
default_13_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_02_b/head_gib"
default_13.gib_overrides = default_13_gibs
templates.renegade_melee.default[13] = default_13
local default_14 = table.clone(basic_renegade_melee_template)
default_14.slot_variation_gear = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_01"
	}
}
default_14.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_02"
	}
}
local default_14_gibs = table.clone(gib_overrides_template)
default_14_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_14_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_14_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_14_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib"
default_14_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_14_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_14_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_02_b/head_gib"
default_14.gib_overrides = default_14_gibs
templates.renegade_melee.default[14] = default_14
local default_15 = table.clone(basic_renegade_melee_template)
default_15.slot_variation_gear = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_02"
	}
}
default_15.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_02"
	}
}
local default_15_gibs = table.clone(gib_overrides_template)
default_15_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_15_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_15_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_15_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib"
default_15_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_15_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_15_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_02_b/head_gib"
default_15.gib_overrides = default_15_gibs
templates.renegade_melee.default[15] = default_15
local default_16 = table.clone(basic_renegade_melee_template)
default_16.slot_variation_gear = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_03"
	}
}
default_16.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_02"
	}
}
local default_16_gibs = table.clone(gib_overrides_template)
default_16_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_16_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_16_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_16_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib"
default_16_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_16_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_16_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_02_b/head_gib"
default_16.gib_overrides = default_16_gibs
templates.renegade_melee.default[16] = default_16
local default_17 = table.clone(basic_renegade_melee_template)
default_17.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_02"
	}
}
local default_17_gibs = table.clone(gib_overrides_template)
default_17_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_03/head_gib"
default_17.gib_overrides = default_17_gibs
templates.renegade_melee.default[17] = default_17
local default_18 = table.clone(basic_renegade_melee_template)
default_18.slot_variation_gear = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_01"
	}
}
default_18.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_02"
	}
}
local default_18_gibs = table.clone(gib_overrides_template)
default_18_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_18_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_18_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_18_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib"
default_18_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib"
default_18_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_18_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_03/head_gib"
default_18.gib_overrides = default_18_gibs
templates.renegade_melee.default[18] = default_18
local default_19 = table.clone(basic_renegade_melee_template)
default_19.slot_variation_gear = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_02"
	}
}
default_19.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_02"
	}
}
local default_19_gibs = table.clone(gib_overrides_template)
default_19_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_19_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_19_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_19_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib"
default_19_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_19_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_19_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_03/head_gib"
default_19.gib_overrides = default_19_gibs
templates.renegade_melee.default[19] = default_19
local default_20 = table.clone(basic_renegade_melee_template)
default_20.slot_variation_gear = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_03"
	}
}
default_20.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_02"
	}
}
local default_20_gibs = table.clone(gib_overrides_template)
default_20_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_20_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_20_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_20_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib"
default_20_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_20_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_20_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_03/head_gib"
default_20.gib_overrides = default_20_gibs
templates.renegade_melee.default[20] = default_20
local default_21 = table.clone(basic_renegade_melee_template)
default_21.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_02"
	}
}
local default_21_gibs = table.clone(gib_overrides_template)
default_21_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_03_b/head_gib"
default_21.gib_overrides = default_21_gibs
templates.renegade_melee.default[21] = default_21
local default_22 = table.clone(basic_renegade_melee_template)
default_22.slot_variation_gear = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_01"
	}
}
default_22.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_02"
	}
}
local default_22_gibs = table.clone(gib_overrides_template)
default_22_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_22_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_22_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_22_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib"
default_22_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_22_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_01/upper_torso_gib_full"
default_22_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_03_b/head_gib"
default_22.gib_overrides = default_22_gibs
templates.renegade_melee.default[22] = default_22
local default_23 = table.clone(basic_renegade_melee_template)
default_23.slot_variation_gear = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_02"
	}
}
default_23.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_02"
	}
}
local default_23_gibs = table.clone(gib_overrides_template)
default_23_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_23_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_23_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_23_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib"
default_23_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_23_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_02/upper_torso_gib_full"
default_23_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_03_b/head_gib"
default_23.gib_overrides = default_23_gibs
templates.renegade_melee.default[23] = default_23
local default_24 = table.clone(basic_renegade_melee_template)
default_24.slot_variation_gear = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_03"
	}
}
default_24.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_02"
	}
}
local default_24_gibs = table.clone(gib_overrides_template)
default_24_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_24_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_24_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_24_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib"
default_24_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_24_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/var_03/upper_torso_gib_full"
default_24_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_03_b/head_gib"
default_24.gib_overrides = default_24_gibs
templates.renegade_melee.default[24] = default_24
local foundry_1 = table.clone(basic_renegade_melee_template)
foundry_1.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[1] = foundry_1
local foundry_2 = table.clone(default_2)
foundry_2.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[2] = foundry_2
local foundry_3 = table.clone(default_3)
foundry_3.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[3] = foundry_3
local foundry_4 = table.clone(default_4)
foundry_4.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[4] = foundry_4
local foundry_5 = table.clone(default_5)
foundry_5.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[5] = foundry_5
local foundry_6 = table.clone(default_6)
foundry_6.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[6] = foundry_6
local foundry_7 = table.clone(default_7)
foundry_7.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[7] = foundry_7
local foundry_7 = table.clone(default_7)
foundry_7.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[7] = foundry_7
local foundry_8 = table.clone(default_8)
foundry_8.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[8] = foundry_8
local foundry_9 = table.clone(default_9)
foundry_9.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[9] = foundry_9
local foundry_10 = table.clone(default_10)
foundry_10.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[10] = foundry_10
local foundry_11 = table.clone(default_11)
foundry_11.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[11] = foundry_11
local foundry_12 = table.clone(default_12)
foundry_12.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[12] = foundry_12
local foundry_13 = table.clone(default_13)
foundry_13.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[13] = foundry_13
local foundry_14 = table.clone(default_14)
foundry_14.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[14] = foundry_14
local foundry_15 = table.clone(default_15)
foundry_15.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[15] = foundry_15
local foundry_16 = table.clone(default_16)
foundry_16.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[16] = foundry_16
local foundry_17 = table.clone(default_17)
foundry_17.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[17] = foundry_17
local foundry_18 = table.clone(default_18)
foundry_18.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[18] = foundry_18
local foundry_19 = table.clone(default_19)
foundry_19.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[19] = foundry_19
local foundry_20 = table.clone(default_20)
foundry_20.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[20] = foundry_20
local foundry_21 = table.clone(default_21)
foundry_21.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[21] = foundry_21
local foundry_22 = table.clone(default_22)
foundry_22.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[22] = foundry_22
local foundry_23 = table.clone(default_23)
foundry_23.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[23] = foundry_23
local foundry_24 = table.clone(default_24)
foundry_24.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee.tank_foundry[24] = foundry_24

return templates
