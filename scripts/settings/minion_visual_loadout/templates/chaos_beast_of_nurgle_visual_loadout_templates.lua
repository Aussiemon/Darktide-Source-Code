-- chunkname: @scripts/settings/minion_visual_loadout/templates/chaos_beast_of_nurgle_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	chaos_beast_of_nurgle = {}
}
local basic_chaos_beast_of_nurgle_template = {
	slots = {
		slot_body = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_beast_of_nurgle/attachments_base/body"
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
local default_1 = table.clone(basic_chaos_beast_of_nurgle_template)

templates.chaos_beast_of_nurgle.default = {
	default_1
}

local foundry_1 = table.clone(basic_chaos_beast_of_nurgle_template)

foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.chaos_beast_of_nurgle[zone_ids.tank_foundry] = {
	foundry_1
}

local dust_1 = table.clone(basic_chaos_beast_of_nurgle_template)

dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
templates.chaos_beast_of_nurgle[zone_ids.dust] = {
	dust_1
}

local watertown_1 = table.clone(basic_chaos_beast_of_nurgle_template)

watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.chaos_beast_of_nurgle[zone_ids.watertown] = {
	watertown_1
}

return templates
