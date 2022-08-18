local MissionSettings = require("scripts/settings/mission/mission_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local gib_overrides_template = GibbingSettings.gib_overrides
local zone_ids = MissionSettings.mission_zone_ids
local basic_chaos_ogryn_gunner_template = {
	slot_base_upperbody = {
		items = {
			"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a",
			"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a_tattoo_01",
			"content/items/characters/minions/chaos_ogryn/attachments_base/torso_a_tattoo_02"
		}
	},
	slot_base_lowerbody = {
		items = {
			"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a"
		}
	},
	slot_base_arms = {
		items = {
			"content/items/characters/minions/chaos_ogryn/attachments_base/arms_a",
			"content/items/characters/minions/chaos_ogryn/attachments_base/arms_a_tattoo_01",
			"content/items/characters/minions/chaos_ogryn/attachments_base/arms_a_tattoo_02"
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
			"content/items/characters/minions/chaos_ogryn/attachments_base/head_a",
			"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_01",
			"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_02",
			"content/items/characters/minions/chaos_ogryn/attachments_base/head_b",
			"content/items/characters/minions/chaos_ogryn/attachments_base/head_b_tattoo_01",
			"content/items/characters/minions/chaos_ogryn/attachments_base/head_b_tattoo_02"
		}
	},
	slot_base_attachment = {
		items = {
			"content/items/characters/minions/chaos_ogryn/attachments_base/skin_attachment_02_b"
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
local templates = {
	chaos_ogryn_gunner = {
		has_gib_overrides = true,
		default = {},
		[zone_ids.tank_foundry] = {}
	}
}
templates.chaos_ogryn_gunner.default[1] = table.clone(basic_chaos_ogryn_gunner_template)
local default_2 = table.clone(basic_chaos_ogryn_gunner_template)
default_2.slot_head = {
	items = {
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a"
	}
}
local default_2_gibs = table.clone(gib_overrides_template)
default_2_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_ogryn/gibbing/ranged_a/head_01/head_gib"
default_2_gibs.head.sawing.override_gib_unit = "content/characters/enemy/chaos_ogryn/gibbing/ranged_a/head_01/head_gib"
default_2.gib_overrides = default_2_gibs
templates.chaos_ogryn_gunner.default[2] = default_2
local default_3 = table.clone(basic_chaos_ogryn_gunner_template)
default_3.slot_head = {
	items = {
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_01"
	}
}
local default_3_gibs = table.clone(gib_overrides_template)
default_3_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_ogryn/gibbing/ranged_a/head_01/head_gib"
default_3_gibs.head.sawing.override_gib_unit = "content/characters/enemy/chaos_ogryn/gibbing/ranged_a/head_01/head_gib"
default_3.gib_overrides = default_3_gibs
templates.chaos_ogryn_gunner.default[3] = default_3
local default_4 = table.clone(basic_chaos_ogryn_gunner_template)
default_4.slot_head = {
	items = {
		"content/items/characters/minions/chaos_ogryn/attachments_base/head_a_tattoo_02"
	}
}
local default_4_gibs = table.clone(gib_overrides_template)
default_4_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_ogryn/gibbing/ranged_a/head_01/head_gib"
default_4_gibs.head.sawing.override_gib_unit = "content/characters/enemy/chaos_ogryn/gibbing/ranged_a/head_01/head_gib"
default_4.gib_overrides = default_4_gibs
templates.chaos_ogryn_gunner.default[4] = default_4
local foundry_1 = table.clone(basic_chaos_ogryn_gunner_template)
foundry_1.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.chaos_ogryn_gunner.tank_foundry[1] = foundry_1
local foundry_2 = table.clone(default_2)
foundry_2.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.chaos_ogryn_gunner.tank_foundry[2] = foundry_2
local foundry_3 = table.clone(default_3)
foundry_3.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.chaos_ogryn_gunner.tank_foundry[3] = foundry_3
local foundry_4 = table.clone(default_4)
foundry_4.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.chaos_ogryn_gunner.tank_foundry[4] = foundry_4

return templates
