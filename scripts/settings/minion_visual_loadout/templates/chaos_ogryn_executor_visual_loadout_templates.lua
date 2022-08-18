local MissionSettings = require("scripts/settings/mission/mission_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local gib_overrides_template = GibbingSettings.gib_overrides
local zone_ids = MissionSettings.mission_zone_ids
local basic_chaos_ogryn_executor_template = {
	slot_base_lowerbody = {
		items = {
			"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a"
		}
	},
	slot_base_arms = {
		items = {
			"content/items/characters/minions/chaos_ogryn/attachments_base/arms_a"
		}
	},
	slot_melee_weapon = {
		drop_on_death = true,
		is_weapon = true,
		items = {
			"content/items/weapons/minions/melee/chaos_ogryn_executor_2h_club"
		}
	},
	slot_head = {
		items = {
			"content/items/characters/minions/chaos_ogryn/attachments_base/head_a",
			"content/items/characters/minions/chaos_ogryn/attachments_base/head_b"
		}
	},
	slot_head_attachment = {
		items = {
			"content/items/characters/minions/chaos_ogryn/attachments_gear/bulwark_helmet_01"
		}
	},
	slot_gear_attachment = {
		items = {
			"content/items/characters/minions/chaos_ogryn/attachments_gear/melee_b"
		}
	},
	slot_flesh = {
		starts_invisible = true,
		items = {
			"content/items/characters/minions/gib_items/chaos_ogryn_flesh"
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
	chaos_ogryn_executor = {
		has_gib_overrides = true,
		default = {},
		[zone_ids.tank_foundry] = {}
	}
}
templates.chaos_ogryn_executor.default[1] = table.clone(basic_chaos_ogryn_executor_template)
local foundry_1 = table.clone(basic_chaos_ogryn_executor_template)
foundry_1.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.chaos_ogryn_executor.tank_foundry[1] = foundry_1

return templates
