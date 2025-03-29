-- chunkname: @scripts/settings/buff/archetype_buff_templates/ogryn_buff_templates.lua

local Action = require("scripts/utilities/action/action")
local Ammo = require("scripts/utilities/ammo")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breeds = require("scripts/settings/breed/breeds")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FixedFrame = require("scripts/utilities/fixed_frame")
local MinionState = require("scripts/utilities/minion_state")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitAction = require("scripts/extension_systems/visual_loadout/utilities/player_unit_action")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local ShoutAbilityImplementation = require("scripts/extension_systems/ability/utilities/shout_ability_implementation")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local Suppression = require("scripts/utilities/attack/suppression")
local Stamina = require("scripts/utilities/attack/stamina")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local Vo = require("scripts/utilities/vo")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local attack_types = AttackSettings.attack_types
local buff_keywords = BuffSettings.keywords
local buff_categories = BuffSettings.buff_categories
local proc_events = BuffSettings.proc_events
local slot_configuration = PlayerCharacterConstants.slot_configuration
local special_rules = SpecialRulesSettings.special_rules
local stat_buffs = BuffSettings.stat_buffs
local talent_settings_shared = TalentSettings.ogryn_shared
local damage_types = DamageSettings.damage_types
local stagger_results = AttackSettings.stagger_results
local talent_settings_1 = TalentSettings.ogryn_1
local talent_settings_2 = TalentSettings.ogryn_2
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local _passive_revive_conditional, _big_bull_add_stacks
local templates = {}

table.make_unique(templates)

local function _penance_start_func(buff_name)
	return function (template_data, template_context)
		local unit = template_context.unit
		local t = FixedFrame.get_latest_fixed_time()
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		buff_extension:add_internally_controlled_buff(buff_name, t)
	end
end

templates.ogryn_base_passive_tank = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings_shared.tank.toughness_damage_taken_multiplier,
		[stat_buffs.damage_taken_multiplier] = talent_settings_shared.tank.damage_taken_multiplier,
		[stat_buffs.static_movement_reduction_multiplier] = talent_settings_shared.tank.static_movement_reduction_multiplier,
	},
	related_talents = {
		"ogryn_base_tank_passive",
	},
}
templates.ogryn_base_passive_revive = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.revive_speed_modifier] = talent_settings_shared.revive.revive_speed_modifier,
		[stat_buffs.assist_speed_modifier] = talent_settings_shared.revive.assist_speed_modifier,
	},
	related_talents = {
		"ogryn_2_base_2",
	},
}
templates.coherency_aura_size_increase = {
	class_name = "buff",
	predicted = false,
	keywords = {},
	stat_buffs = {
		[stat_buffs.coherency_radius_modifier] = talent_settings_shared.radius.coherency_aura_size_increase,
	},
	related_talents = {
		"ogryn_coherency_radius_increase",
	},
}
templates.ogryn_toughness_regen_aura = {
	class_name = "buff",
	coherency_id = "ogryn_toughness_regen_coherency_aura",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_aura_stay_close",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 5,
	max_stacks = 1,
	predicted = false,
	buff_category = buff_categories.aura,
	stat_buffs = {
		[stat_buffs.toughness_replenish_modifier] = talent_settings_shared.toughness_coherency_aura.toughness_replenish_modifier,
	},
	start_func = _penance_start_func("ogryn_toughness_restored_aura_tracking_buff"),
	related_talents = {
		"ogryn_toughness_regen_aura",
	},
}

local toughness_aura_increase = talent_settings_shared.toughness_coherency_aura.toughness_replenish_modifier

templates.ogryn_toughness_restored_aura_tracking_buff = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_toughness_replenished] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.amount = 0
		template_data.threshold = 50
		template_data.last_num_in_coherency = 0
		template_data.valid_buff_owners = {}
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local amount = params.amount

		amount = amount * toughness_aura_increase
		template_data.amount = template_data.amount + amount

		if template_data.amount >= template_data.threshold then
			local hook_name = "hook_ogryn_toughness_restored_aura"
			local parent_buff_name = "ogryn_toughness_regen_aura"

			template_data.last_num_in_coherency, template_data.valid_buff_owners = template_data.coherency_extension:evaluate_and_send_achievement_data(template_data.last_num_in_coherency, template_data.valid_buff_owners, parent_buff_name, hook_name, template_data.amount)
			template_data.amount = template_data.amount - template_data.threshold
		end
	end,
	related_talents = {
		"ogryn_toughness_regen_aura",
	},
}

local heavy_hitter_max_stacks = talent_settings_shared.ogryn_heavy_hitter.max_stacks
local heavy_hitter_lerp_value = 0

templates.ogryn_passive_heavy_hitter = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	start_func = function (template_data, template_context)
		local player_unit = template_context.unit
		local buff_extension = ScriptUnit.extension(player_unit, "buff_system")

		template_data.buff_extension = buff_extension
		template_data.max_stacks = heavy_hitter_max_stacks
		template_data.evaluate_max_stacks_stat = false

		local talent_extension = ScriptUnit.extension(player_unit, "talent_system")

		template_data.light_attacks_refreshes_duration = talent_extension:has_special_rule(special_rules.ogryn_heavy_hitter_light_attacks_refresh_duration)
		template_data.max_stacks_improves_attack_speed = talent_extension:has_special_rule(special_rules.ogryn_heavy_hitter_max_stacks_improves_attack_speed)
		template_data.max_stacks_improves_toughness = talent_extension:has_special_rule(special_rules.ogryn_heavy_hitter_max_stacks_improves_toughness)

		local t = FixedFrame.get_latest_fixed_time()

		if template_data.max_stacks_improves_toughness then
			buff_extension:add_internally_controlled_buff("ogryn_heavy_hitter_max_stacks_improves_toughness", t)
		end
	end,
	update_func = function (template_data, template_context, dt, t, template)
		local max_stacks = template_data.max_stacks
		local buff_extension = template_data.buff_extension
		local damage_buff_name = "ogryn_heavy_hitter_damage_effect"
		local current_stacks = buff_extension:current_stacks(damage_buff_name)
		local at_max_stacks = current_stacks == max_stacks

		heavy_hitter_lerp_value = math.clamp(current_stacks / max_stacks, 0, 1)

		if template_data.evaluate_max_stacks_stat and not at_max_stacks then
			Managers.stats:record_private("hook_ogryn_heavy_hitter_at_max_lost", template_context.player)

			template_data.evaluate_max_stacks_stat = false
		end
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		if params.target_number and params.target_number > 1 then
			return
		end

		if params.attack_type ~= attack_types.melee then
			return
		end

		if not params.damage_efficiency or params.damage_efficiency == "push" then
			return
		end

		local is_heavy_hit = CheckProcFunctions.on_heavy_hit(params)
		local damage_buff_name = "ogryn_heavy_hitter_damage_effect"
		local buff_extension = template_data.buff_extension
		local max_stacks = template_data.max_stacks
		local current_stacks = buff_extension:current_stacks(damage_buff_name)
		local at_max_stacks = current_stacks == max_stacks
		local will_be_max_stacks = current_stacks == max_stacks - 1
		local max_stacks_improves_toughness = template_data.max_stacks_improves_toughness
		local max_stacks_improves_attack_speed = template_data.max_stacks_improves_attack_speed
		local stacks = is_heavy_hit and talent_settings_shared.ogryn_heavy_hitter.heavy_stacks or talent_settings_shared.ogryn_heavy_hitter.stacks

		buff_extension:add_internally_controlled_buff_with_stacks(damage_buff_name, stacks, t)

		if will_be_max_stacks then
			Managers.stats:record_private("hook_ogryn_heavy_hitter_at_max_stacks", template_context.player)

			template_data.evaluate_max_stacks_stat = true

			if max_stacks_improves_attack_speed then
				buff_extension:add_internally_controlled_buff("ogryn_heavy_hitter_attack_speed_effect", t)
			end
		end
	end,
	related_talents = {
		"ogryn_passive_heavy_hitter",
	},
}
templates.ogryn_heavy_hitter_damage_effect = {
	class_name = "buff",
	duration = 7.5,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_keystone_heavy_hitter",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = heavy_hitter_max_stacks,
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings_shared.ogryn_heavy_hitter.melee_damage,
	},
	related_talents = {
		"ogryn_passive_heavy_hitter",
	},
}
templates.ogryn_heavy_hitter_max_stacks_improves_toughness = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.toughness_melee_replenish] = {
			min = 0,
			max = talent_settings_shared.ogryn_heavy_hitter.toughness_melee_replenish * heavy_hitter_max_stacks,
		},
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return heavy_hitter_lerp_value
	end,
}
templates.ogryn_heavy_hitter_tdr = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = {
			min = 1,
			max = 1 - talent_settings_shared.ogryn_heavy_hitter.tdr * heavy_hitter_max_stacks,
		},
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return heavy_hitter_lerp_value
	end,
}
templates.ogryn_heavy_hitter_cleave = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.max_melee_hit_mass_attack_modifier] = {
			min = 0,
			max = talent_settings_shared.ogryn_heavy_hitter.cleave * heavy_hitter_max_stacks,
		},
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return heavy_hitter_lerp_value
	end,
}
templates.ogryn_heavy_hitter_stagger = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.melee_impact_modifier] = {
			min = 0,
			max = talent_settings_shared.ogryn_heavy_hitter.stagger * heavy_hitter_max_stacks,
		},
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return heavy_hitter_lerp_value
	end,
}
templates.ogryn_heavy_hitter_attack_speed_effect = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.attack_speed] = 0.1,
	},
	conditional_exit_func = function (template_data, template_context)
		return heavy_hitter_lerp_value < 1
	end,
}
templates.ogryn_heavy_hitter_toughness_regen_effect = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_melee_replenish] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")
		template_data.max_stacks = 5
	end,
	conditional_exit_func = function (template_data, template_context)
		local buff_extension = template_data.buff_extension
		local max_stacks = template_data.max_stacks
		local current_stacks = buff_extension:current_stacks("ogryn_heavy_hitter_damage_effect")

		return current_stacks < max_stacks
	end,
}
templates.ogryn_rending_on_elite_kills = {
	active_duration = 10,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_rending_on_elite_kills",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.rending_multiplier] = 0.1,
	},
	check_proc_func = CheckProcFunctions.on_elite_kill,
	related_talents = {
		"ogryn_rending_on_elite_kills",
	},
}

local function _pulse(template_data, template_context)
	local unit = template_context.unit
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local first_person_component = unit_data_extension:read_component("first_person")
	local rotation = first_person_component.rotation
	local shout_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))
	local radius = 12
	local shout_target_template_name = "ogryn_shout_no_stagger"
	local t = FixedFrame.get_latest_fixed_time()
	local locomotion_component = unit_data_extension:read_component("locomotion")
	local num_hits = ShoutAbilityImplementation.execute(radius, shout_target_template_name, unit, t, locomotion_component, shout_direction)
	local buff_extension = template_context.buff_extension
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.num_hits = num_hits

		buff_extension:add_proc_event(proc_events.on_ogryn_shout, param_table)
	end

	local vfx = "content/fx/particles/abilities/ogryn_ability_shout_activate"
	local player_position = Unit.world_position(unit, 1)
	local vfx_pos = player_position + Vector3.up()
	local fx_extension = ScriptUnit.extension(unit, "fx_system")

	fx_extension:spawn_particles(vfx, vfx_pos)
end

