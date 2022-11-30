local PresenceManagerDummy = class("PresenceManagerDummy")
local Promise = require("scripts/foundation/utilities/promise")
local PresenceEntryImmaterium = require("scripts/managers/presence/presence_entry_immaterium")
local PresenceManagerInterface = require("scripts/managers/presence/presence_manager_interface")
local PresenceEntryMyself = require("scripts/managers/presence/presence_entry_myself")

PresenceManagerDummy.init = function (self)
	self._myself = PresenceEntryMyself:new()
end

PresenceManagerDummy.set_party = function (self, party_id, num_party_members)
	return
end

PresenceManagerDummy.update = function (self, dt, t)
	return
end

PresenceManagerDummy.get_presence = function (self, account_id)
	if account_id == self._myself:account_id() then
		return self._myself
	end

	local presence_entry = PresenceEntryImmaterium:new(self._myself:platform(), "", account_id)

	return presence_entry, Promise.resolved(nil)
end

PresenceManagerDummy.get_presence_by_platform = function (self, platform, platform_user_id)
	local presence_entry = PresenceEntryImmaterium:new(self._myself:platform(), platform, platform_user_id)

	return presence_entry, Promise.resolved(nil)
end

PresenceManagerDummy.presence_entry_myself = function (self)
	return self._myself
end

PresenceManagerDummy.get_requested_platform_username = function (self)
	return nil
end

implements(PresenceManagerDummy, PresenceManagerInterface)

return PresenceManagerDummy
