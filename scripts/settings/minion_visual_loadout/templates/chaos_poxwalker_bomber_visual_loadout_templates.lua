-- chunkname: @scripts/settings/minion_visual_loadout/templates/chaos_poxwalker_bomber_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	chaos_poxwalker_bomber = {}
}
local basic_chaos_poxwalker_bomber_template = {
	slots = {
		slot_body = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_poxwalker_bomber/attachments_base/body"
			}
		},
		slot_horn = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_poxwalker_bomber/attachments_gear/horn_head_01",
				"content/items/characters/minions/generic_items/empty_minion_item"
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
local default_1 = table.clone(basic_chaos_poxwalker_bomber_template)

templates.chaos_poxwalker_bomber.default = {
	default_1
}

local foundry_1 = table.clone(basic_chaos_poxwalker_bomber_template)

foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.chaos_poxwalker_bomber[zone_ids.tank_foundry] = {
	foundry_1
}

local dust_1 = table.clone(basic_chaos_poxwalker_bomber_template)

dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
templates.chaos_poxwalker_bomber[zone_ids.dust] = {
	dust_1
}

local watertown_1 = table.clone(basic_chaos_poxwalker_bomber_template)

watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.chaos_poxwalker_bomber[zone_ids.watertown] = {
	watertown_1
}

return templates
