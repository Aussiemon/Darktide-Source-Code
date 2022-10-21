local AbilityTemplates = require("scripts/settings/ability/ability_templates/ability_templates")
local ActionAvailability = require("scripts/extension_systems/weapon/utilities/action_availability")
local ActionHandlerSettings = require("scripts/settings/action/action_handler_settings")
local Ammo = require("scripts/utilities/ammo")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local ActionHandler = class("ActionHandler")
local EMPTY_TABLE = {}
local _get_active_template = nil

ActionHandler.init = function (self, unit, data)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._unit_data_extension = unit_data_extension
	self._actions = data.actions
	self._action_kind_condition_funcs = data.action_kind_condition_funcs
	self._action_kind_total_time_funcs = data.action_kind_total_time_funcs
	self._conditional_state_functions = data.conditional_state_functions
	self._registered_components = {}
	self._unit = unit
	self._action_input_extension = ScriptUnit.extension(unit, "action_input_system")
	self._input_extension = ScriptUnit.extension(unit, "input_system")
	self._sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
	self._lunge_character_state_component = unit_data_extension:read_component("lunge_character_state")
	self._alternate_fire_component = unit_data_extension:read_component("alternate_fire")
	self._inventory_component = unit_data_extension:read_component("inventory")
	self._targeting_component = unit_data_extension:read_component("action_module_targeting")
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
	self._registered_components[component_name] = {
		id = component_name,
		component = component
	}
end

ActionHandler.set_tweak_component = function (self, component_name)
	local component = self._unit_data_extension:write_component(component_name)
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
	local wanted_state, params = nil

	for id, handler_data in pairs(registered_components) do
		local running_action = handler_data.running_action

		if running_action and running_action.wanted_character_state_transition then
			local wanted_character_state, character_state_params = running_action:wanted_character_state_transition()

			if wanted_character_state then
				fassert(not wanted_state, "Two character state changes attempted simultaniously from two different actions")
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

ActionHandler.fixed_update = function (self, dt, t)
	local registered_components = self._registered_components
	local action_input_extension = self._action_input_extension

	for id, handler_data in pairs(registered_components) do
		local running_action = handler_data.running_action

		if running_action then
			local action_complete = self:_update_action(handler_data, running_action, dt, t)

			if action_complete then
				local action_settings = running_action:action_settings()

				self:_finish_action(handler_data, "action_complete", nil, t)

				local stop_input = action_settings.stop_input

				if stop_input then
					action_input_extension:action_transitioned_with_automatic_input(id, stop_input, t)
				end
			end
		end
	end
end

ActionHandler._update_action = function (self, handler_data, action, dt, t)
	local component = handler_data.component
	local start_t = component.start_t
	local time_in_action = t - start_t
	local is_done = action:fixed_update(dt, t, time_in_action)
	local is_infinite_duration = component.is_infinite_duration
	local end_t = is_infinite_duration and math.huge or component.end_t

	self:_update_timeline_anims(action, t, start_t, end_t)

	if end_t < t or is_done then
		return true
	end

	return false
end

local fixed_time_step = GameParameters.fixed_time_step

ActionHandler._update_timeline_anims = function (self, action, t, start_t, end_t)
	local action_settings = action:action_settings()
	local anims = action_settings.timeline_anims

	if not anims then
		return
	end

	local total_time = end_t - start_t

	for time_percentage, anim_events in pairs(anims) do
		local time_to_play = nil

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

ActionHandler._finish_action = function (self, handler_data, reason, data, t, next_action_params)
	local running_action = handler_data.running_action
	local action_settings = running_action:action_settings()

	self:_anim_end_event(action_settings, running_action, data, reason)

	local component = handler_data.component
	local time_in_action = t - component.start_t

	running_action:finish(reason, data, t, time_in_action, action_settings, next_action_params)

	handler_data.running_action = nil
	component.previous_action_name = component.current_action_name
	component.current_action_name = "none"
end

local interrupting_action_data = {}
local action_start_params = {}

ActionHandler.start_action = function (self, id, action_objects, action_name, action_params, action_settings, used_input, t, transition_type, condition_func_params)
	local handler_data = self._registered_components[id]
	local component = handler_data.component
	local running_action = handler_data.running_action

	table.clear(action_start_params)

	if running_action then
		table.clear(interrupting_action_data)

		interrupting_action_data.new_action_kind = action_settings.kind
		interrupting_action_data.transition_type = transition_type

		self:_finish_action(handler_data, "new_interrupting_action", interrupting_action_data, t, action_start_params)
	end

	if not action_objects[action_name] then
		local action_context = self._action_context
		action_objects[action_name] = self:_create_action(action_context, action_params, action_settings)
	end

	local action = action_objects[action_name]
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

	local is_chain = transition_type == "chain"

	self:_anim_event(action_settings, action, is_chain, condition_func_params)
end

