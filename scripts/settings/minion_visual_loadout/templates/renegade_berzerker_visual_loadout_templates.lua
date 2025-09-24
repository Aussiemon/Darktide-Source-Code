-- chunkname: @scripts/settings/minion_visual_loadout/templates/renegade_berzerker_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	renegade_berzerker = {},
}
local base_visual_loadout_template = {
	slots = {
		slot_upperbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_berserker",
			},
		},
		slot_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_berserker",
			},
		},
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_02",
			},
		},
		slot_face = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_berserker",
			},
		},
		slot_melee_weapon = {
			drop_on_death = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/melee/chaos_traitor_guard_berzerker_mainhand_weapon_01",
				"content/items/weapons/minions/melee/chaos_traitor_guard_berzerker_mainhand_weapon_02",
				"content/items/weapons/minions/melee/chaos_traitor_guard_berzerker_mainhand_weapon_03",
				"content/items/weapons/minions/melee/chaos_traitor_guard_berzerker_mainhand_weapon_04",
			},
		},
		slot_variation_gear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_elite_a_berserker",
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
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/renegade_berserker_flesh",
			},
		},
		environmental_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
	},
}
local default_1 = table.clone(base_visual_loadout_template)

templates.renegade_berzerker.default = {
	default_1,
}

local foundry_1 = table.clone(base_visual_loadout_template)

foundry_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02",
}
templates.renegade_berzerker[zone_ids.tank_foundry] = {
	foundry_1,
}

local dust_1 = table.clone(base_visual_loadout_template)

dust_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02",
}
templates.renegade_berzerker[zone_ids.dust] = {
	dust_1,
}

local watertown_1 = table.clone(base_visual_loadout_template)

watertown_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02",
}
templates.renegade_berzerker[zone_ids.watertown] = {
	watertown_1,
}

local void_1 = table.clone(base_visual_loadout_template)

void_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/snow_01",
}
templates.renegade_berzerker[zone_ids.void] = {
	void_1,
}

local horde_1 = table.clone(base_visual_loadout_template)

horde_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/snow_01",
}
templates.renegade_berzerker[zone_ids.horde] = {
	horde_1,
}

return templates
