-- chunkname: @scripts/extension_systems/locomotion/projectile_unit_locomotion_extension.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local Luggable = require("scripts/utilities/luggable")
local ProjectileIntegration = require("scripts/extension_systems/locomotion/utilities/projectile_integration")
local ProjectileIntegrationData = require("scripts/extension_systems/locomotion/utilities/projectile_integration_data")
local ProjectileLinking = require("scripts/extension_systems/locomotion/utilities/projectile_linking")
local ProjectileLocomotion = require("scripts/extension_systems/locomotion/utilities/projectile_locomotion")
local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local TrueFlightProjectileIntegration = require("scripts/extension_systems/locomotion/utilities/true_flight_projectile_integration")
local buff_proc_events = BuffSettings.proc_events
local locomotion_states = ProjectileLocomotionSettings.states
local moving_locomotion_states = ProjectileLocomotionSettings.moving_states
local MAX_SNAPSHOT_ID = NetworkConstants.max_projectile_locomotion_snapshot_id
local MAX_SYNCHRONIZE_COUNTER = ProjectileLocomotionSettings.MAX_SYNCHRONIZE_COUNTER
local MIN_TIME_IN_ENGINE_PHYSICS_BEFORE_SLEEP = ProjectileLocomotionSettings.MIN_TIME_IN_ENGINE_PHYSICS_BEFORE_SLEEP
local MINIMUM_SPEED_TO_SLEEP = ProjectileLocomotionSettings.MINIMUM_SPEED_TO_SLEEP
local ProjectileUnitLocomotionExtension = class("ProjectileUnitLocomotionExtension")

ProjectileUnitLocomotionExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	local owner_unit = extension_init_data.owner_unit

	self._owner_unit = owner_unit

	if owner_unit then
		self._buff_extension = ScriptUnit.extension(owner_unit, "buff_system")
	end

	self._projectile_unit = unit
	self._world = extension_init_context.world
	self._physics_world = extension_init_context.physics_world

	local item_or_nil = extension_init_data.optional_item

	if item_or_nil then
		self._item = item_or_nil
	end

	self._fx_extension = ScriptUnit.has_extension(unit, "fx_system")

	local projectile_template_name = extension_init_data.projectile_template_name
	local projectile_template = ProjectileTemplates[projectile_template_name]

	self._projectile_template = projectile_template

	local projectile_locomotion_template = projectile_template.locomotion_template

	self._projectile_locomotion_template = projectile_locomotion_template

	local dynamic_actor_id = Unit.find_actor(unit, "dynamic")
	local dynamic_actor

	if dynamic_actor_id then
		dynamic_actor = Unit.actor(unit, dynamic_actor_id)
		self._dynamic_actor_id = dynamic_actor_id
	end

	if projectile_template.always_hidden then
		Unit.set_unit_visibility(unit, false)
	end

	local _, half_extents = Unit.box(unit, true)

	self._radius = math.max(half_extents.x, half_extents.y, half_extents.z)
	self._mass = dynamic_actor and Actor.mass(dynamic_actor) or projectile_locomotion_template.integrator_parameters.mass

	local position = Unit.world_position(unit, 1)
	local rotation = Unit.world_rotation(unit, 1)

	self._last_fixed_t = Managers.time:has_timer("gameplay") and Managers.time:time("gameplay") or 0
	self._position = Vector3Box(position)
	self._rotation = QuaternionBox(rotation)
	self._old_position = Vector3Box(position)
	self._old_rotation = QuaternionBox(rotation)
	self._velocity = Vector3Box()
	self._speed = 0
	self._carrier_unit = nil

	local target_unit_or_nil = extension_init_data.target_unit

	self._target_unit = target_unit_or_nil
	self._target_position = extension_init_data.target_position
	self._current_synchronize_counter = 1
	self._snapshot_id = 1
	self._snapshot_game_object_data = {
		snapshot_id = 0,
		position = {},
		rotation = {},
	}

	local level_id = Managers.state.unit_spawner:level_index(unit)

	if level_id then
		self._game_object_id = level_id
		self._is_level_unit = true
	else
		self._game_object_id = nil
		self._is_level_unit = nil
	end

	local store_data = true

	self._integration_data = ProjectileIntegrationData.allocate_integration_data(store_data)

	local starting_state = extension_init_data.starting_state or locomotion_states.none
	local carrier_unit = extension_init_data.carrier_unit
	local direction = extension_init_data.direction
	local speed = extension_init_data.speed
	local momentum_or_angular_velocity = extension_init_data.momentum_or_angular_velocity

	self._unit_rotation_offset = projectile_template.unit_rotation_offset

	local want_sleep = starting_state == locomotion_states.none or starting_state == locomotion_states.sleep or starting_state == locomotion_states.deployed

	if want_sleep then
		self:switch_to_sleep(position, rotation)
	elseif starting_state == locomotion_states.carried then
		self:switch_to_carried(carrier_unit)
	elseif starting_state == locomotion_states.sticky then
		self:switch_to_sticky(nil, nil, position, rotation)
	elseif starting_state == locomotion_states.socket_lock then
		self:switch_to_socket_lock(position, rotation)
	elseif starting_state == locomotion_states.manual_physics then
		self:switch_to_manual_physics(position, rotation, direction, speed, momentum_or_angular_velocity)
	elseif starting_state == locomotion_states.true_flight then
		self:switch_to_true_flight(position, rotation, direction, speed, momentum_or_angular_velocity, self._target_unit, self._target_position)
	elseif starting_state == locomotion_states.engine_physics then
		local velocity = direction * speed

		self:switch_to_engine_physics(position, rotation, velocity, momentum_or_angular_velocity)
	end

	self._handle_oob_despawning = extension_init_data.handle_oob_despawning
	self._marked_for_deletion = false
	game_object_data.snapshot_id = self._snapshot_id
	game_object_data.position = self._position:unbox()
	game_object_data.rotation = self._rotation:unbox()
	game_object_data.projectile_locomotion_state_id = NetworkLookup.projectile_locomotion_states[self._current_state]

	local gameplay_safe_extents = {
		Vector3.to_elements(Managers.state.out_of_bounds:soft_cap_extents()),
	}

	self._gameplay_safe_extents = gameplay_safe_extents
	self._fixed_time_step = Managers.state.game_session.fixed_time_step

	self:_hide_grenade_pin()
	Managers.state.out_of_bounds:register_soft_oob_unit(unit, self, "_cb_update_soft_oob")