ActionHandler._calculate_action_total_time = function (self, action_settings, action_params, time_scale)
	local action_kind = action_settings.kind
	local action_kind_total_time_funcs = self._action_kind_total_time_funcs
	local total_time_func = action_kind_total_time_funcs[action_kind]

	if total_time_func then
		return total_time_func(action_params) / time_scale
	else
		return action_settings.total_time / time_scale
	end
end

ActionHandler._create_action = function (self, action_context, action_params, action_settings)
	local action_kind = action_settings.kind
	local actions = self._actions

	return actions[action_kind]:new(action_context, action_params, action_settings)
end

ActionHandler._calculate_time_scale = function (self, action_settings)
	local player_unit = self._unit
	local weapon_extension = ScriptUnit.extension(player_unit, "weapon_system")
	local weapon_handling_template = weapon_extension:weapon_handling_template() or EMPTY_TABLE
	local time_scale = weapon_handling_template.time_scale or 1
	local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	local stat_buffs = buff_extension:stat_buffs()
	local action_stat_buff_keywords = action_settings.stat_buff_keywords

	if not action_stat_buff_keywords then
		return time_scale
	end

	local num_applied_stat_buffs = 0
	local total_modifier = 0

	for i = 1, #action_stat_buff_keywords do
		local keyword = action_stat_buff_keywords[i]
		local stat_buff_value = stat_buffs[keyword]

		if stat_buff_value then
			total_modifier = total_modifier + stat_buff_value
			num_applied_stat_buffs = num_applied_stat_buffs + 1
		end
	end

	total_modifier = total_modifier - (num_applied_stat_buffs - 1)
	local min = NetworkConstants.action_time_scale.min
	local max = NetworkConstants.action_time_scale.max
	time_scale = math.clamp(time_scale * total_modifier, min, max)

	return time_scale
end

ActionHandler._anim_event = function (self, action_settings, action, is_chain, condition_func_params)
	local anim_event, anim_event_3p = nil
	local action_time_offset = action_settings.action_time_offset or 0
	local chain_anim_event = action_settings.chain_anim_event

	if chain_anim_event and is_chain then
		anim_event = chain_anim_event
		anim_event_3p = action_settings.chain_anim_event_3p or chain_anim_event
	elseif action_settings.anim_event_func then
		anim_event, anim_event_3p = action_settings:anim_event_func(condition_func_params)
		anim_event_3p = anim_event_3p or anim_event
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

ActionHandler._anim_end_event = function (self, action_settings, action, data, reason)
	local anim_end_event = action_settings.anim_end_event

	if not anim_end_event then
		return
	end

	local anim_end_event_condition_func = action_settings.anim_end_event_condition_func

	if anim_end_event_condition_func and not anim_end_event_condition_func(self._unit, data, reason) then
		return
	end

	local anim_end_event_3p = action_settings.anim_end_event_3p or anim_end_event

	if action_settings.skip_3p_anims then
		anim_end_event_3p = nil
	end

	action:trigger_anim_event(anim_end_event, anim_end_event_3p)
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
				local chain_action_validated, action_name, action_settings = self:_validate_chain_action(chain_action, t, current_action_t, time_scale, actions, condition_func_params, nil)

				if chain_action_validated then
					self._action_input_extension:action_transitioned_with_automatic_input(id, finish_reason_input, t)
					self:start_action(id, action_objects, action_name, action_params, action_settings, nil, t, "chain", condition_func_params)

					finish_action = false
				end
			end
		end
	end

	if finish_action then
		self:_handle_action_input_on_stop_action(id, t, running_action)
		self:_finish_action(handler_data, reason, data, t)
	end
end

ActionHandler._handle_action_input_on_stop_action = function (self, id, t, running_action)
	local action_settings = running_action:action_settings()
	local stop_input = action_settings.stop_input

	if stop_input then
		self._action_input_extension:action_transitioned_with_automatic_input(id, stop_input, t)
	elseif not self._alternate_fire_component.is_active then
		self._action_input_extension:clear_input_queue_and_sequences(id)
	end

	return false
end

ActionHandler.has_running_action = function (self, id)
	local handler_data = self._registered_components[id]

	fassert(handler_data, "Unknown id %q", id)

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

