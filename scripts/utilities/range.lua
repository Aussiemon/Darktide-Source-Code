local Range = {
	quadratic_falloff = function (range, distance)
		if distance <= range then
			return 1
		else
			return (range / distance)^2
		end
	end,
	power_4 = function (range, distance)
		if distance <= range then
			return 1
		else
			return (range / distance)^4
		end
	end
}

return Range
