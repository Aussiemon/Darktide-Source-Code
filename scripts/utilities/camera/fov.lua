local Fov = {}
local PI = math.pi
local CALIBRATE_VALUE = math.tan(PI / 3 * 0.5)

Fov.sensitivity_modifier = function (viewport_name)
	local current_fov = Managers.state.camera:fov(viewport_name)
	local sensitivity_modifier = math.tan(current_fov * 0.5) / CALIBRATE_VALUE

	return sensitivity_modifier
end

return Fov
