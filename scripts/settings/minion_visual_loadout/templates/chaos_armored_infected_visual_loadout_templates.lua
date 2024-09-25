﻿-- chunkname: @scripts/settings/minion_visual_loadout/templates/chaos_armored_infected_visual_loadout_templates.lua

local templates = {
	chaos_armored_infected = {},
}
local basic_armored_infected_template = {
	slots = {
		slot_face = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
			},
		},
		slot_upperbody = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_01_horde_var_01",
			},
		},
		slot_lowerbody = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_01_horde_var_01",
			},
		},
		slot_decal = {
			items = {
				"content/items/characters/player/human/gear_attachments/atoma_prime_decals_01",
			},
		},
		slot_variation_gear = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/shoulderpads_01_armored_infected",
			},
		},
		slot_melee_weapon = {
			drop_on_death = true,
			is_weapon = true,
			items = {
				"content/items/weapons/minions/melee/renegade_melee_weapon_01",
				"content/items/weapons/minions/melee/renegade_melee_weapon_02",
				"content/items/weapons/minions/melee/renegade_melee_weapon_03",
				"content/items/weapons/minions/melee/renegade_melee_weapon_04",
				"content/items/weapons/minions/melee/renegade_melee_weapon_05",
				"content/items/weapons/minions/melee/renegade_melee_weapon_06",
			},
		},
		slot_hair = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_moebian_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_a_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_a_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_a_var_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b_var_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_c",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_c_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_c_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_c_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_c_var_03",
				"content/items/characters/minions/generic_items/empty_minion_item",
				"content/items/characters/minions/generic_items/empty_minion_item",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/head_horns_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/head_horns_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/head_horns_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/head_horns_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/head_horns_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/head_horns_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/head_horns_c",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/head_horns_c",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/head_horns_c",
			},
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/newly_infected_flesh",
			},
		},
		zone_decal = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/decal_material_overrides/decal_transit_01",
				"content/items/characters/minions/decal_material_overrides/decal_transit_02",
				"content/items/characters/minions/decal_material_overrides/decal_transit_03",
				"content/items/characters/minions/decal_material_overrides/decal_transit_04",
				"content/items/characters/minions/decal_material_overrides/decal_transit_05",
			},
		},
		envrionmental_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/environment_overrides/dirt_02",
			},
		},
		skin_color_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/skin_color_overrides/newly_infected_skin_color_01",
				"content/items/characters/minions/skin_color_overrides/newly_infected_skin_color_02",
				"content/items/characters/minions/skin_color_overrides/newly_infected_skin_color_03",
				"content/items/characters/minions/skin_color_overrides/newly_infected_skin_color_04",
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		grunge_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/skin_color_overrides/newly_infected_grunge_01",
				"content/items/characters/minions/skin_color_overrides/newly_infected_grunge_02",
				"content/items/characters/minions/skin_color_overrides/newly_infected_grunge_03",
				"content/items/characters/minions/skin_color_overrides/newly_infected_grunge_04",
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
	},
}
local default_1 = table.clone(basic_armored_infected_template)

default_1.gib_variations = {
	"lowerbody_b",
}
templates.chaos_armored_infected.default = {
	default_1,
}

return templates
