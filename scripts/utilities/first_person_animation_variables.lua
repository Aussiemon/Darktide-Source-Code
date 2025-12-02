-- chunkname: @scripts/utilities/first_person_animation_variables.lua

local AlternateFire = require("scripts/utilities/alternate_fire")
local Recoil = require("scripts/utilities/recoil")
local Sway = require("scripts/utilities/sway")
local DEFAULT_SWAY_LERP_SPEED = 10
local _update_move, _update_aim_offset, _update_lunge_hit_mass
local FirstPersonAnimationVariables = {}

FirstPersonAnimationVariables.update = function (dt, t, first_person_unit, unit_data_extension, weapon_extension, lerp_values)
	local alternate_fire_component = unit_data_extension:read_component("alternate_fire")

	_update_move(dt, t, first_person_unit, unit_data_extension, alternate_fire_component, lerp_values)
	_update_aim_offset(dt, t, first_person_unit, unit_data_extension, weapon_extension, alternate_fire_component, lerp_values)
	_update_lunge_hit_mass(first_person_unit, unit_data_extension)
end

function _update_move(dt, t, first_person_unit, unit_data_extension, alternate_fire_component, lerp_values)
	local first_person_component = unit_data_extension:read_component("first_person")
	local locomotion_component = unit_data_extension:read_component("locomotion")
	local rotation = first_person_component.rotation
	local velocity_current = Vector3.flat(locomotion_component.velocity_current)
	local velocity_normalized = Vector3.normalize(velocity_current)
	local rotation_right = Quaternion.right(rotation)
	local rotation_right_normalized = Vector3.normalize(rotation_right)
	local move_x_raw = Vector3.dot(velocity_normalized, rotation_right_normalized)
	local move_x = move_x_raw
	local rotation_forward = Vector3.flat(Quaternion.forward(rotation))
	local rotation_forward_normalized = Vector3.normalize(rotation_forward)
	local move_z = Vector3.dot(velocity_normalized, rotation_forward_normalized)

	if alternate_fire_component.is_active then
		move_x = math.clamp(math.lerp(lerp_values.move_x or 0, move_x, math.easeOutCubic(0.5 * dt)), -1, 1)
		move_z = math.clamp(math.lerp(lerp_values.move_z or 0, move_z, math.easeOutCubic(0.2 * dt)), -1, 1)
	else
		move_x = math.clamp(math.lerp(lerp_values.move_x or 0, move_x, math.easeOutCubic(0.2 * dt)), -1, 1)
		move_z = math.clamp(math.lerp(lerp_values.move_z or 0, move_z, math.easeOutCubic(0.5 * dt)), -1, 1)
	end

	move_x_raw = math.clamp(math.lerp(lerp_values.move_x_raw or 0, move_x_raw, math.easeOutCubic(1.7 * dt)), -1, 1)
	lerp_values.move_x_raw = move_x_raw
	lerp_values.move_z = move_z
	lerp_values.move_x = move_x

	local move_x_variable = Unit.animation_find_variable(first_person_unit, "move_x")

	if move_x_variable then
		Unit.animation_set_variable(first_person_unit, move_x_variable, move_x)
	end

	local move_x_raw_variable = Unit.animation_find_variable(first_person_unit, "move_x_raw")

	if move_x_raw_variable then
		Unit.animation_set_variable(first_person_unit, move_x_raw_variable, move_x_raw)
	end

	local move_z_variable = Unit.animation_find_variable(first_person_unit, "move_z")

	if move_z_variable then
		Unit.animation_set_variable(first_person_unit, move_z_variable, move_z)
	end

	local move_speed = Vector3.length(velocity_current)
	local move_speed_variable = Unit.animation_find_variable(first_person_unit, "move_speed")

	if move_speed_variable then
		Unit.animation_set_variable(first_person_unit, move_speed_variable, math.min(move_speed, 19.99999))
	end
end

local deg_65_in_rad = math.degrees_to_radians(65)

