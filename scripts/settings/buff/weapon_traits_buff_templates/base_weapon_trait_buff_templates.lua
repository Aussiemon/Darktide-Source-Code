-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates.lua

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breeds = require("scripts/settings/breed/breeds")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BuffUtils = require("scripts/settings/buff/buff_utils")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local FixedFrame = require("scripts/utilities/fixed_frame")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SharedBuffFunctions = require("scripts/settings/buff/helper_functions/shared_buff_functions")
local Suppression = require("scripts/utilities/attack/suppression")
local Toughness = require("scripts/utilities/toughness/toughness")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local attack_types = AttackSettings.attack_types
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local stat_buffs = BuffSettings.stat_buffs
local slot_configuration = PlayerCharacterConstants.slot_configuration
local _consecutive_hits_proc_func = BuffUtils.consecutive_hits_proc_func
local _consecutive_hits_same_target_proc_func = BuffUtils.consecutive_hits_same_target_proc_func
local _add_debuff_on_hit_start = BuffUtils.add_debuff_on_hit_start
local _add_debuff_on_hit_proc = BuffUtils.add_debuff_on_hit_proc
local base_templates = {}

table.make_unique(base_templates)

base_templates.base_weapon_trait_add_buff_after_proc = {
	class_name = "proc_buff",
	predicted = false,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	end,
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()
		local buff_to_add = template_context.template.buff_to_add

		template_data.buff_extension:add_internally_controlled_buff(buff_to_add, t, "item_slot_name", template_context.item_slot_name)
	end,
}

local function chained_hits_start_func(template_data, template_context)
	local unit = template_context.unit
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local weapon_action_component = unit_data_extension:read_component("weapon_action")

	template_data.weapon_action_component = weapon_action_component
end

local function chain_hits_reset_update_func(template_data, template_context)
	return false
end

