local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local MoveablePlatformExtension = class("MoveablePlatformExtension")
local MOVEABLE_PLATFORM_DIRECTION = table.enum("none", "forward", "backward")

MoveablePlatformExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._world = extension_init_context.world
	self._physics_world = extension_init_context.physics_world
	self._is_server = extension_init_context.is_server
	self._unit = unit
	self._network_story_manager = Managers.state.network_story
	self._story_name = nil
	self._story_direction = MOVEABLE_PLATFORM_DIRECTION.none
	self._walls = {}
	self._player_side = nil
	self._all_players_inside = false
	self._wall_collision_enabled = true
	self._passenger_units = {}
	self._overlap_result = {}
	self._interactables = {}
	self._require_all_players_onboard = false
	local initial_position = Unit.local_position(unit, 1)
	self._previous_update_position = Vector3Box(initial_position)
	self._current_velocity = Vector3Box()
	self._story_speed_forward = 1
	self._story_speed_backward = 1
	self._end_sound_time = 0
	self._play_end_sound = false
	self._level = Unit.level(unit)
	self._unit_spawner = Managers.state.unit_spawner
	local extension_manager = Managers.state.extension
	local side_system = extension_manager:system("side_system")
	self._side_system = side_system
	self._side_names = side_system:side_names()
	self._broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase_system = extension_manager:system("broadphase_system")
	self._broadphase = broadphase_system.broadphase

	self:_update_broadphase()

	local interactable_count = 1
	local interactable_prefix = "c_interactable_"
	local interactable_name = interactable_prefix .. tostring(interactable_count)
	local interactable_id = Unit.find_actor(unit, interactable_name)

	if interactable_id then
		while interactable_id ~= nil do
			self._interactables[interactable_count] = {
				name = interactable_name,
				node_id = interactable_id
			}
			interactable_count = interactable_count + 1
			interactable_name = interactable_prefix .. tostring(interactable_count)
			interactable_id = Unit.find_actor(unit, interactable_name)
		end
	end

	local wall_count = 1
	local wall_prefix = "c_wall_"
	local actor_id = Unit.find_actor(unit, wall_prefix .. tostring(wall_count))

	while actor_id ~= nil do
		self._walls[wall_count] = {
			actor_id = actor_id
		}
		wall_count = wall_count + 1
		actor_id = Unit.find_actor(unit, wall_prefix .. tostring(wall_count))
	end

	for _, wall in pairs(self._walls) do
		self:_enable_wall_collision(wall.actor_id, false)

		self._overlap_result[wall.actor_id] = {}
	end

	self._box = {
		actor_id = Unit.find_actor(unit, "c_box_center")
	}

	self:_enable_wall_collision(self._box.actor_id, false)

	self._overlap_result[self._box.actor_id] = {}
end

MoveablePlatformExtension.setup_from_component = function (self, story_name, player_side, wall_collision_enabled, wall_collision_filter, require_all_players_onboard, interactable_story_actions, interactable_hud_descriptions, story_speed_forward, story_speed_backward, end_sound_time, nav_handling_enabled, stop_position)
	local unit = self._unit
	self._story_name = story_name

	self._network_story_manager:register_story(story_name, self._level)
	self._network_story_manager:play_story(story_name, self._level, 0)

	self._player_side = player_side
	self._wall_collision_enabled = wall_collision_enabled
	self._wall_collision_filter = wall_collision_filter
	self._require_all_players_onboard = require_all_players_onboard
	self._story_speed_forward = story_speed_forward
	self._story_speed_backward = story_speed_backward
	self._end_sound_time = end_sound_time
	self._nav_handling_enabled = nav_handling_enabled
	self._stop_position = stop_position

	if nav_handling_enabled then
		self:_setup_nav_gates(unit)
	end

	self._story_length = self._network_story_manager:get_story_length(story_name, self._level)
	self._interactee_extension = ScriptUnit.has_extension(unit, "interactee_system")

	for i, interactable in ipairs(self._interactables) do
		local interactable_info = interactable

		if interactable_story_actions[i] then
			interactable_info.action = interactable_story_actions[i]
		else
			interactable_info.action = "none"
		end

		if interactable_hud_descriptions[i] then
			interactable_info.hud_description = interactable_hud_descriptions[i]
		else
			interactable_info.hud_description = "loc_default"
		end
	end
end

MoveablePlatformExtension.get_interactables = function (self)
	return self._interactables
end

