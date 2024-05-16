-- chunkname: @scripts/utilities/range.lua

local Range = {}

Range.quadratic_falloff = function (range, distance)
	if distance <= range then
		return 1
	else
		return (range / distance)^2
	end
end

Range.power_4 = function (range, distance)
	if distance <= range then
		return 1
	else
		return (range / distance)^4
	end
end

return Range
