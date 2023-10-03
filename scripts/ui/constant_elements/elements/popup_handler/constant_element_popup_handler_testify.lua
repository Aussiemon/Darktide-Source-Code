local ConstantElementPopupHandlerTestify = {}

ConstantElementPopupHandlerTestify.accept_mission_board_vote = function (constant_element_popup_handler)
	if not constant_element_popup_handler:active_popup() then
		return Testify.RETRY
	end

	local accept_voting_widget = constant_element_popup_handler._widgets_by_name.button_1

	if not accept_voting_widget then
		return Testify.RETRY
	end

	constant_element_popup_handler:trigger_widget_callback(accept_voting_widget)
end

ConstantElementPopupHandlerTestify.wait_for_cutscene_to_finish = function (constant_element_popup_handler)
	if not constant_element_popup_handler:active_popup() then
		return Testify.RETRY
	end

	local accept_voting_widget = constant_element_popup_handler._widgets_by_name.popup_widget_1

	if not accept_voting_widget then
		return Testify.RETRY
	end

	constant_element_popup_handler:trigger_widget_callback(accept_voting_widget)

	return Testify.RETRY
end

ConstantElementPopupHandlerTestify.select_popup_option = function (constant_element_popup_handler, widget_name)
	if not constant_element_popup_handler:active_popup() then
		return Testify.RETRY
	end

	local widget = constant_element_popup_handler._widgets_by_name[widget_name]

	if not widget then
		return Testify.RETRY
	end

	constant_element_popup_handler:trigger_widget_callback(widget)
end

return ConstantElementPopupHandlerTestify
