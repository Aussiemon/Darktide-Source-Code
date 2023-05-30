local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	chaos_spawn = {}
}
local basic_chaos_spawn_template = {
	slots = {
		slot_body = {
			items = {
				"content/items/characters/minions/chaos_spawn/attachments_base/body"
			}
		},
		slot_attachment = {
			items = {
				"content/items/characters/minions/chaos_spawn/attachments_gear/attachment_01"
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
local default_1 = table.clone(basic_chaos_spawn_template)
templates.chaos_spawn.default = {
	default_1
}
local foundry_1 = table.clone(basic_chaos_spawn_template)
foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.chaos_spawn[zone_ids.tank_foundry] = {
	foundry_1
}
local dust_1 = table.clone(basic_chaos_spawn_template)
dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
templates.chaos_spawn[zone_ids.dust] = {
	dust_1
}
local watertown_1 = table.clone(basic_chaos_spawn_template)
watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.chaos_spawn[zone_ids.watertown] = {
	watertown_1
}

return templates