base_templates.chained_hits_increases_melee_cleave_parent = {
	child_buff_template = "chained_hits_increases_melee_cleave_child",
	child_duration = 3.5,
	class_name = "weapon_trait_activated_parent_proc_buff",
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	stacks_to_remove = 5,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	active_proc_func = {
		[proc_events.on_sweep_finish] = function (params)
			return params.num_hit_units > 0
		end,
	},
	start_func = chained_hits_start_func,
	reset_update_func = chain_hits_reset_update_func,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.chained_hits_increases_melee_cleave_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.max_hit_mass_attack_modifier] = 0.5,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.chained_hits_increases_crit_chance_parent = {
	child_buff_template = "chained_hits_increases_crit_chance_child",
	child_duration = 3.5,
	class_name = "weapon_trait_activated_parent_proc_buff",
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	stacks_to_remove = 5,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	active_proc_func = {
		[proc_events.on_sweep_finish] = function (params)
			return params.num_hit_units > 0
		end,
	},
	start_func = chained_hits_start_func,
	reset_update_func = chain_hits_reset_update_func,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.chained_hits_increases_crit_chance_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.5,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.chained_hits_increases_power_parent = {
	child_buff_template = "chained_hits_increases_power_child",
	child_duration = 2,
	class_name = "weapon_trait_activated_parent_proc_buff",
	max_stacks = 10,
	predicted = false,
	stack_offset = -1,
	stacks_to_remove = 10,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	active_proc_func = {
		[proc_events.on_sweep_finish] = function (params)
			return params.num_hit_units > 0
		end,
	},
	start_func = chained_hits_start_func,
	reset_update_func = chain_hits_reset_update_func,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.chained_hits_increases_power_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 10,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.melee_power_level_modifier] = 0.05,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.chained_weakspot_hits_increases_power_ranged_parent = {
	child_buff_template = "chained_weakspot_hits_increases_power_child",
	child_duration = 1,
	class_name = "weapon_trait_activated_parent_proc_buff",
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	stacks_to_remove = 5,
	proc_events = {
		[proc_events.on_shoot] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_shoot] = 1,
	},
	active_proc_func = {
		on_shoot = function (params)
			return params.hit_weakspot
		end,
	},
	check_proc_func = CheckProcFunctions.on_weakspot_hit,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.chained_weakspot_hits_increases_crit_chance_ranged_parent = {
	child_buff_template = "chained_weakspot_hits_increases_crit_chance_child",
	class_name = "weapon_trait_activated_parent_proc_buff",
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	proc_events = {
		[proc_events.on_shoot] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_shoot] = 1,
	},
	active_proc_func = {
		on_shoot = function (params)
			return params.hit_weakspot
		end,
	},
	start_func = chained_hits_start_func,
	reset_update_func = chain_hits_reset_update_func,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.chained_weakspot_hits_increases_crit_chance_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.05,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.chained_weakspot_hits_increases_power_parent = {
	child_buff_template = "chained_weakspot_hits_increases_power_child",
	child_duration = 2.5,
	class_name = "weapon_trait_activated_parent_proc_buff",
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	stacks_to_remove = 5,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_hit] = function (params)
			if params.attack_type == attack_types.melee and params.hit_weakspot then
				return 1
			end

			return nil
		end,
	},
	active_proc_func = {
		on_hit = function (params)
			local attack_type = params.attack_type

			if not attack_type then
				return true
			end

			if params.attack_type ~= "melee" or params.hit_weakspot then
				return true
			end

			if not params.target_index or params.target_index > 1 then
				return true
			end

			return false
		end,
	},
	start_func = chained_hits_start_func,
	reset_update_func = chain_hits_reset_update_func,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.chained_weakspot_hits_increases_power_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.05,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.heavy_chained_hits_increases_killing_blow_chance_parent = {
	child_buff_template = "heavy_chained_hits_increases_killing_blow_chance_child",
	child_duration = 5,
	class_name = "weapon_trait_activated_parent_proc_buff",
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_hit] = function (params)
			if params.attack_type == attack_types.melee and CheckProcFunctions.on_heavy_hit(params) then
				return 1
			end

			return nil
		end,
	},
	active_proc_func = {
		[proc_events.on_hit] = function (params)
			return true
		end,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.heavy_chained_hits_increases_killing_blow_chance_child = {
	class_name = "proc_buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	target_buff_data = {
		killing_blow_chance = 0.2,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		if not CheckProcFunctions.on_item_match(params, template_data, template_context) then
			return false
		end

		if params.attack_type ~= attack_types.melee or not CheckProcFunctions.on_heavy_hit(params) then
			return false
		end

		local attacked_unit = params.attacked_unit

		if not HEALTH_ALIVE[attacked_unit] then
			return false
		end

		local template = template_context.template
		local template_override_data = template_context.template_override_data
		local target_buff_data = template_override_data and template_override_data.target_buff_data or template_data.target_buff_data
		local killing_blow_chance = target_buff_data.killing_blow_chance
		local stack_count = template_context.stack_count + (template.stack_offset or 0)
		local random_value = math.random()

		if random_value < stack_count * killing_blow_chance then
			local unit_data = ScriptUnit.has_extension(attacked_unit, "unit_data_system")
			local target_breed = unit_data and unit_data:breed()

			if target_breed then
				local tags = target_breed.tags
				local excluded = tags and (tags.captain or tags.monster or tags.ogryn)

				if excluded then
					return false
				end
			else
				return false
			end

			return true
		end

		return false
	end,
	proc_func = function (params, template_data, template_context)
		local damage_profile = DamageProfileTemplates.killing_blow
		local attacked_unit = params.attacked_unit
		local attack_direction = params.attack_direction:unbox()
		local hit_world_position_box = params.hit_world_position
		local hit_world_position = hit_world_position_box and hit_world_position_box:unbox()

		Attack.execute(attacked_unit, damage_profile, "power_level", DEFAULT_POWER_LEVEL, "instakill", true, "attack_direction", attack_direction, "hit_world_position", hit_world_position, "hit_zone_name", params.hit_zone_name, "damage_type", params.damage_type, "attack_type", params.attack_type, "attacking_unit", template_context.unit)
	end,
}
base_templates.increased_attack_cleave_on_multiple_hits = {
	active_duration = 3,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	buff_data = {
		required_num_hits = 3,
	},
	proc_stat_buffs = {
		[stat_buffs.max_hit_mass_attack_modifier] = 0.5,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_multiple_melee_hit),
}
base_templates.increased_melee_damage_on_multiple_hits = {
	active_duration = 3,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	buff_data = {
		required_num_hits = 3,
	},
	proc_stat_buffs = {
		[stat_buffs.melee_power_level_modifier] = 0.5,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_multiple_melee_hit),
}
base_templates.infinite_melee_cleave_on_crit = {
	active_duration = 5,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.max_hit_mass_attack_modifier] = 0.5,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_melee_crit_hit),
}
base_templates.infinite_melee_cleave_on_kill = {
	active_duration = 5,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	proc_keywords = {
		keywords.melee_infinite_cleave,
		keywords.ignore_armor_aborts_attack,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_kill),
	conditional_keywords_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.infinite_melee_cleave_on_weakspot_kill = {
	class_name = "buff",
	hide_icon_in_hud = true,
	predicted = false,
	conditional_keywords = {
		keywords.melee_infinite_cleave_on_headshot,
	},
	conditional_stat_buffs = {
		[stat_buffs.melee_weakspot_damage] = 0.5,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.pass_past_armor_on_crit = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.melee_critical_strike_damage] = 0.025,
	},
	conditional_keywords = {
		keywords.use_reduced_hit_mass,
		keywords.ignore_armor_aborts_attack,
	},
	start_func = function (template_data, template_context)
		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")

		template_data.critical_strike_component = unit_data_extension:read_component("critical_strike")
	end,
	conditional_stat_buffs_func = ConditionalFunctions.all(ConditionalFunctions.is_item_slot_wielded, function (template_data, template_context)
		return template_data.critical_strike_component.is_active
	end),
}
base_templates.rending_on_multiple_hits_parent = {
	allow_proc_while_active = true,
	child_buff_template = "rending_on_multiple_hits_child",
	child_duration = 2.5,
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 5,
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_finish] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1,
	},
	buff_data = {
		required_num_hits = 2,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	specific_check_proc_funcs = {
		on_sweep_start = function (params, template_data, template_context)
			template_data.can_activate = true
		end,
		on_hit = function (params, template_data, template_context)
			if not CheckProcFunctions.on_item_match(params, template_data, template_context) then
				return false
			end

			if not template_data.can_activate then
				return false
			end

			local is_multi = CheckProcFunctions.on_multiple_melee_hit(params, template_data, template_context)

			if is_multi then
				template_data.can_activate = false

				return true
			end

			return false
		end,
		on_sweep_finish = function (params, template_data, template_context)
			template_data.can_activate = false
		end,
	},
}
base_templates.rending_on_multiple_hits_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.rending_multiplier] = 0.05,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.staggered_targets_receive_increased_stagger_debuff = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	target_buff_data = {
		internal_buff_name = "increase_impact_received_while_staggered",
		max_stacks = 31,
		num_stacks_on_proc = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_stagger_hit),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc,
}
base_templates.staggered_targets_receive_increased_damage_debuff = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	target_buff_data = {
		internal_buff_name = "increase_damage_received_while_staggered",
		max_stacks = 31,
		num_stacks_on_proc = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_stagger_hit),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc,
}
base_templates.electrocuted_targets_receive_increased_damage_debuff = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_chain_lightning_jump] = 1,
	},
	target_buff_data = {
		internal_buff_name = "increase_damage_received_while_electrocuted",
		max_stacks = 31,
		num_stacks_on_proc = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc,
}
base_templates.targets_receive_rending_debuff = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	target_buff_data = {
		internal_buff_name = "rending_debuff",
		max_stacks = 31,
		num_stacks_on_proc = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.attacked_unit_is_minion),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc,
}
base_templates.burned_targets_receive_rending_debuff = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_direct_flamer_hit] = 1,
	},
	target_buff_data = {
		internal_buff_name = "rending_burn_debuff",
		max_stacks = 31,
		num_stacks_on_proc = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.attacked_unit_is_minion,
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc,
}
base_templates.targets_receive_rending_debuff_on_charged_shots = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	target_buff_data = {
		internal_buff_name = "rending_debuff",
		max_stacks = 31,
		num_stacks_on_proc = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.attacked_unit_is_minion),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc,
	num_stacks_on_proc_func = function (t, params, template_data, template_context)
		local template_override_data = template_context.template_override_data
		local target_buff_data = template_override_data.target_buff_data
		local threshold_num_stacks_on_proc = target_buff_data.threshold_num_stacks_on_proc
		local charge_level = params.charge_level
		local num_stacks
		local num_thresholds = #threshold_num_stacks_on_proc
		local lowest_segment = threshold_num_stacks_on_proc[1]
		local highest_segment = threshold_num_stacks_on_proc[num_thresholds]

		if charge_level < lowest_segment.threshold then
			num_stacks = lowest_segment.num_stacks
		elseif charge_level > highest_segment.threshold then
			num_stacks = highest_segment.num_stacks
		else
			local p1, p2 = 0, 0
			local segment_progress = 0

			for ii = 1, num_thresholds do
				local segment = threshold_num_stacks_on_proc[ii]
				local segment_threshold = segment.threshold

				if charge_level <= segment_threshold then
					p2 = segment.num_stacks
					segment_progress = segment_threshold == 0 and 1 or charge_level / segment_threshold

					break
				else
					local segment_num_stacks = segment.num_stacks

					p1 = segment_num_stacks
					p2 = segment_num_stacks
				end
			end

			num_stacks = math.floor(math.lerp(p1, p2, segment_progress))
		end

		return num_stacks or 1
	end,
}
base_templates.targets_receive_increased_damage_debuff_on_weapon_special = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	target_buff_data = {
		internal_buff_name = "increase_damage_taken",
		max_stacks = 31,
		num_stacks_on_proc = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_melee_weapon_special_hit),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc,
}
base_templates.stacking_increase_impact_on_hit_parent = {
	allow_proc_while_active = true,
	child_buff_template = "stacking_increase_impact_on_hit_child",
	child_duration = 3.5,
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 5,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_item_match,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.stacking_increase_impact_on_hit_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.melee_impact_modifier] = 0.2,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.toughness_recovery_on_chained_attacks = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	toughness_fixed_percentage = 0.05,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		template_data.counter = 0
	end,
	proc_func = function (params, template_data, template_context)
		local active = params.num_hit_units > 0 and params.combo_count > 0
		local current_counter = template_data.counter

		if active then
			current_counter = current_counter + 1
		else
			current_counter = 1
		end

		template_data.counter = current_counter

		if current_counter > 1 then
			local toughness_extension = template_data.toughness_extension

			if not toughness_extension then
				local unit = template_context.unit

				toughness_extension = ScriptUnit.extension(unit, "toughness_system")
				template_data.toughness_extension = toughness_extension
			end

			local buff_template = template_context.template
			local override_data = template_context.template_override_data
			local fixed_percentage = override_data.toughness_fixed_percentage or buff_template.toughness_fixed_percentage
			local ignore_stat_buffs = true

			toughness_extension:recover_percentage_toughness(fixed_percentage, ignore_stat_buffs)
		end
	end,
}
base_templates.toughness_recovery_on_multiple_hits = {
	class_name = "proc_buff",
	cooldown_duration = 0.12,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	buff_data = {
		replenish_percentage = 0.5,
		required_num_hits = 3,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_multiple_melee_hit),
	proc_func = function (params, template_data, template_context, t)
		local template_override_data = template_context.template_override_data
		local buff_data = template_override_data and template_override_data.buff_data or template_data.buff_data
		local replenish_percentage = buff_data.replenish_percentage
		local unit = template_context.unit

		Toughness.replenish_percentage(unit, replenish_percentage, false)
	end,
}
base_templates.power_bonus_scaled_on_stamina = {
	class_name = "stepped_stat_buff",
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.1,
	},
	conditional_stepped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")

		template_data.stamina_read_component = unit_data_extension:read_component("stamina")
	end,
	min_max_step_func = function (template_data, template_context)
		return 0, 5
	end,
	bonus_step_func = function (template_data, template_context)
		local current_stamina_fraction = template_data.stamina_read_component.current_fraction
		local steps = math.floor((1 - current_stamina_fraction) / 0.2)

		return steps
	end,
}
base_templates.taunt_target_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.consecutive_hits_increases_stagger_parent = {
	allow_proc_while_active = true,
	child_buff_template = "consecutive_hits_increases_stagger_child",
	child_duration = 2,
	class_name = "weapon_trait_target_number_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 0,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_item_match,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	proc_func = _consecutive_hits_proc_func,
}
base_templates.consecutive_hits_increases_stagger_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.melee_impact_modifier] = 0.1,
		[stat_buffs.stagger_duration_multiplier] = 1.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.consecutive_hits_increases_ranged_power_parent = {
	allow_proc_while_active = true,
	child_buff_template = "consecutive_hits_increases_ranged_power_child",
	child_duration = 2,
	class_name = "weapon_trait_target_number_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 0,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_item_match,
	proc_func = _consecutive_hits_same_target_proc_func,
}
base_templates.consecutive_hits_increases_ranged_power_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.ranged_power_level_modifier] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.pass_trough_armor_on_weapon_special = {
	class_name = "buff",
	hide_icon_in_hud = true,
	predicted = false,
	conditional_keywords = {
		keywords.use_reduced_hit_mass,
		keywords.ignore_armor_aborts_attack,
	},
	conditional_stat_buffs = {
		[stat_buffs.melee_impact_modifier] = 0.05,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.increase_power_on_hit_parent = {
	allow_proc_while_active = true,
	child_buff_template = "increase_power_on_hit_child",
	child_duration = 3.5,
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 5,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_melee_hit),
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.increase_power_on_hit_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.melee_power_level_modifier] = 0.2,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.increase_power_on_kill_parent = {
	allow_proc_while_active = true,
	child_buff_template = "increase_power_on_kill_child",
	child_duration = 4.5,
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 5,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_melee_kill),
	add_child_proc_events = {
		[proc_events.on_kill] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.increase_power_on_kill_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.2,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.power_bonus_on_first_attack = {
	always_show_in_hud = true,
	class_name = "weapon_trait_proc_conditional_switch_buff",
	force_predicted_proc = true,
	no_power_duration = 5,
	predicted = false,
	show_in_hud_if_slot_is_wielded = true,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_melee_hit),
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()
		local template = template_context.template
		local template_override_data = template_context.template_override_data
		local duration = template_override_data and template_override_data.no_power_duration or template.no_power_duration

		template_data.no_power_duration = t + duration
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = unit and ScriptUnit.has_extension(unit, "unit_data_system")

		template_data.weapon_action_component = unit_data_extension and unit_data_extension:read_component("weapon_action")
		template_data.no_power_duration = 0
	end,
	update_func = function (template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		if t >= template_data.no_power_duration then
			template_context.stat_buff_index = 1
		else
			template_context.stat_buff_index = 2
		end
	end,
	conditional_switch_stat_buffs_func = function (template_data, template_context)
		return template_context.stat_buff_index
	end,
	conditional_switch_stat_buffs = {
		{
			[stat_buffs.melee_power_level_modifier] = 0.6,
		},
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_hud_data = {
		{
			force_negative_frame = false,
			is_active = true,
		},
		{
			force_negative_frame = false,
			is_active = false,
		},
	},
	duration_func = function (template_data, template_context)
		if template_context.stat_buff_index == 1 then
			return 1
		end

		local template = template_context.template
		local template_override_data = template_context.template_override_data
		local duration = template_override_data and template_override_data.no_power_duration or template.no_power_duration
		local t = FixedFrame.get_latest_fixed_time()
		local time_left = template_data.no_power_duration - t
		local percentage = math.clamp01(time_left / duration)

		return 1 - percentage
	end,
}
base_templates.rending_vs_staggered = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 1,
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.rending_vs_staggered_multiplier] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.guaranteed_melee_crit_after_crit_weakspot_kill = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	buff_data = {
		internal_buff_name = "guaranteed_melee_crit_after_crit_weakspot_kill_effect_percentage",
		num_stacks_on_proc = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	end,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_melee_crit_hit, CheckProcFunctions.on_weakspot_kill),
	proc_func = function (params, template_data, template_context)
		local template = template_context.template
		local buff_data = template.buff_data
		local template_override_data = template_context.template_override_data
		local override_buff_data = template_override_data.buff_data
		local internal_buff_name = override_buff_data and override_buff_data.internal_buff_name or buff_data.internal_buff_name
		local t = FixedFrame.get_latest_fixed_time()
		local item_slot_name = template_context.item_slot_name
		local template_name = template_context.template.name
		local num_stacks = override_buff_data and override_buff_data.num_stacks_on_proc or buff_data.num_stacks_on_proc

		template_data.buff_extension:add_internally_controlled_buff_with_stacks(internal_buff_name, num_stacks, t, "item_slot_name", item_slot_name, "parent_buff_template", template_name)
	end,
}
base_templates.guaranteed_melee_crit_after_crit_weakspot_kill_effect = {
	class_name = "proc_buff",
	duration = 5,
	max_stacks = 1,
	predicted = false,
	keywords = {
		keywords.guaranteed_melee_critical_strike,
	},
	proc_events = {
		[proc_events.on_critical_strike] = 1,
	},
	proc_func = function (params, template_data, template_context)
		template_data.finish = true
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish
	end,
}
base_templates.guaranteed_melee_crit_after_crit_weakspot_kill_effect_percentage = {
	class_name = "proc_buff",
	duration = 5,
	max_stacks = 10,
	predicted = false,
	stat_buffs = {
		[stat_buffs.melee_critical_strike_chance] = 0.1,
	},
	proc_events = {
		[proc_events.on_sweep_start] = 1,
	},
	proc_func = function (params, template_data, template_context)
		template_data.finish = true
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish
	end,
}
base_templates.guaranteed_melee_crit_on_activated_kill = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	buff_data = {
		internal_buff_name = "guaranteed_melee_crit_on_activated_kill_effect_percentage",
		num_stacks_on_proc = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	end,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_weapon_special_kill),
	proc_func = function (params, template_data, template_context)
		local template = template_context.template
		local buff_data = template.buff_data
		local template_override_data = template_context.template_override_data
		local override_buff_data = template_override_data.buff_data
		local internal_buff_name = override_buff_data and override_buff_data.internal_buff_name or buff_data.internal_buff_name
		local num_stacks = override_buff_data and override_buff_data.num_stacks_on_proc or buff_data.num_stacks_on_proc
		local t = FixedFrame.get_latest_fixed_time()
		local item_slot_name = template_context.item_slot_name
		local template_name = template_context.template.name

		template_data.buff_extension:add_internally_controlled_buff_with_stacks(internal_buff_name, num_stacks, t, "item_slot_name", item_slot_name, "parent_buff_template", template_name)
	end,
}
base_templates.guaranteed_melee_crit_on_activated_kill_effect = {
	class_name = "proc_buff",
	duration = 5,
	max_stacks = 1,
	predicted = false,
	keywords = {
		keywords.guaranteed_melee_critical_strike,
	},
	proc_events = {
		[proc_events.on_critical_strike] = 1,
	},
	proc_func = function (params, template_data, template_context)
		template_data.finish = true
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish
	end,
}
base_templates.guaranteed_melee_crit_on_activated_kill_effect_percentage = {
	class_name = "proc_buff",
	duration = 5,
	max_stacks = 10,
	predicted = false,
	stat_buffs = {
		[stat_buffs.melee_critical_strike_chance] = 0.1,
	},
	proc_events = {
		[proc_events.on_sweep_start] = 1,
	},
	proc_func = function (params, template_data, template_context)
		template_data.finish = true
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish
	end,
}
base_templates.bleed_on_activated_hit = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	target_buff_data = {
		internal_buff_name = "bleed",
		max_stacks = 31,
		num_stacks_on_proc = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_melee_weapon_special_hit),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc,
}
base_templates.movement_speed_on_activation = {
	active_duration = 2,
	class_name = "proc_buff",
	force_predicted_proc = true,
	predicted = false,
	proc_events = {
		[proc_events.on_weapon_special] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.movement_speed] = 0.5,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.targets_receive_rending_debuff_on_weapon_special_attacks = table.clone(base_templates.targets_receive_rending_debuff)
base_templates.targets_receive_rending_debuff_on_weapon_special_attacks.check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.is_weapon_special)
base_templates.pass_past_armor_on_weapon_special = {
	class_name = "buff",
	predicted = false,
	conditional_keywords = {
		keywords.use_reduced_hit_mass,
		keywords.ignore_armor_aborts_attack,
	},
	conditional_stat_buffs = {
		[stat_buffs.melee_heavy_damage] = 0.05,
	},
	conditional_stat_buffs_func = ConditionalFunctions.all(ConditionalFunctions.is_item_slot_wielded, ConditionalFunctions.melee_weapon_special_active),
}
base_templates.extra_explosion_on_activated_attacks_on_armor = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.weapon_special_max_activations] = 1,
		[stat_buffs.explosion_radius_modifier] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.all(ConditionalFunctions.is_item_slot_wielded, ConditionalFunctions.melee_weapon_special_active),
}
base_templates.toughness_regen_on_weapon_special_elites = {
	active_duration = 2,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.toughness_extra_regen_rate] = 0.1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_elite_hit, CheckProcFunctions.on_melee_weapon_special_hit),
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")
	end,
	proc_func = function (params, template_data, template_context)
		local toughness_extension = template_data.toughness_extension

		if toughness_extension and template_context.is_server then
			toughness_extension:set_toughness_regen_delay()
		end
	end,
}
base_templates.extended_activation_duration_on_chained_attacks = {
	class_name = "stepped_stat_buff",
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.weapon_special_max_activations] = 1,
	},
	conditional_stepped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.all(ConditionalFunctions.is_item_slot_wielded, function (template_data, template_context)
		local inventory_slot_component = template_data.inventory_slot_component
		local special_active = inventory_slot_component.special_active

		return special_active
	end),
	buff_data = {
		extra_hits_max = 2,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = unit and ScriptUnit.has_extension(unit, "unit_data_system")

		template_data.shooting_status_component = unit_data_extension and unit_data_extension:read_component("shooting_status")
		template_data.weapon_action_component = unit_data_extension and unit_data_extension:read_component("weapon_action")
		template_data.weapon_action_component = unit_data_extension and unit_data_extension:read_component("weapon_action")

		local item_slot_name = template_context.item_slot_name

		template_data.inventory_slot_component = unit_data_extension and unit_data_extension:read_component(item_slot_name)
	end,
	min_max_step_func = function (template_data, template_context)
		local template = template_context.template
		local buff_data = template.buff_data
		local template_override_data = template_context.template_override_data
		local override_buff_data = template_override_data and template_override_data.buff_data
		local extra_hits_max = override_buff_data and override_buff_data.extra_hits_max or buff_data.extra_hits_max or 1

		return 0, extra_hits_max
	end,
	bonus_step_func = function (template_data, template_context)
		local weapon_action_component = template_data.weapon_action_component
		local combo_count = weapon_action_component.combo_count

		return combo_count
	end,
}

