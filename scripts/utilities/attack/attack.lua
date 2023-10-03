local Armor = require("scripts/utilities/attack/armor")
local AttackingUnitResolver = require("scripts/utilities/attack/attacking_unit_resolver")
local AttackPositioning = require("scripts/utilities/attack/attack_positioning")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Block = require("scripts/utilities/attack/block")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Damage = require("scripts/utilities/attack/damage")
local DamageCalculation = require("scripts/utilities/attack/damage_calculation")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local DamageTakenCalculation = require("scripts/utilities/attack/damage_taken_calculation")
local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local FriendlyFire = require("scripts/utilities/attack/friendly_fire")
local HitReaction = require("scripts/utilities/attack/hit_reaction")
local MinionPerception = require("scripts/utilities/minion_perception")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local Suppression = require("scripts/utilities/attack/suppression")
local Stamina = require("scripts/utilities/attack/stamina")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local Threat = require("scripts/utilities/threat")
local Toughness = require("scripts/utilities/toughness/toughness")
local ToughnessSettings = require("scripts/settings/toughness/toughness_settings")
local Vo = require("scripts/utilities/vo")
local Weakspot = require("scripts/utilities/attack/weakspot")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local damage_efficiencies = AttackSettings.damage_efficiencies
local proc_events = BuffSettings.proc_events
local keywords = BuffSettings.keywords
local damage_types = DamageSettings.damage_types
local toughness_replenish_types = ToughnessSettings.replenish_types
local _execute, _handle_attack, _handle_buffs, _handle_result, _has_armor_penetrating_buff, _record_stats, _record_telemetry, _trigger_backstab_interfacing, _trigger_elite_special_kill_interfacing, _trigger_flank_interfacing, _trigger_training_grounds_events, ARGS, NUM_ARGS = nil
local Attack = {}
local attack_args_temp = {}

Attack.execute = function (attacked_unit, damage_profile, ...)
	table.clear(attack_args_temp)

	local num_args = select("#", ...)

	for i = 1, num_args, 2 do
		local arg, val = select(i, ...)
		attack_args_temp[ARGS[arg]] = val
	end

	for i = 1, NUM_ARGS do
		local setting = ARGS[i]
		local val = attack_args_temp[i]

		if val == nil then
			local default = setting.default

			if default == "Vector3" then
				val = Vector3.up()
			else
				val = default
			end
		end

		local min = setting.min
		local max = setting.max

		if min and max then
			val = math.clamp(val, min, max)
		elseif min then
			val = math.max(val, min)
		elseif max then
			val = math.min(val, max)
		end

		attack_args_temp[i] = val
	end

	return _execute(attacked_unit, damage_profile, unpack(attack_args_temp, 1, NUM_ARGS))
end

local damage_types_no_proc = {
	grimoire = true
}
local min_power_level = PowerLevelSettings.min_power_level
local max_power_level = PowerLevelSettings.max_power_level
ARGS = {
	{
		default = 0,
		name = "target_index"
	},
	{
		default = 0,
		name = "target_number"
	},
	{
		name = "power_level",
		default = min_power_level,
		min = min_power_level,
		max = max_power_level
	},
	{
		name = "charge_level"
	},
	{
		default = false,
		name = "is_critical_strike"
	},
	{
		name = "dropoff_scalar"
	},
	{
		default = "Vector3",
		name = "attack_direction"
	},
	{
		default = false,
		name = "instakill"
	},
	{
		name = "hit_zone_name"
	},
	{
		name = "hit_world_position"
	},
	{
		name = "hit_actor"
	},
	{
		name = "attacking_unit"
	},
	{
		name = "attack_type"
	},
	{
		name = "herding_template"
	},
	{
		name = "damage_type"
	},
	{
		name = "auto_completed_action"
	},
	{
		name = "item"
	},
	{
		name = "wounds_shape"
	},
	{
		name = "triggered_proc_events"
	}
}
NUM_ARGS = #ARGS

for i = 1, NUM_ARGS do
	local argument = ARGS[i]
	local arg_name = argument.name
	ARGS[arg_name] = i
end

local TRAINING_GROUNDS_GAME_MODE_NAME = "training_grounds"

