local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local Suppression = require("scripts/utilities/attack/suppression")
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {
	weapon_trait_bespoke_lasgun_p1_increased_zoom = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[stat_buffs.fov_multiplier] = 0.95
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
				return
			end

			return ConditionalFunctions.is_alternative_fire(template_data, template_context)
		end
	},
	weapon_trait_bespoke_lasgun_p1_first_shot_ammo_cost_reduction = {
		cooldown_duration = 1,
		predicted = false,
		class_name = "proc_buff",
		proc_events = {
			[proc_events.on_shoot] = 1
		},
		off_cooldown_keywords = {
			keywords.reduced_ammo_consumption
		}
	},
	weapon_trait_bespoke_lasgun_p1_suppression_negation_on_weakspot = {
		predicted = false,
		class_name = "proc_buff",
		active_duration = 1,
		proc_keywords = {
			keywords.suppression_immune
		},
		proc_events = {
			[proc_events.on_hit] = 1
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_weakspot_hit,
		proc_func = function (params, template_data, template_context)
			Suppression.clear_suppression(template_context.unit)
		end
	},
	weapon_trait_bespoke_lasgun_p1_stacking_crit_chance_on_weakspot_parent = {
		class_name = "weapon_trait_parent_proc_buff",
		child_buff_template = "weapon_trait_bespoke_lasgun_p1_stacking_crit_chance_on_weakspot_child",
		predicted = false,
		stacks_to_remove = 5,
		proc_events = {
			[proc_events.on_hit] = 1,
			[proc_events.on_critical_strike] = 1
		},
		add_child_proc_events = {
			[proc_events.on_hit] = 1
		},
		clear_child_stacks_proc_events = {
			[proc_events.on_critical_strike] = true
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_weakspot_hit
	},
	weapon_trait_bespoke_lasgun_p1_stacking_crit_chance_on_weakspot_child = {
		predicted = false,
		stack_offset = -1,
		max_stacks = 5,
		class_name = "buff",
		conditional_stat_buffs = {
			[stat_buffs.critical_strike_chance] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
	},
	weapon_trait_bespoke_lasgun_p1_count_as_dodge_vs_ranged_on_weakspot = {
		predicted = false,
		class_name = "proc_buff",
		active_duration = 2,
		proc_events = {
			[proc_events.on_hit] = 1
		},
		proc_keywords = {
			keywords.count_as_dodge_vs_ranged
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_weakspot_hit
	},
	weapon_trait_bespoke_lasgun_p1_negate_stagger_reduction_on_weakspot = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[stat_buffs.stagger_weakspot_reduction_modifier] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_weakspot_hit
	},
	weapon_trait_bespoke_lasgun_p1_stagger_count_bonus_damage = table.clone(BaseWeaponTraitBuffTemplates.stagger_count_bonus_damage),
	weapon_trait_bespoke_lasgun_p1_burninating_on_crit = {
		class_name = "proc_buff",
		predicted = false,
		proc_events = {
			[proc_events.on_hit] = 1
		},
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = CheckProcFunctions.on_crit,
		dot_data = {
			dot_buff_name = "flamer_assault",
			num_stacks_on_proc = 1,
			max_stacks = math.huge
		},
		start_func = function (template_data, template_context)
			local template = template_context.template
			local dot_data = template.dot_data
			local template_override_data = template_context.template_override_data
			local override_dot_data = template_override_data.dot_data
			template_data.dot_buff_name = override_dot_data and override_dot_data.dot_buff_name or dot_data.dot_buff_name
			template_data.num_stacks_on_proc = override_dot_data and override_dot_data.num_stacks_on_proc or dot_data.num_stacks_on_proc
			template_data.max_stacks = override_dot_data and override_dot_data.max_stacks or dot_data.max_stacks
		end,
		proc_func = function (params, template_data, template_context, t)
			local attacked_unit = params.attacked_unit
			local attacked_buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

			if attacked_buff_extension then
				local dot_buff_name = template_data.dot_buff_name
				local num_stacks_on_proc = template_data.num_stacks_on_proc
				local max_stacks = template_data.max_stacks
				local current_stacks = attacked_buff_extension:current_stacks(dot_buff_name)
				local stacks_to_add = math.min(num_stacks_on_proc, math.max(max_stacks - current_stacks, 0))

				if stacks_to_add == 0 then
					attacked_buff_extension:refresh_duration_of_stacking_buff(dot_buff_name, t)
				else
					local owner_unit = template_context.owner_unit
					local source_item = template_context.source_item

					for i = 1, stacks_to_add do
						attacked_buff_extension:add_internally_controlled_buff(dot_buff_name, t, "owner_unit", owner_unit, "source_item", source_item)
					end
				end
			end
		end
	},
	weapon_trait_bespoke_lasgun_p1_crit_weakspot_finesse = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[stat_buffs.critical_strike_weakspot_damage] = 0.5
		},
		conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = function (params, template_data, template_context)
			return CheckProcFunctions.on_weakspot_crit(params)
		end
	},
	weapon_trait_bespoke_lasgun_p1_power_bonus_on_first_shot = table.clone(BaseWeaponTraitBuffTemplates.power_bonus_on_first_shot)
}

return templates
