local MissionSettings = require("scripts/settings/mission/mission_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local gib_overrides_template = GibbingSettings.gib_overrides
local zone_ids = MissionSettings.mission_zone_ids
local basic_cultist_melee_template = {
	slot_upperbody = {
		items = {
			"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_d"
		}
	},
	slot_lowerbody = {
		items = {
			"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a"
		}
	},
	slot_face = {
		items = {
			"content/items/characters/minions/chaos_cultists/attachments_base/face_01"
		}
	},
	slot_head = {
		items = {
			"content/items/characters/minions/chaos_cultists/attachments_gear/melee_hat_a"
		}
	},
	slot_melee_weapon = {
		drop_on_death = true,
		is_weapon = true,
		items = {
			"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_02",
			"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_04",
			"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_03"
		}
	},
	slot_variation_gear = {
		items = {
			"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a"
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
	cultist_melee = {
		has_gib_overrides = true,
		default = {},
		[zone_ids.tank_foundry] = {}
	}
}
templates.cultist_melee.default[1] = table.clone(basic_cultist_melee_template)
local default_2 = table.clone(basic_cultist_melee_template)
default_2.slot_face = {
	items = {
		"content/items/characters/minions/chaos_cultists/attachments_base/face_02"
	}
}
local default_2_gibs = table.clone(gib_overrides_template)
default_2_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/face_02/head_gib"
default_2_gibs.head.sawing.override_gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/face_02/head_gib"
default_2.gib_overrides = default_2_gibs
templates.cultist_melee.default[2] = default_2
local default_3 = table.clone(basic_cultist_melee_template)
default_3.slot_face = {
	items = {
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03"
	}
}
local default_3_gibs = table.clone(gib_overrides_template)
default_3_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/face_03/head_gib"
default_3_gibs.head.sawing.override_gib_unit = "content/characters/enemy/chaos_cultists/gibbing/melee_a/face_03/head_gib"
default_3.gib_overrides = default_3_gibs
templates.cultist_melee.default[3] = default_3
local foundry_1 = table.clone(basic_cultist_melee_template)
foundry_1.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.cultist_melee.tank_foundry[1] = foundry_1
local foundry_2 = table.clone(default_2)
foundry_2.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.cultist_melee.tank_foundry[2] = foundry_2
local foundry_3 = table.clone(default_3)
foundry_3.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.cultist_melee.tank_foundry[3] = foundry_3

return templates
