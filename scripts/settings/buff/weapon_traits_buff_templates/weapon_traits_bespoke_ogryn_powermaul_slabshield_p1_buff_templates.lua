local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local PushAttack = require("scripts/utilities/attack/push_attack")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local damage_types = DamageSettings.damage_types
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_powermaul_slabshield_p1_toughness_recovery_on_chained_attacks = table.clone(BaseWeaponTraitBuffTemplates.toughness_recovery_on_chained_attacks)
templates.weapon_trait_bespoke_ogryn_powermaul_slabshield_p1_staggered_targets_receive_increased_damage_debuff = table.clone(BaseWeaponTraitBuffTemplates.staggered_targets_receive_increased_damage_debuff)
templates.weapon_trait_bespoke_ogryn_powermaul_slabshield_p1_infinite_melee_cleave_on_weakspot_kill = table.clone(BaseWeaponTraitBuffTemplates.infinite_melee_cleave_on_weakspot_kill)
templates.weapon_trait_bespoke_ogryn_powermaul_slabshield_p1_staggered_targets_receive_increased_stagger_debuff = table.clone(BaseWeaponTraitBuffTemplates.staggered_targets_receive_increased_stagger_debuff)
templates.weapon_trait_bespoke_ogryn_powermaul_slabshield_p1_taunt_target_on_hit = table.clone(BaseWeaponTraitBuffTemplates.taunt_target_on_staggered_hit)
templates.weapon_trait_bespoke_ogryn_powermaul_slabshield_p1_taunt_target_on_hit_child = table.clone(BaseWeaponTraitBuffTemplates.taunt_target_child)
templates.weapon_trait_bespoke_ogryn_powermaul_slabshield_p1_taunt_target_on_hit.child_buff_template = "weapon_trait_bespoke_ogryn_powermaul_slabshield_p1_taunt_target_on_hit_child"
templates.weapon_trait_bespoke_ogryn_powermaul_slabshield_p1_pass_past_armor_on_crit = table.clone(BaseWeaponTraitBuffTemplates.pass_past_armor_on_crit)
templates.weapon_trait_bespoke_ogryn_powermaul_slabshield_p1_block_grants_power_bonus_parent = {
	child_buff_template = "weapon_trait_bespoke_ogryn_powermaul_slabshield_p1_block_grants_power_bonus_child",
	child_duration = 3.5,
	predicted = false,
	allow_proc_while_active = true,
	stacks_to_remove = 0,
	class_name = "weapon_trait_target_number_parent_proc_buff",
	proc_events = {
		[proc_events.on_block] = 1,
		[proc_events.on_sweep_finish] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	specific_proc_func = {
		on_block = function (params, template_data, template_context)
			local t = FixedFrame.approximate_latest_fixed_time()
			local last_hit_time = template_data.last_hit_time or 0
			local time_since_last_hit = t - last_hit_time
			local total_stamina_blocked = (template_data.total_stamina_blocked or 0) + params.block_cost

			if template_context.template.child_duration < time_since_last_hit then
				total_stamina_blocked = params.block_cost
			end

			template_data.total_stamina_blocked = total_stamina_blocked
			template_data.target_number_of_stacks = math.clamp(math.floor(total_stamina_blocked) + (total_stamina_blocked > 0 and 1 or 0), 0, 5)
			template_data.last_hit_time = t
		end,
		on_sweep_finish = function (params, template_data, template_context)
			template_data.total_stamina_blocked = math.max(template_data.total_stamina_blocked - 1, 0)
			template_data.target_number_of_stacks = math.max(template_data.target_number_of_stacks - 1, 0)
			local t = FixedFrame.approximate_latest_fixed_time()
			template_data.last_hit_time = t
		end
	}
}
templates.weapon_trait_bespoke_ogryn_powermaul_slabshield_p1_block_grants_power_bonus_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.melee_power_level_modifier] = 0.1
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
local _push_settings = {
	inner_push_rad = math.pi * 0.55,
	outer_push_rad = math.pi * 1,
	inner_damage_profile = DamageProfileTemplates.ogryn_shield_push,
	inner_damage_type = damage_types.physical,
	outer_damage_profile = DamageProfileTemplates.default_shield_push,
	outer_damage_type = damage_types.physical
}
templates.weapon_trait_bespoke_ogryn_powermaul_slabshield_p1_block_break_pushes = {
	cooldown_duration = 15,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_block] = 1
	},
	push_settings = {
		push_radius = 5,
		power_level = DEFAULT_POWER_LEVEL * 2
	},
	start_func = function (template_data, template_context)
		local player_unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		template_data.first_person_component = unit_data_extension:read_component("first_person")
		template_data.locomotion_component = unit_data_extension:read_component("locomotion")
		template_data.animation_extension = ScriptUnit.extension(player_unit, "animation_system")
	end,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		return params.block_broken
	end,
	proc_func = function (params, template_data, template_context)
		template_data.perform_push = true
	end,
	update_func = function (template_data, template_context)
		if not template_data.perform_push then
			return
		end

		template_data.perform_push = nil
		local player_unit = template_context.unit
		local first_person_component = template_data.first_person_component
		local locomotion_component = template_data.locomotion_component
		local fp_rotation = first_person_component.rotation
		local right = Quaternion.right(fp_rotation)
		local player_direction = Vector3.cross(right, Vector3.down())
		local player_position = locomotion_component.position
		local rewind_ms = 0
		local is_predicted = false
		local weapon_item = template_context.source_item
		local weak_push = false
		local push_settings = _push_settings
		local template = template_context.template
		local template_override_data = template_context.template_override_data
		local template_push_settings = template_override_data.push_settings or template.push_settings
		local power_level = template_push_settings.power_level
		local push_radius = template_push_settings.push_radius
		push_settings.push_radius = push_radius
		local number_of_units_hit = PushAttack.push(template_context.physics_world, player_position, player_direction, rewind_ms, power_level, push_settings, player_unit, is_predicted, weapon_item, weak_push)
		local fx_extension = ScriptUnit.extension(player_unit, "fx_system")
		local fx_rotation = Quaternion.identity()
		local effect_name = "content/fx/particles/abilities/ogryn_aoe_push"
		local scale = Vector3.one()

		fx_extension:spawn_particles(effect_name, player_position, fx_rotation, scale, nil, nil)
	end
}

return templates