local windup_increases_power_valid_actions = {
	character_state_change = true,
	sweep = true,
	targeted_dash_aim = true,
}

base_templates.windup_increases_power_parent = {
	allow_proc_while_active = true,
	child_buff_template = "windup_increases_power_child",
	class_name = "weapon_trait_parent_proc_buff",
	max_stacks = 3,
	predicted = false,
	show_in_hud_if_slot_is_wielded = true,
	stack_offset = -1,
	stacks_to_remove = 3,
	proc_events = {
		[proc_events.on_windup_trigger] = 1,
		[proc_events.on_sweep_finish] = 1,
		[proc_events.on_action_start] = 1,
		[proc_events.on_wield] = 1,
	},
	specific_check_proc_funcs = {
		[proc_events.on_windup_trigger] = function (params, template_data, template_context)
			return ConditionalFunctions.is_item_slot_wielded(template_data, template_context)
		end,
		[proc_events.on_action_start] = function (params, template_data, template_context)
			local action_settings = params.action_settings
			local kind = action_settings.kind

			return not windup_increases_power_valid_actions[kind]
		end,
	},
	add_child_proc_events = {
		[proc_events.on_windup_trigger] = 1,
	},
	clear_child_stacks_proc_events = {
		[proc_events.on_sweep_finish] = true,
		[proc_events.on_action_start] = true,
		[proc_events.on_wield] = true,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.windup_increases_power_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 3,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.melee_power_level_modifier] = 0.5,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.hipfire_while_sprinting = {
	class_name = "buff",
	predicted = false,
	keywords = {
		keywords.allow_hipfire_during_sprint,
	},
	stat_buffs = {
		[stat_buffs.spread_modifier] = -0.3,
	},
	conditional_stat_buffs = {
		[stat_buffs.damage_near] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.all(ConditionalFunctions.is_item_slot_wielded, ConditionalFunctions.is_sprinting),
	conditional_keyword_func = ConditionalFunctions.is_item_slot_wielded,
	check_active_func = ConditionalFunctions.all(ConditionalFunctions.is_item_slot_wielded, ConditionalFunctions.is_sprinting),
}
base_templates.increase_power_on_close_kill_parent = {
	allow_proc_while_active = true,
	child_buff_template = "increase_power_on_close_kill_child",
	child_duration = 1,
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 5,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_ranged_close_kill),
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.increase_power_on_close_kill_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.01,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.increase_damage_on_close_kill_parent = {
	allow_proc_while_active = true,
	child_buff_template = "increase_damage_on_close_kill_child",
	child_duration = 1,
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 5,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_ranged_close_kill),
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.increase_damage_on_close_kill_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.damage] = 0.01,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.increase_close_damage_on_close_kill_parent = {
	allow_proc_while_active = true,
	child_buff_template = "increase_close_damage_on_close_kill_child",
	child_duration = 1,
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 5,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_ranged_close_kill),
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.increase_close_damage_on_close_kill_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.damage_near] = 0.01,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.suppression_on_close_kill = {
	active_duration = 1.5,
	class_name = "proc_buff",
	cooldown_duration = 0,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_ranged_close_kill),
	proc_func = function (params, template_data, template_context)
		local template_override_data = template_context.template_override_data
		local suppression_settings = template_override_data.suppression_settings
		local attacking_unit = params.attacking_unit
		local from_position = POSITION_LOOKUP[attacking_unit] or Unit.world_position(attacking_unit, 1)

		Suppression.apply_area_minion_suppression(attacking_unit, suppression_settings, from_position)
	end,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.count_as_dodge_vs_ranged_on_close_kill = {
	active_duration = 2,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_keywords = {
		keywords.count_as_dodge_vs_ranged,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_ranged_close_kill),
}
base_templates.toughness_recovery_on_close_kill = {
	active_duration = 2,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	toughness_fixed_percentage = 0.02,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_ranged_close_kill),
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	proc_func = SharedBuffFunctions.regain_toughness_proc_func,
}
base_templates.reload_speed_on_slide = {
	active_duration = 2,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_slide_start] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.reload_speed] = 0.5,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.reload_speed_on_close_kill_parent = {
	allow_proc_while_active = true,
	child_buff_template = "reload_speed_on_close_kill_child",
	child_duration = 1,
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 5,
	add_child_proc_events = {
		[proc_events.on_kill] = 1,
	},
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_ranged_close_kill),
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.reload_speed_on_close_kill_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	stat_buffs = {
		[stat_buffs.reload_speed] = 0.1,
	},
}
base_templates.allow_flanking_and_increased_damage_when_flanking = {
	class_name = "buff",
	hide_icon_in_hud = true,
	predicted = false,
	conditional_keywords = {
		keywords.allow_flanking,
	},
	conditional_stat_buffs = {
		[stat_buffs.flanking_damage] = 0.5,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.power_bonus_on_hitting_single_enemy_with_all = {
	active_duration = 5,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_shoot] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.05,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_hit_all_pellets_on_same,
}
base_templates.increased_sprint_speed = {
	class_name = "proc_buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.sprint_movement_speed] = 0.05,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	check_active_func = ConditionalFunctions.all(ConditionalFunctions.is_item_slot_wielded, ConditionalFunctions.is_sprinting),
}
base_templates.count_as_dodge_vs_ranged_while_sprinting = {
	class_name = "buff",
	predicted = false,
	conditional_keywords = {
		keywords.count_as_dodge_vs_ranged,
	},
	conditional_stat_buffs_func = ConditionalFunctions.all(ConditionalFunctions.is_item_slot_wielded, ConditionalFunctions.is_sprinting, ConditionalFunctions.has_stamina),
	conditional_keywords_func = ConditionalFunctions.all(ConditionalFunctions.is_item_slot_wielded, ConditionalFunctions.is_sprinting, ConditionalFunctions.has_stamina),
	check_active_func = ConditionalFunctions.all(ConditionalFunctions.is_item_slot_wielded, ConditionalFunctions.is_sprinting, ConditionalFunctions.has_stamina),
}
base_templates.crit_chance_bonus_on_melee_kills = {
	active_duration = 2,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.ranged_critical_strike_chance] = 0.05,
	},
	check_proc_func = CheckProcFunctions.on_melee_kill,
}
base_templates.crit_chance_on_multiple_pellet_hit_parent = {
	child_buff_template = "crit_chance_on_multiple_pellet_hit_child",
	class_name = "weapon_trait_activated_parent_proc_buff",
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	stacks_to_remove = 5,
	start_func = function (template_data)
		template_data.hit_units = {}
		template_data.num_hit_units = 0
	end,
	proc_events = {
		[proc_events.on_shoot] = 1,
	},
	active_proc_func = {
		on_shoot = function (params)
			return true
		end,
	},
	add_child_proc_events = {
		[proc_events.on_shoot] = function (params, template_data)
			if params.num_hit_units and params.num_hit_units > 1 then
				return params.num_hit_units
			else
				return 0
			end
		end,
	},
	clear_child_stacks_proc_events = {
		[proc_events.on_action_start] = true,
	},
	specific_check_proc_funcs = {
		[proc_events.on_action_start] = function (params, template_data, template_context)
			local kind = params.action_settings.kind

			return kind == "shoot_pellets"
		end,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.crit_chance_on_multiple_pellet_hit_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.ranged_critical_strike_chance] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.recoil_reduction_and_suppression_increase_on_close_kills = {
	active_duration = 2,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.recoil_modifier] = -0.5,
		[stat_buffs.suppression_dealt] = 0.5,
		[stat_buffs.damage_vs_suppressed] = 0.2,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_ranged_close_kill),
}
base_templates.power_bonus_on_first_shot = {
	always_show_in_hud = true,
	class_name = "buff",
	predicted = false,
	show_in_hud_if_slot_is_wielded = true,
	conditional_stat_buffs = {
		[stat_buffs.ranged_power_level_modifier] = 0.02,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.shooting_status = unit_data_extension:read_component("shooting_status")
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return false
		end

		local num_shots_fired = template_data.shooting_status.num_shots

		if num_shots_fired == 0 then
			return true
		end

		return false
	end,
}

local function _follow_up_shots_start(template_data, template_context)
	local unit = template_context.unit
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	template_data.shooting_status_component = unit_data_extension and unit_data_extension:read_component("shooting_status")
end

local function _follow_up_shots_conditional_stat_buff_func(template_data, template_context)
	if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
		return false
	end

	local shooting_status_component = template_data.shooting_status_component
	local num_shots_fired = shooting_status_component.num_shots
	local is_follow_up_shots = num_shots_fired == 1 or num_shots_fired == 2 or num_shots_fired == 3

	return is_follow_up_shots
end

base_templates.followup_shots_ranged_damage = {
	always_show_in_hud = true,
	class_name = "buff",
	predicted = false,
	show_in_hud_if_slot_is_wielded = true,
	conditional_stat_buffs = {
		[stat_buffs.ranged_damage] = 0.2,
	},
	start_func = _follow_up_shots_start,
	conditional_stat_buffs_func = _follow_up_shots_conditional_stat_buff_func,
}
base_templates.followup_shots_ranged_weakspot_damage = {
	always_show_in_hud = true,
	class_name = "buff",
	predicted = false,
	show_in_hud_if_slot_is_wielded = true,
	conditional_stat_buffs = {
		[stat_buffs.ranged_weakspot_damage] = 0.2,
	},
	start_func = _follow_up_shots_start,
	conditional_stat_buffs_func = _follow_up_shots_conditional_stat_buff_func,
}
base_templates.consecutive_hits_increases_close_damage_parent = {
	allow_proc_while_active = true,
	child_buff_template = "consecutive_hits_increases_stagger_child",
	child_duration = 2,
	class_name = "weapon_trait_target_number_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 0,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_item_match,
	proc_func = _consecutive_hits_proc_func,
}
base_templates.consecutive_hits_increases_close_damage_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.damage_near] = 0.01,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.stagger_count_bonus_damage = {
	class_name = "buff",
	hide_icon_in_hud = true,
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.stagger_count_damage] = 0.5,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.stagger_bonus_damage = {
	class_name = "buff",
	hide_icon_in_hud = true,
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.damage_vs_staggered] = 0.2,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.infinite_cleave_on_crit = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 1,
	predicted = false,
	conditional_keywords = {
		keywords.critical_hit_infinite_cleave,
	},
	conditional_stat_buffs = {
		[stat_buffs.ranged_impact_modifier] = 0.05,
	},
	conditional_keywords_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.burninating_on_crit_ranged = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	target_buff_data = {
		internal_buff_name = "flamer_assault",
		max_stacks = 10,
		num_stacks_on_proc = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_crit_ranged, CheckProcFunctions.on_damaging_hit),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc,
}
base_templates.suppression_negation_on_weakspot = {
	active_duration = 1,
	class_name = "proc_buff",
	predicted = false,
	proc_keywords = {
		keywords.suppression_immune,
	},
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_weakspot_hit),
	proc_func = function (params, template_data, template_context)
		Suppression.clear_suppression(template_context.unit)
	end,
}
base_templates.count_as_dodge_vs_ranged_on_weakspot = {
	active_duration = 2,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_keywords = {
		keywords.count_as_dodge_vs_ranged,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_weakspot_hit),
}
base_templates.negate_stagger_reduction_on_weakspot = {
	class_name = "buff",
	hide_icon_in_hud = true,
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.stagger_weakspot_reduction_modifier] = 0.5,
		[stat_buffs.ranged_impact_modifier] = 0.3,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.stacking_crit_chance_on_weakspot_parent = {
	child_buff_template = "stacking_crit_chance_on_weakspot_child",
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 5,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_critical_strike] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1,
	},
	clear_child_stacks_proc_events = {
		[proc_events.on_critical_strike] = true,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	specific_check_proc_funcs = {
		[proc_events.on_hit] = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_weakspot_hit),
	},
}
base_templates.stacking_crit_chance_on_weakspot_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.5,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.crit_weakspot_finesse = {
	class_name = "buff",
	hide_icon_in_hud = true,
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_weakspot_damage] = 0.5,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.target_hit_mass_reduction_on_weakspot_hits = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit] = 0.5,
	},
}

