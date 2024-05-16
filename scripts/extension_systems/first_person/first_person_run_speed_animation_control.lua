-- chunkname: @scripts/extension_systems/first_person/first_person_run_speed_animation_control.lua

local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local FirstPersonRunSpeedAnimationControl = class("FirstPersonRunSpeedAnimationControl")

FirstPersonRunSpeedAnimationControl.init = function (self, first_person_unit, unit)
	self._first_person_unit = first_person_unit

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	self._inventory_component = unit_data_extension:read_component("inventory")
	self._sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
	self._movement_state_component = unit_data_extension:read_component("movement_state")
	self._visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	self._locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	self._previous_speed_scale = 0
end

local ANIMATION_VARIABLE_NAME = "run_speed_scale"
local LERP_SPEED = 10
local SPEED_SCALE_EPS = 0.001

FirstPersonRunSpeedAnimationControl.update = function (self, dt, t)
	local first_person_unit = self._first_person_unit
	local run_speed_scale_variable = Unit.animation_find_variable(first_person_unit, ANIMATION_VARIABLE_NAME)

	if not run_speed_scale_variable then
		return
	end

	local is_sprinting = self._sprint_character_state_component.is_sprinting
	local move_method = self._movement_state_component.method
	local max_movement_speed = self:_max_movement_speed(is_sprinting, move_method)

	if not max_movement_speed then
		return
	end

	local current_move_speed = self._locomotion_extension:move_speed()
	local current_speed_scale = current_move_speed / max_movement_speed
	local target_speed_scale = self:_target_speed_scale(current_speed_scale, is_sprinting, move_method)
	local lerp_t = math.min(1, dt * LERP_SPEED)
	local speed_scale = math.lerp(self._previous_speed_scale, target_speed_scale, lerp_t)

	if speed_scale < SPEED_SCALE_EPS then
		speed_scale = 0
	end

	Unit.animation_set_variable(first_person_unit, run_speed_scale_variable, speed_scale)

	self._previous_speed_scale = speed_scale
end

local MOVE_SPEED = PlayerCharacterConstants.move_speed

FirstPersonRunSpeedAnimationControl._max_movement_speed = function (self, is_sprinting, move_method)
	if is_sprinting then
		local wielded_weapon_template = PlayerUnitVisualLoadout.wielded_weapon_template(self._visual_loadout_extension, self._inventory_component)

		if not wielded_weapon_template then
			return nil
		end

		local max_first_person_anim_movement_speed = wielded_weapon_template.max_first_person_anim_movement_speed

		if not max_first_person_anim_movement_speed then
			return nil
		end

		return max_first_person_anim_movement_speed
	elseif move_method == "move_fwd" or move_method == "move_bwd" or move_method == "lunging" then
		return MOVE_SPEED
	else
		return nil
	end
end

FirstPersonRunSpeedAnimationControl._target_speed_scale = function (self, current_speed_scale)
	local target_speed_scale

	if current_speed_scale >= 0.8 then
		target_speed_scale = math.min(current_speed_scale, 1.2)
	else
		target_speed_scale = current_speed_scale >= 0.19 and 0.8 or current_speed_scale < 0.1 and 0 or math.clamp(current_speed_scale, 0.1, 0.19)
	end

	return target_speed_scale
end

return FirstPersonRunSpeedAnimationControl
