-- chunkname: @scripts/settings/minion_visual_loadout/templates/renegade_captain_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	renegade_captain = {},
}
local base_visual_loadout_template = {
	slots = {
		slot_hellgun = {
			drop_on_death = true,
			is_ranged_weapon = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/ranged/chaos_traitor_guard_hellgun_01",
			},
		},
		slot_bolt_pistol = {
			drop_on_death = true,
			is_ranged_weapon = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/ranged/chaos_traitor_guard_captain_plasma_gun_01",
			},
		},
		slot_plasma_pistol = {
			drop_on_death = true,
			is_ranged_weapon = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/ranged/chaos_traitor_guard_captain_plasma_gun_01",
			},
		},
		slot_shotgun = {
			drop_on_death = true,
			is_ranged_weapon = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/ranged/renegade_elite_shotgun",
			},
		},
		slot_netgun = {
			drop_on_death = true,
			is_ranged_weapon = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/ranged/renegade_netgun",
			},
		},
		slot_powermaul = {
			drop_on_death = true,
			is_weapon = true,
			spawn_with_extensions = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/melee/chaos_traitor_guard_2h_power_maul",
			},
		},
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
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
			},
		},
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_01_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_01_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_01_c",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_04",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_04",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_04",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_04",
			},
		},
		slot_upperbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_captain",
			},
		},
		slot_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_captain",
			},
		},
		slot_decal = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_c",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_d",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_e",
			},
		},
		slot_variation_gear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/captain_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/captain_01_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/captain_01_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/captain_01_var_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/captain_01_var_04",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/captain_01_var_05",
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

templates.renegade_captain.default = {
	default_1,
}

local foundry_1 = table.clone(base_visual_loadout_template)

foundry_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02",
}
templates.renegade_captain[zone_ids.tank_foundry] = {
	foundry_1,
}

local dust_1 = table.clone(base_visual_loadout_template)

dust_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02",
}
templates.renegade_captain[zone_ids.dust] = {
	dust_1,
}

local watertown_1 = table.clone(base_visual_loadout_template)

watertown_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02",
}
templates.renegade_captain[zone_ids.watertown] = {
	watertown_1,
}

local void_1 = table.clone(base_visual_loadout_template)

void_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/snow_01",
}
templates.renegade_captain[zone_ids.void] = {
	void_1,
}

local horde_1 = table.clone(base_visual_loadout_template)

horde_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/snow_01",
}
templates.renegade_captain[zone_ids.horde] = {
	horde_1,
}

return templates
