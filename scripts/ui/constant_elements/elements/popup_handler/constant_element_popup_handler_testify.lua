local ConstantElementPopupHandlerTestify = {
	accept_mission_board_vote = function (_, constant_element_popup_handler)
		local accept_voting_widget = constant_element_popup_handler._widgets_by_name.button_1

		if not accept_voting_widget then
			return Testify.RETRY
		end

		constant_element_popup_handler:trigger_widget_callback(accept_voting_widget)
	end,
	wait_for_cutscene_to_finish = function (_, constant_element_popup_handler)
		local accept_voting_widget = constant_element_popup_handler._widgets_by_name.popup_widget_1

		if not accept_voting_widget then
			return Testify.RETRY
		end

		constant_element_popup_handler:trigger_widget_callback(accept_voting_widget)

		return Testify.RETRY
	end
}

return ConstantElementPopupHandlerTestify
