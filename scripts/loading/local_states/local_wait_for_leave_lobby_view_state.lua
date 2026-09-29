-- chunkname: @scripts/loading/local_states/local_wait_for_leave_lobby_view_state.lua

local LocalWaitForLeaveLobbyViewState = class("LocalWaitForLeaveLobbyViewState")

LocalWaitForLeaveLobbyViewState.update = function (self, dt)
	local lobby_view_active = Managers.ui:view_active("lobby_view")

	if lobby_view_active then
		return
	end

	return "lobby_view_left"
end

return LocalWaitForLeaveLobbyViewState
