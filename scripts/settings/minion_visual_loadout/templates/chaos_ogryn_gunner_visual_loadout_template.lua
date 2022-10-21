local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	chaos_ogryn_gunner = {}
}
local basic_chaos_ogryn_gunner_template = {
	slots = {
		slot_base_upperbody = {
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a",
				"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a_tattoo_01",
				"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a_tattoo_02",
				"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a_tattoo_03"
			}
		},
		slot_base_lowerbody = {
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a",
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a_color_var_01",
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a_color_var_02",
				"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a_color_var_03"
			}
		},
		slot_base_arms = {
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/arms_a",
				"content/items/characters/minions/chaos_ogryn/attachments_base/arms_a_tattoo_01",
				"content/items/characters/minions/chaos_ogryn/attachments_base/arms_a_tattoo_02",
				"content/items/characters/minions/chaos_ogryn/attachments_base/arms_a_tattoo_03"
			}
		},
		slot_ranged_weapon = {
			drop_on_death = true,
			is_weapon = true,
			items = {
				"content/items/weapons/minions/ranged/chaos_ogryn_heavy_stubber"
			}
		},
		slot_head = {
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/head_b",
				"content/items/characters/minions/chaos_ogryn/attachments_base/head_b_tattoo_01",
				"content/items/characters/minions/chaos_ogryn/attachments_base/head_b_tattoo_01",
				"content/items/characters/minions/chaos_ogryn/attachments_base/head_b_tattoo_02",
				"content/items/characters/minions/chaos_ogryn/attachments_base/head_b_tattoo_03"
			}
		},
		slot_base_attachment = {
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_base/skin_attachment_02_b",
				"content/items/characters/minions/chaos_ogryn/attachments_base/skin_attachment_02_b",
				"content/items/characters/minions/chaos_ogryn/attachments_base/skin_attachment_02_b",
				"content/items/characters/minions/chaos_ogryn/attachments_gear/ranged_head_attachment_01",
				"content/items/characters/minions/chaos_ogryn/attachments_gear/ranged_head_attachment_02",
				"content/items/characters/minions/chaos_ogryn/attachments_gear/ranged_head_attachment_03",
				"content/items/characters/minions/chaos_ogryn/attachments_gear/ranged_head_attachment_04",
				"content/items/characters/minions/chaos_ogryn/attachments_gear/ranged_head_attachment_05"
			}
		},
		slot_gear_attachment = {
			items = {
				"content/items/characters/minions/chaos_ogryn/attachments_gear/ranged_a"
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
local default_1 = table.clone(basic_chaos_ogryn_gunner_template)
local default_2 = table.clone(basic_chaos_ogryn_gunner_template)
local default_3 = table.clone(basic_chaos_ogryn_gunner_template)
local default_4 = table.clone(basic_chaos_ogryn_gunner_template)
default_4.gib_variations = {
	"head_01"
}
default_4.slots.slot_head = {
	items = {
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a"
	}
}
local default_5 = table.clone(basic_chaos_ogryn_gunner_template)
default_5.gib_variations = {
	"head_01"
}
default_5.slots.slot_head = {
	items = {
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_01",
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_03"
	}
}
local default_6 = table.clone(basic_chaos_ogryn_gunner_template)
default_6.gib_variations = {
	"head_01"
}
default_6.slots.slot_head = {
	items = {
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_02",
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_03"
	}
}
templates.chaos_ogryn_gunner.default = {
	default_1,
	default_2,
	default_3,
	default_4,
	default_5,
	default_6
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
templates.chaos_ogryn_gunner[zone_ids.tank_foundry] = {
	foundry_1,
	foundry_2,
	foundry_3,
	foundry_4,
	foundry_5,
	foundry_6
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
templates.chaos_ogryn_gunner[zone_ids.watertown] = {
	watertown_1,
	watertown_2,
	watertown_3,
	watertown_4,
	watertown_5,
	watertown_6
}

return templates
