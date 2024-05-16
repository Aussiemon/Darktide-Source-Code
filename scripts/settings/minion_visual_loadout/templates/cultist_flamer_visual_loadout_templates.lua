-- chunkname: @scripts/settings/minion_visual_loadout/templates/cultist_flamer_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	cultist_flamer = {},
}
local basic_cultist_flamer_template = {
	slots = {
		slot_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a",
			},
		},
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/special_flamethrower_mask",
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_variation_gear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/special_flamethrower",
			},
		},
		slot_ranged_weapon = {
			drop_on_death = true,
			is_ranged_weapon = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/ranged/cultist_flamer",
			},
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/newly_infected_flesh",
			},
		},
		envrionmental_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
	},
}
local default_1 = table.clone(basic_cultist_flamer_template)

templates.cultist_flamer.default = {
	default_1,
}

local foundry_1 = table.clone(basic_cultist_flamer_template)

foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02",
}
templates.cultist_flamer[zone_ids.tank_foundry] = {
	foundry_1,
}

local dust_1 = table.clone(basic_cultist_flamer_template)

dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02",
}
templates.cultist_flamer[zone_ids.dust] = {
	dust_1,
}

local watertown_1 = table.clone(basic_cultist_flamer_template)

watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02",
}
templates.cultist_flamer[zone_ids.watertown] = {
	watertown_1,
}

return templates
