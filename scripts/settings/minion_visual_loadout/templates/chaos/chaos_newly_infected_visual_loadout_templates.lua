-- chunkname: @scripts/settings/minion_visual_loadout/templates/chaos/chaos_newly_infected_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local MinionVisualLoadoutVariations = require("scripts/settings/minion_visual_loadout/minion_visual_loadout_variations")
local zone_ids = MissionSettings.mission_zone_ids
local variations = MinionVisualLoadoutVariations.chaos_newly_infected
local templates = {
	chaos_newly_infected = {},
}
local base_visual_loadout_template = {
	gib_variations = nil,
	slots = {
		slot_body = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a",
			},
		},
		slot_upperbody = {
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_upperbody_decal = {
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_lowerbody = {
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
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
		slot_hair = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_a_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_a_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_a_var_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b_var_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_c",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_c_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_c_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_c_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_c_var_03",
				"content/items/characters/minions/generic_items/empty_minion_item",
				"content/items/characters/minions/generic_items/empty_minion_item",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/head_horns_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/head_horns_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/head_horns_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/head_horns_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/head_horns_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/head_horns_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/head_horns_c",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/head_horns_c",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/head_horns_c",
			},
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/newly_infected_flesh",
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
		environmental_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/environment_overrides/dirt_02",
			},
		},
		skin_color_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/skin_color_overrides/newly_infected_skin_color_01",
				"content/items/characters/minions/skin_color_overrides/newly_infected_skin_color_02",
				"content/items/characters/minions/skin_color_overrides/newly_infected_skin_color_03",
				"content/items/characters/minions/skin_color_overrides/newly_infected_skin_color_04",
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		grunge_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/skin_color_overrides/newly_infected_grunge_01",
				"content/items/characters/minions/skin_color_overrides/newly_infected_grunge_02",
				"content/items/characters/minions/skin_color_overrides/newly_infected_grunge_03",
				"content/items/characters/minions/skin_color_overrides/newly_infected_grunge_04",
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
	},
}
local default_1 = table.clone(base_visual_loadout_template)

default_1.gib_variations = {
	"lowerbody_b",
}
default_1.slots.slot_lowerbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_05",
	},
}

local default_2 = table.clone(base_visual_loadout_template)

default_2.gib_variations = {
	"lowerbody_c",
}
default_2.slots.slot_lowerbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_05",
	},
}

local default_3 = table.clone(base_visual_loadout_template)

default_3.gib_variations = {
	"upperbody_a",
	"lowerbody_b",
}
default_3.slots.slot_lowerbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_05",
	},
}
default_3.slots.slot_upperbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_05",
	},
}
default_3.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local default_4 = table.clone(base_visual_loadout_template)

default_4.gib_variations = {
	"upperbody_a",
	"lowerbody_c",
}
default_4.slots.slot_lowerbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_05",
	},
}
default_4.slots.slot_upperbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_05",
	},
}
default_4.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local default_5 = table.clone(base_visual_loadout_template)

default_5.gib_variations = {
	"upperbody_b",
	"lowerbody_a",
}
default_5.slots.slot_lowerbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_05",
	},
}
default_5.slots.slot_upperbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_05",
	},
}

local default_6 = table.clone(base_visual_loadout_template)

default_6.gib_variations = {
	"upperbody_b",
	"lowerbody_b",
}
default_6.slots.slot_lowerbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_05",
	},
}
default_6.slots.slot_upperbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_05",
	},
}

local default_7 = table.clone(base_visual_loadout_template)

default_7.gib_variations = {
	"upperbody_b",
	"lowerbody_c",
}
default_7.slots.slot_lowerbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_05",
	},
}
default_7.slots.slot_upperbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_05",
	},
}

local default_8 = table.clone(base_visual_loadout_template)

default_8.gib_variations = {
	"upperbody_c",
	"lowerbody_b",
}
default_8.slots.slot_hair = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
default_8.slots.slot_lowerbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_05",
	},
}
default_8.slots.slot_upperbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_05",
	},
}

local default_9 = table.clone(base_visual_loadout_template)

default_9.gib_variations = {
	"upperbody_c",
	"lowerbody_c",
}
default_9.slots.slot_hair = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
default_9.slots.slot_lowerbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_05",
	},
}
default_9.slots.slot_upperbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_05",
	},
}

