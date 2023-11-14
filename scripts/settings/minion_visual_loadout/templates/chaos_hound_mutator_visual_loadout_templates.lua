local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	chaos_hound_mutator = {}
}
local basic_chaos_hound_mutator_template = {
	slots = {
		slot_body = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_hound/attachments_base/body_mutator"
			}
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/chaos_hound_flesh"
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
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_03",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_04"
			}
		}
	}
}
local default_1 = table.clone(basic_chaos_hound_mutator_template)
templates.chaos_hound_mutator.default = {
	default_1
}
local foundry_1 = table.clone(basic_chaos_hound_mutator_template)
foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.chaos_hound_mutator[zone_ids.tank_foundry] = {
	foundry_1
}
local dust_1 = table.clone(basic_chaos_hound_mutator_template)
dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
templates.chaos_hound_mutator[zone_ids.dust] = {
	dust_1
}
local watertown_1 = table.clone(basic_chaos_hound_mutator_template)
watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.chaos_hound_mutator[zone_ids.watertown] = {
	watertown_1
}

return templates