MoveablePlatformExtension.can_move = function (self)
	local all_on_board = not self._require_all_players_onboard or self._require_all_players_onboard and self._all_players_inside
	local can_activate_wall_collision_enabled = not self._wall_collision_enabled or self._wall_collision_enabled and not self:_passengers_inside_walls()

	if not all_on_board or not can_activate_wall_collision_enabled then
		self:_set_block_text("loc_platform_blocked_missing_players")

		return false
	end

	local hostiles_onboard = self:_check_hostile_onboard()

	if hostiles_onboard then
		self:_set_block_text("loc_platform_blocked_hostiles_onboard")

		return false
	end

	self:_set_block_text(nil)

	return true
end

MoveablePlatformExtension._set_block_text = function (self, text)
	if self._interactee_extension then
		self._interactee_extension:set_block_text(text)
	end
end

MoveablePlatformExtension._set_direction = function (self, direction)
	fassert(self._is_server, "Server only method.")

	local story_state = self._network_story_manager:get_story_state(self._story_name, self._level)
	local story_states = self._network_story_manager.NETWORK_STORY_STATES
	local can_move = self:can_move()

	if can_move and direction == MOVEABLE_PLATFORM_DIRECTION.forward and story_state == story_states.pause_at_start then
		if self._all_players_inside then
			self:_handle_friendly_bots_on_set_direction()
		end

		if self._wall_collision_enabled then
			self:_lock_units_on_platform()
		end

		self._story_direction = MOVEABLE_PLATFORM_DIRECTION.forward
		local play_direction = self._story_speed_forward

		Unit.flow_event(self._unit, "lua_story_move_forward")

		self._play_end_sound = true

		self._network_story_manager:play_story(self._story_name, self._level, play_direction)
		self:_set_nav_layer_allowed(self._layer_name_start, false)
		self:_send_direction_to_clients()
	elseif can_move and direction == MOVEABLE_PLATFORM_DIRECTION.backward and story_state == story_states.pause_at_end then
		if self._all_players_inside then
			self:_handle_friendly_bots_on_set_direction()
		end

		if self._wall_collision_enabled then
			self:_lock_units_on_platform()
		end

		self._story_direction = MOVEABLE_PLATFORM_DIRECTION.backward
		local play_direction = -self._story_speed_backward

		Unit.flow_event(self._unit, "lua_story_move_backward")

		self._play_end_sound = true

		self._network_story_manager:play_story(self._story_name, self._level, play_direction)
		self:_set_nav_layer_allowed(self._layer_name_stop, false)
		self:_send_direction_to_clients()
	elseif direction == MOVEABLE_PLATFORM_DIRECTION.none then
		if self._story_direction ~= direction then
			Unit.flow_event(self._unit, "lua_moveable_platform_end_move")
		end

		self._story_direction = direction

		self:_send_direction_to_clients()
	end
end

MoveablePlatformExtension._send_direction_to_clients = function (self)
	local unit = self._unit
	local unit_level_index = Managers.state.unit_spawner:level_index(unit)
	local direction_id = NetworkLookup.moveable_platform_direction[self._story_direction]
	local game_session_manager = Managers.state.game_session

	game_session_manager:send_rpc_clients("rpc_moveable_platform_set_direction", unit_level_index, direction_id)
end

MoveablePlatformExtension.story_direction = function (self)
	return self._story_direction
end

MoveablePlatformExtension.set_direction_husk = function (self, direction)
	if direction == MOVEABLE_PLATFORM_DIRECTION.forward then
		self._play_end_sound = true

		Unit.flow_event(self._unit, "lua_story_move_forward")
	elseif direction == MOVEABLE_PLATFORM_DIRECTION.backward then
		self._play_end_sound = true

		Unit.flow_event(self._unit, "lua_story_move_backward")
	elseif direction == MOVEABLE_PLATFORM_DIRECTION.none and self._story_direction ~= direction then
		Unit.flow_event(self._unit, "lua_moveable_platform_end_move")
	end

	self._story_direction = direction
end

MoveablePlatformExtension._enable_wall_collision = function (self, actor_id, activate)
	local filter = "filter_player_character_trigger"

	if activate then
		filter = self._wall_collision_filter
	end

	local actor = Unit.actor(self._unit, actor_id)

	Actor.set_collision_filter(actor, filter)
end

local bot_teleport_location_node_names = {
	"bot_teleport_location_01",
	"bot_teleport_location_02",
	"bot_teleport_location_03"
}
local num_bot_teleport_location_node_names = #bot_teleport_location_node_names

