local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	renegade_rifleman = {}
}
local basic_renegade_rifleman_template = {
	slots = {
		slot_upperbody = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_color_var_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_var_01_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_var_01_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_var_01_color_var_03"
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
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b"
			}
		},
		slot_head = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_01_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_01_b_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_01_b_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_01_d",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_01_d_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_01_d_color_var_02"
			}
		},
		slot_ranged_weapon = {
			drop_on_death = true,
			is_weapon = true,
			items = {
				"content/items/weapons/minions/ranged/chaos_traitor_guard_renegade_lasgun_01"
			}
		},
		slot_decal = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_longrange_a_decal_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_longrange_a_decal_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_longrange_a_decal_c"
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
		slot_variation_gear = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/longrange_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/longrange_a_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/longrange_a_var_02"
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
local default_1 = table.clone(basic_renegade_rifleman_template)
templates.renegade_rifleman.default = {
	default_1
}
local foundry_1 = table.clone(basic_renegade_rifleman_template)
foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_rifleman[zone_ids.tank_foundry] = {
	foundry_1
}
local dust_1 = table.clone(basic_renegade_rifleman_template)
dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
templates.renegade_rifleman[zone_ids.dust] = {
	dust_1
}
local watertown_1 = table.clone(basic_renegade_rifleman_template)
watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.renegade_rifleman[zone_ids.watertown] = {
	watertown_1
}

return templates
