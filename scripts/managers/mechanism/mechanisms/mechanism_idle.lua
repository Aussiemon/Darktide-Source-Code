local MechanismBase = require("scripts/managers/mechanism/mechanisms/mechanism_base")
local MechanismIdle = class("MechanismIdle", "MechanismBase")

MechanismIdle.init = function (self, ...)
	MechanismIdle.super.init(self, ...)
end

MechanismIdle.game_mode_end = function (self, outcome)
	ferror("Idle doesn't handle game_mode_end, need to choose new mechanism.")
end

MechanismIdle.sync_data = function (self)
	return
end

MechanismIdle.wanted_transition = function (self)
	return false, false
end

MechanismIdle.is_allowed_to_reserve_slots = function (self, peer_ids)
	return false
end

MechanismIdle.peers_reserved_slots = function (self, peer_ids)
	return
end

MechanismIdle.peer_freed_slot = function (self, peer_id)
	return
end

implements(MechanismIdle, MechanismBase.INTERFACE)

return MechanismIdle