MoveablePlatformExtension._force_teleport_bots = function (self, bot_player_units_to_teleport)
	local moveable_platform_unit = self._unit
	local index = 1

	for bot_player_unit, _ in pairs(bot_player_units_to_teleport) do
		local current_node_name = bot_teleport_location_node_names[index]
		local has_node = Unit.has_node(moveable_platform_unit, current_node_name)

		if has_node then
			local blackboard = BLACKBOARDS[bot_player_unit]
			local follow_component = Blackboard.write_component(blackboard, "follow")
			follow_component.level_forced_teleport = true
			local node = Unit.node(moveable_platform_unit, current_node_name)
			local node_position = Unit.world_position(moveable_platform_unit, node)

			follow_component.level_forced_teleport_position:store(node_position)
		else
			bot_player_units_to_teleport[bot_player_unit] = nil
		end

		index = index % num_bot_teleport_location_node_names + 1
	end
end

local TEMP_BOT_PLAYER_UNITS = {}

MoveablePlatformExtension._handle_friendly_bots_on_set_direction = function (self)
	table.clear(TEMP_BOT_PLAYER_UNITS)

	local has_valid_bots_that_should_be_passengers = false
	local side_name = self._player_side
	local side_system = self._side_system
	local side = side_system:get_side_from_name(side_name)

	if side then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player_units = side.player_units
		local num_player_units = #player_units

		for i = 1, num_player_units do
			local player_unit = player_units[i]
			local player = player_unit_spawn_manager:owner(player_unit)

			if not player:is_human_controlled() and self:_valid_passenger_player_unit(player_unit) then
				TEMP_BOT_PLAYER_UNITS[player_unit] = true
				has_valid_bots_that_should_be_passengers = true
			end
		end
	end

	if has_valid_bots_that_should_be_passengers then
		self:_force_teleport_bots(TEMP_BOT_PLAYER_UNITS)
		self:_add_bots_to_passengers(TEMP_BOT_PLAYER_UNITS)
	end
end

MoveablePlatformExtension.update = function (self, unit, dt, t)
	if self._is_server then
		if self._story_direction == MOVEABLE_PLATFORM_DIRECTION.forward then
			local story_states = self._network_story_manager.NETWORK_STORY_STATES
			local story_state = self._network_story_manager:get_story_state(self._story_name, self._level)

			self:_check_for_end_flow_events()

			if story_state == story_states.pause_at_end then
				self:_set_direction(MOVEABLE_PLATFORM_DIRECTION.none)
				self:_unlock_units_on_platform()
				self:_set_nav_layer_allowed(self._layer_name_stop, true)
				self:_update_broadphase()
			end
		elseif self._story_direction == MOVEABLE_PLATFORM_DIRECTION.backward then
			local story_states = self._network_story_manager.NETWORK_STORY_STATES
			local story_state = self._network_story_manager:get_story_state(self._story_name, self._level)

			self:_check_for_end_flow_events()

			if story_state == story_states.pause_at_start then
				self:_set_direction(MOVEABLE_PLATFORM_DIRECTION.none)
				self:_unlock_units_on_platform()
				self:_set_nav_layer_allowed(self._layer_name_start, true)
				self:_update_broadphase()
			end
		end
	else
		self:_check_for_end_flow_events()
	end
end

MoveablePlatformExtension._check_for_end_flow_events = function (self)
	local story_name = self._story_name
	local level = self._level
	local network_story_manager = self._network_story_manager
	local story_states = network_story_manager.NETWORK_STORY_STATES
	local story_state = network_story_manager:get_story_state(story_name, level)

	if story_state == story_states.playing then
		local story_time = network_story_manager:get_story_time(story_name, level)
		local story_length = self._network_story_manager:get_story_length(story_name, level)
		local remaining_time = story_length - story_time

		if self._story_direction == MOVEABLE_PLATFORM_DIRECTION.backward then
			remaining_time = story_time
		end

		if self._play_end_sound then
			local story_speed = self._story_speed_forward

			if self._story_direction == MOVEABLE_PLATFORM_DIRECTION.backward then
				story_speed = self._story_speed_backward
			end

			if remaining_time <= self._end_sound_time * story_speed then
				Unit.flow_event(self._unit, "lua_moveable_platform_end_sound")

				self._play_end_sound = false
			end
		end
	end
end