function _execute(attacked_unit, damage_profile, target_index, target_number, power_level, charge_level, is_critical_strike, dropoff_scalar, attack_direction, instakill, hit_zone_name, hit_world_position, hit_actor, attacking_unit, attack_type, herding_template, damage_type, auto_completed_action, item, wounds_shape, triggered_proc_events_or_nil)
	local was_alive_at_attack_start = HEALTH_ALIVE[attacked_unit]
	attacking_unit = ALIVE[attacking_unit] and attacking_unit
	local target_settings = DamageProfile.target_settings(damage_profile, target_index)
	local damage_profile_lerp_values = DamageProfile.lerp_values(damage_profile, attacking_unit, target_index)
	local unit_data_extension = ScriptUnit.has_extension(attacked_unit, "unit_data_system")
	local target_breed_or_nil = unit_data_extension and unit_data_extension:breed()
	local is_player_character = Breed.is_player(target_breed_or_nil)
	local attacking_unit_owner_unit, apply_owner_buffs = AttackingUnitResolver.resolve(attacking_unit)
	local attacking_unit_data_extension = ScriptUnit.has_extension(attacking_unit_owner_unit, "unit_data_system")
	local attacker_breed_or_nil = attacking_unit_data_extension and attacking_unit_data_extension:breed()
	local attacker_buff_extension = ScriptUnit.has_extension(apply_owner_buffs and attacking_unit_owner_unit or attacking_unit, "buff_system")
	local target_buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")
	local is_backstab = AttackPositioning.is_backstabbing(attacked_unit, attacking_unit, attack_type)

	if is_backstab then
		_trigger_backstab_interfacing(attacking_unit_owner_unit, attack_type)
	end

	local is_flanking = AttackPositioning.is_flanking(attacked_unit, attacking_unit, attack_type, attack_direction)

	if is_flanking then
		_trigger_flank_interfacing(attacking_unit_owner_unit, attack_type)
	end

	local attacked_action = nil

	if Managers.stats.can_record_stats() then
		local behaviour_extension = ScriptUnit.has_extension(attacked_unit, "behavior_system")
		attacked_action = behaviour_extension and behaviour_extension:running_action()
	end

	local hit_weakspot = false
	local hit_shield = false

	if target_breed_or_nil then
		hit_weakspot, hit_shield = Weakspot.hit_weakspot(target_breed_or_nil, hit_zone_name)

		if damage_profile.breed_instakill_overrides then
			instakill = instakill or damage_profile.breed_instakill_overrides[target_breed_or_nil.name]
		end
	end

	local is_server = Managers.state.game_session:is_server()
	local calculated_damage, damage_efficiency = nil

	if instakill then
		local health_extension = ScriptUnit.extension(attacked_unit, "health_system")
		damage_efficiency = damage_efficiencies.full
		calculated_damage = health_extension:max_health()
	else
		local target_blackboard = BLACKBOARDS[attacked_unit]
		local target_stagger_count = 0
		local num_triggered_staggers = 0
		local current_stagger_impact = 0

		if not is_player_character and target_blackboard then
			local stagger_component = target_blackboard.stagger
			target_stagger_count = stagger_component.count
			num_triggered_staggers = stagger_component.num_triggered_staggers
			local stagger_impact_comparison = StaggerSettings.stagger_impact_comparison
			local current_stagger_type = stagger_component.type
			current_stagger_impact = stagger_impact_comparison[current_stagger_type]
		end

		local damage_immune = target_buff_extension and target_buff_extension:has_keyword("damage_immune")

		if damage_immune then
			calculated_damage = 0
			damage_efficiency = "negated"
		else
			local attacker_position = POSITION_LOOKUP[attacking_unit_owner_unit]
			local target_position = POSITION_LOOKUP[attacked_unit]
			local distance = attacker_position and target_position and Vector3.distance(attacker_position, target_position)
			local attacker_stat_buffs = attacker_buff_extension and attacker_buff_extension:stat_buffs()
			local target_stat_buffs = target_buff_extension and target_buff_extension:stat_buffs()
			local armor_penetrating = _has_armor_penetrating_buff(attacker_buff_extension, attack_type, hit_weakspot)
			local target_toughness_extension = ScriptUnit.has_extension(attacked_unit, "toughness_system")
			local armor_type = Armor.armor_type(attacked_unit, target_breed_or_nil, hit_zone_name, attack_type)
			local is_attacked_unit_suppressed = Suppression.is_suppressed(attacked_unit)
			local power_level_damage_multiplier = 1

			if damage_type == damage_types.grenade_frag and target_breed_or_nil and target_breed_or_nil.explosion_power_multiplier then
				power_level_damage_multiplier = target_breed_or_nil.explosion_power_multiplier
			end

			local stagger_impact_bonus = nil
			calculated_damage, damage_efficiency = DamageCalculation.calculate(damage_profile, damage_type, target_settings, damage_profile_lerp_values, hit_zone_name, power_level * power_level_damage_multiplier, charge_level, target_breed_or_nil, attacker_breed_or_nil, is_critical_strike, hit_weakspot, hit_shield, is_backstab, is_flanking, dropoff_scalar, attack_type, attacker_stat_buffs, target_stat_buffs, target_buff_extension, armor_penetrating, target_toughness_extension, armor_type, target_stagger_count, num_triggered_staggers, is_attacked_unit_suppressed, distance, attacked_unit, auto_completed_action, current_stagger_impact, stagger_impact_bonus)
		end
	end

	local damage_dealt, attack_result, damage_absorbed, damage, permanent_damage, one_hit_kill, actual_damage_dealt, stagger_result, stagger_type = nil
	local target_is_assisted = false
	local target_is_hogtied = false

	if is_player_character then
		local assisted_state_input_component = unit_data_extension:read_component("assisted_state_input")
		local character_state_component = unit_data_extension:read_component("character_state")
		target_is_assisted = PlayerUnitStatus.is_assisted(assisted_state_input_component)
		target_is_hogtied = PlayerUnitStatus.is_hogtied(character_state_component)
	end

	local target_weapon_template = nil

	if is_player_character then
		local weapon_action_component = unit_data_extension:read_component("weapon_action")
		target_weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
	end

	attack_result, damage_dealt, damage_absorbed, damage, permanent_damage, one_hit_kill, actual_damage_dealt = _handle_attack(is_server, instakill, target_is_assisted, target_is_hogtied, attacked_unit, target_breed_or_nil, calculated_damage, attacking_unit, attacking_unit_owner_unit, hit_zone_name, damage_profile, attack_direction, hit_actor, attack_type, herding_template, is_critical_strike, hit_world_position, damage_type, target_weapon_template, unit_data_extension, wounds_shape, attacker_buff_extension)

	if is_server then
		stagger_result, stagger_type = HitReaction.apply(damage_profile, damage_profile_lerp_values, target_weapon_template, target_breed_or_nil, target_buff_extension, attack_result, attacked_unit, attacking_unit, attack_direction, hit_world_position, target_settings, power_level, charge_level, is_critical_strike, is_backstab, is_flanking, hit_weakspot, dropoff_scalar, attack_type, herding_template, hit_shield)
	end

	if was_alive_at_attack_start and target_breed_or_nil then
		_handle_buffs(is_server, triggered_proc_events_or_nil, damage_profile, attacker_buff_extension, target_buff_extension, attacked_unit, damage_dealt, damage_absorbed, attack_result, stagger_result, hit_zone_name, is_critical_strike, is_backstab, hit_weakspot, one_hit_kill, attack_type, attacking_unit, attacking_unit_owner_unit, attack_direction, damage_efficiency, target_index, target_number, attacker_breed_or_nil, target_breed_or_nil, damage_type, charge_level, hit_world_position)

		if is_server then
			_handle_result(attacking_unit_owner_unit, attacked_unit, attack_result, attack_type, attacker_breed_or_nil, target_breed_or_nil, damage_dealt, damage_absorbed, damage_profile, damage_type, actual_damage_dealt)
			Managers.state.attack_report:add_attack_result(damage_profile, attacked_unit, attacking_unit_owner_unit, attack_direction, hit_world_position, hit_weakspot, damage_dealt, attack_result, attack_type, damage_efficiency)

			if Managers.stats.can_record_stats() then
				_record_stats(attack_result, attack_type, attacked_unit, attacking_unit_owner_unit, damage_absorbed, damage_dealt, hit_zone_name, damage_profile, item, attacked_action, attacker_breed_or_nil, target_breed_or_nil, damage_type, target_buff_extension, is_critical_strike, stagger_result, stagger_type)
			end

			_record_telemetry(attacking_unit_owner_unit, attacked_unit, attack_result, attack_type, damage_dealt, damage_profile, damage_type, damage, permanent_damage, actual_damage_dealt, damage_absorbed, attacker_breed_or_nil, target_breed_or_nil, instakill)
		end

		local game_mode_name = Managers.state.game_mode:game_mode_name()

		if game_mode_name == TRAINING_GROUNDS_GAME_MODE_NAME then
			_trigger_training_grounds_events(item, attack_direction, attack_result, attack_type, attacked_unit, attacking_unit, damage, damage_profile, damage_type, hit_weakspot, is_critical_strike, wounds_shape)
		end
	end

	if was_alive_at_attack_start and attack_result == attack_results.died then
		_trigger_elite_special_kill_interfacing(attacking_unit_owner_unit, attacker_breed_or_nil, target_breed_or_nil, is_server)
	end

	if damage_dealt <= 0 and not is_player_character then
		if damage_efficiency == damage_efficiencies.negated then
			Vo.armor_hit_event(attacking_unit)
		end

		if target_breed_or_nil then
			local breed_name = target_breed_or_nil.name
			local dialogue_breed_settings = DialogueBreedSettings[breed_name]
			local no_damage_vo_event = dialogue_breed_settings and dialogue_breed_settings.no_damage_vo_event

			if no_damage_vo_event then
				Vo.enemy_generic_vo_event(attacked_unit, no_damage_vo_event, breed_name)
			end
		end
	end

	if hit_weakspot then
		local weakspot_extension = ScriptUnit.has_extension(attacked_unit, "weakspot_system")

		if weakspot_extension then
			weakspot_extension:weakspot_attacked(attacking_unit, attack_result, damage_dealt, damage_efficiency, hit_zone_name, hit_world_position, attack_direction)
		end
	end

	return damage_dealt, attack_result, damage_efficiency, stagger_result, hit_weakspot
