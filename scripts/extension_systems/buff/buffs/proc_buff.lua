require("scripts/extension_systems/buff/buffs/buff")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PROC_EVENTS_STRIDE = BuffSettings.proc_events_stride
local ProcBuff = class("ProcBuff", "Buff")

ProcBuff.init = function (self, context, template, start_time, instance_id, ...)
	ProcBuff.super.init(self, context, template, start_time, instance_id, ...)

	local active_duration = self:_active_duration()
	local cooldown = self:_cooldown_duration() or 0
	self._active_start_time = start_time - (active_duration + cooldown)
	self._active_vfx = {}
	self._num_proc_keywords = template.proc_keywords and #template.proc_keywords
	self._num_inactive_keywords = template.inactive_keywords and #template.inactive_keywords
	self._num_off_cooldown_keywords = template.off_cooldown_keywords and #template.off_cooldown_keywords
end

ProcBuff.set_buff_component = function (self, buff_component, component_keys, component_index)
	ProcBuff.super.set_buff_component(self, buff_component, component_keys, component_index)

	local active_start_time = self._active_start_time
	buff_component = self._buff_component
	local active_start_time_key = component_keys.active_start_time_key
	buff_component[active_start_time_key] = active_start_time
end

ProcBuff.destroy = function (self)
	if self._has_activated then
		local template = self._template
		local template_data = self._template_data
		local template_context = self._template_context
		local end_proc_func = template.proc_end_func

		if end_proc_func then
			end_proc_func(template_data, template_context)
		end
	end

	local buff_component = self._buff_component

	if buff_component then
		local component_keys = self._component_keys
		local active_start_time = component_keys.active_start_time_key
		buff_component[active_start_time] = 0
	end

	local t = FixedFrame.get_latest_fixed_time()

	self:_stop_proc_active_fx(t)
	ProcBuff.super.destroy(self)
end

ProcBuff.active_start_time = function (self)
	return self._active_start_time
end

ProcBuff.set_active_start_time = function (self, active_start_time)
	self._active_start_time = active_start_time
end

ProcBuff.is_proc_active = function (self)
	local t = FixedFrame.get_latest_fixed_time()

	return self:_is_proc_active(t)
end

ProcBuff._is_proc_active = function (self, t)
	if self._template.duration then
		return true
	end

	local active_duration = self:_active_duration()
	local active_start_time = self._active_start_time
	local is_active = t < active_start_time + active_duration

	return is_active
end

ProcBuff._active_duration = function (self)
	local active_duration = self._template.active_duration or 0
	local template_override_data = self._template_override_data

	if template_override_data then
		active_duration = template_override_data.active_duration or active_duration
	end

	return active_duration
end

ProcBuff.duration_progress = function (self)
	local template = self._template
	local custom_duration_func = template.duration_func

	if custom_duration_func then
		return custom_duration_func(self._template_data, self._template_context)
	end

	if template.duration then
		return self._duration_progress
	end

	local has_cooldown = template.cooldown_duration
	local has_active_duration = template.active_duration
	local t = FixedFrame.get_latest_fixed_time()

	if has_cooldown and self:_is_cooling_down(t) then
		return self:_cooldown_progress(t)
	elseif has_active_duration and not has_cooldown and not self:_is_proc_active(t) then
		return 0.001
	end

	return 1 - self:activate_percentage(t)
end

ProcBuff.activate_percentage = function (self, t)
	local is_active = self:_is_proc_active(t)
	local active_duration = self:_active_duration()

	if is_active and active_duration > 0 then
		local current_time = t - self._active_start_time
		local percentage = current_time / active_duration

		return percentage
	end

	return 0
end

ProcBuff._is_cooling_down = function (self, t)
	local active_cooldown = self:_cooldown_duration() or 0
	local active_duration = self:_active_duration()
	local active_start_time = self._active_start_time

	if self:_is_proc_active(t) then
		return false
	end

	local is_cooling_down = t < active_start_time + active_duration + active_cooldown

	return is_cooling_down
end

ProcBuff._cooldown_progress = function (self, t)
	local active_cooldown = self:_cooldown_duration() or 0
	local active_start_time = self._active_start_time
	local time_lapsed = t - active_start_time

	return time_lapsed / active_cooldown
end

ProcBuff._can_activate = function (self, t)
	local cooldown = self:_cooldown_duration()
	local has_cooldown = cooldown ~= nil

	if has_cooldown then
		local is_active = self:_is_proc_active(t) and not self._template.allow_proc_while_active
		local is_cooling_down = self:_is_cooling_down(t)

		return not is_active and not is_cooling_down
	end

	return true
end

ProcBuff._cooldown_duration = function (self)
	local template = self._template
	local cooldown_duration = template.cooldown_duration
	local template_override_data = self._template_override_data

	if template_override_data then
		cooldown_duration = template_override_data.cooldown_duration or cooldown_duration
	end

	return cooldown_duration
end

