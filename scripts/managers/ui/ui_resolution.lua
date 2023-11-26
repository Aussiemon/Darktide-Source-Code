-- chunkname: @scripts/managers/ui/ui_resolution.lua

local NUM_SCREEN_FRAGMENTS_W = 1920
local NUM_SCREEN_FRAGMENTS_H = 1080
local UIResolution = {}
local math_max = math.max
local math_round = math.round

UIResolution.width_fragments = function ()
	return NUM_SCREEN_FRAGMENTS_W
end

UIResolution.height_fragments = function ()
	return NUM_SCREEN_FRAGMENTS_H
end

UIResolution.save = function (width, height)
	Application.set_user_setting("screen_resolution", 1, width)
	Application.set_user_setting("screen_resolution", 2, height)
	Application.save_user_settings()
end

UIResolution.scale_vector = function (position, scale, pixel_snap, use_real_coordinates)
	local pos_x = position[1] > 0 and math_max(position[1] * scale, 1) or position[1] * scale
	local pos_y = position[2] > 0 and math_max(position[2] * scale, 1) or position[2] * scale
	local pos_z = position[3] and (position[3] > 0 and math_max(position[3] * scale, 1) or position[2] * scale)

	if pixel_snap then
		if use_real_coordinates then
			return Vector3(math.round(pos_x), position[2] or 0, math.round(pos_z))
		else
			return Vector3(math.round(pos_x), math.round(pos_y), position[3] or 0)
		end
	elseif use_real_coordinates then
		return Vector3(pos_x, position[2] or 0, pos_z)
	else
		return Vector3(pos_x, pos_y, position[3] or 0)
	end
end

UIResolution.scale_lua_vector2 = function (position, scale, pixel_snap)
	local pos_x = position[1] > 0 and math_max(position[1] * scale, 1) or position[1] * scale
	local pos_y = position[2] > 0 and math_max(position[2] * scale, 1) or position[2] * scale

	if pixel_snap then
		return math_round(pos_x), math_round(pos_y), 0
	else
		return pos_x, pos_y, 0
	end
end

UIResolution.scale_vector3 = function (position, scale, pixel_snap)
	local x, y, z = Vector3.to_elements(position)
	local pos_x = x > 0 and math_max(x * scale, 1) or x * scale
	local pos_y = y > 0 and math_max(y * scale, 1) or y * scale

	if pixel_snap then
		return math_round(pos_x), math_round(pos_y), z
	else
		return pos_x, pos_y, z
	end
end

UIResolution.inverse_scale_vector = function (position, inverse_scale, pixel_snap)
	if pixel_snap then
		return Vector3(math_round(position[1] * inverse_scale), math_round(position[2] * inverse_scale), position[3] or 0)
	else
		return Vector3(position[1] * inverse_scale, position[2] * inverse_scale, position[3] or 0)
	end
end

return UIResolution
