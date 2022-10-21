local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	chaos_ogryn_executor = {}
}
local basic_chaos_ogryn_executor_template = {
	slots = {
		slot_base_lowerbody = {
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a",
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a_color_var_01",
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a_color_var_02",
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a_color_var_03"
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
				"content/items/characters/minions/chaos_ogryn/attachments_gear/bulwark_helmet_01",
				"content/items/characters/minions/chaos_ogryn/attachments_gear/melee_head_attachment_01"
			}
		},
		slot_gear_attachment = {
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_gear/melee_b",
				"content/items/characters/minions/chaos_ogryn/attachments_gear/melee_b_var_01"
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
}
local default_1 = table.clone(basic_chaos_ogryn_executor_template)
templates.chaos_ogryn_executor.default = {
	default_1
}
local foundry_1 = table.clone(basic_chaos_ogryn_executor_template)
foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.chaos_ogryn_executor[zone_ids.tank_foundry] = {
	foundry_1
}
local watertown_1 = table.clone(basic_chaos_ogryn_executor_template)
watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.chaos_ogryn_executor[zone_ids.watertown] = {
	watertown_1
}

return templates
