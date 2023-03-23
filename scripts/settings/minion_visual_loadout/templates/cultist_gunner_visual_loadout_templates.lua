local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local basic_cultist_gunner_template = {
	slots = {
		slot_ranged_weapon = {
			drop_on_death = true,
			is_weapon = true,
			is_ranged_weapon = true,
			items = {
				"content/items/weapons/minions/ranged/chaos_cultist_heavy_stubber_02"
			}
		},
		slot_face = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/face_01_tattoo_05",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_01_tattoo_06"
			}
		},
		slot_head = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/longrange_hood_a",
				"content/items/characters/minions/chaos_cultists/attachments_gear/longrange_hood_a_color_var_01"
			}
		},
		slot_mask = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/gas_mask_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/mask_02",
				"content/items/characters/minions/generic_items/empty_minion_item"
			}
		},
		slot_upperbody = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_b",
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_b_color_var_01"
			}
		},
		slot_lowerbody = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_b",
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_b_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_b_color_var_02"
			}
		},
		slot_variation_gear = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/longrange_elite_a"
			}
		},
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
		skin_color_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_01",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_02",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_03"
			}
		}
	}
}
local templates = {
	cultist_gunner = {
		default = {},
		[zone_ids.tank_foundry] = {},
		[zone_ids.dust] = {},
		[zone_ids.watertown] = {}
	}
}
templates.cultist_gunner.default[1] = table.clone(basic_cultist_gunner_template)
local foundry_1 = table.clone(basic_cultist_gunner_template)
foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.cultist_gunner.tank_foundry[1] = foundry_1
local dust_1 = table.clone(basic_cultist_gunner_template)
dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
templates.cultist_gunner.dust[1] = dust_1
local watertown_1 = table.clone(basic_cultist_gunner_template)
watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.cultist_gunner.watertown[1] = watertown_1

return templates
