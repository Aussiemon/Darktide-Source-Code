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
local attack_types = AttackSettings.attack_types
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local templates = {}
local flamer_p1_continuous_fire_step = 3
templates.weapon_trait_bespoke_flamer_p1_toughness_on_continuous_fire = table.merge({
	stat_buffs = {
		[stat_buffs.toughness_extra_regen_rate] = 0.1
	},
	continuous_fire_step = flamer_p1_continuous_fire_step
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_flamer_p1_power_bonus_on_continuous_fire = table.merge({
	stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.02
	},
	continuous_fire_step = flamer_p1_continuous_fire_step
}, BaseWeaponTraitBuffTemplates.stacking_buff_on_continuous_fire)
templates.weapon_trait_bespoke_flamer_p1_faster_reload_on_empty_clip = table.clone(BaseWeaponTraitBuffTemplates.faster_reload_on_empty_clip)
templates.weapon_trait_bespoke_flamer_p1_power_scales_with_clip_percentage = table.clone(BaseWeaponTraitBuffTemplates.power_scales_with_clip_percentage)
templates.weapon_trait_bespoke_flamer_p1_negate_stagger_reduction_with_primary_on_burning = {
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
}
templates.weapon_trait_bespoke_flamer_p1_chance_to_explode_elites_on_kill = {
	fire_buff_id = "flamer_assault",
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_minion_death] = 0.05
	},
	explosion_template = ExplosionTemplates.buff_explosion,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		local tempalte = template_context.template
		local unit = params.dying_unit
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
		local is_burning = buff_extension and buff_extension:has_keyword(keywords.burning)
		local is_source_player = buff_extension and buff_extension:has_buff_id_with_owner(tempalte.fire_buff_id, template_context.unit)
		local breed_name = params.breed_name
		local breed = Breeds[breed_name]
		local is_elite = breed and breed.tags and breed.tags.elite

		return is_burning and is_source_player and is_elite
	end,
	proc_func = function (params, template_data, template_context)
		local dying_unit = params.dying_unit
		local explosion_position = HitZone.hit_zone_center_of_mass(dying_unit, HitZone.hit_zone_names.center_mass, false) + Vector3.up() * 0.01

		Explosion.create_explosion(template_context.world, template_context.physics_world, explosion_position, Vector3.up(), template_context.unit, template_context.template.explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion)
	end
}

return templates
