-- chunkname: @scripts/settings/minion_visual_loadout/templates/chaos_plague_ogryn_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	chaos_plague_ogryn = {},
}
local base_visual_loadout_template = {
	slots = {
		slot_vent = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_plague_ogryn/attachments_base/vent",
			},
		},
		slot_body = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_plague_ogryn/attachments_base/body_skin_02",
				"content/items/characters/minions/chaos_plague_ogryn/attachments_base/body_skin_03",
				"content/items/characters/minions/chaos_plague_ogryn/attachments_base/body_skin_04",
			},
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/plague_ogryn_flesh",
			},
		},
		environmental_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
	},
}
local default_1 = table.clone(base_visual_loadout_template)

templates.chaos_plague_ogryn.default = {
	default_1,
}

local foundry_1 = table.clone(base_visual_loadout_template)

foundry_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02",
}
templates.chaos_plague_ogryn[zone_ids.tank_foundry] = {
	foundry_1,
}

local dust_1 = table.clone(base_visual_loadout_template)

dust_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02",
}
templates.chaos_plague_ogryn[zone_ids.dust] = {
	dust_1,
}

local watertown_1 = table.clone(base_visual_loadout_template)

watertown_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02",
}
templates.chaos_plague_ogryn[zone_ids.watertown] = {
	watertown_1,
}

local void_1 = table.clone(base_visual_loadout_template)

void_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/snow_01",
}
templates.chaos_plague_ogryn[zone_ids.void] = {
	void_1,
}

local horde_1 = table.clone(base_visual_loadout_template)

horde_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/snow_01",
}
templates.chaos_plague_ogryn[zone_ids.horde] = {
	horde_1,
}

return templates
