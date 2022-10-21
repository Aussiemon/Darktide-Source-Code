local PartyImmateriumTestify = {
	leave_party_immaterium = function (_, party_immaterium_manager)
		return party_immaterium_manager:leave_party():next(function ()
			return
		end)
	end,
	immaterium_party_id = function (_, party_immaterium_manager)
		return party_immaterium_manager:party_id()
	end,
	immaterium_join_party = function (party_id, party_immaterium_manager)
		party_immaterium_manager:join_party(party_id)

		local my_account_id = party_immaterium_manager:get_myself():account_id()

		return my_account_id
	end,
	accept_join_party = function (joiner_account_id, party_immaterium_manager)
		local join_popups_keys = table.keys(party_immaterium_manager._request_to_join_popups)

		if table.is_empty(join_popups_keys) then
			return Testify.RETRY
		end

		Managers.grpc:answer_request_to_join(party_immaterium_manager:party_id(), joiner_account_id, "OK_POPUP")

		join_popups_keys[joiner_account_id] = nil
	end
}

return PartyImmateriumTestify