end

function _has_armor_penetrating_buff(attacker_buff_extension, attack_type, is_weakspot)
	local has_normal_armor_penetrating = attacker_buff_extension and attacker_buff_extension:has_keyword(keywords.armor_penetrating)

	if has_normal_armor_penetrating then
		return true
	end

	local has_weakspot_armor_penetrating = is_weakspot and attacker_buff_extension and attacker_buff_extension:has_keyword(keywords.weakspot_hit_gains_armor_penetration)

	if has_weakspot_armor_penetrating then
		return true
	end

	return false
end

function _handle_attack(is_server, instakill, target_is_assisted, target_is_hogtied, attacked_unit, target_breed_or_nil, calculated_damage, attacking_unit, attacking_unit_owner_unit, hit_zone_name, damage_profile, attack_direction, hit_actor, attack_type, herding_template_or_nil, is_critical_strike, hit_world_position_or_nil, damage_type, target_weapon_template, unit_data_extension, wounds_shape, attacker_buff_extension)
	local damage_dealt, actual_damage_dealt, result, damage_absorbed, damage, permanent_damage, one_hit_kill = nil
	local past_blocking = true
	local damage_through_block = nil

	if not instakill and Block.is_blocking(attacked_unit, attacking_unit, attack_type, target_weapon_template, is_server) then
		local side_system = Managers.state.extension:system("side_system")
		local is_ally = side_system:is_ally(attacked_unit, attacking_unit_owner_unit)
		local damage_allowed = not is_ally or FriendlyFire.is_enabled(attacking_unit_owner_unit, attacked_unit)
		local target_is_player = Breed.is_player(target_breed_or_nil)
		local is_blockable = Block.attack_is_blockable(damage_profile, attacked_unit, target_weapon_template)

		if is_blockable then
			damage_dealt = 0
			damage = 0
			permanent_damage = 0
			damage_absorbed = calculated_damage
			result = damage_allowed and attack_results.blocked or attack_results.friendly_fire
			past_blocking = false
		elseif target_is_player and is_server then
			local t = Managers.time:time("gameplay")
			local stamina_read_component = unit_data_extension:read_component("stamina")
			local archetype = unit_data_extension:archetype()
			local base_stamina_template = archetype.stamina
			local current_stamina, max_stamina = Stamina.current_and_max_value(attacked_unit, stamina_read_component, base_stamina_template)

			Stamina.drain(attacked_unit, max_stamina, t)

			damage_through_block = true
		end

		if is_server and unit_data_extension and damage_allowed then
			local block_component = unit_data_extension:write_component("block")
			block_component.has_blocked = true
		end
	end

	if past_blocking then
		if not instakill and target_is_assisted then
			damage_dealt = 0
			damage = 0
			permanent_damage = 0
			damage_absorbed = calculated_damage
			result = attack_results.dodged
		elseif not instakill and target_is_hogtied then
			damage_dealt = 0
			damage = 0
			permanent_damage = 0
			damage_absorbed = 0
			result = attack_results.dodged
		else
			local is_invulnerable, is_damage_allowed, health_setting, current_health_damage, current_permanent_damage, max_health, max_wounds, toughness_template, weapon_toughness_template, current_toughness_damage, movement_state, shield_setting, attacked_unit_stat_buffs, attacked_unit_keywords, attacking_unit_stat_buffs = DamageTakenCalculation.get_calculation_parameters(attacked_unit, target_breed_or_nil, damage_profile, attacking_unit, attacking_unit_owner_unit, hit_actor, attacker_buff_extension)
			local tougness_damage = nil
			result, damage, permanent_damage, tougness_damage, damage_absorbed = DamageTakenCalculation.calculate_attack_result(calculated_damage, damage_profile, attack_type, attack_direction, instakill, is_invulnerable, is_damage_allowed, health_setting, current_health_damage, current_permanent_damage, max_health, max_wounds, toughness_template, weapon_toughness_template, current_toughness_damage, movement_state, shield_setting, attacked_unit_stat_buffs, attacked_unit_keywords, attacked_unit, damage_type, attacking_unit_stat_buffs)
			damage_dealt = damage + permanent_damage
			one_hit_kill = result == attack_results.died and max_health <= damage_dealt and current_health_damage <= 0

			if is_damage_allowed and is_server then
				local target_is_player = Breed.is_player(target_breed_or_nil)

				if target_is_player then
					local is_blockable = Block.attack_is_blockable(damage_profile, attacked_unit, target_weapon_template)
					local stamina_read_component = unit_data_extension:read_component("stamina")
					local archetype = unit_data_extension:archetype()
					local base_stamina_template = archetype.stamina
					local current_stamina, max_stamina = Stamina.current_and_max_value(attacked_unit, stamina_read_component, base_stamina_template)

					if is_blockable and current_stamina <= 0.5 * max_stamina then
						Stamina.add_stamina(attacked_unit, 1)
					end
				end

				actual_damage_dealt = Damage.deal_damage(attacked_unit, target_breed_or_nil, attacking_unit, attacking_unit_owner_unit, result, attack_type, damage_profile, damage, permanent_damage, tougness_damage, hit_actor, attack_direction, hit_zone_name, herding_template_or_nil, is_critical_strike, damage_type, hit_world_position_or_nil, wounds_shape, instakill)
			end
		end
	end

	if damage_through_block then
		result = attack_results.blocked
	end

	return result, damage_dealt, damage_absorbed, damage, permanent_damage, one_hit_kill, actual_damage_dealt
