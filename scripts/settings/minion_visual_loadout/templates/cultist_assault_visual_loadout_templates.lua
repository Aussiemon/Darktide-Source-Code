local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	cultist_assault = {}
}
local basic_cultist_assault_template = {
	slots = {
		slot_upperbody = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_a",
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_a_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_a_color_var_02"
			}
		},
		slot_lowerbody = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a",
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a_color_var_02"
			}
		},
		slot_face = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/face_02",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_02",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_03",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_04"
			}
		},
		slot_head = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_c",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_c_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_c_var_02",
				"content/items/characters/minions/chaos_cultists/attachments_gear/midrange_hat_a",
				"content/items/characters/minions/chaos_cultists/attachments_gear/midrange_hat_a",
				"content/items/characters/minions/chaos_cultists/attachments_gear/midrange_hat_a_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/midrange_hat_a_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/midrange_hat_a_color_var_02"
			}
		},
		slot_beard = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_a_var_01"
			}
		},
		slot_ranged_weapon = {
			drop_on_death = true,
			is_weapon = true,
			is_ranged_weapon = true,
			items = {
				"content/items/weapons/minions/ranged/renegade_autogun_ak"
			}
		},
		slot_melee_weapon = {
			drop_on_death = true,
			is_weapon = true,
			items = {
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_01",
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_05",
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_03",
				"content/items/weapons/minions/melee/renegade_melee_weapon_04"
			}
		},
		slot_variation_gear = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/midrange_a",
				"content/items/characters/minions/chaos_cultists/attachments_gear/midrange_a_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/midrange_a_color_var_02",
				"content/items/characters/minions/chaos_cultists/attachments_gear/midrange_a_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/midrange_a_var_01_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/midrange_a_var_01_color_var_02",
				"content/items/characters/minions/chaos_cultists/attachments_gear/midrange_a_var_02",
				"content/items/characters/minions/chaos_cultists/attachments_gear/midrange_a_var_02_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/midrange_a_var_02_color_var_02"
			}
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/newly_infected_flesh"
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
local default_1 = table.clone(basic_cultist_assault_template)
local default_2 = table.clone(basic_cultist_assault_template)
default_2.gib_variations = {
	"face_03"
}
default_2.slots.slot_face = {
	items = {
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_02",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_03",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_04"
	}
}
templates.cultist_assault.default = {
	default_1,
	default_2
}
local foundry_1 = table.clone(default_1)
foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
local foundry_2 = table.clone(default_2)
foundry_2.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.cultist_assault[zone_ids.tank_foundry] = {
	foundry_1,
	foundry_2
}
local dust_1 = table.clone(default_1)
dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
local dust_2 = table.clone(default_2)
dust_2.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
templates.cultist_assault[zone_ids.dust] = {
	dust_1,
	dust_2
}
local watertown_1 = table.clone(default_1)
watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
local watertown_2 = table.clone(default_2)
watertown_2.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.cultist_assault[zone_ids.watertown] = {
	watertown_1,
	watertown_2
}

return templates
