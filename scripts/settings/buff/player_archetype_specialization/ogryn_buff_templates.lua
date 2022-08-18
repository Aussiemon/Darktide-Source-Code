local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctionTemplates = require("scripts/settings/buff/check_proc_function_templates")
local ConditionalFunctionTemplates = require("scripts/settings/buff/conditional_function_templates")
local Damage = require("scripts/utilities/attack/damage")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local Health = require("scripts/utilities/health")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local attack_types = AttackSettings.attack_types
local buff_keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local stat_buffs = BuffSettings.stat_buffs
local talent_settings = TalentSettings.ogryn_shared
local templates = {
	ogryn_base_passive_tank = {
		predicted = false,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.toughness_damage_taken_multiplier] = talent_settings.tank.toughness_damage_taken_multiplier,
			[stat_buffs.damage_taken_multiplier] = talent_settings.tank.damage_taken_multiplier
		}
	},
	ogryn_base_passive_revive = {
		predicted = false,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.revive_speed_modifier] = talent_settings.revive.revive_speed_modifier,
			[stat_buffs.assist_speed_modifier] = talent_settings.revive.assist_speed_modifier
		}
	},
	coherency_aura_size_increase = {
		predicted = false,
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[stat_buffs.coherency_radius_modifier] = talent_settings.radius.coherency_aura_size_increase
		}
	},
	ogryn_melee_stance = {
		duration = 10,
		class_name = "buff",
		keywords = {
			buff_keywords.uninterruptible
		},
		conditional_stat_buffs = {
			[stat_buffs.attack_speed] = 0.5,
			[stat_buffs.melee_damage] = 0.5,
			[stat_buffs.movement_speed] = 0.5
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			local unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
			local inventory_component = unit_data_extension:read_component("inventory")
			local has_melee_weapon_wielded = PlayerUnitVisualLoadout.has_wielded_weapon_keyword(visual_loadout_extension, inventory_component, "melee")

			return has_melee_weapon_wielded
		end,
		player_effects = {
			on_screen_effect = "content/fx/particles/screenspace/screen_rage_persistant"
		}
	}
}

return templates