ProcBuff.update = function (self, dt, t, portable_random)
	ProcBuff.super.update(self, dt, t, portable_random)

	local template = self._template
	local template_data = self._template_data
	local template_context = self._template_context
	template_context.active_percentage = self:activate_percentage(t)
	local is_active = self:_is_proc_active(t)
	local has_activated = self._has_activated
	local proc_update_func = template.proc_update_func

	if is_active and proc_update_func then
		proc_update_func(dt, t, template_data, template_context)
	end

	if not has_activated and is_active then
		self._has_activated = true

		self:_start_proc_fx()
		self:_start_proc_active_fx()

		if not template.always_show_in_hud and not template.duration then
			local player = self._player

			Managers.event:trigger("event_player_buff_proc_start", player, self)
		end
	elseif has_activated and not is_active then
		self._has_activated = false

		self:_stop_proc_active_fx(t)

		local proc_end_func = template.proc_end_func

		if proc_end_func then
			proc_end_func(template_data, template_context)
		end

		if not template.always_show_in_hud and not template.duration then
			local player = self._player

			Managers.event:trigger("event_player_buff_proc_stop", player, self)
		end
	end
end

ProcBuff._can_add_stat_and_keywords = function (self, t)
	local template = self._template
	local conditional_proc_func = template.conditional_proc_func
	local condition_ok = not conditional_proc_func or conditional_proc_func(self._template_data, self._template_context)
	local is_active = self:_is_proc_active(t) and condition_ok

	return is_active
end

ProcBuff.update_keywords = function (self, current_key_words, t)
	ProcBuff.super.update_keywords(self, current_key_words)

	local template = self._template

	if self:_can_add_stat_and_keywords(t) then
		if self._num_proc_keywords then
			local proc_keywords = template.proc_keywords

			for i = 1, self._num_proc_keywords do
				current_key_words[proc_keywords[i]] = true
			end
		end
	elseif self._num_inactive_keywords then
		local inactive_keywords = template.inactive_keywords

		for i = 1, self._num_inactive_keywords do
			current_key_words[inactive_keywords[i]] = true
		end
	end

	if self._num_off_cooldown_keywords and not self:_is_cooling_down(t) then
		local off_cooldown_keywords = template.off_cooldown_keywords

		for i = 1, self._num_off_cooldown_keywords do
			current_key_words[off_cooldown_keywords[i]] = true
		end
	end

	return current_key_words
end

ProcBuff.update_stat_buffs = function (self, current_stat_buffs, t)
	ProcBuff.super.update_stat_buffs(self, current_stat_buffs, t)

	local template = self._template
	local is_active = self:_can_add_stat_and_keywords(t)
	local template_override_data = self._template_override_data
	local override_proc_stat_buffs = template_override_data and template_override_data.proc_stat_buffs
	local proc_stat_buffs = override_proc_stat_buffs or template.proc_stat_buffs

	if proc_stat_buffs and is_active then
		self:_calculate_stat_buffs(current_stat_buffs, proc_stat_buffs)
	end
end

local PROCCED_PROC_EVENTS = {}

ProcBuff.update_proc_events = function (self, t, proc_events, num_proc_events, portable_random, local_portable_random)
	local template = self._template
	local activated_proc = false
	local procced_proc_events = PROCCED_PROC_EVENTS

	table.clear(procced_proc_events)

	for i = 1, num_proc_events * PROC_EVENTS_STRIDE, PROC_EVENTS_STRIDE do
		local proc_event_name = proc_events[i]
		local params = proc_events[i + 1]
		local proc_chance = self:_proc_chance(proc_event_name)
		local is_local_proc_event = params.is_local_proc_event
		local is_predicted_buff = template.predicted
		local template_data = self._template_data
		local template_context = self._template_context
		local conditional_proc_func = template.conditional_proc_func
		local condition_ok = proc_chance and (not conditional_proc_func or conditional_proc_func(template_data, template_context, t))
		local can_activate = self:_can_activate(t)

		if proc_chance and condition_ok and can_activate then
			local portable_random_to_use = (is_local_proc_event or not is_predicted_buff) and local_portable_random or portable_random
			local will_proc = proc_chance == 1
			local random_value = will_proc and 0 or portable_random_to_use:next_random()

			if random_value < proc_chance then
				local specific_proc_check = template.specific_check_proc_funcs and template.specific_check_proc_funcs[proc_event_name]
				local check_proc_func = specific_proc_check or template.check_proc_func
				local is_check_ok = not check_proc_func or check_proc_func(params, template_data, template_context, t)

				if is_check_ok then
					local proc_func = template.proc_func

					if proc_func then
						proc_func(params, template_data, template_context, t)
					end

					procced_proc_events[proc_event_name] = true

					if not is_local_proc_event then
						activated_proc = true
						self._active_start_time = t
						local buff_component = self._buff_component

						if buff_component then
							local component_keys = self._component_keys
							local active_start_time_key = component_keys.active_start_time_key
							buff_component[active_start_time_key] = t
						end
					end
				end

				local specific_proc_func = template.specific_proc_func

				if specific_proc_func and specific_proc_func[proc_event_name] then
					local func = specific_proc_func[proc_event_name]

					func(params, template_data, template_context, t)
				end

				local proc_extends_time = template.proc_extends_time

				if proc_extends_time then
					local time = template.proc_extends_time_func(template_data, template_context)
					local start_time = self:start_time()

					self:set_start_time(start_time + time)
				end
			end
		end
	end

	return activated_proc, procced_proc_events
