-- chunkname: @scripts/settings/fx/minion_push_fx_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_types = ArmorSettings.types
local push_fx_templates = {}

push_fx_templates.cultist_mutant_push = {
	node_name = "j_hips",
	vfx = "content/fx/particles/impacts/generic_charger_shove",
	sfx = {
		[armor_types.armored] = "wwise/events/weapon/play_specials_push_armored",
		[armor_types.berserker] = "wwise/events/weapon/play_specials_push_unarmored",
		[armor_types.disgustingly_resilient] = "wwise/events/weapon/play_specials_push_resilient",
		[armor_types.resistant] = "wwise/events/weapon/play_specials_push_unarmored",
		[armor_types.super_armor] = "wwise/events/weapon/play_specials_push_super_armor",
		[armor_types.unarmored] = "wwise/events/weapon/play_specials_push_unarmored",
		[armor_types.void_shield] = "wwise/events/weapon/play_specials_push_unarmored",
	},
}
push_fx_templates.captain_charge_push = {
	node_name = "j_hips",
	vfx = "content/fx/particles/impacts/generic_charger_shove",
	sfx = {
		[armor_types.armored] = "wwise/events/weapon/play_specials_push_armored",
		[armor_types.berserker] = "wwise/events/weapon/play_specials_push_unarmored",
		[armor_types.disgustingly_resilient] = "wwise/events/weapon/play_specials_push_resilient",
		[armor_types.resistant] = "wwise/events/weapon/play_specials_push_unarmored",
		[armor_types.super_armor] = "wwise/events/weapon/play_specials_push_super_armor",
		[armor_types.unarmored] = "wwise/events/weapon/play_specials_push_unarmored",
		[armor_types.void_shield] = "wwise/events/weapon/play_specials_push_unarmored",
	},
}
push_fx_templates.lunge_push = {
	sfx = {
		[armor_types.armored] = "wwise/events/weapon/play_specials_push_armored",
		[armor_types.berserker] = "wwise/events/weapon/play_specials_push_unarmored",
		[armor_types.disgustingly_resilient] = "wwise/events/weapon/play_specials_push_resilient",
		[armor_types.resistant] = "wwise/events/weapon/play_specials_push_unarmored",
		[armor_types.super_armor] = "wwise/events/weapon/play_specials_push_super_armor",
		[armor_types.unarmored] = "wwise/events/weapon/play_specials_push_unarmored",
		[armor_types.void_shield] = "wwise/events/weapon/play_specials_push_unarmored",
	},
}

return settings("MinionPushFxTemplates", push_fx_templates)
