local PlayerAssistNotifications = require("scripts/utilities/player_assist_notifications")
local Assist = class("Assist")
local FORCE_ASSIST_TIME = 0.75

Assist.init = function (self, anim_settings, is_server, unit, game_session_or_nil, game_object_id_or_nil)
	self._is_server = is_server
	self._unit = unit
	self._game_session = game_session_or_nil
	self._game_object_id = game_object_id_or_nil
	self._anim_settings = anim_settings
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._animation_extension = ScriptUnit.extension(unit, "animation_system")
	self._interactee_extension = ScriptUnit.extension(unit, "interactee_system")
	self._interactee_component = unit_data_extension:read_component("interactee")
	self._assisted_state_input_component = unit_data_extension:write_component("assisted_state_input")

	self:reset()
end

Assist.game_object_initialized = function (self, game_session, game_object_id)
	self._game_session = game_session
	self._game_object_id = game_object_id
end

Assist.update = function (self, dt, t)
	local assisted_state_input_component = self._assisted_state_input_component
	local being_assisted = assisted_state_input_component.in_progress
	local assist_done = false
	being_assisted = being_assisted or self:_try_assist_start(dt, t)

	self:_try_start_anim()

	if being_assisted then
		assist_done = self:_update_assist(dt, t)
	end

	self:_try_abort_anim()

	self._was_in_progress = assisted_state_input_component.in_progress

	return assist_done
end

Assist._try_assist_start = function (self, dt, t, force)
	local start_assist = self._interactee_component.interacted_with or self._assisted_state_input_component.force_assist

	if start_assist then
		self._assisted_state_input_component.in_progress = true
		self._assisted_state_input_component.success = false
	end

	return start_assist
end

Assist._update_assist = function (self, dt, t)
	self:_synchronize_interaction_duration()

	local force_assist = self._assisted_state_input_component.force_assist
	local being_assisted = self._interactee_component.interacted_with
	local assist_successful = self._assisted_state_input_component.success

	if not being_assisted and not assist_successful and not force_assist then
		self:stop()
	end

	if force_assist then
		assist_successful = assist_successful or self:_update_force_assist(dt)
	end

	return assist_successful
end

Assist._try_start_anim = function (self)
	local assisted_state_input_component = self._assisted_state_input_component
	local was_in_progress = self._was_in_progress
	local in_progress = assisted_state_input_component.in_progress
	local interactee_extension = self._interactee_extension
	local force_assist = self._assisted_state_input_component.force_assist
	local duration = force_assist and FORCE_ASSIST_TIME or interactee_extension:interaction_length()

	if not was_in_progress and in_progress then
		local anim_event = self._anim_settings.start_anim_event

		if anim_event then
			self._animation_extension:anim_event_with_variable_float(anim_event, "assist_interaction_duration", duration)
		end
	end

	if self._is_server then
		local game_session = self._game_session
		local game_object_id = self._game_object_id

		GameSession.set_game_object_field(game_session, game_object_id, "assist_interaction_duration", duration)
	end
end

Assist._try_abort_anim = function (self)
	local assisted_state_input_component = self._assisted_state_input_component
	local interactee_component = self._interactee_component
	local was_in_progress = self._was_in_progress
	local in_progress = assisted_state_input_component.in_progress
	local success = assisted_state_input_component.success
	local being_assisted = interactee_component.interacted_with

	if was_in_progress and (not in_progress or not being_assisted) and not success then
		local anim_event = self._anim_settings.abort_anim_event

		if anim_event then
			self._animation_extension:anim_event(anim_event)
		end
	end
end

Assist.stop = function (self)
	self._assisted_state_input_component.in_progress = false
	self._assisted_state_input_component.force_assist = false
end

Assist.reset = function (self)
	self._was_in_progress = false
	self._assisted_state_input_component.in_progress = false
	self._assisted_state_input_component.success = false
	self._assisted_state_input_component.force_assist = false
	self._force_assist_timer = 0
	self._last_interactor_unit = nil
end

Assist.in_progress = function (self)
	return self._assisted_state_input_component.in_progress
end

Assist._synchronize_interaction_duration = function (self)
	if self._is_server then
		return
	end

	local unit = self._unit
	local game_session = self._game_session
	local game_object_id = self._game_object_id
	local variable_id = Unit.animation_find_variable(unit, "assist_interaction_duration")
	local current_duration = GameSession.game_object_field(game_session, game_object_id, "assist_interaction_duration")
	local old_duration = Unit.animation_get_variable(unit, variable_id)

	if current_duration ~= old_duration then
		Unit.animation_set_variable(unit, variable_id, current_duration)
	end
end

Assist._update_force_assist = function (self, dt)
	if self._force_assist_timer <= FORCE_ASSIST_TIME then
		self._force_assist_timer = self._force_assist_timer + dt

		return false
	else
		self._force_assist_timer = 0
		self._assisted_state_input_component.force_assist = false

		return true
	end
end

return Assist
