local AttackIntensity = require("scripts/utilities/attack_intensity")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local MinionPerception = require("scripts/utilities/minion_perception")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local Vo = require("scripts/utilities/vo")
local aggro_states = PerceptionSettings.aggro_states
local MinionPerceptionExtension = class("MinionPerceptionExtension")

MinionPerceptionExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	local blackboard = BLACKBOARDS[unit]

	self:_init_blackboard_components(blackboard)

	local extension_manager = Managers.state.extension
	self._side_system = extension_manager:system("side_system")
	self._blackboard_system = extension_manager:system("blackboard_system")
	self._broadphase_system = extension_manager:system("broadphase_system")
	self._perception_system = extension_manager:system("perception_system")
	self._smoke_fog_system = Managers.state.extension:system("smoke_fog_system")
	local breed = extension_init_data.breed
	self._breed = breed
	self._unit = unit
	self._reports_known_position = breed.reports_known_position or breed.cover_config ~= nil
	local initial_aggro_state = extension_init_data.aggro_state
	self._initial_aggro_state = initial_aggro_state
	self._is_priority_blackboard_update = false
	self._delayed_alerts = {}
	local use_action_controlled_alert = breed.use_action_controlled_alert

	self:set_use_action_controlled_alert(use_action_controlled_alert)

	local target_unit = extension_init_data.target_unit

	if target_unit then
		self._initial_target_unit = target_unit
	end

	self._physics_world = extension_init_context.physics_world
	self._line_of_sight_lookup = {}
	self._line_of_sight_queue = Script.new_array(4)
	self._running_line_of_sight_checks = {}
	self._num_running_raycasts = 0
	self._force_new_aim = {}
	local line_of_sight_data = breed.line_of_sight_data
	local max_main_index = #line_of_sight_data
	local line_of_sight_lookup_by_id = Script.new_map(max_main_index)
	local num_blocked_per_main_index = Script.new_array(max_main_index)

	for main_index = 1, max_main_index do
		local id = line_of_sight_data[main_index].id
		line_of_sight_lookup_by_id[id] = {}
		num_blocked_per_main_index[main_index] = 0
	end

	self._line_of_sight_data = line_of_sight_data
	self._processing_line_of_sight_data = {
		offset_index = 1,
		main_index = 1,
		num_blocked_per_main_index = num_blocked_per_main_index
	}
	self._line_of_sight_lookup_by_id = line_of_sight_lookup_by_id
	self._last_los_positions = {}
	self._target_selection_template = breed.target_selection_template
	self._target_changed_attack_intensities = breed.target_changed_attack_intensities
	self._force_new_target_attempt = false
	local threat_config = breed.threat_config
	self._threat_config = threat_config
	self._threat_decay_disabled = threat_config.decay_disabled
	self._threat_units = {}
	local ignore_detection_los_modifiers = breed.ignore_detection_los_modifiers
	self._ignore_detection_los_modifiers = ignore_detection_los_modifiers
	self._is_monster = breed.tags.monster
end

MinionPerceptionExtension._init_blackboard_components = function (self, blackboard)
	local perception_component = Blackboard.write_component(blackboard, "perception")
	perception_component.aggro_state = aggro_states.passive
	perception_component.target_unit = nil

	perception_component.target_position:store(Vector3.zero())

	perception_component.previous_target_unit = nil
	perception_component.lock_target = false
	perception_component.target_distance = math.huge
	perception_component.target_speed_away = math.huge
	perception_component.has_line_of_sight = false
	perception_component.target_distance_z = 0
	perception_component.target_changed = false
	perception_component.target_changed_t = -math.huge
	perception_component.ignore_alerted_los = false
	perception_component.has_last_los_position = false

	perception_component.last_los_position:store(Vector3.zero())

	perception_component.has_good_last_los_position = false
	self._perception_component = perception_component
end

MinionPerceptionExtension.extensions_ready = function (self, world, unit)
	self._animation_extension = ScriptUnit.extension(unit, "animation_system")
	self._buff_extension = ScriptUnit.extension(unit, "buff_system")
	self._visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
end

