local MissionSettings = require("scripts/settings/mission/mission_settings")
local templates = {
	renegade_berzerker = {}
}
local zone_ids = MissionSettings.mission_zone_ids
local basic_renegade_berzerker_template = {
	slots = {
		slot_upperbody = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_berserker"
			}
		},
		slot_lowerbody = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_berserker"
			}
		},
		slot_head = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_02"
			}
		},
		slot_face = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_berserker"
			}
		},
		slot_melee_weapon = {
			drop_on_death = true,
			is_weapon = true,
			items = {
				"content/items/weapons/minions/melee/chaos_traitor_guard_berzerker_mainhand_weapon_01",
				"content/items/weapons/minions/melee/chaos_traitor_guard_berzerker_mainhand_weapon_02",
				"content/items/weapons/minions/melee/chaos_traitor_guard_berzerker_mainhand_weapon_03",
				"content/items/weapons/minions/melee/chaos_traitor_guard_berzerker_mainhand_weapon_04"
			}
		},
		slot_variation_gear = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_elite_a_berserker"
			}
		},
		slot_melee_weapon_offhand = {
			drop_on_death = true,
			is_weapon = true,
			items = {
				"content/items/weapons/minions/melee/cultist_berzerker_offhand_weapon_01",
				"content/items/weapons/minions/melee/cultist_berzerker_offhand_weapon_02",
				"content/items/weapons/minions/melee/cultist_berzerker_offhand_weapon_03"
			}
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/renegade_berserker_flesh"
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
local default_1 = table.clone(basic_renegade_berzerker_template)
templates.renegade_berzerker.default = {
	default_1
}
local foundry_1 = table.clone(basic_renegade_berzerker_template)
foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_berzerker[zone_ids.tank_foundry] = {
	foundry_1
}
local dust_1 = table.clone(basic_renegade_berzerker_template)
dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
templates.renegade_berzerker[zone_ids.dust] = {
	dust_1
}
local watertown_1 = table.clone(basic_renegade_berzerker_template)
watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.renegade_berzerker[zone_ids.watertown] = {
	watertown_1
}

return templates
