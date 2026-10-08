-- chunkname: @scripts/ui/views/end_view/end_view_testify.lua

local EndViewTestify = {
	fast_forward_end_of_round = function (end_view)
		if not end_view._testify_leave_requested then
			end_view:_trigger_current_presentation_skip()

			end_view._testify_leave_requested = Managers.multiplayer_session:is_leaving()
		end

		return Testify.RETRY
	end,
	rate_match = function (end_view, rating)
		end_view:rate_match(rating)

		return end_view:match_rating() or false
	end,
}

return EndViewTestify
