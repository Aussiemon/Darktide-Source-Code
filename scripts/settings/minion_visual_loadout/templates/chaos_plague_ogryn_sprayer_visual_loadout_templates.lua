local MissionSettings = require("scripts/settings/mission/mission_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local gib_overrides_template = GibbingSettings.gib_overrides
local zone_ids = MissionSettings.mission_zone_ids
local basic_chaos_plague_ogryn_sprayer_template = {
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
local templates = {
	chaos_plague_ogryn_sprayer = {
		has_gib_overrides = true,
		default = {},
		[zone_ids.tank_foundry] = {}
	}
}
templates.chaos_plague_ogryn_sprayer.default[1] = table.clone(basic_chaos_plague_ogryn_sprayer_template)
local foundry_1 = table.clone(basic_chaos_plague_ogryn_sprayer_template)
foundry_1.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.chaos_plague_ogryn_sprayer.tank_foundry[1] = foundry_1

return templates
