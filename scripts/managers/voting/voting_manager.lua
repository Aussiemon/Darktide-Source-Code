local Promise = require("scripts/foundation/utilities/promise")
local VotingByImmateriumPartyImpl = require("scripts/managers/voting/voting_by_immaterium_party_impl")
local VotingByNetworkImpl = require("scripts/managers/voting/voting_by_network_impl")
local VotingNotificationHandler = require("scripts/managers/voting/voting_notification_handler")
local VotingTemplates = require("scripts/settings/voting/voting_templates")
local VotingManager = class("VotingManager")

VotingManager.init = function (self, network_event_delegate)
	self._network_voting_impl = VotingByNetworkImpl:new(network_event_delegate)
	self._immaterium_party_voting_impl = VotingByImmateriumPartyImpl:new()

	if not DEDICATED_SERVER then
		self._notification_handler = VotingNotificationHandler:new()
	end
end

VotingManager._get_impl_by_template = function (self, template)
	if template.voting_impl == "network" then
		return self._network_voting_impl
	elseif template.voting_impl == "party_immaterium" then
		return self._immaterium_party_voting_impl
	elseif template.voting_impl then
		-- Nothing
	end
end

VotingManager._get_impl_by_vote_id = function (self, vote_id)
	if string.find(vote_id, "immaterium_party:") == 1 then
		return self._immaterium_party_voting_impl
	else
		return self._network_voting_impl
	end
end

VotingManager.can_start_voting = function (self, template_name, params)
	local initiator_peer = Network.peer_id()
	local template = VotingTemplates[template_name]

	if not template then
		return false, string.format("voting template %s not found", template_name)
	end

	local required_params = template.required_params

	if required_params then
		for i = 1, #required_params do
			local param_name = required_params[i]

			if params[param_name] == nil then
				return false, string.format("required voting param %s not found", param_name)
			end
		end
	end

	local result, message = self:_get_impl_by_template(template):can_start_voting(template_name, params, initiator_peer)

	if not result then
		return false, message
	end

	if template.can_start then
		return template.can_start()
	end

	return true
end

VotingManager.start_voting = function (self, template_name, params)
	local success, fail_reason = self:can_start_voting(template_name, params)

	if not success then
		return Promise.rejected({
			fail_reason
		})
	end

	local template = VotingTemplates[template_name]

	return self:_get_impl_by_template(template):start_voting(template_name, params)
end

VotingManager.can_cast_vote = function (self, voting_id, option, voter_peer_id)
	return self:_get_impl_by_vote_id(voting_id):can_cast_vote(voting_id, option, voter_peer_id)
end

VotingManager.cast_vote = function (self, voting_id, option)
	return self:_get_impl_by_vote_id(voting_id):cast_vote(voting_id, option)
end

VotingManager.update = function (self, dt, t)
	self._network_voting_impl:update(dt, t)
	self._immaterium_party_voting_impl:update(dt, t)

	if not DEDICATED_SERVER then
		self._notification_handler:update(dt, t)
	end
end

VotingManager.complete_vote = function (self, voting_id)
	self:_get_impl_by_vote_id(voting_id):complete_vote(voting_id)
end

VotingManager.member_list = function (self, voting_id)
	return self:_get_impl_by_vote_id(voting_id):member_list(voting_id)
end

VotingManager.votes = function (self, voting_id)
	return self:_get_impl_by_vote_id(voting_id):votes(voting_id)
end

VotingManager.time_left = function (self, voting_id)
	return self:_get_impl_by_vote_id(voting_id):time_left(voting_id)
end

VotingManager.voting_template = function (self, voting_id)
	return self:_get_impl_by_vote_id(voting_id):voting_template(voting_id)
end

VotingManager.voting_exists = function (self, voting_id)
	return self:_get_impl_by_vote_id(voting_id):voting_exists(voting_id)
end

VotingManager.voting_result = function (self, voting_id)
	return self:_get_impl_by_vote_id(voting_id):voting_result(voting_id)
end

VotingManager.has_voted = function (self, voting_id, voter_peer_id)
	return self:_get_impl_by_vote_id(voting_id):has_voted(voting_id, voter_peer_id)
end

VotingManager.is_host = function (self, voting_id)
	return self:_get_impl_by_vote_id(voting_id):is_host(voting_id)
end

VotingManager.create_notification = function (self, voting_id, data)
	if not DEDICATED_SERVER then
		return self._notification_handler:create(voting_id, data)
	end
end

VotingManager.modify_notification = function (self, voting_id, data)
	if not DEDICATED_SERVER then
		return self._notification_handler:modify(voting_id, data)
	end
end

VotingManager.remove_notification = function (self, voting_id)
	if not DEDICATED_SERVER then
		return self._notification_handler:remove(voting_id)
	end
end

return VotingManager
