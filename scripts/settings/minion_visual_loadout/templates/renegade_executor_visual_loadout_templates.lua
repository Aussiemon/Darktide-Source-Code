-- chunkname: @scripts/settings/minion_visual_loadout/templates/renegade_executor_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	renegade_executor = {},
}
local base_visual_loadout_template = {
	slots = {
		slot_upperbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_elite",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_elite_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_elite_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_elite_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_elite_var_01_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_elite_var_01_color_var_02",
			},
		},
		slot_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_elite",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_elite_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_elite_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_elite_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_elite_var_01_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_elite_var_01_color_var_02",
			},
		},
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/executor_helmet_01_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/executor_helmet_01_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/executor_helmet_01_a_var_01",
			},
		},
		slot_melee_weapon = {
			drop_on_death = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/melee/renegade_executor_weapon",
			},
		},
		slot_decal = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_melee_elite_a_decal_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_melee_elite_a_decal_01_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_melee_elite_a_decal_c",
			},
		},
		slot_variation_gear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_elite_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_elite_a_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_elite_a_var_02",
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
	},
}
local default_1 = table.clone(base_visual_loadout_template)

templates.renegade_executor.default = {
	default_1,
}

local foundry_1 = table.clone(base_visual_loadout_template)

foundry_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02",
}
templates.renegade_executor[zone_ids.tank_foundry] = {
	foundry_1,
}

local dust_1 = table.clone(base_visual_loadout_template)

dust_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02",
}
templates.renegade_executor[zone_ids.dust] = {
	dust_1,
}

local watertown_1 = table.clone(base_visual_loadout_template)

watertown_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02",
}
templates.renegade_executor[zone_ids.watertown] = {
	watertown_1,
}

local void_1 = table.clone(base_visual_loadout_template)

void_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/snow_01",
}
templates.renegade_executor[zone_ids.void] = {
	void_1,
}

local horde_1 = table.clone(base_visual_loadout_template)

horde_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/snow_01",
}
templates.renegade_executor[zone_ids.horde] = {
	horde_1,
}

return templates
