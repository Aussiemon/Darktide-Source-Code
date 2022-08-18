local Armor = require("scripts/utilities/attack/armor")
local AttackingUnitResolver = require("scripts/utilities/attack/attacking_unit_resolver")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Backstab = require("scripts/utilities/attack/backstab")
local Block = require("scripts/utilities/attack/block")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Damage = require("scripts/utilities/attack/damage")
local DamageCalculation = require("scripts/utilities/attack/damage_calculation")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local DamageTakenCalculation = require("scripts/utilities/attack/damage_taken_calculation")
local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local FriendlyFire = require("scripts/utilities/attack/friendly_fire")
local HitReaction = require("scripts/utilities/attack/hit_reaction")
local MinionPerception = require("scripts/utilities/minion_perception")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local Suppression = require("scripts/utilities/attack/suppression")
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
local toughness_replenish_types = ToughnessSettings.replenish_types
local _execute, _handle_attack, _handle_buffs, _handle_result, _has_armor_penetrating_buff, _record_stats, _record_telemetry, _trigger_backstab_interfacing, _trigger_elite_special_kill_interfacing, ARGS, NUM_ARGS = nil
local Attack = {}
local attack_args_temp = {}

Attack.execute = function (attacked_unit, damage_profile, ...)
	table.clear(attack_args_temp)

	local num_args = select("#", ...)

	for i = 1, num_args, 2 do
		local arg, val = select(i, ...)

		fassert(ARGS[arg], "Argument %q is not a defined Attack argument.", arg)

		attack_args_temp[ARGS[arg]] = val
	end

	for i = 1, NUM_ARGS, 1 do
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

local min_power_level = PowerLevelSettings.min_power_level
local max_power_level = PowerLevelSettings.max_power_level
ARGS = {
	{
		default = 0,
		name = "target_index"
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
		default = false,
		name = "has_power_boost"
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
	}
}
NUM_ARGS = #ARGS

for i = 1, NUM_ARGS, 1 do
	local argument = ARGS[i]
	local arg_name = argument.name
	ARGS[arg_name] = i
end

