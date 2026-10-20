-- chunkname: @scripts/ui/constant_elements/elements/popup_handler/constant_element_popup_handler_testify.lua

local ConstantElementPopupHandlerTestify = {
	accept_mission_board_vote = function (constant_element_popup_handler)
		if not constant_element_popup_handler:active_popup() then
			return Testify.RETRY
		end

		local accept_voting_widget = constant_element_popup_handler._widgets_by_name.button_1

		if not accept_voting_widget then
			return Testify.RETRY
		end

		constant_element_popup_handler:trigger_widget_callback(accept_voting_widget)
	end,
	wait_for_cutscene_to_finish = function (constant_element_popup_handler)
		if not constant_element_popup_handler:active_popup() then
			return Testify.RETRY
		end

		local accept_voting_widget = constant_element_popup_handler._widgets_by_name.popup_widget_1

		if not accept_voting_widget then
			return Testify.RETRY
		end

		constant_element_popup_handler:trigger_widget_callback(accept_voting_widget)

		return Testify.RETRY
	end,
	select_popup_option = function (constant_element_popup_handler, widget_name)
		if not constant_element_popup_handler:active_popup() then
			return Testify.RETRY
		end

		local widget = constant_element_popup_handler._widgets_by_name[widget_name]

		if not widget then
			return Testify.RETRY
		end

		constant_element_popup_handler:trigger_widget_callback(widget)
	end,
	wait_for_popup_displayed = function (constant_element_popup_handler, popup_id)
		local active_popup = constant_element_popup_handler:active_popup()

		if not active_popup or active_popup.id ~= popup_id then
			return Testify.RETRY
		end

		if constant_element_popup_handler._on_enter_anim_id or constant_element_popup_handler._blur_duration then
			return Testify.RETRY
		end
	end,
	wait_for_no_active_popup = function (constant_element_popup_handler)
		if constant_element_popup_handler:active_popup() or constant_element_popup_handler._on_exit_anim_id then
			return Testify.RETRY
		end
	end,
}

return ConstantElementPopupHandlerTestify
