local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local LevelProps = require("scripts/settings/level_prop/level_props")
local NavTagVolumeBox = require("scripts/extension_systems/navigation/utilities/nav_tag_volume_box")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local DoorExtension = class("DoorExtension")
local TYPES = table.enum("none", "two_states", "three_states")
local OPEN_TYPES = table.enum("none", "open_only", "close_only")
local STATES = table.enum("none", "open", "open_fwd", "open_bwd", "closed")

DoorExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._nav_world = extension_init_context.nav_world
	self._type = TYPES.none
	self._open_type = OPEN_TYPES.none
	self._start_state = nil
	self._current_state = STATES.none
	self._anim_data = {
		[STATES.none] = {
			duration = 0
		},
		[STATES.open] = {
			event = "open",
			duration = 0
		},
		[STATES.open_fwd] = {
			event = "open_fwd",
			duration = 0
		},
		[STATES.open_bwd] = {
			event = "open_bwd",
			duration = 0
		},
		[STATES.closed] = {
			event = "close",
			duration = 0
		}
	}
	self._previous_anim_time_normalized = 0
	self._entrance_nav_blocked = false
	self._num_attackers = 0
	self._animation_extension = nil
	self._nav_layer_name = ""
	self._blocked_time = 0
	self._self_closing_time = 0
	self._self_closing_timer = 0
	self._control_panel_units = {}
	self._animation_extension = ScriptUnit.extension(unit, "animation_system")
	local extension_manager = Managers.state.extension
	local side_system = extension_manager:system("side_system")
	self._side_names = side_system:side_names()
	self._broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase_system = extension_manager:system("broadphase_system")
	self._broadphase = broadphase_system.broadphase
	local tm, half_size = Unit.box(unit)
	local bottom_center_position = Matrix4x4.translation(tm) + Vector3.down() * half_size.z
	local radius = math.max(half_size.x, half_size.y)
	self._broadphase_check_position = Vector3Box(bottom_center_position)
	self._broadphase_check_radius = radius
	self._bounding_box = Matrix4x4Box(tm)
	self._bounding_box_half_extents = Vector3Box(half_size)
end

DoorExtension.destroy = function (self)
	if self._is_server then
		self:_unspawn_control_panels()
		self:_set_nav_block(false)
	end
end

DoorExtension.hot_join_sync = function (self, unit, sender)
	self:_sync_server_state(sender, self._current_state)
end

DoorExtension.setup_from_component = function (self, type, start_state, open_duration, close_duration, allow_closing, self_closing_time, blocked_time, open_type, control_panel_props, control_panels_active, ignore_broadphase)
	local unit = self._unit
	self._type = type
	self._open_type = open_type
	self._start_state = start_state
	self._blocked_time = blocked_time
	self._allow_closing = allow_closing
	self._self_closing_time = self_closing_time

	self:_setup_nav_layer(unit, start_state)

	self._interactee_extension = ScriptUnit.has_extension(unit, "interactee_system")
	self._ignore_broadphase = ignore_broadphase

	if self._is_server then
		self:_spawn_control_panels(control_panel_props, control_panels_active)
	end

	if type == TYPES.two_states then
		self._anim_data[STATES.open].duration = open_duration
		self._anim_data[STATES.closed].duration = close_duration

		if start_state == "open_fwd" or start_state == "open_bwd" then
			self._start_state = "open"
		end
	elseif type == TYPES.three_states then
		self._anim_data[STATES.open_fwd].duration = open_duration
		self._anim_data[STATES.open_bwd].duration = open_duration
		self._anim_data[STATES.closed].duration = close_duration

		if start_state == "open" then
			self._start_state = "open_fwd"
		end
	end
end

