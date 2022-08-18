local Fov = {}
local PI = math.pi
local CALIBRATE_VALUE = math.tan(PI / 3 * 0.5)

Fov.from_viewport = function (viewport_name)
	local current_fov = Managers.state.camera:fov(viewport_name)
	local fov_correction = math.tan(current_fov * 0.5) / CALIBRATE_VALUE

	return fov_correction
end

return Fov
