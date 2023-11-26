-- chunkname: @scripts/settings/action_input_formatter/action_input_formatter_settings.lua

local action_input_formatter_settings = {}

action_input_formatter_settings.weapon = {
	max_action_inputs = 32,
	max_action_input_queue = 8,
	network_constants = {
		input_sequence_is_running = NetworkConstants.weapon_input_sequence_is_running,
		input_sequence_current_element_index = NetworkConstants.weapon_input_sequence_current_element_index,
		input_sequence_element_start_t = NetworkConstants.weapon_input_sequence_element_start_t,
		input_queue_action_input = NetworkConstants.weapon_input_queue_action_input,
		input_queue_raw_input = NetworkConstants.weapon_input_queue_raw_input,
		input_queue_produced_by_hierarchy = NetworkConstants.weapon_input_queue_produced_by_hierarchy,
		input_queue_hierarchy_position = NetworkConstants.weapon_input_queue_hierarchy_position,
		action_input_hierarchy_position_max_size = NetworkConstants.action_input_hierarchy_position_max_size
	}
}
action_input_formatter_settings.ability = {
	max_action_inputs = 4,
	max_action_input_queue = 8,
	network_constants = {
		input_sequence_is_running = NetworkConstants.ability_input_sequence_is_running,
		input_sequence_current_element_index = NetworkConstants.ability_input_sequence_current_element_index,
		input_sequence_element_start_t = NetworkConstants.ability_input_sequence_element_start_t,
		input_queue_action_input = NetworkConstants.ability_input_queue_action_input,
		input_queue_raw_input = NetworkConstants.ability_input_queue_raw_input,
		input_queue_produced_by_hierarchy = NetworkConstants.ability_input_queue_produced_by_hierarchy,
		input_queue_hierarchy_position = NetworkConstants.ability_input_queue_hierarchy_position,
		action_input_hierarchy_position_max_size = NetworkConstants.action_input_hierarchy_position_max_size
	}
}

return settings("ActionInputFormatterSettings", action_input_formatter_settings)
