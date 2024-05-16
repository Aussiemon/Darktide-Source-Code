-- chunkname: @scripts/extension_systems/destructible/destructible_extension.lua

local LightControllerUtilities = require("core/scripts/common/light_controller_utilities")
local NavTagVolumeBox = require("scripts/extension_systems/navigation/utilities/nav_tag_volume_box")
local _add_force_on_parts, _calculate_total_health, _set_lights_enabled, _set_meshes_visiblity, _setup_stages, _wake_up_dynamic_actors, _wake_up_static_actors
local FORCE_DIRECTION = table.enum("random_direction", "attack_direction", "provided_direction_relative", "provided_direction_world")
local DestructibleExtension = class("DestructibleExtension")

DestructibleExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._nav_world = extension_init_context.nav_world
	self._is_server = extension_init_context.is_server
	self._destruction_info = nil
	self._despawn_when_destroyed = true
	self._despawn_timer_duration = nil
	self._time_to_despawn = nil
	self._is_nav_gate = false
	self._nav_layer_name = nil
	self._broadphase_radius = nil
	self._visibility_info = {
		fake_light = false,
		lights_enabled = true,
		visible = true,
	}
end

DestructibleExtension.destroy = function (self)
	self:_disable_nav_volume()
end

DestructibleExtension._disable_nav_volume = function (self)
	if self._nav_layer_name then
		local nav_mesh_manager = Managers.state.nav_mesh
		local layer_name = self._nav_layer_name

		if not nav_mesh_manager:is_nav_tag_volume_layer_allowed(layer_name) then
			nav_mesh_manager:set_allowed_nav_tag_layer(layer_name, true)
		end

		self._nav_layer_name = nil
	end
end

DestructibleExtension.setup_from_component = function (self, despawn_timer_duration, despawn_when_destroyed, collision_actor_names, mass, speed, direction, force_direction_type, start_visible, is_nav_gate, broadphase_radius, use_health_extension_health, collectible_data)
	local unit = self._unit

	self._despawn_when_destroyed = despawn_when_destroyed
	self._despawn_timer_duration = despawn_timer_duration
	self._broadphase_radius = broadphase_radius
	self._use_health_extension_health = use_health_extension_health

	local parameters = {
		parts_mass = mass,
		parts_speed = speed,
		force_direction = direction,
		force_direction_type = force_direction_type,
		start_visible = start_visible,
		collision_actors = {},
	}

	if #collision_actor_names > 0 then
		local collision_actors = parameters.collision_actors

		for ii = 1, #collision_actor_names do
			collision_actors[ii] = Unit.actor(unit, collision_actor_names[ii])
		end
	end

	self._parameters = parameters

	if is_nav_gate then
		self:_setup_nav_gate()
	end

	self._is_nav_gate = is_nav_gate

	if collectible_data then
		collectible_data.unit = unit

		local collectibles_manager = Managers.state.collectibles

		collectibles_manager:register_destructible(collectible_data)

		self._collectible_data = collectible_data
	end
end

DestructibleExtension.setup_stages = function (self)
	local unit = self._unit
	local health_extension = ScriptUnit.has_extension(unit, "health_system")
	local parameters = self._parameters

	self._destruction_info = _setup_stages(unit, parameters, health_extension)

	self:set_visibility(parameters.start_visible)
end

DestructibleExtension.hot_join_sync = function (self, unit, peer_id, channel_id)
	local is_level_unit, unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(unit)
	local destruction_info = self._destruction_info

	if destruction_info then
		local current_stage_index = destruction_info.current_stage_index
		local visible = self._visibility_info.visible
		local from_hot_join_sync = true

		if unit_id then
			local game_session_manager = Managers.state.game_session
			local health_extension = ScriptUnit.has_extension(unit, "health_system")
			local max_health = health_extension and health_extension:max_health() or 1

			if peer_id then
				local channel = game_session_manager:peer_to_channel(peer_id)

				if max_health > destruction_info.health then
					RPC.rpc_destructible_damage_taken(channel, unit_id, is_level_unit)
				end

				RPC.rpc_sync_destructible(channel, unit_id, is_level_unit, current_stage_index, visible, from_hot_join_sync)
			else
				if max_health > destruction_info.health then
					game_session_manager:send_rpc_clients("rpc_destructible_damage_taken", unit_id, is_level_unit)
				end

				game_session_manager:send_rpc_clients("rpc_sync_destructible", unit_id, is_level_unit, current_stage_index, visible, from_hot_join_sync)
			end
		end
	end
