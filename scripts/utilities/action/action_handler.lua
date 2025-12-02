-- chunkname: @scripts/utilities/action/action_handler.lua

local AbilityTemplates = require("scripts/settings/ability/ability_templates/ability_templates")
local ActionAvailability = require("scripts/extension_systems/weapon/utilities/action_availability")
local ActionHandlerSettings = require("scripts/settings/action/action_handler_settings")
local Ammo = require("scripts/utilities/ammo")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WieldableSlotScripts = require("scripts/extension_systems/visual_loadout/utilities/wieldable_slot_scripts")
local buff_stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local ActionHandler = class("ActionHandler")
local MAX_COMBO_COUNT = NetworkConstants.action_combo_count.max
local EMPTY_TABLE = {}
local _get_active_template, _get_reset_combo

ActionHandler.init = function (self, unit, data)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	self._unit_data_extension = unit_data_extension
	self._actions = data.actions
	self._action_kind_condition_funcs = data.action_kind_condition_funcs
	self._action_kind_total_time_funcs = data.action_kind_total_time_funcs
	self._action_kinds_with_inverted_timescale = data.action_kinds_with_inverted_timescale
	self._conditional_state_functions = data.conditional_state_functions
	self._registered_components = {}
	self._unit = unit
	self._action_input_extension = ScriptUnit.extension(unit, "action_input_system")
	self._buff_extension = ScriptUnit.extension(unit, "buff_system")
	self._input_extension = ScriptUnit.extension(unit, "input_system")
	self._action_module_target_finder_component = unit_data_extension:read_component("action_module_target_finder")
	self._alternate_fire_component = unit_data_extension:read_component("alternate_fire")
	self._exploding_character_state_component = unit_data_extension:read_component("exploding_character_state")
	self._inventory_component = unit_data_extension:read_component("inventory")
	self._lunge_character_state_component = unit_data_extension:read_component("lunge_character_state")
	self._sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
end

ActionHandler.extensions_ready = function (self, world, unit)
	self._visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
end

ActionHandler.add_component = function (self, component_name)
	local component = self._unit_data_extension:write_component(component_name)

	component.template_name = "none"
	component.current_action_name = "none"
	component.previous_action_name = "none"
	component.start_t = 0
	component.end_t = 0
	component.time_scale = 1
	component.sprint_ready_time = 0
	component.is_infinite_duration = false
	component.special_active_at_start = false
	component.combo_count = 0
	self._registered_components[component_name] = {
		actions = nil,
		running_action = nil,
		id = component_name,
		component = component,
	}
end

ActionHandler.set_weapon_extension_and_tweak_component = function (self, weapon_extension, component_name)
	local component = self._unit_data_extension:write_component(component_name)

	self._weapon_extension = weapon_extension
	self._tweak_component = component
end

ActionHandler.set_action_context = function (self, action_context)
	self._action_context = action_context
end

ActionHandler.set_active_template = function (self, id, template_name)
	local handler_data = self._registered_components[id]
	local component = handler_data.component

	component.template_name = template_name
end

ActionHandler.block_actions = function (self)
	self._block_actions = true
end

ActionHandler.unblock_actions = function (self)
	self._block_actions = false
end

ActionHandler.wanted_character_state_transition = function (self)
	local registered_components = self._registered_components
	local wanted_state, params

	for id, handler_data in pairs(registered_components) do
		local running_action = handler_data.running_action

		if running_action and running_action.wanted_character_state_transition then
			local wanted_character_state, character_state_params = running_action:wanted_character_state_transition()

			if wanted_character_state then
				-- Nothing
			end

			wanted_state = wanted_character_state
			params = character_state_params
		end
	end

	return wanted_state, params
end

ActionHandler.update = function (self, dt, t)
	local registered_components = self._registered_components

	for id, handler_data in pairs(registered_components) do
		local running_action = handler_data.running_action

		if running_action then
			running_action:update(dt, t)
		end
	end
end

ActionHandler.fixed_update = function (self, dt, t, condition_func_params, frame)
	local registered_components = self._registered_components
	local action_input_extension = self._action_input_extension

	for id, handler_data in pairs(registered_components) do
		local running_action = handler_data.running_action
		local component = handler_data.component

		if running_action then
			local action_complete = self:_update_action(handler_data, running_action, dt, t, frame)

			if action_complete then
				local action_settings = running_action:action_settings()

				self:_finish_action(handler_data, "action_complete", nil, t, nil, condition_func_params)

				local stop_input = action_settings.stop_input

				if stop_input then
					action_input_extension:action_transitioned_with_automatic_input(id, stop_input, t)
				end
			end
		end

		local reset_combo = _get_reset_combo(component, t)

		if reset_combo then
			component.combo_count = 0
		end
	end
