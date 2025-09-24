-- chunkname: @scripts/settings/minion_visual_loadout/templates/chaos_ogryn_gunner_visual_loadout_template.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	chaos_ogryn_gunner = {},
}
local base_visual_loadout_template = {
	slots = {
		slot_base_upperbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a",
				"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a_tattoo_01",
				"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a_tattoo_02",
				"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a_tattoo_03",
			},
		},
		slot_base_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a",
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a_color_var_01",
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a_color_var_02",
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a_color_var_03",
			},
		},
		slot_base_arms = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/arms_a",
				"content/items/characters/minions/chaos_ogryn/attachments_base/arms_a_tattoo_01",
				"content/items/characters/minions/chaos_ogryn/attachments_base/arms_a_tattoo_02",
				"content/items/characters/minions/chaos_ogryn/attachments_base/arms_a_tattoo_03",
			},
		},
		slot_ranged_weapon = {
			drop_on_death = true,
			is_ranged_weapon = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/ranged/chaos_ogryn_heavy_stubber",
			},
		},
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/head_b",
				"content/items/characters/minions/chaos_ogryn/attachments_base/head_b_tattoo_01",
				"content/items/characters/minions/chaos_ogryn/attachments_base/head_b_tattoo_01",
				"content/items/characters/minions/chaos_ogryn/attachments_base/head_b_tattoo_02",
				"content/items/characters/minions/chaos_ogryn/attachments_base/head_b_tattoo_03",
			},
		},
		slot_base_attachment = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/skin_attachment_02_b",
				"content/items/characters/minions/chaos_ogryn/attachments_base/skin_attachment_02_b",
				"content/items/characters/minions/chaos_ogryn/attachments_base/skin_attachment_02_b",
				"content/items/characters/minions/chaos_ogryn/attachments_gear/ranged_head_attachment_01",
				"content/items/characters/minions/chaos_ogryn/attachments_gear/ranged_head_attachment_02",
				"content/items/characters/minions/chaos_ogryn/attachments_gear/ranged_head_attachment_03",
				"content/items/characters/minions/chaos_ogryn/attachments_gear/ranged_head_attachment_04",
				"content/items/characters/minions/chaos_ogryn/attachments_gear/ranged_head_attachment_05",
			},
		},
		slot_gear_attachment = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_gear/ranged_a",
			},
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/chaos_ogryn_flesh",
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
local default_2 = table.clone(base_visual_loadout_template)
local default_3 = table.clone(base_visual_loadout_template)
local default_4 = table.clone(base_visual_loadout_template)

default_4.gib_variations = {
	"head_01",
}
default_4.slots.slot_head = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a",
	},
}

local default_5 = table.clone(base_visual_loadout_template)

default_5.gib_variations = {
	"head_01",
}
default_5.slots.slot_head = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_01",
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_03",
	},
}

local default_6 = table.clone(base_visual_loadout_template)

default_6.gib_variations = {
	"head_01",
}
default_6.slots.slot_head = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_02",
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_03",
	},
}
templates.chaos_ogryn_gunner.default = {
	default_1,
	default_2,
	default_3,
	default_4,
	default_5,
	default_6,
}

local tank_foundry_variations = {}
local tank_foundry_index = 1

for _, default_variation in pairs(templates.chaos_ogryn_gunner.default) do
	local tank_foundry_variation = table.clone(default_variation)

	tank_foundry_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/dirt_02",
	}
	tank_foundry_variations[#tank_foundry_variations + 1] = tank_foundry_variation
	tank_foundry_index = tank_foundry_index + 1
end

templates.chaos_ogryn_gunner[zone_ids.tank_foundry] = tank_foundry_variations

local dust_variations = {}
local dust_index = 1

for _, default_variation in pairs(templates.chaos_ogryn_gunner.default) do
	local dust_variation = table.clone(default_variation)

	dust_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/sand_02",
	}
	dust_variations[#dust_variations + 1] = dust_variation
	dust_index = dust_index + 1
end

templates.chaos_ogryn_gunner[zone_ids.dust] = dust_variations

local watertown_variations = {}
local watertown_index = 1

for _, default_variation in pairs(templates.chaos_ogryn_gunner.default) do
	local watertown_variation = table.clone(default_variation)

	watertown_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/acid_02",
	}
	watertown_variations[#watertown_variations + 1] = watertown_variation
	watertown_index = watertown_index + 1
end

templates.chaos_ogryn_gunner[zone_ids.watertown] = watertown_variations

local void_variations = {}

for _, default_variation in pairs(templates.chaos_ogryn_gunner.default) do
	local void_variation = table.clone(default_variation)

	void_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/snow_01",
	}
	void_variations[#void_variations + 1] = void_variation
end

templates.chaos_ogryn_gunner[zone_ids.void] = void_variations

local horde_variations = {}

for _, default_variation in pairs(templates.chaos_ogryn_gunner.default) do
	local horde_variation = table.clone(default_variation)

	horde_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/snow_01",
	}
	horde_variations[#horde_variations + 1] = horde_variation
end

templates.chaos_ogryn_gunner[zone_ids.horde] = horde_variations

return templates
