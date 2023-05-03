local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local BotPerceptionExtension = class("BotPerceptionExtension")
local IN_PROXIMITY_DISTANCE = 5
local MAX_PROXIMITY_ENEMIES = 10

BotPerceptionExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	local blackboard = BLACKBOARDS[unit]

	self:_init_blackboard_components(blackboard)

	self._seen_by_player_units = {}
	self._unit = unit
	self._player = extension_init_data.player
	self._enemies_in_proximity_update_timer = -math.huge
	self._enemies_in_proximity = {}
	self._num_enemies_in_proximity = 0
	local breed = extension_init_data.breed
	self._breed = breed
	local threat_config = breed.threat_config
	self._threat_config = threat_config
	self._threat_decay_disabled = threat_config.decay_disabled
	self._threat_units = {}
	self._target_selection_template = breed.target_selection_template
	self._side_system = Managers.state.extension:system("side_system")
	self._slot_system = Managers.state.extension:system("slot_system")
	self._broadphase_system = Managers.state.extension:system("broadphase_system")
	self._perception_system = Managers.state.extension:system("perception_system")
end

BotPerceptionExtension._init_blackboard_components = function (self, blackboard)
	local perception_component = Blackboard.write_component(blackboard, "perception")
	perception_component.aggro_target_enemy = nil
	perception_component.aggro_target_enemy_distance = 0
	perception_component.aggressive_mode = false
	perception_component.force_aid = false
	perception_component.priority_target_disabled_ally = nil
	perception_component.target_enemy = nil
	perception_component.target_enemy_distance = math.huge
	perception_component.target_enemy_type = "none"
	perception_component.target_enemy_reevaluation_t = 0
	perception_component.opportunity_target_enemy = nil
	perception_component.priority_target_enemy = nil
	perception_component.urgent_target_enemy = nil
	perception_component.target_ally = nil
	perception_component.target_ally_distance = math.huge
	perception_component.target_ally_need_type = "n/a"
	perception_component.target_ally_needs_aid = false
	perception_component.target_level_unit = nil
	perception_component.target_level_unit_distance = math.huge
	local behavior_component = blackboard.behavior
	self._behavior_component = behavior_component
	self._perception_component = perception_component
end

BotPerceptionExtension.extensions_ready = function (self, world, unit)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local locomotion_component = unit_data_extension:read_component("locomotion")
	self._locomotion_component = locomotion_component
	self._slot_extension = ScriptUnit.extension(unit, "slot_system")
	self._behavior_extension = ScriptUnit.extension(unit, "behavior_system")
	local player_unit_input_extension = ScriptUnit.extension(unit, "input_system")
	local bot_unit_input = player_unit_input_extension:bot_unit_input()
	self._bot_unit_input = bot_unit_input
	local group_extension = ScriptUnit.extension(unit, "group_system")
	local bot_group = group_extension:bot_group()
	self._bot_group = bot_group
end

BotPerceptionExtension.on_reload = function (self)
	local breed = self._breed
	local target_selection_template = breed.target_selection_template
	self._target_selection_template = target_selection_template
end

BotPerceptionExtension.enemies_in_proximity = function (self)
	return self._enemies_in_proximity, self._num_enemies_in_proximity
end

local broadphase_results = {}
local FORCED_PRIO_UPDATE_RANGE = 0.75

