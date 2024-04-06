local AimAssist = require("scripts/utilities/aim_assist")
local Recoil = require("scripts/utilities/recoil")
local CommunicationWheelPlayerOrientation = class("CommunicationWheelPlayerOrientation", "BasePlayerOrientation")

CommunicationWheelPlayerOrientation.pre_update = function (self, main_t, main_dt, input, sensitivity_modifier, rotation_contraints)
	local orientation = self._orientation
	local position = self._first_person_component.position
	local weapon_action_component = self._weapon_action_component
	local aim_assist_ramp_component = self._aim_assist_ramp_component
	local targeting_data = self._smart_targeting_extension:targeting_data()
	local yaw, pitch = AimAssist.apply_aim_assist(main_t, main_dt, input, targeting_data, aim_assist_ramp_component, weapon_action_component, orientation.yaw, orientation.pitch, position)
	orientation.yaw = math.mod_two_pi(yaw)
	orientation.pitch = math.mod_two_pi(pitch)
	orientation.roll = 0
end

CommunicationWheelPlayerOrientation.orientation_offset = function (self)
	local recoil_component = self._recoil_component
	local pitch_offset = 0
	local yaw_offset = 0

	if recoil_component then
		local recoil_template = self._weapon_extension:recoil_template()
		pitch_offset, yaw_offset = Recoil.first_person_offset(recoil_template, recoil_component, self._movement_state_component)
	end

	return yaw_offset, pitch_offset, 0
end

return CommunicationWheelPlayerOrientation
