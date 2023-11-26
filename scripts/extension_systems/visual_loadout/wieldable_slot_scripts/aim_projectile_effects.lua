-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/aim_projectile_effects.lua

local Action = require("scripts/utilities/weapon/action")
local AimProjectile = require("scripts/utilities/aim_projectile")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local ProjectileIntegration = require("scripts/extension_systems/locomotion/utilities/projectile_integration")
local ProjectileIntegrationData = require("scripts/extension_systems/locomotion/utilities/projectile_integration_data")
local ProjectileLocomotionTemplates = require("scripts/settings/projectile_locomotion/projectile_locomotion_templates")
local ProjectileTrajectory = require("scripts/utilities/projectile_trajectory")
local Recoil = require("scripts/utilities/recoil")
local Sway = require("scripts/utilities/sway")
local AimProjectileEffects = class("AimProjectileEffects")
local MAX_NUMBER_OF_SPLINE = 2
local MAX_INTEGRATION_STEPS = 100
local MAX_POSITION_STEPS = 30
local AIM_TRAJECTORY_EFFECT_DEFAULT_MATERIAL = "content/fx/materials/master/trajectory"
local AIM_TRAJECTORY_EFFECT_DEFAULT_RADIUS = 0.03
local STUNNED_RECOVERY_LERP_TIME = 0.6
local _calculate_arc_position

AimProjectileEffects.init = function (self, context, slot, weapon_template, fx_sources)
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._physics_world = context.physics_world
	self._is_local_unit = context.is_local_unit

	if not self._is_local_unit then
		return
	end

	self._first_person_unit = context.first_person_unit
	self._weapon_template = weapon_template
	self._weapon_actions = weapon_template.actions
	self._fx_sources = fx_sources

	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._action_aim_projectile_component = unit_data_extension:read_component("action_aim_projectile")
	self._alternate_fire_component = unit_data_extension:read_component("alternate_fire")
	self._character_state_component = unit_data_extension:read_component("character_state")
	self._recoil_component = unit_data_extension:read_component("recoil")
	self._movement_state_component = unit_data_extension:read_component("movement_state")
	self._sway_component = unit_data_extension:read_component("sway")
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._weapon_extension = ScriptUnit.extension(owner_unit, "weapon_system")
	self._integration_data = ProjectileIntegrationData.allocate_integration_data()
	self._last_non_stunned_offset_box = Vector3Box()
	self._out_of_stunned_state_time = 1
	self._aim_data = {}

	for ii = 1, MAX_INTEGRATION_STEPS do
		self._aim_data[ii] = {}
	end

	self._position_data = {}

	for ii = 1, MAX_POSITION_STEPS do
		self._position_data[ii] = {}
	end

	self._splines = {}
end

AimProjectileEffects._trajectory_settings_from_aim_action = function (self, action_settings, trajectory_settings)
	local action_aim_projectile_component = self._action_aim_projectile_component
	local weapon_action_component = self._weapon_action_component

	ProjectileTrajectory.trajectory_settings_from_aim_component(action_settings, action_aim_projectile_component, weapon_action_component, trajectory_settings)

	local weapon_template = self._weapon_template
	local projectile_locomotion_template
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
	local is_throwing = action_settings and action_settings.kind == "throw_grenade"
	local action_start_time = weapon_action_component.start_t
	local arc_draw_delay = action_settings and action_settings.arc_draw_delay or 0
	local time_in_action = t - action_start_time
	local draw_aim_arc = is_aiming and arc_draw_delay < time_in_action
	local spawn_at_time = action_settings and action_settings.spawn_at_time or 0
	local draw_throw_arc = is_throwing and time_in_action < spawn_at_time

	if not draw_aim_arc and not draw_throw_arc then
		return false, nil
	end

	self:_trajectory_settings_from_aim_action(action_settings, _trajectory_settings)

	local weapon_templates = self._weapon_template
	local projectile_template = weapon_templates.projectile_template

	if projectile_template then
		local impact_settings = projectile_template.damage.impact
		local destroy_on_impact = impact_settings and impact_settings.delete_on_impact or impact_settings.explosion_template

		_trajectory_settings.stop_on_impact = destroy_on_impact
	end

	return true, _trajectory_settings