end

function _already_procced(triggered_proc_events_or_nil, proc_event)
	if not triggered_proc_events_or_nil then
		return false
	end

	return triggered_proc_events_or_nil[proc_event]
end

function _handle_buffs(is_server, triggered_proc_events_or_nil, damage_profile, attacker_buff_extension_or_nil, target_buff_extension_or_nil, attacked_unit, damage, damage_absorbed, attack_result, stagger_result, hit_zone_name, is_critical_strike, is_backstab, hit_weakspot, one_hit_kill, attack_type, attacking_unit, attacking_owner_unit, attack_direction, damage_efficiency, target_index, target_number, attacker_breed_or_nil, target_breed_or_nil, damage_type, charge_level, hit_world_position_or_nil)
	if not attacker_buff_extension_or_nil and not target_buff_extension_or_nil then
		return
	end

	local attacker_unit_data_extension = ScriptUnit.has_extension(attacking_owner_unit, "unit_data_system")
	local attacker_is_player = Breed.is_player(attacker_breed_or_nil)
	local alternative_fire = false

	if attacker_is_player then
		local alternate_fire_component = attacker_unit_data_extension:read_component("alternate_fire")
		alternative_fire = alternate_fire_component.is_active
	end

	local attack_direction_box = Vector3Box(attack_direction)
	local hit_world_position_box_or_nil = hit_world_position_or_nil and Vector3Box(hit_world_position_or_nil)
	local should_proc = not damage_type or not damage_types_no_proc[damage_type]

	if should_proc and attacker_buff_extension_or_nil and not damage_profile.skip_on_hit_proc and not _already_procced(triggered_proc_events_or_nil, proc_events.on_hit) then
		local attacker_param_table = attacker_buff_extension_or_nil:request_proc_event_param_table()

		if attacker_param_table then
			attacker_param_table.alternative_fire = alternative_fire
			attacker_param_table.attack_direction = attack_direction_box
			attacker_param_table.attack_instigator_unit = attacking_unit
			attacker_param_table.attack_type = attack_type
			attacker_param_table.attacked_unit = attacked_unit
			attacker_param_table.attacking_unit = attacking_owner_unit
			attacker_param_table.breed_name = target_breed_or_nil and target_breed_or_nil.name
			attacker_param_table.damage = damage
			attacker_param_table.damage_efficiency = damage_efficiency
			attacker_param_table.damage_profile = damage_profile
			attacker_param_table.damage_type = damage_type
			attacker_param_table.hit_weakspot = hit_weakspot
			attacker_param_table.hit_world_position = hit_world_position_box_or_nil
			attacker_param_table.is_backstab = is_backstab
			attacker_param_table.is_critical_strike = is_critical_strike
			attacker_param_table.melee_attack_strength = damage_profile.melee_attack_strength
			attacker_param_table.one_hit_kill = one_hit_kill
			attacker_param_table.attack_result = attack_result
			attacker_param_table.stagger_result = stagger_result
			attacker_param_table.sticky_attack = damage_profile.sticky_attack
			attacker_param_table.tags = target_breed_or_nil and target_breed_or_nil.tags
			attacker_param_table.target_index = target_index
			attacker_param_table.target_number = target_number
			attacker_param_table.weapon_special = damage_profile.weapon_special
			attacker_param_table.charge_level = charge_level
			attacker_param_table.hit_zone_name = hit_zone_name

			attacker_buff_extension_or_nil:add_proc_event(proc_events.on_hit, attacker_param_table)
		end
	end

	if attack_result == attack_results.died and attacker_buff_extension_or_nil and not _already_procced(triggered_proc_events_or_nil, proc_events.on_kill) then
		local attacker_param_table = attacker_buff_extension_or_nil:request_proc_event_param_table()

		if attacker_param_table then
			attacker_param_table.alternative_fire = alternative_fire
			attacker_param_table.attack_direction = attack_direction_box
			attacker_param_table.attack_instigator_unit = attacking_unit
			attacker_param_table.attack_type = attack_type
			attacker_param_table.attacked_unit = attacked_unit
			attacker_param_table.attacking_unit = attacking_owner_unit
			attacker_param_table.breed_name = target_breed_or_nil and target_breed_or_nil.name
			attacker_param_table.damage = damage
			attacker_param_table.damage_efficiency = damage_efficiency
			attacker_param_table.damage_profile = damage_profile
			attacker_param_table.damage_type = damage_type
			attacker_param_table.hit_weakspot = hit_weakspot
			attacker_param_table.hit_world_position = hit_world_position_box_or_nil
			attacker_param_table.is_backstab = is_backstab
			attacker_param_table.is_critical_strike = is_critical_strike
			attacker_param_table.melee_attack_strength = damage_profile.melee_attack_strength
			attacker_param_table.one_hit_kill = one_hit_kill
			attacker_param_table.attack_result = attack_result
			attacker_param_table.stagger_result = stagger_result
			attacker_param_table.sticky_attack = damage_profile.sticky_attack
			attacker_param_table.tags = target_breed_or_nil and target_breed_or_nil.tags
			attacker_param_table.target_index = target_index
			attacker_param_table.target_number = target_number
			attacker_param_table.weapon_special = damage_profile.weapon_special
			attacker_param_table.charge_level = charge_level

			attacker_buff_extension_or_nil:add_proc_event(proc_events.on_kill, attacker_param_table)
		end
	end

	if damage > 0 and attacker_buff_extension_or_nil and not _already_procced(triggered_proc_events_or_nil, proc_events.on_damage_dealt) then
		local attacker_param_table = attacker_buff_extension_or_nil:request_proc_event_param_table()

		if attacker_param_table then
			attacker_param_table.alternative_fire = alternative_fire
			attacker_param_table.attack_direction = attack_direction_box
			attacker_param_table.attack_instigator_unit = attacking_unit
			attacker_param_table.attack_type = attack_type
			attacker_param_table.attacked_unit = attacked_unit
			attacker_param_table.attacking_unit = attacking_owner_unit
			attacker_param_table.breed_name = target_breed_or_nil and target_breed_or_nil.name
			attacker_param_table.damage = damage
			attacker_param_table.damage_efficiency = damage_efficiency
			attacker_param_table.damage_type = damage_type
			attacker_param_table.hit_weakspot = hit_weakspot
			attacker_param_table.hit_world_position = hit_world_position_box_or_nil
			attacker_param_table.is_backstab = is_backstab
			attacker_param_table.is_critical_strike = is_critical_strike
			attacker_param_table.melee_attack_strength = damage_profile.melee_attack_strength
			attacker_param_table.one_hit_kill = one_hit_kill
			attacker_param_table.attack_result = attack_result
			attacker_param_table.stagger_result = stagger_result
			attacker_param_table.sticky_attack = damage_profile.sticky_attack
			attacker_param_table.tags = target_breed_or_nil and target_breed_or_nil.tags
			attacker_param_table.target_index = target_index
			attacker_param_table.target_number = target_number
			attacker_param_table.weapon_special = damage_profile.weapon_special
			attacker_param_table.charge_level = charge_level

			attacker_buff_extension_or_nil:add_proc_event(proc_events.on_damage_dealt, attacker_param_table)
		end
	end

	if is_server and should_proc and not _already_procced(triggered_proc_events_or_nil, proc_events.on_player_hit_received) then
		local target_is_player = Breed.is_player(target_breed_or_nil)

		if target_buff_extension_or_nil and target_is_player then
			local target_param_table = target_buff_extension_or_nil:request_proc_event_param_table()

			if target_param_table then
				target_param_table.alternative_fire = alternative_fire
				target_param_table.attack_direction = Vector3Box(attack_direction)
				target_param_table.attack_instigator_unit = attacking_unit
				target_param_table.attack_type = attack_type
				target_param_table.attacked_unit = attacked_unit
				target_param_table.attacking_unit = attacking_owner_unit
				target_param_table.damage = damage
				target_param_table.damage_absorbed = damage_absorbed
				target_param_table.damage_efficiency = damage_efficiency
				target_param_table.damage_type = damage_type
				target_param_table.hit_weakspot = hit_weakspot
				target_param_table.is_backstab = is_backstab
				target_param_table.is_critical_strike = is_critical_strike
				target_param_table.melee_attack_strength = damage_profile.melee_attack_strength
				target_param_table.attack_result = attack_result
				target_param_table.sticky_attack = damage_profile.sticky_attack
				target_param_table.tags = target_breed_or_nil and target_breed_or_nil.tags
				target_param_table.weapon_special = damage_profile.weapon_special

				target_buff_extension_or_nil:add_proc_event(proc_events.on_player_hit_received, target_param_table)
			end
		end
	end
