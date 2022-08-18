require("scripts/extension_systems/buff/buffs/buff")

local ProcBuff = class("ProcBuff", "Buff")

ProcBuff.init = function (self, context, template, start_time, instance_id, ...)
	ProcBuff.super.init(self, context, template, start_time, instance_id, ...)

	local cooldown = self:_cooldown_duration()
	local active_duration = self:_active_duration()
	local t = Managers.time:time("gameplay")

	if cooldown then
		self._active_start_time = t - (cooldown + active_duration)
	else
		self._active_start_time = t - active_duration
	end

	self._active_vfx = {}
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

	self:_stop_proc_active_fx()
	ProcBuff.super.destroy(self)
end

ProcBuff.active_start_time = function (self)
	return self._active_start_time
end

ProcBuff.set_active_start_time = function (self, active_start_time)
	self._active_start_time = active_start_time
end

ProcBuff.is_active = function (self)
	local t = Managers.time:time("gameplay")

	return self:_is_active(t)
end

ProcBuff._is_active = function (self, t)
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

ProcBuff.activate_percentage = function (self, t)
	local is_active = self:_is_active(t)
	local active_duration = self:_active_duration()

	if is_active and active_duration > 0 then
		local current_time = t - self._active_start_time
		local percentage = current_time / active_duration

		return percentage
	end

	return 0
end

ProcBuff._is_cooling_down = function (self, t)
	local active_cooldown = self:_cooldown_duration()
	local active_duration = self:_active_duration()
	local active_start_time = self._active_start_time

	if self:_is_active(t) then
		return false
	end

	local is_cooling_down = t < active_start_time + active_duration + active_cooldown

	return is_cooling_down
end

ProcBuff._can_activate = function (self, t)
	local cooldown = self:_cooldown_duration()
	local has_cooldown = cooldown >= 0

	if has_cooldown then
		local is_active = self:_is_active(t)
		local is_cooling_down = self:_is_cooling_down(t)

		return not is_active and not is_cooling_down
	end

	return true
end

ProcBuff._cooldown_duration = function (self)
	local template = self._template
	local cooldown_duration = template.cooldown_duration or 0
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
	local is_active = self:_is_active(t)
	local has_activated = self._has_activated
	local proc_update_func = template.proc_update_func

	if is_active and proc_update_func then
		proc_update_func(dt, t, template_data, template_context)
	end

	if not has_activated and is_active then
		self._has_activated = true

		self:_start_proc_fx()
		self:_start_proc_active_fx()
	elseif has_activated and not is_active then
		self._has_activated = false

		self:_stop_proc_active_fx()

		local proc_end_func = template.proc_end_func

		if proc_end_func then
			proc_end_func(template_data, template_context)
		end
	end
end

ProcBuff._can_add_stat_and_keywords = function (self, t)
	local template = self._template
	local condition_func = template.conditional_proc_func
	local condition_ok = not condition_func or condition_func(self._template_data, self._template_context)
	local is_active = self:_is_active(t) and condition_ok

	return is_active
end

ProcBuff.update_keywords = function (self, current_key_words)
	ProcBuff.super.update_keywords(self, current_key_words)

	local template = self._template
	local t = Managers.time:time("gameplay")
	local is_active = self:_can_add_stat_and_keywords(t)
	local proc_keywords = self._template.proc_keywords

	if proc_keywords and is_active then
		for _, keyword in pairs(proc_keywords) do
			current_key_words[keyword] = true
		end
	end

	local inactive_keywords = self._template.inactive_keywords

	if inactive_keywords and not is_active then
		for _, keyword in pairs(inactive_keywords) do
			current_key_words[keyword] = true
		end
	end

	local is_cooling_down = self:_is_cooling_down(t)
	local off_cooldown_keywords = template.off_cooldown_keywords

	if off_cooldown_keywords and not is_cooling_down then
		for _, keyword in pairs(off_cooldown_keywords) do
			current_key_words[keyword] = true
		end
	end

	return current_key_words
end

