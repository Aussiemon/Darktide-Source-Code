local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Threat = require("scripts/utilities/threat")
local MinionSuppressionExtension = class("MinionSuppressionExtension")

MinionSuppressionExtension._init_blackboard_components = function (self, blackboard, breed)
	local suppress_config = breed.suppress_config

	fassert(suppress_config, "No suppress_config specified for breed: %s that has a MinionSuppressionExtension", breed.name)

	self._max_suppress_value = suppress_config.max_value
	self._suppress_threshold = suppress_config.threshold
	self._flinch_threshold = suppress_config.flinch_threshold or 0
	self._suppression_types_allowed = suppress_config.suppression_types_allowed
	self._suppress_decay_speeds = suppress_config.decay_speeds
	self._suppressed_immunity_t = 0
	self._suppressed_immunity_duration = suppress_config.immunity_duration or {
		0,
		0
	}
	local suppression_component = Blackboard.write_component(blackboard, "suppression")
	suppression_component.suppress_value = 0
	suppression_component.is_suppressed = false

	suppression_component.direction:store(0, 0, 0)

	self._suppression_component = suppression_component
	local behavior_component = blackboard.behavior
	self._behavior_component = behavior_component
	self._next_suppress_decay_t = 0
	self._attack_delay = 0
	self._is_suppressed = false
end

MinionSuppressionExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, nil_or_game_object_id)
	local is_server = extension_init_context.is_server

	assert(is_server, "MinionSuppressionExtension should only exist on the server")

	local blackboard = BLACKBOARDS[unit]
	self._blackboard = blackboard
	local breed = extension_init_data.breed
	self._breed = breed
	self._perception_extension = ScriptUnit.extension(unit, "perception_system")

	self:_init_blackboard_components(blackboard, breed)

	local suppress_config = breed.suppress_config
	self._suppress_config = suppress_config
	self._threat_factor = suppress_config.threat_factor
	self._unit = unit
	self._game_object_id = nil_or_game_object_id
end

MinionSuppressionExtension.game_object_initialized = function (self, game_session, game_object_id)
	self._game_object_id = game_object_id
end

MinionSuppressionExtension.hot_join_sync = function (self, unit, sender, channel)
	local is_suppressed = self._is_suppressed

	if is_suppressed then
		RPC.rpc_server_reported_unit_suppression(channel, self._game_object_id, is_suppressed)
	end
end

MinionSuppressionExtension.update = function (self, unit, dt, t)
	local blackboard = self._blackboard

	self:_update_suppression(unit, blackboard, dt, t)
end

local DEFAULT_SUPPRESS_DECAY = 0.2
local FLINCH_FREQUENCY_RANGE = {
	0.4,
	0.6
}

MinionSuppressionExtension.add_suppress_value = function (self, value, type, attack_delay, direction, attacking_unit)
	local t = Managers.time:time("gameplay")

	if t < self._suppressed_immunity_t then
		return
	end

	local suppression_types_allowed = self._suppression_types_allowed

	if suppression_types_allowed and not suppression_types_allowed[type] then
		return
	end

	local config = self._suppress_config

	if config.require_line_of_sight then
		local has_line_of_sight = self._perception_extension:has_line_of_sight(attacking_unit)

		if not has_line_of_sight then
			return
		end
	end

	local suppression_component = self._suppression_component
	local current_suppress_value = suppression_component.suppress_value
	local threshold, max_value = self:_get_threshold_and_max_value()
	local new_value = math.min(current_suppress_value + value, max_value)
	local was_suppressed = suppression_component.is_suppressed
	suppression_component.suppress_value = new_value
	suppression_component.is_suppressed = threshold <= new_value

	suppression_component.direction:store(direction)

	local breed = self._breed

	if new_value < 2 then
		self._attack_delay = 0
	else
		self._attack_delay = (breed.ignore_attack_delay and 0) or attack_delay
	end

	local is_suppressed = suppression_component.is_suppressed
	local entered_suppressed = is_suppressed and not was_suppressed

	if entered_suppressed then
		self:handle_unit_suppression(is_suppressed)
	end

	local combat_range = self._behavior_component.combat_range
	local decay = self._suppress_decay_speeds[combat_range] or DEFAULT_SUPPRESS_DECAY
	self._next_suppress_decay_t = t + math.random() * 0.25 + decay

	if not is_suppressed and self._flinch_threshold <= new_value and (not self._next_flinch_t or self._next_flinch_t < t) then
		self:_play_flinch_anim(breed, direction)

		self._next_flinch_t = t + math.random_range(FLINCH_FREQUENCY_RANGE[1], FLINCH_FREQUENCY_RANGE[2])
	end

	local threat_factor = self._threat_factor

	if threat_factor then
		local threat = value * threat_factor

		Threat.add_flat_threat(self._unit, attacking_unit, threat)
	end