function _update_aim_offset(dt, t, first_person_unit, unit_data_extension, weapon_extension, alternate_fire_component, lerp_values)
	local first_person_component = unit_data_extension:read_component("first_person")
	local rotation = first_person_component.rotation
	local pitch = Quaternion.pitch(rotation)
	local aim_height_variable = Unit.animation_find_variable(first_person_unit, "aim_height")

	if aim_height_variable then
		local current_value = Unit.animation_get_variable(first_person_unit, aim_height_variable)
		local wanted_value = math.clamp(pitch, -1, 1)
		local new_value = math.lerp(current_value, wanted_value, 20 * dt)

		new_value = math.clamp(new_value, -1, 1)

		Unit.animation_set_variable(first_person_unit, aim_height_variable, new_value)
	end

	local sway_component = unit_data_extension:read_component("sway")
	local movement_state_component = unit_data_extension:read_component("movement_state")
	local locomotion_component = unit_data_extension:read_component("locomotion")
	local inair_state_component = unit_data_extension:read_component("inair_state")
	local sway_template = weapon_extension:sway_template()
	local sway_settings = Sway.movement_state_settings(sway_template, movement_state_component, locomotion_component, inair_state_component)
	local visual_sway_settings = sway_settings and sway_settings.visual_sway_settings
	local sway_lerp_speed = visual_sway_settings and visual_sway_settings.lerp_speed or DEFAULT_SWAY_LERP_SPEED
	local sway_lerp_scalar = math.min(sway_lerp_speed * dt * 2, 1)
	local sway_offset_x = sway_component.offset_x
	local sway_offset_y = sway_component.offset_y

	sway_offset_x = math.lerp(lerp_values.sway_offset_x or 0, sway_offset_x, sway_lerp_scalar)
	sway_offset_y = math.lerp(lerp_values.sway_offset_y or 0, sway_offset_y, sway_lerp_scalar)
	lerp_values.sway_offset_x = sway_offset_x
	lerp_values.sway_offset_y = sway_offset_y

	local aim_offset_x = sway_offset_x * (sway_settings and sway_settings.visual_yaw_impact_mod or 1)
	local aim_offset_y = sway_offset_y * (sway_settings and sway_settings.visual_pitch_impact_mod or 1)
	local recoil_template = weapon_extension:recoil_template()
	local recoil_component = unit_data_extension:read_component("recoil")
	local movement_state_settings = Recoil.recoil_movement_state_settings(recoil_template, movement_state_component, locomotion_component, inair_state_component)
	local visual_recoil_settings = movement_state_settings and movement_state_settings.visual_recoil_settings

	if visual_recoil_settings then
		local recoil_intensity = visual_recoil_settings.intensity
		local lerp_scalar = visual_recoil_settings.lerp_scalar
		local yaw_intensity = visual_recoil_settings.yaw_intensity or recoil_intensity * 0.5
		local recoil_pitch_offset, recoil_yaw_offset = Recoil.weapon_offset(recoil_template, recoil_component, movement_state_component, locomotion_component, inair_state_component)

		recoil_pitch_offset = math.lerp(lerp_values.recoil_pitch_offset or 0, recoil_pitch_offset * recoil_intensity, lerp_scalar)
		recoil_yaw_offset = math.lerp(lerp_values.recoil_yaw_offset or 0, recoil_yaw_offset * yaw_intensity, lerp_scalar)
		lerp_values.recoil_pitch_offset = recoil_pitch_offset
		lerp_values.recoil_yaw_offset = recoil_yaw_offset
		aim_offset_y = aim_offset_y + recoil_pitch_offset
		aim_offset_x = aim_offset_x + recoil_yaw_offset
	end

	local fov_mod = 1
	local local_player = Managers.player:local_player(1)

	if local_player then
		local base_tweak_fov = deg_65_in_rad

		if alternate_fire_component.is_active then
			local vertical_fov = AlternateFire.camera_variables(weapon_extension:weapon_template())

			if vertical_fov then
				base_tweak_fov = vertical_fov
			end
		end

		local current_fov = Managers.state.camera:fov(local_player.viewport_name)

		fov_mod = base_tweak_fov / current_fov
	end

	aim_offset_x = math.clamp(aim_offset_x * fov_mod, -1, 1)
	aim_offset_y = math.clamp(aim_offset_y * fov_mod, -1, 1)

	local aim_offset_x_variable = Unit.animation_find_variable(first_person_unit, "aim_offset_x")

	if aim_offset_x_variable then
		Unit.animation_set_variable(first_person_unit, aim_offset_x_variable, aim_offset_x)
	end

	local aim_offset_y_variable = Unit.animation_find_variable(first_person_unit, "aim_offset_y")

	if aim_offset_y_variable then
		Unit.animation_set_variable(first_person_unit, aim_offset_y_variable, aim_offset_y)
	end

	_update_lunge_hit_mass(first_person_unit, unit_data_extension)
end

function _update_lunge_hit_mass(first_person_unit, unit_data_extension)
	local hit_mass_variable = Unit.animation_find_variable(first_person_unit, "hit_mass")

	if hit_mass_variable then
		local character_state_hit_mass_component = unit_data_extension:write_component("character_state_hit_mass")
		local hit_mass = character_state_hit_mass_component.used_hit_mass_percentage

		Unit.animation_set_variable(first_person_unit, hit_mass_variable, hit_mass)
	end
end

return FirstPersonAnimationVariables
