local CriticallyDampenedString = {}
local _critical_spring_damper_implicit, _halflife_to_damping, _fast_negexp = nil

CriticallyDampenedString.step = function (position, velocity, target_position, target_velocity, halflife, dt)
	local damping = _halflife_to_damping(halflife)

	for i = 1, 3 do
		local p = position[i]
		local v = velocity[i]
		local p_goal = target_position[i]
		local v_goal = target_velocity[i]
		position[i], velocity[i] = _critical_spring_damper_implicit(p, v, p_goal, v_goal, damping, dt)
	end
end

local EPS = 1e-05

function _halflife_to_damping(halflife)
	return 2.77258872224 / (halflife + EPS)
end

function _critical_spring_damper_implicit(p, v, p_goal, v_goal, damping, dt)
	local g = p_goal
	local q = v_goal
	local d = damping
	local c = g + d * q / (d * d * 0.25)
	local y = d * 0.5
	local j0 = p - c
	local j1 = v + j0 * y
	local eydt = _fast_negexp(y * dt)
	local p_new = eydt * (j0 + j1 * dt) + c
	local v_new = eydt * (v - j1 * y * dt)

	return p_new, v_new
end

function _fast_negexp(x)
	return 1 / (1 + x + 0.48 * x * x + 0.235 * x * x * x)
end

return CriticallyDampenedString
