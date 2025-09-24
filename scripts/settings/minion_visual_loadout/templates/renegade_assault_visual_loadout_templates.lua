-- chunkname: @scripts/settings/minion_visual_loadout/templates/renegade_assault_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	renegade_assault = {},
}
local base_visual_loadout_template = {
	slots = {
		slot_upperbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_color_var_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_var_01_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_var_01_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_var_01_color_var_03",
			},
		},
		slot_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_color_var_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_var_01_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_var_01_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_var_01_color_var_03",
			},
		},
		slot_face = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02",
			},
		},
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_01_c",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_01_c_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_01_c_var_02",
			},
		},
		slot_ranged_weapon = {
			drop_on_death = true,
			is_ranged_weapon = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/ranged/renegade_lasgun_smg",
			},
		},
		slot_melee_weapon = {
			drop_on_death = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_03",
			},
		},
		slot_helmet_decal = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_01_decal_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_01_decal_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_01_decal_c",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_01_decal_d",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_01_decal_e",
			},
		},
		slot_decal = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_d",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_e",
			},
		},
		slot_variation_gear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/midrange_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/midrange_a_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/midrange_a_var_02",
			},
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/traitor_guard_flesh",
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
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_02",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_03",
			},
		},
	},
}
local default_1 = table.clone(base_visual_loadout_template)
local default_2 = table.clone(base_visual_loadout_template)

default_2.gib_variations = {
	"face_02_b",
}
default_2.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_02",
	},
}

local default_3 = table.clone(base_visual_loadout_template)

default_3.gib_variations = {
	"face_03_b",
}
default_3.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_02",
	},
}
templates.renegade_assault.default = {
	default_1,
	default_2,
	default_3,
}

local tank_foundry_variations = {}

for _, default_variation in pairs(templates.renegade_assault.default) do
	local tank_foundry_variation = table.clone(default_variation)

	tank_foundry_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/dirt_02",
	}
	tank_foundry_variations[#tank_foundry_variations + 1] = tank_foundry_variation
end

templates.renegade_assault[zone_ids.tank_foundry] = tank_foundry_variations

local dust_variations = {}

for _, default_variation in pairs(templates.renegade_assault.default) do
	local dust_variation = table.clone(default_variation)

	dust_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/sand_02",
	}
	dust_variations[#dust_variations + 1] = dust_variation
end

templates.renegade_assault[zone_ids.dust] = dust_variations

local watertown_variations = {}

for _, default_variation in pairs(templates.renegade_assault.default) do
	local watertown_variation = table.clone(default_variation)

	watertown_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/acid_02",
	}
	watertown_variations[#watertown_variations + 1] = watertown_variation
end

templates.renegade_assault[zone_ids.watertown] = watertown_variations

local void_variations = {}

for _, default_variation in pairs(templates.renegade_assault.default) do
	local void_variation = table.clone(default_variation)

	void_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/snow_01",
	}
	void_variations[#void_variations + 1] = void_variation
end

templates.renegade_assault[zone_ids.void] = void_variations

local horde_variations = {}

for _, default_variation in pairs(templates.renegade_assault.default) do
	local horde_variation = table.clone(default_variation)

	horde_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/snow_01",
	}
	horde_variations[#horde_variations + 1] = horde_variation
end

templates.renegade_assault[zone_ids.horde] = horde_variations

return templates
