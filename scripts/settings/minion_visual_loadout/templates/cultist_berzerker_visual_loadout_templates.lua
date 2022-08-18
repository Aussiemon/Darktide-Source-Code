local MissionSettings = require("scripts/settings/mission/mission_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local gib_overrides_template = GibbingSettings.gib_overrides
local zone_ids = MissionSettings.mission_zone_ids
local basic_cultist_berzerker_template = {
	slot_upperbody = {
		items = {
			"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/upperbody_a"
		}
	},
	slot_lowerbody = {
		items = {
			"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/lowerbody_a"
		}
	},
	slot_face = {
		items = {
			"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/face_01"
		}
	},
	slot_head = {
		items = {
			"content/items/characters/minions/generic_items/empty_minion_item"
		}
	},
	slot_melee_weapon = {
		drop_on_death = true,
		is_weapon = true,
		items = {
			"content/items/weapons/minions/melee/cultist_berzerker_mainhand_weapon_01"
		}
	},
	slot_melee_weapon_offhand = {
		drop_on_death = true,
		is_weapon = true,
		items = {
			"content/items/weapons/minions/melee/cultist_berzerker_offhand_weapon_01"
		}
	},
	slot_variation_gear = {
		items = {
			"content/items/characters/minions/chaos_cultist_melee_elite/attachments_gear/attachment_01"
		}
	},
	slot_skin_attachment = {
		items = {
			"content/items/characters/minions/chaos_cultist_melee_elite/attachments_base/skin_attachment_01",
			"content/items/characters/minions/generic_items/empty_minion_item"
		}
	},
	slot_flesh = {
		starts_invisible = true,
		items = {
			"content/items/characters/minions/gib_items/cultist_berzerker_flesh"
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
	cultist_berzerker = {
		has_gib_overrides = true,
		default = {},
		[zone_ids.tank_foundry] = {}
	}
}
templates.cultist_berzerker.default[1] = table.clone(basic_cultist_berzerker_template)
local default_2 = table.clone(basic_cultist_berzerker_template)
default_2.slot_head = {
	items = {
		"content/items/characters/minions/chaos_cultist_melee_elite/attachments_gear/face_01_headgear_01"
	}
}
local default_2_gibs = table.clone(gib_overrides_template)
default_2_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_cultist_melee_elite/gibbing/head_attachment_01/head_gib"
default_2_gibs.head.sawing.override_gib_unit = "content/characters/enemy/chaos_cultist_melee_elite/gibbing/head_attachment_01/head_gib"
default_2.gib_overrides = default_2_gibs
templates.cultist_berzerker.default[2] = default_2
local foundry_1 = table.clone(basic_cultist_berzerker_template)
foundry_1.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.cultist_berzerker.tank_foundry[1] = foundry_1
local foundry_2 = table.clone(default_2)
foundry_2.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.cultist_berzerker.tank_foundry[2] = foundry_2

return templates
