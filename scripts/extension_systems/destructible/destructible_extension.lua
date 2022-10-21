local DestructibleUtilities = require("scripts/extension_systems/destructible/utilities/destructible_utilities")
local NavTagVolumeBox = require("scripts/extension_systems/navigation/utilities/nav_tag_volume_box")
local DestructibleExtension = class("DestructibleExtension")

DestructibleExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._nav_world = extension_init_context.nav_world
	self._is_server = extension_init_context.is_server
	self._destruction_info = nil
	self._despawn_when_destroyed = true
	self._depawn_timer_duration = nil
	self._time_to_despawn = nil
	self._is_nav_gate = false
	self._nav_layer_name = nil
	self._broadphase_radius = nil
	self._visibility_info = {
		fake_light = false,
		lights_enabled = true,
		visible = true
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

DestructibleExtension.setup_from_component = function (self, depawn_timer_duration, despawn_when_destroyed, mass, speed, force_direction_type, start_visible, is_nav_gate, broadphase_radius)
	self._despawn_when_destroyed = despawn_when_destroyed
	self._depawn_timer_duration = depawn_timer_duration
	self._broadphase_radius = broadphase_radius
	self._stages_info = {
		mass = mass,
		speed = speed,
		force_direction_type = force_direction_type,
		start_visible = start_visible
	}
	local unit = self._unit

	if is_nav_gate then
		self:_setup_nav_gate(unit, self._nav_world, self._is_server)
	end

	self._is_nav_gate = is_nav_gate
end

DestructibleExtension.setup_stages = function (self)
	local unit = self._unit
	local health_extension = ScriptUnit.has_extension(unit, "health_system")
	local info = self._stages_info
	self._destruction_info = DestructibleUtilities.setup_stages(unit, info.mass, info.speed, info.force_direction_type, health_extension)

	self:set_visibility(self._stages_info.start_visible)
end

DestructibleExtension.hot_join_sync = function (self, unit, sender)
	self:_sync_server_state(sender)
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
				self._timer_to_despawn = self._depawn_timer_duration
			end

			self._timer_to_despawn = self._timer_to_despawn - dt
			self._timer_to_despawn = math.max(self._timer_to_despawn, 0)

			if self._timer_to_despawn == 0 then
				Managers.state.unit_spawner:mark_for_deletion(unit)
			end
		end
	end
end

DestructibleExtension.set_enabled = function (self, value)
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

	DestructibleUtilities.set_lights_enabled(unit, self._destruction_info, self._visibility_info)
end

DestructibleExtension.add_damage = function (self, damage, hit_actor, attack_direction)
	local unit = self._unit

	if self._is_server then
		local old_stage_index = self._destruction_info.current_stage_index

		DestructibleUtilities.add_damage(unit, self._destruction_info, self._visibility_info, damage, attack_direction)

		local new_stage_index = self._destruction_info.current_stage_index

		if old_stage_index ~= new_stage_index then
			local unit_object_id = Managers.state.unit_spawner:game_object_id(unit)
			local unit_level_id = Managers.state.unit_spawner:level_index(unit)
			local is_level_unit = unit_object_id == nil and unit_level_id ~= nil
			local unit_id = unit_object_id or unit_level_id or NetworkConstants.invalid_level_unit_id
			local visible = true
			local silent_transition = false
			local game_session_manager = Managers.state.game_session

			if unit_id ~= nil then
				game_session_manager:send_rpc_clients("rpc_sync_destructible", unit_id, is_level_unit, new_stage_index, visible, silent_transition)
			end
		end
	end
end

DestructibleExtension._setup_nav_gate = function (self, unit, nav_world, is_server)
	local unit_level_index = Managers.state.unit_spawner:level_index(unit)
	local layer_name = "monster_wall_volume_" .. tostring(unit_level_index)
	local volume_layer_allowed = false
	local volume_points, volume_alt_min, volume_alt_max = NavTagVolumeBox.create_from_unit(nav_world, unit)

	if Unit.has_visibility_group(unit, "NavGate") then
		Unit.set_visibility(unit, "NavGate", false)
	end

	Managers.state.nav_mesh:add_nav_tag_volume(volume_points, volume_alt_min, volume_alt_max, layer_name, volume_layer_allowed)

	self._nav_layer_name = layer_name
end

DestructibleExtension.force_destruct = function (self)
	local damage = DestructibleUtilities.calculate_total_health(self._destruction_info)

	DestructibleUtilities.add_damage(self._unit, self._destruction_info, self._visibility_info, damage)
end

DestructibleExtension.light_controller_setup = function (self, are_lights_enabled, fake_light)
	local visibility_info = self._visibility_info
	visibility_info.lights_enabled = are_lights_enabled
	visibility_info.fake_light = fake_light

	if self._destruction_info then
		local unit = self._unit

		DestructibleUtilities.set_lights_enabled(unit, self._destruction_info, visibility_info)
	end
end

DestructibleExtension.set_lights_enabled = function (self, are_lights_enabled)
	local visibility_info = self._visibility_info
	visibility_info.lights_enabled = are_lights_enabled

	if self._destruction_info then
		local unit = self._unit

		DestructibleUtilities.set_lights_enabled(unit, self._destruction_info, visibility_info)
	end
end

DestructibleExtension.rpc_sync_destructible = function (self, current_stage_index, visible, silent_transition)
	local unit = self._unit
	local settings = self._destruction_info

	if self._visibility_info.visible ~= visible then
		self:set_visibility(visible)
	end

	DestructibleUtilities.set_stage(unit, settings, current_stage_index, self._visibility_info, silent_transition)
end

DestructibleExtension._sync_server_state = function (self, peer_id)
	local unit = self._unit
	local is_level_unit, unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(unit)

	if self._destruction_info then
		local current_stage_index = self._destruction_info.current_stage_index
		local visible = self._visibility_info.visible
		local silent_transition = true

		if unit_id then
			local game_session_manager = Managers.state.game_session

			if peer_id then
				local channel = game_session_manager:peer_to_channel(peer_id)

				RPC.rpc_sync_destructible(channel, unit_id, is_level_unit, current_stage_index, visible, silent_transition)
			else
				game_session_manager:send_rpc_clients("rpc_sync_destructible", unit_id, is_level_unit, current_stage_index, visible, silent_transition)
			end
		end
	end
end

DestructibleExtension.broadphase_radius = function (self)
	return self._broadphase_radius
end

return DestructibleExtension
