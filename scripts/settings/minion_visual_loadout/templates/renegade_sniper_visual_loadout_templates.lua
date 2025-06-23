-- chunkname: @scripts/settings/minion_visual_loadout/templates/renegade_sniper_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	renegade_sniper = {}
}
local basic_renegade_sniper_template = {
	slots = {
		slot_upperbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_sniper"
			}
		},
		slot_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_sniper"
			}
		},
		slot_face = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_02"
			}
		},
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/hood_and_goggles_a"
			}
		},
		slot_ranged_weapon = {
			use_outline = true,
			drop_on_death = true,
			is_weapon = true,
			is_ranged_weapon = true,
			items = {
				"content/items/weapons/minions/ranged/renegade_sniper_rifle"
			}
		},
		slot_variation_gear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/special_sniper"
			}
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/traitor_guard_flesh"
			}
		},
		envrionmental_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item"
			}
		}
	}
}
local default_1 = table.clone(basic_renegade_sniper_template)

templates.renegade_sniper.default = {
	default_1
}

local foundry_1 = table.clone(basic_renegade_sniper_template)

foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_sniper[zone_ids.tank_foundry] = {
	foundry_1
}

local dust_1 = table.clone(basic_renegade_sniper_template)

dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
templates.renegade_sniper[zone_ids.dust] = {
	dust_1
}

local watertown_1 = table.clone(basic_renegade_sniper_template)

watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.renegade_sniper[zone_ids.watertown] = {
	watertown_1
}

return templates
