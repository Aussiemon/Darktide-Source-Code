-- chunkname: @scripts/game_states/boot/state_boot_sub_state_base.lua

local StateBootSubStateBase = class("StateBootSubStateBase")

StateBootSubStateBase.ENFORCED_INTERFACE = {
	"update",
	"_state_update",
}

StateBootSubStateBase.on_enter = function (self, parent, params)
	self._parent = parent
	self._params = params
end

StateBootSubStateBase._state_params = function (self)
	return self._params.states[self._params.sub_state_index][2]
end

StateBootSubStateBase.update = function (self)
	local done, error = self:_state_update()
	local params = self._params

	if error then
		return StateError, {
			error,
		}
	elseif done then
		local next_index = params.sub_state_index + 1

		params.sub_state_index = next_index

		local next_state_data = params.states[next_index]

		if next_state_data then
			return next_state_data[1], self._params
		else
			self._parent:sub_states_done()
		end
	end
end

return StateBootSubStateBase