MinionPerceptionExtension.game_object_initialized = function (self, session, game_object_id)
	self._game_object_id = game_object_id
	self._game_session = session
	local initial_aggro_state = self._initial_aggro_state
	local initial_target_unit = self._initial_target_unit

	if initial_aggro_state then
		if initial_aggro_state == aggro_states.aggroed then
			self:aggro()
		elseif initial_aggro_state == aggro_states.alerted then
			self:alert(initial_target_unit)
		end

		self._initial_aggro_state = nil
	end

	if initial_target_unit then
		self:_set_target_unit(initial_target_unit)

		self._initial_target_unit = nil
	end
end

MinionPerceptionExtension.on_reload = function (self)
	local breed = self._breed
	local target_selection_template = breed.target_selection_template
	self._target_selection_template = target_selection_template
end

MinionPerceptionExtension.last_los_position = function (self, target_unit)
	local last_los_positions = self._last_los_positions

	return last_los_positions[target_unit] and last_los_positions[target_unit]:unbox()
end

MinionPerceptionExtension.set_last_los_position = function (self, target_unit, position)
	local last_los_positions = self._last_los_positions

	if last_los_positions[target_unit] then
		last_los_positions[target_unit]:store(position)
	else
		last_los_positions[target_unit] = Vector3Box(position)
	end
end

MinionPerceptionExtension.has_line_of_sight = function (self, target_unit)
	return self._line_of_sight_lookup[target_unit] or false
end

MinionPerceptionExtension.has_line_of_sight_by_id = function (self, target_unit, id)
	local line_of_sight_lookup = self._line_of_sight_lookup_by_id[id]
	local has_line_of_sight = line_of_sight_lookup[target_unit] or false

	return has_line_of_sight
end

MinionPerceptionExtension.immediate_line_of_sight_check = function (self, target_unit, optional_from_node_name, optional_to_node_name)
	local first_line_of_sight_data = self._line_of_sight_data[1]
	local from_node = optional_from_node_name or first_line_of_sight_data.from_node
	local to_node = optional_to_node_name or first_line_of_sight_data.to_node
	local from_offsets = first_line_of_sight_data.from_offsets
	local los_from_position, los_to_position = MinionPerception.line_of_sight_positions(self._unit, target_unit, from_node, to_node, from_offsets)
	local vector = los_to_position - los_from_position
	local distance = Vector3.length(vector)
	local direction = Vector3.normalize(vector)
	local line_of_sight_collision_filter = self._breed.line_of_sight_collision_filter
	local hit = PhysicsWorld.raycast(self._physics_world, los_from_position, direction, distance, "all", "types", "both", "collision_filter", line_of_sight_collision_filter)

	return not hit
end

local FORCE_NEW_AIM_DISTANCE = 5

MinionPerceptionExtension.cb_line_of_sight_hit = function (self, hit, hit_position)
	self._num_running_raycasts = self._num_running_raycasts - 1
	local processing_line_of_sight_data = self._processing_line_of_sight_data
	local current_offset_index = processing_line_of_sight_data.offset_index
	local current_main_index = processing_line_of_sight_data.main_index
	local num_blocked_per_main_index = processing_line_of_sight_data.num_blocked_per_main_index

	if hit then
		num_blocked_per_main_index[current_main_index] = num_blocked_per_main_index[current_main_index] + 1
	end

	local line_of_sight_data = self._line_of_sight_data
	local current_num_offsets = line_of_sight_data[current_main_index].num_offsets

	if current_offset_index < current_num_offsets then
		processing_line_of_sight_data.offset_index = current_offset_index + 1

		return
	end

	processing_line_of_sight_data.offset_index = 1
	local max_main_index = #line_of_sight_data

	if current_main_index < max_main_index then
		processing_line_of_sight_data.main_index = current_main_index + 1

		return
	end

	processing_line_of_sight_data.main_index = 1
	local line_of_sight_queue = self._line_of_sight_queue
	local target_unit = line_of_sight_queue[1]

	table.remove(line_of_sight_queue, 1)

	self._running_line_of_sight_checks[target_unit] = nil

	if ALIVE[target_unit] then
		local had_los = self._line_of_sight_lookup[target_unit]
		local line_of_sight_lookup_by_id = self._line_of_sight_lookup_by_id
		local last_los_positions = self._last_los_positions
		local has_los = false
		local least_blocked_main_index = nil
		local least_blocked_percentage = 1

		for i = 1, max_main_index do
			local data = line_of_sight_data[i]
			local num_blocked = num_blocked_per_main_index[i]
			local num_offsets = data.num_offsets
			local id = data.id
			local has_unblocked_raycast = num_blocked < num_offsets
			line_of_sight_lookup_by_id[id][target_unit] = has_unblocked_raycast

			if has_unblocked_raycast then
				local blocked_percentage = num_blocked / num_offsets

				if least_blocked_percentage > blocked_percentage then
					least_blocked_percentage = blocked_percentage
					least_blocked_main_index = i
				end

				has_los = true
			end
		end

		self._line_of_sight_lookup[target_unit] = has_los

		if least_blocked_main_index then
			local data = line_of_sight_data[least_blocked_main_index]
			local to_node = data.to_node
			local los_to_node = Unit.node(target_unit, to_node)
			local los_to_position = Unit.world_position(target_unit, los_to_node)

			if not self._force_new_aim[target_unit] and has_los and not had_los and last_los_positions[target_unit] then
				local last_los = last_los_positions[target_unit]
				local distance_to_last_los = Vector3.distance(last_los:unbox(), los_to_position)

				if FORCE_NEW_AIM_DISTANCE < distance_to_last_los then
					self._force_new_aim[target_unit] = true
				end
			end

			if least_blocked_percentage == 0 then
				if last_los_positions[target_unit] then
					last_los_positions[target_unit]:store(los_to_position)
				else
					last_los_positions[target_unit] = Vector3Box(los_to_position)
				end
			elseif not last_los_positions[target_unit] then
				last_los_positions[target_unit] = Vector3Box(los_to_position)
			end

			if self._reports_known_position then
				local combat_vector_system = Managers.state.extension:system("combat_vector_system")

				combat_vector_system:set_last_known_position(target_unit, los_to_position)
			end
		end
	end

	for i = 1, max_main_index do
		num_blocked_per_main_index[i] = 0
	end
