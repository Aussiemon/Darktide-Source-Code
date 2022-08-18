local Action = require("scripts/utilities/weapon/action")
local AimProjectile = require("scripts/utilities/aim_projectile")
local DefaultGameParameters = require("scripts/foundation/utilities/parameters/default_game_parameters")
local ProjectileIntegrationData = require("scripts/extension_systems/locomotion/utilities/projectile_integration_data")
local ProjectileLocomotion = require("scripts/extension_systems/locomotion/utilities/projectile_locomotion")
local ProjectileLocomotionTemplates = require("scripts/settings/projectile_locomotion/projectile_locomotion_templates")
local ProjectileTrajectory = require("scripts/utilities/projectile_trajectory")
local AimProjectileEffects = class("AimProjectileEffects")
local SPAWN_POS = Vector3Box(400, 400, 400)

AimProjectileEffects.init = function (self, context, slot, weapon_template, fx_sources)
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._physics_world = context.physics_world
	self._is_local_unit = context.is_local_unit
	self._first_person_unit = context.first_person_unit
	self._weapon_template = weapon_template
	self._weapon_actions = weapon_template.actions
	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._action_aim_projectile_component = unit_data_extension:read_component("action_aim_projectile")
	self._alternate_fire_component = unit_data_extension:read_component("alternate_fire")
	self._integration_data = ProjectileIntegrationData.allocate_integration_data()
end

AimProjectileEffects._trajectory_settings_from_aim_action = function (self, action_settings, trajectory_settings)
	local _action_aim_projectile_component = self._action_aim_projectile_component
	local _weapon_action_component = self._weapon_action_component

	ProjectileTrajectory.trajectory_settings_from_aim_component(action_settings, _action_aim_projectile_component, _weapon_action_component, trajectory_settings)

	local weapon_template = self._weapon_template
	local projectile_locomotion_template = nil
	local locomotion_template_name = action_settings and action_settings.projectile_locomotion_template

	if locomotion_template_name then
		projectile_locomotion_template = ProjectileLocomotionTemplates[locomotion_template_name]
	elseif weapon_template.projectile_template then
		local projectile_templates = weapon_template.projectile_template
		projectile_locomotion_template = projectile_templates.locomotion_template
	end

	trajectory_settings.projectile_locomotion_template = projectile_locomotion_template
	local mass, radius = ProjectileIntegrationData.mass_radius(projectile_locomotion_template, nil)
	trajectory_settings.mass = mass
	trajectory_settings.radius = radius
end

local _trajectory_settings = {}

AimProjectileEffects._trajectory_settings = function (self, t)
	table.clear(_trajectory_settings)

	local weapon_action_component = self._weapon_action_component
	local action_settings = Action.current_action_settings_from_component(weapon_action_component, self._weapon_actions)
	local is_aiming = action_settings and action_settings.kind == "aim_projectile"
	local action_start_time = weapon_action_component.start_t
	local arc_draw_delay = action_settings and action_settings.arc_draw_delay or 0
	local time_in_action = t - action_start_time
	local is_timing_right = arc_draw_delay < time_in_action

	if not is_aiming or not is_timing_right then
		return false, nil
	end

	self:_trajectory_settings_from_aim_action(action_settings, _trajectory_settings)

	return true, _trajectory_settings
end

AimProjectileEffects.post_update = function (self, unit, dt, t)
	if not self._is_local_unit then
		return
	end

	Profiler.start("AimProjectileEffects_update")

	local draw_trajectory, trajectory_settings = self:_trajectory_settings(t)

	if draw_trajectory then
		-- Nothing
	elseif self:_trajectory_vfx_is_active() then
		self:_stop_trajectory_vfx()
	end

	Profiler.stop("AimProjectileEffects_update")
end

AimProjectileEffects._update_fx = function (self, trajectory_settings)
	self:_update_trajectory_fx(trajectory_settings)
end

AimProjectileEffects._update_trajectory_fx = function (self, trajectory_settings)
	local projectile_locomotion_template = trajectory_settings.projectile_locomotion_template

	if not projectile_locomotion_template and projectile_locomotion_template.vfx then
		return
	end

	local rotation = trajectory_settings.rotation
	local speed = trajectory_settings.speed
	local momentum = trajectory_settings.momentum
	local radius = trajectory_settings.radius
	local mass = trajectory_settings.mass
	local throw_type = trajectory_settings.throw_type
	local stop_on_impact = trajectory_settings.stop_on_impact
	local first_person_unit = self._first_person_unit
	local look_position = Unit.world_position(first_person_unit, 1)
	local look_rotation = Unit.world_rotation(first_person_unit, 1)
	local time_in_action = trajectory_settings.time_in_action
	local aim_parameters = AimProjectile.aim_parameters(look_position, rotation, look_rotation, projectile_locomotion_template, throw_type, time_in_action)
	local integration_data = self._integration_data

	ProjectileIntegrationData.fill_integration_data(integration_data, self._player_unit, nil, projectile_locomotion_template, radius, mass, aim_parameters.position, rotation, aim_parameters.direction, speed, momentum)

	local throw_config = projectile_locomotion_template.throw_parameters[throw_type]
	local max_iterations = throw_config.aim_max_iterations

	if not self:_trajectory_vfx_is_active() then
		self:_start_trajectory_vfx(projectile_locomotion_template)
	end

	local aim_data, number_of_iterations_done = self:_get_trajactory_data(integration_data, max_iterations, stop_on_impact)
	local local_start_offset = trajectory_settings.start_offset
	local arc_offset = Vector3.zero()

	if local_start_offset then
		local first_position = aim_parameters.position
		local start_offset = Quaternion.rotate(look_rotation, local_start_offset)
		local gun_posistion = look_position + start_offset
		arc_offset = gun_posistion - first_position
	end

	local max_positions = self._trajectory_vfx.max_position_indices
	local position_distance = self._trajectory_vfx.particle_distance
	local distributed_positions, total_distance = self:_get_points_distrubuted_by_distance(aim_parameters.position, aim_data, position_distance, max_positions)

	if total_distance > 0 then
		for i = 1, max_positions do
			local data = distributed_positions[i]
			local position, _ = self:_calculate_arc_position(data, total_distance, arc_offset)

			self:_set_particle_position(i, position)
		end
	end
