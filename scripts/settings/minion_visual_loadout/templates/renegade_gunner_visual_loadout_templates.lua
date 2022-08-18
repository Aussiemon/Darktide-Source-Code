local MissionSettings = require("scripts/settings/mission/mission_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local gib_overrides_template = GibbingSettings.gib_overrides
local zone_ids = MissionSettings.mission_zone_ids
local basic_renegade_gunner_template = {
	slot_ranged_weapon = {
		drop_on_death = true,
		is_weapon = true,
		items = {
			"content/items/weapons/minions/ranged/chaos_traitor_guard_hellgun_01"
		}
	},
	slot_melee_weapon = {
		drop_on_death = true,
		is_weapon = true,
		items = {
			"content/items/weapons/minions/melee/renegade_combat_knife"
		}
	},
	slot_head = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/helmet_02_b"
		}
	},
	slot_upperbody = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_longrange_elite"
		}
	},
	slot_lowerbody = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_longrange_elite"
		}
	},
	slot_decal = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_longrange_elite_a_decal_a",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_longrange_elite_a_decal_b",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_longrange_elite_a_decal_c"
		}
	},
	slot_helmet_decal = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_02_decal_a",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_02_decal_b",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_02_decal_c",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_02_decal_d",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_helmet_02_decal_e"
		}
	},
	slot_variation_gear = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/longrange_elite_a"
		}
	},
	slot_gear_attachment = {
		items = {
			"content/items/weapons/minions/ranged/chaos_traitor_guard_hellgun_backpack"
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
	renegade_gunner = {
		has_gib_overrides = true,
		default = {},
		[zone_ids.tank_foundry] = {}
	}
}
templates.renegade_gunner.default[1] = table.clone(basic_renegade_gunner_template)
local foundry_1 = table.clone(basic_renegade_gunner_template)
foundry_1.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_gunner.tank_foundry[1] = foundry_1

return templates