end

ActionHandler._update_action = function (self, handler_data, action, dt, t, frame)
	local component = handler_data.component
	local start_t = component.start_t
	local time_in_action = t - start_t
	local is_done = action:fixed_update(dt, t, time_in_action, frame)
	local is_infinite_duration = component.is_infinite_duration
	local end_t = is_infinite_duration and math.huge or component.end_t

	self:_update_timeline_anims(action, t, start_t, end_t)

	if end_t < t or is_done then
		return true
	end

	return false
end

ActionHandler._update_timeline_anims = function (self, action, t, start_t, end_t)
	local action_settings = action:action_settings()
	local anims = action_settings.timeline_anims

	if not anims then
		return
	end

	local total_time = end_t - start_t
	local fixed_time_step = Managers.state.game_session.fixed_time_step

	for time_percentage, anim_events in pairs(anims) do
		local time_to_play

		if end_t == math.huge then
			time_to_play = math.round((start_t + time_percentage) / fixed_time_step) * fixed_time_step
		else
			time_to_play = math.round((start_t + total_time * time_percentage) / fixed_time_step) * fixed_time_step
		end

		local should_play = time_to_play == t

		if should_play then
			action:trigger_anim_event(anim_events.anim_event_1p, anim_events.anim_event_3p)
		end
	end
end

ActionHandler._finish_action = function (self, handler_data, reason, data, t, next_action_params, condition_func_params)
	local running_action = handler_data.running_action
	local action_settings = running_action:action_settings()

	self:_anim_end_event(action_settings, running_action, data, reason, condition_func_params)

	local component = handler_data.component
	local time_in_action = t - component.start_t

	running_action:finish(reason, data, t, time_in_action, action_settings, next_action_params)

	local buff_extension = self._buff_extension
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.action_name = component.current_action_name
		param_table.action_settings = action_settings
		param_table.interrupting_data = data
		param_table.reason = reason

		if action_settings.charge_template then
			local action_module_charge_component = self._unit_data_extension:read_component("action_module_charge")

			param_table.charge_level = action_module_charge_component.charge_level
		end

		buff_extension:add_proc_event(proc_events.on_action_finish, param_table)
	end

	local action_finish_func = action_settings.action_finish_func

	if action_finish_func then
		action_finish_func(reason, data, condition_func_params, t)
	end

	handler_data.running_action = nil
	component.end_t = t
	component.previous_action_name = component.current_action_name
	component.current_action_name = "none"
end

local interrupting_action_data = {}
local action_start_params = {}

ActionHandler.start_action = function (self, id, action_objects, action_name, action_params, action_settings, used_input, t, transition_type, condition_func_params, automatic_input, reset_combo_override)
	local handler_data = self._registered_components[id]
	local component = handler_data.component
	local running_action = handler_data.running_action

	table.clear(action_start_params)

	if running_action then
		table.clear(interrupting_action_data)

		interrupting_action_data.new_action_kind = action_settings.kind
		interrupting_action_data.transition_type = transition_type

		self:_finish_action(handler_data, "new_interrupting_action", interrupting_action_data, t, action_start_params, condition_func_params)
	end

	if not action_objects[action_name] then
		local action_context = self._action_context

		action_objects[action_name] = self:_create_action(action_context, action_params, action_settings)
	end

	local action = action_objects[action_name]
	local is_chain_action = transition_type == "chain"

	action_start_params.is_chain_action = running_action and is_chain_action
	action_start_params.combo_count = component.combo_count
	action_start_params.used_input = used_input
	action_start_params.auto_completed = self._action_input_extension:last_action_auto_completed(id)
	handler_data.running_action = action

	local tweak_component = self._tweak_component

	if tweak_component then
		tweak_component.weapon_handling_template_name = action_settings.weapon_handling_template or "none"
	end

	local time_scale = self:_calculate_time_scale(action_settings)
	local sprint_ready_time = t + (action_settings.sprint_ready_time or 0)
	local total_time = self:_calculate_action_total_time(action_settings, action_params, time_scale)

	component.current_action_name = action_name
	component.start_t = t
	component.time_scale = time_scale
	component.sprint_ready_time = sprint_ready_time

	local is_infinite = total_time == math.huge

	component.end_t = is_infinite and t or t + total_time
	component.is_infinite_duration = is_infinite

	local inventory_component = self._inventory_component
	local wielded_slot = inventory_component.wielded_slot

	if PlayerUnitVisualLoadout.is_slot_of_type(wielded_slot, "weapon") then
		local inventory_slot_component = self._unit_data_extension:read_component(wielded_slot)

		component.special_active_at_start = inventory_slot_component.special_active
	else
		component.special_active_at_start = false
	end

	action:start(action_settings, t, time_scale, action_start_params)
	self:_anim_event(action_settings, action, condition_func_params, is_chain_action, running_action)
	self:_update_combo_count(running_action, action_settings, component, automatic_input, reset_combo_override)

	local wieldable_slot_scripts = self._visual_loadout_extension:current_wielded_slot_scripts()

	if wieldable_slot_scripts then
		WieldableSlotScripts.on_action(wieldable_slot_scripts, action_settings, t)
	end

	local buff_extension = self._buff_extension
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.action_name = action_name
		param_table.action_settings = action_settings

		if action_settings.charge_template then
			local action_module_charge_component = self._unit_data_extension:read_component("action_module_charge")

			param_table.charge_level = action_module_charge_component.charge_level
		end

		buff_extension:add_proc_event(proc_events.on_action_start, param_table)
	end