end

MinionPerceptionExtension.aggro = function (self)
	local perception_component = self._perception_component

	if perception_component.aggro_state ~= aggro_states.aggroed then
		perception_component.aggro_state = aggro_states.aggroed

		self._animation_extension:anim_event("to_combat")

		local unit = self._unit
		local breed = self._breed
		local aggro_inventory_slot = breed.aggro_inventory_slot

		if aggro_inventory_slot then
			local visual_loadout_extension = self._visual_loadout_extension

			if visual_loadout_extension:can_wield_slot(aggro_inventory_slot) then
				visual_loadout_extension:wield_slot(aggro_inventory_slot)
			end
		end

		if breed.trigger_boss_health_bar_on_aggro then
			local boss_extension = ScriptUnit.extension(unit, "boss_system")

			boss_extension:start_boss_encounter()
			Managers.state.game_session:send_rpc_clients("rpc_start_boss_encounter", self._game_object_id)
		end

		Managers.state.pacing:add_aggroed_minion(unit)
	end
end

MinionPerceptionExtension.alert = function (self, enemy_unit)
	local perception_component = self._perception_component
	local aggro_state = perception_component.aggro_state

	if aggro_state == aggro_states.aggroed then
		return
	elseif aggro_state == aggro_states.alerted then
		self:aggro()
	else
		perception_component.aggro_state = aggro_states.alerted
		local unit = self._unit
		local target_distance = nil

		if perception_component.target_unit then
			target_distance = perception_component.target_distance
		else
			self:_set_target_unit(enemy_unit)

			target_distance = Vector3.distance(POSITION_LOOKUP[unit], POSITION_LOOKUP[enemy_unit])
		end

		local breed_name = self._breed.name
		local vo_event = "alerted_idle"

		Vo.enemy_generic_vo_event(unit, vo_event, breed_name, target_distance)
	end
end

local DEFAULT_ALERT_NEARBY_RADIUS = 20
local BROADPHASE_RESULTS = {}

