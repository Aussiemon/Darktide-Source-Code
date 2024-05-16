-- chunkname: @scripts/settings/minion_visual_loadout/templates/renegade_twin_captain_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	renegade_twin_captain = {},
}
local basic_cultist_grenadier_template = {
	slots = {
		slot_plasma_pistol = {
			drop_on_death = true,
			is_ranged_weapon = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/ranged/chaos_traitor_guard_captain_plasma_gun_01",
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
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_traitor_guard_lieutanant_helmet_01",
			},
		},
		slot_upperbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_var_01_color_var_04",
			},
		},
		slot_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_color_var_04",
			},
		},
		slot_variation_gear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_lieutenant_a",
			},
		},
		slot_variation_gear_2 = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_lieutenant_b",
			},
		},
		slot_fx_void_shield = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/captain_fx_bubble",
			},
		},
	},
}
local default_1 = table.clone(basic_cultist_grenadier_template)

templates.renegade_twin_captain.default = {
	default_1,
}

local foundry_1 = table.clone(basic_cultist_grenadier_template)

foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02",
}
templates.renegade_twin_captain[zone_ids.tank_foundry] = {
	foundry_1,
}

local dust_1 = table.clone(basic_cultist_grenadier_template)

dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02",
}
templates.renegade_twin_captain[zone_ids.dust] = {
	dust_1,
}

local watertown_1 = table.clone(basic_cultist_grenadier_template)

watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02",
}
templates.renegade_twin_captain[zone_ids.watertown] = {
	watertown_1,
}

return templates