end

local DEFAULT_FLINCH_ANIM_EVENTS = {
	default = "flinch_reaction_down",
	left = "flinch_reaction_right",
	right = "flinch_reaction_left"
}

MinionSuppressionExtension._play_flinch_anim = function (self, breed, direction)
	local unit = self._unit
	local rotation = Unit.local_rotation(unit, 1)
	local forward = Quaternion.forward(rotation)
	local right = Quaternion.right(rotation)
	local right_dot = Vector3.dot(right, direction)
	local fwd_dot = Vector3.dot(forward, direction)
	local abs_right = math.abs(right_dot)
	local abs_fwd = math.abs(fwd_dot)
	local flinch_anims = breed.flinch_anim_events or DEFAULT_FLINCH_ANIM_EVENTS
	local flinch_anim = nil

	if abs_fwd < abs_right and right_dot > 0 then
		flinch_anim = flinch_anims.right
	elseif abs_fwd < abs_right then
		flinch_anim = flinch_anims.left
	else
		flinch_anim = flinch_anims.default
	end

	if Unit.has_animation_event(unit, flinch_anim) then
		local animation_extension = ScriptUnit.extension(unit, "animation_system")

		animation_extension:anim_event(flinch_anim)
	end
end

MinionSuppressionExtension._update_suppression = function (self, unit, blackboard, dt, t)
	local suppression_component = self._suppression_component
	local current_suppress_value = suppression_component.suppress_value
	local suppress_threshold = self:_get_threshold_and_max_value()
	local was_suppressed = suppress_threshold <= current_suppress_value

	if current_suppress_value > 0 and self._next_suppress_decay_t < t then
		local suppression_config = self._suppress_config
		local decay_amount = suppression_config.decay_amount or 1
		suppression_component.suppress_value = math.max(suppression_component.suppress_value - decay_amount, 0)
		local combat_range = self._behavior_component.combat_range
		local decay = self._suppress_decay_speeds[combat_range] or DEFAULT_SUPPRESS_DECAY
		self._next_suppress_decay_t = t + decay
	end

	local is_suppressed = suppress_threshold <= suppression_component.suppress_value
	suppression_component.is_suppressed = is_suppressed
	self._attack_delay = math.max(self._attack_delay - dt, 0)
	local exited_suppressed = not is_suppressed and was_suppressed

	if exited_suppressed then
		self._suppressed_immunity_t = t + math.random_range(self._suppressed_immunity_duration[1], self._suppressed_immunity_duration[2])

		self:handle_unit_suppression(is_suppressed)
	end
end

MinionSuppressionExtension._get_threshold_and_max_value = function (self)
	local threshold = self._suppress_threshold
	local combat_range = self._behavior_component.combat_range

	if type(threshold) == "table" then
		threshold = threshold[combat_range]
	end

	local max_value = self._max_suppress_value

	if type(max_value) == "table" then
		max_value = max_value[combat_range]
	end

	return threshold, max_value
end

MinionSuppressionExtension.handle_unit_suppression = function (self, is_suppressed)
	local unit = self._unit

	Managers.event:trigger("event_unit_suppression", unit, is_suppressed)

	local suppressed_unit_id = self._game_object_id

	Managers.state.game_session:send_rpc_clients("rpc_server_reported_unit_suppression", suppressed_unit_id, is_suppressed)

	self._is_suppressed = is_suppressed
end

MinionSuppressionExtension.is_suppressed = function (self)
	return self._is_suppressed
end

MinionSuppressionExtension.attack_delay = function (self)
	return self._attack_delay
end

return MinionSuppressionExtension
