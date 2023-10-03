local EndViewTestify = {}

EndViewTestify.fast_forward_end_of_round = function (end_view)
	if end_view:can_skip() and end_view:skip_grace_time() <= 0 then
		Managers.event:trigger("event_trigger_current_end_presentation_skip")

		return Testify.RETRY
	else
		Managers.multiplayer_session:leave("skip_end_of_round")

		return
	end
end

return EndViewTestify