BotPerceptionExtension.pre_update = function (self, unit, dt, t)
	local Vector3_length_squared = Vector3.length_squared
	local side_system = self._side_system
	local side = side_system.side_by_unit[unit]
	local search_position = POSITION_LOOKUP[unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local ai_target_units = side.ai_target_units
	local player_units = side.valid_enemy_player_units
	local broadphase_system = self._broadphase_system
	local perception_system = self._perception_system
	local slot_system = self._slot_system
	local broadphase = broadphase_system.broadphase
	local num_hits = broadphase:query(search_position, FORCED_PRIO_UPDATE_RANGE, broadphase_results, enemy_side_names)

	for i = 1, num_hits do
		repeat
			local enemy_unit = broadphase_results[i]

			if not ai_target_units[enemy_unit] or player_units[enemy_unit] then
				break
			end

			local locomotion_extension = ScriptUnit.has_extension(enemy_unit, "locomotion_system")

			if locomotion_extension and Vector3_length_squared(locomotion_extension:current_velocity()) > 0 then
				perception_system:register_prioritized_unit_update(enemy_unit)

				local slot_extension = ScriptUnit.has_extension(enemy_unit, "slot_system")

				if slot_extension then
					slot_system:register_prioritized_user_unit_update(enemy_unit)
				end
			end
		until true
	end
end

BotPerceptionExtension.update = function (self, unit, dt, t)
	if self._player:is_human_controlled() then
		return
	end

	local side_system = self._side_system
	local perception_component = self._perception_component
	local behavior_component = self._behavior_component
	local bot_group = self._bot_group
	local side = side_system.side_by_unit[unit]
	local position = POSITION_LOOKUP[unit]

	self:_update_target_enemy(unit, position, perception_component, behavior_component, self._enemies_in_proximity, side, bot_group, dt, t)
	self:_update_target_ally(unit, position, perception_component, side, bot_group, t)
	self:_update_target_level_unit(unit, position, perception_component, t)
end

BotPerceptionExtension._update_target_enemy = function (self, self_unit, self_position, perception_component, behavior_component, enemies_in_proximity, side, bot_group, dt, t)
	local threat_decay_disabled = self._threat_decay_disabled

	if not threat_decay_disabled then
		self:_decay_threat(self_unit, dt)
	end

	local enemy_side_names = side:relation_side_names("enemy")
	local aggroed_units = side.aggroed_minion_target_units

	if self._enemies_in_proximity_update_timer < t then
		local broadphase = self._broadphase_system.broadphase
		local search_position = POSITION_LOOKUP[self_unit]
		local num_enemies_in_proximity = broadphase:query(search_position, IN_PROXIMITY_DISTANCE, enemies_in_proximity, enemy_side_names)
		local write_index = 0

		for read_index = 1, num_enemies_in_proximity do
			local enemy_unit = enemies_in_proximity[read_index]
			local data_extension = ScriptUnit.extension(enemy_unit, "unit_data_system")
			local breed = data_extension:breed()

			if not breed.not_bot_target and aggroed_units[enemy_unit] then
				write_index = write_index + 1
				enemies_in_proximity[write_index] = enemies_in_proximity[read_index]

				if MAX_PROXIMITY_ENEMIES <= write_index then
					break
				end
			end
		end

		for i = write_index + 1, num_enemies_in_proximity do
			enemies_in_proximity[i] = nil
		end

		self._num_enemies_in_proximity = write_index
		self._enemies_in_proximity_update_timer = t + 0.5 + 0.5 * math.random()
	end

	local num_enemies_in_proximity = self._num_enemies_in_proximity

	for i = num_enemies_in_proximity, 1, -1 do
		local enemy_unit = enemies_in_proximity[i]

		if not aggroed_units[enemy_unit] then
			table.swap_delete(enemies_in_proximity, i)

			self._num_enemies_in_proximity = self._num_enemies_in_proximity - 1
		end
	end

	local breed = self._breed
	local target_units = side.ai_target_units
	local template = self._target_selection_template

	template(self_unit, self_position, side, perception_component, behavior_component, breed, target_units, t, self._threat_units, bot_group, self._target_selection_debug_info)
end

BotPerceptionExtension._decay_threat = function (self, unit, dt)
	local threat_units = self._threat_units
	local threat_config = self._threat_config
	local threat_decay_per_second = threat_config.threat_decay_per_second
	local threat_decay = threat_decay_per_second * dt

	for threat_unit, threat in pairs(threat_units) do
		if threat > 0 then
			threat_units[threat_unit] = math.max(threat - threat_decay, 0)
		else
			threat_units[threat_unit] = nil
		end
	end
end

local DEFAULT_THREAT_MULTIPLIER = 1

BotPerceptionExtension.add_threat = function (self, threat_unit, threat_to_add)
	local threat_config = self._threat_config
	local max_threat = threat_config.max_threat
	local threat_units = self._threat_units
	local threat_multiplier = threat_config.threat_multiplier or DEFAULT_THREAT_MULTIPLIER
	local new_threat = (threat_units[threat_unit] or 0) + threat_to_add * threat_multiplier
	local threat = math.min(new_threat, max_threat)
	threat_units[threat_unit] = threat
end

local PROXIMITY_CHECK_RANGE = 5
local PROXIMITY_CHECK_RANGE_SQ = PROXIMITY_CHECK_RANGE^2

BotPerceptionExtension.within_aid_range = function (self, unit, perception_component)
	if perception_component.target_ally_needs_aid then
		local target_ally = perception_component.target_ally
		local self_position = POSITION_LOOKUP[unit]
		local target_position = POSITION_LOOKUP[target_ally]
		local distance_sq = Vector3.distance_squared(self_position, target_position)

		if distance_sq <= PROXIMITY_CHECK_RANGE_SQ then
			return true
		end
	end

	return false
end

local PROXIMITY_UP_DOWN_THRESHOLD = math.sin(math.pi * 0.25)

BotPerceptionExtension._target_valid = function (self, unit, enemy_offset)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local breed = unit_data_extension:breed()

	if breed.not_bot_target then
		return false
	end

	local up_dot_product = Vector3.dot(Vector3.up(), Vector3.normalize(enemy_offset))

	if PROXIMITY_UP_DOWN_THRESHOLD < up_dot_product or up_dot_product < -PROXIMITY_UP_DOWN_THRESHOLD then
		return false
	end

	return true
end

local PRIORITY_AID_TYPES = {
	ledge = true,
	knocked_down = true
}

BotPerceptionExtension._update_target_ally = function (self, self_unit, self_position, perception_component, side, bot_group, t)
	local best_ally, ally_distance, in_need_type, look_at_ally = nil
	local target_enemy = perception_component.target_enemy

	if target_enemy and target_enemy == perception_component.priority_target_enemy then
		best_ally = bot_group.priority_targets[target_enemy]
		ally_distance = Vector3.distance(self_position, POSITION_LOOKUP[best_ally])
	else
		best_ally, ally_distance, in_need_type, look_at_ally = self:_select_ally_by_utility(self_unit, self_position, perception_component, side, t)
	end

	perception_component.target_ally = best_ally or nil
	perception_component.target_ally_distance = ally_distance

	if best_ally and in_need_type then
		perception_component.target_ally_need_type = in_need_type
		perception_component.target_ally_needs_aid = true
	elseif perception_component.target_ally_needs_aid then
		perception_component.target_ally_need_type = "n/a"
		perception_component.target_ally_needs_aid = false
	end

	local bot_unit_input = self._bot_unit_input

	if look_at_ally then
		bot_unit_input:set_look_at_player_unit(best_ally, false)
	else
		bot_unit_input:set_look_at_player_unit(nil)
	end

	local target_ally_need_type = perception_component.target_ally_need_type
	local is_priority_aid_type = PRIORITY_AID_TYPES[target_ally_need_type]

	if perception_component.target_ally_needs_aid and is_priority_aid_type then
		bot_group:register_ally_needs_aid_priority(self_unit, best_ally)
	end
end

BotPerceptionExtension._update_target_level_unit = function (self, self_unit, self_position, perception_component, t)
	local next_health_station_unit, next_health_station_unit_distance = self:_select_next_health_station(self_unit, self_position, perception_component, t)
	perception_component.target_level_unit = next_health_station_unit
	perception_component.target_level_unit_distance = next_health_station_unit_distance
end

local ALLOWED_AID_MIN_RANGE_MONSTER_TARGETING_SELF_SQ = 12
local ALLOWED_AID_MIN_RANGE_MONSTER_ALLY_BASE = 3.5
local ALLOWED_AID_MIN_RANGE_MONSTER_CURRENT_ALLY_BASE = 1
local ALLOWED_AID_MIN_RANGE_MONSTER_TARGETING_ALLY_MODIFIER = 1.4
local MIN_ALLY_HEALTH_TO_CONSIDER_MONSTERS = 0.5

BotPerceptionExtension._select_ally_by_utility = function (self, self_unit, self_position, perception_component, side, t)
	local can_heal_other = false
	local can_give_healing_to_other = false
	local self_health_utility = 0
	local main_path_manager = Managers.state.main_path
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local closest_ally, closest_in_need_type = nil
	local closest_ally_look_at = false
	local closest_distance = math.huge
	local closest_real_distance = math.huge
	local main_path_ready = main_path_manager:is_main_path_ready()
	local self_segment_index = main_path_ready and main_path_manager:segment_index_by_unit(self_unit)

	if not main_path_ready or self_segment_index == nil then
		return closest_ally, closest_real_distance, closest_in_need_type, closest_ally_look_at
	end

	local liquid_area_system = Managers.state.extension:system("liquid_area_system")
	local Vector3_distance = Vector3.distance
	local Vector3_distance_squared = Vector3.distance_squared
	local target_enemy = perception_component.target_enemy
	local valid_player_units = side.valid_player_units
	local num_valid_player_units = #valid_player_units

	for i = 1, num_valid_player_units do
		local player_unit = valid_player_units[i]
		local player_segment_index = main_path_manager:segment_index_by_unit(player_unit)

		if player_unit ~= self_unit and HEALTH_ALIVE[player_unit] and self_segment_index <= player_segment_index then
			local player = player_unit_spawn_manager:owner(player_unit)
			local player_position = POSITION_LOOKUP[player_unit]
			local is_bot = not player:is_human_controlled()
			local in_need_type, look_at_ally, utility = self:_calculate_ally_need_type(self_position, self_health_utility, can_heal_other, can_give_healing_to_other, player_unit, player_position, target_enemy, is_bot, t)
			local is_position_in_liquid = liquid_area_system:is_position_in_liquid(player_position)

			if (in_need_type or not is_bot) and not is_position_in_liquid then
				local allowed_follow_path, allowed_aid_path = self:_ally_path_allowed(self_position, self_segment_index, player_unit, player_position, player_segment_index, t)

				if allowed_follow_path then
					if not allowed_aid_path then
						in_need_type = nil
					elseif in_need_type then
						local alive_monsters = side:alive_units_by_tag("enemy", "monster")
						local num_alive_monsters = alive_monsters.size
						local player_health = ScriptUnit.extension(player_unit, "health_system"):current_health_percent()

						for j = 1, num_alive_monsters do
							local monster_unit = alive_monsters[j]
							local monster_blackboard = BLACKBOARDS[monster_unit]
							local monster_perception_component = monster_blackboard.perception
							local monster_target = monster_perception_component.target_unit
							local monster_position = POSITION_LOOKUP[monster_unit]
							local self_to_monster_distance_sq = Vector3_distance_squared(self_position, monster_position)

							if monster_target == self_unit and self_to_monster_distance_sq < ALLOWED_AID_MIN_RANGE_MONSTER_TARGETING_SELF_SQ then
								utility = 0
								in_need_type = nil

								break
							end

							if MIN_ALLY_HEALTH_TO_CONSIDER_MONSTERS < player_health then
								local is_target_ally_and_needs_aid = perception_component.target_ally == player_unit and perception_component.target_ally_needs_aid
								local monster_to_target_range = is_target_ally_and_needs_aid and ALLOWED_AID_MIN_RANGE_MONSTER_CURRENT_ALLY_BASE or ALLOWED_AID_MIN_RANGE_MONSTER_ALLY_BASE

								if monster_target == player_unit then
									monster_to_target_range = monster_to_target_range + ALLOWED_AID_MIN_RANGE_MONSTER_TARGETING_ALLY_MODIFIER
								end

								local player_to_monster_distance = Vector3_distance(player_position, monster_position)

								if player_to_monster_distance < monster_to_target_range then
									utility = 0
									in_need_type = nil

									break
								end
							end
						end
					end

					if in_need_type or not is_bot then
						local real_distance = Vector3_distance(self_position, player_position)
						local distance = real_distance - utility

						if closest_distance > distance then
							closest_real_distance = real_distance
							closest_distance = distance
							closest_ally_look_at = look_at_ally
							closest_in_need_type = in_need_type
							closest_ally = player_unit
						end
					end
				end
			end
		end
	end

	return closest_ally, closest_real_distance, closest_in_need_type, closest_ally_look_at
end

BotPerceptionExtension._select_next_health_station = function (self, self_unit, self_position, perception_component, t)
	local unit = nil
	local distance = math.huge
	local health_station_system = Managers.state.extension:system("health_station_system")

	if health_station_system then
		unit, distance = health_station_system:get_closest_health_station(self_position)
	end

	return unit, distance
end

local IS_WOUNDED_MODIFIER = 0.33
local IS_WOUNDED_QUICK_USE_MODIFIER = 0.5

BotPerceptionExtension._calculate_healing_item_utility = function (self, health_percent, is_wounded, is_quick_use_item)
	if is_quick_use_item then
		return 1 - (is_wounded and health_percent - IS_WOUNDED_QUICK_USE_MODIFIER or health_percent)
	else
		return 1 - (is_wounded and health_percent * IS_WOUNDED_MODIFIER or health_percent)
	end
end

local WANTS_TO_HEAL_THRESHOLD = 0.25
local WANTS_TO_GIVE_HEAL_TO_OTHER = 0.5
local KNOCKED_DOWN_UTILITY = 100
local LEDGE_HANGING_UTILITY = 100
local NETTED_UTILITY = 100
local HOGTIED_UTILITY = 100
local HEAL_OTHER_BASE_UTILITY = 70
local HEAL_OTHER_HEALTH_UTILITY_MODIFIER = 15
local GIVE_HEAL_TO_OTHER_BASE_UTILITY = 70
local GIVE_HEAL_TO_OTHER_HEALTH_UTILITY_MODIFER = 10
local STOP_BASE_UTILITY = 5
local LOOK_AT_BASE_UTILITY = 2
local MAX_ENEMIES_IN_PROXIMITY_TO_AID_BOT = 1

BotPerceptionExtension._calculate_ally_need_type = function (self, self_position, self_health_utility, can_heal_other, can_give_healing_to_other, ally_unit, ally_position, target_enemy, ally_is_bot, t)
	local ally_unit_data_extension = ScriptUnit.extension(ally_unit, "unit_data_system")
	local ally_character_state_component = ally_unit_data_extension:read_component("character_state")
	local ally_disabled_character_state_component = ally_unit_data_extension:read_component("disabled_character_state")
	local assisted_state_input_component = ally_unit_data_extension:read_component("assisted_state_input")
	local interactee_component = ally_unit_data_extension:read_component("interactee")
	local being_assisted = assisted_state_input_component.in_progress
	local in_need_type = nil
	local look_at_ally = false
	local utility = 0

	if ally_is_bot and MAX_ENEMIES_IN_PROXIMITY_TO_AID_BOT <= self._num_enemies_in_proximity then
		return in_need_type, look_at_ally, utility
	end

	if being_assisted and interactee_component.interactor_unit ~= self._unit then
		return in_need_type, look_at_ally, utility
	end

	if PlayerUnitStatus.is_knocked_down(ally_character_state_component) then
		utility = KNOCKED_DOWN_UTILITY
		in_need_type = "knocked_down"
	elseif PlayerUnitStatus.is_ledge_hanging(ally_character_state_component) then
		utility = LEDGE_HANGING_UTILITY
		in_need_type = "ledge"
	elseif PlayerUnitStatus.is_netted(ally_disabled_character_state_component) then
		utility = NETTED_UTILITY
		in_need_type = "netted"
	elseif PlayerUnitStatus.is_hogtied(ally_character_state_component) then
		utility = HOGTIED_UTILITY
		in_need_type = "hogtied"
	else
		local ally_health_extension = ScriptUnit.extension(ally_unit, "health_system")
		local health_percent = ally_health_extension:current_health_percent()
		local is_wounded = false
		local health_utility = self:_calculate_healing_item_utility(health_percent, is_wounded, can_give_healing_to_other)
		local heal_other_allowed = self_health_utility < health_utility
		local has_healthkit = false
		local need_attention_type, extra_utility = self:_player_needs_attention(self_position, ally_unit, ally_position, ally_unit_data_extension, target_enemy, t)

		if can_heal_other and (health_percent < WANTS_TO_HEAL_THRESHOLD or is_wounded) and heal_other_allowed then
			utility = HEAL_OTHER_BASE_UTILITY + health_utility * HEAL_OTHER_HEALTH_UTILITY_MODIFIER
			in_need_type = "in_need_of_heal"
		elseif can_give_healing_to_other and is_wounded and (health_percent < WANTS_TO_GIVE_HEAL_TO_OTHER or is_wounded) and not has_healthkit and heal_other_allowed then
			utility = GIVE_HEAL_TO_OTHER_BASE_UTILITY + health_utility * GIVE_HEAL_TO_OTHER_HEALTH_UTILITY_MODIFER
			in_need_type = "can_accept_heal_item"
		elseif need_attention_type == "stop" then
			utility = STOP_BASE_UTILITY + extra_utility
			look_at_ally = true
			in_need_type = "in_need_of_attention_stop"
		elseif need_attention_type == "look_at" then
			utility = LOOK_AT_BASE_UTILITY + extra_utility
			look_at_ally = true
			in_need_type = "in_need_of_attention_look"
		end
	end

	return in_need_type, look_at_ally, utility
end

local MIN_HEADING_TOWARDS_US_DOT = math.degrees_to_radians(30)
local ATTENTION_MIN_STOP_DISTANCE = 0.5
local ATTENTION_MAX_STOP_DISTANCE = 3.5
local ATTENTION_MIN_STOP_DISTANCE_SQ = ATTENTION_MIN_STOP_DISTANCE^2
local SPEED_EPSILON_SQ = 0.01
local BOTH_MOVING_WITHOUT_ITEM_TO_GIVE_STOP_THRESHOLD = math.huge
local BOTH_MOVING_WITHOUT_ITEM_TO_GIVE_LOOK_AT_THRESHOLD = 0.5
local STOPPED_WITHOUT_ITEM_TO_GIVE_STOP_THRESHOLD = 0.3
local STOPPED_WITHOUT_ITEM_TO_GIVE_LOOK_AT_THRESHOLD = 0.25
local MOVING_WITHOUT_ITEM_TO_GIVE_STOP_THRESHOLD = 1.25
local MOVING_WITHOUT_ITEM_TO_GIVE_LOOK_AT_THRESHOLD = 0.5
local STOP_EXTRA_UTILITY_MIN = 0
local STOP_EXTRA_UTILITY_MAX = 2
local LOOK_AT_EXTRA_UTILITY_MIN = 0
local LOOK_AT_EXTRA_UTILITY_MAX = 0.5

BotPerceptionExtension._player_needs_attention = function (self, self_position, player_unit, player_position, player_unit_data_extension, target_enemy, t)
	local start_time = self._seen_by_player_units[player_unit]

	if not start_time or target_enemy then
		return false, 0
	end

	local player_locomotion_component = player_unit_data_extension:read_component("locomotion")
	local player_to_self = self_position - player_position
	local player_to_self_direction = Vector3.normalize(player_to_self)
	local player_velocity = player_locomotion_component.velocity_current
	local player_speed_sq = Vector3.length_squared(player_velocity)
	local locomotion_component = self._locomotion_component
	local velocity = locomotion_component.velocity_current
	local velocity_normalized = Vector3.normalize(velocity)
	local speed_sq = Vector3.length_squared(velocity)
	local is_heading_towards_player = nil

	if SPEED_EPSILON_SQ < speed_sq then
		local bot_direction_dot = Vector3.dot(player_to_self_direction, velocity_normalized)
		is_heading_towards_player = bot_direction_dot <= MIN_HEADING_TOWARDS_US_DOT
	else
		is_heading_towards_player = false
	end

	local look_threshold, stop_threshold = nil
	local safe_stop_distance = ATTENTION_MAX_STOP_DISTANCE
	local smallest_speed_sq = math.min(speed_sq, player_speed_sq)

	if SPEED_EPSILON_SQ < smallest_speed_sq or is_heading_towards_player then
		look_threshold = BOTH_MOVING_WITHOUT_ITEM_TO_GIVE_LOOK_AT_THRESHOLD
		stop_threshold = BOTH_MOVING_WITHOUT_ITEM_TO_GIVE_STOP_THRESHOLD
	elseif speed_sq <= 0.01 and player_speed_sq <= 0.01 then
		look_threshold = STOPPED_WITHOUT_ITEM_TO_GIVE_LOOK_AT_THRESHOLD
		stop_threshold = STOPPED_WITHOUT_ITEM_TO_GIVE_STOP_THRESHOLD
	else
		look_threshold = MOVING_WITHOUT_ITEM_TO_GIVE_LOOK_AT_THRESHOLD
		stop_threshold = MOVING_WITHOUT_ITEM_TO_GIVE_STOP_THRESHOLD
	end

	local player_to_self_length_sq = Vector3.length_squared(player_to_self)

	if player_to_self_length_sq > safe_stop_distance^2 or player_to_self_length_sq <= ATTENTION_MIN_STOP_DISTANCE_SQ then
		stop_threshold = math.huge
	end

	local self_unit = self._unit
	local bot_group = self._bot_group
	local has_ammo_pickup_order = bot_group:ammo_pickup_order_unit(self_unit) ~= nil
	local has_pickup_order = has_ammo_pickup_order or bot_group:has_pending_pickup_order(self_unit)
	local current_seen_time = t - start_time

	if stop_threshold < current_seen_time and not has_pickup_order then
		local extra_utility = math.clamp(current_seen_time, STOP_EXTRA_UTILITY_MIN, STOP_EXTRA_UTILITY_MAX)

		return "stop", extra_utility
	elseif look_threshold < current_seen_time then
		local extra_utility = math.clamp(current_seen_time, LOOK_AT_EXTRA_UTILITY_MIN, LOOK_AT_EXTRA_UTILITY_MAX)

		return "look_at", extra_utility
	end
end

local ALLY_PATH_TIME_MIN_DISTANCE = 5
local ALLY_PATH_TIME_MAX_DISTANCE = 15
local ALLY_PATH_TIME_DISTANCE_SLOPE = 1 / (ALLY_PATH_TIME_MAX_DISTANCE - ALLY_PATH_TIME_MIN_DISTANCE)
local ALLY_PATH_MIN_DISTANCE_TIME = 3
local ALLY_PATH_MAX_DISTANCE_TIME = 12
local ALLY_PATH_FAILED_REPATH_THRESHOLD_SQ = 0.25

BotPerceptionExtension._ally_path_allowed = function (self, self_position, self_segment_index, ally_unit, ally_position, ally_segment_index, t)
	local behavior_extension = self._behavior_extension
	local path_status = behavior_extension:ally_path_status(ally_unit)

	if path_status and path_status.failed then
		local ignore_ally_from = path_status.ignore_ally_from
		local ally_distance = Vector3.distance(self_position, ally_position)
		local p = math.clamp((ally_distance - ALLY_PATH_TIME_MIN_DISTANCE) * ALLY_PATH_TIME_DISTANCE_SLOPE, 0, 1)
		local wait_time = math.lerp(ALLY_PATH_MIN_DISTANCE_TIME, ALLY_PATH_MAX_DISTANCE_TIME, p)

		if t > ignore_ally_from + wait_time then
			return true, true
		end

		local ignore_for = nil

		if self_segment_index < ally_segment_index then
			ignore_for = 1
		elseif ally_segment_index < self_segment_index then
			ignore_for = 10
		else
			ignore_for = 5
		end

		local no_longer_ignored = t > ignore_ally_from + ignore_for

		if no_longer_ignored then
			local last_path_destination = path_status.last_path_destination:unbox()
			local has_moved = ALLY_PATH_FAILED_REPATH_THRESHOLD_SQ < Vector3.distance_squared(ally_position, last_path_destination)

			return true, has_moved
		else
			return false, false
		end
	else
		return true, true
	end
end

BotPerceptionExtension.set_seen_by_player_unit = function (self, seen, player_unit, t)
	local seen_by_player_units = self._seen_by_player_units

	if seen then
		seen_by_player_units[player_unit] = t
	else
		seen_by_player_units[player_unit] = nil
	end
end

return BotPerceptionExtension