end

ActionHandler._calculate_action_total_time = function (self, action_settings, action_params, time_scale)
	local action_kind = action_settings.kind
	local action_kind_total_time_funcs = self._action_kind_total_time_funcs
	local total_time_func = action_kind_total_time_funcs[action_kind]

	if total_time_func then
		return total_time_func(action_settings, action_params) / time_scale
	else
		return action_settings.total_time / time_scale
	end
end

ActionHandler._create_action = function (self, action_context, action_params, action_settings)
	local action_kind = action_settings.kind
	local actions = self._actions

	return actions[action_kind]:new(action_context, action_params, action_settings)
end

local WIELD_ACTION_KINDS = {
	ranged_wield = true,
	unwield = true,
	unwield_to_previous = true,
	unwield_to_specific = true,
	wield = true,
}

ActionHandler._calculate_time_scale = function (self, action_settings)
	local time_scale = 1

	if self._weapon_extension then
		local weapon_handling_template = self._weapon_extension:weapon_handling_template() or EMPTY_TABLE
		local weapon_handling_time_scale = weapon_handling_template.time_scale or 1

		time_scale = time_scale * weapon_handling_time_scale
	end

	local buff_extension = self._buff_extension
	local stat_buffs = buff_extension:stat_buffs()

	if WIELD_ACTION_KINDS[action_settings.kind] then
		local stat_buff_value = stat_buffs[buff_stat_buffs.wield_speed]

		time_scale = time_scale * stat_buff_value
	end

	local action_time_scale_stat_buffs = action_settings.time_scale_stat_buffs

	if not action_time_scale_stat_buffs then
		return time_scale
	end

	local num_applied_stat_buffs, total_modifier = 0, 0

	for ii = 1, #action_time_scale_stat_buffs do
		local stat_buff = action_time_scale_stat_buffs[ii]
		local stat_buff_value = stat_buffs[stat_buff]

		if stat_buff_value then
			total_modifier = total_modifier + stat_buff_value
			num_applied_stat_buffs = num_applied_stat_buffs + 1
		end
	end

	total_modifier = total_modifier - (num_applied_stat_buffs - 1)
	time_scale = time_scale * total_modifier

	local min, max = NetworkConstants.action_time_scale.min, NetworkConstants.action_time_scale.max

	if time_scale < min or max < time_scale then
		local active_buffs = "Buffs:"
		local buffs = buff_extension:buffs()

		for ii = 1, #buffs do
			local template = buffs[ii]:template()
			local template_stat_buffs = template.stat_buffs
			local template_conditional_stat_buffs = template.conditional_stat_buffs
			local template_lerped_stat_buffs = template.lerped_stat_buffs
			local template_proc_stat_buffs = template.proc_stat_buffs

			for jj = 1, #action_time_scale_stat_buffs do
				local key = action_time_scale_stat_buffs[jj]

				if template_stat_buffs and template_stat_buffs[key] or template_conditional_stat_buffs and template_conditional_stat_buffs[key] or template_lerped_stat_buffs and template_lerped_stat_buffs[key] or template_proc_stat_buffs and template_proc_stat_buffs[key] then
					active_buffs = string.format("%s %s,", active_buffs, template.name)
				end
			end
		end

		local active_stat_buffs = "Time scales:"

		for ii = 1, #action_time_scale_stat_buffs do
			local key = action_time_scale_stat_buffs[ii]
			local value = stat_buffs[key]

			active_stat_buffs = string.format("%s (%s:%s),", active_stat_buffs, key, value and string.format("%.3f", value) or "n/a")
		end

		Log.exception("ActionHandler", "action time scale value of %.3f fell outside allowed %.3f-%.3f range! %s %s", time_scale, min, max, active_stat_buffs, active_buffs)
	end

	time_scale = math.clamp(time_scale, min, max)

	local gameplay_time_scale_limit = ActionHandlerSettings.gameplay_time_scale_limits[action_settings.kind] or max

	time_scale = math.clamp(time_scale, min, gameplay_time_scale_limit)

	return time_scale
