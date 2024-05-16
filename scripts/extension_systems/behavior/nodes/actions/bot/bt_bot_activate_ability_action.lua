-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bot/bt_bot_activate_ability_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local AbilityTemplates = require("scripts/settings/ability/ability_templates/ability_templates")
local BtBotActivateAbilityAction = class("BtBotActivateAbilityAction", "BtNode")

BtBotActivateAbilityAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local ability_component_name = action_data.ability_component_name
	local ability_component = unit_data_extension:read_component(ability_component_name)
	local ability_template_name = ability_component.template_name
	local ability_template = AbilityTemplates[ability_template_name]
	local ability_meta_data = ability_template.ability_meta_data
	local activation_data = ability_meta_data.activation
	local wait_action_data = ability_meta_data.wait_action
	local end_condition_data = ability_meta_data.end_condition

	scratchpad.ability_component_name = ability_component_name
	scratchpad.do_start_input = true
	scratchpad.started = false
	scratchpad.enter_time = t
	scratchpad.activation_data = activation_data
	scratchpad.wait_action_data = wait_action_data
	scratchpad.end_condition_data = end_condition_data

	local action_input_extension = ScriptUnit.extension(unit, "action_input_system")

	scratchpad.action_input_extension = action_input_extension

	local input_extension = ScriptUnit.extension(unit, "input_system")
	local bot_unit_input = input_extension:bot_unit_input()

	scratchpad.bot_unit_input = bot_unit_input

	if end_condition_data then
		scratchpad.locomotion_component = unit_data_extension:read_component("locomotion")
		scratchpad.navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	end
end

BtBotActivateAbilityAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if not scratchpad.started then
		scratchpad.do_start_input, scratchpad.started = self:_start_ability(scratchpad, t)

		return "running"
	end

	local wait_action_data = scratchpad.wait_action_data

	if wait_action_data then
		self:_perform_wait_action(wait_action_data, scratchpad, action_data)
	end

	return self:_evaluate_end_condition(scratchpad, t)
end

BtBotActivateAbilityAction._start_ability = function (self, scratchpad, t)
	local started
	local do_start_input = scratchpad.do_start_input

	if do_start_input then
		local activation_data = scratchpad.activation_data

		if not scratchpad.activate_action_started then
			local action_input_extension = scratchpad.action_input_extension
			local ability_component_name, activate_action_input, raw_input = scratchpad.ability_component_name, activation_data.action_input

			action_input_extension:bot_queue_action_input(ability_component_name, activate_action_input, raw_input)

			scratchpad.activate_action_started = true
		end

		local enter_time = scratchpad.enter_time
		local min_hold_time = activation_data.min_hold_time or 0

		if t >= enter_time + min_hold_time then
			do_start_input, started = false, false
		else
			do_start_input, started = true, false
		end
	else
		do_start_input, started = false, true
	end

	return do_start_input, started
end

BtBotActivateAbilityAction._perform_wait_action = function (self, wait_action_data, scratchpad, action_data)
	local wait_action_input = wait_action_data.action_input

	if wait_action_input and not scratchpad.wait_action_started then
		local action_input_extension = scratchpad.action_input_extension
		local ability_component_name = action_data.ability_component_name
		local raw_input

		action_input_extension:bot_queue_action_input(ability_component_name, wait_action_input, raw_input)

		scratchpad.wait_action_started = true
	end
end

local MIN_DURATION = 0.5
local MIN_SPEED_SQ = 0.04000000000000001

BtBotActivateAbilityAction._evaluate_end_condition = function (self, scratchpad, t)
	local end_condition_data = scratchpad.end_condition_data

	if end_condition_data == nil or not end_condition_data.done_when_arriving_at_destination then
		return "done"
	end

	local done = false
	local done_when_arriving_at_destination = end_condition_data.done_when_arriving_at_destination
	local elapsed_time = t - scratchpad.enter_time
	local navigation_extension, locomotion_component = scratchpad.navigation_extension, scratchpad.locomotion_component

	if not done and done_when_arriving_at_destination then
		local current_velocity = locomotion_component.velocity_current
		local speed_sq = Vector3.length_squared(current_velocity)
		local destination_reached = navigation_extension:destination_reached()

		if elapsed_time > MIN_DURATION and (destination_reached or speed_sq <= MIN_SPEED_SQ) then
			done = true
		end
	end

	if done then
		return "done"
	else
		return "running"
	end
end

return BtBotActivateAbilityAction