end

AimProjectileEffects.update_unit_position = function (self, unit, dt, t)
	if not self._is_local_unit then
		return
	end

	local draw_trajectory, trajectory_settings = self:_trajectory_settings(t)

	if draw_trajectory then
		self:_update_trajectory(trajectory_settings, dt, t)
	elseif self:_trajectory_is_active_spline() then
		self:_stop_trajectory_spline()
	end
end

AimProjectileEffects._update_trajectory = function (self, trajectory_settings, dt, t)
	if not self:_can_update_trajectory_spline(trajectory_settings) then
		return
	end

	local projectile_locomotion_template = trajectory_settings.projectile_locomotion_template
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
	local start_position = look_position
	local start_rotation = look_rotation

	if trajectory_settings.use_sway_and_recoil then
		local weapon_extension = self._weapon_extension
		local recoil_template = weapon_extension:recoil_template()
		local sway_template = weapon_extension:sway_template()
		local movement_state_component = self._movement_state_component
		local recoil_component = self._recoil_component
		local sway_component = self._sway_component

		start_rotation = Recoil.apply_weapon_recoil_rotation(recoil_template, recoil_component, movement_state_component, start_rotation)
		start_rotation = Sway.apply_sway_rotation(sway_template, sway_component, movement_state_component, start_rotation)
	end

	local aim_parameters = AimProjectile.aim_parameters(start_position, rotation, start_rotation, projectile_locomotion_template, throw_type, time_in_action)
	local integration_data = self._integration_data

	ProjectileIntegrationData.fill_integration_data(integration_data, self._player_unit, nil, projectile_locomotion_template, radius, mass, aim_parameters.position, rotation, aim_parameters.direction, speed, momentum)

	local throw_config = projectile_locomotion_template.trajectory_parameters[throw_type]
	local max_iterations = throw_config.aim_max_iterations
	local time_step_multiplier = throw_config.aim_time_step_multiplier or 1
	local max_number_of_bounces = math.clamp(throw_config.aim_max_number_of_bounces or MAX_NUMBER_OF_SPLINE, 1, MAX_NUMBER_OF_SPLINE)

	if not self:_trajectory_is_active_spline() then
		self:_start_trajectory_spline(trajectory_settings)
	end

	local aim_data, number_of_iterations_done, total_distance, arc_distances = self:_get_trajectory_data(integration_data, max_iterations, stop_on_impact, time_step_multiplier, max_number_of_bounces)
	local arc_offset = Vector3.zero()
	local fx_source_name = trajectory_settings.arc_vfx_spawner_name
	local fx_sources = self._fx_sources
	local fx_spawner_name = fx_sources[fx_source_name]
	local local_start_offset = trajectory_settings.start_offset
	local is_stunned = PlayerUnitStatus.is_stunned(self._character_state_component)

	if fx_spawner_name then
		if is_stunned then
			arc_offset = self._last_non_stunned_offset_box:unbox()
			self._out_of_stunned_state_time = 0
		else
			local fx_extension = self._fx_extension
			local fx_pose = fx_extension:vfx_spawner_pose(fx_spawner_name)
			local fx_position = Matrix4x4.translation(fx_pose)
			local aim_position = aim_parameters.position
			local offset = fx_position - aim_position
			local out_of_stunned_state_time = math.clamp01(self._out_of_stunned_state_time + dt / STUNNED_RECOVERY_LERP_TIME)

			self._out_of_stunned_state_time = out_of_stunned_state_time

			if out_of_stunned_state_time >= 0.99 then
				self._last_non_stunned_offset_box:store(offset)
			else
				local last_safe_offset = self._last_non_stunned_offset_box:unbox()

				offset = Vector3.lerp(last_safe_offset, offset, out_of_stunned_state_time)
			end

			arc_offset = offset
		end
	elseif local_start_offset then
		local first_position = aim_parameters.position
		local start_offset = Quaternion.rotate(look_rotation, local_start_offset)
		local gun_posistion = start_position + start_offset
		local fixed_offset = gun_posistion - first_position

		arc_offset = fixed_offset
	end

	self:_set_trajectory_positions_spline(aim_data, number_of_iterations_done, arc_offset, total_distance, arc_distances, dt)
