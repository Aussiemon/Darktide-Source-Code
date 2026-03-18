-- chunkname: @scripts/settings/voting/voting_flow_settings.lua

local voting_flow_settings = {
	expeditions_exit = {
		instructions_text = "loc_party_kick_instructions_new",
		post_vote_message = "loc_party_kick_instructions_yes_vote",
		title = "loc_expedition_exit_instructions_header",
	},
	expeditions_extract = {
		instructions_text = "loc_party_kick_instructions_new",
		post_vote_message = "loc_party_kick_instructions_yes_vote",
		title = "loc_expedition_extract_instructions_header",
	},
}

return settings("VotingFlowSettings", voting_flow_settings)