end

ActionHandler._anim_event = function (self, action_settings, action, condition_func_params, is_chain_action, running_action)
	local anim_event, anim_event_3p
	local action_time_offset = action_settings.action_time_offset or 0
	local chain_anim_event = action_settings.chain_anim_event

	if action_settings.anim_event_func then
		anim_event, anim_event_3p = action_settings.anim_event_func(action_settings, condition_func_params, is_chain_action, running_action)
		anim_event_3p = anim_event_3p or anim_event
	elseif chain_anim_event and is_chain_action then
		anim_event = chain_anim_event
		anim_event_3p = action_settings.chain_anim_event_3p or chain_anim_event
	else
		anim_event = action_settings.anim_event
		anim_event_3p = action_settings.anim_event_3p or anim_event
	end

	if not anim_event then
		return
	end

	if action_settings.skip_3p_anims then
		anim_event_3p = nil
	end

	local anim_variables_func = action_settings.anim_variables_func

	if anim_variables_func then
		action:trigger_anim_event(anim_event, anim_event_3p, action_time_offset, anim_variables_func(action_settings, condition_func_params))
	else
		action:trigger_anim_event(anim_event, anim_event_3p, action_time_offset)
	end
end

ActionHandler._anim_end_event = function (self, action_settings, action, data, reason, condition_func_params)
	local anim_end_event, anim_end_event_3p
	local anim_end_event_func = action_settings.anim_end_event_func

	if anim_end_event_func then
		anim_end_event, anim_end_event_3p = anim_end_event_func(action_settings, condition_func_params)
		anim_end_event_3p = anim_end_event_3p or anim_end_event
	else
		anim_end_event = action_settings.anim_end_event
		anim_end_event_3p = action_settings.anim_end_event_3p or anim_end_event
	end

	if not anim_end_event then
		return
	end

	local anim_end_event_condition_func = action_settings.anim_end_event_condition_func

	if anim_end_event_condition_func and not anim_end_event_condition_func(self._unit, data, reason) then
		return
	end

	if action_settings.skip_3p_anims then
		anim_end_event_3p = nil
	end

	action:trigger_anim_event(anim_end_event, anim_end_event_3p)
end

ActionHandler._update_combo_count = function (self, running_action, action_settings, component, automatic_input, reset_combo_override)
	if reset_combo_override or not running_action and not automatic_input and not action_settings.keep_combo_on_start then
		component.combo_count = 0

		return
	end

	local increase_combo = ActionAvailability.increases_action_combo(action_settings)
	local hold_combo = ActionAvailability.holds_action_combo(action_settings)
	local reset_combo = not increase_combo and not hold_combo

	if reset_combo then
		component.combo_count = 0
	elseif increase_combo then
		local new_combo_count = math.min(component.combo_count + 1, MAX_COMBO_COUNT)

		component.combo_count = new_combo_count
	end
end

ActionHandler.server_correction_occurred = function (self, id, action_objects, action_params, actions)
	local handler_data = self._registered_components[id]
	local component = handler_data.component
	local current_action_name = component.current_action_name

	if current_action_name == "none" then
		handler_data.running_action = nil
	else
		local action = action_objects[current_action_name]

		if not action then
			local action_context = self._action_context
			local action_settings = actions[current_action_name]

			action = self:_create_action(action_context, action_params, action_settings)
			action_objects[current_action_name] = action
		end

		action:server_correction_occurred()

		handler_data.running_action = action
	end
end

ActionHandler.stop_action = function (self, id, reason, data, t, actions, action_objects, action_params, condition_func_params)
	local handler_data = self._registered_components[id]
	local running_action = handler_data.running_action

	if not running_action then
		return
	end

	local finish_action = true

	if condition_func_params then
		local current_action_settings = running_action:action_settings()
		local allowed_chain_actions = current_action_settings.allowed_chain_actions or EMPTY_TABLE
		local finish_reason_to_action_input = current_action_settings.finish_reason_to_action_input or EMPTY_TABLE
		local finish_reason_config = finish_reason_to_action_input[reason]

		if finish_reason_config then
			local finish_reason_input = finish_reason_config.input_name
			local chain_action = allowed_chain_actions[finish_reason_input]

			if chain_action then
				local component = handler_data.component
				local start_t = component.start_t
				local time_scale = component.time_scale
				local current_action_t = t - start_t
				local running_action_state = running_action:running_action_state(t, current_action_t)
				local chain_action_validated, action_name, action_settings, reset_combo = self:_validate_chain_action(chain_action, t, current_action_t, time_scale, actions, condition_func_params, nil, running_action_state)

				if chain_action_validated then
					self._action_input_extension:action_transitioned_with_automatic_input(id, finish_reason_input, t)
					self:start_action(id, action_objects, action_name, action_params, action_settings, nil, t, "chain", condition_func_params, reset_combo)

					finish_action = false
				end
			end
		end
	end

	if finish_action then
		self:_handle_action_input_on_stop_action(id, t, running_action)
		self:_finish_action(handler_data, reason, data, t, nil, condition_func_params)
	end
