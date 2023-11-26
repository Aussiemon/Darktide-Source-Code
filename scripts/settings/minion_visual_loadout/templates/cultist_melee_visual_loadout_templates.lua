-- chunkname: @scripts/settings/minion_visual_loadout/templates/cultist_melee_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	cultist_melee = {}
}
local basic_cultist_melee_template = {
	slots = {
		slot_upperbody = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_d",
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_d_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_d_color_var_02",
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_d_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_d_var_01_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/upperbody_d_var_01_color_var_02"
			}
		},
		slot_lowerbody = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a",
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/lowerbody_a_color_var_02"
			}
		},
		slot_face = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_base/face_02",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_01",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_02",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_03",
				"content/items/characters/minions/chaos_cultists/attachments_base/face_02_tattoo_04"
			}
		},
		slot_head = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_hat_a",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_hat_a_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_hat_a_color_var_02",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_hat_a_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_hat_a_var_01_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_hat_a_var_01_color_var_02"
			}
		},
		slot_melee_weapon = {
			drop_on_death = true,
			is_weapon = true,
			items = {
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_01",
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_04",
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_02"
			}
		},
		slot_variation_gear = {
			items = {
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a_color_var_02",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a_var_01_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a_var_01_color_var_02",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a_var_02",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a_var_02_color_var_01",
				"content/items/characters/minions/chaos_cultists/attachments_gear/melee_a_var_02_color_var_02"
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
		},
		skin_color_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_01",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_02",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_03"
			}
		}
	}
}
local default_1 = table.clone(basic_cultist_melee_template)
local default_2 = table.clone(basic_cultist_melee_template)

default_2.gib_variations = {
	"face_03"
}
default_2.slots.slot_face = {
	items = {
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_02",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_03",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_04"
	}
}

local default_3 = table.clone(basic_cultist_melee_template)

default_3.gib_variations = {
	"no_gear"
}
default_3.slots.slot_variation_gear = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}

local default_4 = table.clone(basic_cultist_melee_template)

default_4.gib_variations = {
	"no_gear",
	"face_03"
}
default_4.slots.slot_variation_gear = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
default_4.slots.slot_face = {
	items = {
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_02",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_03",
		"content/items/characters/minions/chaos_cultists/attachments_base/face_03_tattoo_04"
	}
}

local default_5 = table.clone(default_3)
local default_6 = table.clone(default_4)

templates.cultist_melee.default = {
	default_1,
	default_2,
	default_3,
	default_4,
	default_5,
	default_6
}

local foundry_1 = table.clone(basic_cultist_melee_template)

foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_2 = table.clone(default_2)

foundry_2.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_3 = table.clone(default_3)

foundry_3.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_4 = table.clone(default_4)

foundry_4.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_5 = table.clone(default_3)

foundry_5.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_6 = table.clone(default_4)

foundry_6.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.cultist_melee[zone_ids.tank_foundry] = {
	foundry_1,
	foundry_2,
	foundry_3,
	foundry_4,
	foundry_5,
	foundry_6
}

local dust_1 = table.clone(basic_cultist_melee_template)

dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_2 = table.clone(default_3)

dust_2.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_3 = table.clone(default_3)

dust_3.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_4 = table.clone(default_4)

dust_4.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_5 = table.clone(default_3)

dust_5.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_6 = table.clone(default_4)

dust_6.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
templates.cultist_melee[zone_ids.dust] = {
	dust_1,
	dust_2,
	dust_3,
	dust_4,
	dust_5,
	dust_6
}

local watertown_1 = table.clone(basic_cultist_melee_template)

watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_2 = table.clone(default_2)

watertown_2.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_3 = table.clone(default_3)

watertown_3.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_4 = table.clone(default_4)

watertown_4.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_5 = table.clone(default_3)

watertown_5.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_6 = table.clone(default_4)

watertown_6.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.cultist_melee[zone_ids.watertown] = {
	watertown_1,
	watertown_2,
	watertown_3,
	watertown_4,
	watertown_5,
	watertown_6
}

return templates