MinionPerceptionExtension.alert_nearby_allies = function (self, target_unit, optional_radius, optional_require_los, optional_max_distance_to_target)
	local unit = self._unit
	local side_system = self._side_system
	local side = side_system.side_by_unit[unit]
	local side_name = side:name()
	local broadphase_system = self._broadphase_system
	local broadphase = broadphase_system.broadphase
	local from_position = POSITION_LOOKUP[unit]
	local target_position = POSITION_LOOKUP[target_unit]
	local num_results = broadphase:query(from_position, optional_radius or DEFAULT_ALERT_NEARBY_RADIUS, BROADPHASE_RESULTS, side_name)

	for i = 1, num_results do
		repeat
			local nearby_unit = BROADPHASE_RESULTS[i]
			local unit_data_extension = ScriptUnit.extension(nearby_unit, "unit_data_system")
			local breed = unit_data_extension:breed()

			if breed.ignore_ally_alerts then
				break
			end

			if nearby_unit ~= unit and Breed.is_minion(breed) then
				local perception_extension = ScriptUnit.extension(nearby_unit, "perception_system")
				local should_alert = not optional_require_los or perception_extension:has_line_of_sight(target_unit)

				if should_alert then
					should_alert = not optional_max_distance_to_target or Vector3.distance(POSITION_LOOKUP[nearby_unit], target_position) <= optional_max_distance_to_target

					if should_alert then
						perception_extension:alert(target_unit)
					end
				end
			end
		until true
	end
end

MinionPerceptionExtension.delayed_alert = function (self, enemy_unit, delay, optional_ignore_alerted_los)
	local t = Managers.time:time("gameplay")
	self._delayed_alerts[enemy_unit] = t + delay

	self:set_ignore_alerted_los(optional_ignore_alerted_los)
end

MinionPerceptionExtension.set_ignore_alerted_los = function (self, value)
	local perception_component = self._perception_component
	perception_component.ignore_alerted_los = value and true or false
end

MinionPerceptionExtension.use_action_controlled_alert = function (self)
	return self._use_action_controlled_alert
end

MinionPerceptionExtension.set_use_action_controlled_alert = function (self, value)
	self._use_action_controlled_alert = value
end

MinionPerceptionExtension.set_threat_decay_enabled = function (self, enabled)
	self._threat_decay_disabled = not enabled
end

MinionPerceptionExtension.force_new_target_attempt = function (self, optional_config)
	self._force_new_target_attempt_config = optional_config
	self._force_new_target_attempt = true
end

MinionPerceptionExtension._set_target_unit = function (self, target_unit)
	local perception_component = self._perception_component
	local current_target_unit = perception_component.target_unit
	local target_changed = current_target_unit ~= target_unit

	if target_changed then
		self:_on_target_change(current_target_unit, target_unit)
	end

	return target_changed
end

MinionPerceptionExtension._update_aggro_state = function (self, target_changed, target_unit)
	if target_changed then
		local perception_component = self._perception_component
		local aggro_state = perception_component.aggro_state

		if target_unit and aggro_state == aggro_states.passive then
			self:alert(target_unit)
		end
	end
end

MinionPerceptionExtension._update_target_selection = function (self, unit, side, target_units, perception_component, breed, dt, t, force_new_target_attempt, force_new_target_attempt_config)
	local threat_decay_disabled = self._threat_decay_disabled

	if not threat_decay_disabled then
		self:_decay_threat(unit, dt)
	end

	local los_collision_filter = breed.line_of_sight_collision_filter

	self:_update_line_of_sight(unit, target_units, los_collision_filter)

	local template = self._target_selection_template
	local target_unit = template(unit, side, perception_component, self._buff_extension, breed, target_units, self._line_of_sight_lookup, t, self._threat_units, force_new_target_attempt, force_new_target_attempt_config, self._debug_target_weighting, self._last_los_positions)

	return target_unit
end

