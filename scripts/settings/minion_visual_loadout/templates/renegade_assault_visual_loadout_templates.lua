local MissionSettings = require("scripts/settings/mission/mission_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local gib_overrides_template = GibbingSettings.gib_overrides
local zone_ids = MissionSettings.mission_zone_ids
local basic_renegade_assault_template = {
	slot_upperbody = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b"
		}
	},
	slot_lowerbody = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a"
		}
	},
	slot_face = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01"
		}
	},
	slot_head = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_01_c"
		}
	},
	slot_ranged_weapon = {
		drop_on_death = true,
		is_weapon = true,
		items = {
			"content/items/weapons/minions/ranged/renegade_lasgun_smg"
		}
	},
	slot_melee_weapon = {
		drop_on_death = true,
		is_weapon = true,
		items = {
			"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_03"
		}
	},
	slot_helmet_decal = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_01_decal_a",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_01_decal_b",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_01_decal_c",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_01_decal_d",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_01_decal_e"
		}
	},
	slot_decal = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_a",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_d",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_e"
		}
	},
	slot_variation_gear = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/midrange_a"
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
local templates = {
	renegade_assault = {
		has_gib_overrides = true,
		default = {},
		[zone_ids.tank_foundry] = {}
	}
}
templates.renegade_assault.default[1] = table.clone(basic_renegade_assault_template)
local foundry_1 = table.clone(basic_renegade_assault_template)
foundry_1.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_assault.tank_foundry[1] = foundry_1

return templates
