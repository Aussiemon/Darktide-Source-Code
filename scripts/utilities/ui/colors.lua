local ColorUtilities = {
	color_lerp = function (source, target, p, out, ignore_alpha)
		local math_lerp = math.lerp

		if not ignore_alpha then
			out[1] = math_lerp(source[1], target[1], p)
		end

		out[2] = math_lerp(source[2], target[2], p)
		out[3] = math_lerp(source[3], target[3], p)
		out[4] = math_lerp(source[4], target[4], p)

		return out
	end,
	color_copy = function (source, target, ignore_alpha)
		if not ignore_alpha then
			target[1] = source[1]
		end

		target[2] = source[2]
		target[3] = source[3]
		target[4] = source[4]
	end
}

local function hue2rgb(p, q, t)
	if t < 0 then
		t = t + 1
	elseif t > 1 then
		t = t - 1
	end

	if t < 0.16666666666666666 then
		return p + (q - p) * 6 * t
	elseif t < 0.5 then
		return q
	elseif t < 0.6666666666666666 then
		return p + (q - p) * 6 * (0.6666666666666666 - t)
	end

	return p
end

ColorUtilities.hsl2rgb = function (h, s, l)
	local r, g, b = nil

	if s ~= 0 then
		local q = (l < 0.5 and l * (1 + s)) or s + l * (1 - s)
		local p = 2 * l - q
		r = hue2rgb(p, q, h + 0.3333333333333333)
		g = hue2rgb(p, q, h)
		b = hue2rgb(p, q, h - 0.3333333333333333)
	else
		b = l
		g = l
		r = l
	end

	local floor = math.floor

	return floor(r * 255 + 0.5), floor(g * 255 + 0.5), floor(b * 255 + 0.5)
end

return ColorUtilities
