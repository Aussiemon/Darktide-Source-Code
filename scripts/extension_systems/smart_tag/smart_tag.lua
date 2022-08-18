local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local projectile_valid_interaction_states = ProjectileLocomotionSettings.valid_interaction_states
local SmartTag = class("SmartTag")
local REMOVE_TAG_REASONS = table.enum("canceled_by_owner", "expired", "group_limit_exceeded", "tagged_unit_removed", "tagged_unit_died", "invalid_interaction_state", "health_station_depleted", "smart_tag_system_destroyed")
SmartTag.REMOVE_TAG_REASONS = REMOVE_TAG_REASONS

SmartTag.init = function (self, tag_id, template, tagger_unit, target_unit, target_location, replies)
	fassert(target_unit or target_location, "Must supply either target_unit or target_location")
	fassert(not target_unit or not target_location, "Can't supply both target_unit and target_location")

	self._id = tag_id
	self._template = template
	self._tagger_unit = tagger_unit
	self._target_unit = target_unit

	if target_location then
		self._target_location = Vector3Box(target_location)
	end

	self._tagger_player = Managers.state.player_unit_spawn:owner(tagger_unit)
	self._replies = replies or {}
end

SmartTag.destroy = function (self)
	self._tagger_unit = nil
	self._tagger_player = nil
	self._template = nil
	self._target_unit = nil
	self._target_location = nil
	self._replies = nil
end

SmartTag.id = function (self)
	return self._id
end

SmartTag.template = function (self)
	return self._template
end

SmartTag.group = function (self)
	return self._template.group
end

SmartTag.target_unit = function (self)
	return self._target_unit
end

SmartTag.target_location = function (self)
	local target_location = self._target_location

	if target_location then
		return target_location:unbox()
	end
end

SmartTag.display_name = function (self)
	local target_unit = self._target_unit

	if target_unit then
		local smart_tag_extension = ScriptUnit.has_extension(target_unit, "smart_tag_system")

		return smart_tag_extension:display_name()
	end

	local template = self._template

	return template.display_name
end

SmartTag.tagger_unit = function (self)
	return self._tagger_unit
end

SmartTag.tagger_player = function (self)
	return self._tagger_player
end

SmartTag.set_expire_time = function (self, expire_time)
	self._expire_time = expire_time
end

SmartTag.expire_time = function (self)
	return self._expire_time
end

SmartTag.clear_tagger = function (self)
	self._tagger_unit = nil
	self._tagger_player = nil
end

SmartTag.add_reply = function (self, replier_unit, reply)
	self._replies[replier_unit] = reply
end

SmartTag.remove_reply = function (self, replier_unit)
	self._replies[replier_unit] = nil
end

SmartTag.replies = function (self)
	return self._replies
end

SmartTag.available_replies = function (self)
	return self._template.replies
end

SmartTag.default_reply = function (self)
	local replies = self._template.replies
	local reply = replies and replies[1]

	return reply
end

SmartTag.is_cancelable = function (self)
	return self._template.is_cancelable
end

SmartTag.is_valid = function (self, t)
	if self._expire_time <= t then
		return false, REMOVE_TAG_REASONS.expired
	end

	local target_unit = self._target_unit

	if target_unit then
		return self.validate_target_unit(target_unit)
	else
		return true
	end
end

SmartTag.validate_target_unit = function (target_unit)
	local target_type = Unit.get_data(target_unit, "smart_tag_target_type")

	if target_type == "pickup" then
		local locomotion_extension = ScriptUnit.has_extension(target_unit, "locomotion_system")

		if locomotion_extension then
			local current_state = locomotion_extension:current_state()

			if current_state and not projectile_valid_interaction_states[current_state] then
				return false, REMOVE_TAG_REASONS.invalid_interaction_state
			end
		end
	elseif target_type == "breed" then
		if not HEALTH_ALIVE[target_unit] then
			return false, REMOVE_TAG_REASONS.tagged_unit_died
		end
	elseif target_type == "health_station" then
		local health_station_extension = ScriptUnit.extension(target_unit, "health_station_system")
		local has_battery = health_station_extension:battery_in_slot()

		if has_battery then
			local charge_amount = health_station_extension:charge_amount()

			if charge_amount == 0 then
				return false, REMOVE_TAG_REASONS.health_station_depleted
			end
		end
	end

	return true
end

SmartTag.target_unit_outline = function (self)
	return self._template.target_unit_outline
end

return SmartTag
