local function _require_buff_class(buff)
	local base_path = "scripts/extension_systems/buff/buffs/"
	local buff_file_name = base_path .. buff
	local class = require(buff_file_name)

	return class
end

local buff_classes = {
	active_time_offset_proc_buff = _require_buff_class("active_time_offset_proc_buff"),
	buff = _require_buff_class("buff"),
	conditional_switch_stat_buff = _require_buff_class("conditional_switch_stat_buff"),
	grimoire_buff = _require_buff_class("grimoire_buff"),
	interval_buff = _require_buff_class("interval_buff"),
	limit_range_buff = _require_buff_class("limit_range_buff"),
	proc_buff = _require_buff_class("proc_buff"),
	proc_extendable_duration_buff = _require_buff_class("proc_extendable_duration_buff"),
	special_rules_based_lerped_stat_buff = _require_buff_class("special_rules_based_lerped_stat_buff"),
	stepped_range_buff = _require_buff_class("stepped_range_buff"),
	stepped_stat_buff = _require_buff_class("stepped_stat_buff"),
	timed_trigger_buff = _require_buff_class("timed_trigger_buff"),
	weapon_trait_parent_proc_buff = _require_buff_class("weapon_trait_parent_proc_buff"),
	weapon_trait_proc_conditional_switch_buff = _require_buff_class("weapon_trait_proc_conditional_switch_buff"),
	weapon_trait_activated_parent_proc_buff = _require_buff_class("weapon_trait_activated_parent_proc_buff"),
	weapon_trait_target_number_parent_proc_buff = _require_buff_class("weapon_trait_target_number_parent_proc_buff"),
	psyker_passive_buff = _require_buff_class("psyker_passive_buff"),
	zealot_passive_buff = _require_buff_class("zealot_passive_buff")
}

return buff_classes