DoorExtension._spawn_control_panels = function (self, control_panel_props, control_panels_active)
	if #control_panel_props == 0 then
		return
	end

	local unit = self._unit

	for i = 1, #control_panel_props do
		local control_panel_prop = control_panel_props[i]
		local node_name = "ap_control_panel_" .. tostring(i)

		if not Unit.has_node(unit, node_name) then
			Log.error("DoorExtension", "[_spawn_control_panel] Missing node '%s' to spawn control panel '%s'.", node_name, control_panel_prop)

			return
		end

		local control_panel_node = Unit.node(unit, node_name)
		local control_panel_position = Unit.world_position(unit, control_panel_node)
		local control_panel_rotation = Unit.world_rotation(unit, control_panel_node)
		local props_settings = LevelProps[control_panel_prop]
		local control_panel_unit_name = props_settings.unit_name
		local unit_spawner_manager = Managers.state.unit_spawner
		local spawn_offset_boxed = props_settings.spawn_offset

		if spawn_offset_boxed then
			local spawn_offset = spawn_offset_boxed:unbox()
			local control_panel_pose = Unit.world_pose(unit, control_panel_node)
			control_panel_position = Matrix4x4.transform(control_panel_pose, spawn_offset)
		end

		local control_panel_unit, _ = unit_spawner_manager:spawn_network_unit(control_panel_unit_name, "level_prop", control_panel_position, control_panel_rotation, nil, props_settings)
		local door_control_panel_extension = ScriptUnit.extension(control_panel_unit, "door_control_panel_system")

		door_control_panel_extension:register_door(self)
		door_control_panel_extension:set_active(control_panels_active)

		self._control_panel_units[#self._control_panel_units + 1] = control_panel_unit
	end
end

DoorExtension._unspawn_control_panels = function (self)
	local unit_spawner_manager = Managers.state.unit_spawner
	local control_panel_units = self._control_panel_units

	for _, control_panel_unit in ipairs(control_panel_units) do
		unit_spawner_manager:mark_for_deletion(control_panel_unit)
	end

	table.clear(self._control_panel_units)
end

DoorExtension.set_control_panel_active = function (self, val)
	local control_panel_units = self._control_panel_units

	for _, control_panel_unit in ipairs(control_panel_units) do
		local door_control_panel_extension = ScriptUnit.extension(control_panel_unit, "door_control_panel_system")

		door_control_panel_extension:set_active(val)
	end
end

DoorExtension._setup_nav_layer = function (self, unit, start_state)
	local unit_level_index = Managers.state.unit_spawner:level_index(unit)
	local layer_name = "door_volume_" .. tostring(unit_level_index)
	local volume_layer_allowed = true
	local is_server = self._is_server

	if is_server then
		volume_layer_allowed = start_state ~= STATES.closed
	end

	local volume_points, volume_alt_min, volume_alt_max = NavTagVolumeBox.create_from_unit(self._nav_world, unit)

	Managers.state.nav_mesh:add_nav_tag_volume(volume_points, volume_alt_min, volume_alt_max, layer_name, volume_layer_allowed)

	self._nav_layer_name = layer_name
	self._entrance_nav_blocked = not volume_layer_allowed
end

local SELF_CLOSE_CHECK_COOLDOWN = 0.25

DoorExtension.update = function (self, unit, dt, t)
	if self._is_server then
		if self._start_state ~= nil then
			self:_set_server_state(self._start_state)

			self._start_state = nil
		end

		if self._self_closing_timer > 0 and not self:_is_dead(unit) then
			self._self_closing_timer = self._self_closing_timer - dt

			if self._self_closing_timer <= 0 then
				local use_proximity_check = true

				if self:can_close(use_proximity_check) then
					self:close()
				else
					self._self_closing_timer = SELF_CLOSE_CHECK_COOLDOWN
				end
			end
		end

		self:_update_nav_block(unit)
	end

	self:_update_external_dependencies()
end

DoorExtension._should_nav_block = function (self)
	local current_state = self._current_state
	local closed = current_state == STATES.closed
	local anim_time = self:_normalized_anim_time()
	local blocked_time = self._blocked_time
	local should_nav_block = closed and blocked_time <= anim_time or not closed and anim_time < 1 - blocked_time

	return should_nav_block
end

DoorExtension._update_nav_block = function (self, unit)
	local is_dead = self:_is_dead(unit)
	local nav_blocked = self:nav_blocked()

	if is_dead then
		if not nav_blocked then
			self:_set_nav_block(false)
		end
	else
		local should_nav_block = self:_should_nav_block()

		if should_nav_block and not nav_blocked then
			self:_set_nav_block(true)
		elseif not should_nav_block and nav_blocked then
			self:_set_nav_block(false)
		end
	end
end

DoorExtension._normalized_anim_time = function (self)
	local anim_time_normalized = self:_anim_time() / self:_anim_duration()
	anim_time_normalized = math.clamp(anim_time_normalized, 0, 1)

	return anim_time_normalized
end

local _times_buffer = {}

DoorExtension._anim_time = function (self)
	local unit = self._unit
	local times = Unit.animation_get_time(unit, _times_buffer)
	local anim_duration = self:_anim_duration()
	local anim_time = math.min(times[1], anim_duration)

	return anim_time
end

DoorExtension._anim_duration = function (self)
	local state = self._current_state

	return self._anim_data[state].duration
end

DoorExtension._is_playing_anim = function (self)
	local anim_time = self:_normalized_anim_time()
	local is_playing = anim_time > 0 or anim_time < 1

	return is_playing
end

DoorExtension._update_external_dependencies = function (self)
	local current_normalized_anim_time = self:_normalized_anim_time()
	local previous_normalized_anim_time = self._previous_anim_time_normalized
	local delta = math.abs(current_normalized_anim_time - self._previous_anim_time_normalized)
	local reached_limits = previous_normalized_anim_time > 0 and previous_normalized_anim_time < 1 and (current_normalized_anim_time == 0 or current_normalized_anim_time == 1)
	local delta_threshold = delta > 0.1
	local should_update_external_dependencies = reached_limits or delta_threshold

	if should_update_external_dependencies then
		local unit = self._unit

		Unit.set_flow_variable(unit, "lua_animation_time", current_normalized_anim_time)
		Unit.flow_event(unit, "lua_update_animation_time")

		local component_system = Managers.state.extension:system("component_system")
		local portal_volume_components = component_system:get_components(unit, "WwisePortalVolume")
		local door_is_closed = self:can_open()
		local anim_time = self:_anim_time()
		local anim_duration = self:_anim_duration()

		for i = 1, #portal_volume_components do
			portal_volume_components[i]:door_apply_portal_obstruction(door_is_closed, current_normalized_anim_time, anim_time, anim_duration)
		end

		self._previous_anim_time_normalized = current_normalized_anim_time
	end
end

DoorExtension._set_nav_block = function (self, block)
	local nav_mesh_manager = Managers.state.nav_mesh
	local layer_name = self._nav_layer_name
	local allowed = not block

	nav_mesh_manager:set_allowed_nav_tag_layer(layer_name, allowed)

	self._entrance_nav_blocked = block
end

DoorExtension.nav_blocked = function (self)
	return self._entrance_nav_blocked
end

DoorExtension.can_attack = function (self)
	return self._current_state == STATES.closed and not self:_is_dead() and not self:_is_playing_anim()
end

DoorExtension.can_open = function (self, interactor_unit)
	local can_open = false
	local current_state = self._current_state
	local type = self._type
	local open_type = self._open_type

	if type == TYPES.two_states or type == TYPES.three_states and interactor_unit == nil then
		can_open = current_state == STATES.closed
		can_open = can_open and (open_type == OPEN_TYPES.open_only or open_type == OPEN_TYPES.none)
	elseif type == TYPES.three_states and interactor_unit ~= nil then
		can_open = current_state == STATES.closed
		can_open = can_open and (open_type == OPEN_TYPES.open_only or open_type == OPEN_TYPES.none)
	end

	can_open = can_open and not self:_is_dead()

	return can_open
end

DoorExtension.can_close = function (self, use_proximity_check)
	if not self._allow_closing then
		return false
	end

	local can_close = false

	if not use_proximity_check or not self:_minion_proximity_check() then
		local open_type = self._open_type
		can_close = self._current_state ~= STATES.closed and not self:_is_dead()
		can_close = can_close and (open_type == OPEN_TYPES.close_only or open_type == OPEN_TYPES.none)
	end

	return can_close
end

local broadphase_results = {}

DoorExtension._minion_proximity_check = function (self)
	table.clear_array(broadphase_results, #broadphase_results)

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
			if breed.is_boss then
				return true
			end

			local unit_position = POSITION_LOOKUP[unit]
			local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
			local current_velocity = locomotion_extension:current_velocity()
			local speed = Vector3.length(current_velocity)

			if speed > 0 then
				local velocity_direction = current_velocity / speed
				local to_door_direction = Vector3.normalize(check_position - unit_position)
				local direction_dot = Vector3.dot(velocity_direction, to_door_direction)

				if direction_dot > 0 then
					return true
				end
			end

			local offsetted_unit_position = unit_position + Vector3.up() * 0.25

			if math.point_is_inside_oobb(offsetted_unit_position, bounding_box, half_extents) then
				return true
			end
		end
	end

	return false
end

DoorExtension.open = function (self, state, interactor_unit, optional_closing_time)
	if self._type == TYPES.two_states then
		if state ~= nil and state ~= "open" then
			state = STATES.open
		end
	elseif self._type == TYPES.three_states and state ~= nil and state ~= "open_fwd" and state ~= "open_bwd" then
		state = STATES.open_fwd
	end

	if not state and interactor_unit then
		state = self:_get_open_state_from_interactor(interactor_unit)
	end

	local new_state = STATES[state]

	self:_set_server_state(new_state)

	self._self_closing_timer = optional_closing_time or self._self_closing_time
end

DoorExtension._get_open_state_from_interactor = function (self, interactor_unit)
	if self._type == TYPES.two_states then
		return STATES.open
	else
		local unit = self._unit
		local door_position = Unit.world_position(unit, 1)
		local door_rotation = Unit.world_rotation(unit, 1)
		local interactor_position = POSITION_LOOKUP[interactor_unit]
		local interaction_vector = door_position - interactor_position
		local interaction_direction = Vector3.normalize(Vector3.flat(interaction_vector))
		local door_forward = Quaternion.forward(door_rotation)
		local door_direction = Vector3.normalize(Vector3.flat(door_forward))
		local dot = Vector3.dot(interaction_direction, door_direction)
		local infront = dot >= 0

		if infront then
			return STATES.open_bwd
		else
			return STATES.open_fwd
		end
	end
end

DoorExtension.close = function (self)
	if not self:can_close() then
		return
	end

	self:_set_server_state(STATES.closed)

	self._self_closing_timer = 0
end

local bot_teleport_location_node_names = {
	"bot_teleport_location_01",
	"bot_teleport_location_02",
	"bot_teleport_location_03"
}

DoorExtension.teleport_bots = function (self)
	local unit = self._unit
	local current_node_name = bot_teleport_location_node_names[1]
	local has_node = Unit.has_node(unit, current_node_name)

	if not has_node then
		return
	end

	local bot_players = Managers.player:bot_players()
	local index = 1

	for _, bot_player in pairs(bot_players) do
		local bot_unit = bot_player.player_unit

		if bot_unit then
			current_node_name = bot_teleport_location_node_names[index]
			has_node = Unit.has_node(unit, current_node_name)

			if has_node then
				local node = Unit.node(unit, current_node_name)
				local node_position = Unit.world_position(unit, node)
				local blackboard = BLACKBOARDS[bot_unit]
				local follow_component = Blackboard.write_component(blackboard, "follow")
				follow_component.level_forced_teleport = true

				follow_component.level_forced_teleport_position:store(node_position)
			end

			index = index + 1
		end
	end
end

DoorExtension._is_dead = function (self, unit)
	local is_dead = false
	local health_extension = ScriptUnit.has_extension(unit, "health_system")

	if health_extension and not health_extension:is_alive() then
		is_dead = true
	end

	return is_dead
end

DoorExtension._set_current_state = function (self, state)
	self._current_state = state

	if self._interactee_extension then
		local text = "loc_action_interaction_open"

		if state ~= STATES.closed then
			text = "loc_action_interaction_close"
		end

		self._interactee_extension:set_action_text(text)

		if not self._allow_closing and string.find(state, "open") then
			self._interactee_extension:set_active(false)
		end
	end
end

DoorExtension._set_server_state = function (self, new_state)
	local current_state = self._current_state

	if current_state ~= new_state then
		local anim = self._anim_data[new_state]

		self._animation_extension:anim_event_with_variable_float(anim.event, "anim_duration", anim.duration)
		self:_do_flow_calls(new_state)
		self:_sync_server_state(nil, new_state)
		self:_set_current_state(new_state)
	end
end

DoorExtension._do_flow_calls = function (self, state)
	local unit = self._unit
	local anim = self._anim_data[state]

	Unit.set_flow_variable(unit, "lua_animation_length", anim.duration)

	if state ~= STATES.closed then
		Unit.flow_event(unit, "lua_open")
	elseif state == STATES.closed then
		Unit.flow_event(unit, "lua_close")
	end
end

DoorExtension._sync_server_state = function (self, peer_id, state)
	local unit = self._unit
	local unit_level_index = Managers.state.unit_spawner:level_index(unit)
	local state_lookup_id = NetworkLookup.door_states[state]

	if peer_id then
		local channel = Managers.state.game_session:peer_to_channel(peer_id)

		RPC.rpc_sync_door_state(channel, unit_level_index, state_lookup_id)
	else
		local game_session_manager = Managers.state.game_session

		game_session_manager:send_rpc_clients("rpc_sync_door_state", unit_level_index, state_lookup_id)
	end
end

DoorExtension.increment_num_attackers = function (self)
	self._num_attackers = self._num_attackers + 1
end

DoorExtension.decrement_num_attackers = function (self)
	self._num_attackers = self._num_attackers - 1
end

DoorExtension.num_attackers = function (self)
	return self._num_attackers
end

DoorExtension.ignore_broadphase = function (self)
	return self._ignore_broadphase
end

DoorExtension.rpc_sync_door_state = function (self, new_state)
	self:_do_flow_calls(new_state)
	self:_set_current_state(new_state)
end

return DoorExtension
