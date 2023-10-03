local PartyImmateriumManagerTestify = {
	accept_join_party = function (_, wait_for_popup)
		local constant_elements = Managers.ui:ui_constant_elements()
		local constant_element_popup_handler = constant_elements:element("ConstantElementPopupHandler")
		local widgets_by_name = constant_element_popup_handler:widgets_by_name()
		local accept_button = widgets_by_name.popup_widget_1

		if accept_button then
			constant_element_popup_handler:trigger_widget_callback(accept_button)
		elseif wait_for_popup == false then
			return
		else
			return Testify.RETRY
		end
	end
}

PartyImmateriumManagerTestify.immaterium_join_party = function (party_immaterium_manager, party_id)
	party_immaterium_manager:join_party(party_id)
end

PartyImmateriumManagerTestify.immaterium_party_id = function (party_immaterium_manager)
	return party_immaterium_manager:party_id()
end

PartyImmateriumManagerTestify.leave_party_immaterium = function (party_immaterium_manager)
	return party_immaterium_manager:leave_party():next(function ()
		return
	end)
end

return PartyImmateriumManagerTestify
