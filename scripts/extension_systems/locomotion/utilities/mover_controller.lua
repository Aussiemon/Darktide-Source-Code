-- chunkname: @scripts/extension_systems/locomotion/utilities/mover_controller.lua

local MoverController = {}

Unit._set_mover = Unit._set_mover or Unit.set_mover

Unit.set_mover = function ()
	error("Use your locomotion-extension's mover functions instead of setting mover directly through Unit.set_mover")
end

MoverController.create_mover_state = function ()
	return {
		disable_reasons = {},
	}
end

MoverController.set_active_mover = function (unit, mover_state, new_active_mover)
	if next(mover_state.disable_reasons) == nil then
		Unit._set_mover(unit, new_active_mover)
	end

	mover_state.active_mover = new_active_mover
end

MoverController.set_disable_reason = function (unit, mover_state, reason, new_state)
	if new_state == false then
		new_state = nil
	end

	local disable_reasons = mover_state.disable_reasons

	disable_reasons[reason] = new_state

	if next(disable_reasons) == nil then
		Unit._set_mover(unit, mover_state.active_mover)
	else
		Unit._set_mover(unit, nil)
	end
end

return MoverController