templates.ogryn_repeat_taunt = {
	class_name = "buff",
	duration = 6,
	predicted = false,
	start_func = function (template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		template_data.second_pulse_t = t + 3
	end,
	update_func = function (template_data, template_context, dt, t)
		if template_data.second_pulse_done then
			return
		end

		if t >= template_data.second_pulse_t then
			_pulse(template_data, template_context)

			template_data.second_pulse_done = true
		end
	end,
	stop_func = function (template_data, template_context)
		_pulse(template_data, template_context)
	end,
}
templates.ogryn_taunt_staggers_reduce_cooldown = {
	class_name = "proc_buff",
	cooldown_reduction_percentage = 0.025,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_stagger_hit,
	proc_func = function (params, template_data, template_context)
		local ability_extension = ScriptUnit.has_extension(template_context.unit, "ability_system")
		local ability_type = "combat_ability"

		if not ability_extension or not ability_extension:has_ability_type(ability_type) then
			return
		end

		local t = FixedFrame.get_latest_fixed_time()

		if template_data.next_proc_t and t < template_data.next_proc_t then
			return
		end

		if not params.attack_type or params.attack_type ~= attack_types.melee and params.attack_type ~= attack_types.push then
			return
		end

		local cd_reduction = template_context.template.cooldown_reduction_percentage

		ability_extension:reduce_ability_cooldown_percentage(ability_type, cd_reduction)

		template_data.next_proc_t = t + 0.1
	end,
}
templates.ogryn_taunt_radius_increase = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.shout_radius_modifier] = 0.5,
	},
}
templates.ogryn_taunt_increased_damage_taken_buff = {
	class_name = "buff",
	duration = 15,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = 1.25,
	},
}
templates.ogryn_blocking_ranged_taunts = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_block] = 1,
		[proc_events.on_push_hit] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		local affected_unit = params.attacking_unit or params.pushed_unit

		if not HEALTH_ALIVE[affected_unit] then
			return
		end

		local unit_data_extension = ScriptUnit.extension(affected_unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local is_monster = breed.tags.monster

		if is_monster then
			return
		end

		local buff_extension = ScriptUnit.has_extension(affected_unit, "buff_system")

		if buff_extension then
			local is_already_taunted = buff_extension:has_keyword(buff_keywords.taunted)

			if not is_already_taunted then
				buff_extension:add_internally_controlled_buff("taunted_short", t, "owner_unit", template_context.unit)
			end
		end
	end,
}
templates.ogryn_windup_reduces_damage_taken = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = 0.85,
	},
	start_func = function (template_data, template_context)
		local player_unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

		template_data.weapon_action_component = unit_data_extension:read_component("weapon_action")
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local weapon_action_component = template_data.weapon_action_component
		local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
		local _, action_settings = Action.current_action(weapon_action_component, weapon_template)
		local is_windup = action_settings and action_settings.kind == "windup"

		return is_windup
	end,
}
templates.ogryn_windup_is_uninterruptible = {
	class_name = "buff",
	predicted = false,
	conditional_keywords = {
		buff_keywords.uninterruptible,
	},
	conditional_stat_buffs = {
		[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0,
	},
	start_func = function (template_data, template_context)
		local player_unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

		template_data.weapon_action_component = unit_data_extension:read_component("weapon_action")
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local weapon_action_component = template_data.weapon_action_component
		local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
		local _, action_settings = Action.current_action(weapon_action_component, weapon_template)
		local is_windup = action_settings and action_settings.kind == "windup"

		return is_windup
	end,
}
templates.ogryn_bracing_reduces_damage_taken = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_bracing_reduces_damage_taken",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = 0.8,
	},
	start_func = function (template_data, template_context)
		local player_unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

		template_data.weapon_action_component = unit_data_extension:read_component("weapon_action")
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local weapon_action_component = template_data.weapon_action_component
		local braced = PlayerUnitAction.has_current_action_keyword(weapon_action_component, "braced")

		return braced
	end,
	realted_talents = {
		"ogryn_bracing_reduces_damage_taken",
	},
}
templates.ogryn_carapace_armor_child = {
	class_name = "buff",
	max_stacks = 10,
	predicted = false,
	refresh_start_time_on_stack = true,
	stack_offset = -1,
	stat_buffs = {
		[stat_buffs.toughness_replenish_modifier] = 0.025,
		[stat_buffs.toughness_damage_taken_multiplier] = 0.975,
	},
	conditional_stat_buffs = {
		[stat_buffs.toughness_replenish_modifier] = 0.025,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local talent_extension = ScriptUnit.extension(unit, "talent_system")

		template_data.talent_extension = talent_extension
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local talent_extension = template_data.talent_extension
		local ogryn_carapace_armor_more_toughness_special_rule = talent_extension:has_special_rule(special_rules.ogryn_carapace_armor_more_toughness)

		return ogryn_carapace_armor_more_toughness_special_rule
	end,
}
templates.ogryn_carapace_armor_parent = {
	always_show_in_hud = true,
	child_buff_template = "ogryn_carapace_armor_child",
	class_name = "parent_proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_keystone_carapace_armor",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	predicted = false,
	restore_child_duration = 3,
	start_at_max = true,
	proc_events = {
		[proc_events.on_player_hit_received] = 1,
		[proc_events.on_push_finish] = 1,
		[proc_events.on_kill] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_push_finish] = 1,
	},
	remove_child_proc_events = {
		[proc_events.on_player_hit_received] = 1,
	},
	specific_check_proc_funcs = {
		[proc_events.on_player_hit_received] = function (params, template_data, template_context, t)
			if t < template_data.internal_cd_t then
				return false
			end

			if params.damage <= 0 and params.damage_absorbed <= 0 then
				return false
			end

			if not params.attack_result or params.attack_result == "blocked" then
				return
			end

			local attacking_unit = params.attacking_unit

			if attacking_unit then
				local unit_data_extension = ScriptUnit.has_extension(attacking_unit, "unit_data_system")
				local breed_name = unit_data_extension and unit_data_extension:breed_name()
				local breed = breed_name and Breeds[breed_name]
				local faction_name = breed and breed.faction_name

				if faction_name and faction_name == "imperium" then
					return
				end
			end

			template_data.internal_cd_t = t + 1

			return true
		end,
		[proc_events.on_push_finish] = function (params, template_data, template_context)
			local talent_extension = template_data.talent_extension
			local refresh_on_push = talent_extension:has_special_rule(special_rules.ogryn_carapace_armor_add_stack_on_push)

			return refresh_on_push and params.num_hit_units > 0
		end,
		[proc_events.on_kill] = function (params, template_data, template_context)
			local max_stacks = template_data.max_stacks - 3
			local child_stacks = template_data.num_child_stacks

			if child_stacks <= max_stacks then
				return
			end

			Managers.stats:record_private("hook_ogryn_feel_no_pain_kills_at_max", template_context.player)
		end,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local talent_extension = ScriptUnit.extension(unit, "talent_system")

		template_data.max_stacks = templates.ogryn_carapace_armor_child.max_stacks
		template_data.num_child_stacks = templates.ogryn_carapace_armor_child.max_stacks
		template_data.talent_extension = talent_extension
		template_data.internal_cd_t = 0
	end,
	on_stacks_removed_func = function (num_child_stacks, num_child_stacks_removed, t, template_data, template_context)
		template_data.num_child_stacks = num_child_stacks

		local talent_extension = template_data.talent_extension
		local trigger_on_zero_stack_special_rule = talent_extension:has_special_rule(special_rules.ogryn_carapace_armor_explosion_on_zero_stacks)
		local buff_extension = template_context.buff_extension
		local has_buff = buff_extension:has_unique_buff_id("ogryn_carapace_armor_explosion_on_zero_stacks_effect")
		local amount = talent_settings_shared.ogryn_carapace_explosion.stacks

		if trigger_on_zero_stack_special_rule and num_child_stacks <= amount and not has_buff then
			buff_extension:add_internally_controlled_buff("ogryn_carapace_armor_explosion_on_zero_stacks_effect", t)
		end
	end,
	realted_talents = {
		"ogryn_carapace_armor",
	},
}

local _toughness_ammount = talent_settings_shared.ogryn_carapace_explosion.toughness

templates.ogryn_carapace_armor_explosion_on_zero_stacks_effect = {
	class_name = "buff",
	duration = 30,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_carapace_armor_trigger_on_zero_stacks",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	inverse_duration_progress = true,
	predicted = false,
	unique_buff_id = "ogryn_carapace_armor_explosion_on_zero_stacks_effect",
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local world = template_context.world
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")
		local knocked_down_state_input = unit_data_extension:read_component("knocked_down_state_input")
		local should_knock_down = knocked_down_state_input.knock_down
		local should_or_is_knocked_down = should_knock_down or PlayerUnitStatus.is_knocked_down(character_state_component)
		local is_health_alive = HEALTH_ALIVE[unit]

		if is_health_alive and not should_or_is_knocked_down then
			Toughness.replenish_percentage(unit, _toughness_ammount, false, "talent_toughness_2")
		end

		local physics_world = World.physics_world(world)
		local explosion_template = ExplosionTemplates.ogryn_carapace_armor_explosion
		local power_level = DEFAULT_POWER_LEVEL
		local position = Unit.local_position(unit, 1)
		local attack_type = AttackSettings.attack_types.explosion

		Explosion.create_explosion(world, physics_world, position + Vector3.up(), nil, unit, explosion_template, power_level, 1, attack_type)
	end,
	related_talents = {
		"ogryn_carapace_armor_trigger_on_zero_stacks",
	},
}
templates.ogryn_increase_explosion_radius = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.explosion_radius_modifier] = 0.275,
	},
}
templates.ogryn_targets_recieve_damage_taken_increase_debuff = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_targets_recieve_damage_taken_increase_debuff",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = true,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_melee_hit, CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_non_kill),
	proc_func = function (params, template_data, template_context, t)
		if CheckProcFunctions.on_kill(params) then
			return
		end

		local victim_unit = params.attacked_unit
		local buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and buff_extension then
			local num_stacks = 1

			buff_extension:add_internally_controlled_buff_with_stacks("ogryn_recieve_damage_taken_increase_debuff", num_stacks, t, "owner_unit", template_context.unit)
		end
	end,
	related_talents = {
		"ogryn_targets_recieve_damage_taken_increase_debuff",
	},
}
templates.ogryn_recieve_damage_taken_increase_debuff = {
	class_name = "buff",
	duration = 5,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[stat_buffs.damage_taken_modifier] = 0.15,
	},
}
templates.ogryn_decrease_suppressed_decay = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.suppressor_decay_multiplier] = 0.5,
	},
}
templates.ogryn_block_cost_reduction = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.block_cost_multiplier] = 0.8,
	},
}
templates.ogryn_blocking_reduces_push_cost = {
	active_duration = 5,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_blocking_reduces_push_cost",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = true,
	proc_events = {
		[proc_events.on_block] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.push_cost_multiplier] = 0.8,
	},
	related_talents = {
		"ogryn_blocking_reduces_push_cost",
	},
}
templates.ogryn_empowered_push = {
	class_name = "proc_buff",
	cooldown_duration = 8,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_blocking_reduces_push_cost",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_push_finish] = 1,
	},
	conditional_stat_buffs = {
		[stat_buffs.push_impact_modifier] = 2.5,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_context.active
	end,
	proc_func = function (params, template_data, template_context, t)
		return
	end,
	related_talents = {
		"ogryn_blocking_reduces_push_cost",
	},
}
templates.ogryn_fully_charged_attacks_gain_damage_and_stagger = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_fully_charged_attacks_gain_damage_and_stagger",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = true,
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_sweep_finish] = 1,
	},
	conditional_stat_buffs = {
		[stat_buffs.melee_damage] = 0.4,
		[stat_buffs.melee_impact_modifier] = 0.4,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_fully_charged
	end,
	check_active_func = function (template_data, template_context)
		return template_data.is_fully_charged
	end,
	specific_proc_func = {
		[proc_events.on_sweep_start] = function (params, template_data, template_context)
			template_data.is_fully_charged = params.is_auto_completed
		end,
		[proc_events.on_sweep_finish] = function (params, template_data, template_context)
			template_data.is_fully_charged = false
		end,
	},
	related_talents = {
		"ogryn_fully_charged_attacks_gain_damage_and_stagger",
	},
}
templates.ogryn_charge_speed_on_lunge = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_ability_bull_rush",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 3,
	predicted = true,
	active_duration = talent_settings_2.combat_ability.active_duration,
	proc_events = {
		[proc_events.on_lunge_end] = talent_settings_2.combat_ability.on_lunge_end_proc_chance,
	},
	proc_stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings_2.combat_ability.movement_speed,
		[stat_buffs.melee_attack_speed] = talent_settings_2.combat_ability.melee_attack_speed,
	},
	related_talents = {
		"ogryn_charge",
	},
}
templates.ogryn_charge_bleed = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_lunge_start] = 1,
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.lunge_character_state_component = unit_data_extension:read_component("lunge_character_state")
		template_data.hit_units = {}
	end,
	specific_check_proc_funcs = {
		[proc_events.on_hit] = function (params, template_data)
			if not params.damage_type or params.damage_type ~= damage_types.ogryn_lunge or template_data.hit_units[params.attacked_unit] then
				return false
			end

			return true
		end,
	},
	specific_proc_func = {
		[proc_events.on_lunge_start] = function (params, template_data, template_context, t)
			table.clear(template_data.hit_units)
		end,
		[proc_events.on_hit] = function (params, template_data, template_context, t)
			local stacks = talent_settings_2.combat_ability_1.stacks
			local hit_unit = params.attacked_unit
			local hit_units = template_data.hit_units

			if HEALTH_ALIVE[hit_unit] and not hit_units[hit_unit] then
				local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

				if buff_extension then
					buff_extension:add_internally_controlled_buff_with_stacks("bleed", stacks, t, "owner_unit", template_context.unit)
				end

				hit_units[hit_unit] = true
			end
		end,
	},
}
templates.ogryn_charge_trample = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params)
		if not params.damage_type or params.damage_type ~= damage_types.ogryn_lunge then
			return false
		end

		return true
	end,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("ogryn_charge_trample_buff", t)
	end,
}
templates.ogryn_charge_trample_buff = {
	class_name = "buff",
	duration = 8,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_ability_charge_trample",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	max_stacks = 25,
	max_stacks_cap = 25,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[stat_buffs.damage] = 0.02,
	},
	related_talents = {
		"ogryn_charge_trample",
	},
}
templates.ogryn_base_lunge_toughness_and_damage_resistance = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.melee_heavy_damage] = talent_settings_2.passive_2.melee_heavy_damage,
		[stat_buffs.damage_taken_multiplier] = talent_settings_2.passive_2.damage_taken_multiplier,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_lunging,
}