local default_10 = table.clone(base_visual_loadout_template)

default_10.gib_variations = {
	"upperbody_d",
	"lowerbody_b",
}
default_10.slots.slot_lowerbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_05",
	},
}
default_10.slots.slot_upperbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_05",
	},
}

local default_11 = table.clone(base_visual_loadout_template)

default_11.gib_variations = {
	"upperbody_d",
	"lowerbody_c",
}
default_11.slots.slot_lowerbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_05",
	},
}
default_11.slots.slot_upperbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_05",
	},
}

local default_12 = table.clone(base_visual_loadout_template)

default_12.gib_variations = {
	"upperbody_e",
	"lowerbody_b",
}
default_12.slots.slot_lowerbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_05",
	},
}
default_12.slots.slot_upperbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_05",
	},
}
default_12.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local default_13 = table.clone(base_visual_loadout_template)

default_13.gib_variations = {
	"upperbody_e",
	"lowerbody_c",
}
default_13.slots.slot_lowerbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_05",
	},
}
default_13.slots.slot_upperbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_05",
	},
}
default_13.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local default_14 = table.clone(base_visual_loadout_template)

default_14.gib_variations = {
	"upperbody_f",
	"lowerbody_b",
}
default_14.slots.slot_lowerbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_05",
	},
}
default_14.slots.slot_upperbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_05",
	},
}
default_14.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local default_15 = table.clone(base_visual_loadout_template)

default_15.gib_variations = {
	"upperbody_f",
	"lowerbody_c",
}
default_15.slots.slot_lowerbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_05",
	},
}
default_15.slots.slot_upperbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_05",
	},
}
default_15.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local default_16 = table.clone(base_visual_loadout_template)

default_16.gib_variations = {
	"fullbody_a",
	"lowerbody_b",
}
default_16.slots.slot_lowerbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_05",
	},
}
default_16.slots.slot_upperbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_05",
	},
}
default_16.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local default_17 = table.clone(base_visual_loadout_template)

default_17.gib_variations = {
	"fullbody_a",
	"lowerbody_c",
}
default_17.slots.slot_lowerbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_05",
	},
}
default_17.slots.slot_upperbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_05",
	},
}
default_17.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local default_18 = table.clone(base_visual_loadout_template)

default_18.gib_variations = {
	"fullbody_a",
}
default_18.slots.slot_upperbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_05",
	},
}
default_18.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local default_19 = table.clone(default_16)

default_19.slots.slot_lowerbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_04",
	},
}
default_19.slots.slot_upperbody = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_04",
	},
}
default_19.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_decal",
	},
}
default_19.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_transit_01",
	"content/items/characters/minions/decal_material_overrides/decal_transit_02",
	"content/items/characters/minions/decal_material_overrides/decal_transit_03",
	"content/items/characters/minions/decal_material_overrides/decal_transit_04",
	"content/items/characters/minions/decal_material_overrides/decal_transit_05",
}

local default_20 = table.clone(default_1)

default_20.gib_variations = {
	"default_body_01_var_01",
	"lowerbody_b",
}
default_20.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}

local default_21 = table.clone(default_2)

default_21.gib_variations = {
	"default_body_01_var_01",
	"lowerbody_c",
}
default_21.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}

local default_22 = table.clone(default_3)

default_22.gib_variations = {
	"upperbody_a_body_01_var_01",
	"head_body_01_var_01",
	"upperbody_a",
	"lowerbody_b",
}
default_22.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}

local default_23 = table.clone(default_4)

default_23.gib_variations = {
	"upperbody_a_body_01_var_01",
	"head_body_01_var_01",
	"upperbody_a",
	"lowerbody_c",
}
default_23.variation = variations.default_4
default_23.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}

local default_24 = table.clone(default_5)

default_24.gib_variations = {
	"upperbody_b_body_01_var_01",
	"head_body_01_var_01",
	"upperbody_b",
	"lowerbody_a",
}
default_24.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}

local default_25 = table.clone(default_6)

default_25.gib_variations = {
	"upperbody_b_body_01_var_01",
	"upperbody_b",
	"head_body_01_var_01",
	"lowerbody_b",
}
default_25.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}

