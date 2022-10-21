local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	chaos_daemonhost = {}
}
local basic_chaos_daemonhost_template = {
	slots = {
		slot_body = {
			items = {
				"content/items/characters/minions/chaos_daemonhost_witch/attachments_base/body"
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
local default_1 = table.clone(basic_chaos_daemonhost_template)
templates.chaos_daemonhost.default = {
	default_1
}
local foundry_1 = table.clone(basic_chaos_daemonhost_template)
foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.chaos_daemonhost[zone_ids.tank_foundry] = {
	foundry_1
}
local watertown_1 = table.clone(basic_chaos_daemonhost_template)
watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.chaos_daemonhost[zone_ids.watertown] = {
	watertown_1
}

return templates
