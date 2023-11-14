local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	renegade_shocktrooper = {}
}
local basic_renegade_shocktrooper_template = {
	slots = {
		slot_upperbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_elite",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_elite_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_elite_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_elite_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_elite_var_01_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_elite_var_01_color_var_02"
			}
		},
		slot_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_elite",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_elite_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_elite_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_elite_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_elite_var_01_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_elite_var_01_color_var_02"
			}
		},
		slot_face = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02"
			}
		},
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_02_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_02_a_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_02_var_01"
			}
		},
		slot_ranged_weapon = {
			use_outline = true,
			drop_on_death = true,
			is_weapon = true,
			is_ranged_weapon = true,
			items = {
				"content/items/weapons/minions/ranged/renegade_elite_shotgun"
			}
		},
		slot_melee_weapon = {
			use_outline = true,
			is_weapon = true,
			drop_on_death = true,
			items = {
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_05",
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_01"
			}
		},
		slot_decal = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_midrange_elite_a_decal_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_longrange_elite_a_decal_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_longrange_elite_a_decal_b"
			}
		},
		slot_helmet_decal = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_02_decal_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_02_decal_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_02_decal_c",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_02_decal_d",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_02_decal_e"
			}
		},
		slot_variation_gear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/midrange_elite_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/midrange_elite_a_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/midrange_elite_a_var_02"
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
}
local default_1 = table.clone(basic_renegade_shocktrooper_template)
local default_2 = table.clone(basic_renegade_shocktrooper_template)
default_2.gib_variations = {
	"face_02_b"
}
default_2.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_02"
	}
}
local default_3 = table.clone(basic_renegade_shocktrooper_template)
default_3.gib_variations = {
	"face_03_b"
}
default_3.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_02"
	}
}
local default_4 = table.clone(basic_renegade_shocktrooper_template)
default_4.gib_variations = {
	"face_02"
}
default_4.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_02"
	}
}
local default_5 = table.clone(basic_renegade_shocktrooper_template)
default_5.gib_variations = {
	"face_03"
}
default_5.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_02"
	}
}
templates.renegade_shocktrooper.default = {
	default_1,
	default_2,
	default_3,
	default_4,
	default_5
}
local foundry_1 = table.clone(basic_renegade_shocktrooper_template)
foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
local foundry_2 = table.clone(default_2)
foundry_2.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
local foundry_3 = table.clone(default_3)
foundry_3.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
local foundry_4 = table.clone(default_4)
foundry_4.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
local foundry_5 = table.clone(default_5)
foundry_5.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_shocktrooper[zone_ids.tank_foundry] = {
	foundry_1,
	foundry_2,
	foundry_3,
	foundry_4,
	foundry_5
}
local dust_1 = table.clone(basic_renegade_shocktrooper_template)
dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
local dust_2 = table.clone(default_2)
dust_2.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
local dust_3 = table.clone(default_3)
dust_3.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
local dust_4 = table.clone(default_4)
dust_4.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
local dust_5 = table.clone(default_5)
dust_5.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
templates.renegade_shocktrooper[zone_ids.dust] = {
	dust_1,
	dust_2,
	dust_3,
	dust_4,
	dust_5
}
local watertown_1 = table.clone(basic_renegade_shocktrooper_template)
watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
local watertown_2 = table.clone(default_2)
watertown_2.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
local watertown_3 = table.clone(default_3)
watertown_3.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
local watertown_4 = table.clone(default_4)
watertown_4.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
local watertown_5 = table.clone(default_5)
watertown_5.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.renegade_shocktrooper[zone_ids.watertown] = {
	watertown_1,
	watertown_2,
	watertown_3,
	watertown_4,
	watertown_5
}

return templates