local default_26 = table.clone(default_7)

default_26.gib_variations = {
	"upperbody_b_body_01_var_01",
	"upperbody_b",
	"head_body_01_var_01",
	"lowerbody_c",
}
default_26.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}

local default_27 = table.clone(default_8)

default_27.gib_variations = {
	"upperbody_c_body_01_var_01",
	"upperbody_c",
	"lowerbody_b",
}
default_27.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}

local default_28 = table.clone(default_9)

default_28.gib_variations = {
	"upperbody_c_body_01_var_01",
	"upperbody_c",
	"lowerbody_c",
}
default_28.slots.slot_hair = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
default_28.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}

local default_29 = table.clone(default_10)

default_29.gib_variations = {
	"upperbody_d_body_01_var_01",
	"upperbody_d",
	"head_body_01_var_01",
	"lowerbody_b",
}
default_29.slots.slot_hair = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
default_29.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}

local default_30 = table.clone(default_11)

default_30.gib_variations = {
	"upperbody_d_body_01_var_01",
	"upperbody_d",
	"head_body_01_var_01",
	"lowerbody_c",
}
default_30.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}

local default_31 = table.clone(default_12)

default_31.gib_variations = {
	"upperbody_e_body_01_var_01",
	"upperbody_e",
	"head_body_01_var_01",
	"lowerbody_b",
}
default_31.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}

local default_32 = table.clone(default_13)

default_32.gib_variations = {
	"upperbody_e_body_01_var_01",
	"upperbody_e",
	"head_body_01_var_01",
	"lowerbody_c",
}
default_32.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}

local default_33 = table.clone(default_14)

default_32.gib_variations = {
	"upperbody_f_body_01_var_01",
	"upperbody_f",
	"head_body_01_var_01",
	"lowerbody_b",
}
default_33.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}

local default_34 = table.clone(default_15)

default_34.gib_variations = {
	"upperbody_f_body_01_var_01",
	"upperbody_f",
	"head_body_01_var_01",
	"lowerbody_c",
}
default_34.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}

local default_35 = table.clone(default_16)

default_35.gib_variations = {
	"fullbody_a_body_01_var_01",
	"fullbody_a",
	"head_body_01_var_01",
	"lowerbody_b",
}
default_35.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}

local default_36 = table.clone(default_17)

default_36.gib_variations = {
	"fullbody_a_body_01_var_01",
	"fullbody_a",
	"head_body_01_var_01",
	"lowerbody_c",
}
default_36.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}

local default_37 = table.clone(default_18)

default_37.gib_variations = {
	"fullbody_a_body_01_var_01",
	"fullbody_a",
	"head_body_01_var_01",
}
default_37.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}

local default_38 = table.clone(default_37)

default_38.slots.slot_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_b",
	},
}
templates.chaos_newly_infected.default = {
	default_1,
	default_2,
	default_3,
	default_4,
	default_5,
	default_6,
	default_7,
	default_8,
	default_9,
	default_10,
	default_11,
	default_12,
	default_13,
	default_14,
	default_15,
	default_16,
	default_17,
	default_18,
	default_19,
	default_20,
	default_21,
	default_22,
	default_23,
	default_24,
	default_25,
	default_26,
	default_27,
	default_28,
	default_29,
	default_30,
	default_31,
	default_32,
	default_33,
	default_34,
	default_35,
	default_36,
	default_37,
	default_38,
}

local foundry_1 = table.clone(default_1)

foundry_1.variation = variations.default_1
foundry_1.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_04",
	},
}
foundry_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01",
}

local foundry_2 = table.clone(default_2)

foundry_2.variation = variations.default_2
foundry_2.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_04",
	},
}
foundry_2.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01",
}

local foundry_3 = table.clone(default_16)

foundry_3.variation = variations.default_16
foundry_3.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_04",
	},
}
foundry_3.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_04",
	},
}
foundry_3.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_decal",
	},
}
foundry_3.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_foundry_01",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_02",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_03",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_04",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_05",
}
foundry_3.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01",
}

local foundry_4 = table.clone(default_8)

foundry_4.variation = variations.default_8
foundry_4.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_04",
	},
}
foundry_4.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_04",
	},
}
foundry_4.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01",
}