function _execute(attacked_unit, damage_profile, target_index, power_level, charge_level, is_critical_strike, dropoff_scalar, has_power_boost, attack_direction, instakill, hit_zone_name, hit_world_position, hit_actor, attacking_unit, attack_type, herding_template, damage_type, auto_completed_action, item, wounds_shape)
	local was_alive_at_attack_start = HEALTH_ALIVE[attacked_unit]
	attacking_unit = ALIVE[attacking_unit] and attacking_unit
	local target_settings = DamageProfile.target_settings(damage_profile, target_index)
	local damage_profile_lerp_values = DamageProfile.lerp_values(damage_profile, attacking_unit, target_index)
	local unit_data_extension = ScriptUnit.has_extension(attacked_unit, "unit_data_system")
	local breed_or_nil = unit_data_extension and unit_data_extension:breed()
	local is_player_character = Breed.is_player(breed_or_nil)
	local attacking_unit_data_extension = ScriptUnit.has_extension(attacking_unit, "unit_data_system")
	local attacking_breed_or_nil = attacking_unit_data_extension and attacking_unit_data_extension:breed()
	local attacking_unit_owner_unit = AttackingUnitResolver.resolve(attacking_unit)
	local attacker_buff_extension = ScriptUnit.has_extension(attacking_unit_owner_unit, "buff_system")
	local target_buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")
	local is_backstab = Backstab.is_attack_backstab(attacked_unit, attacking_unit, attack_type, attack_direction)

	if is_backstab then
		_trigger_backstab_interfacing(attacking_unit_owner_unit, attack_type)
	end

	local hit_weakspot = false
	local hit_shield = false

	if breed_or_nil then
		hit_weakspot, hit_shield = Weakspot.hit_weakspot(breed_or_nil, hit_zone_name, attacker_buff_extension, attack_type)
	end

	local is_server = Managers.state.game_session:is_server()
	local calculated_damage, damage_efficiency = nil

	if instakill then
		local health_extension = ScriptUnit.extension(attacked_unit, "health_system")
		damage_efficiency = damage_efficiencies.full
		calculated_damage = health_extension:damaged_max_health()
	else
		local target_blackboard = BLACKBOARDS[attacked_unit]
		local stagger_count = 0
		local num_triggered_staggers = 0

		if not is_player_character and target_blackboard then
			local stagger_component = target_blackboard.stagger
			stagger_count = stagger_component.count
			num_triggered_staggers = stagger_component.num_triggered_staggers
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
			local armor_type = Armor.armor_type(attacked_unit, breed_or_nil, hit_zone_name, attack_type)
			local is_attacked_unit_suppressed = Suppression.is_suppressed(attacked_unit)
			calculated_damage, damage_efficiency = DamageCalculation.calculate(damage_profile, target_settings, damage_profile_lerp_values, hit_zone_name, power_level, charge_level, breed_or_nil, attacking_breed_or_nil, is_critical_strike, is_backstab, dropoff_scalar, has_power_boost, attack_type, attacker_stat_buffs, target_stat_buffs, armor_penetrating, target_toughness_extension, armor_type, stagger_count, num_triggered_staggers, is_attacked_unit_suppressed, distance, attacked_unit, attacking_unit, auto_completed_action)
		end
	end

	local damage_dealt, attack_result, damage_absorbed, stagger_result = nil
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

	attack_result, damage_dealt, damage_absorbed = _handle_attack(is_server, instakill, target_is_assisted, target_is_hogtied, attacked_unit, breed_or_nil, calculated_damage, attacking_unit, attacking_unit_owner_unit, hit_zone_name, damage_profile, attack_direction, hit_actor, attack_type, herding_template, is_critical_strike, hit_world_position, damage_type, target_weapon_template, unit_data_extension, wounds_shape)

	if is_server then
		stagger_result = HitReaction.apply(damage_profile, damage_profile_lerp_values, target_weapon_template, breed_or_nil, attack_result, attacked_unit, attacking_unit, attack_direction, hit_world_position, target_settings, power_level, charge_level, is_critical_strike, is_backstab, hit_weakspot, dropoff_scalar, has_power_boost, attack_type, herding_template, hit_shield)
	end

	if was_alive_at_attack_start and breed_or_nil then
		_handle_buffs(damage_profile, attacker_buff_extension, attacked_unit, damage_dealt, attack_result, is_critical_strike, is_backstab, hit_weakspot, attack_type, attacking_unit, attacking_unit_owner_unit, attack_direction, damage_efficiency, breed_or_nil)

		if is_server then
			_handle_result(attacking_unit_owner_unit, attacked_unit, attack_result, attack_type, breed_or_nil, damage_dealt, damage_absorbed, damage_profile)
			Managers.state.attack_report:add_attack_result(damage_profile, attacked_unit, attacking_unit_owner_unit, attack_direction, hit_world_position, hit_weakspot, damage_dealt, attack_result, attack_type)

			if DEDICATED_SERVER then
				_record_stats(attack_result, attack_type, attacked_unit, attacking_unit_owner_unit, damage_absorbed, damage_dealt, hit_zone_name, item)
				_record_telemetry(attacking_unit, attacked_unit, attack_result, attack_type, damage_dealt, damage_profile, damage_type)
			end
		end
	end

	if was_alive_at_attack_start and attack_result == attack_results.died then
		_trigger_elite_special_kill_interfacing(attacking_unit_owner_unit, breed_or_nil)
	end

	if damage_dealt <= 0 and not is_player_character and breed_or_nil then
		local breed_name = breed_or_nil.name
		local dialogue_breed_settings = DialogueBreedSettings[breed_name]
		local no_damage_vo_event = dialogue_breed_settings and dialogue_breed_settings.no_damage_vo_event

		if no_damage_vo_event then
			Vo.enemy_generic_vo_event(attacked_unit, no_damage_vo_event, breed_name)
		end
	end

	return damage_dealt, attack_result, damage_efficiency, stagger_result
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