end

DestructibleExtension.update = function (self, unit, dt, t)
	if self._destruction_info then
		local current_stage_index = self._destruction_info.current_stage_index
		local should_despawn = self._despawn_when_destroyed and current_stage_index == 0 and self._timer_to_despawn ~= 0

		if current_stage_index == 0 then
			self:_disable_nav_volume()
		end

		if should_despawn then
			if self._timer_to_despawn == nil then
				self._timer_to_despawn = self._despawn_timer_duration
			end

			self._timer_to_despawn = self._timer_to_despawn - dt
			self._timer_to_despawn = math.max(self._timer_to_despawn, 0)

			if self._timer_to_despawn == 0 then
				Managers.state.unit_spawner:mark_for_deletion(unit)
			end
		end
	end
end

DestructibleExtension.set_enabled_from_component = function (self, value)
	local actor = Unit.actor(self._unit, "c_destructible")

	Actor.set_scene_query_enabled(actor, value)
end

DestructibleExtension.set_physics_disabled = function (self, physics_disabled)
	self._physics_disabled = physics_disabled
end

DestructibleExtension.physics_disabled = function (self)
	return self._physics_disabled
end

DestructibleExtension.set_visibility = function (self, is_visible)
	local unit = self._unit

	Unit.set_visibility(unit, "main", is_visible)

	self._visibility_info.visible = is_visible

	_set_lights_enabled(unit, self._destruction_info, self._visibility_info)
end

DestructibleExtension.add_damage = function (self, damage_amount, hit_actor, attack_direction, attacking_unit)
	if not self._is_server then
		return
	end

	local unit = self._unit
	local destruction_info = self._destruction_info
	local old_stage_index = destruction_info.current_stage_index

	self:_add_damage(damage_amount, attack_direction, false, attacking_unit)

	local new_stage_index = destruction_info.current_stage_index

	if old_stage_index ~= new_stage_index then
		local unit_object_id = Managers.state.unit_spawner:game_object_id(unit)
		local unit_level_id = Managers.state.unit_spawner:level_index(unit)
		local is_level_unit = unit_object_id == nil and unit_level_id ~= nil
		local unit_id = unit_object_id or unit_level_id or NetworkConstants.invalid_level_unit_id
		local visible = true
		local from_hot_join_sync = false

		if unit_id ~= nil then
			Managers.state.game_session:send_rpc_clients("rpc_sync_destructible", unit_id, is_level_unit, new_stage_index, visible, from_hot_join_sync)
		end
	end
end

DestructibleExtension._setup_nav_gate = function (self)
	local unit = self._unit
	local unit_level_index = Managers.state.unit_spawner:level_index(unit)
	local layer_name = "monster_wall_volume_" .. tostring(unit_level_index)
	local volume_layer_allowed = false
	local volume_points, volume_alt_min, volume_alt_max = NavTagVolumeBox.create_from_unit(self._nav_world, unit)

	if Unit.has_visibility_group(unit, "NavGate") then
		Unit.set_visibility(unit, "NavGate", false)
	end

	Managers.state.nav_mesh:add_nav_tag_volume(volume_points, volume_alt_min, volume_alt_max, layer_name, volume_layer_allowed)

	self._nav_layer_name = layer_name
end

DestructibleExtension.force_destruct = function (self)
	local destruction_info = self._destruction_info
	local damage_amount = _calculate_total_health(destruction_info)

	self:_add_damage(damage_amount, nil, true)
end

DestructibleExtension.light_controller_setup = function (self, are_lights_enabled, fake_light)
	local visibility_info = self._visibility_info

	visibility_info.lights_enabled = are_lights_enabled
	visibility_info.fake_light = fake_light

	local destruction_info = self._destruction_info

	if destruction_info then
		_set_lights_enabled(self._unit, destruction_info, visibility_info)
	end
end

DestructibleExtension.set_lights_enabled = function (self, are_lights_enabled)
	local visibility_info = self._visibility_info

	visibility_info.lights_enabled = are_lights_enabled

	local destruction_info = self._destruction_info

	if destruction_info then
		_set_lights_enabled(self._unit, destruction_info, visibility_info)
	end
end

DestructibleExtension.rpc_destructible_damage_taken = function (self)
	Unit.flow_event(self._unit, "lua_damage_taken")