local function _continuous_fire_start_func(template_data, template_context)
	local unit = template_context.unit
	local item_slot_name = template_context.item_slot_name
	local unit_data_extension = unit and ScriptUnit.has_extension(unit, "unit_data_system")

	template_data.shooting_status_component = unit_data_extension and unit_data_extension:read_component("shooting_status")
	template_data.weapon_action_component = unit_data_extension and unit_data_extension:read_component("weapon_action")
	template_data.inventory_slot_component = unit_data_extension and unit_data_extension:read_component(item_slot_name)
end

local function _get_number_of_continuous_fire_steps(template_data, template_context, uncapped_fire_steps)
	local template = template_context.template
	local use_combo = template.use_combo

	if not use_combo then
		local shooting_status_component = template_data.shooting_status_component
		local num_shots = shooting_status_component.num_shots
		local continuous_fire_step
		local continuous_fire_step_func = template.continuous_fire_step_func

		if continuous_fire_step_func then
			continuous_fire_step = continuous_fire_step_func(template_data, template_context)
		end

		continuous_fire_step = continuous_fire_step or template_context.template.continuous_fire_step or 1

		if continuous_fire_step == 0 then
			return 0
		end

		local steps = math.floor(num_shots / continuous_fire_step)

		if uncapped_fire_steps then
			return steps
		end

		steps = math.min(steps, 5)

		return steps
	else
		local shooting_status_component = template_data.weapon_action_component
		local combo_count = shooting_status_component.combo_count

		if uncapped_fire_steps then
			return combo_count
		end

		combo_count = math.min(combo_count, 5)

		return combo_count
	end
