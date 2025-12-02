-- chunkname: @scripts/settings/minion_visual_loadout/templates/cultist/cultist_melee_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	cultist_melee = {},
}
local base_visual_loadout_template = {
	gib_variations = nil,
	slots = {
		slot_upperbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_d",
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_d_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_d_color_var_02",
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_d_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_d_var_01_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_d_var_01_color_var_02",
			},
		},
		slot_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a",
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a_color_var_02",
			},
		},
		slot_face = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/face_02",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_02",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_03",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_04",
			},
		},
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_hat_a",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_hat_a_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_hat_a_color_var_02",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_hat_a_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_hat_a_var_01_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_hat_a_var_01_color_var_02",
			},
		},
		slot_melee_weapon = {
			drop_on_death = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_01",
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_04",
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_02",
			},
		},
		slot_variation_gear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a_color_var_02",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a_var_01_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a_var_01_color_var_02",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a_var_02",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a_var_02_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a_var_02_color_var_02",
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
local default_2 = table.clone(base_visual_loadout_template)

default_2.gib_variations = {
	"face_03",
}
default_2.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_02",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_03",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_04",
	},
}

local default_3 = table.clone(base_visual_loadout_template)

default_3.gib_variations = {
	"no_gear",
}
default_3.slots.slot_variation_gear = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local default_4 = table.clone(base_visual_loadout_template)

default_4.gib_variations = {
	"no_gear",
	"face_03",
}
default_4.slots.slot_variation_gear = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
default_4.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_02",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_03",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_04",
	},
}

local default_5 = table.clone(default_3)
local default_6 = table.clone(default_4)

templates.cultist_melee.default = {
	default_1,
	default_2,
	default_3,
	default_4,
	default_5,
	default_6,
}

local tank_foundry_variations = {}

for _, default_variation in pairs(templates.cultist_melee.default) do
	local tank_foundry_variation = table.clone(default_variation)

	tank_foundry_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/dirt_02",
	}
	tank_foundry_variations[#tank_foundry_variations + 1] = tank_foundry_variation
end

templates.cultist_melee[zone_ids.tank_foundry] = tank_foundry_variations

local dust_variations = {}

for _, default_variation in pairs(templates.cultist_melee.default) do
	local dust_variation = table.clone(default_variation)

	dust_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/sand_02",
	}
	dust_variations[#dust_variations + 1] = dust_variation
end

templates.cultist_melee[zone_ids.dust] = dust_variations

local watertown_variations = {}

for _, default_variation in pairs(templates.cultist_melee.default) do
	local watertown_variation = table.clone(default_variation)

	watertown_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/acid_02",
	}
	watertown_variations[#watertown_variations + 1] = watertown_variation
end

templates.cultist_melee[zone_ids.watertown] = watertown_variations

local void_variations = {}

for _, default_variation in pairs(templates.cultist_melee.default) do
	local void_variation = table.clone(default_variation)

	void_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/snow_01",
	}
	void_variations[#void_variations + 1] = void_variation
end

templates.cultist_melee[zone_ids.void] = void_variations

local horde_variations = {}

for _, default_variation in pairs(templates.cultist_melee.default) do
	local horde_variation = table.clone(default_variation)

	horde_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/snow_01",
	}
	horde_variations[#horde_variations + 1] = horde_variation
end

templates.cultist_melee[zone_ids.horde] = horde_variations

return templates
