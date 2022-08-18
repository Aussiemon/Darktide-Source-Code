local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local basic_chaos_hound_template = {
	slot_body = {
		items = {
			"content/items/characters/minions/chaos_hound/attachments_base/body"
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
	}
}
local templates = {
	chaos_hound = {
		has_gib_overrides = true,
		default = {},
		[zone_ids.tank_foundry] = {}
	}
}
templates.chaos_hound.default[1] = table.clone(basic_chaos_hound_template)
local foundry_1 = table.clone(basic_chaos_hound_template)
foundry_1.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.chaos_hound.tank_foundry[1] = foundry_1

return templates