end

ProcBuff._proc_chance = function (self, proc_event_name)
	local template = self._template
	local proc_events = template.proc_events
	local template_override_data = self._template_override_data
	local override_proc_events = template_override_data and template_override_data.proc_events
	local chance = override_proc_events and override_proc_events[proc_event_name] or proc_events[proc_event_name]

	return chance
end

ProcBuff._start_proc_fx = function (self)
	local template_context = self._template_context
	local template = self._template
	local wwise_world = template_context.wwise_world
	local proc_effects = template.proc_effects
	local is_local_unit = template_context.is_local_unit

	if proc_effects then
		local player_effects = proc_effects.player_effects
		local player_wwise_proc_event = player_effects and player_effects.wwise_proc_event

		if is_local_unit and player_wwise_proc_event then
			WwiseWorld.trigger_resource_event(wwise_world, player_wwise_proc_event)
		end
	end
end

ProcBuff._start_proc_active_fx = function (self)
	local template_context = self._template_context
	local template = self._template
	local world = template_context.world
	local wwise_world = template_context.wwise_world
	local active_vfx = self._active_vfx
	local proc_effects = template.proc_effects

	if proc_effects then
		local is_local_unit = template_context.is_local_unit
		local player_effects = proc_effects.player_effects

		if player_effects and is_local_unit then
			local on_screen_effect = player_effects.on_screen_effect

			if on_screen_effect then
				local on_screen_effect_id = World.create_particles(world, on_screen_effect, Vector3(0, 0, 1))
				local stop_type = "destroy"

				table.insert(active_vfx, {
					particle_id = on_screen_effect_id,
					stop_type = stop_type
				})
			end

			local player_looping_wwise_start_event = player_effects.looping_wwise_start_event

			if player_looping_wwise_start_event then
				WwiseWorld.trigger_resource_event(wwise_world, player_looping_wwise_start_event)
			end

			local wwise_state = player_effects.wwise_state

			if wwise_state then
				Wwise.set_state(wwise_state.group, wwise_state.on_state)
			end
		end
	end
end

ProcBuff._stop_proc_active_fx = function (self, t)
	local template = self._template
	local template_context = self._template_context
	local world = template_context.world
	local wwise_world = template_context.wwise_world
	local active_vfx = self._active_vfx

	for i = 1, #active_vfx do
		local effect = active_vfx[i]
		local particle_id = effect.particle_id
		local stop_type = effect.stop_type

		if stop_type == "stop" then
			World.stop_spawning_particles(world, particle_id)
		else
			World.destroy_particles(world, particle_id)
		end
	end

	table.clear(active_vfx)

	local proc_effects = template.proc_effects

	if proc_effects then
		local is_local_unit = template_context.is_local_unit
		local player_effects = proc_effects.player_effects

		if player_effects and is_local_unit then
			local player_looping_wwise_stop_event = player_effects.looping_wwise_stop_event

			if player_looping_wwise_stop_event and self:_is_proc_active(t) then
				WwiseWorld.trigger_resource_event(wwise_world, player_looping_wwise_stop_event)
			end

			local wwise_state = player_effects.wwise_state

			if wwise_state then
				Wwise.set_state(wwise_state.group, wwise_state.off_state)
			end
		end
	end
end

ProcBuff.force_predicted_proc = function (self)
	local template = self._template

	return template.force_predicted_proc
end

ProcBuff.has_hud = function (self)
	local has_hud = ProcBuff.super.has_hud(self)
	local template = self._template
	local always_show_in_hud = template.always_show_in_hud
	local has_cooldown = not not template.cooldown_duration
	local has_active_duration = not not template.active_duration
	local has_duration = not not template.duration
	local has_check_active_func = template.check_active_func

	return has_hud and (always_show_in_hud or has_cooldown or has_active_duration or has_duration or has_check_active_func)
end

ProcBuff._show_in_hud = function (self)
	local template = self._template
	local template_data = self._template_data
	local template_context = self._template_context
	local check_active_func = template.check_active_func

	if check_active_func and check_active_func(template_data, template_context) then
		return true
	end

	local t = FixedFrame.get_latest_fixed_time()
	local is_active = self:_is_proc_active(t)
	local is_cooling_down = self:_is_cooling_down(t)
	local show_in_hud_if_slot_is_wielded = template.show_in_hud_if_slot_is_wielded

	if show_in_hud_if_slot_is_wielded and not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
		return false
	end

	local always_show_in_hud = template.always_show_in_hud

	if always_show_in_hud then
		return true
	end

	local show_in_hud = is_active or is_cooling_down

	return show_in_hud
end

ProcBuff._is_hud_active = function (self)
	local cooldown_duration = self:_cooldown_duration()
	local has_cooldown_duration = cooldown_duration ~= nil
	local t = FixedFrame.get_latest_fixed_time()

	if has_cooldown_duration then
		return not self:_is_cooling_down(t)
	end

	return ProcBuff.super._is_hud_active(self)
end

return ProcBuff
