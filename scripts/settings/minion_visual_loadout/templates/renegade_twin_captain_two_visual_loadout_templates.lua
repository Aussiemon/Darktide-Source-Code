local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	renegade_twin_captain_two = {}
}
local renegade_twin_captain_two = {
	slots = {
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/newly_infected_flesh"
			}
		},
		envrionmental_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item"
			}
		},
		slot_power_sword = {
			use_outline = true,
			drop_on_death = true,
			spawn_with_extensions = true,
			is_weapon = true,
			items = {
				"content/items/weapons/minions/melee/chaos_traitor_guard_2h_power_sword"
			}
		},
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_traitor_guard_lieutanant_helmet_01_a"
			}
		},
		slot_upperbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_twins"
			}
		},
		slot_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_color_var_04"
			}
		},
		slot_variation_gear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_lieutenant_d"
			}
		},
		slot_skirt = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_lieutenant_c"
			}
		},
		slot_fx_void_shield = {
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/captain_fx_bubble"
			}
		}
	}
}
local default_1 = table.clone(renegade_twin_captain_two)
templates.renegade_twin_captain_two.default = {
	default_1
}
local foundry_1 = table.clone(renegade_twin_captain_two)
foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_twin_captain_two[zone_ids.tank_foundry] = {
	foundry_1
}
local dust_1 = table.clone(renegade_twin_captain_two)
dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
templates.renegade_twin_captain_two[zone_ids.dust] = {
	dust_1
}
local watertown_1 = table.clone(renegade_twin_captain_two)
watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.renegade_twin_captain_two[zone_ids.watertown] = {
	watertown_1
}

return templates
