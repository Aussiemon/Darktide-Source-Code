local MoodSettings = require("scripts/settings/camera/mood/mood_settings")
local Suppression = require("scripts/utilities/attack/suppression")
local Vo = require("scripts/utilities/vo")
local WeaponMovementState = require("scripts/extension_systems/weapon/utilities/weapon_movement_state")
local mood_types = MoodSettings.mood_types
local PlayerSuppressionExtension = class("PlayerSuppressionExtension")
local MAX_SUPPRESSION_HITS = 15
local NUM_HITS_FOR_LOW_SUPPRESSION = 3
local NUM_HITS_FOR_HIGH_SUPPRESSION = 10
local SUPPRESSION_HIT_CLEAR_TIME = 0.03
local SUPPRESSION_HIT_CLEAR_AMOUNT = 0.1
local _add_to_clear_time = nil
local CLIENT_RPCS = {
	"rpc_player_suppressed"
}

PlayerSuppressionExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	self._world = extension_init_context.world
	self._unit = unit
	local is_server = extension_init_context.is_server
	local is_local_unit = extension_init_data.is_local_unit
	local player = extension_init_data.player

	if not is_server then
		local network_event_delegate = extension_init_context.network_event_delegate
		self._network_event_delegate = network_event_delegate
		self._game_object_id = nil_or_game_object_id

		self._network_event_delegate:register_session_unit_events(self, nil_or_game_object_id, unpack(CLIENT_RPCS))
	elseif is_server then
		self._channel_id = player:channel_id()
	end

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._num_suppression_hits = 0
	self._suppression_hit_clear_timer = 0

	if is_server then
		self._movement_state_component = unit_data_extension:write_component("movement_state")
		self._weapon_extension = ScriptUnit.extension(unit, "weapon_system")
	end

	self._max_suppression = math.floor(MAX_SUPPRESSION_HITS / 2)
	self._is_server = is_server
	self._is_local_unit = is_local_unit
	self._player = player
	self._first_person_extension = ScriptUnit.extension(unit, "first_person_system")

	if is_server or is_local_unit then
		local suppression_component = unit_data_extension:write_component("suppression")
		suppression_component.sway_pitch = 0
		suppression_component.sway_yaw = 0
		suppression_component.spread_pitch = 0
		suppression_component.spread_yaw = 0
		suppression_component.time = 0
		suppression_component.decay_time = 0
		self._suppression_component = suppression_component
	end

	self._suppression_delay = 0
end

PlayerSuppressionExtension.extensions_ready = function (self, world, unit)
	self._buff_extension = ScriptUnit.extension(unit, "buff_system")
	self._mood_extension = ScriptUnit.has_extension(unit, "mood_system")
end

PlayerSuppressionExtension.game_object_initialized = function (self, game_session, game_object_id)
	self._game_object_id = game_object_id
end

PlayerSuppressionExtension.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(CLIENT_RPCS))
	end
end

PlayerSuppressionExtension.fixed_update = function (self, unit, dt, t)
	self:_update_suppression_hits(dt, t)

	if self._is_server then
		self._suppression_delay = math.max(self._suppression_delay - dt, 0)
	end
end

PlayerSuppressionExtension._update_suppression_hits = function (self, dt, t)
	local num_suppression_hits = self._num_suppression_hits
	local suppression_hit_clear_timer = self._suppression_hit_clear_timer

	if num_suppression_hits > 0 then
		if suppression_hit_clear_timer then
			suppression_hit_clear_timer = suppression_hit_clear_timer - dt

			if suppression_hit_clear_timer <= 0 then
				suppression_hit_clear_timer = nil
			end
		end

		if not suppression_hit_clear_timer then
			num_suppression_hits = math.max(num_suppression_hits - SUPPRESSION_HIT_CLEAR_AMOUNT, 0)
			suppression_hit_clear_timer = _add_to_clear_time(num_suppression_hits)
		end

		self._num_suppression_hits = num_suppression_hits
		self._suppression_hit_clear_timer = suppression_hit_clear_timer
	end
end

