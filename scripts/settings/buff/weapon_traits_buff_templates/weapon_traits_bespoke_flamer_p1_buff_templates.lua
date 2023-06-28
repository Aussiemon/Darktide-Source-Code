local AttackSettings = require("scripts/settings/damage/attack_settings")
local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local Breeds = require("scripts/settings/breed/breeds")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionState = require("scripts/utilities/minion_state")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local FireStepFunctions = require("scripts/settings/buff/fire_step_functions")
local attack_types = AttackSettings.attack_types
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local templates = {
	weapon_trait_bespoke_flamer_p1_toughness_on_continuous_fire = table.merge({
		toughness_fixed_percentage = 0.1,
		continuous_fire_step_func = FireStepFunctions.toughness_regen_continuous_fire_step_func
	}, BaseWeaponTraitBuffTemplates.toughness_on_continuous_fire),
	weapon_trait_bespoke_flamer_p1_power_bonus_on_continuous_fire = table.merge({
		conditional_stat_buffs = {
			[stat_buffs.power_level_modifier] = 0.02
		},
		continuous_fire_step_func = FireStepFunctions.default_continuous_fire_step_func
	}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire),
	weapon_trait_bespoke_flamer_p1_faster_reload_on_empty_clip = table.clone(BaseWeaponTraitBuffTemplates.faster_reload_on_empty_clip),
	weapon_trait_bespoke_flamer_p1_power_scales_with_clip_percentage = table.clone(BaseWeaponTraitBuffTemplates.power_scales_with_clip_percentage),
	weapon_trait_bespoke_flamer_p1_negate_stagger_reduction_with_primary_on_burning = {
		class_name = "buff",
		predicted = false,
		conditional_stat_buffs = {
			[stat_buffs.stagger_burning_reduction_modifier] = 0.5
		},
		valid_actions = {
			action_shoot = true
		},
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local weapon_action_component = unit_data_extension:read_component("weapon_action")
			template_data.weapon_action_component = weapon_action_component
		end,
		conditional_stat_buffs_func = function (template_data, template_context)
			local valid_actions = template_context.template.valid_actions
			local weapon_action_component = template_data.weapon_action_component
			local current_action_name = weapon_action_component.current_action_name

			return valid_actions[current_action_name] and ConditionalFunctions.is_item_slot_wielded(template_data, template_context)
		end
	},
	weapon_trait_bespoke_flamer_p1_chance_to_explode_elites_on_kill = table.merge(table.clone(BaseWeaponTraitBuffTemplates.chance_to_explode_elites_on_kill), {
		proc_data = {
			fire_buff_id = "flamer_assault",
			explosion_template = ExplosionTemplates.trait_buff_flamer_p1_minion_explosion,
			validation_keywords = {
				keywords.burning
			}
		}
	})
}

return templates