end

AimProjectileEffects._calculate_arc_position = function (self, position_data, total_distance, arc_offset)
	local new_position = position_data.position
	local distance = position_data.distance
	local lerp = 1 - distance / total_distance
	lerp = lerp * lerp
	local final_offset = arc_offset * lerp
	local arc_position = new_position + final_offset

	return arc_position, final_offset
end

local _aim_data = {}

AimProjectileEffects._get_trajactory_data = function (self, integration_data, max_iterations, stop_on_impact)
	table.clear(_aim_data)

	local number_of_iterations_done = 0
	local fixed_frame_time = DefaultGameParameters.fixed_time_step

	for i = 1, max_iterations do
		local old_position = integration_data.position:unbox()

		ProjectileLocomotion.integrate(self._physics_world, integration_data, fixed_frame_time)

		local new_position = integration_data.position:unbox()
		local has_hit = integration_data.has_hit
		_aim_data[#_aim_data + 1] = {
			old_position = old_position,
			new_position = new_position,
			has_hit = has_hit
		}
		number_of_iterations_done = i
		local continue = integration_data.integrate

		if not continue then
			break
		end

		if has_hit and stop_on_impact then
			break
		end
	end

	return _aim_data, number_of_iterations_done
end

local position_table = {}

AimProjectileEffects._get_points_distrubuted_by_distance = function (self, start_position, aim_data, distance_between_dots, number_of_dots)
	table.clear(position_table)

	local current_position = start_position
	local next_point = aim_data[1].new_position
	local current_index = 1
	local number_of_aim_data = #aim_data
	local start_delta = next_point - start_position
	local current_drection = Vector3.normalize(start_delta)
	local current_length = Vector3.length(start_delta)
	local total_distance = 0

	for i = 1, number_of_dots do
		position_table[i] = {
			position = current_position,
			distance = total_distance
		}
		local current_segment_length_left = distance_between_dots

		while current_segment_length_left > 0 do
			if distance_between_dots < current_length then
				current_position = current_position + current_drection * current_segment_length_left
				current_length = current_length - current_segment_length_left
				current_segment_length_left = 0
				total_distance = total_distance + current_segment_length_left
			else
				current_segment_length_left = current_segment_length_left - current_length
				local old_point = next_point
				current_index = current_index + 1

				if number_of_aim_data < current_index then
					current_position = next_point

					break
				end

				total_distance = total_distance + current_length
				next_point = aim_data[current_index].new_position
				local new_delta = next_point - old_point
				current_drection = Vector3.normalize(new_delta)
				current_length = Vector3.length(new_delta)
				current_position = old_point
			end
		end
	end

	return position_table, total_distance
end

AimProjectileEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

AimProjectileEffects.wield = function (self)
	return
end

AimProjectileEffects.unwield = function (self)
	self:_stop_trajectory_vfx()
end

AimProjectileEffects.destroy = function (self)
	self:_stop_trajectory_vfx()
end

AimProjectileEffects._start_trajectory_vfx = function (self, locomotion_template)
	local vfx_config = locomotion_template.vfx
	local trajectory_vfx_config = vfx_config.trajectory
	local effect_name = trajectory_vfx_config.effect_name
	local particle_id = World.create_particles(self._world, effect_name, SPAWN_POS:unbox())
	self._trajectory_vfx = {
		effect_name = effect_name,
		particle_id = particle_id,
		position_prefix = trajectory_vfx_config.position_prefix,
		max_position_indices = trajectory_vfx_config.max_position_indices,
		particle_distance = trajectory_vfx_config.particle_distance
	}
end

AimProjectileEffects._stop_trajectory_vfx = function (self)
	if self._trajectory_vfx then
		local particle_id = self._trajectory_vfx.particle_id

		World.destroy_particles(self._world, particle_id)

		self._trajectory_vfx = nil
	end
end

AimProjectileEffects._trajectory_vfx_is_active = function (self)
	return self._trajectory_vfx ~= nil
end

AimProjectileEffects._set_particle_position = function (self, position_index, new_position)
	local vfx = self._trajectory_vfx
	local position_prefix = vfx.position_prefix
	local effect_name = vfx.effect_name
	local particle_id = vfx.particle_id
	local position_particle_name = string.format("%s%d", position_prefix, position_index)
	local variable_index = World.find_particles_variable(self._world, effect_name, position_particle_name)

	World.set_particles_variable(self._world, particle_id, variable_index, new_position)
end

return AimProjectileEffects
