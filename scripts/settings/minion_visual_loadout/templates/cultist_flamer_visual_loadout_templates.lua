local MissionSettings = require("scripts/settings/mission/mission_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local gib_overrides_template = GibbingSettings.gib_overrides
local zone_ids = MissionSettings.mission_zone_ids
local basic_cultist_flamer_template = {
	slot_lowerbody = {
		items = {
			"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a"
		}
	},
	slot_head = {
		items = {
			"content/items/characters/minions/chaos_cultists/attachments_gear/special_flamethrower_mask"
		}
	},
	slot_variation_gear = {
		items = {
			"content/items/characters/minions/chaos_cultists/attachments_gear/special_flamethrower"
		}
	},
	slot_ranged_weapon = {
		drop_on_death = true,
		is_weapon = true,
		items = {
			"content/items/weapons/minions/ranged/cultist_flamer"
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
	cultist_flamer = {
		has_gib_overrides = true,
		default = {},
		[zone_ids.tank_foundry] = {}
	}
}
templates.cultist_flamer.default[1] = table.clone(basic_cultist_flamer_template)
local foundry_1 = table.clone(basic_cultist_flamer_template)
foundry_1.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.cultist_flamer.tank_foundry[1] = foundry_1

return templates