ProcBuff.update_stat_buffs = function (self, current_stat_buffs)
	ProcBuff.super.update_stat_buffs(self, current_stat_buffs)

	local template = self._template
	local t = Managers.time:time("gameplay")
	local is_active = self:_can_add_stat_and_keywords(t)
	local proc_stat_buffs = template.proc_stat_buffs

	if proc_stat_buffs and is_active then
		self:_calculate_stat_buffs(current_stat_buffs, proc_stat_buffs)
	end
end

ProcBuff.update_proc_events = function (self, t, proc_events, num_proc_events, portable_random, local_portable_random)
	local template = self._template
	local activated_proc = false

	for i = 1, num_proc_events, 1 do
		local proc_event_data = proc_events[i]
		local proc_event_name = proc_event_data.name
		local proc_chance = self:_proc_chance(proc_event_name)
		local params = proc_event_data.params
		local is_local_proc_event = params.is_local_proc_event
		local is_predicted_buff = template.predicted
		local template_data = self._template_data
		local template_context = self._template_context

		if proc_chance and self:_can_activate(t) then
			local portable_random_to_use = ((is_local_proc_event or not is_predicted_buff) and local_portable_random) or portable_random
			local auto_tester = DevParameters.weapon_traits_testify
			local will_proc = proc_chance == 1 or auto_tester
			local random_value = (will_proc and 0) or portable_random_to_use:next_random()

			if random_value < proc_chance then
				local check_proc_func = template.check_proc_func
				local is_check_ok = not check_proc_func or check_proc_func(params, template_data, template_context)
				local condition_func = template.conditional_proc_func
				local condition_ok = not condition_func or condition_func(template_data, template_context)

				if is_check_ok and condition_ok then
					local proc_func = template.proc_func

					if proc_func then
						proc_func(params, template_data, template_context)
					end

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

					func(params, template_data, template_context)
				end
			end
		end
	end

	return activated_proc
end

ProcBuff._proc_chance = function (self, proc_event_name)
	local template = self._template
	local proc_events = template.proc_events
	local template_override_data = self._template_override_data
	local override_proc_events = template_override_data and template_override_data.proc_events
	local chance = (override_proc_events and override_proc_events[proc_event_name]) or proc_events[proc_event_name]

	return chance
end

ProcBuff._start_proc_fx = function (self)
	local template_context = self._template_context
	local template = self._template
	local world = template_context.world
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

ProcBuff._stop_proc_active_fx = function (self)
	local template = self._template
	local template_context = self._template_context
	local world = template_context.world
	local wwise_world = template_context.wwise_world
	local active_vfx = self._active_vfx

	for i = 1, #active_vfx, 1 do
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

			if player_looping_wwise_stop_event then
				WwiseWorld.trigger_resource_event(wwise_world, player_looping_wwise_stop_event)
			end

			local wwise_state = player_effects.wwise_state

			if wwise_state then
				Wwise.set_state(wwise_state.group, wwise_state.off_state)
			end
		end
	end
end

ProcBuff.debug_draw = function (self, gui, t, position, box_width, box_height, scale, opacity, text_size, debug_font_mtrl)
	ProcBuff.super.debug_draw(self, gui, t, position, box_width, box_height, scale, opacity, text_size, debug_font_mtrl)

	local active_start_time = self:active_start_time()
	local active_duration = self:_active_duration()

	if self:_is_active(t) and active_duration > 0 then
		local active_rect_scalar = (t - active_start_time) / active_duration
		local active_rect_size = Vector3(box_width * active_rect_scalar, box_height / 2, 0) * scale
		local active_rect_color = Color(230 * opacity, 200, 200, 10)

		Gui.rect(gui, position + Vector3(0, box_height / 2, 0) * scale, active_rect_size, active_rect_color)
	end

	if self:_is_cooling_down(t) then
		local cooldown_duration = self:_cooldown_duration()
		local cooldown_rect_scalar = (t - active_start_time - active_duration) / cooldown_duration
		local cooldown_rect_size = Vector3(box_width * cooldown_rect_scalar, box_height / 4, 0) * scale
		local cooldown_rect_color = Color(230 * opacity, 200, 0, 10)

		Gui.rect(gui, position + Vector3(0, (3 * box_height) / 4, 0) * scale, cooldown_rect_size, cooldown_rect_color)
	end
end

return ProcBuff