end

function _record_stats(attack_result, attack_type, attacked_unit, attacking_unit, damage_absorbed, damage_dealt, hit_zone_name, damage_profile, attacking_item, attacked_action, attacker_breed_or_nil, target_breed_or_nil, damage_type, target_buff_extension, is_critical_hit, stagger_result, stagger_type)
	local did_damage = damage_dealt > 0
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local attacked_player = player_unit_spawn_manager:owner(attacked_unit)
	local attacking_player = player_unit_spawn_manager:owner(attacking_unit)
	local attacked_is_human = attacked_player and attacked_player:is_human_controlled()
	local attacking_is_human = attacking_player and attacking_player:is_human_controlled()
	local attacked_unit_id = Managers.state.unit_spawner:game_object_id(attacked_unit)
	local damage_profile_name = damage_profile and damage_profile.name
	local is_weapon_special = damage_profile.weapon_special
	local attacked_unit_blackboard = BLACKBOARDS[attacked_unit]
	local target_breed_name_or_nil = target_breed_or_nil and target_breed_or_nil.name

	if attacking_player then
		local weapon_template_or_nil = attacking_item and WeaponTemplate.weapon_template_from_item(attacking_item)
		local weapon_template_name = weapon_template_or_nil and weapon_template_or_nil.name or "none"
		local attacked_position_or_nil = POSITION_LOOKUP[attacked_unit]
		local attacking_position_or_nil = POSITION_LOOKUP[attacking_unit]
		local either_unit_lacks_position = not attacked_position_or_nil or not attacking_position_or_nil
		local distance_between_units = either_unit_lacks_position and 0 or Vector3.length(attacked_position_or_nil - attacking_position_or_nil)
		local rounded_distance_between_units = math.round(distance_between_units)
		local attacking_health_extension_or_nil = ScriptUnit.has_extension(attacking_unit, "health_system")
		local attacking_health_percent = attacking_health_extension_or_nil and attacking_health_extension_or_nil:current_health_percent() or 0
		local target_buff_keywords = target_buff_extension and target_buff_extension:keywords()
		local attacked_health_extension_or_nil = ScriptUnit.has_extension(attacked_unit, "health_system")
		local solo_kill = false

		if attacked_health_extension_or_nil then
			local damaging_players = attacked_health_extension_or_nil.damaging_players and attacked_health_extension_or_nil:damaging_players()

			if damaging_players and #damaging_players == 1 and damaging_players[1] == attacking_player then
				solo_kill = true
			end
		end

		if attacking_is_human then
			Managers.stats:record_damage(attacking_player, target_breed_or_nil, weapon_template_name, attack_result, attack_type, hit_zone_name, damage_profile_name, rounded_distance_between_units, attacking_health_percent, attacked_action, attacked_unit_id, damage_type, damage_dealt, is_critical_hit, is_weapon_special, stagger_result, stagger_type)
		end

		if attack_result == attack_results.died then
			Managers.telemetry.stats_kill = true

			Managers.stats:record_team_kill(target_breed_name_or_nil, attack_type)

			if attacking_is_human then
				Managers.stats:record_kill(attacking_player, target_breed_or_nil, weapon_template_name, attack_type, hit_zone_name, damage_profile_name, distance_between_units, attacking_health_percent, attacked_action, attacked_unit_id, target_buff_keywords, damage_type, is_critical_hit, is_weapon_special, solo_kill, attacked_unit_blackboard)
			end
		end
	end

	if attacked_player then
		if attack_result == attack_results.blocked then
			local attacker_data_extension = ScriptUnit.extension(attacked_unit, "unit_data_system")
			local weapon_action_component = attacker_data_extension:read_component("weapon_action")
			local target_weapon_template = weapon_action_component and WeaponTemplate.current_weapon_template(weapon_action_component)
			local weapon_template_name = target_weapon_template and target_weapon_template.name

			Managers.stats:record_team_blocked_damage(damage_absorbed)

			if attacked_is_human then
				Managers.stats:record_blocked_damage(attacked_player, damage_absorbed, weapon_template_name)
			end
		end

		local did_damage_to_health = did_damage and attack_result ~= attack_results.toughness_absorbed

		if did_damage_to_health then
			Managers.stats:record_team_damage_taken(damage_dealt)

			if attacked_is_human then
				local is_attacker_elite = attacker_breed_or_nil and attacker_breed_or_nil.tags and attacker_breed_or_nil.tags.elite

				Managers.stats:record_player_damage_taken(attacked_player, damage_dealt, attack_type, is_attacker_elite)
			end
		end
	end