end

ProjectileUnitLocomotionExtension.game_object_initialized = function (self, game_session, game_object_id)
	self._game_object_id = game_object_id
	self._game_session = game_session
	self._is_level_unit = false
end

ProjectileUnitLocomotionExtension.destroy = function (self)
	Managers.state.out_of_bounds:unregister_soft_oob_unit(self._projectile_unit, self)
end

ProjectileUnitLocomotionExtension.mark_for_deletion = function (self)
	if not self._marked_for_deletion then
		Managers.state.out_of_bounds:unregister_soft_oob_unit(self._projectile_unit, self)
		Managers.state.unit_spawner:mark_for_deletion(self._projectile_unit)

		self._marked_for_deletion = true
	end
end

ProjectileUnitLocomotionExtension.is_marked_for_deletion = function (self)
	return self._marked_for_deletion
end

ProjectileUnitLocomotionExtension.pre_update = function (self, unit, dt, t)
	self._send_snapshot_this_frame = false
end

ProjectileUnitLocomotionExtension.fixed_update = function (self, unit, dt, t)
	self._last_fixed_t = t

	self._old_position:store(self._position:unbox())
	self._old_rotation:store(self._rotation:unbox())

	local state = self._current_state

	if state == locomotion_states.engine_physics then
		self:_update_engine_physics(unit)
	elseif state == locomotion_states.manual_physics then
		self:_update_manual_physics(unit, dt, t)
	elseif state == locomotion_states.true_flight then
		self:_update_true_flight(unit, dt, t)
	elseif state == locomotion_states.sticky then
		self:_update_sticky(unit, dt, t)
	elseif state == locomotion_states.socket_lock or state == locomotion_states.sleep or state == locomotion_states.carried then
		-- Nothing
	else
		local position = Unit.world_position(unit, 1)
		local rotation = Unit.world_rotation(unit, 1)

		self._position:store(position)
		self._rotation:store(rotation)
	end

	self:_update_out_of_bounds()

	if self._current_synchronize_counter > MAX_SYNCHRONIZE_COUNTER then
		local snapshot_id = self._snapshot_id % MAX_SNAPSHOT_ID + 1

		self._snapshot_id = snapshot_id
		self._current_synchronize_counter = 1
		self._send_snapshot_this_frame = true
	else
		self._current_synchronize_counter = self._current_synchronize_counter + 1
	end