ActionHandler.update_actions = function (self, fixed_frame, id, condition_func_params, actions, action_objects, action_params)
	local t = fixed_frame * GameParameters.fixed_time_step
	local registered_components = self._registered_components
	local handler_data = registered_components[id]
	local action_name, action_settings, used_input, transition_type, automatic_input = self:_check_new_actions(handler_data, actions, condition_func_params, t, action_params)

	if action_name and not self._block_actions then
		if automatic_input then
			self._action_input_extension:action_transitioned_with_automatic_input(id, automatic_input, t)
		else
			self._action_input_extension:consume_next_input(id, t)
		end

		self:start_action(id, action_objects, action_name, action_params, action_settings, used_input, t, transition_type, condition_func_params)
	else
		automatic_input = self:_update_stop_input(id, handler_data, t)

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

	local condition_func = action_settings.condition_func

	if condition_func and not condition_func(action_settings, condition_func_params, used_input) then
		return false
	end

	local sprint_character_state_component = self._sprint_character_state_component
	local is_sprinting = Sprint.is_sprinting(sprint_character_state_component)

	if is_sprinting then
		if not ActionAvailability.available_in_sprint(action_settings) then
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
		local target_unit = self._targeting_component.target_unit_1

		if not target_unit then
			return false
		end
	end

	if ActionAvailability.needs_ammo(action_settings) then
		local inventory_component = self._inventory_component
		local wielded_slot = inventory_component.wielded_slot
		local ammo = Ammo.current_slot_clip_amount(self._unit, wielded_slot)

		if ammo <= 0 then
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
	local wanted_action_name, wanted_action_settings, wanted_used_input, automatic_input = nil

	if action_input then
		local chain_action = allowed_chain_actions[action_input]

		if chain_action then
			local chain_action_validated, action_name, action_settings = self:_validate_chain_action(chain_action, t, current_action_t, time_scale, actions, condition_func_params, used_input)

			if chain_action_validated then
				wanted_action_name = action_name
				wanted_action_settings = action_settings
				wanted_used_input = used_input
				automatic_input = nil
			end
		end
	end

	if not wanted_action_name then
		local running_action = handler_data.running_action
		local running_action_state = running_action:running_action_state(t, current_action_t)

		if running_action_state then
			local running_action_chain_config = running_action_state_to_action_input[running_action_state]

			if running_action_chain_config then
				local running_action_input = running_action_chain_config.input_name
				local chain_action = allowed_chain_actions[running_action_input]

				if chain_action then
					local chain_action_validated, action_name, action_settings = self:_validate_chain_action(chain_action, t, current_action_t, time_scale, actions, condition_func_params, used_input)

					if chain_action_validated then
						wanted_action_name = action_name
						wanted_action_settings = action_settings
						wanted_used_input = nil
						automatic_input = running_action_input
					end
				end
			end
		end
	end

	if not wanted_action_name then
		local conditional_state_funcs = self._conditional_state_functions
		local remaining_time = current_action_end_t - t

		for conditional_state, conditional_state_config in pairs(conditional_state_to_action_input) do
			local conditional_action_input = conditional_state_config.input_name
			local func = conditional_state_funcs[conditional_state]
			local chain_action = allowed_chain_actions[conditional_action_input]

			if chain_action and func(condition_func_params, action_params, remaining_time) then
				local chain_action_validated, action_name, action_settings = self:_validate_chain_action(chain_action, t, current_action_t, time_scale, actions, condition_func_params, used_input)

				if chain_action_validated then
					wanted_action_name = action_name
					wanted_action_settings = action_settings
					wanted_used_input = nil
					automatic_input = conditional_action_input

					break
				end
			end
		end
	end

	if wanted_action_name then
		return wanted_action_name, wanted_action_settings, wanted_used_input, "chain", automatic_input
	else
		return nil, nil, nil, nil, nil, nil
	end
end

ActionHandler._validate_chain_action = function (self, chain_action, t, current_action_t, time_scale, actions, condition_func_params, used_input)
	local chain_time = chain_action.chain_time and chain_action.chain_time / time_scale
	local chain_until = chain_action.chain_until and chain_action.chain_until / time_scale
	local chain_validated = nil
	chain_validated = not chain_time or (chain_time and chain_time <= current_action_t or chain_until and current_action_t <= chain_until) and true
	local action_name = chain_action.action_name
	local action_settings = actions[action_name]
	local action_is_validated = chain_validated and self:_validate_action(action_settings, condition_func_params, t, used_input)

	return action_is_validated, action_name, action_settings
end

ActionHandler._valid_action_from_action_input = function (self, actions, action_input, t, condition_func_params, used_input)
	local current_settings, current_name = nil
	local current_priority = -math.huge

	for name, settings in pairs(actions) do
		local start_input = settings.start_input
		local priority = settings.priority or math.huge

		if start_input == action_input and current_priority < priority then
			local is_validated = self:_validate_action(settings, condition_func_params, t, used_input)

			if is_validated then
				current_settings = settings
				current_name = name
				current_priority = priority

				if not settings.priority then
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

	local wanted_action, wanted_action_settings, automatic_input = nil

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

			if func(condition_func_params, action_params) then
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

ActionHandler._update_stop_input = function (self, id, handler_data, t)
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

	local action_input_extension = self._action_input_extension
	local action_component_name = handler_data.id
	local action_input = action_input_extension:peek_next_input(action_component_name)

	if action_input == stop_input then
		action_input_extension:consume_next_input(action_component_name, t)
		self:_finish_action(handler_data, "hold_input_released", nil, t)

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
				self:_finish_action(handler_data, "hold_input_released", nil, t)

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
			local chain_action_validated, _, _ = self:_validate_chain_action(chain_action, t, current_action_t, time_scale, actions, condition_func_params, used_input)

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

	fassert(template, "Failed fetching template %q, could not be found.", template_name)

	return template
end

return ActionHandler
