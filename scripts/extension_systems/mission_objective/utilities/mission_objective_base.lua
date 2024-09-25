-- chunkname: @scripts/extension_systems/mission_objective/utilities/mission_objective_base.lua

local MissionSoundEvents = require("scripts/settings/sound/mission_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local MissionObjectiveBase = class("MissionObjectiveBase")
local last_activation_order = 1
local WWISE_MUSIC_STATE_NONE = WwiseGameSyncSettings.state_groups.music_game_state.none
local OBJECTIVE_EVENT_TYPES = table.enum("None", "mid_event", "end_event")

MissionObjectiveBase.init = function (self)
	self._name = nil
	self._objective_type = nil
	self._is_updated_externally = false
	self._order_of_activation = 0
	self._objective_category = "default"
	self._is_side_mission = false
	self._registered_units = {}
	self._objective_units = {}
	self._marked_units = {}
	self._synchronizer_extension = nil
	self._synchronizer_unit = nil
	self._paused = false
	self._stage = 1
	self._stage_count = 1
	self._progression = 0
	self._has_second_progression = false
	self._second_progression = 0
	self._incremented_progression = 0
	self._max_incremented_progression = 0
	self._progression_sync_granularity = 0.01
	self._ui_state = "default"
	self._header = ""
	self._description = ""
	self._override_header = nil
	self._override_description = nil
	self._music_wwise_state = WWISE_MUSIC_STATE_NONE
	self._mission_giver_voice_profile = nil
	self._use_hud = true
	self._use_hud_changed = false
	self._hide_widget = false
	self._use_counter = true
	self._progress_bar = false
	self._progress_bar_icon = nil
	self._progress_timer = false
	self._popups_enabled = true
	self._icon = nil
	self._marker_type = nil
	self._show_progression_popup_on_update = true
	self._evaluate_at_level_end = false
	self._turn_off_backfill = false
	self._event_type = OBJECTIVE_EVENT_TYPES.None
	self._mission_objective_system = Managers.state.extension:system("mission_objective_system")
end

MissionObjectiveBase.destroy = function (self)
	return
end

MissionObjectiveBase.start_objective = function (self, mission_objective_data, registered_units, synchronizer_unit)
	self._name = mission_objective_data.name
	self._objective_type = mission_objective_data.mission_objective_type
	self._order_of_activation = last_activation_order
	last_activation_order = last_activation_order + 1
	self._ui_state = mission_objective_data.ui_state or "default"
	self._header = mission_objective_data.header and Localize(mission_objective_data.header) or ""
	self._description = mission_objective_data.description and Localize(mission_objective_data.description) or ""
	self._music_wwise_state = mission_objective_data.music_wwise_state or WWISE_MUSIC_STATE_NONE
	self._music_ignore_start_event = mission_objective_data.music_ignore_start_event or false
	self._mission_giver_voice_profile = mission_objective_data.mission_giver_voice_profile
	self._use_hud = mission_objective_data.hidden ~= true
	self._use_counter = mission_objective_data.progress_bar ~= true or mission_objective_data.progress_timer ~= true
	self._hide_widget = mission_objective_data.hide_widget or false
	self._progress_bar = mission_objective_data.progress_bar or false
	self._progress_bar_icon = mission_objective_data.progress_bar_icon
	self._progress_timer = mission_objective_data.progress_timer or false
	self._large_progress_bar = mission_objective_data.large_progress_bar or false
	self._objective_category = mission_objective_data.objective_category
	self._is_side_mission = mission_objective_data.objective_category == "side_mission"
	self._popups_enabled = mission_objective_data.popups_enabled ~= false
	self._evaluate_at_level_end = mission_objective_data.evaluate_at_level_end or false
	self._event_type = mission_objective_data.event_type or OBJECTIVE_EVENT_TYPES.None
	self._icon = mission_objective_data.icon
	self._marker_type = mission_objective_data.marker_type or self._marker_type
	self._turn_off_backfill = mission_objective_data.turn_off_backfill == true
	self._locally_added = mission_objective_data.locally_added or false
	self._stage = 1
	self._stage_count = 1
	self._incremented_progression = 0
	self._max_incremented_progression = 0
	self._progression = 0
	self._has_second_progression = mission_objective_data.has_second_progression or false
	self._second_progression = 0

	if mission_objective_data.show_progression_popup_on_update == nil then
		self._show_progression_popup_on_update = true
	else
		self._show_progression_popup_on_update = mission_objective_data.show_progression_popup_on_update
	end

	self._progression_sync_granularity = mission_objective_data.progression_sync_granularity or 0.01
	self._registered_units = registered_units
	self._objective_units = {}
	self._marked_units = {}
	self._synchronizer_unit = synchronizer_unit

	if synchronizer_unit then
		local synchronizer_extension = ScriptUnit.extension(synchronizer_unit, "event_synchronizer_system")

		synchronizer_extension:objective_started()

		self._synchronizer_extension = synchronizer_extension
	end

	if self._music_wwise_state ~= WWISE_MUSIC_STATE_NONE then
		local event = "objective_start_" .. self._objective_type

		if MissionSoundEvents[event] and not mission_objective_data.music_ignore_start_event then
			self._mission_objective_system:sound_event(MissionSoundEvents[event])
		end
	end

	if self._large_progress_bar then
		Managers.event:trigger("objective_progress_bar_open", self)
	end
end

MissionObjectiveBase.start_stage = function (self, stage)
	self._stage = stage
	self._incremented_progression = 0
	self._max_incremented_progression = 0
	self._progression = 0
	self._second_progression = 0
	self._objective_units = {}

	local units = self:_get_active_units()
	local synchronizer_extension = self._synchronizer_extension

	if synchronizer_extension then
		synchronizer_extension:start_stage(stage)
	end

	for _, unit in ipairs(units) do
		self:_init_objective_unit(unit)
	end

	self:stage_to_flow()
end

MissionObjectiveBase.stage_done = function (self)
	local synchronizer_extension = self._synchronizer_extension

	if synchronizer_extension then
		if self._stage < self._stage_count then
			synchronizer_extension:finished_stage()

			self._stage = self._stage + 1

			local mission_objective_system = Managers.state.extension:system("mission_objective_system")

			mission_objective_system:start_mission_objective_stage(self._name, self._stage)
		else
			if self._music_wwise_state ~= WWISE_MUSIC_STATE_NONE then
				self._mission_objective_system:sound_event(MissionSoundEvents.objective_finished)
			end

			synchronizer_extension:finished_event()
		end
	end
end

MissionObjectiveBase._get_active_units = function (self)
	local registered_units = self._registered_units
	local registered_stage_units = {}

	if registered_units then
		registered_stage_units = registered_units[self._stage]
	end

	local units_sorted_by_id = self:_sort_units_by_id(registered_stage_units)
	local synchronizer_extension = self._synchronizer_extension

	if synchronizer_extension then
		units_sorted_by_id = synchronizer_extension:register_connected_units(units_sorted_by_id, registered_units, self._stage)
		self._synchronizer_extension = synchronizer_extension
	end

	return units_sorted_by_id
end

MissionObjectiveBase._sort_units_by_id = function (self, units)
	if #units == 0 then
		return units
	end

	local function sort_comp(unit_l, unit_r)
		local _, unit_id_l = Managers.state.unit_spawner:game_object_id_or_level_index(unit_l)
		local _, unit_id_r = Managers.state.unit_spawner:game_object_id_or_level_index(unit_r)

		return unit_id_l < unit_id_r
	end

	table.sort(units, sort_comp)

	return units
end

MissionObjectiveBase.end_objective = function (self)
	local units = self._objective_units
	local ALIVE = ALIVE

	for unit, _ in pairs(units) do
		if ALIVE[unit] then
			self:_deinit_objective_unit(unit)
			Unit.flow_event(unit, "lua_objective_end")
		end
	end

	local synchronizer_unit = self._synchronizer_unit

	if synchronizer_unit and ALIVE[synchronizer_unit] then
		Unit.flow_event(synchronizer_unit, "lua_objective_end")
	end

	if self._large_progress_bar then
		Managers.event:trigger("objective_progress_bar_close", self)
	end
end

MissionObjectiveBase.update = function (self, dt)
	return
end

MissionObjectiveBase.update_increment = function (self, increment)
	self._incremented_progression = self._incremented_progression + increment
end

MissionObjectiveBase.update_progression = function (self)
	return
end

MissionObjectiveBase.progression_to_flow = function (self)
	local units = self._objective_units
	local ALIVE = ALIVE

	for unit, _ in pairs(units) do
		if ALIVE[unit] then
			Unit.set_flow_variable(unit, "lua_var_objective_progression", self._progression)
			Unit.flow_event(unit, "lua_event_objective_progression")
		end
	end

	local synchronizer_unit = self._synchronizer_unit

	if synchronizer_unit and ALIVE[synchronizer_unit] then
		Unit.set_flow_variable(synchronizer_unit, "lua_var_objective_progression", self._progression)
		Unit.flow_event(synchronizer_unit, "lua_event_objective_progression")
	end
end

MissionObjectiveBase.stage_to_flow = function (self)
	local synchronizer_unit = self._synchronizer_unit

	if synchronizer_unit and ALIVE[synchronizer_unit] then
		Unit.set_flow_variable(synchronizer_unit, "lua_var_objective_stage", self._stage)
		Unit.flow_event(synchronizer_unit, "lua_event_objective_stage")
	end
end

local function _owned_by_death_manager(hit_unit)
	local unit_data_ext = ScriptUnit.has_extension(hit_unit, "unit_data_system")

	if not unit_data_ext then
		return false
	end

	local owned_by_death_manager = unit_data_ext:is_owned_by_death_manager()

	return owned_by_death_manager
end

MissionObjectiveBase.clear_invalid_units = function (self)
	local objective_units = self._objective_units
	local ALIVE = ALIVE

	for unit, _ in pairs(objective_units) do
		local owned_by_death_manager = _owned_by_death_manager(unit)

		if not ALIVE[unit] or owned_by_death_manager then
			objective_units[unit] = nil
		end
	end

	local marked_units = self._marked_units

	for unit, _ in pairs(marked_units) do
		local owned_by_death_manager = _owned_by_death_manager(unit)

		if not ALIVE[unit] or owned_by_death_manager then
			marked_units[unit] = nil
		end
	end
end

MissionObjectiveBase._init_objective_unit = function (self, unit)
	local mission_objective_target_extension = ScriptUnit.extension(unit, "mission_objective_target_system")

	if mission_objective_target_extension:enabled_only_during_mission() and self._name == mission_objective_target_extension:objective_name() then
		mission_objective_target_extension:enable_unit()
	end

	if mission_objective_target_extension:should_add_marker_on_objective_start() then
		mission_objective_target_extension:add_unit_marker()
	end

	self:register_unit(unit)
end

MissionObjectiveBase._deinit_objective_unit = function (self, unit)
	self:unregister_unit(unit)

	local mission_objective_target_extension = ScriptUnit.has_extension(unit, "mission_objective_target_system")

	if mission_objective_target_extension and mission_objective_target_extension:should_add_marker_on_objective_start() then
		mission_objective_target_extension:remove_unit_marker()
	end

	if mission_objective_target_extension and mission_objective_target_extension:enabled_only_during_mission() and self._name == mission_objective_target_extension:objective_name() then
		mission_objective_target_extension:disable_unit()
	end
end

MissionObjectiveBase.register_unit = function (self, unit)
	self._objective_units[unit] = true
end

MissionObjectiveBase.unregister_unit = function (self, unit)
	self._objective_units[unit] = nil
end

MissionObjectiveBase.unit_registered = function (self, unit)
	return self._objective_units[unit] ~= nil
end

MissionObjectiveBase.add_marker = function (self, unit)
	self._marked_units[unit] = true
end

MissionObjectiveBase.remove_marker = function (self, unit)
	self._marked_units[unit] = nil
end

MissionObjectiveBase.has_marker = function (self, unit)
	return self._marked_units[unit] ~= nil
end

MissionObjectiveBase.add_marker_on_hot_join = function (self, unit)
	return self:has_marker(unit)
end

MissionObjectiveBase.objective_units = function (self)
	return self._objective_units
end

MissionObjectiveBase.marked_units = function (self)
	return self._marked_units
end

MissionObjectiveBase.synchronizer_extension = function (self)
	return self._synchronizer_extension
end

MissionObjectiveBase.synchronizer_unit = function (self)
	return self._synchronizer_unit
end

MissionObjectiveBase.name = function (self)
	return self._name
end

MissionObjectiveBase.objective_type = function (self)
	return self._objective_type
end

MissionObjectiveBase.ui_state = function (self)
	return self._ui_state
end

MissionObjectiveBase.set_ui_state = function (self, ui_state)
	self._ui_state = ui_state
end

MissionObjectiveBase.order_of_activation = function (self)
	return self._order_of_activation
end

MissionObjectiveBase.is_paused = function (self)
	return self._paused
end

MissionObjectiveBase.pause = function (self)
	self._paused = true
end

MissionObjectiveBase.resume = function (self)
	self._paused = false
end

MissionObjectiveBase.max_progression_achieved = function (self)
	return self._progression == 1 and not self._paused
end

MissionObjectiveBase.evaluate_at_level_end = function (self)
	return self._evaluate_at_level_end
end

MissionObjectiveBase.is_done = function (self)
	return self:max_progression_achieved()
end

MissionObjectiveBase.event_type = function (self)
	return self._event_type
end

MissionObjectiveBase.set_stage = function (self, value)
	self._stage = value
end

MissionObjectiveBase.stage = function (self)
	return self._stage
end

MissionObjectiveBase.set_stage_count = function (self, value)
	self._stage_count = value
end

MissionObjectiveBase.stage_count = function (self)
	return self._stage_count
end

MissionObjectiveBase.progression = function (self)
	return self._progression
end

MissionObjectiveBase.progression_sync_granularity = function (self)
	return self._progression_sync_granularity
end

MissionObjectiveBase.total_progression = function (self)
	return (self:stage() - 1 + self:progression()) / self:stage_count()
end

MissionObjectiveBase.has_second_progression = function (self)
	return self._has_second_progression
end

MissionObjectiveBase.second_progression = function (self)
	return self._second_progression
end

MissionObjectiveBase.set_increment = function (self, amount)
	self._incremented_progression = amount
end

MissionObjectiveBase.incremented_progression = function (self)
	return self._incremented_progression
end

MissionObjectiveBase.turn_off_backfill = function (self)
	return self._turn_off_backfill
end

MissionObjectiveBase.set_max_increment = function (self, max_amount)
	self._max_incremented_progression = max_amount
end

MissionObjectiveBase.max_incremented_progression = function (self)
	return self._max_incremented_progression
end

MissionObjectiveBase.show_progression_popup_on_update = function (self)
	return self._show_progression_popup_on_update
end

MissionObjectiveBase.music_wwise_state = function (self)
	return self._music_wwise_state
end

MissionObjectiveBase.mission_giver_voice_profile = function (self)
	return self._mission_giver_voice_profile
end

MissionObjectiveBase.set_updated_externally = function (self, value)
	self._is_updated_externally = value
end

MissionObjectiveBase.is_updated_externally = function (self)
	return self._is_updated_externally
end

MissionObjectiveBase.set_progression = function (self, progression)
	self._progression = progression
end

MissionObjectiveBase.set_second_progression = function (self, progression)
	self._second_progression = progression
end

MissionObjectiveBase.use_hud = function (self)
	return self._use_hud
end

MissionObjectiveBase.use_hud_changed_state = function (self)
	if not self._use_hud_changed then
		return nil
	end

	return self._use_hud
end

MissionObjectiveBase.set_use_ui = function (self, use_hud)
	self._use_hud = use_hud
	self._use_hud_changed = true
end

MissionObjectiveBase.hide_widget = function (self)
	return self._hide_widget
end

MissionObjectiveBase.popups_enabled = function (self)
	return self._popups_enabled
end

MissionObjectiveBase.locally_added = function (self)
	return self._locally_added
end

MissionObjectiveBase.use_counter = function (self)
	return self._use_counter and self:max_incremented_progression() > 0
end

MissionObjectiveBase.use_counter_changed_state = function (self)
	if self._use_counter then
		return nil
	end

	return self._use_counter
end

MissionObjectiveBase.set_use_counter = function (self, use_counter)
	self._use_counter = use_counter
end

MissionObjectiveBase.progress_bar = function (self)
	return self._progress_bar
end

MissionObjectiveBase.set_progress_bar = function (self, use_bar)
	self._progress_bar = use_bar
end

MissionObjectiveBase.progress_bar_icon = function (self)
	return self._progress_bar_icon
end

MissionObjectiveBase.progress_timer = function (self)
	return self._progress_timer
end

MissionObjectiveBase.set_progress_timer = function (self, use_timer)
	self._progress_timer = use_timer
end

MissionObjectiveBase.large_progress_bar = function (self)
	return self._large_progress_bar
end

MissionObjectiveBase.header = function (self)
	if self._override_header then
		return self._override_header
	end

	return self._header
end

MissionObjectiveBase.set_header = function (self, header)
	self._override_header = header
end

MissionObjectiveBase.description = function (self)
	if self._override_description then
		return self._override_description
	end

	return self._description
end

MissionObjectiveBase.set_description = function (self, description)
	self._override_description = description
end

MissionObjectiveBase.icon = function (self)
	return self._icon
end

MissionObjectiveBase.objective_category = function (self)
	return self._objective_category
end

MissionObjectiveBase.is_side_mission = function (self)
	return self._is_side_mission
end

MissionObjectiveBase.marker_type = function (self)
	return self._marker_type
end

MissionObjectiveBase.set_marker_type = function (self, marker_type)
	self._marker_type = marker_type
end

return MissionObjectiveBase
