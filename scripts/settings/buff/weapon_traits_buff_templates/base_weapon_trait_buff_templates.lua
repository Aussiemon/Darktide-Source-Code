local Action = require("scripts/utilities/weapon/action")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breeds = require("scripts/settings/breed/breeds")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local Explosion = require("scripts/utilities/attack/explosion")
local FixedFrame = require("scripts/utilities/fixed_frame")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local Suppression = require("scripts/utilities/attack/suppression")
local Toughness = require("scripts/utilities/toughness/toughness")
local WarpCharge = require("scripts/utilities/warp_charge")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local attack_types = AttackSettings.attack_types
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local stat_buffs = BuffSettings.stat_buffs
local slot_configuration = PlayerCharacterConstants.slot_configuration

local function _regain_toughness_proc_func(params, template_data, template_context)
	local toughness_extension = template_data.toughness_extension

	if not toughness_extension then
		local unit = template_context.unit
		toughness_extension = ScriptUnit.extension(unit, "toughness_system")
		template_data.toughness_extension = toughness_extension
	end

	local buff_template = template_context.template
	local override_data = template_context.template_override_data
	local multiplier = template_data.toughness_regain_multiplier or 1
	local fixed_percentage = (override_data.toughness_fixed_percentage or buff_template.toughness_fixed_percentage) * multiplier
	local ignore_stat_buffs = true

	toughness_extension:recover_percentage_toughness(fixed_percentage, ignore_stat_buffs)
end

local DEFAULT_NUMBER_OF_HITS_PER_STACK = 1

local function _consecutive_hits_proc_func(params, template_data, template_context, t)
	if template_data.attacked_unit ~= params.attacked_unit then
		template_data.attacked_unit = params.attacked_unit
		template_data.number_of_hits = 0
		template_data.target_number_of_stacks = 0
	else
		local max_stacks = 5
		local number_of_hits = template_data.number_of_hits + 1
		template_data.number_of_hits = number_of_hits
		local template = template_context.template
		local override = template_context.templte_override_data
		local number_of_hits_per_stack = override and override.number_of_hits_per_stack or template.number_of_hits_per_stack or DEFAULT_NUMBER_OF_HITS_PER_STACK
		template_data.target_number_of_stacks = math.clamp(math.floor(number_of_hits / number_of_hits_per_stack), 0, max_stacks)
		template_data.last_hit_time = t
	end
end

local function _add_debuff_on_hit_start(template_data, template_context)
	local template = template_context.template
	local target_buff_data = template.target_buff_data
	local template_override_data = template_context.template_override_data
	local override_target_buff_data = template_override_data.target_buff_data
	template_data.internal_buff_name = override_target_buff_data and override_target_buff_data.internal_buff_name or target_buff_data.internal_buff_name
	template_data.num_stacks_on_proc = override_target_buff_data and override_target_buff_data.num_stacks_on_proc or target_buff_data.num_stacks_on_proc
	template_data.max_stacks = override_target_buff_data and override_target_buff_data.max_stacks or target_buff_data.max_stacks
end

local function _add_proc_debuff(t, params, template_data, template_context)
	local attacked_unit = params.attacked_unit

	if not HEALTH_ALIVE[attacked_unit] then
		return
	end

	local attacked_unit_buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

	if attacked_unit_buff_extension then
		local internal_buff_name = template_data.internal_buff_name
		local num_stacks_on_proc_func = template_context.template.num_stacks_on_proc_func
		local num_stacks_on_proc = num_stacks_on_proc_func and num_stacks_on_proc_func(t, params, template_data, template_context) or template_data.num_stacks_on_proc
		local max_stacks = template_data.max_stacks
		local current_stacks = attacked_unit_buff_extension:current_stacks(internal_buff_name)
		local stacks_to_add = math.min(num_stacks_on_proc, math.max(max_stacks - current_stacks, 0))

		if stacks_to_add == 0 and current_stacks <= max_stacks then
			attacked_unit_buff_extension:refresh_duration_of_stacking_buff(internal_buff_name, t)
		else
			local owner_unit = template_context.owner_unit
			local source_item = template_context.source_item

			attacked_unit_buff_extension:add_internally_controlled_buff_with_stacks(internal_buff_name, stacks_to_add, t, "owner_unit", owner_unit, "source_item", source_item)
		end
	end
end

local function _add_debuff_on_hit_proc(params, template_data, template_context, t)
	local allow_weapon_special = template_context.template.target_buff_data.allow_weapon_special
	local is_weapon_special = params.weapon_special

	if is_weapon_special and allow_weapon_special ~= nil and not allow_weapon_special then
		return
	end

	_add_proc_debuff(t, params, template_data, template_context)
end

local base_templates = {
	base_weapon_trait_add_buff_after_proc = {
		predicted = false,
		class_name = "proc_buff",
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			template_data.buff_extension = ScriptUnit.has_extension(unit, "buff_system")
		end,
		proc_func = function (params, template_data, template_context)
			local t = FixedFrame.get_latest_fixed_time()
			local buff_to_add = template_context.template.buff_to_add

			template_data.buff_extension:add_internally_controlled_buff(buff_to_add, t, "item_slot_name", template_context.item_slot_name)
		end
	}
}

local function chained_hits_start_func(template_data, template_context)
	local unit = template_context.unit
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local weapon_action_component = unit_data_extension:read_component("weapon_action")
	template_data.weapon_action_component = weapon_action_component
end

