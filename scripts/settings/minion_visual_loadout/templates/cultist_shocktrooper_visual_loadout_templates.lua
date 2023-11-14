local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	cultist_shocktrooper = {}
}
local basic_cultist_shocktrooper_template = {
	slots = {
		slot_body = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/midrange_elite_a",
				"content/items/characters/minions/chaos_cultists/attachments_gear/midrange_elite_a_var_01"
			}
		},
		slot_mask = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/mask_01",
				"content/items/characters/minions/generic_items/empty_minion_item"
			}
		},
		slot_face = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_05",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_06"
			}
		},
		slot_ranged_weapon = {
			use_outline = true,
			drop_on_death = true,
			is_weapon = true,
			is_ranged_weapon = true,
			items = {
				"content/items/weapons/minions/ranged/renegade_shotgun"
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
local default_1 = table.clone(basic_cultist_shocktrooper_template)
templates.cultist_shocktrooper.default = {
	default_1
}
local foundry_1 = table.clone(basic_cultist_shocktrooper_template)
foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.cultist_shocktrooper[zone_ids.tank_foundry] = {
	foundry_1
}
local dust_1 = table.clone(basic_cultist_shocktrooper_template)
dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
templates.cultist_shocktrooper[zone_ids.dust] = {
	dust_1
}
local watertown_1 = table.clone(basic_cultist_shocktrooper_template)
watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.cultist_shocktrooper[zone_ids.watertown] = {
	watertown_1
}

return templates