end

ProjectileUnitLocomotionExtension._update_out_of_bounds = function (self)
	local unit = self._projectile_unit
	local position = self._position:unbox()
	local safe_extents = self._gameplay_safe_extents

	for ii = 1, 3 do
		if math.abs(position[ii]) > safe_extents[ii] then
			self:_cb_update_soft_oob(unit)

			break
		end
	end
end

ProjectileUnitLocomotionExtension._cb_update_soft_oob = function (self, unit)
	self:switch_to_sleep(Vector3.zero(), Quaternion.identity())

	if self._handle_oob_despawning and not self._marked_for_deletion then
		Log.info("ProjectileUnitLocomotionExtension", "%s is out-of-bounds, despawning (%s).", unit, tostring(POSITION_LOOKUP[unit]))
		self:mark_for_deletion()
	end
end

ProjectileUnitLocomotionExtension.update = function (self, unit, dt, t)
	local projectile_unit = self._projectile_unit
	local is_moving = self:is_moving()

	if is_moving then
		local current_position = self._position:unbox()
		local current_rotation = self._rotation:unbox()
		local old_position = self._old_position:unbox()
		local old_rotation = self._old_rotation:unbox()
		local remainder_t = t - self._last_fixed_t
		local t_value = remainder_t / self._fixed_time_step

		t_value = math.min(t_value, 1)

		local simulated_position = Vector3.lerp(old_position, current_position, t_value)
		local simulated_rotation = Quaternion.lerp(old_rotation, current_rotation, t_value)
		local rotation_offset_box = self._unit_rotation_offset

		if rotation_offset_box then
			simulated_rotation = Quaternion.multiply(simulated_rotation, rotation_offset_box:unbox())
		end

		Unit.set_local_position(projectile_unit, 1, simulated_position)
		Unit.set_local_rotation(projectile_unit, 1, simulated_rotation)
	end

	local fx_extension = self._fx_extension

	if fx_extension then
		fx_extension:set_speed_paramater(self:current_speed())
	end
end

ProjectileUnitLocomotionExtension.post_update = function (self, unit, dt, t)
	if self._send_snapshot_this_frame then
		local snapshot_id = self._snapshot_id
		local clamped_position = self._position:unbox()
		local network_min, network_max = NetworkConstants.min_position * 0.95, NetworkConstants.max_position * 0.95

		for i = 1, 3 do
			clamped_position[i] = math.clamp(clamped_position[i], network_min, network_max)
		end

		local snapshot_game_object_data = self._snapshot_game_object_data

		snapshot_game_object_data.snapshot_id = snapshot_id
		snapshot_game_object_data.position = clamped_position
		snapshot_game_object_data.rotation = self._rotation:unbox()
		snapshot_game_object_data.projectile_locomotion_state_id = NetworkLookup.projectile_locomotion_states[self._current_state]

		GameSession.set_game_object_fields(self._game_session, self._game_object_id, snapshot_game_object_data)
	end
end

ProjectileUnitLocomotionExtension.external_move = function (self, position, rotation)
	local projectile_unit = self._projectile_unit
	local dynamic_actor

	if self._dynamic_actor_id then
		dynamic_actor = Unit.actor(projectile_unit, self._dynamic_actor_id)
	end

	if dynamic_actor then
		Actor.teleport_position(dynamic_actor, position)
		Actor.teleport_rotation(dynamic_actor, rotation)
	end

	self._position:store(position)
	self._rotation:store(rotation)
end

