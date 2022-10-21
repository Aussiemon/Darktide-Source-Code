local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	renegade_sniper = {}
}
local basic_renegade_sniper_template = {
	slots = {
		slot_upperbody = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_sniper"
			}
		},
		slot_lowerbody = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_sniper"
			}
		},
		slot_face = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_02"
			}
		},
		slot_head = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/hood_and_goggles_a"
			}
		},
		slot_ranged_weapon = {
			drop_on_death = true,
			is_weapon = true,
			items = {
				"content/items/weapons/minions/ranged/renegade_sniper_rifle"
			}
		},
		slot_variation_gear = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/special_sniper"
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
local default_1 = table.clone(basic_renegade_sniper_template)
templates.renegade_sniper.default = {
	default_1
}
local foundry_1 = table.clone(basic_renegade_sniper_template)
foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_sniper[zone_ids.tank_foundry] = {
	foundry_1
}
local watertown_1 = table.clone(basic_renegade_sniper_template)
watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.renegade_sniper[zone_ids.watertown] = {
	watertown_1
}

return templates