local valid_help_interactions = {
	pull_up = true,
	remove_net = true,
	rescue = true,
	revive = true,
}

function _passive_revive_conditional(template_data, template_context)
	local is_interacting = template_data.interactor_extension:is_interacting()

	if is_interacting then
		local interaction = template_data.interactor_extension:interaction()
		local interaction_type = interaction:type()
		local is_helping = valid_help_interactions[interaction_type]

		return is_helping
	end
end

templates.ogryn_passive_revive = {
	class_name = "buff",
	predicted = false,
	conditional_keywords = {
		buff_keywords.uninterruptible,
	},
	conditional_stat_buffs = {
		[stat_buffs.push_speed_modifier] = -0.9,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local interactor_extension = ScriptUnit.extension(unit, "interactor_system")

		template_data.interactor_extension = interactor_extension
	end,
	conditional_keywords_func = _passive_revive_conditional,
	conditional_stat_buffs_func = _passive_revive_conditional,
}

local function _stagger_add_stamina(params, template_data, template_context)
	local stagger_result = params.stagger_result

	if not stagger_result == stagger_results.stagger then
		return
	end

	local stamina = talent_settings_2.passive_1.stamina

	Stamina.add_stamina_percent(template_context.unit, stamina)
end

templates.ogryn_passive_stagger = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_melee_stagger",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	stat_buffs = {
		[stat_buffs.melee_impact_modifier] = talent_settings_2.passive_1.impact_modifier,
	},
	related_talents = {
		"ogryn_melee_stagger",
	},
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_push_hit] = 1,
	},
	cooldown_duration = talent_settings_2.passive_1.cooldown,
	specific_proc_func = {
		on_hit = function (params, template_data, template_context, t)
			_stagger_add_stamina(params, template_data, template_context)
		end,
		on_push_hit = function (params, template_data, template_context, t)
			_stagger_add_stamina(params, template_data, template_context)
		end,
	},
}
templates.ogryn_increased_coherency_regen = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_regen_rate_modifier] = talent_settings_2.toughness_1.toughness_bonus,
	},
}
templates.ogryn_heavy_hits_toughness = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = talent_settings_2.toughness_2.on_sweep_finish_proc_chance,
	},
	proc_func = function (params, template_data, template_context)
		if params.num_hit_units ~= 1 then
			return
		end

		local heavy = params.is_heavy or params.melee_attack_strength == "heavy"
		local amount = heavy and talent_settings_2.toughness_2.toughness or talent_settings_2.toughness_2.reduced_toughness

		Toughness.replenish_percentage(template_context.unit, amount, false, "talent_toughness_2")
	end,
}
templates.ogryn_multiple_enemy_heavy_hits_restore_toughness = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = talent_settings_2.toughness_3.on_sweep_finish_proc_chance,
	},
	proc_func = function (params, template_data, template_context)
		if params.num_hit_units <= 1 then
			return
		end

		local heavy = params.is_heavy or params.melee_attack_strength == "heavy"
		local toughness = heavy and talent_settings_2.toughness_3.heavy_toughness or talent_settings_2.toughness_3.toughness

		Toughness.replenish_percentage(template_context.unit, toughness, false, "talent_toughness_3")
	end,
}
templates.ogryn_better_ogryn_fighting = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_vs_ogryn] = talent_settings_2.offensive_1.damage_vs_ogryn,
		[stat_buffs.damage_vs_chaos_plague_ogryn] = talent_settings_2.offensive_1.damage_vs_ogryn,
		[stat_buffs.damage_taken_by_chaos_plague_ogryn_multiplier] = talent_settings_2.offensive_1.ogryn_damage_taken_multiplier,
		[stat_buffs.ogryn_damage_taken_multiplier] = talent_settings_2.offensive_1.ogryn_damage_taken_multiplier,
	},
}
templates.ogryn_heavy_attacks_bleed = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_melee_hit, CheckProcFunctions.on_non_kill),
	proc_func = function (params, template_data, template_context, t)
		if CheckProcFunctions.on_kill(params) then
			return
		end

		local victim_unit = params.attacked_unit
		local buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and buff_extension then
			local is_heavy_hit = CheckProcFunctions.on_heavy_hit(params)
			local num_stacks = is_heavy_hit and talent_settings_2.offensive_3.stacks or talent_settings_2.offensive_3.light_stacks

			buff_extension:add_internally_controlled_buff_with_stacks("bleed", num_stacks, t, "owner_unit", template_context.unit)
		end
	end,
}

local external_properties = {}

templates.ogryn_friend_grenade_replenishment = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_blitz_big_friendly_rock_replenish",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_blitz",
	hud_priority = 4,
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
		template_data.fx_extension = ScriptUnit.extension(unit, "fx_system")
		template_data.first_person_extension = ScriptUnit.extension(unit, "first_person_system")
		template_data.missing_charges = 0
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if not template_data.ability_extension then
			local unit = template_context.unit
			local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

			if not ability_extension then
				return
			end

			template_data.ability_extension = ability_extension
		end

		local ability_extension = template_data.ability_extension

		if not ability_extension or not ability_extension:has_ability_type("grenade_ability") then
			template_data.next_grenade_t = nil
			template_data.missing_charges = 0

			return
		end

		local missing_charges = ability_extension and ability_extension:missing_ability_charges("grenade_ability")

		if missing_charges == 0 then
			template_data.next_grenade_t = nil
			template_data.missing_charges = 0

			return
		end

		template_data.missing_charges = missing_charges

		local next_grenade_t = template_data.next_grenade_t

		if not next_grenade_t then
			local cooldown = ability_extension:max_ability_cooldown("grenade_ability")

			template_data.next_grenade_t = t + cooldown
			template_data.cooldown = cooldown

			return
		end

		if next_grenade_t < t then
			template_data.next_grenade_t = nil

			local first_person_extension = template_data.first_person_extension

			if first_person_extension and first_person_extension:is_in_first_person_mode() then
				external_properties.indicator_type = "ogryn_grenade_friend_rock"

				template_data.fx_extension:trigger_gear_wwise_event("grenade_recover_indicator", external_properties)
			end
		end
	end,
	check_active_func = function (template_data, template_context)
		local is_missing_charges = template_data.missing_charges > 0

		return is_missing_charges
	end,
	duration_func = function (template_data, template_context)
		local next_grenade_t = template_data.next_grenade_t

		if not next_grenade_t then
			return 1
		end

		local t = FixedFrame.get_latest_fixed_time()
		local time_until_next = next_grenade_t - t
		local percentage_left = time_until_next / template_data.cooldown

		return 1 - percentage_left
	end,
	related_talents = {
		"ogryn_grenade_friend_rock",
	},
}
templates.ogryn_frag_grenade_thrown = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_grenade_thrown] = 1,
	},
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local t = FixedFrame.get_latest_fixed_time()
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		local buff_name = "ogryn_kills_during_frag_grenade"

		buff_extension:add_internally_controlled_buff(buff_name, t, "owner_unit", template_context.unit)
	end,
}
templates.ogryn_kills_during_frag_grenade = {
	class_name = "proc_buff",
	duration = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_minion_death] = 1,
	},
	proc_func = function (params, template_data, template_context)
		if params.damage_type == "grenade_frag" then
			template_data.amount_killed = template_data.amount_killed + 1
		end
	end,
	start_func = function (template_data, template_context)
		template_data.amount_killed = 0
		template_data.achievement_target_amount = 25
	end,
	stop_func = function (template_data, template_context)
		if template_data.amount_killed >= template_data.achievement_target_amount then
			Managers.stats:record_private("hook_ogryn_frag_grenade", template_context.player)
		end
	end,
}
templates.ogryn_bigger_coherency_radius = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.coherency_radius_modifier] = talent_settings_2.coop_1.coherency_aura_size_increase,
	},
}
templates.ogryn_charge_grants_allied_movement_speed = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_combat_ability] = talent_settings_2.coop_2.on_lunge_start_proc_chance,
	},
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local coherency_extension = ScriptUnit.has_extension(unit, "coherency_system")

		if coherency_extension then
			local units_in_coherence = coherency_extension:in_coherence_units()
			local movement_speed_buff = "ogryn_allied_movement_speed_buff"
			local t = FixedFrame.get_latest_fixed_time()

			for coherency_unit, _ in pairs(units_in_coherence) do
				local coherency_buff_extension = ScriptUnit.extension(coherency_unit, "buff_system")

				coherency_buff_extension:add_internally_controlled_buff(movement_speed_buff, t, "owner_unit", unit)
			end
		end
	end,
}
templates.ogryn_allied_movement_speed_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_ally_movement_boost_on_ability",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = true,
	refresh_duration_on_stack = true,
	duration = talent_settings_2.coop_2.duration,
	buff_category = buff_categories.talents_secondary,
	max_stacks = talent_settings_2.coop_2.max_stacks,
	stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings_2.coop_2.movement_speed,
	},
	keywords = {
		buff_keywords.stun_immune,
		buff_keywords.suppression_immune,
	},
	related_talents = {
		"ogryn_ally_movement_boost_on_ability",
	},
}
templates.ogryn_coherency_increased_melee_damage = {
	class_name = "buff",
	coherency_id = "ogryn_coherency_aura",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_aura_intimidating_presence",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 5,
	predicted = false,
	buff_category = buff_categories.aura,
	max_stacks = talent_settings_2.coherency.max_stacks,
	keywords = {},
	stat_buffs = {
		[stat_buffs.melee_heavy_damage] = talent_settings_2.coherency.melee_damage,
	},
	related_talents = {
		"ogryn_melee_damage_coherency",
	},
}
templates.ogryn_melee_damage_coherency_improved = {
	class_name = "buff",
	coherency_id = "ogryn_coherency_aura_improved",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_aura_bonebreakers_aura",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 5,
	predicted = false,
	buff_category = buff_categories.aura,
	max_stacks = talent_settings_2.coherency.max_stacks,
	keywords = {},
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings_2.coherency.melee_damage_improved,
	},
	start_func = _penance_start_func("ogryn_heavy_kills_in_coherency_tracking_buff"),
	related_talents = {
		"ogryn_melee_damage_coherency_improved",
	},
}
templates.ogryn_heavy_kills_in_coherency_tracking_buff = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.last_num_in_coherency = 0
		template_data.valid_buff_owners = {}
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if unit ~= params.attacking_unit then
			return
		end

		local melee_attack_strength = params.melee_attack_strength

		if melee_attack_strength == "heavy" then
			local hook_name = "hook_ogryn_heavy_aura_kills"
			local parent_buff_name = "ogryn_melee_damage_coherency_improved"

			template_data.last_num_in_coherency, template_data.valid_buff_owners = template_data.coherency_extension:evaluate_and_send_achievement_data(template_data.last_num_in_coherency, template_data.valid_buff_owners, parent_buff_name, hook_name)
		end
	end,
}
templates.ogryn_cooldown_on_elite_kills_by_coherence = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_minion_death] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		local breed_name = params.breed_name
		local breed = breed_name and Breeds[breed_name]

		if not breed or not breed.tags or not breed.tags.elite then
			return
		end

		local attacker_unit = params.attacking_unit
		local unit = template_context.unit
		local coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		local units_in_coherence = coherency_extension:in_coherence_units()

		if not units_in_coherence[attacker_unit] then
			return
		end

		local ability_extension = ScriptUnit.has_extension(unit, "ability_system")
		local ability_type = "combat_ability"

		if not ability_extension or not ability_extension:has_ability_type(ability_type) then
			return
		end

		template_context.buff_extension:add_internally_controlled_buff("ogryn_cooldown_on_elite_kills_buff", t)
	end,
}
templates.ogryn_cooldown_on_elite_kills_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_ally_elite_kills_grant_cooldown",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings_2.coop_3.duration,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
	end,
	update_func = function (template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		if not template_data.timer then
			template_data.timer = t + 1
		end

		if t > template_data.timer then
			template_data.timer = t + 1

			template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", talent_settings_2.coop_3.increased_cooldown_regeneration)
		end
	end,
	related_talents = {
		"ogryn_ally_elite_kills_grant_cooldown",
	},
}