end

DestructibleExtension.rpc_destructible_last_destruction = function (self)
	Unit.flow_event(self._unit, "lua_last_destruction")
end

DestructibleExtension.rpc_sync_destructible = function (self, current_stage_index, visible, from_hot_join_sync)
	local unit = self._unit
	local destruction_info = self._destruction_info
	local visibility_info = self._visibility_info

	if visibility_info.visible ~= visible then
		self:set_visibility(visible)
	end

	if destruction_info.current_stage_index ~= current_stage_index then
		if current_stage_index > 0 then
			Unit.flow_event(unit, "lua_synced_intact")
		else
			Unit.flow_event(unit, "lua_synced_destroyed")
		end
	end

	self:_set_stage(current_stage_index, from_hot_join_sync)
end

DestructibleExtension.broadphase_radius = function (self)
	return self._broadphase_radius
end

DestructibleExtension._set_stage = function (self, new_stage, from_hot_join_sync)
	local current_stage_index = self._destruction_info.current_stage_index

	while current_stage_index ~= new_stage do
		current_stage_index = self:_dequeue_stage(nil, from_hot_join_sync)
	end
end

DestructibleExtension._dequeue_stage = function (self, attack_direction, from_hot_join_sync)
	local destruction_info = self._destruction_info
	local visibility_info = self._visibility_info
	local current_stage_index = destruction_info.current_stage_index

	if current_stage_index > 0 then
		local unit = self._unit
		local initial_actor = ActorBox.unbox(destruction_info.initial_actor)

		Actor.set_collision_enabled(initial_actor, false)
		Actor.set_scene_query_enabled(initial_actor, false)

		if not DEDICATED_SERVER then
			Unit.set_visibility(unit, "main", false)
			_set_meshes_visiblity(unit, destruction_info.meshes, true)
			_wake_up_static_actors(destruction_info.static_actors)
			_wake_up_dynamic_actors(destruction_info.dynamic_actors)
		end

		if not from_hot_join_sync then
			if not DEDICATED_SERVER then
				local force_direction_type = destruction_info.force_direction_type

				if force_direction_type == FORCE_DIRECTION.random_direction then
					attack_direction = nil
				elseif force_direction_type == FORCE_DIRECTION.provided_direction_world then
					attack_direction = destruction_info.force_direction:unbox()
				elseif force_direction_type == FORCE_DIRECTION.provided_direction_relative then
					local local_direction = destruction_info.force_direction:unbox()
					local unit_rotation = Unit.world_rotation(unit, 1)

					attack_direction = Quaternion.rotate(unit_rotation, local_direction)
				end

				_add_force_on_parts(destruction_info.dynamic_actors, destruction_info.parts_mass, destruction_info.parts_speed, attack_direction)
			end

			local collision_actors = destruction_info.collision_actors

			for ii = 1, #collision_actors do
				Actor.set_collision_enabled(collision_actors[ii], false)
				Actor.set_scene_query_enabled(collision_actors[ii], false)
			end

			if self._is_server then
				Unit.flow_event(unit, "lua_last_destruction")

				local is_level_unit, unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(unit)

				Managers.state.game_session:send_rpc_clients("rpc_destructible_last_destruction", unit_id, is_level_unit)
			end
		end

		destruction_info.current_stage_index = 0

		_set_lights_enabled(unit, destruction_info, visibility_info)
	end

	return destruction_info.current_stage_index
end

DestructibleExtension._add_damage = function (self, damage_amount, attack_direction, force_destruction, attacking_unit)
	local destruction_info = self._destruction_info
	local unit = self._unit
	local current_stage_index = destruction_info.current_stage_index

	if current_stage_index > 0 and damage_amount > 0 then
		local health_after_damage
		local health_extension = ScriptUnit.has_extension(unit, "health_system")

		if health_extension and self._use_health_extension_health then
			health_after_damage = health_extension:current_health()
		else
			health_after_damage = destruction_info.health - damage_amount
		end

		destruction_info.health = math.max(0, health_after_damage)

		if health_after_damage <= 0 then
			self:_dequeue_stage(attack_direction, false)

			if self._collectible_data then
				local collectibles_manager = Managers.state.collectibles

				collectibles_manager:collectible_destroyed(self._collectible_data, attacking_unit)
			end
		elseif self._is_server then
			Unit.flow_event(unit, "lua_damage_taken")

			local is_level_unit, unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(unit)

			Managers.state.game_session:send_rpc_clients("rpc_destructible_damage_taken", unit_id, is_level_unit)
		end
	end
