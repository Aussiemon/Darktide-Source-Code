-- chunkname: @scripts/extension_systems/suppression/minion_suppression_extension.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Threat = require("scripts/utilities/threat")
local MinionSuppressionExtension = class("MinionSuppressionExtension")
local _get_suppresor_decay_multiplier

MinionSuppressionExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, nil_or_game_object_id)
	local is_server = extension_init_context.is_server
	local blackboard = BLACKBOARDS[unit]

	self._blackboard = blackboard

	local breed = extension_init_data.breed

	self._breed = breed
	self._perception_extension = ScriptUnit.extension(unit, "perception_system")
	self._cover_user_extension = ScriptUnit.has_extension(unit, "cover_system")

	self:_init_blackboard_components(blackboard, breed)

	local suppress_config = breed.suppress_config

	self._suppress_config = suppress_config
	self._threat_factor = suppress_config.threat_factor
	self._enabled = true
	self._unit = unit
	self._game_object_id = nil_or_game_object_id
	self._suppressor_decay_multiplier = 1
end

MinionSuppressionExtension._init_blackboard_components = function (self, blackboard, breed)
	local suppress_config = breed.suppress_config

	self._max_suppress_value = suppress_config.max_value
	self._suppress_threshold = suppress_config.threshold
	self._flinch_threshold = suppress_config.flinch_threshold or 0
	self._suppression_types_allowed = suppress_config.suppression_types_allowed
	self._suppress_decay_speeds = suppress_config.decay_speeds
	self._disable_cover_threshold = suppress_config.disable_cover_threshold
	self._disable_cover_cooldown = 0
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

	if self._cover_user_extension then
		local cover_component = Blackboard.write_component(blackboard, "cover")

		self._cover_component = cover_component
	end

	local behavior_component = blackboard.behavior

	self._behavior_component = behavior_component
	self._next_suppress_decay_t = 0
	self._attack_delay = 0
	self._is_suppressed = false
end

MinionSuppressionExtension.set_enabled = function (self, enabled)
	self._enabled = enabled
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
local DEFAULT_DISABLE_COVER_TIME_RANGE = {
	6,
	10
}
local DEFAULT_DISABLE_COVER_COOLDOWN_RANGE = {
	2,
	4
}

