local DampenedString = {}
local _damper_implicit, _halflife_to_damping, _fast_negexp = nil

DampenedString.step = function (position, target_position, halflife, dt)
	local damping = _halflife_to_damping(halflife, dt)

	for i = 1, 3, 1 do
		local p = position[i]
		local p_goal = target_position[i]
		position[i] = _damper_implicit(p, p_goal, damping)
	end
end

local EPS = 1e-05

function _halflife_to_damping(halflife, dt)
	return (0.69314718056 * dt) / (halflife + EPS)
end

function _damper_implicit(p, p_goal, damping)
	return math.lerp(p, p_goal, 1 - _fast_negexp(damping))
end

function _fast_negexp(x)
	return 1 / (1 + x + 0.48 * x * x + 0.235 * x * x * x)
end

return DampenedString
