-- chunkname: @scripts/game_states/boot/state_boot_sub_state_base.lua

local StateBootSubStateBase = class("StateBootSubStateBase")

StateBootSubStateBase.on_enter = function (self, parent, params)
	self._parent = parent
	self._params = params

	local index = params.boot_state_index

	parent:boot_printf(".//%02d/%s", index, self.__class_name)
end

StateBootSubStateBase.destroy = function (self, exit_params)
	if self._state_cleanup then
		local on_shutdown = exit_params and exit_params.on_shutdown or false

		self:_state_cleanup(on_shutdown)
	end
end

StateBootSubStateBase.update = function (self)
	local done = self:_state_update()

	if done then
		local params = self._params
		local parent = self._parent

		table.insert(params.initialized_steps, self)

		local next_index = params.boot_state_index + 1

		params.boot_state_index = next_index

		local next_state = params.boot_states[next_index]

		if next_state then
			return next_state, self._params
		else
			parent:sub_states_done()
		end
	end
end

return StateBootSubStateBase