PlayerSuppressionExtension.add_suppression = function (self, suppression_hit_cost, hit_position)
	local is_server = self._is_server

	if not is_server then
		return
	end

	local suppression_immune = self._buff_extension:has_keyword("suppression_immune")

	if suppression_immune then
		return
	end

	local t = Managers.time:time("gameplay")
	local previous_num_suppression_hits = self._num_suppression_hits
	local num_suppression_hits = math.min(previous_num_suppression_hits + suppression_hit_cost, MAX_SUPPRESSION_HITS)
	local suppression_hit_clear_timer = nil

	if num_suppression_hits <= NUM_HITS_FOR_HIGH_SUPPRESSION then
		suppression_hit_clear_timer = _add_to_clear_time(num_suppression_hits)
	end

	local mood_extension = self._mood_extension

	if is_server and mood_extension then
		local passed_low = previous_num_suppression_hits < NUM_HITS_FOR_LOW_SUPPRESSION and NUM_HITS_FOR_LOW_SUPPRESSION <= num_suppression_hits
		local passed_high = previous_num_suppression_hits < NUM_HITS_FOR_HIGH_SUPPRESSION and NUM_HITS_FOR_HIGH_SUPPRESSION <= num_suppression_hits

		if passed_low then
			mood_extension:add_timed_mood(t, mood_types.suppression_low)
		elseif passed_high then
			mood_extension:add_timed_mood(t, mood_types.suppression_high)
		end
	end

	if not self._is_local_unit then
		Managers.state.game_session:send_rpc_clients("rpc_player_suppressed", self._game_object_id, num_suppression_hits)
	end

	if NUM_HITS_FOR_LOW_SUPPRESSION <= num_suppression_hits and self._suppression_delay <= 0 then
		local weapon_extension = self._weapon_extension
		local movement_state_component = self._movement_state_component
		local suppression_component = self._suppression_component
		local suppression_template = weapon_extension:suppression_template()
		local movement_state = WeaponMovementState.translate_movement_state_component(movement_state_component)
		local suppression_movement_template = nil

		if suppression_template and suppression_component then
			suppression_movement_template = suppression_template[movement_state]

			Suppression.add_immediate_suppression(t, suppression_movement_template, suppression_component, math.floor(1 + num_suppression_hits - NUM_HITS_FOR_LOW_SUPPRESSION))

			self._suppression_delay = suppression_movement_template.delay
		else
			self._suppression_delay = 1
		end

		Vo.player_suppressed_event(self._unit)
	end

	self._num_suppression_hits = num_suppression_hits
	self._suppression_hit_clear_timer = suppression_hit_clear_timer
end

PlayerSuppressionExtension.rpc_player_suppressed = function (self, channel_id, unit_id, num_suppression_hits)
	self._num_suppression_hits = num_suppression_hits
	self._next_suppression_hit_clear_time = _add_to_clear_time(num_suppression_hits)
end

PlayerSuppressionExtension.num_suppression_hits = function (self)
	return self._num_suppression_hits
end

PlayerSuppressionExtension.has_suppression = function (self)
	return self._num_suppression_hits > 0
end

PlayerSuppressionExtension.has_low_suppression = function (self)
	return NUM_HITS_FOR_LOW_SUPPRESSION <= self._num_suppression_hits
end

PlayerSuppressionExtension.has_high_suppression = function (self)
	return NUM_HITS_FOR_HIGH_SUPPRESSION <= self._num_suppression_hits
end

PlayerSuppressionExtension.max_suppression = function (self)
	return self._max_suppression
end

PlayerSuppressionExtension.wwise_suppression_state = function (self)
	local num_suppression_hits = self._num_suppression_hits

	if NUM_HITS_FOR_HIGH_SUPPRESSION <= num_suppression_hits then
		return "high"
	elseif NUM_HITS_FOR_LOW_SUPPRESSION <= num_suppression_hits then
		return "low"
	else
		return "none"
	end
end

PlayerSuppressionExtension.clear_suppression = function (self)
	if self._is_server or self._is_local_unit then
		local suppression_component = self._suppression_component
		suppression_component.sway_pitch = 0
		suppression_component.sway_yaw = 0
		suppression_component.spread_pitch = 0
		suppression_component.spread_yaw = 0
		suppression_component.time = 0
		suppression_component.decay_time = 0
	end

	self._num_suppression_hits = 0
	self._next_suppression_hit_clear_time = 0
end

function _add_to_clear_time(num_suppression_hits)
	local extra_clear_time_multiplier = 1 - math.min(num_suppression_hits, 5) / 5
	local new_clear_timer = SUPPRESSION_HIT_CLEAR_TIME + SUPPRESSION_HIT_CLEAR_TIME * extra_clear_time_multiplier

	return new_clear_timer
end

return PlayerSuppressionExtension
