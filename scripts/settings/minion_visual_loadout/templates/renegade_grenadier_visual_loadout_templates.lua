local MissionSettings = require("scripts/settings/mission/mission_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local gib_overrides_template = GibbingSettings.gib_overrides
local zone_ids = MissionSettings.mission_zone_ids
local basic_renegade_grenadier_template = {
	slot_face = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_03"
		}
	},
	slot_upperbody = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_b_midrange_elite"
		}
	},
	slot_lowerbody = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_grenadier"
		}
	},
	slot_decal = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_a",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_b",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_c",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_d",
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_e"
		}
	},
	slot_variation_gear = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_gear/special_grenadier"
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
	renegade_grenadier = {
		has_gib_overrides = true,
		default = {},
		[zone_ids.tank_foundry] = {}
	}
}
templates.renegade_grenadier.default[1] = table.clone(basic_renegade_grenadier_template)
local foundry_1 = table.clone(basic_renegade_grenadier_template)
foundry_1.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_grenadier.tank_foundry[1] = foundry_1

return templates