local bleed_dr_max_stacks = talent_settings_2.defensive_1.max_stacks
local bleed_range = DamageSettings.in_melee_range

templates.ogryn_reduce_damage_taken_per_bleed = {
	always_show_in_hud = true,
	class_name = "buff",
	hud_always_show_stacks = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_nearby_bleeds_reduce_damage_taken",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = {
			min = talent_settings_2.defensive_1.min,
			max = talent_settings_2.defensive_1.max,
		},
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase
		template_data.broadphase_results = {}
		template_data.num_stacks = 0

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")
		local t = FixedFrame.get_latest_fixed_time()

		template_data.next_bleed_check_t = t + talent_settings_2.defensive_1.time
		template_data.enemy_side_names = enemy_side_names
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local next_bleed_check_t = template_data.next_bleed_check_t

		if next_bleed_check_t < t then
			local player_unit = template_context.unit
			local player_position = POSITION_LOOKUP[player_unit]
			local broadphase = template_data.broadphase
			local enemy_side_names = template_data.enemy_side_names
			local broadphase_results = template_data.broadphase_results

			table.clear(broadphase_results)

			local num_stacks = 0
			local num_hits = broadphase.query(broadphase, player_position, bleed_range, broadphase_results, enemy_side_names)

			for i = 1, num_hits do
				local enemy_unit = broadphase_results[i]
				local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

				if buff_extension then
					local target_is_bleeding = buff_extension:has_keyword(buff_keywords.bleeding)

					if target_is_bleeding then
						num_stacks = num_stacks + 1
					end
				end
			end

			template_data.num_stacks = num_stacks
			template_data.next_bleed_check_t = t + talent_settings_2.defensive_1.time
		end

		return math.clamp(template_data.num_stacks / bleed_dr_max_stacks, 0, 1)
	end,
	visual_stack_count = function (template_data, template_context)
		return math.clamp(template_data.num_stacks, 0, bleed_dr_max_stacks)
	end,
	related_talents = {
		"ogryn_nearby_bleeds_reduce_damage_taken",
	},
}

local reduced_damage_distance = talent_settings_2.defensive_2.distance * talent_settings_2.defensive_2.distance

templates.ogryn_reduce_damage_taken_on_disabled_allies = {
	class_name = "buff",
	hud_always_show_stacks = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_knocked_allies_grant_damage_reduction",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = {
			min = talent_settings_2.defensive_2.min,
			max = talent_settings_2.defensive_2.max,
		},
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]

		template_data.side = side
		template_data.lerp_t = 0

		local t = Managers.time:time("gameplay")

		template_data.update_t = t + 0.1
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		if t > template_data.update_t then
			local max_players = 3
			local player_units = template_data.side.valid_player_units
			local valid_units = 0
			local unit = template_context.unit
			local pos = POSITION_LOOKUP[unit]

			for i = 1, #player_units do
				local player_unit = player_units[i]

				if player_unit ~= unit then
					local player_pos = POSITION_LOOKUP[player_unit]
					local distance = Vector3.distance_squared(pos, player_pos)

					if distance < reduced_damage_distance then
						local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
						local character_state_component = unit_data_extension:read_component("character_state")
						local requires_help = PlayerUnitStatus.requires_help(character_state_component)

						if requires_help then
							valid_units = valid_units + 1
						end
					end
				end
			end

			template_data.lerp_t = valid_units / max_players
			template_data.update_t = t + 0.1
		end

		return template_data.lerp_t
	end,
	check_active_func = function (template_data, template_context)
		return template_data.lerp_t > 0
	end,
	visual_stack_count = function (template_data, template_context)
		local stack_count = math.floor(template_data.lerp_t * 3 + 0.5)

		return stack_count
	end,
	related_talents = {
		"ogryn_knocked_allies_grant_damage_reduction",
	},
}

local increased_toughness_health_threshold = talent_settings_2.defensive_3.increased_toughness_health_threshold

templates.ogryn_increased_toughness_at_low_health = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_toughness_on_low_health",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.toughness_replenish_modifier] = talent_settings_2.defensive_3.toughness_replenish_modifier,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local unit = template_context.unit
		local health_extension = ScriptUnit.has_extension(unit, "health_system")

		if health_extension then
			local current_health_percent = health_extension:current_health_percent()

			return current_health_percent < increased_toughness_health_threshold
		end
	end,
	related_talents = {
		"ogryn_toughness_on_low_health",
	},
}

local breed_name_size = {
	chaos_armored_infected = 1,
	chaos_beast_of_nurgle = 10,
	chaos_daemonhost = 8,
	chaos_hound = 3,
	chaos_hound_mutator = 3,
	chaos_lesser_mutated_poxwalker = 1,
	chaos_mutated_poxwalker = 1,
	chaos_mutator_daemonhost = 8,
	chaos_mutator_ritualist = 1,
	chaos_newly_infected = 1,
	chaos_ogryn_bulwark = 5,
	chaos_ogryn_executor = 5,
	chaos_ogryn_gunner = 5,
	chaos_plague_ogryn = 10,
	chaos_poxwalker = 1,
	chaos_poxwalker_bomber = 2,
	chaos_spawn = 10,
	cultist_assault = 1,
	cultist_berzerker = 3,
	cultist_captain = 8,
	cultist_flamer = 2,
	cultist_grenadier = 2,
	cultist_gunner = 2,
	cultist_melee = 1,
	cultist_mutant = 5,
	cultist_mutant_mutator = 5,
	cultist_ritualist = 1,
	cultist_shocktrooper = 2,
	renegade_assault = 1,
	renegade_berzerker = 3,
	renegade_captain = 8,
	renegade_executor = 3,
	renegade_flamer = 2,
	renegade_grenadier = 2,
	renegade_gunner = 2,
	renegade_melee = 1,
	renegade_netgunner = 2,
	renegade_rifleman = 1,
	renegade_shocktrooper = 2,
	renegade_sniper = 1,
	renegade_twin_captain = 2,
	renegade_twin_captain_two = 2,
}

function _big_bull_add_stacks(template_context, stacks)
	local unit = template_context.unit
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if buff_extension then
		local t = FixedFrame.get_latest_fixed_time()

		for i = 1, stacks do
			buff_extension:add_internally_controlled_buff("ogryn_big_bully_heavy_hits_buff", t)
		end
	end
end

templates.ogryn_big_bully_heavy_hits = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_sweep_finish] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.stacks = 0
	end,
	specific_proc_func = {
		on_sweep_start = function (params, template_data, template_context)
			template_data.in_sweep = params.is_heavy
		end,
		on_hit = function (params, template_data, template_context)
			local stagger_result = params.stagger_result

			if stagger_result ~= stagger_results.stagger then
				return
			end

			local breed_name = params.breed_name
			local stacks = breed_name_size[breed_name] or 0

			if not template_data.in_sweep then
				_big_bull_add_stacks(template_context, stacks)

				return
			end

			template_data.stacks = template_data.stacks + stacks
		end,
		on_sweep_finish = function (params, template_data, template_context)
			template_data.sweep_done = true
			template_data.in_sweep = nil
		end,
	},
	update_func = function (template_data, template_context, dt, t)
		if template_data.sweep_done then
			template_data.sweep_done = nil
			template_data.delay = 0.1
		end

		if not template_data.delay then
			return
		end

		if template_data.delay > 0 then
			template_data.delay = template_data.delay - dt

			return
		end

		if template_data.delay <= 0 then
			local stacks = template_data.stacks or 0

			_big_bull_add_stacks(template_context, stacks)

			template_data.stacks = 0
			template_data.delay = nil
		end
	end,
}
templates.ogryn_big_bully_heavy_hits_buff = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_staggering_increases_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings_2.offensive_2_2.duration,
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_sweep_finish] = 1,
	},
	stat_buffs = {
		[stat_buffs.melee_heavy_damage] = talent_settings_2.offensive_2_2.melee_heavy_damage,
	},
	max_stacks = talent_settings_2.offensive_2_2.max_stacks,
	specific_proc_func = {
		on_sweep_start = function (params, template_data, template_context)
			template_data.can_finish = params.is_heavy
			template_data.finished = nil
		end,
		on_sweep_finish = function (params, template_data, template_context)
			template_data.finished = true
		end,
	},
	conditional_exit_func = function (template_data, template_context)
		return template_data.can_finish and template_data.finished
	end,
	realated_talents = {
		"ogryn_staggering_increases_damage",
	},
}
templates.ogryn_melee_revenge_damage = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_player_hit_received] = 1,
		[proc_events.on_successful_dodge] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local dodge = not params.damage
		local damage = params.damage or 0
		local damage_absorbed = params.damage_absorbed or 0
		local add_buff = damage > 0 or damage_absorbed > 0

		add_buff = add_buff or dodge

		if add_buff then
			local t = FixedFrame.get_latest_fixed_time()

			template_data.buff_extension:add_internally_controlled_buff("ogryn_melee_revenge_damage_buff", t)
		end
	end,
}
templates.ogryn_melee_revenge_damage_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_revenge_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings_2.offensive_2_1.damage,
	},
	duration = talent_settings_2.offensive_2_1.time,
	related_talents = {
		"ogryn_revenge_damage",
	},
}
templates.ogryn_hitting_multiple_with_melee_grants_melee_damage_bonus = {
	class_name = "proc_buff",
	force_predicted_proc = true,
	hud_always_show_stacks = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_more_hits_more_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = talent_settings_2.offensive_2_3.on_sweep_finish_proc_chance,
	},
	lerped_stat_buffs = {
		[stat_buffs.melee_damage] = {
			min = 0,
			max = talent_settings_2.offensive_2_3.melee_damage * talent_settings_2.offensive_2_3.max_targets,
		},
	},
	specific_proc_func = {
		on_sweep_finish = function (params, template_data, template_context)
			local hits = params.num_hit_units

			template_data.hits = hits
		end,
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local hits = template_data.hits or 0
		local max_hits = talent_settings_2.offensive_2_3.max_targets

		return math.clamp(hits / max_hits, 0, 1)
	end,
	visual_stack_count = function (template_data, template_context)
		local hits = template_data.hits or 0
		local number_of_stacks = math.clamp(hits, 0, talent_settings_2.offensive_2_3.max_targets)

		return number_of_stacks
	end,
	check_active_func = function (template_data, template_context)
		local hits = template_data.hits or 0
		local show = hits > 0

		return show
	end,
	related_talents = {
		"ogryn_more_hits_more_damage",
	},
}
templates.ogryn_bull_rush_hits_replenish_toughness = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.lunge_character_state_component = unit_data_extension:read_component("lunge_character_state")
	end,
	check_proc_func = function (params)
		if not params.damage_type or params.damage_type ~= damage_types.ogryn_lunge then
			return false
		end

		return true
	end,
	proc_func = function (params, template_data, template_context)
		local is_lunging = template_data.lunge_character_state_component.is_lunging

		if not is_lunging then
			return
		end

		Toughness.replenish_percentage(template_context.unit, talent_settings_2.combat_ability_3.toughness, false, "bull_rush_toughness_talent")
	end,
}

local stance_duration = 10