local foundry_5 = table.clone(default_9)

foundry_5.variation = variations.default_9
foundry_5.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_04",
	},
}
foundry_5.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_04",
	},
}
foundry_5.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01",
}

local foundry_6 = table.clone(default_20)

foundry_6.variation = variations.default_20
foundry_6.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_04",
	},
}
foundry_6.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01",
}

local foundry_7 = table.clone(default_35)

foundry_7.variation = variations.default_35
foundry_7.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_04",
	},
}
foundry_7.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_04",
	},
}
foundry_7.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_decal",
	},
}
foundry_7.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_foundry_01",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_02",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_03",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_04",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_05",
}
foundry_7.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01",
}

local foundry_8 = table.clone(default_28)

foundry_8.variation = variations.default_28
foundry_8.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_04",
	},
}
foundry_8.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_04",
	},
}
foundry_8.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01",
}

local foundry_9 = table.clone(default_27)

foundry_9.variation = variations.default_27
foundry_9.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_04",
	},
}
foundry_9.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_04",
	},
}
foundry_9.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01",
}

local foundry_10 = table.clone(default_28)

foundry_10.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_04",
	},
}
foundry_10.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_04",
	},
}
foundry_10.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01",
}
templates.chaos_newly_infected[zone_ids.tank_foundry] = {
	foundry_1,
	foundry_2,
	foundry_3,
	foundry_4,
	foundry_5,
	foundry_6,
	foundry_7,
	foundry_8,
	foundry_9,
	foundry_10,
}

local dust_1 = table.clone(default_5)

dust_1.variation = variations.default_5
dust_1.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_dust_05",
	},
}
dust_1.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_05",
	},
}
dust_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_01",
}

local dust_2 = table.clone(default_7)

dust_2.variation = variations.default_7
dust_2.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_05",
	},
}
dust_2.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_05",
	},
}
dust_2.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_01",
}

local dust_3 = table.clone(default_9)

dust_3.variation = variations.default_9
dust_3.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_05",
	},
}
dust_3.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_dust_05",
	},
}
dust_3.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_01",
}

local dust_4 = table.clone(default_11)

dust_4.variation = variations.default_11
dust_4.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_05",
	},
}
dust_4.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_dust_05",
	},
}
dust_4.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_01",
}

local dust_5 = table.clone(default_15)

dust_5.variation = variations.default_15
dust_5.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_05",
	},
}
dust_5.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_dust_05",
	},
}
dust_5.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
dust_5.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_dust_01",
	"content/items/characters/minions/decal_material_overrides/decal_dust_02",
	"content/items/characters/minions/decal_material_overrides/decal_dust_03",
	"content/items/characters/minions/decal_material_overrides/decal_dust_04",
	"content/items/characters/minions/decal_material_overrides/decal_dust_05",
}
dust_5.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_01",
}

local dust_6 = table.clone(default_24)

dust_6.variation = variations.default_24
dust_6.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_dust_05",
	},
}
dust_6.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_05",
	},
}
dust_6.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_01",
}

local dust_7 = table.clone(default_26)

dust_7.variation = variations.default_26
dust_7.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_05",
	},
}
dust_7.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_dust_05",
	},
}
dust_7.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_01",
}

local dust_8 = table.clone(default_28)

dust_8.variation = variations.default_28
dust_8.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_05",
	},
}
dust_8.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_dust_05",
	},
}
dust_8.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_01",
}

local dust_9 = table.clone(default_30)

dust_9.variation = variations.default_30
dust_9.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_05",
	},
}
dust_9.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_dust_05",
	},
}
dust_9.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_01",
}

local dust_10 = table.clone(default_34)

dust_10.variation = variations.default_34
dust_10.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_dust_05",
	},
}
dust_10.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_dust_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_dust_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_dust_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_dust_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_dust_05",
	},
}
dust_10.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
dust_10.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_dust_01",
	"content/items/characters/minions/decal_material_overrides/decal_dust_02",
	"content/items/characters/minions/decal_material_overrides/decal_dust_03",
	"content/items/characters/minions/decal_material_overrides/decal_dust_04",
	"content/items/characters/minions/decal_material_overrides/decal_dust_05",
}
dust_10.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_01",
}
templates.chaos_newly_infected[zone_ids.dust] = {
	dust_1,
	dust_2,
	dust_3,
	dust_4,
	dust_5,
	dust_6,
	dust_7,
	dust_8,
	dust_9,
	dust_10,
}