function _handle_attack(is_server, instakill, target_is_assisted, target_is_hogtied, attacked_unit, breed_or_nil, calculated_damage, attacking_unit, attacking_unit_owner_unit, hit_zone_name, damage_profile, attack_direction, hit_actor, attack_type, herding_template_or_nil, is_critical_strike, hit_world_position_or_nil, damage_type, target_weapon_template, unit_data_extension, wounds_shape)
	local damage_dealt, result, damage_absorbed = nil

	if not instakill and Block.is_blocking(attacked_unit, attack_type, target_weapon_template, is_server) and Block.attack_is_blockable(damage_profile) then
		local side_system = Managers.state.extension:system("side_system")
		local is_ally = side_system:is_ally(attacked_unit, attacking_unit_owner_unit)
		local damage_allowed = not is_ally or FriendlyFire.is_enabled(attacking_unit_owner_unit, attacked_unit)
		damage_dealt = 0
		damage_absorbed = calculated_damage
		result = (damage_allowed and attack_results.blocked) or attack_results.friendly_fire

		if is_server and unit_data_extension and damage_allowed then
			local block_component = unit_data_extension:write_component("block")
			block_component.has_blocked = true
		end
	elseif not instakill and target_is_assisted then
		damage_dealt = 0
		damage_absorbed = calculated_damage
		result = attack_results.dodged
	elseif not instakill and target_is_hogtied then
		damage_dealt = 0
		damage_absorbed = 0
		result = attack_results.dodged
	else
		local is_invulnerable, is_damage_allowed, health_setting, current_health_damage, current_permanent_damage, max_health, toughness_template, weapon_toughness_template, current_toughness_damage, movement_state, shield_setting, attacked_unit_stat_buffs, attacked_unit_keywords = DamageTakenCalculation.get_calculation_parameters(attacked_unit, breed_or_nil, damage_profile, attacking_unit, attacking_unit_owner_unit, hit_actor)
		local damage, permanent_damage, tougness_damage = nil
		result, damage, permanent_damage, tougness_damage, damage_absorbed = DamageTakenCalculation.calculate_attack_result(calculated_damage, damage_profile, attack_type, attack_direction, instakill, is_invulnerable, is_damage_allowed, health_setting, current_health_damage, current_permanent_damage, max_health, toughness_template, weapon_toughness_template, current_toughness_damage, movement_state, shield_setting, attacked_unit_stat_buffs, attacked_unit_keywords)
		damage_dealt = damage + permanent_damage

		if is_damage_allowed and is_server then
			Damage.deal_damage(attacked_unit, breed_or_nil, attacking_unit, attacking_unit_owner_unit, result, attack_type, damage_profile, damage, permanent_damage, tougness_damage, hit_actor, attack_direction, hit_zone_name, herding_template_or_nil, is_critical_strike, damage_type, hit_world_position_or_nil, wounds_shape)
		end
	end

	return result, damage_dealt, damage_absorbed
end

function _handle_buffs(damage_profile, attacker_buff_extension, attacked_unit, damage, result, is_critical_strike, is_backstab, hit_weakspot, attack_type, attacking_unit, attacking_owner_unit, attack_direction, damage_efficiency, breed)
	if not attacker_buff_extension then
		return
	end

	if damage_profile.skip_on_hit_proc then
		return
	end

	local unit_data_extension = ScriptUnit.has_extension(attacking_unit, "unit_data_system")
	local attacking_breed_or_nil = unit_data_extension and unit_data_extension:breed()
	local attacker_is_player = Breed.is_player(attacking_breed_or_nil)
	local alternative_fire = false

	if attacker_is_player then
		local alternate_fire_component = unit_data_extension:read_component("alternate_fire")
		alternative_fire = alternate_fire_component.is_active
	end

	local param_table = attacker_buff_extension:request_proc_event_param_table()
	param_table.attacked_unit = attacked_unit
	param_table.attacking_unit = attacking_owner_unit
	param_table.attack_instigator_unit = attacking_unit
	param_table.damage = damage
	param_table.result = result
	param_table.is_critical_strike = is_critical_strike
	param_table.is_backstab = is_backstab
	param_table.hit_weakspot = hit_weakspot
	param_table.attack_type = attack_type
	param_table.alternative_fire = alternative_fire
	param_table.melee_attack_strength = damage_profile.melee_attack_strength
	param_table.damage_type = damage_profile.damage_type
	param_table.tags = breed and breed.tags
	param_table.sticky_attack = damage_profile.sticky_attack
	param_table.weapon_special = damage_profile.weapon_special
	param_table.attack_direction = Vector3Box(attack_direction)
	param_table.damage_efficiency = damage_efficiency

	attacker_buff_extension:add_proc_event(proc_events.on_hit, param_table)
end