MoveablePlatformExtension.fixed_update = function (self, unit, dt, t)
	self:_update_passengers()
	self:_update_overlap()

	self._all_players_inside = self:_get_passengers_onboard_info()

	self:_set_flow_all_players_onboard(self._all_players_inside)
end

MoveablePlatformExtension.post_update = function (self, unit, dt, t)
	self:_update_velocity(unit, dt)
end

MoveablePlatformExtension._update_passengers = function (self)
	Profiler.start("_update_passengers")

	local passenger_units = self._passenger_units
	local passenger_actors = self._overlap_result[self._box.actor_id]

	if passenger_actors then
		local ActorBox_unbox = ActorBox.unbox
		local Actor_unit = Actor.unit

		for i = 1, #passenger_actors do
			local passenger_actor = ActorBox_unbox(passenger_actors[i])

			if passenger_actor then
				local passenger_unit = Actor_unit(passenger_actor)

				if not passenger_units[passenger_unit] then
					passenger_units[passenger_unit] = true
				end
			end
		end
	end

	Profiler.stop("_update_passengers")
end

MoveablePlatformExtension._add_bots_to_passengers = function (self, bot_player_units_to_teleport)
	local passenger_units = self._passenger_units

	for bot_player_unit, _ in pairs(bot_player_units_to_teleport) do
		if not passenger_units[bot_player_unit] then
			passenger_units[bot_player_unit] = true
		end
	end
end

MoveablePlatformExtension._update_overlap = function (self)
	Profiler.start("_update_overlap")

	for _, wall in pairs(self._walls) do
		self:_send_player_overlap_request(wall.actor_id)
	end

	self:_send_player_overlap_request(self._box.actor_id)
	Profiler.stop("_update_overlap")
end

MoveablePlatformExtension._update_velocity = function (self, unit, dt)
	local previous_position = self._previous_update_position:unbox()
	local current_position = Unit.local_position(unit, 1)
	local delta_pos = current_position - previous_position
	local velocity = delta_pos / dt

	self._current_velocity:store(velocity)
	self._previous_update_position:store(current_position)
end

MoveablePlatformExtension._send_player_overlap_request = function (self, actor_id)
	local unit = self._unit
	local actor = Unit.actor(unit, actor_id)
	local node = Actor.node(actor)
	local meshes = Unit.get_node_meshes(unit, node, true, false)
	local mesh_id = meshes and meshes[1]

	if mesh_id then
		local mesh = Unit.mesh(unit, mesh_id)
		local box_pose, box_half_extents = Mesh.box(mesh)
		local position = Matrix4x4.translation(box_pose)
		local rotation = Matrix4x4.rotation(box_pose)
		local size = box_half_extents + Vector3(0.2, 0.2, 0)

		PhysicsWorld.overlap(self._physics_world, function (...)
			self:_receive_overlap_result_players(actor_id, ...)
		end, "shape", "oobb", "position", position, "rotation", rotation, "size", size, "collision_filter", "filter_player_character_trigger")
	end
end

MoveablePlatformExtension._receive_overlap_result_players = function (self, actor_id, _, hit_actors)
	Profiler.start("_receive_overlap_result_players")

	local overlaps_for_actor = self._overlap_result[actor_id]

	table.clear(overlaps_for_actor)

	local i = 1

	for _, actor in pairs(hit_actors) do
		overlaps_for_actor[i] = ActorBox()

		overlaps_for_actor[i]:store(actor)

		i = i + 1
	end

	Profiler.stop("_receive_overlap_result_players")
end

MoveablePlatformExtension._lock_units_on_platform = function (self)
	for _, wall in pairs(self._walls) do
		self:_enable_wall_collision(wall.actor_id, true)
	end

	self:_set_platform_as_parent_for_all_passengers()
end

MoveablePlatformExtension._passengers_inside_walls = function (self)
	for _, wall in pairs(self._walls) do
		if self._overlap_result[wall.actor_id] then
			local results = self._overlap_result[wall.actor_id]
			local num_actors_in_wall = #results

			if num_actors_in_wall > 0 then
				return true
			end
		end
	end

	return false
end

MoveablePlatformExtension._update_broadphase = function (self)
	local tm, half_size = Unit.box(self._unit)
	local bottom_center_position = Matrix4x4.translation(tm) + Vector3.down() * half_size.z
	self._broadphase_check_position = Vector3Box(bottom_center_position)
	local radius = math.max(half_size.x, half_size.y)
	self._broadphase_check_radius = radius
	self._bounding_box = Matrix4x4Box(tm)
	self._bounding_box_half_extents = Vector3Box(half_size)
