-- chunkname: @scripts/settings/minion_visual_loadout/templates/cultist_ritualist_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	cultist_ritualist = {},
}
local base_visual_loadout_template = {
	slots = {
		slot_upperbody = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_a",
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_a_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_a_color_var_02",
			},
		},
		slot_lowerbody = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a",
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a_color_var_02",
			},
		},
		slot_face = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/face_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_01_tattoo_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_01_tattoo_02",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_01_tattoo_03",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_01_tattoo_04",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_01_tattoo_05",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_01_tattoo_06",
			},
		},
		slot_head = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/ritualist_a",
				"content/items/characters/minions/chaos_cultists/attachments_gear/ritualist_a_var_01",
			},
		},
		slot_variation_gear = {
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
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
local torso_02_items = {
	"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_b",
	"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_b_color_var_01",
}
local default_1 = table.clone(base_visual_loadout_template)
local default_2 = table.clone(default_1)

default_2.gib_variations = {
	"torso_02",
}
default_2.slots.slot_upperbody = {
	items = torso_02_items,
}

local default_3 = table.clone(base_visual_loadout_template)

default_3.gib_variations = {
	"face_02",
}
default_3.slots.slot_face = {
	items = {
		"content/items/characters/minions/chaos_cultists/attachments_base/face_02",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_01",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_02",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_03",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_04",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_05",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_06",
	},
}

local default_4 = table.clone(default_3)

default_4.gib_variations = {
	"face_02",
	"torso_02",
}
default_4.slots.slot_upperbody = {
	items = torso_02_items,
}

local default_5 = table.clone(base_visual_loadout_template)

default_5.gib_variations = {
	"face_03",
}
default_5.slots.slot_face = {
	items = {
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_02",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_03",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_04",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_05",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_06",
	},
}

local default_6 = table.clone(default_5)

default_6.gib_variations = {
	"face_03",
	"torso_02",
}
default_6.slots.slot_upperbody = {
	items = torso_02_items,
}
templates.cultist_ritualist.default = {
	default_1,
	default_2,
	default_3,
	default_4,
	default_5,
	default_6,
}

local tank_foundry_variations = {}

for _, default_variation in pairs(templates.cultist_ritualist.default) do
	local tank_foundry_variation = table.clone(default_variation)

	tank_foundry_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/dirt_02",
	}
	tank_foundry_variations[#tank_foundry_variations + 1] = tank_foundry_variation
end

templates.cultist_ritualist[zone_ids.tank_foundry] = tank_foundry_variations

local dust_variations = {}

for _, default_variation in pairs(templates.cultist_ritualist.default) do
	local dust_variation = table.clone(default_variation)

	dust_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/sand_02",
	}
	dust_variations[#dust_variations + 1] = dust_variation
end

templates.cultist_ritualist[zone_ids.dust] = dust_variations

local watertown_variations = {}

for _, default_variation in pairs(templates.cultist_ritualist.default) do
	local watertown_variation = table.clone(default_variation)

	watertown_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/acid_02",
	}
	watertown_variations[#watertown_variations + 1] = watertown_variation
end

templates.cultist_ritualist[zone_ids.watertown] = watertown_variations

local void_variations = {}

for _, default_variation in pairs(templates.cultist_ritualist.default) do
	local void_variation = table.clone(default_variation)

	void_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/snow_01",
	}
	void_variations[#void_variations + 1] = void_variation
end

templates.cultist_ritualist[zone_ids.void] = void_variations

local horde_variations = {}

for _, default_variation in pairs(templates.cultist_ritualist.default) do
	local horde_variation = table.clone(default_variation)

	horde_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/snow_01",
	}
	horde_variations[#horde_variations + 1] = horde_variation
end

templates.cultist_ritualist[zone_ids.horde] = horde_variations

return templates