function _record_stats(attack_result, attack_type, attacked_unit, attacking_unit, damage_absorbed, damage_dealt, hit_zone_name, attacking_item)
	local did_damage = damage_dealt > 0
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local attacked_player = player_unit_spawn_manager:owner(attacked_unit)
	local attacking_player = player_unit_spawn_manager:owner(attacking_unit)
	local attacked_is_human = attacked_player and attacked_player:is_human_controlled()
	local attacking_is_human = attacking_player and attacking_player:is_human_controlled()
	local attacked_unit_id = Managers.state.unit_spawner:game_object_id(attacked_unit)
	local attacked_data_extension = ScriptUnit.extension(attacked_unit, "unit_data_system")
	local attacked_breed = attacked_data_extension:breed()
	local attacked_breed_name_or_nil = attacked_breed.name

	if attacking_player then
		local behaviour_extension = ScriptUnit.has_extension(attacked_unit, "behavior_system")
		local attacked_action = behaviour_extension and behaviour_extension:running_action()
		local weapon_template_or_nil = attacking_item and WeaponTemplate.weapon_template_from_item(attacking_item)
		local weapon_template_name = (weapon_template_or_nil and weapon_template_or_nil.name) or "none"
		local attacked_position_or_nil = POSITION_LOOKUP[attacked_unit]
		local attacking_position_or_nil = POSITION_LOOKUP[attacking_unit]
		local either_unit_lacks_position = not attacked_position_or_nil or not attacking_position_or_nil
		local distance_between_units = (either_unit_lacks_position and 0) or Vector3.length(attacked_position_or_nil - attacking_position_or_nil)
		local attacking_health_extension_or_nil = ScriptUnit.has_extension(attacking_unit, "health_system")
		local attacking_health_percent = (attacking_health_extension_or_nil and attacking_health_extension_or_nil:current_health_percent()) or 0

		if did_damage and attacking_is_human then
			Managers.stats:record_damage(attacking_player, attacked_breed_name_or_nil, weapon_template_name, attack_type, hit_zone_name, distance_between_units, attacking_health_percent, attacked_action, attacked_unit_id, damage_dealt)
		end

		if attack_result == attack_results.died then
			Managers.stats:record_team_kill()

			if attacking_is_human then
				Managers.stats:record_kill(attacking_player, attacked_breed_name_or_nil, weapon_template_name, attack_type, hit_zone_name, distance_between_units, attacking_health_percent, attacked_action)
			end
		end
	end

	if attacked_player then
		if attack_result == attack_results.blocked and attacked_is_human then
			local weapon_action_component = attacked_data_extension:read_component("weapon_action")
			local target_weapon_template = weapon_action_component and WeaponTemplate.current_weapon_template(weapon_action_component)
			local weapon_template_name = target_weapon_template and target_weapon_template.name

			Managers.stats:record_blocked_damage(attacked_player, damage_absorbed, weapon_template_name)
		end

		local did_damage_to_health = did_damage and attack_result ~= attack_results.toughness_absorbed

		if did_damage_to_health then
			Managers.stats:record_team_damage_taken(damage_dealt)

			if attacked_is_human then
				Managers.stats:record_player_damage_taken(attacked_player, damage_dealt)
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