local watertown_1 = table.clone(default_1)

watertown_1.variation = variations.default_1
watertown_1.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_08",
	},
}
watertown_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_2 = table.clone(default_2)

watertown_2.variation = variations.default_2
watertown_2.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_08",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_09",
	},
}
watertown_2.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_3 = table.clone(default_3)

watertown_3.variation = variations.default_3
watertown_3.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_08",
	},
}
watertown_3.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_07",
	},
}
watertown_3.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
watertown_3.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_wt_01",
	"content/items/characters/minions/decal_material_overrides/decal_wt_02",
	"content/items/characters/minions/decal_material_overrides/decal_wt_03",
	"content/items/characters/minions/decal_material_overrides/decal_wt_04",
	"content/items/characters/minions/decal_material_overrides/decal_wt_05",
}
watertown_3.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_4 = table.clone(default_4)

watertown_4.variation = variations.default_4
watertown_4.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_08",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_09",
	},
}
watertown_4.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_07",
	},
}
watertown_4.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
watertown_4.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_wt_01",
	"content/items/characters/minions/decal_material_overrides/decal_wt_02",
	"content/items/characters/minions/decal_material_overrides/decal_wt_03",
	"content/items/characters/minions/decal_material_overrides/decal_wt_04",
	"content/items/characters/minions/decal_material_overrides/decal_wt_05",
}
watertown_4.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_5 = table.clone(default_6)

watertown_5.variation = variations.default_6
watertown_5.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_08",
	},
}
watertown_5.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_06",
	},
}
watertown_5.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_6 = table.clone(default_7)

watertown_6.variation = variations.default_7
watertown_6.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_08",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_09",
	},
}
watertown_6.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_06",
	},
}
watertown_6.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_7 = table.clone(default_8)

watertown_7.variation = variations.default_8
watertown_7.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_08",
	},
}
watertown_7.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_07",
	},
}
watertown_7.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_8 = table.clone(default_9)

watertown_8.variation = variations.default_9
watertown_8.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_08",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_09",
	},
}
watertown_8.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_07",
	},
}
watertown_8.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_9 = table.clone(default_10)

watertown_9.variation = variations.default_10
watertown_9.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_08",
	},
}
watertown_9.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_06",
	},
}
watertown_9.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_10 = table.clone(default_11)

watertown_10.variation = variations.default_11
watertown_10.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_08",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_09",
	},
}
watertown_10.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_06",
	},
}
watertown_10.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_11 = table.clone(default_14)

watertown_11.variation = variations.default_14
watertown_11.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_08",
	},
}
watertown_11.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_07",
	},
}
watertown_11.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
watertown_11.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_wt_01",
	"content/items/characters/minions/decal_material_overrides/decal_wt_02",
	"content/items/characters/minions/decal_material_overrides/decal_wt_03",
	"content/items/characters/minions/decal_material_overrides/decal_wt_04",
	"content/items/characters/minions/decal_material_overrides/decal_wt_05",
}
watertown_11.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_12 = table.clone(default_15)

watertown_12.variation = variations.default_15
watertown_12.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_08",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_09",
	},
}
watertown_12.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_06",
	},
}
watertown_12.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
watertown_12.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_wt_01",
	"content/items/characters/minions/decal_material_overrides/decal_wt_02",
	"content/items/characters/minions/decal_material_overrides/decal_wt_03",
	"content/items/characters/minions/decal_material_overrides/decal_wt_04",
	"content/items/characters/minions/decal_material_overrides/decal_wt_05",
}
watertown_12.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_13 = table.clone(default_16)

watertown_13.variation = variations.default_16
watertown_13.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_08",
	},
}
watertown_13.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_06",
	},
}
watertown_13.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
watertown_13.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_wt_01",
	"content/items/characters/minions/decal_material_overrides/decal_wt_02",
	"content/items/characters/minions/decal_material_overrides/decal_wt_03",
	"content/items/characters/minions/decal_material_overrides/decal_wt_04",
	"content/items/characters/minions/decal_material_overrides/decal_wt_05",
}
watertown_13.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_14 = table.clone(default_17)