ProjectileUnitLocomotionExtension.switch_to_manual_physics = function (self, position, rotation, direction, speed, angular_velocity)
	self:_set_state(locomotion_states.manual_physics)
	self:_switch_to_manual_state_helper(position, rotation, direction, speed, angular_velocity)
end

ProjectileUnitLocomotionExtension.switch_to_true_flight = function (self, position, rotation, direction, speed, angular_velocity, target_unit, target_position)
	self:_set_state(locomotion_states.true_flight)
	self:_switch_to_manual_state_helper(position, rotation, direction, speed, angular_velocity, target_unit, target_position)
end

ProjectileUnitLocomotionExtension._switch_to_manual_state_helper = function (self, position, rotation, direction, speed, angular_velocity, target_unit, target_position)
	local projectile_unit = self._projectile_unit
	local dynamic_actor_id = self._dynamic_actor_id

	if dynamic_actor_id then
		local dynamic_actor = Unit.actor(projectile_unit, dynamic_actor_id)

		ProjectileLocomotion.set_kinematic(projectile_unit, dynamic_actor_id, true)
	end

	local projectile_locomotion_template = self._projectile_locomotion_template
	local mass, radius = ProjectileIntegrationData.mass_radius(projectile_locomotion_template, self)
	local integration_data = self._integration_data

	ProjectileIntegrationData.fill_integration_data(integration_data, self._owner_unit, self._projectile_unit, projectile_locomotion_template, radius, mass, position, rotation, direction, speed, angular_velocity, target_unit, target_position)
	self._position:store(position)
	self._rotation:store(rotation)
end

ProjectileUnitLocomotionExtension._update_manual_physics = function (self, unit, dt, t)
	local dynamic_actor_id = self._dynamic_actor_id
	local dynamic_actor = Unit.actor(unit, dynamic_actor_id)
	local integration_data = self._integration_data

	ProjectileIntegrationData.unbox(integration_data)

	local old_collision_count = integration_data.hit_count
	local is_server = true

	ProjectileIntegration.integrate(self._physics_world, integration_data, dt, t, is_server)

	local integrate_this_frame = integration_data.integrate
	local new_position = integration_data.position
	local new_velocity = integration_data.velocity
	local new_rotation = integration_data.rotation
	local new_collision_count = integration_data.hit_count

	ProjectileIntegrationData.store(self._integration_data)

	local hit_this_frame = old_collision_count < new_collision_count

	if not integrate_this_frame then
		local projectile_template = self._projectile_template
		local deployable_settings = projectile_template.deployable
		local deploy_on_stop = deployable_settings ~= nil

		if deploy_on_stop then
			self:switch_to_deployed(new_position, new_rotation)
			deployable_settings.deploy_func(self._world, self._physics_world, unit)
		else
			local angular_momentum = integration_data.angular_velocity / integration_data.inertia

			self:switch_to_engine_physics(new_position, new_rotation, new_velocity, angular_momentum)
		end
	else
		if hit_this_frame then
			Unit.flow_event(unit, "lua_manual_physics_collision")
		end

		self:_apply_changes(locomotion_states.manual_physics, new_position, new_rotation, new_velocity, Vector3.zero(), nil, nil, nil)
	end
end

ProjectileUnitLocomotionExtension._update_true_flight = function (self, unit, dt, t)
	local dynamic_actor_id = self._dynamic_actor_id

	if dynamic_actor_id then
		local dynamic_actor = Unit.actor(unit, dynamic_actor_id)
	end

	local integration_data = self._integration_data

	ProjectileIntegrationData.unbox(integration_data)

	local old_collision_count = integration_data.hit_count
	local integrate_this_frame = integration_data.integrate

	TrueFlightProjectileIntegration.integrate(self._physics_world, integration_data, dt, t, true)

	local new_position = integration_data.position
	local new_velocity = integration_data.velocity
	local new_rotation = integration_data.rotation
	local new_target_unit = integration_data.target_unit
	local new_target_hit_zone = integration_data.target_hit_zone
	local new_target_position = integration_data.target_position

	ProjectileIntegrationData.store(integration_data)

	if integrate_this_frame then
		local new_collision_count = integration_data.hit_count

		if old_collision_count < new_collision_count then
			Unit.flow_event(unit, "lua_manual_physics_collision")
		end

		self:_apply_changes(locomotion_states.manual_physics, new_position, new_rotation, new_velocity, Vector3.zero(), new_target_position, new_target_unit, new_target_hit_zone)
	else
		local projectile_template = self._projectile_template
		local deployable_settings = projectile_template.deployable
		local deploy_on_stop = deployable_settings ~= nil

		if deploy_on_stop then
			self:switch_to_deployed(new_position, new_rotation)
			deployable_settings.deploy_func(self._world, self._physics_world, unit)
		else
			self:switch_to_sleep(new_position, new_rotation)
		end
	end

	local time_without_target = integration_data.time_without_target

	if time_without_target >= 5 and not self._marked_for_deletion then
		Managers.state.unit_spawner:mark_for_deletion(unit)

		self._marked_for_deletion = true
	end
