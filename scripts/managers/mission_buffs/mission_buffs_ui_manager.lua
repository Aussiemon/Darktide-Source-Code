-- chunkname: @scripts/managers/mission_buffs/mission_buffs_ui_manager.lua

local HordesModeSettings = require("scripts/settings/hordes_mode_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local MissionBuffsUIManager = class("MissionBuffsUIManager")

MissionBuffsUIManager.init = function (self, mission_buffs_manager, game_mode, is_server, network_event_delegate)
	self._game_mode = game_mode
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._choice_notifications_queue = {}
	self._buff_received_notifications_queue = {}
	self._current_notification = nil
end

MissionBuffsUIManager.destroy = function (self)
	self._game_mode = nil
	self._network_event_delegate = nil
	self._current_notification = nil
end

MissionBuffsUIManager.current_choice_resolved = function (self)
	Log.info("MissionBuffsUIManager", "Current choice resolved!")

	local current_notification = self._current_notification

	if current_notification and current_notification.is_choice_notification then
		self._current_notification = nil
	end
end

MissionBuffsUIManager.try_show_new_ui_notification = function (self)
	local choice_notifications_queue = self._choice_notifications_queue
	local buff_received_notifications_queue = self._buff_received_notifications_queue
	local has_notifications_in_queue = #choice_notifications_queue > 0 or #buff_received_notifications_queue > 0

	if not has_notifications_in_queue then
		Log.info("MissionBuffsUIManager", "No notifications left.")

		return
	end

	local can_show_notification = self:check_if_can_show_choice_notification()

	if not can_show_notification then
		Log.info("MissionBuffsUIManager", "Can't show notification!")

		return
	end

	local target_queue = #choice_notifications_queue > 0 and choice_notifications_queue or buff_received_notifications_queue
	local new_ui_notification = target_queue[1]
	local current_notification = self._current_notification
	local is_active_notification_a_choice = current_notification and current_notification.is_choice_notification

	if is_active_notification_a_choice then
		Log.info("MissionBuffsUIManager", "Current notification is a choice. Waiting for resolution.")

		return
	end

	local num_waves_per_island = HordesModeSettings.waves_per_island
	local is_new_notification_a_choice = new_ui_notification.is_choice_notification
	local time_left = self:get_time_left_between_waves()
	local waves_completed = self._game_mode:get_last_wave_completed()
	local is_after_last_wave_end = num_waves_per_island <= waves_completed
	local player

	if Managers.connection:is_initialized() then
		local peer_id = Network.peer_id()
		local local_player_id = 1

		player = Managers.player:player(peer_id, local_player_id)
	end

	local unit = player and player.player_unit
	local unit_data_extension = unit and ScriptUnit.extension(unit, "unit_data_system")
	local is_spectating = unit_data_extension and PlayerUnitStatus.is_hogtied(unit_data_extension:read_component("character_state"))
	local player_not_alive = not player or player and not player:unit_is_alive()

	if waves_completed > 0 and not is_after_last_wave_end and not time_left then
		Log.info("MissionBuffsUIManager", string.format("Tried to show UI notification outside the pause between waves."))

		return
	elseif is_new_notification_a_choice and time_left and time_left < 5 then
		Log.info("MissionBuffsUIManager", string.format("Tried to show Choice UI notification with little time left before wave start. Time left: %f.", time_left))

		return
	elseif is_new_notification_a_choice and player_not_alive or is_spectating then
		Log.info("MissionBuffsUIManager", string.format("Tried to show Choice UI notification while player is not alive or waiting for rescue"))

		return
	end

	table.remove(target_queue, 1)

	local default_timer = waves_completed > 0 and 20 or is_new_notification_a_choice and 30 or 5

	new_ui_notification.timer = time_left or default_timer
	new_ui_notification.wave_num = waves_completed > 0 and waves_completed or nil
	new_ui_notification.state = new_ui_notification.is_buff_family and waves_completed > 0 and "completed" or new_ui_notification.state

	Log.info("MissionBuffsUIManager", "New notification triggered. Type: %s | Timer: %f | Wave Num: %d", is_new_notification_a_choice and "Choice" or "Buff Received", new_ui_notification.timer, waves_completed)

	self._current_notification = new_ui_notification

	Managers.event:trigger("event_mission_buffs_update_presentation", new_ui_notification)
end

MissionBuffsUIManager._check_if_notification_already_exists = function (self, new_notification)
	local is_choice_notification = new_notification.is_choice_notification
	local target_queue = is_choice_notification and self._choice_notifications_queue or self._buff_received_notifications_queue
	local current_notification = self._current_notification
	local is_same_notification = current_notification and self:_compare_notifications(new_notification, current_notification)

	if is_same_notification then
		return true
	end

	for _, queue_notification in ipairs(target_queue) do
		is_same_notification = self:_compare_notifications(new_notification, queue_notification)

		if is_same_notification then
			break
		end
	end

	return is_same_notification
end

MissionBuffsUIManager._queue_ui_notification = function (self, context)
	local is_choice_ui = context.is_choice_notification
	local target_queue = is_choice_ui and self._choice_notifications_queue or self._buff_received_notifications_queue

	table.insert(target_queue, context)
	self:try_show_new_ui_notification()
end

MissionBuffsUIManager.queue_choice_selection_ui = function (self, is_buff_family_choice, options, wave_num)
	Log.info("MissionBuffsUIManager", "New Choice UI Queued Wave(%d) | FamilyChoice?(%s) | Option1(%s) | Option2(%s) | Option3(%s)", wave_num, is_buff_family_choice and "Y" or "N", options[1], options[2], options[3])

	local time_left = self:get_time_left_between_waves()
	local timer = time_left or 30
	local ui_context_data = {
		is_choice_notification = true,
		timer = timer,
		state = wave_num > 0 and "completed" or nil,
		is_buff_family = is_buff_family_choice,
		buffs = options,
		wave_num = wave_num > 0 and wave_num or nil,
	}

	if not self:_check_if_notification_already_exists(ui_context_data) then
		self:_queue_ui_notification(ui_context_data)
	else
		self:try_show_new_ui_notification()
	end
end

MissionBuffsUIManager.queue_buff_received_notification_ui = function (self, buff_name, buff_family_source_id, wave_num)
	Log.info("MissionBuffsUIManager", "New Buff Received UI Queued Wave(%d) | BuffName(%s)", wave_num, buff_name)

	local time_left = self:get_time_left_between_waves()
	local timer = time_left or 20
	local ui_context_data = {
		is_choice_notification = false,
		timer = wave_num > 0 and timer or 5,
		state = wave_num > 0 and "completed" or nil,
		buffs = {
			buff_name,
		},
		buff_family_source_id = buff_family_source_id,
		wave_num = wave_num > 0 and wave_num or nil,
	}

	if self:_check_if_notification_already_exists(ui_context_data) then
		Log.info("MissionBuffsUIManager", "Notification already exists. Skipping.")

		return
	end

	local num_queued_choice_notifications = #self._choice_notifications_queue

	if num_queued_choice_notifications > 0 then
		Log.info("MissionBuffsUIManager", "Buff notification skipped. Prioritizing Choices queued.")
		self:try_show_new_ui_notification()
	else
		self:_queue_ui_notification(ui_context_data)
	end
end

MissionBuffsUIManager.queue_wave_end_notification_ui = function (self, wave_num)
	Log.info("MissionBuffsUIManager", "New Wave End UI Queued Wave(%d)", wave_num)

	local time_left = self:get_time_left_between_waves()
	local timer = time_left or 20
	local ui_context_data = {
		buffs = nil,
		is_choice_notification = false,
		state = "completed",
		timer = timer,
		wave_num = wave_num,
	}

	if self:_check_if_notification_already_exists(ui_context_data) then
		Log.info("MissionBuffsUIManager", "Notification already exists. Skipping.")

		return
	end

	local num_queued_choice_notifications = #self._choice_notifications_queue

	if num_queued_choice_notifications > 0 then
		Log.info("MissionBuffsUIManager", "Buff notification skipped. Prioritizing Choices queued.")
		self:try_show_new_ui_notification()
	else
		self:_queue_ui_notification(ui_context_data)
	end
end

MissionBuffsUIManager.check_if_can_show_choice_notification = function (self)
	local game_mode = self._game_mode
	local current_wave_num = game_mode:get_current_wave()
	local num_waves_per_island = HordesModeSettings.waves_per_island

	if current_wave_num == 0 or num_waves_per_island <= current_wave_num then
		Log.info("MissionBuffsUIManager", string.format("Allow all notifications in wave 0 or after last wave is completed. Wave Num: %d", current_wave_num))

		return true
	end

	local is_wave_in_progress = self._game_mode:is_wave_in_progress()
	local time_left_between_waves = not is_wave_in_progress and self:get_time_left_between_waves() or 0
	local can_show_notification = not is_wave_in_progress and time_left_between_waves and time_left_between_waves > 10

	if not can_show_notification then
		Log.info("MissionBuffsUIManager", string.format("Not a good time to show notification. Is wave ongoing? %s | Time left before next wave: %f", is_wave_in_progress and "Y" or "N", time_left_between_waves))
	end

	return can_show_notification
end

MissionBuffsUIManager.check_if_can_show_buff_received_notification = function (self)
	local game_mode = self._game_mode
	local current_wave_num = game_mode:get_current_wave()

	if current_wave_num == 0 then
		return true
	end

	local is_wave_in_progress = game_mode:is_wave_in_progress()

	if is_wave_in_progress then
		return false
	end

	local time_left_between_waves = self:get_time_left_between_waves()

	return time_left_between_waves and time_left_between_waves < 5
end

MissionBuffsUIManager._compare_notifications = function (self, notification_a, notification_b)
	local buffs_a = notification_a.buffs
	local buffs_b = notification_b.buffs

	if buffs_a == nil and buffs_b == nil then
		return notification_a.wave_num == notification_b.wave_num and notification_a.state == notification_b.state
	end

	if buffs_a == nil or buffs_b == nil or #buffs_a ~= #buffs_b then
		return false
	end

	local matches = 0

	for _, buff_a in ipairs(buffs_a) do
		for _, buff_b in ipairs(buffs_b) do
			if buff_a == buff_b then
				matches = matches + 1

				break
			end
		end
	end

	return matches == #buffs_a
end

MissionBuffsUIManager.get_time_left_between_waves = function (self)
	local game_mode = self._game_mode
	local mission_objective_system = Managers.state.extension:system("mission_objective_system")
	local last_wave_completed = game_mode:get_last_wave_completed()
	local objective_name_formating_function = HordesModeSettings.mission_objectives.name_formating_function
	local inbetween_waves_objective_name = objective_name_formating_function(HordesModeSettings.mission_objectives.between_waves_objective.name, last_wave_completed)
	local between_waves_mission_objective = mission_objective_system:active_objective(inbetween_waves_objective_name)

	if between_waves_mission_objective then
		local time_remaining = between_waves_mission_objective:get_time_left() or 0

		return time_remaining >= 0 and time_remaining or 0
	end

	return nil
end

return MissionBuffsUIManager
