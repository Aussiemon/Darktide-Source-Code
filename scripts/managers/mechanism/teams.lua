local Team = require("scripts/managers/mechanism/team")
local Teams = class("Teams")

Teams.init = function (self, team_settings)
	local teams = {}
	self._teams = teams
	self._peer_to_team_lookup = {}

	for i = 1, #team_settings do
		local team_config = team_settings[i]
		teams[i] = Team:new(team_config)
	end
end

Teams.teams = function (self)
	return self._teams
end

Teams.has_space_in_any_team_for_peers = function (self, peer_ids)
	local num_peers = #peer_ids
	local num_space = 0
	local teams = self._teams
	local num_teams = #teams

	for i = 1, num_teams do
		local team = teams[i]
		num_space = num_space + team:num_unoccupied_slots()
	end

	if num_peers <= num_space then
		return true
	else
		Log.info("Teams", "Not enough space in any team. num_space(%i) num_peers(%i)", num_space, num_teams)

		return false
	end
end

Teams.add_peers_to_any_team = function (self, peer_ids)
	local num_peer_ids = #peer_ids

	for i = 1, num_peer_ids do
		local peer_id = peer_ids[i]
		local assigned_team = false

		for team_id, team in ipairs(self._teams) do
			if team:has_space() then
				self:_add_peer_to_team(peer_id, team)

				assigned_team = true

				break
			end
		end

		fassert(assigned_team, "Could not find team for peer %q", peer_id)
	end
end

Teams.remove_peer_from_team = function (self, peer_id)
	local team = self._peer_to_team_lookup[peer_id]

	fassert(team, "Peer %q is not assigned to any team.", peer_id)
	self:_remove_peer_from_team(peer_id, team)
end

Teams.team_name_from_peer_id = function (self, peer_id)
	local team = self._peer_to_team_lookup[peer_id]

	fassert(team, "peer %q does not have a team.", peer_id)

	return team:name()
end

Teams.team_name_from_team_id = function (self, team_id)
	local team = self._teams[team_id]

	fassert(team, "No team on team_id %i", team_id)

	return team:name()
end

Teams._add_peer_to_team = function (self, peer_id, team)
	self._peer_to_team_lookup[peer_id] = team

	team:add_peer(peer_id)
end

Teams._remove_peer_from_team = function (self, peer_id, team)
	team:remove_peer(peer_id)

	self._peer_to_team_lookup[peer_id] = nil
end

return Teams
