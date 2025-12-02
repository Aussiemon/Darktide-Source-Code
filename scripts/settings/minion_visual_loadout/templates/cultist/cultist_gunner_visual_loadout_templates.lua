-- chunkname: @scripts/settings/minion_visual_loadout/templates/cultist/cultist_gunner_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	cultist_gunner = {},
}
local base_visual_loadout_template = {
	gib_variations = nil,
	slots = {
		slot_ranged_weapon = {
			drop_on_death = true,
			is_ranged_weapon = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/ranged/chaos_cultist_heavy_stubber_02",
			},
		},
		slot_face = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/face_01_tattoo_05",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_01_tattoo_06",
			},
		},
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/longrange_hood_a",
				"content/items/characters/minions/chaos_cultists/attachments_gear/longrange_hood_a_color_var_01",
			},
		},
		slot_mask = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/gas_mask_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/mask_02",
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_upperbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_b",
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_b_color_var_01",
			},
		},
		slot_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_b",
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_b_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_b_color_var_02",
			},
		},
		slot_variation_gear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/longrange_elite_a",
			},
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/newly_infected_flesh",
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

templates.cultist_gunner.default = {
	default_1,
}

local foundry_1 = table.clone(base_visual_loadout_template)

foundry_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02",
}
templates.cultist_gunner[zone_ids.tank_foundry] = {
	foundry_1,
}

local dust_1 = table.clone(base_visual_loadout_template)

dust_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02",
}
templates.cultist_gunner[zone_ids.dust] = {
	dust_1,
}

local watertown_1 = table.clone(base_visual_loadout_template)

watertown_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02",
}
templates.cultist_gunner[zone_ids.watertown] = {
	watertown_1,
}

local void_1 = table.clone(base_visual_loadout_template)

void_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/snow_01",
}
templates.cultist_gunner[zone_ids.void] = {
	void_1,
}

local horde_1 = table.clone(base_visual_loadout_template)

horde_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/snow_01",
}
templates.cultist_gunner[zone_ids.horde] = {
	horde_1,
}

return templates
