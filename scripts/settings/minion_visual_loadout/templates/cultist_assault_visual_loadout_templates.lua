local MissionSettings = require("scripts/settings/mission/mission_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local gib_overrides_template = GibbingSettings.gib_overrides
local zone_ids = MissionSettings.mission_zone_ids
local basic_cultist_assault_template = {
	slot_upperbody = {
		items = {
			"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_a"
		}
	},
	slot_lowerbody = {
		items = {
			"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a"
		}
	},
	slot_face = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b"
		}
	},
	slot_head = {
		items = {
			"content/items/characters/minions/chaos_cultists/attachments_gear/midrange_hat_a"
		}
	},
	slot_ranged_weapon = {
		drop_on_death = true,
		is_weapon = true,
		items = {
			"content/items/weapons/minions/ranged/renegade_autogun_ak"
		}
	},
	slot_melee_weapon = {
		drop_on_death = true,
		is_weapon = true,
		items = {
			"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_01",
			"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_05",
			"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_03",
			"content/items/weapons/minions/melee/renegade_melee_weapon_04"
		}
	},
	slot_variation_gear = {
		items = {
			"content/items/characters/minions/chaos_cultists/attachments_gear/midrange_a"
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
	}
}
local templates = {
	cultist_assault = {
		has_gib_overrides = true,
		default = {},
		[zone_ids.tank_foundry] = {}
	}
}
templates.cultist_assault.default[1] = table.clone(basic_cultist_assault_template)
local foundry_1 = table.clone(basic_cultist_assault_template)
foundry_1.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.cultist_assault.tank_foundry[1] = foundry_1

return templates