watertown_14.variation = variations.default_17
watertown_14.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_08",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_09",
	},
}
watertown_14.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_06",
	},
}
watertown_14.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
watertown_14.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_wt_01",
	"content/items/characters/minions/decal_material_overrides/decal_wt_02",
	"content/items/characters/minions/decal_material_overrides/decal_wt_03",
	"content/items/characters/minions/decal_material_overrides/decal_wt_04",
	"content/items/characters/minions/decal_material_overrides/decal_wt_05",
}
watertown_14.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_15 = table.clone(default_20)

watertown_15.variation = variations.default_20
watertown_15.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_08",
	},
}
watertown_15.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_16 = table.clone(default_21)

watertown_16.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_08",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_09",
	},
}
watertown_16.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_17 = table.clone(default_22)

watertown_17.variation = variations.default_22
watertown_17.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_08",
	},
}
watertown_17.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_07",
	},
}
watertown_17.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
watertown_17.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_wt_01",
	"content/items/characters/minions/decal_material_overrides/decal_wt_02",
	"content/items/characters/minions/decal_material_overrides/decal_wt_03",
	"content/items/characters/minions/decal_material_overrides/decal_wt_04",
	"content/items/characters/minions/decal_material_overrides/decal_wt_05",
}
watertown_17.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_18 = table.clone(default_23)

watertown_18.variation = variations.default_23
watertown_18.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_08",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_09",
	},
}
watertown_18.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_wt_07",
	},
}
watertown_18.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
watertown_18.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_wt_01",
	"content/items/characters/minions/decal_material_overrides/decal_wt_02",
	"content/items/characters/minions/decal_material_overrides/decal_wt_03",
	"content/items/characters/minions/decal_material_overrides/decal_wt_04",
	"content/items/characters/minions/decal_material_overrides/decal_wt_05",
}
watertown_18.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_19 = table.clone(default_25)

watertown_19.variation = variations.default_25
watertown_19.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_08",
	},
}
watertown_19.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_06",
	},
}
watertown_19.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_20 = table.clone(default_26)

watertown_20.variation = variations.default_26
watertown_20.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_08",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_09",
	},
}
watertown_20.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_wt_06",
	},
}
watertown_20.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_21 = table.clone(default_27)

watertown_21.variation = variations.default_27
watertown_21.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_08",
	},
}
watertown_21.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_07",
	},
}
watertown_21.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_22 = table.clone(default_28)

watertown_22.variation = variations.default_28
watertown_22.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_08",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_09",
	},
}
watertown_22.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_wt_07",
	},
}
watertown_22.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_23 = table.clone(default_29)

watertown_23.variation = variations.default_29
watertown_23.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_08",
	},
}
watertown_23.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_06",
	},
}
watertown_23.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_24 = table.clone(default_30)

watertown_24.variation = variations.default_30
watertown_24.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_08",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_09",
	},
}
watertown_24.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_wt_06",
	},
}
watertown_24.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_25 = table.clone(default_33)

watertown_25.variation = variations.default_33
watertown_25.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_08",
	},
}
watertown_25.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_07",
	},
}
watertown_25.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
watertown_25.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_wt_01",
	"content/items/characters/minions/decal_material_overrides/decal_wt_02",
	"content/items/characters/minions/decal_material_overrides/decal_wt_03",
	"content/items/characters/minions/decal_material_overrides/decal_wt_04",
	"content/items/characters/minions/decal_material_overrides/decal_wt_05",
}
watertown_25.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_26 = table.clone(default_34)

watertown_26.variation = variations.default_34
watertown_26.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_08",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_09",
	},
}
watertown_26.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_wt_06",
	},
}
watertown_26.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
watertown_26.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_wt_01",
	"content/items/characters/minions/decal_material_overrides/decal_wt_02",
	"content/items/characters/minions/decal_material_overrides/decal_wt_03",
	"content/items/characters/minions/decal_material_overrides/decal_wt_04",
	"content/items/characters/minions/decal_material_overrides/decal_wt_05",
}
watertown_26.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_27 = table.clone(default_35)

