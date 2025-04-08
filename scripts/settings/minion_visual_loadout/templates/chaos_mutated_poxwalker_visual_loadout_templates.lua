-- chunkname: @scripts/settings/minion_visual_loadout/templates/chaos_mutated_poxwalker_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	chaos_mutated_poxwalker = {},
}
local basic_mutated_poxwalker_template = {
	slots = {
		slot_body = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_poxwalker/attachments_base/body_tentacle_arm",
				"content/items/characters/minions/chaos_poxwalker/attachments_base/body_tentacle_arm_skin_01",
				"content/items/characters/minions/chaos_poxwalker/attachments_base/body_tentacle_arm_skin_02",
				"content/items/characters/minions/chaos_poxwalker/attachments_base/body_tentacle_arm_skin_03",
				"content/items/characters/minions/chaos_poxwalker/attachments_base/body_tentacle_arm_skin_04",
			},
		},
		slot_melee_weapon = {
			drop_on_death = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/melee/renegade_melee_weapon_01",
				"content/items/weapons/minions/melee/renegade_melee_weapon_02",
				"content/items/weapons/minions/melee/renegade_melee_weapon_03",
				"content/items/weapons/minions/melee/renegade_melee_weapon_04",
				"content/items/weapons/minions/melee/renegade_melee_weapon_05",
				"content/items/weapons/minions/melee/renegade_melee_weapon_06",
			},
		},
		slot_upper_body_horn = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_left_02",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_left_02",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_left_02",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_left_02",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_left_03",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_left_03",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_left_03",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_left_03",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_right_01",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_right_01",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_right_01",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_right_02",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_right_02",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_right_02",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_torso_01",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_torso_02",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_torso_02",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_torso_02",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_torso_02",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_torso_03",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_torso_03",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_torso_03",
				"content/items/characters/minions/generic_items/empty_minion_item",
				"content/items/characters/minions/generic_items/empty_minion_item",
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_poxwalker/attachments_base/hair_a",
				"content/items/characters/minions/chaos_poxwalker/attachments_base/hair_b",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_head_01",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_head_02",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_head_03",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_head_04",
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_horn = {
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_lower_body = {
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_upper_body = {
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/poxwalker_body_tentacle_arm_flesh",
			},
		},
		slot_variation_gear = {
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		zone_decal = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/decal_material_overrides/decal_transit_01",
				"content/items/characters/minions/decal_material_overrides/decal_transit_02",
				"content/items/characters/minions/decal_material_overrides/decal_transit_03",
				"content/items/characters/minions/decal_material_overrides/decal_transit_04",
				"content/items/characters/minions/decal_material_overrides/decal_transit_05",
			},
		},
		envrionmental_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/environment_overrides/dirt_02",
			},
		},
	},
}
local default_1 = table.clone(basic_mutated_poxwalker_template)
local default_2 = table.clone(basic_mutated_poxwalker_template)

default_2.gib_variations = {
	"lowerbody_a",
}
default_2.slots.slot_lower_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06",
	},
}
default_2.slots.slot_upper_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e",
	},
}
default_2.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_base/body_tentacle_arm",
		"content/items/characters/minions/chaos_poxwalker/attachments_base/body_tentacle_arm_skin_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_base/body_tentacle_arm_skin_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_base/body_tentacle_arm_skin_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_base/body_tentacle_arm_skin_04",
	},
}
templates.chaos_mutated_poxwalker.default = {
	default_1,
	default_2,
}

return templates
