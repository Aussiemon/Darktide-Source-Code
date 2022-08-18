local PartyMemberInterface = require("scripts/managers/party_immaterium/party_member_interface")
local PartyImmateriumMember = class("PartyImmateriumMember")

PartyImmateriumMember.init = function (self, account_id)
	self._account_id = account_id
	self._peer_id = account_id
	self._unique_id = account_id
	self._name = account_id

	self:_update_presence()
end

PartyImmateriumMember._get_presence = function (self)
	local presence = self._presence

	if presence and presence:is_alive() then
		return presence
	else
		self._presence = nil

		self:_update_presence()

		return self._presence
	end
end

PartyImmateriumMember._update_presence = function (self)
	if not self._presence then
		self._presence = Managers.presence:get_presence(self._account_id)
	end
end

PartyImmateriumMember.update_immaterium_entry = function (self, immaterium_entry)
	self._immaterium_entry = immaterium_entry
end

PartyImmateriumMember.is_online = function (self)
	return self:_get_presence():is_online()
end

PartyImmateriumMember.is_invited = function (self)
	return self._immaterium_entry.status == "INVITED"
end

PartyImmateriumMember.is_connected = function (self)
	return self._immaterium_entry.status == "CONNECTED"
end

PartyImmateriumMember.invite_expires = function (self)
	return self._immaterium_entry.invite_expires
end

PartyImmateriumMember.platform = function (self)
	return self:_get_presence():platform()
end

PartyImmateriumMember.platform_user_id = function (self)
	return self:_get_presence():platform_user_id()
end

PartyImmateriumMember.presence = function (self)
	return self:_get_presence()
end

PartyImmateriumMember.presence_name = function (self)
	return self:_get_presence():activity_id()
end

PartyImmateriumMember.presence_id = function (self)
	return self:_get_presence():activity_id()
end

PartyImmateriumMember.presence_hud_text = function (self)
	return self:_get_presence():activity_localized()
end

PartyImmateriumMember.peer_id = function (self)
	return self._peer_id
end

PartyImmateriumMember.unique_id = function (self)
	return self._unique_id
end

PartyImmateriumMember.name = function (self)
	local presence = self:_get_presence()

	return presence:character_name()
end

PartyImmateriumMember.account_id = function (self)
	return self._account_id
end

PartyImmateriumMember.profile = function (self)
	local presence = self:_get_presence()

	return presence:character_profile()
end

PartyImmateriumMember.destroy = function (self)
	return
end

PartyImmateriumMember.is_human_controlled = function (self)
	return true
end

PartyImmateriumMember.unit_is_alive = function (self)
	return false
end

PartyImmateriumMember.is_party_player = function (self)
	return true
end

implements(PartyImmateriumMember, PartyMemberInterface)

return PartyImmateriumMember