end

ActionHandler._handle_action_input_on_stop_action = function (self, id, t, running_action)
	local action_settings = running_action:action_settings()
	local stop_input = action_settings.stop_input

	if stop_input then
		self._action_input_extension:action_transitioned_with_automatic_input(id, stop_input, t)
	elseif self._alternate_fire_component.is_active then
		-- Nothing
	else
		self._action_input_extension:clear_input_queue_and_sequences(id)
	end

	return false
end

ActionHandler.has_running_action = function (self, id)
	local handler_data = self._registered_components[id]

	return handler_data.running_action ~= nil
end

ActionHandler.running_action_name = function (self, id)
	local handler_data = self._registered_components[id]
	local running_action = handler_data.running_action

	if not running_action then
		return nil
	end

	local action_settings = running_action:action_settings()

	return action_settings.name
end

ActionHandler.action_settings_from_action_input = function (self, id, actions, action_input)
	if not actions then
		return nil
	end

	local registered_components = self._registered_components
	local handler_data = registered_components[id]
	local running_action = handler_data.running_action
	local has_running_action = running_action ~= nil
	local action_settings

	if not has_running_action then
		local current_settings
		local current_priority = -math.huge

		for name, settings in pairs(actions) do
			local start_input = settings.start_input
			local priority = settings.action_priority or math.huge

			if start_input == action_input and current_priority < priority then
				current_settings = settings
				current_priority = priority

				if not settings.action_priority then
					break
				end
			end
		end

		action_settings = current_settings
	else
		local current_action_settings = running_action:action_settings()
		local allowed_chain_actions = current_action_settings.allowed_chain_actions or EMPTY_TABLE
		local chain_action = allowed_chain_actions[action_input]

		if chain_action then
			action_settings = actions[chain_action.action_name]
		end
	end

	return action_settings
end

ActionHandler.update_actions = function (self, fixed_frame, id, condition_func_params, actions, action_objects, action_params)
	local t = fixed_frame * Managers.state.game_session.fixed_time_step
	local registered_components = self._registered_components
	local handler_data = registered_components[id]
	local action_name, action_settings, used_input, transition_type, automatic_input, reset_combo = self:_check_new_actions(handler_data, actions, condition_func_params, t, action_params)

	if action_name and not self._block_actions then
		if automatic_input then
			self._action_input_extension:action_transitioned_with_automatic_input(id, automatic_input, t)
		else
			self._action_input_extension:consume_next_input(id, t)
		end

		self:start_action(id, action_objects, action_name, action_params, action_settings, used_input, t, transition_type, condition_func_params, automatic_input, reset_combo)
	else
		automatic_input = self:_update_stop_input(id, handler_data, t, condition_func_params, action_params)

		if automatic_input then
			self._action_input_extension:action_transitioned_with_automatic_input(id, automatic_input, t)
		end
	end
end

ActionHandler._validate_action = function (self, action_settings, condition_func_params, t, used_input)
	local kind = action_settings.kind
	local action_kind_condition_func = self._action_kind_condition_funcs[kind]

	if action_kind_condition_func and not action_kind_condition_func(action_settings, condition_func_params, used_input) then
		return false
	end

	local action_condition_func = action_settings.action_condition_func

	if action_condition_func and not action_condition_func(action_settings, condition_func_params, used_input, t) then
		return false
	end

	local sprint_character_state_component = self._sprint_character_state_component
	local is_sprinting = Sprint.is_sprinting(sprint_character_state_component)

	if is_sprinting then
		local buff_extension = self._buff_extension

		if not ActionAvailability.available_in_sprint(action_settings, buff_extension) then
			return false
		end
	else
		local action_is_available_after_sprint_t = sprint_character_state_component.last_sprint_time + (action_settings.sprint_ready_up_time or 0)

		if t < action_is_available_after_sprint_t then
			return false
		end
	end

	local is_lunging = self._lunge_character_state_component.is_lunging

	if is_lunging and not ActionAvailability.available_in_lunge(action_settings) then
		return false
	end

	if not ActionAvailability.allowed_without_smite_target(action_settings) then
		local target_unit = self._action_module_target_finder_component.target_unit_1

		if not target_unit then
			return false
		end
	end

	local is_exploding = self._exploding_character_state_component.is_exploding

	if is_exploding and not ActionAvailability.allowed_while_exploding(action_settings) then
		return false
	end

	if ActionAvailability.needs_ammo(action_settings) then
		local inventory_component = self._inventory_component
		local wielded_slot = inventory_component.wielded_slot
		local ammo, reserve = Ammo.current_slot_clip_amount(self._unit, wielded_slot)
		local inventory_slot_component = self._unit_data_extension:read_component(wielded_slot)

		if ammo <= 0 and not action_settings.allow_even_if_out_of_ammo and (reserve > 0 or inventory_slot_component.free_ammunition_transfer) then
			return false
		end
	end

	return true