watertown_27.variation = variations.default_35
watertown_27.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_wt_08",
	},
}
watertown_27.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_06",
	},
}
watertown_27.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
watertown_27.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_wt_01",
	"content/items/characters/minions/decal_material_overrides/decal_wt_02",
	"content/items/characters/minions/decal_material_overrides/decal_wt_03",
	"content/items/characters/minions/decal_material_overrides/decal_wt_04",
	"content/items/characters/minions/decal_material_overrides/decal_wt_05",
}
watertown_27.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_28 = table.clone(default_36)

watertown_28.variation = variations.default_36
watertown_28.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_06",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_07",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_08",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_wt_09",
	},
}
watertown_28.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_05",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_wt_06",
	},
}
watertown_28.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
watertown_28.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_wt_01",
	"content/items/characters/minions/decal_material_overrides/decal_wt_02",
	"content/items/characters/minions/decal_material_overrides/decal_wt_03",
	"content/items/characters/minions/decal_material_overrides/decal_wt_04",
	"content/items/characters/minions/decal_material_overrides/decal_wt_05",
}
watertown_28.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}
templates.chaos_newly_infected[zone_ids.watertown] = {
	watertown_1,
	watertown_2,
	watertown_3,
	watertown_4,
	watertown_5,
	watertown_6,
	watertown_7,
	watertown_8,
	watertown_9,
	watertown_10,
	watertown_11,
	watertown_12,
	watertown_13,
	watertown_14,
	watertown_15,
	watertown_16,
	watertown_17,
	watertown_18,
	watertown_19,
	watertown_20,
	watertown_21,
	watertown_22,
	watertown_23,
	watertown_24,
	watertown_25,
	watertown_26,
	watertown_27,
	watertown_28,
}

local throneside_1 = table.clone(default_1)

throneside_1.variation = variations.default_1

local throneside_2 = table.clone(default_2)

throneside_2.variation = variations.default_2

local throneside_3 = table.clone(default_3)

throneside_3.variation = variations.default_3

local throneside_4 = table.clone(default_4)

throneside_4.variation = variations.default_4

local throneside_5 = table.clone(default_5)

throneside_5.variation = variations.default_5
throneside_5.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_ts_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_ts_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_ts_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_ts_var_04",
	},
}
throneside_5.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_ts_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_ts_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_ts_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_ts_var_04",
	},
}

local throneside_6 = table.clone(default_5)

throneside_6.variation = variations.default_5
throneside_5.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_ts_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_ts_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_ts_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_ts_var_04",
	},
}
throneside_5.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_ts_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_ts_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_ts_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_ts_var_04",
	},
}

local throneside_7 = table.clone(default_8)

throneside_7.variation = variations.default_8

local throneside_8 = table.clone(default_9)

throneside_8.variation = variations.default_9

local throneside_9 = table.clone(default_10)

throneside_9.variation = variations.default_10

local throneside_10 = table.clone(default_11)

throneside_10.variation = variations.default_11

local throneside_11 = table.clone(default_14)

throneside_11.variation = variations.default_14

local throneside_12 = table.clone(default_15)

throneside_12.variation = variations.default_15

local throneside_13 = table.clone(default_16)

throneside_13.variation = variations.default_16

local throneside_14 = table.clone(default_17)

throneside_14.variation = variations.default_17
throneside_14.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_ts_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_ts_var_02",
	},
}
throneside_14.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_ts_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_ts_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_ts_var_03",
	},
}
throneside_14.slots.slot_hair = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_wig_a",
	},
}

local throneside_15 = table.clone(default_17)

throneside_15.variation = variations.default_17
throneside_14.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_ts_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_ts_var_02",
	},
}
throneside_15.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_ts_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_ts_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_ts_var_03",
	},
}
throneside_15.slots.slot_hair = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_wig_a",
	},
}

local throneside_16 = table.clone(default_21)
local throneside_17 = table.clone(default_22)

throneside_17.variation = variations.default_22

local throneside_18 = table.clone(default_23)

throneside_18.variation = variations.default_23

local throneside_19 = table.clone(default_25)

throneside_19.variation = variations.default_25

local throneside_20 = table.clone(default_26)