end

AimProjectileEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

AimProjectileEffects.wield = function (self)
	return
end

AimProjectileEffects.unwield = function (self)
	self:_stop_trajectory_spline()
end

AimProjectileEffects.destroy = function (self)
	self:_stop_trajectory_spline()
end

local function _add_aim_data(aim_data, new_position, old_position, has_hit, distance_in_arc, distance_traveled)
	aim_data.old_position = old_position
	aim_data.new_position = new_position
	aim_data.has_hit = has_hit

	local delta_distance = Vector3.distance(old_position, new_position)

	distance_in_arc = distance_in_arc + delta_distance
	aim_data.distance_in_arc = distance_in_arc
	distance_traveled = distance_traveled + delta_distance
	aim_data.distance = distance_traveled
	aim_data.delta_distance = delta_distance

	return distance_in_arc, distance_traveled
end

local _arc_distances = {}

AimProjectileEffects._get_trajectory_data = function (self, integration_data, max_iterations, stop_on_impact, time_step_multiplier, max_number_of_bounces)
	max_iterations = math.min(max_iterations, MAX_INTEGRATION_STEPS)

	local fixed_frame_time = Managers.state.game_session.fixed_time_step
	local number_of_iterations_done = 0
	local number_of_bounces = 0
	local distance_traveled = 0
	local distance_in_arc = 0
	local is_server = false
	local fake_t = 0

	table.clear(_arc_distances)

	local current_aim_data_index = 1
	local aim_data = self._aim_data
	local num_iterations_to_do = max_iterations - 2 * MAX_NUMBER_OF_SPLINE

	for ii = 1, num_iterations_to_do do
		local old_position = integration_data.position

		ProjectileIntegration.integrate(self._physics_world, integration_data, fixed_frame_time, fake_t, is_server, time_step_multiplier, true)

		fake_t = fake_t + fixed_frame_time * time_step_multiplier

		local new_position = integration_data.position
		local has_hit = integration_data.has_hit
		local pre_bounce_arc_length = distance_in_arc

		if has_hit then
			local hit_position = integration_data.last_hit_position

			pre_bounce_arc_length, distance_traveled = _add_aim_data(aim_data[current_aim_data_index], hit_position, old_position, true, distance_in_arc, distance_traveled)
			distance_in_arc = 0
			distance_in_arc, distance_traveled = _add_aim_data(aim_data[current_aim_data_index + 1], new_position, hit_position, false, distance_in_arc, distance_traveled)
			current_aim_data_index = current_aim_data_index + 2
			number_of_iterations_done = number_of_iterations_done + 2
		else
			distance_in_arc, distance_traveled = _add_aim_data(aim_data[current_aim_data_index], new_position, old_position, false, distance_in_arc, distance_traveled)
			current_aim_data_index = current_aim_data_index + 1
			number_of_iterations_done = number_of_iterations_done + 1
		end

		_arc_distances[number_of_bounces + 1] = pre_bounce_arc_length
		number_of_bounces = number_of_bounces + (has_hit and 1 or 0)

		local continue = integration_data.integrate

		if not continue then
			break
		end

		local hit_unit = integration_data.last_hit_unit
		local hit_minion = hit_unit and HEALTH_ALIVE[hit_unit]

		if hit_minion or has_hit and (stop_on_impact or max_number_of_bounces <= number_of_bounces) then
			break
		end

		if ii == max_iterations then
			break
		end
	end

	return self._aim_data, number_of_iterations_done, distance_traveled, _arc_distances
end

AimProjectileEffects._can_update_trajectory_spline = function (self, trajectory_settings)
	return true
end

