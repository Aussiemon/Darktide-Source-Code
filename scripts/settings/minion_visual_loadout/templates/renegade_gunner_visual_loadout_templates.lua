local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	renegade_gunner = {}
}
local basic_renegade_gunner_template = {
	slots = {
		slot_ranged_weapon = {
			drop_on_death = true,
			is_weapon = true,
			items = {
				"content/items/weapons/minions/ranged/chaos_traitor_guard_hellgun_01"
			}
		},
		slot_melee_weapon = {
			drop_on_death = true,
			is_weapon = true,
			items = {
				"content/items/weapons/minions/melee/renegade_combat_knife"
			}
		},
		slot_head = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_02_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_02_b_var_01"
			}
		},
		slot_upperbody = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_elite",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_elite_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_elite_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_elite_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_elite_var_01_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_elite_var_01_color_var_02"
			}
		},
		slot_lowerbody = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_elite",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_elite_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_elite_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_elite_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_elite_var_01_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_elite_var_01_color_var_02"
			}
		},
		slot_decal = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_longrange_elite_a_decal_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_longrange_elite_a_decal_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_longrange_elite_a_decal_c"
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
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/longrange_elite_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/longrange_elite_a_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/longrange_elite_a_var_02"
			}
		},
		slot_gear_attachment = {
			items = {
				"content/items/weapons/minions/ranged/chaos_traitor_guard_hellgun_backpack"
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
		}
	}
}
local default_1 = table.clone(basic_renegade_gunner_template)
templates.renegade_gunner.default = {
	default_1
}
local foundry_1 = table.clone(basic_renegade_gunner_template)
foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_gunner[zone_ids.tank_foundry] = {
	foundry_1
}
local dust_1 = table.clone(basic_renegade_gunner_template)
dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
templates.renegade_gunner[zone_ids.dust] = {
	dust_1
}
local watertown_1 = table.clone(basic_renegade_gunner_template)
watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.renegade_gunner[zone_ids.watertown] = {
	watertown_1
}

return templates
