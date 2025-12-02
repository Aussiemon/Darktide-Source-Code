-- chunkname: @scripts/settings/minion_visual_loadout/templates/renegade/renegade_twin_captain_two_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	renegade_twin_captain_two = {},
}
local base_visual_loadout_template = {
	gib_variations = nil,
	slots = {
		slot_power_sword = {
			drop_on_death = true,
			is_weapon = true,
			spawn_with_extensions = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/melee/chaos_traitor_guard_2h_power_sword",
			},
		},
		slot_face = {
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_traitor_guard_lieutanant_helmet_01_a",
			},
		},
		slot_upperbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_twins",
			},
		},
		slot_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_color_var_04",
			},
		},
		slot_skirt = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_lieutenant_c",
			},
		},
		slot_variation_gear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_lieutenant_d",
			},
		},
		slot_fx_void_shield = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/captain_fx_bubble",
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
	},
}
local havoc_1 = table.clone(base_visual_loadout_template)

havoc_1.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
	},
}
havoc_1.slots.slot_head = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_04",
	},
}
havoc_1.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/captain_01_var_02",
	},
}
havoc_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02",
}
templates.renegade_twin_captain_two.havoc_twin_visual_loadout = {
	havoc_1,
}

local default_1 = table.clone(base_visual_loadout_template)

templates.renegade_twin_captain_two.default = {
	default_1,
}

local foundry_1 = table.clone(base_visual_loadout_template)

foundry_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02",
}
templates.renegade_twin_captain_two[zone_ids.tank_foundry] = {
	foundry_1,
}

local dust_1 = table.clone(base_visual_loadout_template)

dust_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02",
}
templates.renegade_twin_captain_two[zone_ids.dust] = {
	dust_1,
}

local watertown_1 = table.clone(base_visual_loadout_template)

watertown_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02",
}
templates.renegade_twin_captain_two[zone_ids.watertown] = {
	watertown_1,
}

local void_1 = table.clone(base_visual_loadout_template)

void_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/snow_01",
}
templates.renegade_twin_captain_two[zone_ids.void] = {
	void_1,
}

local horde_1 = table.clone(base_visual_loadout_template)

horde_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/snow_01",
}
templates.renegade_twin_captain_two[zone_ids.horde] = {
	horde_1,
}

return templates