end

DestructibleExtension.set_collectible_data = function (self, data)
	self._collectible_data = data
end

function _set_meshes_visiblity(unit, meshes, visible)
	local Unit_set_mesh_visibility = Unit.set_mesh_visibility

	for ii = 1, #meshes do
		Unit_set_mesh_visibility(unit, meshes[ii], visible)
	end
end

function _setup_stages(unit, parameters, health_extension)
	local destructible_parameters = table.shallow_copy(parameters)

	destructible_parameters.current_stage_index = 1

	local initial_actor = Unit.actor(unit, "c_destructible")

	destructible_parameters.initial_actor = ActorBox(initial_actor)

	Unit.set_visibility(unit, "main", true)

	local parent_node

	if Unit.has_node(unit, "ds_1") then
		parent_node = Unit.node(unit, "ds_1")
	end

	destructible_parameters.health = 1

	if health_extension then
		destructible_parameters.health = health_extension:max_health()
	end

	if parent_node == nil then
		destructible_parameters.meshes = {}
		destructible_parameters.lights = {}
		destructible_parameters.dynamic_actors = {}
		destructible_parameters.static_actors = {}
	else
		destructible_parameters.meshes = Unit.get_node_meshes(unit, parent_node, true, false) or {}

		_set_meshes_visiblity(unit, destructible_parameters.meshes, false)

		destructible_parameters.lights = Unit.get_node_lights(unit, parent_node, true, false) or {}

		local unit_actors = Unit.get_node_actors(unit, parent_node, true, false) or {}
		local dynamic_actors = {}
		local static_actors = {}

		for ii = 1, #unit_actors do
			local actor = Unit.actor(unit, unit_actors[ii])

			if Actor.is_dynamic(actor) then
				Actor.set_kinematic(actor, true)
				Actor.set_collision_enabled(actor, false)
				Actor.set_scene_query_enabled(actor, false)
				Actor.set_simulation_enabled(actor, false)

				dynamic_actors[#dynamic_actors + 1] = ActorBox(actor)
			elseif Actor.is_static(actor) then
				Actor.set_collision_enabled(actor, false)
				Actor.set_scene_query_enabled(actor, false)

				static_actors[#static_actors + 1] = ActorBox(actor)
			end
		end

		destructible_parameters.dynamic_actors = dynamic_actors
		destructible_parameters.static_actors = static_actors
	end

	return destructible_parameters
end

function _wake_up_static_actors(actors)
	for ii = 1, #actors do
		local actor = ActorBox.unbox(actors[ii])

		Actor.set_collision_enabled(actor, true)
		Actor.set_scene_query_enabled(actor, true)
	end
end

function _wake_up_dynamic_actors(actors)
	for ii = 1, #actors do
		local actor = ActorBox.unbox(actors[ii])

		Actor.set_collision_enabled(actor, true)
		Actor.set_kinematic(actor, false)
		Actor.set_simulation_enabled(actor, true)
		Actor.wake_up(actor)
	end
end

function _add_force_on_parts(actors, mass, speed, attack_direction)
	local direction = attack_direction

	for ii = 1, #actors do
		local actor = ActorBox.unbox(actors[ii])

		if not attack_direction then
			local random_x = math.random() * 2 - 1
			local random_y = math.random() * 2 - 1
			local random_z = math.random() * 2 - 1
			local random_direction = Vector3(random_x, random_y, random_z)

			direction = Vector3.normalize(random_direction)
		end

		Actor.add_impulse(actor, direction * mass * speed)
	end
end

function _calculate_total_health(destructible_parameters)
	local current_stage_index = destructible_parameters.current_stage_index
	local health = 0

	if current_stage_index > 0 then
		health = destructible_parameters.health
	end

	return health
end

function _set_lights_enabled(unit, destructible_parameters, visibility_info)
	local unit_visible = visibility_info.visible
	local lights_enabled = visibility_info.lights_enabled
	local fake_light = visibility_info.fake_light
	local destroyed = destructible_parameters.current_stage_index <= 0

	LightControllerUtilities.set_enabled(unit, unit_visible and lights_enabled and not destroyed, fake_light)
end

return DestructibleExtension
