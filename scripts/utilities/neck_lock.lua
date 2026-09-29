-- chunkname: @scripts/utilities/neck_lock.lua

local NeckLock = {}

NeckLock.stabilize_neck = function (unit, item_stabilize_neck_value)
	if Unit.has_animation_state_machine(unit) and Unit.has_animation_event(unit, "lock_head") and Unit.has_animation_event(unit, "unlock_head") then
		if item_stabilize_neck_value > 0 then
			Unit.animation_event(unit, "lock_head")

			local sm_variable_index = Unit.animation_find_variable(unit, "lock_neck_weight")
			local stabilize_amount

			if sm_variable_index then
				stabilize_amount = math.clamp(item_stabilize_neck_value, 0, 80) / 80

				Unit.animation_set_variable(unit, sm_variable_index, stabilize_amount)
			end

			sm_variable_index = Unit.animation_find_variable(unit, "lock_head_weight")

			if sm_variable_index then
				if item_stabilize_neck_value >= 50 then
					stabilize_amount = (item_stabilize_neck_value - 50) / 50

					Unit.animation_set_variable(unit, sm_variable_index, stabilize_amount)
				else
					Unit.animation_set_variable(unit, sm_variable_index, 0)
				end
			end
		else
			Unit.animation_event(unit, "unlock_head")
		end
	end
end

return NeckLock