end

local broadphase_results = {}

MoveablePlatformExtension._check_hostile_onboard = function (self)
	local check_radius = self._broadphase_check_radius
	local check_position = self._broadphase_check_position:unbox()
	local broadphase = self._broadphase
	local side_names = self._side_names
	local bounding_box = self._bounding_box:unbox()
	local half_extents = self._bounding_box_half_extents:unbox()
	local num_results = Broadphase.query(broadphase, check_position, check_radius, broadphase_results, side_names)

	for i = 1, num_results do
		local unit = broadphase_results[i]
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local is_minion = Breed.is_minion(breed)

		if is_minion then
			local unit_position = Unit.world_position(unit, 1)
			local offsetted_unit_position = unit_position + Vector3.up() * 0.25

			if math.point_is_inside_oobb(offsetted_unit_position, bounding_box, half_extents) then
				return true
			end
		end
	end
end

MoveablePlatformExtension._unlock_units_on_platform = function (self)
	for _, wall in pairs(self._walls) do
		self:_enable_wall_collision(wall.actor_id, false)
	end

	self:_unparent_all_passengers()
end

MoveablePlatformExtension._set_platform_as_parent = function (self, passenger_unit)
	if ALIVE[passenger_unit] then
		local is_husk_unit = self._unit_spawner:is_husk(passenger_unit)

		if not is_husk_unit then
			local locomotion_extension = ScriptUnit.has_extension(passenger_unit, "locomotion_system")

			if locomotion_extension then
				locomotion_extension:set_parent_unit(self._unit)
			end
		end
	end
end

MoveablePlatformExtension._set_platform_as_parent_for_all_passengers = function (self)
	for passenger_unit, _ in pairs(self._passenger_units) do
		if ALIVE[passenger_unit] then
			local game_object = self._unit_spawner:game_object_id(passenger_unit)

			if game_object then
				local is_husk_unit = self._unit_spawner:is_husk(passenger_unit)

				if not is_husk_unit then
					local locomotion_extension = ScriptUnit.has_extension(passenger_unit, "locomotion_system")

					if locomotion_extension then
						locomotion_extension:set_parent_unit(self._unit)
					end
				end
			end
		end
	end
end

MoveablePlatformExtension._unparent_passenger = function (self, passenger_unit)
	if ALIVE[passenger_unit] then
		local is_husk_unit = self._unit_spawner:is_husk(passenger_unit)

		if not is_husk_unit then
			local locomotion_extension = ScriptUnit.has_extension(passenger_unit, "locomotion_system")

			if locomotion_extension then
				locomotion_extension:set_parent_unit()
			end
		end
	end
end

MoveablePlatformExtension._unparent_all_passengers = function (self)
	local ALIVE = ALIVE

	for passenger_unit, _ in pairs(self._passenger_units) do
		if ALIVE[passenger_unit] then
			local game_object = self._unit_spawner:game_object_id(passenger_unit)

			if game_object then
				local is_husk_unit = self._unit_spawner:is_husk(passenger_unit)

				if not is_husk_unit then
					local locomotion_extension = ScriptUnit.has_extension(passenger_unit, "locomotion_system")

					if locomotion_extension then
						locomotion_extension:set_parent_unit()
					end
				end
			end
		end
	end

	table.clear(self._passenger_units)
end

MoveablePlatformExtension.move_forward = function (self)
	fassert(self._is_server, "Server only method.")
	self:_set_direction(MOVEABLE_PLATFORM_DIRECTION.forward)
end

MoveablePlatformExtension.move_backward = function (self)
	fassert(self._is_server, "Server only method.")
	self:_set_direction(MOVEABLE_PLATFORM_DIRECTION.backward)
end

MoveablePlatformExtension.toggle_require_all_players_onboard = function (self)
	self._require_all_players_onboard = not self._require_all_players_onboard
end

MoveablePlatformExtension._set_flow_all_players_onboard = function (self, val)
	Unit.set_flow_variable(self._unit, "lua_all_players_onboard", val)
end