end

local function _format_weapon_name(name)
	local slash = name:find("/")

	while slash do
		name = name:sub(slash + 1)
		slash = name:find("/")
	end

	return name
end

local TelemetryHelper = require("scripts/managers/telemetry/telemetry_helper")

function _record_telemetry(attacking_unit, attacked_unit, attack_result, attack_type, damage_dealt, damage_profile, damage_type, damage, permanent_damage, actual_damage_dealt, damage_absorbed, attacker_breed_or_nil, target_breed_or_nil, instakill)
	local attacking_player = attacking_unit and Managers.state.player_unit_spawn:owner(attacking_unit)
	local visual_loadout_extension = attacking_unit and ScriptUnit.has_extension(attacking_unit, "visual_loadout_system")
	local attack_weapon = visual_loadout_extension and visual_loadout_extension:telemetry_wielded_weapon()
	local attack_weapon_name = attack_weapon and _format_weapon_name(attack_weapon.name)
	local attacked_player = attacked_unit and Managers.state.player_unit_spawn:owner(attacked_unit)
	local attacker_position = TelemetryHelper.unit_position(attacking_unit)
	local victim_position = TelemetryHelper.unit_position(attacked_unit)
	local data = {
		reason = "damage",
		attacker_position = attacker_position,
		victim_position = victim_position,
		attack_type = attack_type,
		weapon = attack_weapon_name,
		damage_profile = damage_profile.name,
		damage_type = damage_type,
		damage = damage,
		permanent_damage = permanent_damage,
		actual_damage = actual_damage_dealt or 0,
		damage_absorbed = damage_absorbed
	}

	if attacking_player then
		data.victim = target_breed_or_nil and target_breed_or_nil.name
		data.is_boss = target_breed_or_nil and target_breed_or_nil.is_boss

		if damage_dealt > 0 then
			Managers.telemetry_reporters:reporter("player_dealt_damage"):register_event(attacking_player, data)
		end

		if attack_result == attack_results.died then
			Managers.telemetry_events:player_killed_enemy(attacking_player, data)
		end
	end

	if attacked_player then
		data.attacker = attacker_breed_or_nil and attacker_breed_or_nil.name
		data.is_boss = attacker_breed_or_nil and attacker_breed_or_nil.is_boss

		if (damage_dealt > 0 or damage_absorbed > 0) and not instakill then
			Managers.telemetry_reporters:reporter("player_taken_damage"):register_event(attacked_player, data)
		end

		local unit_data_extension = ScriptUnit.extension(attacked_unit, "unit_data_system")
		local dead_state_input = unit_data_extension:read_component("dead_state_input")
		local knocked_down_state_input = unit_data_extension:read_component("knocked_down_state_input")

		if attack_result ~= attack_results.damaged then
			if dead_state_input.die then
				Managers.telemetry_events:player_died(attacked_player, data)
			elseif knocked_down_state_input.knock_down and attack_result == attack_results.knock_down then
				Managers.telemetry_events:player_knocked_down(attacked_player, data)
			end
		end
	end