templates.ogryn_ranged_stance = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_ability_speshul_ammo",
	predicted = true,
	unique_buff_id = "ogryn_ranged_stance",
	duration = stance_duration,
	keywords = {
		buff_keywords.ogryn_combat_ability_stance,
	},
	stat_buffs = {
		[stat_buffs.ranged_attack_speed] = 0.25,
		[stat_buffs.reload_speed] = 0.65,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local talent_extension = ScriptUnit.extension(unit, "talent_system")
		local t = FixedFrame.get_latest_fixed_time()
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.cooldown_time = t + stance_duration
		template_data.evaluate_max_stacks_stat = false
		template_data.amount_killed = 0
		template_data.penance_threshold = 15

		local no_movement_penalty = special_rules.ogryn_combat_no_movement_penalty

		if talent_extension:has_special_rule(no_movement_penalty) then
			local buff_name = "ogryn_ranged_stance_no_movement_penalty_buff"

			buff_extension:add_internally_controlled_buff(buff_name, t)
		end

		local fire_shots = special_rules.ogryn_ranged_stance_fire_shots

		if talent_extension:has_special_rule(fire_shots) then
			local buff_name = "ogryn_ranged_stance_fire_shots"

			buff_extension:add_internally_controlled_buff(buff_name, t)
		end

		local armor_piercing_shots = special_rules.ogryn_combat_armor_pierce

		if talent_extension:has_special_rule(armor_piercing_shots) then
			local buff_name = "ogryn_ranged_stance_armor_pierce"

			buff_extension:add_internally_controlled_buff(buff_name, t)
		end

		local toughness_regen = special_rules.ogryn_ranged_stance_toughness_regen

		if talent_extension:has_special_rule(toughness_regen) then
			local buff_name = "ogryn_ranged_stance_toughness_regen"

			buff_extension:add_internally_controlled_buff(buff_name, t)
		end

		local buff_name = "ogryn_kills_during_barrage"

		buff_extension:add_internally_controlled_buff(buff_name, t)

		template_data.evaluate_max_stacks_stat = true
	end,
	related_talents = {
		"ogryn_special_ammo_movement",
	},
}
templates.ogryn_kills_during_barrage = {
	class_name = "proc_buff",
	duration = 11,
	predicted = false,
	proc_events = {
		[proc_events.on_minion_death] = 1,
	},
	proc_func = function (params, template_data, template_context)
		template_data.amount_killed = template_data.amount_killed + 1
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.amount_killed = 0
		template_data.target_amount = 25
		template_data.triggered = false
		template_data.talent_extension = ScriptUnit.extension(unit, "talent_system")
		template_data.buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if not template_data.triggered and template_data.amount_killed >= template_data.target_amount then
			Managers.stats:record_private("hook_ogryn_barrage_end", template_context.player)

			template_data.triggered = true
		end
	end,
}
templates.ogryn_increased_ammo_reserve_passive = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.ammo_reserve_capacity] = talent_settings_1.passive_3.increased_max_ammo,
	},
}
templates.ogryn_leadbelcher_aura_tracking_buff = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_ammo_consumed] = 1,
	},
	proc_func = function (params, template_data, template_context)
		if params.is_leadbelcher_shot then
			Managers.stats:record_private("hook_ogryn_leadbelcher_free_shot", template_context.player)
		end
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.talent_extension = ScriptUnit.extension(unit, "talent_system")
		template_data.buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	end,
}
templates.ogryn_passive_proc_combat_ability_cooldown_reduction = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_ammo_consumed] = 1,
	},
	proc_func = function (params, template_data, template_context)
		local talent_extension = template_data.talent_extension

		if params.is_leadbelcher_shot then
			local t = FixedFrame.get_latest_fixed_time()

			template_data.buff_extension:add_internally_controlled_buff("ogryn_no_ammo_consumption_passive_cooldown_buff", t)
		end
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.talent_extension = ScriptUnit.extension(unit, "talent_system")
		template_data.buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	end,
}
templates.ogryn_no_ammo_consumption_passive_cooldown_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_leadbelcher_cooldown_reduction",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings_1.spec_passive_1.duration,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
	end,
	update_func = function (template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		if not template_data.timer then
			template_data.timer = t + 1
		end

		if t > template_data.timer then
			template_data.timer = t + 1

			template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", talent_settings_1.spec_passive_1.increased_cooldown_regeneration)
		end
	end,
	related_talents = {
		"ogryn_leadbelcher_cooldown_reduction",
	},
}
templates.ogryn_aura_increased_damage_vs_suppressed = {
	class_name = "buff",
	coherency_id = "ogryn_aura_increased_damage_vs_suppressed",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_aura_bringing_big_guns",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 5,
	max_stacks = 1,
	predicted = false,
	buff_category = buff_categories.aura,
	stat_buffs = {
		[stat_buffs.damage_vs_suppressed] = 0.2,
	},
	start_func = _penance_start_func("ogryn_suppressed_kills_aura_tracking_buff"),
	related_talents = {
		"ogryn_damage_vs_suppressed_coherency",
	},
}
templates.ogryn_suppressed_kills_aura_tracking_buff = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.last_num_in_coherency = 0
		template_data.valid_buff_owners = {}
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.killed_unit_was_supressed = Suppression.is_suppressed(params.attacked_unit)

		if not template_data.killed_unit_was_supressed then
			return
		end

		local unit = template_context.unit

		if unit ~= params.attacking_unit then
			return
		end

		local hook_name = "hook_ogryn_suppressed_aura_kills"
		local parent_buff_name = "ogryn_damage_vs_suppressed_coherency"

		template_data.last_num_in_coherency, template_data.valid_buff_owners = template_data.coherency_extension:evaluate_and_send_achievement_data(template_data.last_num_in_coherency, template_data.valid_buff_owners, parent_buff_name, hook_name)
	end,
}
templates.ogryn_increased_damage_after_reload = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_reloading_grants_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	active_duration = talent_settings_1.mixed_1.duration,
	proc_events = {
		[proc_events.on_reload] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.ranged_damage] = talent_settings_1.mixed_1.damage_after_reload,
	},
	related_talents = {
		"ogryn_reloading_grants_damage",
	},
}
templates.ogryn_increased_clip_size = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.clip_size_modifier] = talent_settings_1.mixed_3.increased_clip_size,
	},
}
templates.ogryn_crit_chance_on_kill = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

		if buff_extension then
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff("ogryn_crit_chance_on_kill_effect", t)
		end
	end,
	check_proc_func = CheckProcFunctions.on_kill,
}
templates.ogryn_crit_chance_on_kill_effect = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_kills_grant_crit_chance",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings_1.offensive_1.duration,
	max_stacks = talent_settings_1.offensive_1.max_stacks,
	max_stacks_cap = talent_settings_1.offensive_1.max_stacks,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings_1.offensive_1.crit_chance_on_kill,
	},
	related_talents = {
		"ogryn_kills_grant_crit_chance",
	},
}
templates.ogryn_increased_suppression = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.suppression_dealt] = talent_settings_1.offensive_2.increased_suppression,
	},
}
templates.ogryn_increased_reload_speed_on_multiple_hits = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.hit_units = {}
		template_data.num_hit_units = 0
		template_data.num_hits_required = talent_settings_1.offensive_3.num_multi_hit
		template_data.multi_hit_window = talent_settings_1.offensive_3.multi_hit_window
	end,
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()
		local hit_units = template_data.hit_units
		local unit = params.attacked_unit
		local num_hit_units = template_data.num_hit_units

		if not hit_units[unit] then
			num_hit_units = num_hit_units + 1
			template_data.num_hit_units = num_hit_units
		end

		hit_units[unit] = t + template_data.multi_hit_window

		if num_hit_units > 0 then
			for hit_unit, unit_t in pairs(hit_units) do
				if unit_t < t then
					template_data.num_hit_units = template_data.num_hit_units - 1
					hit_units[hit_unit] = nil
				end
			end
		end

		local add_buff = template_data.num_hit_units >= template_data.num_hits_required

		if add_buff then
			local player_unit = template_context.unit
			local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
			local reload_buff = "ogryn_increased_reload_speed_on_multiple_hits_effect"

			buff_extension:add_internally_controlled_buff(reload_buff, t)
		end
	end,
}
templates.ogryn_increased_reload_speed_on_multiple_hits_effect = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_multi_hits_grant_reload_speed",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_reload] = 1,
	},
	stat_buffs = {
		[stat_buffs.reload_speed] = talent_settings_1.offensive_3.reload_speed_on_multi_hit,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")

		template_data.weapon_action_component = unit_data_extension:read_component("weapon_action")
		template_data.inventory_component = unit_data_extension:read_component("inventory")
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.done = true
	end,
	conditional_exit_func = function (template_data, template_context)
		local inventory_component = template_data.inventory_component
		local visual_loadout_extension = template_data.visual_loadout_extension
		local wielded_slot_id = inventory_component.wielded_slot
		local weapon_template = visual_loadout_extension:weapon_template_from_slot(wielded_slot_id)
		local _, current_action = Action.current_action(template_data.weapon_action_component, weapon_template)
		local action_kind = current_action and current_action.kind
		local is_reloading = action_kind and (action_kind == "reload_shotgun" or action_kind == "reload_state" or action_kind == "ranged_load_special")

		return template_data.done and not is_reloading
	end,
	related_talents = {
		"ogryn_multi_hits_grant_reload_speed",
	},
}
templates.ogryn_movement_speed_on_ranged_kill = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_movement_speed_after_ranged_kills",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = true,
	active_duration = talent_settings_1.defensive_2.duration,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings_1.defensive_2.move_speed_on_ranged_kill,
	},
	check_proc_func = CheckProcFunctions.on_ranged_kill,
	related_talents = {
		"ogryn_movement_speed_after_ranged_kills",
	},
}
templates.ogryn_regen_toughness_on_braced = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_toughness_while_bracing",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local weapon_component = unit_data_extension:read_component("weapon_action")
		local braced = PlayerUnitAction.has_current_action_keyword(weapon_component, "braced")

		template_data.braced = braced

		if braced then
			Toughness.replenish_percentage(unit, talent_settings_1.defensive_3.braced_toughness_regen * dt)
		end
	end,
	check_active_func = function (template_data, template_context)
		return template_data.braced
	end,
	related_talents = {
		"ogryn_toughness_while_bracing",
	},
}
templates.ogryn_ranged_stance_no_movement_penalty_buff = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	duration = stance_duration,
	proc_events = {
		[proc_events.on_wield_ranged] = 1,
		[proc_events.on_wield_melee] = 1,
	},
	conditional_stat_buffs = {
		[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = talent_settings_1.combat_ability_3.reduced_move_penalty,
		[stat_buffs.weapon_action_movespeed_reduction_multiplier] = talent_settings_1.combat_ability_3.reduced_move_penalty,
		[stat_buffs.damage_near] = talent_settings_1.combat_ability_3.increased_damage_vs_close,
	},
	start_func = function (template_data, template_context)
		template_data.wielding_ranged = true
	end,
	specific_proc_func = {
		on_wield_ranged = function (params, template_data, template_context)
			template_data.wielding_ranged = true
		end,
		on_wield_melee = function (params, template_data, template_context)
			template_data.wielding_ranged = false
		end,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.wielding_ranged
	end,
}
templates.ogryn_ranged_stance_toughness_regen = {
	class_name = "proc_buff",
	predicted = false,
	duration = stance_duration,
	proc_events = {
		[proc_events.on_shoot] = 1,
		[proc_events.on_shoot_projectile] = 1,
		[proc_events.on_reload] = 1,
	},
	specific_proc_func = {
		on_shoot = function (params, template_data, template_context)
			Toughness.replenish_percentage(template_context.unit, 0.02, false, "ogryn_ranged_stance_shoot")
		end,
		on_shoot_projectile = function (params, template_data, template_context)
			Toughness.replenish_percentage(template_context.unit, 0.02, false, "ogryn_ranged_stance_shoot")
		end,
		on_reload = function (params, template_data, template_context)
			Toughness.replenish_percentage(template_context.unit, 0.1, false, "ogryn_ranged_stance_reload")
		end,
	},
}
templates.ogryn_ranged_stance_armor_pierce = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	duration = stance_duration,
	proc_events = {
		[proc_events.on_wield_ranged] = 1,
		[proc_events.on_wield_melee] = 1,
	},
	conditional_stat_buffs = {
		[stat_buffs.ranged_rending_multiplier] = talent_settings_shared.special_ammo_armor_pen.rending_multiplier,
		[stat_buffs.ranged_damage] = talent_settings_shared.special_ammo_armor_pen.damage,
	},
	start_func = function (template_data, template_context)
		template_data.wielding_ranged = true
	end,
	specific_proc_func = {
		on_wield_ranged = function (params, template_data, template_context)
			template_data.wielding_ranged = true
		end,
		on_wield_melee = function (params, template_data, template_context)
			template_data.wielding_ranged = false
		end,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return true
	end,
}

local fire_targets_hit = {}
local burning_buff = "flamer_assault"
local max_burn_stacks = talent_settings_1.combat_ability_1.max_stacks

templates.ogryn_ranged_stance_fire_shots = {
	class_name = "proc_buff",
	duration = 10,
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_shoot] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.new_shot = true
	end,
	specific_proc_func = {
		on_hit = function (params, template_data, template_context, t)
			if not CheckProcFunctions.on_ranged_hit(params, template_data, template_context, t) or not CheckProcFunctions.attacked_unit_is_minion(params, template_data, template_context, t) then
				return
			end

			local attacked_unit = params.attacked_unit

			if fire_targets_hit[attacked_unit] then
				return
			end

			fire_targets_hit[attacked_unit] = true

			if ALIVE[attacked_unit] then
				local buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

				if buff_extension then
					local damage_profile = params.damage_profile
					local current_stacks = buff_extension:current_stacks(burning_buff)

					if current_stacks < max_burn_stacks then
						local num_stacks = damage_profile.ogryn_ranged_stance_fire_shots_override or talent_settings_1.combat_ability_1.num_stacks

						num_stacks = num_stacks > max_burn_stacks - current_stacks and max_burn_stacks - current_stacks or num_stacks

						buff_extension:add_internally_controlled_buff_with_stacks(burning_buff, num_stacks, t, "owner_unit", template_context.unit)
					else
						buff_extension:refresh_duration_of_stacking_buff(burning_buff, t)
					end
				end
			end
		end,
		on_shoot = function (params, template_data, template_context)
			table.clear(fire_targets_hit)
		end,
	},
}

