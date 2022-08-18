local MissionSettings = require("scripts/settings/mission/mission_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local gib_overrides_template = GibbingSettings.gib_overrides
local zone_ids = MissionSettings.mission_zone_ids
local basic_renegade_shocktrooper_template = {
	slot_upperbody = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_midrange_elite"
		}
	},
	slot_lowerbody = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_midrange_elite"
		}
	},
	slot_face = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02"
		}
	},
	slot_head = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_02_a"
		}
	},
	slot_ranged_weapon = {
		drop_on_death = true,
		is_weapon = true,
		items = {
			"content/items/weapons/minions/ranged/renegade_elite_shotgun"
		}
	},
	slot_melee_weapon = {
		drop_on_death = true,
		is_weapon = true,
		items = {
			"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_05",
			"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_01"
		}
	},
	slot_decal = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_midrange_elite_a_decal_a"
		}
	},
	slot_helmet_decal = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_02_decal_a",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_02_decal_b",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_02_decal_c",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_02_decal_d",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_02_decal_e"
		}
	},
	slot_variation_gear = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/midrange_elite_a"
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
	renegade_shocktrooper = {
		has_gib_overrides = true,
		default = {},
		[zone_ids.tank_foundry] = {}
	}
}
templates.renegade_shocktrooper.default[1] = table.clone(basic_renegade_shocktrooper_template)
local default_2 = table.clone(basic_renegade_shocktrooper_template)
default_2.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_02"
	}
}
local default_2_gibs = table.clone(gib_overrides_template)
default_2_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_02_b/head_gib"
default_2.gib_overrides = default_2_gibs
templates.renegade_shocktrooper.default[2] = default_2
local default_3 = table.clone(basic_renegade_shocktrooper_template)
default_3.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_02"
	}
}
local default_3_gibs = table.clone(gib_overrides_template)
default_3_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/melee_a/face_03_b/head_gib"
default_3.gib_overrides = default_3_gibs
templates.renegade_shocktrooper.default[3] = default_3
local foundry_1 = table.clone(basic_renegade_shocktrooper_template)
foundry_1.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_shocktrooper.tank_foundry[1] = foundry_1
local foundry_2 = table.clone(default_2)
foundry_2.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_shocktrooper.tank_foundry[2] = foundry_2
local foundry_3 = table.clone(default_3)
foundry_3.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_shocktrooper.tank_foundry[3] = foundry_3

return templates