end

function _handle_result(attacking_unit_owner_unit, attacked_unit, attack_result, attack_type, attacker_breed_or_nil, target_breed_or_nil, damage_dealt, damage_absorbed, damage_profile, damage_type, actual_damage_dealt)
	if not attacking_unit_owner_unit then
		return
	end

	local extension_manager = Managers.state.extension
	local side_system = extension_manager:system("side_system")
	local target_is_ally = side_system:is_ally(attacking_unit_owner_unit, attacked_unit)
	local target_is_enemy = side_system:is_enemy(attacking_unit_owner_unit, attacked_unit)
	local attacker_is_player = Breed.is_player(attacker_breed_or_nil)
	local target_is_player = Breed.is_player(target_breed_or_nil)
	local is_ranged_friendly_fire = attack_type == attack_types.ranged and target_is_ally and attacker_is_player and target_is_player

	if target_is_enemy then
		local target_is_minion = Breed.is_minion(target_breed_or_nil)
		local target_is_character = Breed.is_character(target_breed_or_nil)

		if target_is_character and attack_result ~= attack_results.died then
			local perception_extension = ScriptUnit.extension(attacked_unit, "perception_system")

			if target_is_minion then
				MinionPerception.attempt_aggro(perception_extension)
			end

			Threat.add_threat(attacked_unit, attacking_unit_owner_unit, damage_dealt, damage_absorbed, damage_profile)
		end

		if attack_type == attack_types.ranged then
			if attack_result == attack_results.died and attacker_is_player and target_is_minion then
				local combat_vector_system = extension_manager:system("combat_vector_system")

				combat_vector_system:add_main_aggro_target_score("killed_unit", attacking_unit_owner_unit, attacked_unit)
			end
		elseif attack_type == attack_types.melee and attacker_is_player and attack_result == attack_results.died then
			Toughness.replenish(attacking_unit_owner_unit, toughness_replenish_types.melee_kill)
		end
	elseif is_ranged_friendly_fire then
		Vo.friendly_fire_counter_event(attacking_unit_owner_unit, attacked_unit)
	end
