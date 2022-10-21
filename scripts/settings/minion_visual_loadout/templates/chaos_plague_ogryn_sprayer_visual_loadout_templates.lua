local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	chaos_plague_ogryn_sprayer = {}
}
local basic_chaos_plague_ogryn_sprayer_template = {
	slots = {
		slot_body = {
			items = {
				"content/items/characters/minions/chaos_plague_ogryn/attachments_base/sprayer"
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
local default_1 = table.clone(basic_chaos_plague_ogryn_sprayer_template)
templates.chaos_plague_ogryn_sprayer.default = {
	default_1
}
local foundry_1 = table.clone(basic_chaos_plague_ogryn_sprayer_template)
foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.chaos_plague_ogryn_sprayer[zone_ids.tank_foundry] = {
	foundry_1
}
local watertown_1 = table.clone(basic_chaos_plague_ogryn_sprayer_template)
watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.chaos_plague_ogryn_sprayer[zone_ids.watertown] = {
	watertown_1
}

return templates