end

ProjectileUnitLocomotionExtension.switch_to_engine_physics = function (self, position, rotation, velocity, angular_momentum)
	self:_set_state(locomotion_states.engine_physics)

	local projectile_unit = self._projectile_unit
	local dynamic_actor_id = self._dynamic_actor_id
	local dynamic_actor = Unit.actor(projectile_unit, dynamic_actor_id)

	ProjectileLocomotion.set_kinematic(projectile_unit, dynamic_actor_id, false)

	position = position or Unit.world_position(projectile_unit, 1)
	rotation = rotation or Unit.world_rotation(projectile_unit, 1)
	velocity = velocity or Vector3.zero()
	angular_momentum = (angular_momentum or Vector3.zero()) * 0.01

	self:_apply_changes(locomotion_states.engine_physics, position, rotation, velocity, angular_momentum, nil, nil, nil)

	self._time_starting_in_engine = Managers.time:time("gameplay")

	self._old_position:store(position)
	self._old_rotation:store(rotation)
end

ProjectileUnitLocomotionExtension._update_engine_physics = function (self, unit)
	local dynamic_actor_id = self._dynamic_actor_id
	local dynamic_actor = Unit.actor(unit, dynamic_actor_id)
	local position = Actor.position(dynamic_actor)
	local rotation = Actor.rotation(dynamic_actor)
	local velocity = Actor.velocity(dynamic_actor)
	local start_time = self._time_starting_in_engine or 0
	local current_time = Managers.time:time("gameplay")
	local time_in_engine = current_time - start_time

	if Vector3.length(velocity) <= MINIMUM_SPEED_TO_SLEEP and time_in_engine > MIN_TIME_IN_ENGINE_PHYSICS_BEFORE_SLEEP then
		self:switch_to_sleep(position, rotation)
	else
		self._position:store(position)
		self._rotation:store(rotation)
		self._velocity:store(velocity)

		self._speed = Vector3.length(velocity)
	end
end

ProjectileUnitLocomotionExtension.switch_to_sticky = function (self, sticking_to_unit, sticking_to_actor, world_position, world_rotation, hit_normal, hit_direction)
	self:_set_state(locomotion_states.sticky)
	ProjectileLocomotion.set_kinematic(self._projectile_unit, self._dynamic_actor_id, true)

	local zero_vector = Vector3.zero()

	self:_apply_changes(locomotion_states.sticky, world_position, world_rotation, zero_vector, zero_vector, nil, nil, nil)

	local sticking_to_actor_index = Actor.node(sticking_to_actor)
	local local_position, local_rotation = ProjectileLinking.link_position_and_rotation(sticking_to_unit, sticking_to_actor_index, world_position, world_rotation, hit_normal, hit_direction)

	self._sticking_to_unit = sticking_to_unit
	self._sticking_to_actor = sticking_to_actor
	self._sticking_to_actor_index = sticking_to_actor_index

	local world = self._world
	local projectile_unit = self._projectile_unit

	World.link_unit(world, projectile_unit, 1, sticking_to_unit, sticking_to_actor_index)
	Unit.set_local_position(projectile_unit, 1, local_position)
	Unit.set_local_rotation(projectile_unit, 1, local_rotation)
	World.update_unit(world, projectile_unit)

	local owner_buff_extension = self._buff_extension

	if owner_buff_extension then
		local param_table = owner_buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.owner_unit = self._owner_unit
			param_table.target_unit = sticking_to_unit
			param_table.projectile_unit = self._projectile_unit
			param_table.projectile_template_name = self._projectile_template.name

			owner_buff_extension:add_proc_event(buff_proc_events.on_projectile_stick, param_table)
		end
	end
