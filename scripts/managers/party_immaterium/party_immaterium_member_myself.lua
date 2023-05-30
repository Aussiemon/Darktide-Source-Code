local PartyMemberInterface = require("scripts/managers/party_immaterium/party_member_interface")
local PartyImmateriumMemberMyself = class("PartyImmateriumMemberMyself")

PartyImmateriumMemberMyself.init = function (self, account_id)
	self._account_id = account_id
	self._peer_id = account_id
	self._unique_id = account_id
	self._presence_entry = Managers.presence:presence_entry_myself()
end

PartyImmateriumMemberMyself.update_account_id = function (self, account_id)
	self._account_id = account_id
	self._peer_id = account_id
	self._unique_id = account_id
end

PartyImmateriumMemberMyself.is_online = function (self)
	return true
end

PartyImmateriumMemberMyself.platform = function (self)
	return self._platform
end

PartyImmateriumMemberMyself.presence = function (self)
	return self._presence_entry
end

PartyImmateriumMemberMyself.presence_name = function (self)
	return self._presence_entry:activity_id()
end

PartyImmateriumMemberMyself.presence_id = function (self)
	return self._presence_entry:activity_id()
end

PartyImmateriumMemberMyself.presence_hud_text = function (self)
	return self._presence_entry:activity_localized()
end

PartyImmateriumMemberMyself.peer_id = function (self)
	return self._peer_id
end

PartyImmateriumMemberMyself.unique_id = function (self)
	return self._unique_id
end

PartyImmateriumMemberMyself.name = function (self)
	return self._presence_entry:character_name()
end

PartyImmateriumMemberMyself.profile = function (self)
	return self._presence_entry:character_profile()
end

PartyImmateriumMemberMyself.account_id = function (self)
	return self._account_id
end

PartyImmateriumMemberMyself.destroy = function (self)
	return
end

PartyImmateriumMemberMyself.is_human_controlled = function (self)
	return true
end

PartyImmateriumMemberMyself.unit_is_alive = function (self)
	return false
end

PartyImmateriumMemberMyself.is_party_player = function (self)
	return true
end

implements(PartyImmateriumMemberMyself, PartyMemberInterface)

return PartyImmateriumMemberMyself