function _record_telemetry(attacking_unit, attacked_unit, attack_result, attack_type, damage_dealt, damage_profile, damage_type)
	local attacking_player = attacking_unit and Managers.state.player_unit_spawn:owner(attacking_unit)
	local attacking_unit_data_ext = ScriptUnit.has_extension(attacking_unit, "unit_data_system")
	local attacking_breed_or_nil = attacking_unit_data_ext and attacking_unit_data_ext:breed()
	local visual_loadout_extension = attacking_unit and ScriptUnit.has_extension(attacking_unit, "visual_loadout_system")
	local attack_weapon = visual_loadout_extension and visual_loadout_extension:wielded_weapon()
	local attack_weapon_name = attack_weapon and _format_weapon_name(attack_weapon.name)
	local attacked_player = attacked_unit and Managers.state.player_unit_spawn:owner(attacked_unit)
	local attacked_unit_data_ext = ScriptUnit.has_extension(attacked_unit, "unit_data_system")
	local attacked_breed_or_nil = attacked_unit_data_ext and attacked_unit_data_ext:breed()
	local data = {
		attacker_position = POSITION_LOOKUP[attacking_unit],
		victim_position = POSITION_LOOKUP[attacked_unit],
		attack_type = attack_type,
		weapon = attack_weapon_name,
		damage_profile = damage_profile.name,
		damage = damage_dealt,
		damage_type = damage_type
	}

	if attacking_player and attacking_player:is_human_controlled() then
		data.victim = attacked_breed_or_nil and attacked_breed_or_nil.name
		data.is_boss = attacked_breed_or_nil and attacked_breed_or_nil.is_boss

		if damage_dealt > 0 then
			Managers.telemetry_reporters:reporter("player_dealt_damage"):register_event(attacking_player, data)
		end

		if attack_result == attack_results.died then
			Managers.telemetry_events:player_killed_enemy(attacking_player, data)
		end
	end

	if attacked_player and attacked_player:is_human_controlled() then
		data.attacker = attacking_breed_or_nil and attacking_breed_or_nil.name
		data.is_boss = attacking_breed_or_nil and attacking_breed_or_nil.is_boss

		if damage_dealt > 0 then
			Managers.telemetry_reporters:reporter("player_taken_damage"):register_event(attacked_player, data)
		end

		if attack_result == attack_results.knock_down then
			Managers.telemetry_events:player_knocked_down(attacked_player, data)
		elseif attack_result == attack_results.died then
			Managers.telemetry_events:player_died(attacked_player, data)
		end
	end
end

function _handle_result(attacking_unit_owner_unit, attacked_unit, attack_result, attack_type, breed_or_nil, damage_dealt, damage_absorbed, damage_profile)
	if not attacking_unit_owner_unit then
		return
	end

	local extension_manager = Managers.state.extension
	local side_system = extension_manager:system("side_system")
	local target_is_ally = side_system:is_ally(attacking_unit_owner_unit, attacked_unit)
	local target_is_enemy = side_system:is_enemy(attacking_unit_owner_unit, attacked_unit)
	local attacking_unit_data_extension = ScriptUnit.has_extension(attacking_unit_owner_unit, "unit_data_system")
	local attacking_breed_or_nil = attacking_unit_data_extension and attacking_unit_data_extension:breed()
	local attacker_is_player = Breed.is_player(attacking_breed_or_nil)
	local target_is_player = Breed.is_player(breed_or_nil)
	local is_ranged_friendly_fire = attack_type == attack_types.ranged and target_is_ally and attacker_is_player and target_is_player

	if target_is_enemy then
		local target_is_minion = Breed.is_minion(breed_or_nil)
		local target_is_character = Breed.is_character(breed_or_nil)

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
		Vo.friendly_fire_event(attacking_unit_owner_unit, attacked_unit)
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

		attacking_unit_fx_extension:trigger_exclusive_gear_wwise_event("play_trigger_backstab", _backstab_gear_wwise_event_options, optional_position, except_sender)
	end
end

local _elite_special_killed_gear_wwise_event_options = {}

function _trigger_elite_special_kill_interfacing(attacking_unit, attacked_unit_breed_or_nil)
	local unit_data_extension = ScriptUnit.has_extension(attacking_unit, "unit_data_system")
	local attacking_breed_or_nil = unit_data_extension and unit_data_extension:breed()
	local attacker_is_player = Breed.is_player(attacking_breed_or_nil)

	if not attacker_is_player then
		return
	end

	local attacking_unit_fx_extension = ScriptUnit.has_extension(attacking_unit, "fx_system")
	local minion_tag = nil
	local attack_breed_tags = attacked_unit_breed_or_nil and attacked_unit_breed_or_nil.tags

	if attack_breed_tags and attack_breed_tags.elite then
		minion_tag = "elite"
	elseif attack_breed_tags and attack_breed_tags.special then
		minion_tag = "special"
	elseif attack_breed_tags and attack_breed_tags.monster then
		minion_tag = "monster"
	elseif attack_breed_tags and attack_breed_tags.captain then
		minion_tag = "captain"
	end

	if attacking_unit_fx_extension and minion_tag then
		table.clear(_elite_special_killed_gear_wwise_event_options)

		_elite_special_killed_gear_wwise_event_options.minion_tag = minion_tag
		local except_sender = true
		local optional_position = nil

		attacking_unit_fx_extension:trigger_exclusive_gear_wwise_event("elite_special_killed_stinger", _elite_special_killed_gear_wwise_event_options, optional_position, except_sender)
	end
end

return Attack