end

ProjectileUnitLocomotionExtension._update_sticky = function (self, unit, dt, t)
	local sticking_to_unit = self._sticking_to_unit

	if sticking_to_unit and not ALIVE[sticking_to_unit] then
		self:unstick_from_unit()

		local unit_id = Managers.state.unit_spawner:game_object_id(unit)

		Log.warning("ProjectileUnitLocomotionExtension", "Unit %s was sticking to another unit that was not alive was not released properly.", unit_id)

		return
	end

	local projectile_unit = self._projectile_unit
	local world_position = Unit.world_position(projectile_unit, 1)
	local world_rotation = Unit.world_rotation(projectile_unit, 1)

	self:_apply_changes(locomotion_states.sticky, world_position, world_rotation, Vector3.zero(), Vector3.zero(), nil, nil, nil)
end

ProjectileUnitLocomotionExtension.unstick_from_unit = function (self)
	local sticking_to_unit = self._sticking_to_unit

	if sticking_to_unit then
		local world = self._world
		local projectile_unit = self._projectile_unit

		World.unlink_unit(world, projectile_unit)
	end

	self._sticking_to_unit = nil
	self._sticking_to_actor = nil
	self._sticking_to_actor_index = nil

	self:switch_to_engine_physics()
end

ProjectileUnitLocomotionExtension.switch_to_socket_lock = function (self, position, rotation)
	self:_set_state(locomotion_states.socket_lock)

	local projectile_unit = self._projectile_unit

	Unit.set_local_position(projectile_unit, 1, position)
	Unit.set_local_rotation(projectile_unit, 1, rotation)
	self:_apply_changes(locomotion_states.socket_lock, position, rotation, Vector3.zero(), Vector3.zero(), nil, nil, nil)
end

ProjectileUnitLocomotionExtension.switch_to_carried = function (self, carrier_unit)
	self._carrier_unit = carrier_unit

	local projectile_unit = self._projectile_unit

	Luggable.link_to_player_unit(self._world, carrier_unit, projectile_unit, self._item)
	self:_set_state(locomotion_states.carried)

	local position = Unit.local_position(projectile_unit, 1)
	local rotation = Unit.local_rotation(projectile_unit, 1)

	self:_apply_changes(locomotion_states.carried, position, rotation, Vector3.zero(), Vector3.zero(), nil, nil, nil)

	local game_session = self._game_session
	local game_object_id = self._game_object_id
	local carrier_unit_id = Managers.state.unit_spawner:game_object_id(carrier_unit) or NetworkConstants.invalid_game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "carrier_unit_id", carrier_unit_id)
end

ProjectileUnitLocomotionExtension.switch_to_sleep = function (self, position, rotation)
	local projectile_unit = self._projectile_unit

	position = position or Unit.world_position(projectile_unit, 1)
	rotation = rotation or Unit.world_rotation(projectile_unit, 1)

	self:_set_state(locomotion_states.sleep)
	ProjectileLocomotion.set_kinematic(self._projectile_unit, self._dynamic_actor_id, false)
	self:_apply_changes(locomotion_states.sleep, position, rotation, Vector3.zero(), Vector3.zero(), nil, nil, nil)
end

ProjectileUnitLocomotionExtension.switch_to_deployed = function (self, position, rotation)
	self:_set_state(locomotion_states.deployed)
	self:_apply_changes(locomotion_states.deployed, position, rotation, Vector3.zero(), Vector3.zero(), nil, nil, nil)
end

