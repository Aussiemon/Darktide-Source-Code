-- chunkname: @scripts/settings/minion_visual_loadout/templates/chaos/chaos_ogryn_houndmaster_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	chaos_ogryn_houndmaster = {},
}
local base_visual_loadout_template = {
	gib_variations = nil,
	slots = {
		slot_base_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a",
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a_color_var_01",
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a_color_var_02",
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a_color_var_03",
			},
		},
		slot_base_upperbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a",
				"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a_tattoo_01",
				"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a_tattoo_02",
				"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a_tattoo_03",
			},
		},
		slot_base_arms = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/arms_a_small_hand",
			},
		},
		slot_melee_weapon = {
			drop_on_death = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/melee/ogryn_houndmaster_melee_weapon_01",
			},
		},
		slot_headgear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_base_attachment = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/skin_attachment_01_b",
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_head_attachment = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_gear/houndmaster_headgear_01",
			},
		},
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/head_b",
				"content/items/characters/minions/chaos_ogryn/attachments_base/head_b_tattoo_01",
				"content/items/characters/minions/chaos_ogryn/attachments_base/head_b_tattoo_02",
				"content/items/characters/minions/chaos_ogryn/attachments_base/head_b_tattoo_03",
			},
		},
		slot_gear_attachment = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_gear/houndmaster_armour_01",
			},
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/chaos_ogryn_houndmaster_flesh",
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

templates.chaos_ogryn_houndmaster.default = {
	default_1,
}

local foundry_1 = table.clone(base_visual_loadout_template)

foundry_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02",
}
templates.chaos_ogryn_houndmaster[zone_ids.tank_foundry] = {
	foundry_1,
}

local dust_1 = table.clone(base_visual_loadout_template)

dust_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02",
}
templates.chaos_ogryn_houndmaster[zone_ids.dust] = {
	dust_1,
}

local watertown_1 = table.clone(base_visual_loadout_template)

watertown_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02",
}
templates.chaos_ogryn_houndmaster[zone_ids.watertown] = {
	watertown_1,
}

local void_1 = table.clone(base_visual_loadout_template)

void_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/snow_01",
}
templates.chaos_ogryn_houndmaster[zone_ids.void] = {
	void_1,
}

local horde_1 = table.clone(base_visual_loadout_template)

horde_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/snow_01",
}
templates.chaos_ogryn_houndmaster[zone_ids.horde] = {
	horde_1,
}

return templates
