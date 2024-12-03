-- chunkname: @scripts/settings/minion_visual_loadout/templates/cultist_ritualist_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	cultist_ritualist = {},
}
local basic_cultist_ritualist_template = {
	slots = {
		slot_upperbody = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_a",
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_a_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_a_color_var_02",
			},
		},
		slot_lowerbody = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a",
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a_color_var_02",
			},
		},
		slot_face = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/face_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_01_tattoo_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_01_tattoo_02",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_01_tattoo_03",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_01_tattoo_04",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_01_tattoo_05",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_01_tattoo_06",
			},
		},
		slot_head = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/ritualist_a",
				"content/items/characters/minions/chaos_cultists/attachments_gear/ritualist_a_var_01",
			},
		},
		slot_variation_gear = {
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/newly_infected_flesh",
			},
		},
		envrionmental_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		skin_color_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_01",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_02",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_03",
			},
		},
	},
}
local torso_02_items = {
	"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_b",
	"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_b_color_var_01",
}
local default_1_1 = table.clone(basic_cultist_ritualist_template)
local default_1_2 = table.clone(default_1_1)

default_1_2.gib_variations = {
	"torso_02",
}
default_1_2.slots.slot_upperbody = {
	items = torso_02_items,
}

local default_2_1 = table.clone(basic_cultist_ritualist_template)

default_2_1.gib_variations = {
	"face_02",
}
default_2_1.slots.slot_face = {
	items = {
		"content/items/characters/minions/chaos_cultists/attachments_base/face_02",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_01",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_02",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_03",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_04",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_05",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_06",
	},
}

local default_2_2 = table.clone(default_2_1)

default_2_2.gib_variations = {
	"face_02",
	"torso_02",
}
default_2_2.slots.slot_upperbody = {
	items = torso_02_items,
}

local default_3_1 = table.clone(basic_cultist_ritualist_template)

default_3_1.gib_variations = {
	"face_03",
}
default_3_1.slots.slot_face = {
	items = {
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_02",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_03",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_04",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_05",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_06",
	},
}

local default_3_2 = table.clone(default_3_1)

default_3_2.gib_variations = {
	"face_03",
	"torso_02",
}
default_3_2.slots.slot_upperbody = {
	items = torso_02_items,
}
templates.cultist_ritualist.default = {
	default_1_1,
	default_1_2,
	default_2_1,
	default_2_2,
	default_3_1,
	default_3_2,
}

return templates
