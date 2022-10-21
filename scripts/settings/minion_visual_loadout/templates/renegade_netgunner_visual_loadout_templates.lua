local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	renegade_netgunner = {}
}
local basic_renegade_netgunner_template = {
	slots = {
		slot_upperbody = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_netgunner"
			}
		},
		slot_lowerbody = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_netgunner"
			}
		},
		slot_head = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/netgunner_helmet_01_a"
			}
		},
		slot_netgun = {
			drop_on_death = true,
			is_weapon = true,
			items = {
				"content/items/weapons/minions/ranged/renegade_netgun"
			}
		},
		slot_variation_gear = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/special_netgunner"
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
local default_1 = table.clone(basic_renegade_netgunner_template)
templates.renegade_netgunner.default = {
	default_1
}
local foundry_1 = table.clone(basic_renegade_netgunner_template)
foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_netgunner[zone_ids.tank_foundry] = {
	foundry_1
}
local watertown_1 = table.clone(basic_renegade_netgunner_template)
watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.renegade_netgunner[zone_ids.watertown] = {
	watertown_1
}

return templates