MoveablePlatformExtension.destroy = function (self)
	self:_unparent_all_passengers()

	self._unit = nil
	self._story_name = nil
	self._walls = nil
	self._box = nil
	self._passenger_units = nil
	self._overlap_result = nil

	if self._is_server and self._nav_handling_enabled then
		local nav_mesh_manager = Managers.state.nav_mesh
		local layer_name_start = self._layer_name_start

		if not nav_mesh_manager:is_nav_tag_volume_layer_allowed(layer_name_start) then
			nav_mesh_manager:set_allowed_nav_tag_layer(layer_name_start, true)
		end

		local layer_name_stop = self._layer_name_stop

		if not nav_mesh_manager:is_nav_tag_volume_layer_allowed(layer_name_stop) then
			nav_mesh_manager:set_allowed_nav_tag_layer(layer_name_stop, true)
		end
	end
end

MoveablePlatformExtension._valid_passenger_player_unit = function (self, player_unit)
	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")

	return HEALTH_ALIVE[player_unit] and not PlayerUnitStatus.is_hogtied(character_state_component)
end

local units_inside = {}

MoveablePlatformExtension._get_passengers_onboard_info = function (self)
	local side_name = self._player_side
	local side_system = self._side_system
	local side = side_system:get_side_from_name(side_name)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn

	if side then
		local ActorBox_unbox = ActorBox.unbox
		local Actor_unit = Actor.unit
		local player_units = side.player_units
		local passenger_actors = self._overlap_result[self._box.actor_id]

		table.clear(units_inside)

		for i = 1, #passenger_actors do
			local passenger_actor = ActorBox_unbox(passenger_actors[i])

			if passenger_actor then
				local passenger_unit = Actor_unit(passenger_actor)
				units_inside[passenger_unit] = true
			end
		end

		local all_valid_players_inside = true
		local at_least_one_player_inside = false

		for i = 1, #player_units do
			local player_unit = player_units[i]
			local player = player_unit_spawn_manager:owner(player_unit)
			local is_human = player:is_human_controlled()

			if is_human and self:_valid_passenger_player_unit(player_unit) then
				if not units_inside[player_unit] then
					all_valid_players_inside = false

					break
				end

				at_least_one_player_inside = true
			end
		end

		return all_valid_players_inside and at_least_one_player_inside
	else
		return false
	end
end

MoveablePlatformExtension.player_side = function (self)
	return self._player_side
end

MoveablePlatformExtension._get_volume_alt_min_max = function (self, volume_points, volume_height)
	fassert(#volume_points > 0, "[NavBlockExtension][_get_volume_alt_min_max][Unit: %s] No volume points.", Unit.id_string(self._unit))

	local alt_min, alt_max = nil

	for i = 1, #volume_points do
		local alt = volume_points[i].z

		if not alt_min or alt < alt_min then
			alt_min = alt
		end

		if not alt_max or alt_max < alt + volume_height then
			alt_max = alt + volume_height
		end
	end

	return alt_min, alt_max
end

MoveablePlatformExtension._setup_nav_gates = function (self, unit)
	local unit_level_index = Managers.state.unit_spawner:level_index(unit)
	local layer_name_start = "nav_elevator_volume_" .. tostring(unit_level_index) .. "_start"
	local layer_name_stop = "nav_elevator_volume_" .. tostring(unit_level_index) .. "_stop"
	local volume_points = Unit.volume_points(unit, "g_volume_block")
	local volume_height = Unit.volume_height(unit, "g_volume_block")
	local volume_alt_min, volume_alt_max = self:_get_volume_alt_min_max(volume_points, volume_height)

	Managers.state.nav_mesh:add_nav_tag_volume(volume_points, volume_alt_min, volume_alt_max, layer_name_start, true)

	self._layer_name_start = layer_name_start
	local offset_position = self._stop_position:unbox() - Unit.world_position(unit, 1)

	for i, volume_point in ipairs(volume_points) do
		volume_points[i] = volume_point + offset_position
	end

	volume_alt_min, volume_alt_max = self:_get_volume_alt_min_max(volume_points, volume_height)

	Managers.state.nav_mesh:add_nav_tag_volume(volume_points, volume_alt_min, volume_alt_max, layer_name_stop, false)

	self._layer_name_stop = layer_name_stop
end

MoveablePlatformExtension._set_nav_layer_allowed = function (self, layer_name, is_allowed)
	fassert(self._is_server, "[MoveablePlatformExtension][_set_nav_layer_allowed] Method should only be called on the server")

	if not self._nav_handling_enabled then
		return
	end

	local nav_mesh_manager = Managers.state.nav_mesh

	nav_mesh_manager:set_allowed_nav_tag_layer(layer_name, is_allowed)
end

return MoveablePlatformExtension
