-- chunkname: @scripts/utilities/camera/fov.lua

local Fov = {}
local PI = math.pi
local SENSITIVITY_CALIBRATE_VALUE = math.tan(PI / 3 * 0.5)
local CROSSHAIR_CALIBRATE_VALUE = 37
local math_tan = math.tan
local math_rad = math.rad

Fov.sensitivity_modifier = function (viewport_name)
	local current_fov = Managers.state.camera:fov(viewport_name)
	local sensitivity_modifier = math_tan(current_fov * 0.5) / SENSITIVITY_CALIBRATE_VALUE

	return sensitivity_modifier
end

Fov.apply_fov_to_crosshair = function (pitch, yaw)
	local player = Managers.player:local_player(1)

	if not player then
		return pitch, yaw
	end

	local viewport_name = player.viewport_name
	local current_fov = Managers.state.camera:fov(viewport_name)
	local half_fov = current_fov * 0.5
	local corrected_pitch = math_tan(math_rad(pitch)) / math_tan(half_fov) * CROSSHAIR_CALIBRATE_VALUE
	local corrected_yaw = math_tan(math_rad(yaw)) / math_tan(half_fov) * CROSSHAIR_CALIBRATE_VALUE

	return corrected_pitch, corrected_yaw
end

return Fov