MinionPerceptionExtension._update_line_of_sight = function (self, unit, target_units, los_collision_filter)
	local line_of_sight_queue = self._line_of_sight_queue
	local running_line_of_sight_checks = self._running_line_of_sight_checks
	local unit_position = POSITION_LOOKUP[unit]

	for i = 1, #target_units do
		local target_unit = target_units[i]

		if not running_line_of_sight_checks[target_unit] then
			local target_position = POSITION_LOOKUP[target_unit]
			local within_detection_los_range = self:_within_detection_los_range(unit, unit_position, target_unit, target_position)

			if within_detection_los_range then
				self:_line_of_sight_check(unit, target_unit, los_collision_filter)

				running_line_of_sight_checks[target_unit] = true
				line_of_sight_queue[#line_of_sight_queue + 1] = target_unit
			else
				self._line_of_sight_lookup[target_unit] = false

				for id, lookup in pairs(self._line_of_sight_lookup_by_id) do
					lookup[target_unit] = false
				end
			end
		end
	end
end

MinionPerceptionExtension._line_of_sight_check = function (self, unit, target_unit, los_collision_filter)
	local perception_system = self._perception_system
	local up = Vector3.up()
	local line_of_sight_data = self._line_of_sight_data

	for main_index = 1, #line_of_sight_data do
		local data = line_of_sight_data[main_index]
		local from_node = data.from_node
		local to_node = data.to_node
		local los_node = Unit.node(unit, from_node)
		local los_to_node = Unit.node(target_unit, to_node)
		local los_from_position = Unit.world_position(unit, los_node)
		local from_offsets = data.from_offsets

		if from_offsets then
			local right = Quaternion.right(Unit.local_rotation(unit, 1))
			local from_offset = from_offsets:unbox()
			los_from_position = los_from_position + Vector3(right.x * from_offset.x, right.y * from_offset.x, from_offset.z)
		end

		local los_to_position = Unit.world_position(target_unit, los_to_node)
		local to_los_position = los_to_position - los_from_position
		local right_vector = Vector3.normalize(Vector3.cross(to_los_position, up))
		local raycast_offsets = data.offsets
		local num_offsets = data.num_offsets

		for i = 1, num_offsets do
			local raycast_offset = raycast_offsets[i]:unbox()
			local offset_vector = to_los_position + Vector3(right_vector.x * raycast_offset.x, right_vector.y * raycast_offset.x, raycast_offset.z)
			local los_direction = Vector3.normalize(offset_vector)
			local los_distance = Vector3.length(offset_vector)

			perception_system:add_line_of_sight_raycast_query(unit, los_from_position, los_direction, los_distance, los_collision_filter)

			self._num_running_raycasts = self._num_running_raycasts + 1
		end
	end
end

MinionPerceptionExtension.destroy = function (self)
	if self._perception_component.aggro_state == aggro_states.aggroed then
		Managers.state.pacing:remove_aggroed_minion(self._unit)
	end

	local perception_component = self._perception_component
	local current_target_unit = perception_component.target_unit

	if ALIVE[current_target_unit] then
		local is_monster = self._is_monster

		if is_monster then
			AttackIntensity.set_monster_attacker(current_target_unit, nil)
		end
	end
end

MinionPerceptionExtension._on_target_change = function (self, old_target_unit, new_target_unit)
	local attack_intensities = self._target_changed_attack_intensities

	if new_target_unit and attack_intensities then
		AttackIntensity.add_intensity(new_target_unit, attack_intensities)
	end

	local is_monster = self._is_monster
	local unit = self._unit

	if is_monster then
		if ALIVE[old_target_unit] then
			AttackIntensity.set_monster_attacker(old_target_unit, nil)
		end

		if new_target_unit then
			AttackIntensity.set_monster_attacker(new_target_unit, unit)
		end
	end

	local perception_component = self._perception_component
	perception_component.target_unit = new_target_unit
	perception_component.previous_target_unit = old_target_unit
	perception_component.target_changed = true
	local time_manager = Managers.time
	local t = time_manager:time("gameplay")
	perception_component.target_changed_t = t
	local game_session = self._game_session
	local game_object_id = self._game_object_id
	local target_unit_id = new_target_unit and Managers.state.unit_spawner:game_object_id(new_target_unit) or NetworkConstants.invalid_game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "target_unit_id", target_unit_id)
end

MinionPerceptionExtension._update_priority_blackboard_status = function (self, unit)
	local perception_component = self._perception_component
	local is_priority_blackboard_update = perception_component.target_distance <= PerceptionSettings.max_priority_blackboard_update_distance

	if is_priority_blackboard_update and not self._is_priority_blackboard_update then
		self._blackboard_system:register_priority_update_unit(unit)

		self._is_priority_blackboard_update = true
	elseif not is_priority_blackboard_update and self._is_priority_blackboard_update then
		self._blackboard_system:unregister_priority_update_unit(unit)

		self._is_priority_blackboard_update = false
	end
end

MinionPerceptionExtension._decay_threat = function (self, unit, dt)
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

MinionPerceptionExtension.threat = function (self, threat_unit)
	local threat_units = self._threat_units

	return threat_units[threat_unit]
end

MinionPerceptionExtension.aggro_state = function (self)
	local perception_component = self._perception_component
	local aggro_state = perception_component.aggro_state

	return aggro_state
end

local DEFAULT_THREAT_MULTIPLIER = 1

