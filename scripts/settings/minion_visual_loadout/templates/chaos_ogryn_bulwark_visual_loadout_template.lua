local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	chaos_ogryn_bulwark = {}
}
local basic_chaos_ogryn_bulwark_template = {
	slots = {
		slot_base_upperbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a",
				"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a_tattoo_01",
				"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a_tattoo_02",
				"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a_tattoo_03"
			}
		},
		slot_base_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a",
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a_color_var_01",
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a_color_var_02",
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a_color_var_03"
			}
		},
		slot_base_arms = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/arms_a",
				"content/items/characters/minions/chaos_ogryn/attachments_base/arms_a_tattoo_01",
				"content/items/characters/minions/chaos_ogryn/attachments_base/arms_a_tattoo_02",
				"content/items/characters/minions/chaos_ogryn/attachments_base/arms_a_tattoo_03"
			}
		},
		slot_headgear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_gear/melee_head_attachment_02",
				"content/items/characters/minions/chaos_ogryn/attachments_gear/melee_head_attachment_03",
				"content/items/characters/minions/generic_items/empty_minion_item"
			}
		},
		slot_base_attachment = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/skin_attachment_01_b",
				"content/items/characters/minions/generic_items/empty_minion_item"
			}
		},
		slot_melee_weapon = {
			use_outline = true,
			is_weapon = true,
			drop_on_death = true,
			items = {
				"content/items/weapons/minions/melee/chaos_ogryn_melee_weapon"
			}
		},
		slot_shield = {
			use_outline = true,
			is_weapon = true,
			drop_on_death = true,
			items = {
				"content/items/weapons/minions/shields/chaos_ogryn_bulwark_shield_01"
			}
		},
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/head_b",
				"content/items/characters/minions/chaos_ogryn/attachments_base/head_b_tattoo_01",
				"content/items/characters/minions/chaos_ogryn/attachments_base/head_b_tattoo_02",
				"content/items/characters/minions/chaos_ogryn/attachments_base/head_b_tattoo_03"
			}
		},
		slot_gear_attachment = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_gear/melee_a"
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
local default_1 = table.clone(basic_chaos_ogryn_bulwark_template)
local default_2 = table.clone(basic_chaos_ogryn_bulwark_template)
local default_3 = table.clone(basic_chaos_ogryn_bulwark_template)
local default_4 = table.clone(basic_chaos_ogryn_bulwark_template)
default_4.gib_variations = {
	"head_01"
}
default_4.slots.slot_head = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a"
	}
}
local default_5 = table.clone(basic_chaos_ogryn_bulwark_template)
default_5.gib_variations = {
	"head_01"
}
default_5.slots.slot_head = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_01",
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_03"
	}
}
local default_6 = table.clone(basic_chaos_ogryn_bulwark_template)
default_6.gib_variations = {
	"head_01"
}
default_6.slots.slot_head = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_02",
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_03"
	}
}
local default_7 = table.clone(basic_chaos_ogryn_bulwark_template)
default_4.gib_variations = {
	"var_01"
}
default_7.slots.slot_gear_attachment = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_ogryn/attachments_gear/melee_a_var_01"
	}
}
local default_8 = table.clone(default_7)
local default_9 = table.clone(default_7)
local default_10 = table.clone(default_7)
default_10.gib_variations = {
	"var_01",
	"head_01"
}
default_10.slots.slot_head = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a"
	}
}
local default_11 = table.clone(default_7)
default_11.gib_variations = {
	"var_01",
	"head_01"
}
default_11.slots.slot_head = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_02",
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_03"
	}
}
local default_12 = table.clone(default_7)
default_12.gib_variations = {
	"var_01",
	"head_01"
}
default_12.slots.slot_head = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_02",
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_03"
	}
}
templates.chaos_ogryn_bulwark.default = {
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
	default_1,
	default_12
}
local foundry_1 = table.clone(default_1)
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
local foundry_5 = table.clone(default_5)
foundry_5.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
local foundry_6 = table.clone(default_6)
foundry_6.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
local foundry_7 = table.clone(default_7)
foundry_7.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
local foundry_8 = table.clone(default_8)
foundry_8.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
local foundry_9 = table.clone(default_9)
foundry_9.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
local foundry_10 = table.clone(default_10)
foundry_10.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
local foundry_11 = table.clone(default_11)
foundry_11.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
local foundry_12 = table.clone(default_12)
foundry_12.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.chaos_ogryn_bulwark[zone_ids.tank_foundry] = {
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
	foundry_11,
	foundry_12
}
local dust_1 = table.clone(default_1)
dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
local dust_2 = table.clone(default_2)
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
local dust_5 = table.clone(default_5)
dust_5.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
local dust_6 = table.clone(default_6)
dust_6.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
local dust_7 = table.clone(default_7)
dust_7.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
local dust_8 = table.clone(default_8)
dust_8.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
local dust_9 = table.clone(default_9)
dust_9.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
local dust_10 = table.clone(default_10)
dust_10.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
local dust_11 = table.clone(default_11)
dust_11.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
local dust_12 = table.clone(default_12)
dust_12.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
templates.chaos_ogryn_bulwark[zone_ids.dust] = {
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
	dust_11,
	dust_12
}
local watertown_1 = table.clone(default_1)
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
local watertown_5 = table.clone(default_5)
watertown_5.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
local watertown_6 = table.clone(default_6)
watertown_6.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
local watertown_7 = table.clone(default_7)
watertown_7.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
local watertown_8 = table.clone(default_8)
watertown_8.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
local watertown_9 = table.clone(default_9)
watertown_9.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
local watertown_10 = table.clone(default_10)
watertown_10.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
local watertown_11 = table.clone(default_11)
watertown_11.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
local watertown_12 = table.clone(default_12)
watertown_12.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.chaos_ogryn_bulwark[zone_ids.watertown] = {
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
	watertown_12
}

return templates