local function chain_hits_reset_update_func(template_data, template_context)
	local weapon_action_component = template_data.weapon_action_component
	local combo_count = weapon_action_component.combo_count
	local has_combo = combo_count > 0

	return not has_combo
end

base_templates.chained_hits_increases_melee_cleave_parent = {
	child_buff_template = "chained_hits_increases_melee_cleave_child",
	predicted = false,
	stack_offset = -1,
	max_stacks = 5,
	class_name = "weapon_trait_activated_parent_proc_buff",
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_finish] = 1
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1
	},
	active_proc_func = {
		on_sweep_start = function (params)
			return params.combo_count > 0
		end,
		on_sweep_finish = function (params)
			return params.num_hit_units > 0
		end
	},
	start_func = chained_hits_start_func,
	reset_update_func = chain_hits_reset_update_func,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.chained_hits_increases_melee_cleave_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.max_hit_mass_attack_modifier] = 0.5
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.chained_hits_increases_crit_chance_parent = {
	child_buff_template = "chained_hits_increases_crit_chance_child",
	predicted = false,
	stack_offset = -1,
	max_stacks = 5,
	class_name = "weapon_trait_activated_parent_proc_buff",
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_finish] = 1
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1
	},
	active_proc_func = {
		on_sweep_start = function (params)
			return params.combo_count > 0
		end,
		on_sweep_finish = function (params)
			return params.num_hit_units > 0
		end
	},
	clear_child_stacks_proc_events = {
		[proc_events.on_wield] = true,
		[proc_events.on_push_finish] = true
	},
	start_func = chained_hits_start_func,
	reset_update_func = chain_hits_reset_update_func,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.chained_hits_increases_crit_chance_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.5
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.chained_hits_increases_power_parent = {
	child_buff_template = "chained_hits_increases_power_child",
	predicted = false,
	stack_offset = -1,
	max_stacks = 5,
	class_name = "weapon_trait_activated_parent_proc_buff",
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_finish] = 1,
		[proc_events.on_wield] = 1,
		[proc_events.on_push_finish] = 1
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1
	},
	active_proc_func = {
		on_sweep_start = function (params)
			return params.combo_count > 0
		end,
		on_sweep_finish = function (params)
			return params.num_hit_units > 0
		end
	},
	clear_child_stacks_proc_events = {
		[proc_events.on_wield] = true,
		[proc_events.on_push_finish] = true
	},
	start_func = chained_hits_start_func,
	reset_update_func = chain_hits_reset_update_func,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.chained_hits_increases_power_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.05
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.chained_weakspot_hits_increases_power_parent = {
	child_buff_template = "chained_weakspot_hits_increases_power_child",
	predicted = false,
	stack_offset = -1,
	max_stacks = 1,
	class_name = "weapon_trait_activated_parent_proc_buff",
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_finish] = 1
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1
	},
	active_proc_func = {
		on_sweep_start = function (params)
			return params.combo_count > 0
		end,
		on_sweep_finish = function (params)
			return params.num_hit_units > 0 and params.hit_weakspot
		end
	},
	start_func = chained_hits_start_func,
	reset_update_func = chain_hits_reset_update_func,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.chained_weakspot_hits_increases_power_ranged_parent = {
	child_buff_template = "chained_weakspot_hits_increases_power_child",
	predicted = false,
	stack_offset = -1,
	max_stacks = 1,
	class_name = "weapon_trait_activated_parent_proc_buff",
	proc_events = {
		[proc_events.on_shoot] = 1
	},
	add_child_proc_events = {
		[proc_events.on_shoot] = 1
	},
	active_proc_func = {
		on_shoot = function (params)
			return params.hit_weakspot
		end
	},
	start_func = chained_hits_start_func,
	reset_update_func = chain_hits_reset_update_func,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.chained_weakspot_hits_increases_power_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.05
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.heavy_chained_hits_increases_killing_blow_chance_parent = {
	child_buff_template = "heavy_chained_hits_increases_killing_blow_chance_child",
	child_duration = 5,
	predicted = false,
	stack_offset = -1,
	max_stacks = 5,
	class_name = "weapon_trait_activated_parent_proc_buff",
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_finish] = 1,
		[proc_events.on_wield] = 1,
		[proc_events.on_push_finish] = 1
	},
	add_child_proc_events = {
		[proc_events.on_hit] = function (params)
			if params.attack_type == attack_types.melee and CheckProcFunctions.on_heavy_hit(params) then
				return 1
			end

			return nil
		end
	},
	active_proc_func = {
		[proc_events.on_sweep_start] = function (params)
			return params.combo_count > 0 and params.is_heavy
		end,
		[proc_events.on_sweep_finish] = function (params)
			return params.num_hit_units > 0
		end
	},
	clear_child_stacks_proc_events = {
		[proc_events.on_wield] = true,
		[proc_events.on_push_finish] = true
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.heavy_chained_hits_increases_killing_blow_chance_child = {
	predicted = false,
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	target_buff_data = {
		killing_blow_chance = 0.2
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
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
	end
}
base_templates.increased_attack_cleave_on_multiple_hits = {
	predicted = false,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	active_duration = 3,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	buff_data = {
		required_num_hits = 3
	},
	proc_stat_buffs = {
		[stat_buffs.max_hit_mass_attack_modifier] = 0.5
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_multiple_melee_hit
}
base_templates.increased_melee_damage_on_multiple_hits = {
	predicted = false,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	active_duration = 3,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	buff_data = {
		required_num_hits = 3
	},
	proc_stat_buffs = {
		[stat_buffs.melee_damage] = 0.5
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_multiple_melee_hit
}
base_templates.infinite_melee_cleave_on_crit = {
	class_name = "buff",
	predicted = false,
	conditional_keywords = {
		keywords.melee_infinite_cleave_critical_strike,
		keywords.ignore_armor_aborts_attack_critical_strike
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")
		template_data.critical_strike_component = unit_data_extension:read_component("critical_strike")
	end,
	check_active_func = function (template_data, template_context)
		return template_data.critical_strike_component.is_active
	end
}
base_templates.infinite_melee_cleave_on_kill = {
	predicted = false,
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[proc_events.on_kill] = 1
	},
	proc_keywords = {
		keywords.melee_infinite_cleave,
		keywords.ignore_armor_aborts_attack
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_kill,
	conditional_keywords_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.infinite_melee_cleave_on_weakspot_kill = {
	predicted = false,
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[proc_events.on_kill] = 1
	},
	proc_keywords = {
		keywords.melee_infinite_cleave,
		keywords.ignore_armor_aborts_attack
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_weakspot_kill,
	conditional_keywords_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.pass_past_armor_on_crit = {
	predicted = false,
	class_name = "buff",
	conditional_keywords = {
		keywords.use_reduced_hit_mass,
		keywords.ignore_armor_aborts_attack
	},
	start_func = function (template_data, template_context)
		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")
		template_data.critical_strike_component = unit_data_extension:read_component("critical_strike")
	end,
	conditional_stat_buffs_func = ConditionalFunctions.all(ConditionalFunctions.is_item_slot_wielded, function (template_data, template_context)
		return template_data.critical_strike_component.is_active
	end)
}
base_templates.staggered_targets_receive_increased_stagger_debuff = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	target_buff_data = {
		internal_buff_name = "increase_impact_received_while_staggered",
		num_stacks_on_proc = 1,
		max_stacks = math.huge
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_stagger_hit,
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc
}
base_templates.staggered_targets_receive_increased_damage_debuff = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	target_buff_data = {
		internal_buff_name = "increase_damage_received_while_staggered",
		num_stacks_on_proc = 1,
		max_stacks = math.huge
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_stagger_hit,
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc
}
base_templates.targets_receive_rending_debuff = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	target_buff_data = {
		internal_buff_name = "rending_debuff",
		num_stacks_on_proc = 1,
		max_stacks = math.huge
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.attacked_unit_is_minion,
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc
}
base_templates.stacking_increase_impact_on_hit_parent = {
	child_buff_template = "stacking_increase_impact_on_hit_child",
	child_duration = 1.5,
	predicted = false,
	allow_proc_while_active = true,
	stacks_to_remove = 5,
	class_name = "weapon_trait_parent_proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.stacking_increase_impact_on_hit_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.melee_impact_modifier] = 0.2
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.toughness_recovery_on_chained_attacks = {
	predicted = false,
	toughness_fixed_percentage = 0.05,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_sweep_finish] = 1
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
	end
}
base_templates.toughness_recovery_on_multiple_hits = {
	cooldown_duration = 0,
	predicted = false,
	class_name = "proc_buff",
	active_duration = 1.5,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	buff_data = {
		replenish_percentage = 0.5,
		required_num_hits = 3
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_multiple_melee_hit,
	proc_func = function (params, template_data, template_context, t)
		local template_override_data = template_context.template_override_data
		local buff_data = template_override_data and template_override_data.buff_data or template_data.buff_data
		local replenish_percentage = buff_data.replenish_percentage
		local unit = template_context.unit

		Toughness.replenish_percentage(unit, replenish_percentage, false)
	end
}
base_templates.power_bonus_scaled_on_stamina = {
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	class_name = "stepped_stat_buff",
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.1
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
	end
}
base_templates.taunt_target_on_staggered_hit = {
	child_buff_template = "taunt_target_child",
	predicted = false,
	stacks_to_remove = 0,
	class_name = "weapon_trait_target_number_parent_proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	start_func = function (template_data, template_context)
		template_data.taunted_enemies = {}
	end,
	update_func = function (template_data, template_context)
		local number_of_taunted_enemies = 0
		local unit = template_context.unit
		local taunted_enemies = template_data.taunted_enemies

		for tauned_unit, _ in pairs(taunted_enemies) do
			local attacked_unit_buff_extension = ScriptUnit.has_extension(tauned_unit, "buff_system")
			local owner_of_taunt = attacked_unit_buff_extension and attacked_unit_buff_extension:owner_of_buff_with_id("taunted")

			if owner_of_taunt == unit then
				number_of_taunted_enemies = number_of_taunted_enemies + 1
			else
				taunted_enemies[tauned_unit] = nil
			end
		end

		template_data.target_number_of_stacks = number_of_taunted_enemies
	end,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_stagger_hit, CheckProcFunctions.any(CheckProcFunctions.on_melee_hit, CheckProcFunctions.on_push_hit)),
	proc_func = function (params, template_data, template_context)
		local attacked_unit = params.attacked_unit

		if not attacked_unit then
			return
		end

		local attacked_unit_buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

		if attacked_unit_buff_extension then
			local owner_unit = template_context.owner_unit
			local source_item = template_context.source_item
			local t = FixedFrame.get_latest_fixed_time()

			attacked_unit_buff_extension:add_internally_controlled_buff("taunted", t, "owner_unit", owner_unit, "source_item", source_item)

			template_data.taunted_enemies[attacked_unit] = true
		end
	end
}
base_templates.taunt_target_child = {
	hide_icon_in_hud = true,
	predicted = false,
	stack_offset = -1,
	max_stacks = 1,
	class_name = "buff",
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.consecutive_hits_increases_stagger_parent = {
	child_buff_template = "consecutive_hits_increases_stagger_child",
	child_duration = 2,
	predicted = false,
	allow_proc_while_active = true,
	stacks_to_remove = 0,
	class_name = "weapon_trait_target_number_parent_proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	proc_func = _consecutive_hits_proc_func
}
base_templates.consecutive_hits_increases_stagger_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.melee_impact_modifier] = 0.1
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.consecutive_hits_increases_ranged_power_parent = {
	child_buff_template = "consecutive_hits_increases_ranged_power_child",
	child_duration = 2,
	predicted = false,
	allow_proc_while_active = true,
	stacks_to_remove = 0,
	class_name = "weapon_trait_target_number_parent_proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	proc_func = _consecutive_hits_proc_func
}
base_templates.consecutive_hits_increases_ranged_power_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.ranged_power_level_modifier] = 0.1
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.pass_trough_armor_on_weapon_special = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_keywords = {
		keywords.use_reduced_hit_mass,
		keywords.ignore_armor_aborts_attack
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.increase_power_on_hit_parent = {
	child_duration = 3.5,
	predicted = false,
	child_buff_template = "increase_power_on_hit_child",
	allow_proc_while_active = true,
	stacks_to_remove = 5,
	class_name = "weapon_trait_parent_proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.increase_power_on_hit_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.2
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.increase_power_on_kill_parent = {
	child_buff_template = "increase_power_on_kill_child",
	child_duration = 3.5,
	predicted = false,
	allow_proc_while_active = true,
	stacks_to_remove = 5,
	class_name = "weapon_trait_parent_proc_buff",
	proc_events = {
		[proc_events.on_kill] = 1
	},
	check_proc_func = CheckProcFunctions.on_kill,
	add_child_proc_events = {
		[proc_events.on_kill] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.increase_power_on_kill_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.2
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.power_bonus_on_first_attack = {
	always_show_in_hud = true,
	predicted = false,
	force_predicted_proc = true,
	class_name = "weapon_trait_proc_conditional_switch_buff",
	show_in_hud_if_slot_is_wielded = true,
	proc_events = {
		[proc_events.on_windup_start] = 1,
		[proc_events.on_sweep_start] = 1
	},
	conditional_stat_buffs = {
		{
			[stat_buffs.power_level_modifier] = 0.5
		},
		{
			[stat_buffs.power_level_modifier] = -0.5
		}
	},
	specific_proc_func = {
		on_windup_start = function (params, template_data, template_context)
			if params.combo_count > 0 then
				template_context.stat_buff_index = 2
			else
				template_context.stat_buff_index = 1
			end
		end,
		on_sweep_start = function (params, template_data, template_context)
			if params.combo_count > 0 then
				template_context.stat_buff_index = 2
			else
				template_context.stat_buff_index = 1
			end
		end
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = unit and ScriptUnit.has_extension(unit, "unit_data_system")
		template_data.weapon_action_component = unit_data_extension and unit_data_extension:read_component("weapon_action")
	end,
	update_func = function (template_data, template_context)
		local weapon_action_component = template_data.weapon_action_component
		local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
		local _, current_action_settings = Action.current_action(weapon_action_component, weapon_template)
		local current_action_kind = current_action_settings and current_action_settings.kind
		local combo_count = weapon_action_component.combo_count

		if combo_count == 0 and current_action_kind ~= "sweep" and current_action_kind ~= "windup" then
			template_context.stat_buff_index = false
		end
	end,
	conditional_switch_stat_buffs_func = function (template_data, template_context)
		return template_context.stat_buff_index
	end,
	conditional_hud_data = {
		{
			force_negative_frame = false,
			is_active = true
		},
		{
			force_negative_frame = true,
			is_active = true
		},
		{
			force_negative_frame = false,
			is_active = false
		}
	}
}
base_templates.rending_vs_staggered = {
	hide_icon_in_hud = true,
	predicted = false,
	max_stacks = 1,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.rending_vs_staggered_multiplier] = 0.1
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.guaranteed_melee_crit_on_activated_kill = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_kill] = 1
	},
	buff_data = {
		internal_buff_name = "guaranteed_melee_crit_on_activated_kill_effect"
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	end,
	check_proc_func = function (params, template_data, template_context)
		return ConditionalFunctions.is_item_slot_wielded(template_data, template_context) and CheckProcFunctions.on_weapon_special_kill(params)
	end,
	proc_func = function (params, template_data, template_context)
		local template = template_context.template
		local buff_data = template.buff_data
		local template_override_data = template_context.template_override_data
		local override_buff_data = template_override_data.buff_data
		local internal_buff_name = override_buff_data and override_buff_data.internal_buff_name or buff_data.internal_buff_name
		local t = FixedFrame.get_latest_fixed_time()
		local item_slot_name = template_context.item_slot_name
		local template_name = template_context.template.name

		template_data.buff_extension:add_internally_controlled_buff(internal_buff_name, t, "item_slot_name", item_slot_name, "parent_buff_template", template_name)
	end
}
base_templates.guaranteed_melee_crit_on_activated_kill_effect = {
	predicted = false,
	max_stacks = 1,
	duration = 5,
	class_name = "proc_buff",
	keywords = {
		keywords.guaranteed_melee_critical_strike
	},
	proc_events = {
		[proc_events.on_critical_strike] = 1
	},
	proc_func = function (params, template_data, template_context)
		template_data.finish = true
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish
	end
}
base_templates.bleed_on_activated_hit = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	target_buff_data = {
		internal_buff_name = "bleed",
		num_stacks_on_proc = 1,
		max_stacks = math.huge
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_melee_weapon_special_hit),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc
}
base_templates.movement_speed_on_activation = {
	force_predicted_proc = true,
	predicted = false,
	class_name = "proc_buff",
	active_duration = 2,
	proc_events = {
		[proc_events.on_weapon_special] = 1
	},
	proc_stat_buffs = {
		[stat_buffs.movement_speed] = 1.5
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.targets_receive_rending_debuff_on_weapon_special_attacks = table.clone(base_templates.targets_receive_rending_debuff)
base_templates.targets_receive_rending_debuff_on_weapon_special_attacks.check_proc_func = CheckProcFunctions.is_weapon_special
base_templates.pass_past_armor_on_weapon_special = {
	predicted = false,
	class_name = "buff",
	conditional_keywords = {
		keywords.use_reduced_hit_mass,
		keywords.ignore_armor_aborts_attack
	},
	conditional_stat_buffs_func = ConditionalFunctions.all(ConditionalFunctions.is_item_slot_wielded, ConditionalFunctions.melee_weapon_special_active)
}
base_templates.extra_explosion_on_activated_attacks_on_armor = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.weapon_special_max_activations] = 1
	},
	conditional_stat_buffs_func = ConditionalFunctions.all(ConditionalFunctions.is_item_slot_wielded, ConditionalFunctions.melee_weapon_special_active)
}
base_templates.windup_increases_power_parent = {
	stacks_to_remove = 3,
	predicted = false,
	allow_proc_while_active = true,
	child_buff_template = "windup_increases_power_child",
	stack_offset = -1,
	max_stacks = 3,
	class_name = "weapon_trait_parent_proc_buff",
	show_in_hud_if_slot_is_wielded = true,
	proc_events = {
		[proc_events.on_windup_trigger] = 1,
		[proc_events.on_sweep_finish] = 1,
		[proc_events.on_action_start] = 1,
		[proc_events.on_wield] = 1
	},
	specific_check_proc_funcs = {
		[proc_events.on_windup_trigger] = function (params, template_data, template_context)
			return ConditionalFunctions.is_item_slot_wielded(template_data, template_context)
		end,
		[proc_events.on_action_start] = function (params, template_data, template_context)
			local action_settings = params.action_settings
			local kind = action_settings.kind
			local is_sweep = kind == "sweep"

			return not is_sweep
		end
	},
	add_child_proc_events = {
		[proc_events.on_windup_trigger] = 1
	},
	clear_child_stacks_proc_events = {
		[proc_events.on_sweep_finish] = true,
		[proc_events.on_action_start] = true,
		[proc_events.on_wield] = true
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.windup_increases_power_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 3,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.melee_power_level_modifier] = 0.5
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.hipfire_while_sprinting = {
	predicted = false,
	class_name = "buff",
	keywords = {
		keywords.allow_hipfire_during_sprint
	},
	conditional_keyword_func = ConditionalFunctions.is_item_slot_wielded,
	check_active_func = ConditionalFunctions.all(ConditionalFunctions.is_item_slot_wielded, ConditionalFunctions.is_sprinting)
}
base_templates.increase_power_on_close_kill_parent = {
	child_duration = 1,
	predicted = false,
	child_buff_template = "increase_power_on_close_kill_child",
	allow_proc_while_active = true,
	stacks_to_remove = 5,
	class_name = "weapon_trait_parent_proc_buff",
	proc_events = {
		[proc_events.on_kill] = 1
	},
	add_child_proc_events = {
		[proc_events.on_kill] = 1
	},
	check_proc_func = CheckProcFunctions.on_ranged_close_kill,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.increase_power_on_close_kill_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.01
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.increase_damage_on_close_kill_parent = {
	child_duration = 1,
	predicted = false,
	child_buff_template = "increase_damage_on_close_kill_child",
	allow_proc_while_active = true,
	stacks_to_remove = 5,
	class_name = "weapon_trait_parent_proc_buff",
	proc_events = {
		[proc_events.on_kill] = 1
	},
	add_child_proc_events = {
		[proc_events.on_kill] = 1
	},
	check_proc_func = CheckProcFunctions.on_ranged_close_kill,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.increase_damage_on_close_kill_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.damage] = 0.01
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.increase_close_damage_on_close_kill_parent = {
	child_duration = 1,
	predicted = false,
	child_buff_template = "increase_close_damage_on_close_kill_child",
	allow_proc_while_active = true,
	stacks_to_remove = 5,
	class_name = "weapon_trait_parent_proc_buff",
	proc_events = {
		[proc_events.on_kill] = 1
	},
	add_child_proc_events = {
		[proc_events.on_kill] = 1
	},
	check_proc_func = CheckProcFunctions.on_ranged_close_kill,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.increase_close_damage_on_close_kill_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.damage_near] = 0.01
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.suppression_on_close_kill = {
	cooldown_duration = 0,
	predicted = false,
	class_name = "proc_buff",
	active_duration = 1.5,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_ranged_close_kill,
	proc_func = function (params, template_data, template_context)
		local template_override_data = template_context.template_override_data
		local suppression_settings = template_override_data.suppression_settings
		local attacking_unit = params.attacking_unit
		local from_position = POSITION_LOOKUP[attacking_unit] or Unit.world_position(attacking_unit, 1)

		Suppression.apply_area_minion_suppression(attacking_unit, suppression_settings, from_position)
	end,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.count_as_dodge_vs_ranged_on_close_kill = {
	active_duration = 2,
	predicted = false,
	class_name = "proc_buff",
	allow_proc_while_active = true,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	proc_keywords = {
		keywords.count_as_dodge_vs_ranged
	},
	check_proc_func = CheckProcFunctions.on_ranged_close_kill,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.toughness_recovery_on_close_kill = {
	predicted = false,
	allow_proc_while_active = true,
	toughness_fixed_percentage = 0.02,
	class_name = "proc_buff",
	active_duration = 2,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_ranged_close_kill,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	proc_func = _regain_toughness_proc_func
}
base_templates.reload_speed_on_slide = {
	predicted = false,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	active_duration = 2,
	proc_events = {
		[proc_events.on_slide_start] = 1
	},
	proc_stat_buffs = {
		[stat_buffs.reload_speed] = 0.5
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.allow_flanking_and_increased_damage_when_flanking = {
	class_name = "buff",
	hide_icon_in_hud = true,
	predicted = false,
	conditional_keywords = {
		keywords.allow_flanking
	},
	conditional_stat_buffs = {
		[stat_buffs.flanking_damage] = 0.5
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.power_bonus_on_hitting_single_enemy_with_all = {
	predicted = false,
	allow_proc_while_active = true,
	max_stacks = 1,
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[proc_events.on_shoot] = 1
	},
	proc_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.05
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_hit_all_pellets_on_same
}
base_templates.increased_sprint_speed = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.sprint_movement_speed] = 1.05
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	check_active_func = ConditionalFunctions.all(ConditionalFunctions.is_item_slot_wielded, ConditionalFunctions.is_sprinting)
}
base_templates.power_bonus_on_first_shot = {
	always_show_in_hud = true,
	predicted = false,
	class_name = "buff",
	show_in_hud_if_slot_is_wielded = true,
	conditional_stat_buffs = {
		[stat_buffs.ranged_power_level_modifier] = 0.02
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
	end
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
	local is_follow_up_shots = num_shots_fired == 1 or num_shots_fired == 2

	return is_follow_up_shots
end

base_templates.followup_shots_ranged_damage = {
	always_show_in_hud = true,
	predicted = false,
	class_name = "buff",
	show_in_hud_if_slot_is_wielded = true,
	conditional_stat_buffs = {
		[stat_buffs.ranged_damage] = 0.2
	},
	start_func = _follow_up_shots_start,
	conditional_stat_buffs_func = _follow_up_shots_conditional_stat_buff_func
}
base_templates.followup_shots_ranged_weakspot_damage = {
	always_show_in_hud = true,
	predicted = false,
	class_name = "buff",
	show_in_hud_if_slot_is_wielded = true,
	conditional_stat_buffs = {
		[stat_buffs.ranged_weakspot_damage] = 0.2
	},
	start_func = _follow_up_shots_start,
	conditional_stat_buffs_func = _follow_up_shots_conditional_stat_buff_func
}
base_templates.consecutive_hits_increases_close_damage_parent = {
	child_buff_template = "consecutive_hits_increases_stagger_child",
	child_duration = 2,
	predicted = false,
	allow_proc_while_active = true,
	stacks_to_remove = 0,
	class_name = "weapon_trait_target_number_parent_proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	proc_func = _consecutive_hits_proc_func
}
base_templates.consecutive_hits_increases_close_damage_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.damage_near] = 0.01
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.stagger_count_bonus_damage = {
	hide_icon_in_hud = true,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.stagger_count_damage] = 0.5
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.burninating_on_crit_ranged = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	target_buff_data = {
		max_stacks = 10,
		internal_buff_name = "flamer_assault",
		num_stacks_on_proc = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_crit_ranged, CheckProcFunctions.on_damaging_hit),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc
}
base_templates.suppression_negation_on_weakspot = {
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
}
base_templates.count_as_dodge_vs_ranged_on_weakspot = {
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
}
base_templates.negate_stagger_reduction_on_weakspot = {
	hide_icon_in_hud = true,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.stagger_weakspot_reduction_modifier] = 0.5
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_weakspot_hit
}
base_templates.stacking_crit_chance_on_weakspot_parent = {
	class_name = "weapon_trait_parent_proc_buff",
	child_buff_template = "stacking_crit_chance_on_weakspot_child",
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
	specific_check_proc_funcs = {
		[proc_events.on_hit] = CheckProcFunctions.on_weakspot_hit
	}
}
base_templates.stacking_crit_chance_on_weakspot_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.5
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.crit_weakspot_finesse = {
	hide_icon_in_hud = true,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_weakspot_damage] = 0.5
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		return CheckProcFunctions.on_weakspot_crit(params)
	end
}

local function _continuous_fire_start_func(template_data, template_context)
	local unit = template_context.unit
	local unit_data_extension = unit and ScriptUnit.has_extension(unit, "unit_data_system")
	template_data.shooting_status_component = unit_data_extension and unit_data_extension:read_component("shooting_status")
	template_data.weapon_action_component = unit_data_extension and unit_data_extension:read_component("weapon_action")
end

local function _get_number_of_continuous_fire_steps(template_data, template_context)
	local template = template_context.template
	local use_combo = template.use_combo

	if not use_combo then
		local shooting_status_component = template_data.shooting_status_component
		local num_shots = shooting_status_component.num_shots
		local continuous_fire_step = template_context.template.continuous_fire_step or 1

		if continuous_fire_step == 0 then
			return 0
		end

		local steps = math.floor(num_shots / continuous_fire_step)

		return steps
	else
		local shooting_status_component = template_data.weapon_action_component
		local combo_count = shooting_status_component.combo_count

		return combo_count
	end
end

base_templates.conditional_buff_on_continuous_fire = {
	predicted = false,
	max_stacks = 1,
	class_name = "stepped_stat_buff",
	start_func = _continuous_fire_start_func,
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return false
		end

		local number_of_steps = _get_number_of_continuous_fire_steps(template_data, template_context)

		return number_of_steps > 0
	end
}
base_templates.stacking_buff_on_continuous_fire = {
	predicted = false,
	stack_offset = -1,
	max_stacks = 1,
	class_name = "stepped_stat_buff",
	conditional_stepped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = _continuous_fire_start_func,
	min_max_step_func = function (template_data, template_context)
		return 0, 5
	end,
	bonus_step_func = _get_number_of_continuous_fire_steps
}
base_templates.bleed_on_crit_ranged = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	target_buff_data = {
		internal_buff_name = "bleed",
		num_stacks_on_proc = 1,
		max_stacks = math.huge
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_ranged_crit_hit),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc
}
base_templates.bleed_on_crit_pellets = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_pellet_hits] = 1
	},
	target_buff_data = {
		internal_buff_name = "bleed",
		num_stacks_on_proc = 1,
		max_stacks = math.huge
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_crit),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc
}
base_templates.stacking_power_bonus_on_staggering_enemies_parent = {
	class_name = "weapon_trait_parent_proc_buff",
	child_buff_template = "stacking_power_bonus_on_staggering_enemies_child",
	child_duration = 2.5,
	predicted = false,
	stacks_to_remove = 5,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_staggering_hit
}
base_templates.stacking_power_bonus_on_staggering_enemies_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.1
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.toughness_on_crit_kills = {
	predicted = false,
	toughness_fixed_percentage = 0.05,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_kill] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_crit_kills,
	proc_func = _regain_toughness_proc_func
}
base_templates.warpcharge_stepped_bonus = {
	predicted = false,
	stack_offset = -1,
	max_stacks = 1,
	class_name = "stepped_stat_buff",
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
	end
}
base_templates.faster_charge_on_chained_secondary_attacks = {
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	class_name = "stepped_stat_buff",
	conditional_stat_buffs = {
		[stat_buffs.charge_up_time] = -0.04
	},
	charge_actions = {
		action_trigger_explosion = true,
		action_charge_explosion = true
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
	end
}
base_templates.vents_warpcharge_on_weakspot_hits = {
	vent_percentage = 0.05,
	predicted = false,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local warp_charge_component = unit_data_extension:write_component("warp_charge")
		template_data.warp_charge_component = warp_charge_component
		template_data.counter = 0
	end,
	check_proc_func = CheckProcFunctions.on_weakspot_hit,
	proc_func = function (params, template_data, template_context)
		template_data.proc = true
	end,
	update_func = function (template_data, template_context, dt, t)
		if template_data.proc then
			local warp_charge_component = template_data.warp_charge_component
			local buff_template = template_context.template
			local override_data = template_context.template_override_data
			local remove_percentage = override_data.vent_percentage or buff_template.vent_percentage

			WarpCharge.decrease_immediate(remove_percentage, warp_charge_component, template_context.unit)

			template_data.proc = nil
		end
	end
}
base_templates.warpfire_on_crits_ranged = {
	predicted = false,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	target_buff_data = {
		max_stacks = 6,
		internal_buff_name = "warp_fire",
		num_stacks_on_proc = 2
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_ranged_crit_hit, CheckProcFunctions.on_damaging_hit),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc
}
base_templates.warpfire_on_crits_melee = {
	predicted = false,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	target_buff_data = {
		max_stacks = 6,
		internal_buff_name = "warp_fire",
		num_stacks_on_proc = 2,
		allow_weapon_special = true
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_melee_crit_hit, CheckProcFunctions.on_damaging_hit),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc
}
base_templates.double_shot_on_crit = {
	hide_icon_in_hud = true,
	predicted = false,
	max_stacks = 1,
	class_name = "buff",
	conditional_keywords = {
		keywords.critical_hit_second_projectile
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.uninterruptable_while_charging = {
	max_num_stacks = 6,
	class_name = "buff",
	predicted = false,
	max_stacks = 1,
	conditional_keywords = {
		keywords.uninterruptible,
		keywords.stun_immune
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
	end
}
base_templates.stacking_rending_on_weakspot_parent = {
	class_name = "weapon_trait_parent_proc_buff",
	stacks_to_remove = 5,
	child_duration = 2.5,
	predicted = false,
	base_child_buff_template = "stacking_rending_on_weakspot_child",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_weakspot_hit
}
base_templates.stacking_rending_on_weakspot_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 5,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.rending_multiplier] = 0.1
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.dodge_grants_finesse_bonus = {
	allow_proc_while_active = true,
	predicted = false,
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[proc_events.on_successful_dodge] = 1
	},
	proc_stat_buffs = {
		[stat_buffs.finesse_modifier_bonus] = 0.05
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.dodge_grants_critical_strike_chance = {
	allow_proc_while_active = true,
	predicted = false,
	class_name = "proc_buff",
	active_duration = 5,
	proc_events = {
		[proc_events.on_successful_dodge] = 1
	},
	proc_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.05
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.bleed_on_crit_melee = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	target_buff_data = {
		internal_buff_name = "bleed",
		num_stacks_on_proc = 1,
		allow_weapon_special = true,
		max_stacks = math.huge
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_melee_crit_hit),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc
}
base_templates.bleed_on_non_weakspot_hit_melee = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	target_buff_data = {
		internal_buff_name = "bleed",
		num_stacks_on_proc = 1,
		max_stacks = math.huge
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_non_weakspot_hit_melee),
	start_func = _add_debuff_on_hit_start,
	proc_func = _add_debuff_on_hit_proc
}
base_templates.rending_on_backstab = {
	class_name = "buff",
	predicted = false,
	hide_icon_in_hud = true,
	keywords = {
		keywords.allow_backstabbing
	},
	conditional_stat_buffs = {
		[stat_buffs.backstab_rending_multiplier] = 1
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.increased_weakspot_damage_against_bleeding = {
	hide_icon_in_hud = true,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.melee_weakspot_damage_vs_bleeding] = 1
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.increased_crit_chance_on_staggered_weapon_special_hit_parent = {
	child_buff_template = "increased_crit_chance_on_staggered_weapon_special_hit_child",
	child_duration = 2,
	predicted = false,
	allow_proc_while_active = true,
	stacks_to_remove = 2,
	class_name = "weapon_trait_parent_proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_weapon_special_melee_stagger_hit
}
base_templates.increased_crit_chance_on_staggered_weapon_special_hit_child = {
	hide_icon_in_hud = true,
	stack_offset = -1,
	max_stacks = 2,
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.1
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.increased_crit_chance_on_weapon_special_hit = {
	allow_proc_while_active = true,
	predicted = false,
	class_name = "proc_buff",
	active_duration = 3,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	proc_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_melee_weapon_special_hit
}
base_templates.toughness_on_elite_kills = {
	predicted = false,
	toughness_fixed_percentage = 0.05,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_kill] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = CheckProcFunctions.on_elite_kill,
	proc_func = _regain_toughness_proc_func
}
base_templates.rending_on_crit = {
	class_name = "buff",
	hide_icon_in_hud = true,
	predicted = false,
	stat_buffs = {
		[stat_buffs.critical_strike_rending_multiplier] = 1
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded
}
base_templates.chance_based_on_aim_time = {
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	duration_per_stack = 1,
	class_name = "stepped_stat_buff",
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.05
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
		return 0, 5
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
	end
}
base_templates.crit_chance_based_on_ammo_left = {
	predicted = false,
	hud_always_show_stacks = true,
	stack_offset = -1,
	class_name = "stepped_stat_buff",
	conditional_stat_buffs = {
		[stat_buffs.ranged_critical_strike_chance] = 0.05
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
	end
}
base_templates.sticky_projectiles = {
	predicted = false,
	class_name = "buff",
	hide_icon_in_hud = true,
	keywords = {
		keywords.sticky_projectiles
	}
}
base_templates.chance_to_explode_elites_on_kill = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_minion_death] = 0.05
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	check_proc_func = function (params, template_data, template_context)
		local template = template_context.template
		local proc_data = template.proc_data
		local target_unit = params.dying_unit
		local breed_name = params.breed_name
		local breed = Breeds[breed_name]
		local is_elite = breed and breed.tags and breed.tags.elite

		if not is_elite then
			return false
		end

		local target_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

		if not target_buff_extension then
			return false
		end

		local valid_keyword = target_buff_extension:has_any_keyword(proc_data.validation_keywords)

		if not valid_keyword then
			return false
		end

		local is_source_player = target_buff_extension:has_buff_id_with_owner(proc_data.fire_buff_id, template_context.unit)

		if not is_source_player then
			return false
		end

		return true
	end,
	proc_func = function (params, template_data, template_context)
		local dying_unit = params.dying_unit
		local explosion_position = HitZone.hit_zone_center_of_mass(dying_unit, HitZone.hit_zone_names.center_mass, false) + Vector3.up() * 0.01
		local explosion_template = template_context.template.proc_data.explosion_template

		Explosion.create_explosion(template_context.world, template_context.physics_world, explosion_position, Vector3.up(), template_context.unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion)
	end
}
base_templates.faster_reload_on_empty_clip = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.reload_speed] = 1.5
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return ConditionalFunctions.is_item_slot_wielded(template_data, template_context) and ConditionalFunctions.has_empty_clip(template_data, template_context)
	end
}
base_templates.power_scales_with_clip_percentage = {
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	class_name = "stepped_stat_buff",
	conditional_stat_buffs = {
		[stat_buffs.ranged_power_level_modifier] = 0.05
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

		if slot_type == "weapon" and not ConditionalFunctions.is_reloading(template_data, template_context) then
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
	end
}
base_templates.move_ammo_from_reserve_to_clip_on_crit = {
	num_ammmo_to_move = 5,
	force_predicted_proc = true,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_critical_strike] = 1
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
	end
}

return base_templates