ProjectileUnitLocomotionExtension._set_state = function (self, new_state)
	local old_state = self._current_state

	if new_state ~= old_state then
		local projectile_unit = self._projectile_unit

		if old_state == locomotion_states.carried then
			Luggable.unlink_from_player_unit(self._world, projectile_unit)

			local world_position = Unit.world_position(projectile_unit, 1)
			local world_rotation = Unit.world_rotation(projectile_unit, 1)

			self._position:store(world_position)
			self._rotation:store(world_rotation)
		end

		if new_state == locomotion_states.carried then
			ProjectileLocomotion.deactivate_physics(projectile_unit, self._dynamic_actor_id)
		elseif new_state == locomotion_states.socket_lock then
			ProjectileLocomotion.deactivate_physics(projectile_unit, self._dynamic_actor_id)
		elseif new_state == locomotion_states.deployed then
			ProjectileLocomotion.deactivate_physics(projectile_unit, self._dynamic_actor_id)
		elseif old_state == locomotion_states.carried then
			ProjectileLocomotion.activate_physics(projectile_unit)
		end

		self._current_state = new_state
	end
end

ProjectileUnitLocomotionExtension._apply_changes = function (self, state, position, rotation, velocity, angular_momentum, target_position, target_unit, target_hit_zone)
	local projectile_unit = self._projectile_unit
	local dynamic_actor

	if self._dynamic_actor_id then
		dynamic_actor = Unit.actor(projectile_unit, self._dynamic_actor_id)
	end

	if dynamic_actor then
		Actor.teleport_position(dynamic_actor, position)
		Actor.teleport_rotation(dynamic_actor, rotation)

		if state == locomotion_states.engine_physics then
			Actor.set_velocity(dynamic_actor, velocity)
			Actor.set_angular_velocity(dynamic_actor, angular_momentum)
		elseif state == locomotion_states.sleep then
			Actor.put_to_sleep(dynamic_actor)
		end
	end

	self._position:store(position)
	self._rotation:store(rotation)
	self._velocity:store(velocity)

	self._speed = Vector3.length(velocity)
	self._target_unit = target_unit
	self._target_hit_zone = target_hit_zone
	self._target_position = target_position
end

ProjectileUnitLocomotionExtension._hide_grenade_pin = function (self)
	local projectile_unit = self._projectile_unit
	local has_visibility_group = Unit.has_visibility_group(projectile_unit, "pin")

	if has_visibility_group then
		Unit.set_visibility(projectile_unit, "pin", false)
	end
end

ProjectileUnitLocomotionExtension.owner_unit = function (self)
	return self._owner_unit
end

ProjectileUnitLocomotionExtension.radius = function (self)
	return self._radius
end

ProjectileUnitLocomotionExtension.mass = function (self)
	return self._mass
end

ProjectileUnitLocomotionExtension.is_moving = function (self)
	return moving_locomotion_states[self._current_state]
end

ProjectileUnitLocomotionExtension.previous_and_current_positions = function (self)
	if self:is_moving() and self._current_state ~= locomotion_states.engine_physics then
		local integration_data = self._integration_data

		return integration_data.previous_position_box:unbox(), integration_data.position_box:unbox()
	end

	local position = self._position:unbox()

	return position, position
end

ProjectileUnitLocomotionExtension.current_rotation_and_direction = function (self)
	local integration_data = self._integration_data
	local velocity = integration_data.velocity_box:unbox()
	local direction = Vector3.normalize(velocity)
	local rotation = integration_data.rotation_box:unbox()

	return rotation, direction
end

ProjectileUnitLocomotionExtension.current_speed = function (self)
	local state = self._current_state

	if state == locomotion_states.sticky or state == locomotion_states.socket_lock or state == locomotion_states.sleep or state == locomotion_states.carried then
		return 0
	end

	return self._speed
end

ProjectileUnitLocomotionExtension.sticking_to_unit = function (self)
	local sticking_to_unit = self._sticking_to_unit
	local sticking_to_actor_index = self._sticking_to_actor_index or 1
	local sticking_to_actor = self._sticking_to_actor

	return sticking_to_unit, sticking_to_actor_index, sticking_to_actor
end

ProjectileUnitLocomotionExtension.current_state = function (self)
	return self._current_state
end

ProjectileUnitLocomotionExtension.locomotion_template = function (self)
	return self._projectile_locomotion_template
end

return ProjectileUnitLocomotionExtension
