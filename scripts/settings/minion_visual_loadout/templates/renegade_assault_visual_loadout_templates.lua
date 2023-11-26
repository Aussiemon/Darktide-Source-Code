-- chunkname: @scripts/settings/minion_visual_loadout/templates/renegade_assault_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	renegade_assault = {}
}
local basic_renegade_assault_template = {
	slots = {
		slot_upperbody = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_color_var_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_var_01_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_var_01_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_var_01_color_var_03"
			}
		},
		slot_lowerbody = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_color_var_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_var_01_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_var_01_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_var_01_color_var_03"
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
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_01_c",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_01_c_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_01_c_var_02"
			}
		},
		slot_ranged_weapon = {
			drop_on_death = true,
			is_weapon = true,
			is_ranged_weapon = true,
			items = {
				"content/items/weapons/minions/ranged/renegade_lasgun_smg"
			}
		},
		slot_melee_weapon = {
			drop_on_death = true,
			is_weapon = true,
			items = {
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_03"
			}
		},
		slot_helmet_decal = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_01_decal_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_01_decal_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_01_decal_c",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_01_decal_d",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_01_decal_e"
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
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/midrange_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/midrange_a_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/midrange_a_var_02"
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
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_02",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_03"
			}
		}
	}
}
local default_1 = table.clone(basic_renegade_assault_template)

default_2 = table.clone(basic_renegade_assault_template)
default_2.gib_variations = {
	"face_02_b"
}
default_2.slots.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_02"
	}
}
default_3 = table.clone(basic_renegade_assault_template)
default_3.gib_variations = {
	"face_03_b"
}
default_3.slots.slot_face = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_02"
	}
}
templates.renegade_assault.default = {
	default_1,
	default_2,
	default_3
}

local foundry_1 = table.clone(basic_renegade_assault_template)

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
templates.renegade_assault[zone_ids.tank_foundry] = {
	foundry_1,
	foundry_2,
	foundry_3
}

local dust_1 = table.clone(basic_renegade_assault_template)

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
templates.renegade_assault[zone_ids.dust] = {
	dust_1,
	dust_2,
	dust_3
}

local watertown_1 = table.clone(basic_renegade_assault_template)

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
templates.renegade_assault[zone_ids.watertown] = {
	watertown_1,
	watertown_2,
	watertown_3
}

return templates