local ogryn_explosions_burn_blacklist = {
	powermaul_explosion = true,
}
local max_burn_stacks_explosions = talent_settings_shared.explosions_burn.max_stacks

templates.ogryn_explosions_burn = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_non_kill, CheckProcFunctions.on_explosion_hit),
	proc_func = function (params, template_data, template_context, t)
		local attacked_unit = params.attacked_unit

		if HEALTH_ALIVE[attacked_unit] and params.damage_profile then
			local damage_profile_name = params.damage_profile.name

			if not ogryn_explosions_burn_blacklist[damage_profile_name] then
				local buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

				if buff_extension then
					local current_stacks = buff_extension:current_stacks(burning_buff)

					if current_stacks < max_burn_stacks_explosions then
						local close_hit = params.close_explosion_hit
						local num_stacks = close_hit and talent_settings_shared.explosions_burn.close_stacks or talent_settings_shared.explosions_burn.stacks

						num_stacks = num_stacks > max_burn_stacks_explosions - current_stacks and max_burn_stacks_explosions - current_stacks or num_stacks

						buff_extension:add_internally_controlled_buff_with_stacks(burning_buff, num_stacks, t, "owner_unit", template_context.unit)
					else
						buff_extension:refresh_duration_of_stacking_buff(burning_buff, t)
					end
				end
			end
		end
	end,
}
templates.ogryn_frag_bomb_bleed = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_non_kill, CheckProcFunctions.on_explosion_hit),
	proc_func = function (params, template_data, template_context, t)
		local damage_profile = params.damage_profile
		local damage_profile_name = damage_profile and damage_profile.name

		if damage_profile_name ~= "ogryn_grenade" and damage_profile_name ~= "close_ogryn_grenade" then
			return
		end

		local hit_unit = params.attacked_unit
		local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

		if HEALTH_ALIVE[hit_unit] and buff_extension then
			local unit = template_context.unit
			local num_stacks = talent_settings_shared.frag_bomb_bleed.stacks

			buff_extension:add_internally_controlled_buff_with_stacks("bleed", num_stacks, t, "owner_unit", unit)
		end
	end,
}
templates.ogryn_windup_increases_power_parent = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_windup_trigger] = 1,
		[proc_events.on_sweep_start] = 1,
	},
	specific_proc_func = {
		[proc_events.on_sweep_start] = function (params, template_data, template_context, t)
			if not params.is_auto_completed then
				return
			end

			local current_stacks = template_context.buff_extension:current_stacks("ogryn_windup_increases_power_child")
			local max_stacks = talent_settings_shared.ogryn_thrust.max_stacks

			if current_stacks < max_stacks then
				local stacks = max_stacks - current_stacks

				template_context.buff_extension:add_internally_controlled_buff_with_stacks("ogryn_windup_increases_power_child", stacks, t)
			end
		end,
		[proc_events.on_windup_trigger] = function (params, template_data, template_context, t)
			template_context.buff_extension:add_internally_controlled_buff("ogryn_windup_increases_power_child", t)
		end,
	},
}
templates.ogryn_windup_increases_power_child = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_fully_charged_attacks_gain_damage_and_stagger",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	max_stacks = talent_settings_shared.ogryn_thrust.max_stacks,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	stat_buffs = {
		[stat_buffs.melee_damage] = 0.1,
		[stat_buffs.melee_impact_modifier] = 0.1,
	},
	proc_func = function (params, template_data, template_context)
		template_data.finish = true
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish
	end,
	related_talents = {
		"ogryn_fully_charged_attacks_gain_damage_and_stagger",
	},
}
templates.ogryn_box_bleed = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_damaging_hit, CheckProcFunctions.on_non_kill, CheckProcFunctions.on_explosion_hit),
	proc_func = function (params, template_data, template_context, t)
		local damage_profile = params.damage_profile
		local damage_profile_name = damage_profile and damage_profile.name

		if damage_profile_name ~= "ogryn_box_cluster_frag_grenade" and damage_profile_name ~= "ogryn_box_cluster_close_frag_grenade" then
			return
		end

		local hit_unit = params.attacked_unit
		local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

		if HEALTH_ALIVE[hit_unit] and buff_extension then
			local unit = template_context.unit
			local num_stacks = talent_settings_shared.box_bleed.stacks

			buff_extension:add_internally_controlled_buff_with_stacks("bleed", num_stacks, t, "owner_unit", unit)
		end
	end,
}
templates.ogryn_suppression_immunity_on_high_toughness = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_movement_speed_after_ranged_kills",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	conditional_keywords = {
		buff_keywords.suppression_immune,
	},
	start_func = function (template_data, template_context)
		local toughness_extension = ScriptUnit.has_extension(template_context.unit, "toughness_system")

		template_data.toughness_extension = toughness_extension
	end,
	conditional_keywords_func = function (template_data, template_context)
		local current_toughness = template_data.toughness_extension:current_toughness_percent()
		local above_threshold = current_toughness > talent_settings_shared.ogryn_suppression_immunity_on_high_toughness.toughness

		return above_threshold
	end,
	related_talents = {
		"ogryn_suppression_toughness",
	},
}
templates.ogryn_movement_boost_on_ranged_damage = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_rending_on_elite_kills",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	active_duration = talent_settings_shared.ogryn_movement_boost_on_ranged_damage.duration,
	cooldown_duration = talent_settings_shared.ogryn_movement_boost_on_ranged_damage.cooldown_duration,
	proc_events = {
		[proc_events.on_player_hit_received] = 1,
	},
	check_proc_func = CheckProcFunctions.on_ranged_hit,
	proc_stat_buffs = {
		[stat_buffs.ranged_damage_taken_multiplier] = talent_settings_shared.ogryn_movement_boost_on_ranged_damage.ranged_damage_taken_multiplier,
	},
	related_talents = {
		"ogryn_movement_boost_on_ranged_damage",
	},
}
templates.ogryn_replenish_rock_on_miss = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_replenish_rock_on_miss",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_blitz",
	hud_priority = 3,
	predicted = false,
	cooldown_duration = talent_settings_shared.ogryn_replenish_rock_on_miss.cooldown_duration,
	proc_events = {
		[proc_events.on_player_projectile_finished] = 1,
	},
	check_proc_func = function (params, template_data, template_context)
		local projectile_name = params.projectile_name

		if projectile_name ~= "ogryn_grenade_friend_rock" then
			return false
		end

		local hit = params.impact_hit
		local weakspot_hits = params.num_impact_hit_weakspot

		if hit and weakspot_hits == 0 then
			return false
		end

		return true
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

		template_data.ability_extension = ability_extension
	end,
	proc_func = function (params, template_data, template_context)
		local ability_extension = template_data.ability_extension
		local ability_type = "grenade_ability"

		if not ability_extension or not ability_extension:has_ability_type(ability_type) then
			return
		end

		if ability_extension then
			local num_charges_restored = 1

			ability_extension:restore_ability_charge("grenade_ability", num_charges_restored)
		end
	end,
	related_talents = {
		"ogryn_replenish_rock_on_miss",
	},
}
templates.ogryn_protect_allies_toughness_broken = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_protect_allies",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	active_duration = talent_settings_shared.ogryn_protect_allies.duration,
	cooldown_duration = talent_settings_shared.ogryn_protect_allies.cooldown_duration,
	proc_events = {
		[proc_events.on_player_toughness_broken] = 1,
	},
	check_proc_func = function (params, template_data, template_context)
		return params.unit ~= template_context.unit
	end,
	proc_stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings_shared.ogryn_protect_allies.toughness_damage_reduction,
		[stat_buffs.power_level_modifier] = talent_settings_shared.ogryn_protect_allies.power_level_modifier,
	},
	related_talents = {
		"ogryn_protect_allies",
	},
}
templates.ogryn_protect_allies = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_protect_allies",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	active_duration = talent_settings_shared.ogryn_protect_allies.duration,
	proc_events = {
		[proc_events.on_ally_knocked_down] = 1,
	},
	check_proc_func = function (params, template_data, template_context)
		return params.downed_unit ~= template_context.unit
	end,
	proc_stat_buffs = {
		[stat_buffs.revive_speed_modifier] = talent_settings_shared.ogryn_protect_allies.revive_speed_modifier,
	},
	proc_keywords = {
		buff_keywords.stun_immune,
	},
	related_talents = {
		"ogryn_protect_allies",
	},
}
templates.ogryn_damage_reduction_after_elite_kill = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_damage_reduction_after_elite_kill",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	active_duration = talent_settings_shared.ogryn_damage_reduction_after_elite_kill.duration,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings_shared.ogryn_damage_reduction_after_elite_kill.damage_taken_multiplier,
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_kill,
	related_talents = {
		"ogryn_damage_reduction_after_elite_kill",
	},
}
templates.ogryn_melee_attacks_give_mtdr = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	check_proc_func = function (params, template_data, template_context)
		local num_hit_units = params.num_hit_units

		return num_hit_units > 0
	end,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("ogryn_melee_attacks_give_mtdr_stacking_buff", t)
	end,
}
templates.ogryn_melee_attacks_give_mtdr_stacking_buff = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_melee_attacks_give_mtdr",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	max_stacks = talent_settings_shared.ogryn_melee_attacks_give_mtdr.stacks,
	stat_buffs = {
		[stat_buffs.melee_damage_taken_multiplier] = talent_settings_shared.ogryn_melee_attacks_give_mtdr.damage_taken_multiplier,
	},
	proc_events = {
		[proc_events.on_damage_taken] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	proc_func = function (params, template_data, template_context)
		template_data.finish = true
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish
	end,
	related_talents = {
		"ogryn_melee_attacks_give_mtdr",
	},
}
templates.ogryn_reload_speed_on_empty = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_reload_speed_on_empty",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.reload_speed] = talent_settings_shared.ogryn_reload_speed_on_empty.reload_speed,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")

		template_data.inventory_component = inventory_component
	end,
	update_func = function (template_data, template_context)
		local unit = template_context.unit
		local inventory_component = template_data.inventory_component
		local wielded_slot = inventory_component.wielded_slot
		local ammo_percentage = Ammo.current_slot_clip_percentage(unit, wielded_slot)
		local is_reloading = ConditionalFunctions.is_reloading(template_data, template_context)
		local active = ammo_percentage == 0

		if not is_reloading then
			template_data.is_active = active
		end
	end,
	check_active_func = ConditionalFunctions.is_reloading,
	related_talents = {
		"ogryn_reload_speed_on_empty",
	},
}
templates.ogryn_stagger_cleave_on_third = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	start_func = function (template_data, template_context)
		return
	end,
	check_proc_func = function (params, template_data, template_context)
		local num_hit_units = params.num_hit_units

		return num_hit_units > 0
	end,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("ogryn_stagger_cleave_on_third_active_buff", t)
	end,
	related_talents = {
		"ogryn_stagger_cleave_on_third",
	},
}
templates.ogryn_stagger_cleave_on_third_active_buff = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_stagger_cleave_on_third",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	max_stacks = talent_settings_shared.ogryn_stagger_cleave_on_third.count,
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_sweep_finish] = 1,
	},
	conditional_stat_buffs = {
		[stat_buffs.max_hit_mass_attack_modifier] = talent_settings_shared.ogryn_stagger_cleave_on_third.max_hit_mass_attack_modifier,
		[stat_buffs.melee_impact_modifier] = talent_settings_shared.ogryn_stagger_cleave_on_third.melee_impact_modifier,
	},
	specific_proc_func = {
		on_sweep_start = function (params, template_data, template_context)
			if template_context.stack_count == talent_settings_shared.ogryn_stagger_cleave_on_third.count then
				template_data.should_end = true
			end
		end,
		on_sweep_finish = function (params, template_data, template_context)
			if template_data.should_end then
				template_data.finish = true
			end
		end,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_context.stack_count == talent_settings_shared.ogryn_stagger_cleave_on_third.count
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish
	end,
	related_talents = {
		"ogryn_stagger_cleave_on_third",
	},
}
templates.ogryn_melee_damage_after_heavy = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_melee_damage_after_heavy",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	active_duration = talent_settings_shared.ogryn_melee_damage_after_heavy.duration,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings_shared.ogryn_melee_damage_after_heavy.melee_damage_modifier,
	},
	check_proc_func = function (params, template_data, template_context)
		local num_hit_units = params.num_hit_units

		if num_hit_units == 0 then
			return false
		end

		local is_heavy = params.is_heavy

		if not is_heavy then
			return false
		end

		return true
	end,
	related_talents = {
		"ogryn_melee_damage_after_heavy",
	},
}
templates.ogryn_far_damage = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_far] = talent_settings_shared.ogryn_far_damage.damage_far,
	},
}
templates.ogryn_corruption_resistance = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.corruption_taken_multiplier] = talent_settings_shared.ogryn_corruption_resistance.corruption_taken_multiplier,
	},
}
templates.ogryn_taking_damage_improves_handling = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_rending_on_elite_kills",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	active_duration = talent_settings_shared.ogryn_taking_damage_improves_handling.duration,
	proc_events = {
		[proc_events.on_player_hit_received] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.spread_modifier] = talent_settings_shared.ogryn_taking_damage_improves_handling.spread_modifier,
		[stat_buffs.recoil_modifier] = talent_settings_shared.ogryn_taking_damage_improves_handling.recoil_modifier,
	},
	related_talents = {
		"ogryn_taking_damage_improves_handling",
	},
}
templates.ogryn_block_increases_power = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_block] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("ogryn_block_increases_power_active_buff", t)
	end,
}
templates.ogryn_block_increases_power_active_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_rending_on_elite_kills",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings_shared.ogryn_block_increases_power.duration,
	max_stacks = talent_settings_shared.ogryn_block_increases_power.stacks,
	stat_buffs = {
		[stat_buffs.melee_impact_modifier] = talent_settings_shared.ogryn_block_increases_power.melee_impact_modifier,
	},
	related_talents = {
		"ogryn_block_increases_power",
	},
}
templates.ogryn_damage_reduction_on_high_stamina = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_damage_reduction_on_high_stamina",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings_shared.ogryn_damage_reduction_on_high_stamina.damage_taken_multiplier,
	},
	start_func = function (template_data, template_context)
		local unit_data_extension = ScriptUnit.has_extension(template_context.unit, "unit_data_system")
		local stamina_component = unit_data_extension:read_component("stamina")

		template_data.stamina_component = stamina_component
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local current_stamina = template_data.stamina_component.current_fraction
		local above_threshold = current_stamina > talent_settings_shared.ogryn_damage_reduction_on_high_stamina.stamina_threshold

		return above_threshold
	end,
	related_talents = {
		"ogryn_damage_reduction_on_high_stamina",
	},
}
templates.ogryn_multiple_staggers_restore_stamina = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	proc_func = function (params, template_data, template_context)
		if params.num_hit_units <= 1 then
			return
		end

		local stamina = talent_settings_shared.ogryn_multiple_staggers_restore_stamina.stamina

		Stamina.add_stamina_percent(template_context.unit, stamina)
	end,
}
templates.ogryn_stacking_attack_speed = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.chained = 0
	end,
	proc_func = function (params, template_data, template_context, t)
		if params.num_hit_units == 0 then
			template_data.chained = 0
		else
			template_data.chained = template_data.chained + 1
		end

		if template_data.chained > 1 then
			template_context.buff_extension:add_internally_controlled_buff("ogryn_stacking_attack_speed_active_buff", t)
		end
	end,
}
templates.ogryn_stacking_attack_speed_active_buff = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_stacking_attack_speed",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = talent_settings_shared.ogryn_stacking_attack_speed.max_stacks,
	duration = talent_settings_shared.ogryn_stacking_attack_speed.duration,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	stat_buffs = {
		[stat_buffs.melee_attack_speed] = talent_settings_shared.ogryn_stacking_attack_speed.melee_attack_speed,
	},
	proc_func = function (params, template_data, template_context)
		if params.num_hit_units == 0 then
			template_data.finish = true
		end
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish
	end,
	related_talents = {
		"ogryn_stacking_attack_speed",
	},
}

