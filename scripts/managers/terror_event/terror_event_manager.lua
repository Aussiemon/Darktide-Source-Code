local BreedQueries = require("scripts/utilities/breed_queries")
local HordeSettings = require("scripts/settings/horde/horde_settings")
local LoadedDice = require("scripts/utilities/loaded_dice")
local TerrorEventNodes = require("scripts/managers/terror_event/terror_event_nodes")
local TerrorEventTemplates = require("scripts/settings/terror_event/terror_event_templates")
local TerrorTrickleTemplates = require("scripts/managers/terror_event/terror_trickle_templates")
local HORDE_TYPES = HordeSettings.horde_types
local CLIENT_RPCS = {
	"rpc_terror_event_trigger_level_flow"
}
local TerrorEventManager = class("TerrorEventManager")

TerrorEventManager.init = function (self, world, is_server, network_event_delegate, mission, level_name)
	self._is_server = is_server
	self._world = world
	self._level_name = level_name
	self._wwise_world = Managers.world:wwise_world(world)
	self._level = nil
	self._terror_trickle_data = {
		spawned_minion_data = {}
	}
	local event_templates, random_event_templates = self:_load_mission_event_templates(mission)
	self._flow_events_network_lookup = self:_create_network_lookups(event_templates)

	if is_server then
		self._random_event_probabilities = self:_calculate_random_event_probabilities(random_event_templates)
		self._event_templates = event_templates
		self._random_event_templates = random_event_templates
		self._start_events = {}
		self._active_events = {}

		if not DEDICATED_SERVER then
			-- Nothing
		end

		self._minion_spawner_system = Managers.state.extension:system("minion_spawner_system")
	else
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))

		self._network_event_delegate = network_event_delegate
	end
end

TerrorEventManager.on_gameplay_post_init = function (self, level)
	self._level = level
end

TerrorEventManager._load_mission_event_templates = function (self, mission)
	local event_templates = {}
	local random_event_templates = {}
	local mission_template_files = mission.terror_event_templates

	if mission_template_files then
		for i = 1, #mission_template_files do
			local template_file = mission_template_files[i]
			local template = TerrorEventTemplates[template_file]
			local events = template.events

			if events then
				table.merge(event_templates, events)
			end

			local random_events = template.random_events

			if random_events then
				table.merge(random_event_templates, random_events)
			end
		end
	end

	return event_templates, random_event_templates
end

TerrorEventManager._create_network_lookups = function (self, events)
	local flow_events_lookup = {}

	for _, nodes in pairs(events) do
		for i = 1, #nodes do
			local node = nodes[i]
			local flow_event_name = node.flow_event_name

			if flow_event_name and not flow_events_lookup[flow_event_name] then
				local id = #flow_events_lookup + 1
				flow_events_lookup[id] = flow_event_name
				flow_events_lookup[flow_event_name] = id
			end
		end
	end

	return flow_events_lookup
end

