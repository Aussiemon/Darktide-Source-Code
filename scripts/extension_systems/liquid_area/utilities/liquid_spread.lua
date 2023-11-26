-- chunkname: @scripts/extension_systems/liquid_area/utilities/liquid_spread.lua

local LiquidSpread = {}

LiquidSpread.default = function (angle)
	return math.max((1 - angle / math.pi)^2 - 0.45, 0)
end

LiquidSpread.pour = function (angle)
	return 1
end

LiquidSpread.forward = function (angle)
	return math.max(1 - angle / (math.pi * 0.25), 0)
end

LiquidSpread.flamethrower = function (angle)
	return math.max((1 - angle / math.pi)^2, 0)
end

return LiquidSpread