end

base_templates.conditional_buff_on_continuous_fire = {
	class_name = "stepped_stat_buff",
	max_stacks = 1,
	predicted = false,
	start_func = _continuous_fire_start_func,
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return false
		end

		local number_of_steps = _get_number_of_continuous_fire_steps(template_data, template_context)

		return number_of_steps > 0
	end,
}
base_templates.stacking_buff_on_continuous_fire = {
	class_name = "stepped_stat_buff",
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	conditional_stepped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = _continuous_fire_start_func,
	min_max_step_func = function (template_data, template_context)
		return 0, 5
	end,
	bonus_step_func = _get_number_of_continuous_fire_steps,
}
base_templates.stacking_buff_on_continuous_alternative_fire = {
	class_name = "stepped_stat_buff",
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	conditional_stepped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_alternative_fire,
	start_func = _continuous_fire_start_func,
	min_max_step_func = function (template_data, template_context)
		return 0, 5
	end,
	bonus_step_func = _get_number_of_continuous_fire_steps,
}
base_templates.toughness_on_continuous_fire = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_always_show_stacks = true,
	predicted = false,
	show_in_hud_if_slot_is_wielded = true,
	proc_events = {
		[proc_events.on_ammo_consumed] = 1,
		[proc_events.on_shoot_finish] = 1,
	},
	start_func = _continuous_fire_start_func,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	specific_check_proc_funcs = {
		[proc_events.on_ammo_consumed] = function (params, template_data, template_context, t)
			local current_num_fire_steps = template_data.num_fire_steps or 0
			local uncapped_fire_steps = true
			local num_fire_steps = _get_number_of_continuous_fire_steps(template_data, template_context, uncapped_fire_steps)
			local give_the_thing

			give_the_thing = template_context.template.use_combo and num_fire_steps == NetworkConstants.action_combo_count.max and true or current_num_fire_steps < num_fire_steps
			template_data.num_fire_steps = num_fire_steps

			return give_the_thing
		end,
		[proc_events.on_shoot_finish] = function (params, template_data, template_context, t)
			return true
		end,
	},
	specific_proc_func = {
		on_ammo_consumed = function (params, template_data, template_context)
			local num_fire_steps = template_data.num_fire_steps or 0

			template_data.toughness_regain_multiplier = math.min(num_fire_steps, 5)

			SharedBuffFunctions.regain_toughness_proc_func(params, template_data, template_context)
		end,
		on_shoot_finish = function (params, template_data, template_context)
			return
		end,
	},
	visual_stack_count = function (template_data, template_context)
		return _get_number_of_continuous_fire_steps(template_data, template_context) or 0
	end,
}
base_templates.bleed_on_ranged = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	target_buff_data = {
		internal_buff_name = "bleed",
		max_stacks = 31,
		num_stacks_on_proc = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_ranged_hit),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc,
}
base_templates.bleed_on_crit_ranged = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	target_buff_data = {
		internal_buff_name = "bleed",
		max_stacks = 31,
		num_stacks_on_proc = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_ranged_crit_hit),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc,
}
base_templates.bleed_on_crit_pellets = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_pellet_hits] = 1,
	},
	target_buff_data = {
		internal_buff_name = "bleed",
		max_stacks = 31,
		num_stacks_on_proc = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_crit),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc,
}
base_templates.stacking_power_bonus_on_staggering_enemies_parent = {
	child_buff_template = "stacking_power_bonus_on_staggering_enemies_child",
	child_duration = 2.5,
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 5,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_staggering_hit),
}
base_templates.stacking_power_bonus_on_staggering_enemies_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.toughness_on_crit_kills = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	toughness_fixed_percentage = 0.05,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_crit_kills),
	proc_func = SharedBuffFunctions.regain_toughness_proc_func,
}
base_templates.warpcharge_stepped_bonus = {
	class_name = "stepped_stat_buff",
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	conditional_stepped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = unit and ScriptUnit.has_extension(unit, "unit_data_system")
		local warp_charge_component = unit_data_extension and unit_data_extension:read_component("warp_charge")

		template_data.warp_charge_component = warp_charge_component
	end,
	min_max_step_func = function (template_data, template_context)
		return 0, 4
	end,
	bonus_step_func = function (template_data, template_context)
		local warp_charge_component = template_data.warp_charge_component
		local current_warp_charge = warp_charge_component and warp_charge_component.current_percentage or 0
		local extra_steps = current_warp_charge and math.floor(current_warp_charge / 0.2) or 0

		return extra_steps
	end,
}
base_templates.faster_charge_on_chained_secondary_attacks = {
	class_name = "stepped_stat_buff",
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.charge_up_time] = -0.04,
	},
	charge_actions = {
		action_charge_explosion = true,
		action_trigger_explosion = true,
	},
	conditional_stepped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = unit and ScriptUnit.has_extension(unit, "unit_data_system")

		template_data.weapon_action_component = unit_data_extension and unit_data_extension:read_component("weapon_action")
	end,
	min_max_step_func = function (template_data, template_context)
		return 0, 5
	end,
	bonus_step_func = function (template_data, template_context)
		local charge_actions = template_context.template.charge_actions
		local weapon_action_component = template_data.weapon_action_component
		local current_action_name = weapon_action_component.current_action_name

		if charge_actions[current_action_name] then
			local combo_count = weapon_action_component.combo_count
			local steps_semi = math.floor(combo_count)

			return steps_semi
		end

		return 0
	end,
}
base_templates.faster_charge_on_chained_secondary_attacks_parent = {
	base_child_buff_template = "faster_charge_on_chained_secondary_attacks_child",
	child_duration = 5,
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 3,
	proc_events = {
		[proc_events.on_action_start] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_action_start] = 1,
	},
	charge_actions = {
		action_charge_explosion = true,
		action_trigger_explosion = true,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = unit and ScriptUnit.has_extension(unit, "unit_data_system")

		template_data.weapon_action_component = unit_data_extension and unit_data_extension:read_component("weapon_action")
	end,
	specific_check_proc_funcs = {
		[proc_events.on_action_start] = function (params, template_data, template_context)
			local action_settings = params.action_settings
			local kind = action_settings.kind
			local is_sweep = kind == "sweep"

			return not is_sweep
		end,
	},
}
base_templates.faster_charge_on_chained_secondary_attacks_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 3,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.charge_up_time] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.vents_warpcharge_on_weakspot_hits = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	vent_percentage = 0.05,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = SharedBuffFunctions.vent_warp_charge_start_func,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_weakspot_hit),
	proc_func = SharedBuffFunctions.vent_warp_charge_proc_func,
	update_func = SharedBuffFunctions.vent_warp_charge_update_func,
}
base_templates.warpfire_on_crits_ranged = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	target_buff_data = {
		internal_buff_name = "warp_fire",
		max_stacks = 6,
		num_stacks_on_proc = 2,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_ranged_crit_hit, CheckProcFunctions.on_damaging_hit),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc,
}
base_templates.warpfire_on_crits_melee = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	target_buff_data = {
		allow_weapon_special = true,
		internal_buff_name = "warp_fire",
		max_stacks = 6,
		num_stacks_on_proc = 2,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_melee_crit_hit, CheckProcFunctions.on_damaging_hit),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc,
}
base_templates.double_shot_on_crit = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 1,
	predicted = false,
	conditional_keywords = {
		keywords.critical_strike_second_projectile,
	},
	conditional_stat_buffs = {
		[stat_buffs.ranged_critical_strike_chance] = 0.05,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.uninterruptable_while_charging = {
	class_name = "buff",
	max_num_stacks = 6,
	max_stacks = 1,
	predicted = false,
	conditional_keywords = {
		keywords.uninterruptible,
		keywords.stun_immune,
	},
	conditional_stat_buffs = {
		[stat_buffs.charge_movement_reduction_multiplier] = 0.9,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local weapon_action_component = unit_data_extension:read_component("weapon_action")

		template_data.weapon_action_component = weapon_action_component
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local uninteruptable_actions = template_context.template.uninteruptable_actions
		local weapon_action_component = template_data.weapon_action_component
		local current_action_name = weapon_action_component.current_action_name

		return uninteruptable_actions[current_action_name] and ConditionalFunctions.is_item_slot_wielded(template_data, template_context)
	end,
}
base_templates.stacking_buff_on_charge_level = {
	class_name = "stepped_stat_buff",
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	conditional_stepped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = unit and ScriptUnit.has_extension(unit, "unit_data_system")
		local action_module_charge_component = unit_data_extension and unit_data_extension:read_component("action_module_charge")

		template_data.action_module_charge_component = action_module_charge_component
	end,
	min_max_step_func = function (template_data, template_context)
		return 0, 5
	end,
	bonus_step_func = function (template_data, template_context)
		local action_module_charge_component = template_data.action_module_charge_component
		local current_charge_level = action_module_charge_component and action_module_charge_component.charge_level or 0
		local extra_steps = current_charge_level and math.floor(current_charge_level / 0.2) or 0

		return extra_steps
	end,
}
base_templates.stacking_rending_on_weakspot_parent = {
	base_child_buff_template = "stacking_rending_on_weakspot_child",
	child_duration = 3.5,
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 5,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_weakspot_hit),
}
base_templates.stacking_rending_on_weakspot_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.rending_multiplier] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.dodge_grants_finesse_bonus = {
	active_duration = 5,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_successful_dodge] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.finesse_modifier_bonus] = 0.05,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.dodge_grants_critical_strike_chance = {
	active_duration = 6,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_successful_dodge] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.05,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.bleed_on_crit_melee = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	target_buff_data = {
		allow_weapon_special = true,
		internal_buff_name = "bleed",
		max_stacks = 31,
		num_stacks_on_proc = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_melee_crit_hit),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc,
}
base_templates.bleed_on_non_weakspot_hit_melee = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	target_buff_data = {
		internal_buff_name = "bleed",
		max_stacks = 31,
		num_stacks_on_proc = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_non_weakspot_hit_melee),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc,
}
base_templates.rending_on_backstab = {
	class_name = "buff",
	hide_icon_in_hud = true,
	predicted = false,
	keywords = {
		keywords.allow_backstabbing,
	},
	conditional_stat_buffs = {
		[stat_buffs.backstab_rending_multiplier] = 1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.increased_weakspot_damage_against_bleeding = {
	class_name = "buff",
	hide_icon_in_hud = true,
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.melee_weakspot_damage_vs_bleeding] = 1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.increased_crit_chance_on_staggered_weapon_special_hit_parent = {
	allow_proc_while_active = true,
	child_buff_template = "increased_crit_chance_on_staggered_weapon_special_hit_child",
	child_duration = 4.5,
	class_name = "weapon_trait_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 2,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_weapon_special_melee_stagger_hit),
}
base_templates.increased_crit_chance_on_staggered_weapon_special_hit_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.increased_crit_chance_on_weapon_special_hit = {
	active_duration = 3,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_melee_weapon_special_hit),
}
base_templates.consecutive_melee_hits_increases_melee_power_parent = {
	allow_proc_while_active = true,
	child_buff_template = "consecutive_melee_hits_increases_melee_power_child",
	child_duration = 2,
	class_name = "weapon_trait_target_number_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 0,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_item_match,
	proc_func = _consecutive_hits_proc_func,
}
base_templates.consecutive_melee_hits_increases_melee_power_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.melee_power_level_modifier] = 0.01,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.consecutive_melee_hits_same_target_increases_melee_power_parent = {
	allow_proc_while_active = true,
	child_buff_template = "consecutive_melee_hits_same_target_increases_melee_power_child",
	child_duration = 2,
	class_name = "weapon_trait_target_number_parent_proc_buff",
	predicted = false,
	stacks_to_remove = 0,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_item_match,
	proc_func = _consecutive_hits_same_target_proc_func,
}
base_templates.consecutive_melee_hits_same_target_increases_melee_power_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.melee_power_level_modifier] = 0.01,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.weakspot_hit_resets_dodge_count = {
	class_name = "proc_buff",
	force_predicted_proc = true,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_melee_hit, CheckProcFunctions.on_weakspot_hit),
	conditional_stat_buffs = {
		[stat_buffs.melee_weakspot_damage] = 0.025,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

		template_data.dodge_write_component = unit_data_extension:write_component("dodge_character_state")
	end,
	proc_func = function (params, template_data, template_context)
		local dodge_write_component = template_data.dodge_write_component

		dodge_write_component.consecutive_dodges = 0
	end,
}
base_templates.toughness_on_elite_kills = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	toughness_fixed_percentage = 0.05,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_item_match, CheckProcFunctions.on_elite_kill),
	proc_func = SharedBuffFunctions.regain_toughness_proc_func,
}
base_templates.rending_on_crit = {
	class_name = "buff",
	hide_icon_in_hud = true,
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_rending_multiplier] = 1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
base_templates.chance_based_on_aim_time = {
	class_name = "stepped_stat_buff",
	duration_per_stack = 1,
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.05,
	},
	conditional_stepped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = unit and ScriptUnit.has_extension(unit, "unit_data_system")

		template_data.alternate_fire_component = unit_data_extension and unit_data_extension:read_component("alternate_fire")
		template_data.action_shoot_component = unit_data_extension and unit_data_extension:read_component("action_shoot")
	end,
	min_max_step_func = function (template_data, template_context)
		return 0, 10
	end,
	bonus_step_func = function (template_data, template_context)
		local alternate_fire_component = template_data.alternate_fire_component
		local is_aiming = alternate_fire_component.is_active

		if not is_aiming then
			return 0
		end

		local alternate_fire_time = alternate_fire_component.start_t
		local action_shoot_component = template_data.action_shoot_component
		local last_shoot_time = action_shoot_component.fire_last_t
		local check_time = math.max(alternate_fire_time, last_shoot_time)
		local t = FixedFrame.get_latest_fixed_time()
		local time_lapsed = t - check_time
		local template = template_context.template
		local override_data = template_context.template_override_data
		local duration_per_stack = override_data.duration_per_stack or template.duration_per_stack
		local steps = math.floor(time_lapsed / duration_per_stack)

		return steps
	end,
}
base_templates.crit_chance_based_on_ammo_left = {
	class_name = "stepped_stat_buff",
	hud_always_show_stacks = true,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.ranged_critical_strike_chance] = 0.05,
	},
	conditional_stepped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local item_slot_name = template_context.item_slot_name
		local unit = template_context.unit
		local unit_data_extension = unit and ScriptUnit.has_extension(unit, "unit_data_system")

		template_data.inventory_slot_component = unit_data_extension and unit_data_extension:read_component(item_slot_name)
	end,
	min_max_step_func = function (template_data, template_context)
		return 0, 100
	end,
	bonus_step_func = function (template_data, template_context)
		if ConditionalFunctions.is_reloading(template_data, template_context) then
			return 0
		end

		local inventory_slot_component = template_data.inventory_slot_component
		local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
		local max_ammunition_clip = inventory_slot_component.max_ammunition_clip
		local missing_in_clip = max_ammunition_clip - current_ammunition_clip

		if missing_in_clip == max_ammunition_clip then
			return 0
		end

		return missing_in_clip
	end,
}
base_templates.sticky_projectiles = {
	class_name = "buff",
	hide_icon_in_hud = true,
	predicted = false,
	keywords = {
		keywords.sticky_projectiles,
	},
}
base_templates.chance_to_explode_elites_on_kill = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = function (params, template_data, template_context)
		if not CheckProcFunctions.on_item_match(params, template_data, template_context) then
			return false
		end

		local template = template_context.template
		local proc_data = template.proc_data
		local target_unit = params.attacked_unit
		local breed_name = params.breed_name
		local breed = Breeds[breed_name]
		local is_elite = breed and breed.tags and (breed.tags.elite or breed.tags.special)

		if not is_elite then
			return false
		end

		local target_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

		if not target_buff_extension then
			return false
		end

		local attacking_unit_is_me = params.attacking_unit == template_context.unit
		local valid_keyword = target_buff_extension:has_any_keyword(proc_data.validation_keywords) or params.damage_type and params.damage_type == DamageSettings.damage_types.burning and attacking_unit_is_me

		if not valid_keyword then
			return false
		end

		local is_source_player = attacking_unit_is_me or target_buff_extension:has_buff_id_with_owner(proc_data.fire_buff_id, template_context.unit)

		if not is_source_player then
			return false
		end

		return true
	end,
	proc_func = function (params, template_data, template_context)
		local dying_unit = params.attacked_unit
		local explosion_position = HitZone.hit_zone_center_of_mass(dying_unit, HitZone.hit_zone_names.center_mass, false) + Vector3.up() * 0.01
		local explosion_template = template_context.template.proc_data.explosion_template

		Explosion.create_explosion(template_context.world, template_context.physics_world, explosion_position, Vector3.up(), template_context.unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion)
	end,
}
base_templates.faster_reload_on_empty_clip = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.reload_speed] = 1.5,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return ConditionalFunctions.is_item_slot_wielded(template_data, template_context) and ConditionalFunctions.has_empty_clip(template_data, template_context)
	end,
}
base_templates.power_scales_with_clip_percentage = {
	class_name = "stepped_stat_buff",
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.ranged_power_level_modifier] = 0.05,
	},
	conditional_stepped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	min_max_step_func = function (template_data, template_context)
		return 0, 5
	end,
	bonus_step_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")
		local wielded_slot = inventory_component.wielded_slot

		if wielded_slot == "none" or not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return 0
		end

		local wielded_slot_configuration = slot_configuration[wielded_slot]
		local slot_type = wielded_slot_configuration and wielded_slot_configuration.slot_type

		if slot_type == "weapon" then
			local slot_inventory_component = unit_data_extension:read_component(wielded_slot)
			local current_ammunition_clip = slot_inventory_component.current_ammunition_clip
			local max_ammunition_clip = slot_inventory_component.max_ammunition_clip
			local percentage = current_ammunition_clip / max_ammunition_clip

			percentage = 1 - (percentage - 0.1) / 0.9

			local steps = math.floor(percentage * 5)

			steps = math.clamp(steps, 0, 5)

			return steps
		end

		return 0
	end,
}
base_templates.move_ammo_from_reserve_to_clip_on_crit = {
	class_name = "proc_buff",
	force_predicted_proc = true,
	num_ammmo_to_move = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_critical_strike] = 1,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local item_slot_name = template_context.item_slot_name
		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")

		template_data.inventory_slot_component = unit_data_extension:write_component(item_slot_name)
	end,
	proc_func = function (params, template_data, template_context)
		local inventory_slot_component = template_data.inventory_slot_component
		local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
		local current_ammunition_reserve = inventory_slot_component.current_ammunition_reserve
		local max_ammunition_clip = inventory_slot_component.max_ammunition_clip
		local override_data = template_context.template_override_data
		local total_ammo_to_move = override_data and override_data.num_ammmo_to_move or template_context.template.num_ammmo_to_move
		local number_of_bullets_missing_from_clip = max_ammunition_clip - current_ammunition_clip

		total_ammo_to_move = math.min(total_ammo_to_move, number_of_bullets_missing_from_clip, current_ammunition_reserve)
		inventory_slot_component.current_ammunition_clip = current_ammunition_clip + total_ammo_to_move
		inventory_slot_component.current_ammunition_reserve = current_ammunition_reserve - total_ammo_to_move
	end,
}
base_templates.can_block_ranged = {
	class_name = "buff",
	predicted = false,
	conditional_keywords = {
		keywords.can_block_ranged,
	},
	conditional_stat_buffs = {
		[stat_buffs.block_cost_ranged_multiplier] = 1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	check_active_func = ConditionalFunctions.all(ConditionalFunctions.is_item_slot_wielded, ConditionalFunctions.is_blocking),
}

return base_templates