TerrorEventManager._calculate_random_event_probabilities = function (self, random_events)
	local random_event_probabilities = {}

	for event_chunk_name, event_chunk in pairs(random_events) do
		local weight_list = {}

		for i = 1, #event_chunk, 2 do
			local event_weight = event_chunk[i + 1]
			weight_list[#weight_list + 1] = event_weight
		end

		local p, a = LoadedDice.create(weight_list, false)
		random_event_probabilities[event_chunk_name] = {
			p,
			a
		}
	end

	return random_event_probabilities
end

TerrorEventManager.start_event = function (self, event_name, optional_seed)
	if not self._is_server then
		return
	end

	local start_events = self._start_events
	start_events[#start_events + 1] = {
		name = event_name,
		data = {
			seed = optional_seed
		}
	}

	Managers.event:trigger("terror_event_started")
end

TerrorEventManager.start_random_event = function (self, event_chunk_name)
	if not self._is_server then
		return
	end

	local event_chunk = self._random_event_templates[event_chunk_name]
	local probability_table = self._random_event_probabilities[event_chunk_name]
	local index = LoadedDice.roll(probability_table[1], probability_table[2])
	index = index * 2 - 1
	local event_name = event_chunk[index]
	local has_minion_spawners = self:_event_has_minion_spawners(event_name)

	self:start_event(event_name)
end

TerrorEventManager.stop_event = function (self, event_name)
	if not self._is_server then
		return
	end

	local active_events = self._active_events

	for i = 1, #active_events do
		local event = active_events[i]

		if event.name == event_name then
			event.stopped = true
		end
	end

	self._terror_trickle_data.active = false

	Managers.event:trigger("terror_event_stopped")
end

TerrorEventManager._event_has_minion_spawners = function (self, event_name)
	local nodes = self._event_templates[event_name]
	local minion_spawn_system = self._minion_spawner_system
	local spawners_exists = true

	for i = 1, #nodes do
		local spawner_group = nodes[i].spawner_group

		if spawner_group then
			local spawners = minion_spawn_system:spawners_in_group(spawner_group)

			if not spawners or #spawners == 0 then
				spawners_exists = false

				break
			end
		end
	end

	return spawners_exists
end

TerrorEventManager.num_active_events = function (self)
	return #self._active_events
end

TerrorEventManager.update = function (self, dt, t)
	local active_events = self._active_events

	for i = #active_events, 1, -1 do
		local event = active_events[i]
		local event_completed = event.stopped or self:_update_event(event, t, dt)

		if event_completed then
			local event_name = event.name

			Managers.telemetry_events:stop_terror_event(event_name)
			table.swap_delete(active_events, i)
		end
	end

	local start_events = self._start_events

	for i = 1, #start_events do
		local event = start_events[i]
		local event_name = event.name
		local data = event.data

		self:_start_event(event_name, data)

		start_events[i] = nil
	end

	self:_update_terror_trickle(dt, t)
end

local TEMP_SPAWN_SIDE_NAME = "villains"
local TEMP_TARGET_SIDE_NAME = "heroes"
local DEFAULT_WAVE_TIMER = 0

TerrorEventManager.start_terror_trickle = function (self, template_name, spawner_group, delay, use_occluded_positions, limit_spawners, proximity_spawners)
	local data = self._terror_trickle_data
	local trickle_template = TerrorTrickleTemplates[template_name]
	local difficulty_template = Managers.state.difficulty:get_table_entry_by_resistance(trickle_template)
	data.template = difficulty_template
	data.use_occluded_positions = use_occluded_positions
	local side_system = Managers.state.extension:system("side_system")
	local spawn_side = side_system:get_side_from_name(TEMP_SPAWN_SIDE_NAME)
	local spawn_side_id = spawn_side.side_id
	local target_side = side_system:get_side_from_name(TEMP_TARGET_SIDE_NAME)
	local target_side_id = target_side.side_id
	data.spawn_side_id = spawn_side_id
	data.target_side_id = target_side_id
	data.limit_spawners = limit_spawners

	if spawner_group then
		data.spawner_group = spawner_group
		data.proximity_spawners = proximity_spawners
	end

	data.wave_timer = delay or DEFAULT_WAVE_TIMER
	local num_waves = difficulty_template.num_waves
	data.num_waves = math.random(num_waves[1], num_waves[2])
	data.wave_counter = 0
	data.active = true
end

TerrorEventManager.stop_terror_trickle = function (self)
	self._terror_trickle_data.active = false

	Managers.event:trigger("terror_event_stopped")
end

TerrorEventManager.get_terror_trickle_data = function (self)
	return self._terror_trickle_data
end

local PAUSE_TRICKLE_TIME = 10
local DEFAULT_TOTAL_MINIONS_ALLOWED = 200

TerrorEventManager._update_terror_trickle = function (self, dt, t)
	local data = self._terror_trickle_data

	if not data.active then
		return
	end

	local terror_events_allowed = Managers.state.pacing:spawn_type_allowed("terror_events")

	if not terror_events_allowed then
		return
	end

	local pacing_manager = Managers.state.pacing
	local template = data.template
	local tension_stop_threshold = template.tension_stop_threshold
	local tension = pacing_manager:tension()

	if tension_stop_threshold <= tension then
		data.wave_timer = PAUSE_TRICKLE_TIME

		return
	end

	local challenge_rating_stop_threshold = template.challenge_rating_stop_threshold
	local challenge_rating = pacing_manager:total_challenge_rating()

	if challenge_rating_stop_threshold <= challenge_rating then
		data.wave_timer = PAUSE_TRICKLE_TIME

		return
	end

	local total_minions_spawned_stop_threshold = template.total_minions_spawned_stop_threshold or DEFAULT_TOTAL_MINIONS_ALLOWED
	local total_minions_spawned = Managers.state.minion_spawn:num_spawned_minions()

	if total_minions_spawned_stop_threshold <= total_minions_spawned then
		data.wave_timer = PAUSE_TRICKLE_TIME

		return
	end

	data.wave_timer = data.wave_timer - dt

	if data.wave_timer <= 0 then
		local wanted_sub_faction = Managers.state.pacing:current_faction()
		local faction_compositions = template.compositions[wanted_sub_faction]
		local composition = faction_compositions[math.random(1, #faction_compositions)]
		local resistance_scaled_composition = Managers.state.difficulty:get_table_entry_by_resistance(composition)
		local use_occluded_positions = data.use_occluded_positions
		local minion_spawn_system = Managers.state.extension:system("minion_spawner_system")
		local spawner_group = data.spawner_group
		local spawners = nil

		if spawner_group then
			local side_system = Managers.state.extension:system("side_system")
			local proximity_spawners = data.proximity_spawners

			if proximity_spawners then
				local average_position = Vector3(0, 0, 0)
				local side = side_system:get_side(data.target_side_id)
				local valid_player_units = side.valid_player_units
				local num_valid_player_units = #valid_player_units

				for i = 1, num_valid_player_units do
					local target_unit = valid_player_units[i]
					local position = POSITION_LOOKUP[target_unit]
					average_position = average_position + position
				end

				average_position = average_position / num_valid_player_units
				spawners = proximity_spawners and minion_spawn_system:spawners_in_group_distance_sorted(spawner_group, average_position)
			else
				spawners = minion_spawn_system:spawners_in_group(spawner_group)
			end

			local limit_spawners = data.limit_spawners

			if limit_spawners then
				for i = limit_spawners + 1, #spawners do
					spawners[i] = nil
				end
			end

			table.shuffle(spawners)
		end

		local spawn_from_minion_spawners = not use_occluded_positions or spawners and math.random() > 0.5

		if spawn_from_minion_spawners then
			local breeds = resistance_scaled_composition.breeds

			for i = 1, #breeds do
				local breed_data = breeds[i]
				local breed_name = breed_data.name
				local amount_range = breed_data.amount
				local amount = math.random(amount_range[1], amount_range[2])

				BreedQueries.add_spawns_single_breed(spawners, breed_name, amount, data.spawn_side_id, data.target_side_id, data.spawned_minion_data)
			end
		else
			local horde_manager = Managers.state.horde
			local towards_combat_vector = true

			horde_manager:horde(HORDE_TYPES.trickle_horde, "trickle_horde", data.spawn_side_id, data.target_side_id, resistance_scaled_composition, towards_combat_vector)
		end

		data.wave_counter = data.wave_counter + 1

		if data.num_waves <= data.wave_counter then
			local num_waves = template.num_waves
			data.num_waves = math.random(num_waves[1], num_waves[2])
			data.wave_counter = 0
			local cooldown = template.cooldown
			data.wave_timer = math.random(cooldown[1], cooldown[2])
		else
			local time_between_waves = template.time_between_waves
			data.wave_timer = math.random(time_between_waves[1], time_between_waves[2])
		end

		Managers.event:trigger("event_trickle_wave_spawned")
	end
end

local function _disable_nodes_with_lower_difficulty(nodes)
	return
end

TerrorEventManager._start_event = function (self, event_name, data)
	local nodes = self._event_templates[event_name]

	_disable_nodes_with_lower_difficulty(nodes)

	local new_event = {
		node_index = 1,
		stopped = false,
		name = event_name,
		nodes = nodes,
		data = data,
		scratchpad = {},
		spawned_minion_data = {}
	}
	local active_events = self._active_events
	active_events[#active_events + 1] = new_event
	local t = Managers.time:time("gameplay")
	local node = nodes[1]
	local node_type = node[1]

	if not node.disabled then
		TerrorEventNodes[node_type].init(node, new_event, t)
		Managers.telemetry_events:start_terror_event(event_name)
	end
end

TerrorEventManager.current_event = function (self)
	return self._current_event
end

TerrorEventManager._update_event = function (self, event, t, dt)
	self._current_event = event
	local nodes = event.nodes
	local node_index = event.node_index
	local node = nodes[node_index]
	local node_type = node[1]
	local node_completed = node.disabled or TerrorEventNodes[node_type].update(node, event.scratchpad, t, dt)

	if node_completed then
		local scratchpad = event.scratchpad

		table.clear(scratchpad)

		node_index = node_index + 1

		if node_index > #nodes then
			return true
		end

		event.node_index = node_index
		local next_node = nodes[node_index]

		if not next_node.disabled then
			local next_node_type = next_node[1]

			TerrorEventNodes[next_node_type].init(next_node, event, t)
		end
	end
end

TerrorEventManager.trigger_network_synced_level_flow = function (self, flow_event_name)
	Level.trigger_event(self._level, flow_event_name)

	local flow_event_id = self._flow_events_network_lookup[flow_event_name]

	Managers.state.game_session:send_rpc_clients("rpc_terror_event_trigger_level_flow", flow_event_id)
end

TerrorEventManager.rpc_terror_event_trigger_level_flow = function (self, channel_id, flow_event_id)
	local flow_event_name = self._flow_events_network_lookup[flow_event_id]

	Level.trigger_event(self._level, flow_event_name)
end

TerrorEventManager.destroy = function (self)
	if self._is_server then
		self._start_events = nil
		self._active_events = nil
		self._random_event_probabilities = nil
	else
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))

		self._network_event_delegate = nil
	end

	self._world = nil
	self._wwise_world = nil
	self._level = nil
end

return TerrorEventManager