end

ActionHandler._check_chain_actions = function (self, handler_data, current_action_settings, current_action_start_t, current_action_end_t, t, actions, condition_func_params, action_params, template, action_input, used_input)
	local component = handler_data.component
	local allowed_chain_actions = current_action_settings.allowed_chain_actions or EMPTY_TABLE
	local running_action_state_to_action_input = current_action_settings.running_action_state_to_action_input or EMPTY_TABLE
	local conditional_state_to_action_input = current_action_settings.conditional_state_to_action_input or EMPTY_TABLE
	local time_scale = component.time_scale
	local current_action_t = t - current_action_start_t
	local wanted_action_name, wanted_action_settings, wanted_used_input, automatic_input, reset_combo
	local running_action = handler_data.running_action
	local running_action_state = running_action:running_action_state(t, current_action_t)

	if action_input then
		local chain_action = allowed_chain_actions[action_input]

		if chain_action then
			local chain_action_validated, action_name, action_settings, action_reset_combo = self:_validate_chain_action(chain_action, t, current_action_t, time_scale, actions, condition_func_params, used_input, running_action_state)

			if chain_action_validated then
				wanted_action_name = action_name
				wanted_action_settings = action_settings
				wanted_used_input = used_input
				automatic_input = nil
				reset_combo = action_reset_combo
			end
		end
	end

	if not wanted_action_name and running_action_state then
		local running_action_chain_config = running_action_state_to_action_input[running_action_state]

		if running_action_chain_config then
			local running_action_input = running_action_chain_config.input_name
			local chain_action = allowed_chain_actions[running_action_input]

			if chain_action then
				local chain_action_validated, action_name, action_settings, action_reset_combo = self:_validate_chain_action(chain_action, t, current_action_t, time_scale, actions, condition_func_params, used_input, running_action_state)

				if chain_action_validated then
					wanted_action_name = action_name
					wanted_action_settings = action_settings
					wanted_used_input = nil
					automatic_input = running_action_input
					reset_combo = action_reset_combo
				end
			end
		end
	end

	if not wanted_action_name then
		local conditional_state_funcs = self._conditional_state_functions
		local remaining_time = current_action_end_t - t
		local conditional_states = table.keys(conditional_state_to_action_input)

		table.sort(conditional_states)

		for _, conditional_state in ipairs(conditional_states) do
			local conditional_state_config = conditional_state_to_action_input[conditional_state]
			local conditional_action_input = conditional_state_config.input_name
			local func = conditional_state_funcs[conditional_state]
			local chain_action = allowed_chain_actions[conditional_action_input]

			if chain_action and func(condition_func_params, action_params, remaining_time, t) then
				local chain_action_validated, action_name, action_settings, action_reset_combo = self:_validate_chain_action(chain_action, t, current_action_t, time_scale, actions, condition_func_params, used_input, running_action_state)

				if chain_action_validated then
					wanted_action_name = action_name
					wanted_action_settings = action_settings
					wanted_used_input = nil
					automatic_input = conditional_action_input
					reset_combo = action_reset_combo

					break
				end
			end
		end
	end

	if wanted_action_name then
		return wanted_action_name, wanted_action_settings, wanted_used_input, "chain", automatic_input, reset_combo
	else
		return nil, nil, nil, nil, nil, nil, false
	end
end

ActionHandler._validate_chain_action = function (self, chain_action, t, current_action_t, time_scale, actions, condition_func_params, used_input, running_action_state)
	local num_chain_actions = #chain_action

	if num_chain_actions == 0 then
		return self:_validate_single_chain_action(chain_action, t, current_action_t, time_scale, actions, condition_func_params, used_input, running_action_state)
	else
		for ii = 1, num_chain_actions do
			local action = chain_action[ii]
			local action_is_validated, action_name, action_settings, reset_combo = self:_validate_single_chain_action(action, t, current_action_t, time_scale, actions, condition_func_params, used_input, running_action_state)

			if action_is_validated then
				return action_is_validated, action_name, action_settings, reset_combo
			end
		end
	end
