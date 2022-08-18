local LiquidSpread = {
	default = function (angle)
		return math.max((1 - angle / math.pi)^2 - 0.45, 0)
	end,
	pour = function (angle)
		return 1
	end,
	forward = function (angle)
		return math.max(1 - angle / (math.pi * 0.25), 0)
	end,
	flamethrower = function (angle)
		return math.max((1 - angle / math.pi)^2, 0)
	end
}

return LiquidSpread