MinionPerceptionExtension.add_threat = function (self, threat_unit, threat_to_add, optional_attack_type)
	local threat_config = self._threat_config
	local max_threat = threat_config.max_threat
	local threat_units = self._threat_units
	local threat_multiplier = threat_config.threat_multiplier or DEFAULT_THREAT_MULTIPLIER
	local threat_attack_type_multiplier = optional_attack_type and threat_config.attack_type_multiplier and threat_config.attack_type_multiplier[optional_attack_type]

	if threat_attack_type_multiplier then
		threat_multiplier = threat_multiplier + threat_attack_type_multiplier - 1
	end

	local new_threat = (threat_units[threat_unit] or 0) + threat_to_add * threat_multiplier
	local threat = math.min(new_threat, max_threat)
	threat_units[threat_unit] = threat
end

MinionPerceptionExtension.has_forced_aim = function (self, target_unit)
	return self._force_new_aim[target_unit]
end

MinionPerceptionExtension.reset_forced_aim = function (self, target_unit)
	self._force_new_aim[target_unit] = nil
end

MinionPerceptionExtension.update = function (self, unit, dt, t)
	local perception_component = self._perception_component

	if perception_component.target_changed then
		perception_component.target_changed = false
	end

	local force_new_target_attempt = self._force_new_target_attempt
	local force_new_target_attempt_config = self._force_new_target_attempt_config

	if force_new_target_attempt then
		self._force_new_target_attempt_config = nil
		self._force_new_target_attempt = false
	end

	local delayed_alerts = self._delayed_alerts
	local side_system = self._side_system
	local side = side_system.side_by_unit[unit]
	local target_units = side.ai_target_units

	for enemy_unit, time in pairs(delayed_alerts) do
		if time < t then
			delayed_alerts[enemy_unit] = nil

			if target_units[enemy_unit] then
				self:alert(enemy_unit)

				break
			end
		end
	end

	local breed = self._breed
	local target_unit = self:_update_target_selection(unit, side, target_units, perception_component, breed, dt, t, force_new_target_attempt, force_new_target_attempt_config)
	local target_changed = self:_set_target_unit(target_unit)

	self:_update_aggro_state(target_changed, target_unit)
	self:_update_priority_blackboard_status(unit)
end

local DARKNESS_LOS_MODIFIER_NAME = "mutator_darkness_los"
local VENTILATION_PURGE_LOS_MODIFIER_NAME = "mutator_ventilation_purge_los"
local CIRCUMSTANCE_DETECTION_DISTANCE_LOS_REQUIREMENTS = {
	mutator_ventilation_purge_los = 20,
	mutator_darkness_los = 15
}
local BUFF_KEYWORD_DISTANCE_LOS_REQUIREMENT = {
	concealed = 5
}

MinionPerceptionExtension._within_detection_los_range = function (self, unit, unit_position, target_unit, target_position)
	if self._ignore_detection_los_modifiers then
		return true
	end

	local mutator_manager = Managers.state.mutator
	local los_modifier = mutator_manager:mutator(DARKNESS_LOS_MODIFIER_NAME) and DARKNESS_LOS_MODIFIER_NAME or mutator_manager:mutator(VENTILATION_PURGE_LOS_MODIFIER_NAME) and VENTILATION_PURGE_LOS_MODIFIER_NAME
	local detection_los_requirement = nil

	if los_modifier then
		detection_los_requirement = CIRCUMSTANCE_DETECTION_DISTANCE_LOS_REQUIREMENTS[los_modifier]
	end

	local buff_extension = self._buff_extension

	for keyword, distance_requirement in pairs(BUFF_KEYWORD_DISTANCE_LOS_REQUIREMENT) do
		if buff_extension:has_keyword(keyword) then
			detection_los_requirement = distance_requirement
		else
			local target_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

			if target_buff_extension and target_buff_extension:has_keyword(keyword) then
				detection_los_requirement = distance_requirement
			end
		end
	end

	local is_within_range = not detection_los_requirement or Vector3.distance(unit_position, target_position) <= detection_los_requirement

	if not is_within_range then
		return false
	end

	local is_looking_trough_fog = self._smoke_fog_system:check_fog_los(unit_position, target_position, unit)

	if is_looking_trough_fog then
		return false
	end

	return true
end

return MinionPerceptionExtension