throneside_20.variation = variations.default_26
throneside_20.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_ts_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_ts_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_ts_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_ts_var_04",
	},
}
throneside_20.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_ts_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_ts_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_ts_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_ts_var_04",
	},
}

local throneside_21 = table.clone(default_26)

throneside_21.variation = variations.default_26
throneside_21.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_ts_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_ts_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_ts_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_ts_var_04",
	},
}
throneside_21.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_ts_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_ts_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_ts_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_ts_var_04",
	},
}

local throneside_22 = table.clone(default_28)

throneside_22.variation = variations.default_28

local throneside_23 = table.clone(default_29)

throneside_23.variation = variations.default_29

local throneside_24 = table.clone(default_30)

throneside_24.variation = variations.default_30

local throneside_25 = table.clone(default_33)

throneside_25.variation = variations.default_33

local throneside_26 = table.clone(default_36)

throneside_26.variation = variations.default_36
throneside_26.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_ts_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_ts_var_02",
	},
}
throneside_26.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_ts_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_ts_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_ts_var_03",
	},
}
throneside_26.slots.slot_hair = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_wig_a",
	},
}

local throneside_27 = table.clone(default_36)

throneside_27.variation = variations.default_36
throneside_27.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_ts_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_ts_var_02",
	},
}
throneside_27.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_ts_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_ts_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_ts_var_03",
	},
}
throneside_27.slots.slot_hair = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_wig_a",
	},
}

local throneside_28 = table.clone(default_36)

throneside_28.variation = variations.default_36
throneside_28.slots.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_ts_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_ts_var_02",
	},
}
throneside_28.slots.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_ts_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_ts_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_ts_var_03",
	},
}
throneside_28.slots.slot_hair = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_wig_a",
	},
}
templates.chaos_newly_infected[zone_ids.throneside] = {
	throneside_1,
	throneside_2,
	throneside_3,
	throneside_4,
	throneside_5,
	throneside_6,
	throneside_7,
	throneside_8,
	throneside_9,
	throneside_10,
	throneside_11,
	throneside_12,
	throneside_13,
	throneside_14,
	throneside_15,
	throneside_16,
	throneside_17,
	throneside_18,
	throneside_19,
	throneside_20,
	throneside_21,
	throneside_22,
	throneside_23,
	throneside_24,
	throneside_25,
	throneside_26,
	throneside_27,
	throneside_28,
}

local training_grounds_1 = table.clone(default_1)

training_grounds_1.variation = variations.default_1

local training_grounds_2 = table.clone(default_2)

training_grounds_2.variation = variations.default_2

local training_grounds_3 = table.clone(default_5)

training_grounds_3.variation = variations.default_5

local training_grounds_4 = table.clone(default_6)

training_grounds_4.variation = variations.default_6

local training_grounds_5 = table.clone(default_7)

training_grounds_5.variation = variations.default_7

local training_grounds_6 = table.clone(default_8)

training_grounds_6.variation = variations.default_8

local training_grounds_7 = table.clone(default_9)

training_grounds_7.variation = variations.default_9

local training_grounds_8 = table.clone(default_10)

training_grounds_8.variation = variations.default_10

local training_grounds_9 = table.clone(default_11)

training_grounds_9.variation = variations.default_11
templates.chaos_newly_infected[zone_ids.training_grounds] = {
	training_grounds_1,
	training_grounds_2,
	training_grounds_3,
	training_grounds_4,
	training_grounds_5,
	training_grounds_6,
	training_grounds_7,
	training_grounds_8,
	training_grounds_9,
}

local void_variations = {}

for _, tank_foundry_variation in pairs(templates.chaos_newly_infected[zone_ids.tank_foundry]) do
	local void_variation = table.clone(tank_foundry_variation)

	void_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/snow_01",
	}
	void_variations[#void_variations + 1] = void_variation
end

templates.chaos_newly_infected[zone_ids.void] = void_variations

local horde_variations = {}

for _, tank_foundry_variation in pairs(templates.chaos_newly_infected[zone_ids.tank_foundry]) do
	local horde_variation = table.clone(tank_foundry_variation)

	horde_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/snow_01",
	}
	horde_variations[#horde_variations + 1] = horde_variation
end

templates.chaos_newly_infected[zone_ids.horde] = horde_variations

return templates