local function dodge_update(template_data, template_context)
	local unit = template_context.unit
	local radius = 1.5
	local DAMAGE_COLLISION_FILTER = "filter_player_character_lunge"
	local multiplier = 1 / (template_data.consecutive_dodges * 2 - 1)
	local max_distance = 4
	local position = POSITION_LOOKUP[unit]
	local dodge_direction = template_data.dodge_direction:unbox()
	local check_position = position + dodge_direction
	local actors, num_actors = PhysicsWorld.immediate_overlap(template_data.physics_world, "shape", "sphere", "position", check_position, "size", radius, "collision_filter", DAMAGE_COLLISION_FILTER)
	local hit_enemy_units = template_data.hit_enemy_units

	for ii = 1, num_actors do
		local hit_actor = actors[ii]
		local hit_unit = Actor.unit(hit_actor)
		local unit_data_extension = hit_unit and ScriptUnit.has_extension(hit_unit, "unit_data_system")
		local breed = unit_data_extension and unit_data_extension:breed()
		local invalid = not breed or not breed.tags or breed.tags.elite or breed.tags.ogryn or breed.tags.special or breed.tags.monster

		if not invalid and template_data.side_system:is_enemy(unit, hit_unit) and not hit_enemy_units[hit_unit] then
			local hit_position = POSITION_LOOKUP[hit_unit]
			local hit_distance = Vector3.distance(hit_position, position)
			local hit_direction = Vector3.normalize(Vector3.flat(hit_position - position))
			local distance_multiplier = max_distance - hit_distance
			local hit_world_position = Actor.position(hit_actor)
			local damage_profile = DamageProfileTemplates.ogryn_dodge_impact
			local LUNGE_ATTACK_POWER_LEVEL = 500 * multiplier * distance_multiplier
			local damage_type = damage_types.ogryn_physical
			local damage_dealt, attack_result, damage_efficiency = Attack.execute(hit_unit, damage_profile, "power_level", LUNGE_ATTACK_POWER_LEVEL, "hit_world_position", hit_world_position, "attack_direction", hit_direction, "attack_type", AttackSettings.attack_types.melee, "attacking_unit", unit, "damage_type", damage_type)

			hit_enemy_units[hit_unit] = true
		end
	end
end

templates.ogryn_suppression_increase = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.suppression_dealt] = talent_settings_shared.ogryn_suppression_increase.suppression,
	},
}
templates.ogryn_dodge_stagger = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_dodge_start] = 1,
		[proc_events.on_dodge_end] = 1,
	},
	start_func = function (template_data, template_context)
		local physics_world = World.physics_world(template_context.world)

		template_data.physics_world = physics_world

		local side_system = Managers.state.extension:system("side_system")

		template_data.side_system = side_system
	end,
	specific_proc_func = {
		on_dodge_start = function (params, template_data, template_context)
			template_data.hit_enemy_units = {}
			template_data.active = true
			template_data.dodge_direction = params.dodge_direction

			local consecutive_dodges = Dodge.consecutive_dodges(template_context.unit)

			template_data.consecutive_dodges = consecutive_dodges

			dodge_update(template_data, template_context)
		end,
		on_dodge_end = function (params, template_data, template_context)
			template_data.active = false
		end,
	},
	update_func = function (template_data, template_context)
		if not template_data.active then
			return
		end

		dodge_update(template_data, template_context)
	end,
}
templates.ogryn_weakspot_damage = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.melee_weakspot_power_modifier] = talent_settings_shared.ogryn_weakspot_damage.power,
	},
}
templates.ogryn_big_box_of_hurt_more_bombs = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.ogryn_grenade_box_cluster_amount] = talent_settings_shared.ogryn_big_box_of_hurt_more_bombs.amount,
	},
}
templates.ogryn_staggering_increases_damage_taken = {
	class_name = "proc_buff",
	predicted = true,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_push_hit] = 1,
	},
	specific_proc_func = {
		on_hit = function (params, template_data, template_context, t)
			if CheckProcFunctions.on_kill(params) then
				return
			end

			if not CheckProcFunctions.on_melee_stagger_hit(params) then
				return
			end

			local victim_unit = params.attacked_unit
			local buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

			if HEALTH_ALIVE[victim_unit] and buff_extension then
				local num_stacks = 1

				buff_extension:add_internally_controlled_buff_with_stacks("ogryn_staggering_damage_taken_increase", num_stacks, t, "owner_unit", template_context.unit)
			end
		end,
		on_push_hit = function (params, template_data, template_context, t)
			local victim_unit = params.pushed_unit

			if not MinionState.is_minion(victim_unit) or not MinionState.is_staggered(victim_unit) then
				return
			end

			local buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

			if HEALTH_ALIVE[victim_unit] and buff_extension then
				local num_stacks = 1

				buff_extension:add_internally_controlled_buff_with_stacks("ogryn_staggering_damage_taken_increase", num_stacks, t, "owner_unit", template_context.unit)
			end
		end,
	},
}
templates.ogryn_staggering_damage_taken_increase = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings_shared.ogryn_staggering_increases_damage_taken.duration,
	stat_buffs = {
		[stat_buffs.damage_taken_modifier] = talent_settings_shared.ogryn_staggering_increases_damage_taken.damage,
	},
}

function _is_in_weapon_alternate_fire_with_stamina(template_data, template_context)
	local wielded_slot = template_data.inventory_component.wielded_slot

	if wielded_slot == "none" then
		return false, false
	end

	local wielded_slot_configuration = slot_configuration[wielded_slot]
	local slot_type = wielded_slot_configuration and wielded_slot_configuration.slot_type
	local is_weapon = slot_type == "weapon"

	if not is_weapon then
		return false, false
	end

	local is_alternate_fire_active = template_data.alternate_fire_component.is_active

	if not is_alternate_fire_active then
		return false, false
	end

	local has_stamina = template_data.stamina_component.current_fraction > 0

	if not has_stamina then
		return false, is_alternate_fire_active
	end

	return true, is_alternate_fire_active
end

