-- chunkname: @scripts/loading/local_states/local_wait_for_mission_briefing_done_state.lua

local LocalWaitForMissionBriefingDoneState = class("LocalWaitForMissionBriefingDoneState")

LocalWaitForMissionBriefingDoneState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
end

LocalWaitForMissionBriefingDoneState.destroy = function (self)
	return
end

LocalWaitForMissionBriefingDoneState.update = function (self, dt)
	local lobby_view_active = Managers.ui:view_active("lobby_view")

	if lobby_view_active then
		return
	end

	local mission_intro_view_active = Managers.ui:view_active("mission_intro_view")

	if not mission_intro_view_active then
		Log.info("LocalWaitForMissionBriefingDoneState", "no mission_intro_view active")

		return "mission_briefing_done"
	end

	local mission_intro_view = Managers.ui:view_instance("mission_intro_view")

	if not mission_intro_view then
		Log.info("LocalWaitForMissionBriefingDoneState", "no mission_intro_view active")

		return "mission_briefing_done"
	end

	local mission_briefing_done = mission_intro_view.mission_briefing_done

	if mission_briefing_done then
		Log.info("LocalWaitForMissionBriefingDoneState", "mission_briefing_done")

		return "mission_briefing_done"
	end
end

return LocalWaitForMissionBriefingDoneState