end

ActionHandler._validate_single_chain_action = function (self, chain_action, t, current_action_t, time_scale, actions, condition_func_params, used_input, running_action_state)
	local chain_time, chain_until, chain_validated

	if time_scale < 1 then
		local current_action_name = self._action_context.weapon_action_component.current_action_name
		local current_action = actions[current_action_name]
		local current_action_has_inverted_timescale = current_action and self._action_kinds_with_inverted_timescale[current_action.kind]

		if current_action_has_inverted_timescale then
			chain_time = chain_action.chain_time and chain_action.chain_time * time_scale
			chain_until = chain_action.chain_until and chain_action.chain_until * time_scale
		else
			chain_time = chain_action.chain_time and chain_action.chain_time / time_scale
			chain_until = chain_action.chain_until and chain_action.chain_until / time_scale
		end
	else
		chain_time = chain_action.chain_time and chain_action.chain_time / time_scale
		chain_until = chain_action.chain_until and chain_action.chain_until / time_scale
	end

	chain_validated = not chain_time or (chain_time and chain_time <= current_action_t or not not chain_until and current_action_t <= chain_until) and true

	local running_action_state_requirement = chain_action.running_action_state_requirement

	if running_action_state_requirement and (not running_action_state or not running_action_state_requirement[running_action_state]) then
		chain_validated = false
	end

	local action_name = chain_action.action_name
	local action_settings = actions[action_name]
	local reset_combo = chain_action.reset_combo
	local action_is_validated = chain_validated and self:_validate_action(action_settings, condition_func_params, t, used_input)

	return action_is_validated, action_name, action_settings, reset_combo
end

ActionHandler._valid_action_from_action_input = function (self, actions, action_input, t, condition_func_params, used_input)
	local current_settings, current_name
	local current_priority = -math.huge

	for name, settings in pairs(actions) do
		local start_input = settings.start_input
		local priority = settings.action_priority or math.huge

		if start_input == action_input and current_priority < priority then
			local is_validated = self:_validate_action(settings, condition_func_params, t, used_input)

			if is_validated then
				current_settings = settings
				current_name = name
				current_priority = priority

				if not settings.action_priority then
					break
				end
			end
		end
	end

	return current_name, current_settings
end

ActionHandler._check_start_actions = function (self, handler_data, t, actions, condition_func_params, action_params, template, action_input, used_input)
	if not actions then
		return nil, nil, nil, nil, nil
	end

	local wanted_action, wanted_action_settings, automatic_input

	if action_input then
		wanted_action, wanted_action_settings = self:_valid_action_from_action_input(actions, action_input, t, condition_func_params, used_input)
	end

	if not wanted_action then
		local conditional_state_to_action_input = template.conditional_state_to_action_input or EMPTY_TABLE
		local conditional_state_funcs = self._conditional_state_functions

		for i = 1, #conditional_state_to_action_input do
			local conditional_state_config = conditional_state_to_action_input[i]
			local conditional_state = conditional_state_config.conditional_state
			local func = conditional_state_funcs[conditional_state]

			if func(condition_func_params, action_params, nil, t) then
				local conditional_action_input = conditional_state_config.input_name
				local action, action_settings = self:_valid_action_from_action_input(actions, conditional_action_input, t, condition_func_params, used_input)

				if action then
					wanted_action = action
					wanted_action_settings = action_settings
					used_input = nil
					automatic_input = conditional_action_input

					break
				end
			end
		end
	end

	if wanted_action then
		return wanted_action, wanted_action_settings, used_input, "start", automatic_input
	else
		return nil, nil, nil, nil, nil
	end
end

ActionHandler._check_new_actions = function (self, handler_data, actions, condition_func_params, t, action_params)
	local running_action = handler_data.running_action
	local has_running_action = running_action ~= nil
	local component = handler_data.component
	local template = _get_active_template(component)
	local id = handler_data.id
	local action_input, used_input = self._action_input_extension:peek_next_input(id)

	if not has_running_action then
		return self:_check_start_actions(handler_data, t, actions, condition_func_params, action_params, template, action_input, used_input)
	else
		local action_settings = running_action:action_settings()
		local start_t = component.start_t
		local is_infinite_duration = component.is_infinite_duration
		local end_t = is_infinite_duration and math.huge or component.end_t
		local allow_chain_actions = running_action:allow_chain_actions()

		if allow_chain_actions then
			return self:_check_chain_actions(handler_data, action_settings, start_t, end_t, t, actions, condition_func_params, action_params, template, action_input, used_input)
		end
	end

	return nil
end

