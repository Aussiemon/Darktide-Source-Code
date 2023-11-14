local Fov = {}
local PI = math.pi
local SENSITIVITY_CALIBRATE_VALUE = math.tan(PI / 3 * 0.5)
local math_tan = math.tan
local math_rad = math.rad

Fov.sensitivity_modifier = function (viewport_name)
	local current_fov = Managers.state.camera:fov(viewport_name)
	local sensitivity_modifier = math_tan(current_fov * 0.5) / SENSITIVITY_CALIBRATE_VALUE

	return sensitivity_modifier
end

return Fov