AimProjectileEffects._start_trajectory_spline = function (self, trajectory_settings)
	local locomotion_template = trajectory_settings.projectile_locomotion_template
	local vfx_config = locomotion_template.vfx
	local trajectory_vfx_config = vfx_config.trajectory
	local material = trajectory_vfx_config.material_name or AIM_TRAJECTORY_EFFECT_DEFAULT_MATERIAL
	local radius = trajectory_vfx_config.radius or AIM_TRAJECTORY_EFFECT_DEFAULT_RADIUS

	for ii = 1, MAX_NUMBER_OF_SPLINE do
		self._splines[ii] = World.create_spline_object_drawer(self._world, material, radius, Color.white())
	end
end

AimProjectileEffects._stop_trajectory_spline = function (self)
	if self._splines and #self._splines > 0 then
		for ii = 1, MAX_NUMBER_OF_SPLINE do
			World.destroy_spline_object_drawer(self._world, self._splines[ii])

			self._splines[ii] = nil
		end
	end
end

AimProjectileEffects._trajectory_is_active_spline = function (self)
	return self._splines and #self._splines > 0
end

local positions_table = {}

AimProjectileEffects._set_trajectory_positions_spline = function (self, aim_data, number_of_aim_data, arc_offset, total_distance, arc_distances, dt)
	if number_of_aim_data == 1 then
		for ii = 1, MAX_NUMBER_OF_SPLINE do
			local spline = self._splines[ii]

			SplineObjectDrawer.reset(spline)
			SplineObjectDrawer.dispatch(spline)
		end

		return
	end

	local number_of_points = 7
	local spline_start_index = 1
	local first_arc_distance = arc_distances[1]
	local arc_lerp = math.clamp01(first_arc_distance / 3 - 0.2)

	arc_offset = Vector3.lerp(Vector3.zero(), arc_offset, arc_lerp)

	for ii = 1, MAX_NUMBER_OF_SPLINE do
		local spline = self._splines[ii]
		local number_of_aim_data_left = number_of_aim_data - spline_start_index

		if ii <= #arc_distances and number_of_aim_data_left > 1 then
			local arc_distance = arc_distances[ii]
			local distance_between_points = arc_distance / (number_of_points - 1)
			local is_first_arc = ii == 1

			table.clear(positions_table)

			local first_aim_data = aim_data[spline_start_index]
			local first_position = first_aim_data.old_position

			positions_table[1] = _calculate_arc_position(first_position, 0, arc_distance, arc_offset, is_first_arc)

			if first_aim_data.has_hit then
				positions_table[2] = _calculate_arc_position(first_aim_data.new_position, first_aim_data.distance_in_arc, arc_distance, arc_offset, is_first_arc)
				spline_start_index = spline_start_index + 1
			else
				local current_step = first_aim_data.distance_in_arc + (is_first_arc and 0 or 0.5 * distance_between_points)
				local next_pos = 2

				for jj = spline_start_index + 1, number_of_aim_data do
					local current_aim_data = aim_data[jj]

					spline_start_index = jj
					current_step = current_step + current_aim_data.delta_distance

					if distance_between_points < current_step or current_aim_data.has_hit then
						current_step = 0

						local position = _calculate_arc_position(current_aim_data.new_position, current_aim_data.distance_in_arc, arc_distance, arc_offset, is_first_arc)

						positions_table[next_pos] = position
						next_pos = next_pos + 1
					end

					if current_aim_data.has_hit then
						spline_start_index = spline_start_index + 1

						break
					end
				end
			end

			positions_table[#positions_table + 1] = positions_table[#positions_table]

			table.insert(positions_table, 1, positions_table[1])
			SplineObjectDrawer.reset(spline)
			SplineObjectDrawer.add_spline(spline, positions_table)
			SplineObjectDrawer.dispatch(spline)
		else
			SplineObjectDrawer.reset(spline)
			SplineObjectDrawer.dispatch(spline)
		end
	end
end

function _calculate_arc_position(position, distance, total_distance, arc_offset, use_offset)
	local lerp = total_distance == 0 and 0 or math.clamp01(1 - distance / total_distance)

	lerp = lerp * lerp

	local final_offset = use_offset and arc_offset * lerp or Vector3.zero()
	local arc_position = position + final_offset

	return arc_position, final_offset
end

return AimProjectileEffects