ActionHandler._update_stop_input = function (self, id, handler_data, t, condition_func_params, action_params)
	local running_action = handler_data.running_action
	local has_running_action = running_action ~= nil

	if not has_running_action then
		return
	end

	local action_settings = running_action:action_settings()
	local stop_input = action_settings.stop_input

	if not stop_input then
		return
	end

	local minimum_hold_time = action_settings.minimum_hold_time
	local component = handler_data.component
	local start_t = component.start_t
	local time_in_action = t - start_t

	if minimum_hold_time and t < start_t + minimum_hold_time then
		return
	end

	local conditional_states_to_hold = action_settings.conditional_states_to_hold

	if conditional_states_to_hold then
		for ii = 1, #conditional_states_to_hold do
			local condition_key = conditional_states_to_hold[ii]
			local func = self._conditional_state_functions[condition_key]
			local remaining_time = component.end_t - t

			if func(condition_func_params, action_params, remaining_time, t) then
				return
			end
		end
	end

	local action_input_extension = self._action_input_extension
	local action_component_name = handler_data.id
	local action_input = action_input_extension:peek_next_input(action_component_name)

	if action_input == stop_input then
		action_input_extension:consume_next_input(action_component_name, t)
		self:_finish_action(handler_data, "hold_input_released", nil, t, nil, condition_func_params)

		return
	end

	local running_action_state = running_action:running_action_state(t, time_in_action)

	if running_action_state then
		local current_action_settings = running_action:action_settings()
		local running_action_state_to_action_input = current_action_settings.running_action_state_to_action_input or EMPTY_TABLE
		local running_action_chain_config = running_action_state_to_action_input[running_action_state]

		if running_action_chain_config then
			local running_action_input = running_action_chain_config.input_name

			if running_action_input == stop_input then
				self:_finish_action(handler_data, "hold_input_released", nil, t, nil, condition_func_params)

				return running_action_input
			end
		end
	end
end

ActionHandler.sensitivity_modifier = function (self, id, t)
	local handler_data = self._registered_components[id]
	local running_action = handler_data.running_action

	if not running_action then
		return 1
	end

	return running_action:sensitivity_modifier(t)
end

ActionHandler.rotation_contraints = function (self, id, t)
	local handler_data = self._registered_components[id]
	local running_action = handler_data.running_action

	if not running_action then
		return nil
	end

	return running_action:rotation_contraints(t)
end

ActionHandler.running_action_settings = function (self, id)
	local handler_data = self._registered_components[id]
	local running_action = handler_data.running_action

	if not running_action then
		return nil
	end

	return running_action:action_settings()
end

ActionHandler.action_input_is_currently_valid = function (self, id, actions, condition_func_params, t, action_input, used_input)
	local handler_data = self._registered_components[id]
	local is_valid = false
	local running_action = handler_data.running_action

	if running_action then
		local action_settings = running_action:action_settings()
		local stop_input = action_settings.stop_input
		local allowed_chain_actions = action_settings.allowed_chain_actions or EMPTY_TABLE
		local chain_action = allowed_chain_actions[action_input]

		if chain_action then
			local component = handler_data.component
			local start_t = component.start_t
			local time_scale = component.time_scale
			local current_action_t = t - start_t
			local running_action_state = running_action:running_action_state(t, current_action_t)
			local chain_action_validated, _, _ = self:_validate_chain_action(chain_action, t, current_action_t, time_scale, actions, condition_func_params, used_input, running_action_state)

			if chain_action_validated then
				is_valid = true
			end
		elseif stop_input and stop_input == action_input then
			is_valid = true
		end
	else
		local action_name, _ = self:_valid_action_from_action_input(actions, action_input, t, condition_func_params, used_input)

		if action_name then
			is_valid = true
		end
	end

	return is_valid
end

function _get_active_template(component)
	local template_name = component.template_name
	local weapon_template = WeaponTemplate.current_weapon_template(component)
	local template = weapon_template or AbilityTemplates[template_name]

	return template
end

local DEFAULT_COMBO_RESET_DURATION = 0.2

function _get_reset_combo(component, t)
	local current_action_name = component.current_action_name
	local action_end_time = component.end_t
	local action_start_time = component.start_t
	local time_since_end = t - action_end_time
	local is_looping_action = action_end_time == action_start_time and current_action_name ~= nil and current_action_name ~= "none"
	local template = component.template_name ~= "none" and _get_active_template(component)
	local combo_reset_duration = template and template.combo_reset_duration or DEFAULT_COMBO_RESET_DURATION
	local reset_combo = not is_looping_action and combo_reset_duration < time_since_end and component.combo_count > 0

	return reset_combo, time_since_end, combo_reset_duration, is_looping_action
end

return ActionHandler