templates.ogryn_drain_stamina_for_handling = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_drain_stamina_for_handling",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 4,
	predicted = true,
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings_shared.ogryn_drain_stamina_for_handling.critical_strike_chance,
		[stat_buffs.spread_modifier] = talent_settings_shared.ogryn_drain_stamina_for_handling.spread_modifier,
		[stat_buffs.recoil_modifier] = talent_settings_shared.ogryn_drain_stamina_for_handling.recoil_modifier,
		[stat_buffs.sway_modifier] = talent_settings_shared.ogryn_drain_stamina_for_handling.sway_modifier,
	},
	start_func = function (template_data, template_context)
		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")

		template_data.alternate_fire_component = unit_data_extension:read_component("alternate_fire")
		template_data.stamina_component = unit_data_extension:read_component("stamina")
		template_data.sway_component = unit_data_extension:write_component("sway_control")
		template_data.inventory_component = unit_data_extension:read_component("inventory")
		template_data.stamina_per_second = talent_settings_shared.ogryn_drain_stamina_for_handling.stamina_per_second
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end,
	update_func = function (template_data, template_context, dt, t)
		local is_active, is_alternate_fire_active = _is_in_weapon_alternate_fire_with_stamina(template_data, template_context)

		template_data.is_active = is_active

		local is_reloading = ConditionalFunctions.is_reloading(template_data, template_context)

		if not is_alternate_fire_active or is_reloading then
			return
		end

		local cost_per_second = template_data.stamina_per_second
		local remaining_stamina = Stamina.drain(template_context.unit, cost_per_second * dt, t)

		template_data.remaining_stamina = remaining_stamina
	end,
	check_active_func = function (template_data, template_context)
		local is_alternate_fire_active = template_data.alternate_fire_component.is_active
		local is_reloading = ConditionalFunctions.is_reloading(template_data, template_context)

		return is_alternate_fire_active and not is_reloading
	end,
	duration_func = function (template_data, template_context)
		local stamina_component = template_data.stamina_component

		if stamina_component then
			return stamina_component.current_fraction
		end

		return 0.01
	end,
}
templates.ogryn_wield_speed_increase = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.wield_speed] = talent_settings_shared.ogryn_wield_speed_increase.wield_speed,
	},
}
templates.ogryn_ranged_damage_immunity = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_movement_boost_on_ranged_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	active_duration = talent_settings_shared.ogryn_ranged_damage_immunity.duration,
	cooldown_duration = talent_settings_shared.ogryn_ranged_damage_immunity.cooldown,
	proc_events = {
		[proc_events.on_damage_taken] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.ranged_damage_taken_multiplier] = talent_settings_shared.ogryn_ranged_damage_immunity.ranged_damage_taken_multiplier,
	},
	check_proc_func = function (params, template_data, template_context)
		if params.attack_type ~= attack_types.ranged then
			return
		end

		if params.attacked_unit ~= template_context.unit then
			return
		end

		return true
	end,
	related_talents = {
		"ogryn_ranged_damage_immunity",
	},
}
templates.ogryn_melee_improves_ranged = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_kill,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("ogryn_melee_improves_ranged_stacking_buff", t)
	end,
}
templates.ogryn_melee_improves_ranged_stacking_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_melee_improves_ranged",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings_shared.ogryn_melee_improves_ranged.duration,
	max_stacks = talent_settings_shared.ogryn_melee_improves_ranged.max_stacks,
	stat_buffs = {
		[stat_buffs.ranged_damage] = talent_settings_shared.ogryn_melee_improves_ranged.ranged_damage,
	},
	related_talents = {
		"ogryn_melee_improves_ranged",
	},
}
templates.ogryn_taunt_restore_toughness = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_ogryn_shout] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		local unit = template_context.unit
		local settings = talent_settings_shared.ogryn_taunt_restore_toughness
		local percentage = settings.instant_toughness

		Toughness.replenish_percentage(unit, percentage, false, "ogryn_taunt_restore_toughness")

		local num_hits = math.min(params.num_hits, settings.max_stacks)

		template_context.buff_extension:add_internally_controlled_buff_with_stacks("ogryn_taunt_restore_toughness_over_time", num_hits, t)
	end,
}
templates.ogryn_taunt_restore_toughness_over_time = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_taunt_restore_toughness",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 3,
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = talent_settings_shared.ogryn_taunt_restore_toughness.max_stacks,
	max_stacks_cap = talent_settings_shared.ogryn_taunt_restore_toughness.max_stacks,
	duration = talent_settings_shared.ogryn_taunt_restore_toughness.duration,
	update_func = function (template_data, template_context, dt)
		local toughness = template_context.stack_count * talent_settings_shared.ogryn_taunt_restore_toughness.toughness_per_hit * dt

		Toughness.replenish_percentage(template_context.unit, toughness, false, "ogryn_taunt_restore_toughness_over_time")
	end,
	related_talents = {
		"ogryn_taunt_restore_toughness",
	},
}
templates.ogryn_pushing_applies_brittleness = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_push_hit] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		local pushed_unit = params.pushed_unit

		if not HEALTH_ALIVE[pushed_unit] then
			return
		end

		local buff_extension = ScriptUnit.has_extension(pushed_unit, "buff_system")

		if buff_extension then
			local stacks = talent_settings_shared.ogryn_pushing_applies_brittleness.stacks

			buff_extension:add_internally_controlled_buff_with_stacks("rending_debuff", stacks, t)
		end
	end,
}
templates.ogryn_ranged_improves_melee = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_ranged_improves_melee",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	active_duration = talent_settings_shared.ogryn_ranged_improves_melee.duration,
	proc_events = {
		[proc_events.on_ammo_consumed] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings_shared.ogryn_ranged_improves_melee.melee_damage,
		[stat_buffs.melee_attack_speed] = talent_settings_shared.ogryn_ranged_improves_melee.melee_attack_speed,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")

		template_data.inventory_component = inventory_component
	end,
	check_proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local inventory_component = template_data.inventory_component
		local wielded_slot = inventory_component.wielded_slot
		local ammo_percentage = Ammo.current_slot_clip_percentage(unit, wielded_slot)

		return ammo_percentage == 0
	end,
	related_talents = {
		"ogryn_ranged_improves_melee",
	},
}
templates.ogryn_block_all_attacks = {
	class_name = "buff",
	predicted = false,
	keywords = {
		buff_keywords.block_unblockable,
	},
}
templates.ogryn_block_all_attacks_perfect = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_perfect_block] = 1,
	},
	conditional_keywords = {
		buff_keywords.block_unblockable,
	},
	start_func = function (template_data, template_context)
		local unit_data = ScriptUnit.extension(template_context.unit, "unit_data_system")
		local block_component = unit_data:write_component("block")

		template_data.block_component = block_component
	end,
	conditional_keywords_func = function (template_data, template_context)
		return template_data.block_component.is_perfect_blocking
	end,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("ogryn_block_all_attacks_perfect_damage_boost", t)
	end,
}
templates.ogryn_block_all_attacks_perfect_damage_boost = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_block_all_attacks",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings_shared.ogryn_block_all_attacks.duration,
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings_shared.ogryn_block_all_attacks.melee_damage,
	},
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	proc_func = function (params, template_data, template_context)
		template_data.finish = true
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish
	end,
	related_talents = {
		"ogryn_block_all_attacks_perfect",
	},
}
templates.ogryn_crit_damage_increase = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.critical_strike_damage] = talent_settings_shared.ogryn_crit_damage_increase.critical_strike_damage,
	},
}
templates.ogryn_blo_melee = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_start] = 1,
	},
	specific_proc_func = {
		on_hit = function (params, template_data, template_context, t)
			if not template_data.allowed then
				return
			end

			if not CheckProcFunctions.on_melee_kill(params, template_data, template_context) then
				return
			end

			template_context.buff_extension:add_internally_controlled_buff("ogryn_blo_melee_active_buff", t)

			template_data.allowed = false
		end,
		on_sweep_start = function (params, template_data, template_context, t)
			template_data.allowed = true
		end,
	},
}
templates.ogryn_blo_melee_active_buff = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_blo_melee",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 3,
	predicted = false,
	max_stacks = talent_settings_shared.ogryn_blo_melee.max_stacks,
	proc_events = {
		[proc_events.on_ammo_consumed] = 1,
	},
	stat_buffs = {
		[stat_buffs.leadbelcher_chance_bonus] = talent_settings_shared.ogryn_blo_melee.chance,
	},
	proc_func = function (params, template_data, template_context)
		template_data.finish = true
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish
	end,
	related_talents = {
		"ogryn_blo_melee",
	},
}
templates.ogryn_blo_new_passive = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_ranged_kill,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("ogryn_blo_stacking_buff", t)
	end,
}

local blo_passive_max_stacks = talent_settings_1.passive_1.max_stacks
local blo_passive_lerp_value = 0

templates.ogryn_blo_stacking_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_blo_wield_speed",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 3,
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = blo_passive_max_stacks,
	duration = talent_settings_1.passive_1.duration,
	stat_buffs = {
		[stat_buffs.ranged_damage] = talent_settings_1.passive_1.ranged_damage,
		[stat_buffs.ranged_attack_speed] = talent_settings_1.passive_1.fire_rate,
	},
	update_func = function (template_data, template_context)
		local stacks = template_context.stack_count
		local value = math.clamp(stacks / blo_passive_max_stacks, 0, 1)

		blo_passive_lerp_value = value
	end,
	stop_func = function (template_data, template_context)
		blo_passive_lerp_value = 0
	end,
	related_talents = {
		"ogryn_leadbelcher_no_ammo_chance",
	},
}
templates.ogryn_blo_wield_speed = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.wield_speed] = {
			min = 0,
			max = talent_settings_1.passive_1.wield_speed * blo_passive_max_stacks,
		},
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return blo_passive_lerp_value
	end,
	related_talents = {
		"ogryn_blo_wield_speed",
	},
}
templates.ogryn_blo_fire_rate = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.ranged_attack_speed] = {
			min = 0,
			max = talent_settings_1.passive_1.fire_rate * blo_passive_max_stacks,
		},
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return blo_passive_lerp_value
	end,
}
templates.ogryn_blo_ally_ranged_buffs = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_ammo_consumed] = 1,
	},
	check_proc_func = function (params, template_data, template_context)
		return params.is_leadbelcher_shot
	end,
	proc_func = function (params, template_data, template_context, t)
		local unit = template_context.unit
		local coherency_extension = ScriptUnit.has_extension(unit, "coherency_system")

		if coherency_extension then
			local units_in_coherence = coherency_extension:in_coherence_units()

			for coherency_unit, _ in pairs(units_in_coherence) do
				local coherency_buff_extension = ScriptUnit.extension(coherency_unit, "buff_system")

				coherency_buff_extension:add_internally_controlled_buff("ogryn_blo_ally_ranged_buff", t, "owner_unit", unit)
			end
		end
	end,
}
templates.ogryn_blo_ally_ranged_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_blo_ally_ranged_buffs",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 3,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[stat_buffs.ranged_damage] = talent_settings_shared.ogryn_blo_ally_ranged_buffs.ranged_damage,
	},
	duration = talent_settings_shared.ogryn_blo_ally_ranged_buffs.duration,
	related_talents = {
		"ogryn_blo_ally_ranged_buffs",
	},
}

local ally_defense_max_stacks = talent_settings_shared.ogryn_damage_taken_by_all_increases_strength_tdr.max_stacks

templates.ogryn_damage_taken_by_all_increases_strength_tdr = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_damage_taken] = 1,
	},
	check_proc_func = function (params)
		return true
	end,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("ogryn_damage_taken_by_all_increases_strength_tdr_buff", t)

		local num_stacks = template_context.buff_extension:current_stacks("ogryn_damage_taken_by_all_increases_strength_tdr_buff")

		if num_stacks == ally_defense_max_stacks then
			template_context.buff_extension:add_internally_controlled_buff("ogryn_damage_taken_by_all_increases_strength_tdr_max_buff", t)
		end
	end,
}
templates.ogryn_damage_taken_by_all_increases_strength_tdr_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/ogryn/ogryn_stamina_restores_toughness",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = ally_defense_max_stacks,
	duration = talent_settings_shared.ogryn_damage_taken_by_all_increases_strength_tdr.duration,
	stat_buffs = {
		[stat_buffs.power_level_modifier] = talent_settings_shared.ogryn_damage_taken_by_all_increases_strength_tdr.power_level_modifier,
	},
	related_talents = {
		"ogryn_damage_taken_by_all_increases_strength_tdr",
	},
}
templates.ogryn_damage_taken_by_all_increases_strength_tdr_max_buff = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings_shared.ogryn_damage_taken_by_all_increases_strength_tdr.tdr,
	},
	conditional_exit_func = function (template_data, template_context)
		local num_stacks = template_context.buff_extension:current_stacks("ogryn_damage_taken_by_all_increases_strength_tdr_buff")
		local max_stacks = ally_defense_max_stacks

		return num_stacks < max_stacks
	end,
}

return templates