end

local _backstab_gear_wwise_event_options = {}

function _trigger_backstab_interfacing(attacking_unit, attack_type)
	local attacking_unit_fx_extension = ScriptUnit.has_extension(attacking_unit, "fx_system")

	if attacking_unit_fx_extension then
		local except_sender = true

		table.clear(_backstab_gear_wwise_event_options)

		_backstab_gear_wwise_event_options.attack_type = attack_type
		local optional_position = nil

		attacking_unit_fx_extension:trigger_exclusive_gear_wwise_event("backstab_interfacing", _backstab_gear_wwise_event_options, optional_position, except_sender)
	end
end

local _flank_gear_wwise_event_options = {}

function _trigger_flank_interfacing(attacking_unit, attack_type)
	local attacking_unit_fx_extension = ScriptUnit.has_extension(attacking_unit, "fx_system")

	if attacking_unit_fx_extension then
		local except_sender = true

		table.clear(_flank_gear_wwise_event_options)

		_flank_gear_wwise_event_options.attack_type = attack_type
		local optional_position = nil

		attacking_unit_fx_extension:trigger_exclusive_gear_wwise_event("flank_interfacing", _flank_gear_wwise_event_options, optional_position, except_sender)
	end
end

local _elite_special_killed_gear_wwise_event_options = {}

function _trigger_elite_special_kill_interfacing(attacking_unit, attacker_breed_or_nil, target_breed_or_nil, is_server)
	if not is_server then
		return
	end

	local attacker_is_player = Breed.is_player(attacker_breed_or_nil)

	if not attacker_is_player then
		return
	end

	local attacking_unit_fx_extension = ScriptUnit.has_extension(attacking_unit, "fx_system")
	local enemy_type = Breed.enemy_type(target_breed_or_nil)
	local is_monster = target_breed_or_nil and target_breed_or_nil.tags.monster
	local is_captain = target_breed_or_nil and target_breed_or_nil.tags.captain

	if attacking_unit_fx_extension and enemy_type then
		table.clear(_elite_special_killed_gear_wwise_event_options)

		_elite_special_killed_gear_wwise_event_options.enemy_type = enemy_type
		local except_sender = false
		local optional_position = nil

		if is_captain or is_monster then
			local players = Managers.player:players()

			for _, player in pairs(players) do
				local player_unit = player.player_unit
				local player_fx_extension = ALIVE[player_unit] and ScriptUnit.has_extension(player_unit, "fx_system")

				if player_fx_extension then
					player_fx_extension:trigger_exclusive_gear_wwise_event("elite_special_killed_stinger", _elite_special_killed_gear_wwise_event_options, optional_position, except_sender)
				end
			end
		else
			attacking_unit_fx_extension:trigger_exclusive_gear_wwise_event("elite_special_killed_stinger", _elite_special_killed_gear_wwise_event_options, optional_position, except_sender)
		end
	end
end

local tg_on_attack_execute_data = {}

function _trigger_training_grounds_events(item, attack_direction, attack_result, attack_type, attacked_unit, attacking_unit, damage, damage_profile, damage_type, hit_weakspot, is_critical_strike, wounds_shape)
	local hit_unit_data_extension = ScriptUnit.has_extension(attacked_unit, "unit_data_system")
	local target_breed_or_nil = hit_unit_data_extension and hit_unit_data_extension:breed()

	table.clear(tg_on_attack_execute_data)

	tg_on_attack_execute_data.item = item
	tg_on_attack_execute_data.attack_direction = attack_direction
	tg_on_attack_execute_data.attack_result = attack_result
	tg_on_attack_execute_data.attack_type = attack_type
	tg_on_attack_execute_data.attacked_unit = attacked_unit
	tg_on_attack_execute_data.attacking_unit = attacking_unit
	tg_on_attack_execute_data.breed_or_nil = target_breed_or_nil
	tg_on_attack_execute_data.damage_profile = damage_profile
	tg_on_attack_execute_data.hit_weakspot = hit_weakspot
	tg_on_attack_execute_data.is_critical_strike = is_critical_strike

	Managers.event:trigger("tg_on_attack_execute", tg_on_attack_execute_data)
end

return Attack
