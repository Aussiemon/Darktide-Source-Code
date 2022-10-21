local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	cultist_grenadier = {}
}
local basic_cultist_grenadier_template = {
	slots = {
		slot_lowerbody = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_b"
			}
		},
		slot_variation_gear = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/special_grenadier"
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
		}
	}
}
local default_1 = table.clone(basic_cultist_grenadier_template)
templates.cultist_grenadier.default = {
	default_1
}
local foundry_1 = table.clone(basic_cultist_grenadier_template)
foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.cultist_grenadier[zone_ids.tank_foundry] = {
	foundry_1
}
local watertown_1 = table.clone(basic_cultist_grenadier_template)
watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.cultist_grenadier[zone_ids.watertown] = {
	watertown_1
}

return templates
