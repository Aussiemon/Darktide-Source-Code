-- chunkname: @scripts/settings/minion_visual_loadout/templates/cultist_berzerker_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	cultist_berzerker = {},
}
local basic_cultist_berzerker_template = {
	slots = {
		slot_upperbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/upperbody_a",
				"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/upperbody_a_tattoo_01",
				"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/upperbody_a_tattoo_02",
				"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/upperbody_a_tattoo_03",
			},
		},
		slot_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/lowerbody_a",
				"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/lowerbody_a_color_var_01",
				"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/lowerbody_a_color_var_02",
			},
		},
		slot_face = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/face_01",
				"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/face_01_tattoo_01",
				"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/face_01_tattoo_02",
				"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/face_01_tattoo_03",
				"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/face_01_tattoo_04",
				"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/face_01_tattoo_05",
				"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/face_01_tattoo_06",
			},
		},
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_melee_weapon = {
			drop_on_death = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/melee/cultist_berzerker_mainhand_weapon_01",
				"content/items/weapons/minions/melee/cultist_berzerker_mainhand_weapon_02",
				"content/items/weapons/minions/melee/cultist_berzerker_mainhand_weapon_03",
			},
		},
		slot_melee_weapon_offhand = {
			drop_on_death = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/melee/cultist_berzerker_offhand_weapon_01",
				"content/items/weapons/minions/melee/cultist_berzerker_offhand_weapon_02",
				"content/items/weapons/minions/melee/cultist_berzerker_offhand_weapon_03",
			},
		},
		slot_variation_gear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultist_melee_elite/attachments_gear/attachment_01",
			},
		},
		slot_skin_attachment = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/skin_attachment_01",
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/cultist_berzerker_flesh",
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
local default_1 = table.clone(basic_cultist_berzerker_template)
local default_2 = table.clone(basic_cultist_berzerker_template)

default_2.gib_variations = {
	"headgear_01",
}
default_2.slots.slot_head = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_cultist_melee_elite/attachments_gear/face_01_headgear_01",
	},
}
templates.cultist_berzerker.default = {
	default_1,
	default_2,
}

local foundry_1 = table.clone(default_1)

foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02",
}

local foundry_2 = table.clone(default_2)

foundry_2.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02",
}
templates.cultist_berzerker[zone_ids.tank_foundry] = {
	foundry_1,
	foundry_2,
}

local dust_1 = table.clone(default_1)

dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02",
}

local dust_2 = table.clone(default_2)

dust_2.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02",
}
templates.cultist_berzerker[zone_ids.dust] = {
	dust_1,
	dust_2,
}

local watertown_1 = table.clone(default_1)

watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02",
}

local watertown_2 = table.clone(default_1)

watertown_2.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02",
}
templates.cultist_berzerker[zone_ids.watertown] = {
	watertown_1,
	watertown_2,
}

return templates
