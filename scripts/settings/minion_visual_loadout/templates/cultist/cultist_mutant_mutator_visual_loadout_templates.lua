-- chunkname: @scripts/settings/minion_visual_loadout/templates/cultist/cultist_mutant_mutator_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	cultist_mutant_mutator = {},
}
local base_visual_loadout_template = {
	gib_variations = nil,
	slots = {
		slot_body = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_mutant_charger/attachments_base/body",
				"content/items/characters/minions/chaos_mutant_charger/attachments_base/body_tattoo_01",
				"content/items/characters/minions/chaos_mutant_charger/attachments_base/body_tattoo_02",
				"content/items/characters/minions/chaos_mutant_charger/attachments_base/body_var_01",
				"content/items/characters/minions/chaos_mutant_charger/attachments_base/body_var_01_tattoo_01",
				"content/items/characters/minions/chaos_mutant_charger/attachments_base/body_var_01_tattoo_02",
			},
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/chaos_mutant_charger_flesh",
			},
		},
		environmental_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		skin_color_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_01",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_02",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_03",
			},
		},
	},
}
local default_1 = table.clone(base_visual_loadout_template)

templates.cultist_mutant_mutator.default = {
	default_1,
}

local foundry_1 = table.clone(base_visual_loadout_template)

foundry_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01",
}
templates.cultist_mutant_mutator[zone_ids.tank_foundry] = {
	foundry_1,
}

local dust_1 = table.clone(base_visual_loadout_template)

dust_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_01",
}
templates.cultist_mutant_mutator[zone_ids.dust] = {
	dust_1,
}

local watertown_1 = table.clone(base_visual_loadout_template)

watertown_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}
templates.cultist_mutant_mutator[zone_ids.watertown] = {
	watertown_1,
}

local void_1 = table.clone(base_visual_loadout_template)

void_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/snow_01",
}
templates.cultist_mutant_mutator[zone_ids.void] = {
	void_1,
}

local horde_1 = table.clone(base_visual_loadout_template)

horde_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/snow_01",
}
templates.cultist_mutant_mutator[zone_ids.horde] = {
	horde_1,
}

return templates
