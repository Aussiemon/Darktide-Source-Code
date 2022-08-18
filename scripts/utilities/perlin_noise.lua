local PerlinNoise = {}
local _noise, _smoothed_noise, _interpolated_noise = nil

PerlinNoise.calculate_perlin_value = function (x, persistance, octaves, seed)
	local total = 0
	local max_value = 0
	local frequency = 1
	local amplitude = 1

	for i = 0, octaves, 1 do
		total = total + _interpolated_noise(x * frequency, seed) * amplitude
		max_value = max_value + amplitude
		frequency = frequency * 2
		amplitude = amplitude * persistance
	end

	local normalized_total = total / max_value

	return normalized_total
end

function _noise(x, seed)
	local next_seed, _ = math.next_random(x * seed)
	local _, value = math.next_random(next_seed)

	return value * 2 - 1
end

function _smoothed_noise(x, seed)
	return _noise(x, seed) / 2 + _noise(x - 1, seed) / 4 + _noise(x + 1, seed) / 4
end

function _interpolated_noise(x, seed)
	local x_floored = math.floor(x)
	local remainder = x - x_floored
	local v1 = _smoothed_noise(x_floored, seed)
	local v2 = _smoothed_noise(x_floored + 1, seed)

	return math.lerp(v1, v2, remainder)
end

return PerlinNoise
