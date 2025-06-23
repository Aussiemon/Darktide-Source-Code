-- chunkname: @scripts/settings/voting/voting_templates.lua

local voting_templates = {
	network = {},
	party_immaterium = {}
}

local function _validate_template_data(data)
	if data.evaluate_delay and data.duration then
		-- Nothing
	end

	if data.duration then
		-- Nothing
	end
end

local function _create_voting_template_entry(path)
	local voting_template_data = require(path)
	local voting_template_name = voting_template_data.name

	_validate_template_data(voting_template_data)

	voting_templates[voting_template_name] = voting_template_data
	voting_templates[voting_template_data.voting_impl][voting_template_name] = voting_template_data
end

_create_voting_template_entry("scripts/settings/voting/voting_templates/mission_lobby_ready_voting_template")
_create_voting_template_entry("scripts/settings/voting/voting_templates/accept_mission_voting_template_immaterium")
_create_voting_template_entry("scripts/settings/voting/voting_templates/new_hub_session_voting_template_immaterium")
_create_voting_template_entry("scripts/settings/voting/voting_templates/internal_vote_mission_matchmaking_immaterium")
_create_voting_template_entry("scripts/settings/voting/voting_templates/mission_vote_matchmaking_immaterium")
_create_voting_template_entry("scripts/settings/voting/voting_templates/kick_from_mission_voting_template")
_create_voting_template_entry("scripts/settings/voting/voting_templates/stay_in_party_voting_template")

return voting_templates