MinionSuppressionExtension.add_suppress_value = function (self, value, suppression_type, attack_delay, direction, attacking_unit)
	if not self._enabled then
		return
	end

	local t = Managers.time:time("gameplay")

	if t < self._suppressed_immunity_t then
		return
	end

	local suppression_types_allowed = self._suppression_types_allowed

	if suppression_types_allowed and not suppression_types_allowed[suppression_type] then
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
		self._attack_delay = self._suppress_config.ignore_attack_delay and 0 or attack_delay
	end

	local is_suppressed = suppression_component.is_suppressed
	local entered_suppressed = is_suppressed and not was_suppressed

	if entered_suppressed then
		self:handle_unit_suppression(is_suppressed)
	end

	local combat_range = self._behavior_component.combat_range
	local decay = self._suppress_decay_speeds[combat_range] or DEFAULT_SUPPRESS_DECAY

	if type(decay) == "table" then
		decay = Managers.state.difficulty:get_table_entry_by_challenge(decay)
	end

	self._next_suppress_decay_t = t + math.random() * 0.25 + decay

	if not is_suppressed and new_value >= self._flinch_threshold and (not self._next_flinch_t or t > self._next_flinch_t) then
		self:_play_flinch_anim(breed, direction)

		self._next_flinch_t = t + math.random_range(FLINCH_FREQUENCY_RANGE[1], FLINCH_FREQUENCY_RANGE[2])
	end

	local threat_factor = self._threat_factor

	if threat_factor then
		local threat = value * threat_factor

		Threat.add_flat_threat(self._unit, attacking_unit, threat)
	end

	if self._cover_user_extension then
		local disable_cover_threshold = self._disable_cover_threshold

		if type(disable_cover_threshold) == "table" then
			disable_cover_threshold = disable_cover_threshold[combat_range]
		end

		if disable_cover_threshold and disable_cover_threshold <= new_value and t > self._disable_cover_cooldown then
			local disable_t = math.random_range(DEFAULT_DISABLE_COVER_TIME_RANGE[1], DEFAULT_DISABLE_COVER_TIME_RANGE[2])

			self._cover_user_extension:release_cover_slot(disable_t)

			local disable_cooldown = math.random_range(DEFAULT_DISABLE_COVER_COOLDOWN_RANGE[1], DEFAULT_DISABLE_COVER_COOLDOWN_RANGE[2])

			self._disable_cover_cooldown = t + disable_cooldown
		end
	end

	self._last_suppressing_unit = attacking_unit

	if entered_suppressed and attacking_unit then
		self._suppressor_decay_multiplier = _get_suppresor_decay_multiplier(attacking_unit)
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
	local flinch_anim

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
	if self._decay_delay then
		self._decay_delay = self._decay_delay - dt

		if self._decay_delay <= 0 then
			self._decay_delay = nil
		else
			return
		end
	end

	local suppression_component = self._suppression_component
	local current_suppress_value = suppression_component.suppress_value
	local suppress_threshold = self:_get_threshold_and_max_value()
	local was_suppressed = suppress_threshold <= current_suppress_value

	if current_suppress_value > 0 and t > self._next_suppress_decay_t then
		local suppression_config = self._suppress_config
		local decay_multiplier = was_suppressed and suppression_config.above_threshold_decay_multiplier or 1
		local suppressor_decay_multiplier = was_suppressed and self._suppressor_decay_multiplier or 1
		local decay_amount = (suppression_config.decay_amount or 1) * decay_multiplier * suppressor_decay_multiplier

		suppression_component.suppress_value = math.max(suppression_component.suppress_value - decay_amount, 0)

		local combat_range = self._behavior_component.combat_range
		local decay = self._suppress_decay_speeds[combat_range] or DEFAULT_SUPPRESS_DECAY

		if type(decay) == "table" then
			decay = Managers.state.difficulty:get_table_entry_by_challenge(decay)
		end

		self._next_suppress_decay_t = t + decay
	end

	local is_suppressed = suppress_threshold <= suppression_component.suppress_value

	suppression_component.is_suppressed = is_suppressed
	self._attack_delay = math.max(self._attack_delay - dt, 0)

	local exited_suppressed = not is_suppressed and was_suppressed

	if exited_suppressed then
		self._suppressed_immunity_t = t + math.random_range(self._suppressed_immunity_duration[1], self._suppressed_immunity_duration[2])

		self:handle_unit_suppression(is_suppressed)

		self._suppressor_decay_multiplier = 1
	end
end

MinionSuppressionExtension._get_threshold_and_max_value = function (self)
	local threshold = self._suppress_threshold
	local combat_range = self._behavior_component.combat_range

	if type(threshold) == "table" then
		threshold = threshold[combat_range]

		if type(threshold) == "table" then
			threshold = Managers.state.difficulty:get_table_entry_by_challenge(threshold)
		end
	end

	local max_value = self._max_suppress_value

	if type(max_value) == "table" then
		max_value = max_value[combat_range]

		if type(max_value) == "table" then
			max_value = Managers.state.difficulty:get_table_entry_by_challenge(max_value)
		end
	end

	return threshold, max_value
end

MinionSuppressionExtension.handle_unit_suppression = function (self, is_suppressed)
	self._is_suppressed = is_suppressed
end

MinionSuppressionExtension.is_suppressed = function (self)
	return self._is_suppressed
end

MinionSuppressionExtension.attack_delay = function (self)
	return self._attack_delay
end

MinionSuppressionExtension.last_suppressing_unit = function (self)
	return self._last_suppressing_unit
end

MinionSuppressionExtension.apply_suppression_decay_delay = function (self, decay_delay)
	self._decay_delay = decay_delay
end

function _get_suppresor_decay_multiplier(attacking_unit)
	local attacking_unit_buff_extension = ScriptUnit.has_extension(attacking_unit, "buff_system")

	if attacking_unit_buff_extension then
		local stat_buffs = attacking_unit_buff_extension:stat_buffs()

		return stat_buffs.suppressor_decay_multiplier or 1
	end

	return 1
end

return MinionSuppressionExtension
