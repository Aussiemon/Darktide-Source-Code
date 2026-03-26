-- chunkname: @scripts/utilities/expeditions/expedition_timer_handler.lua

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local Vo = require("scripts/utilities/vo")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local TIMER_OBJECTIVE_NAME = "objective_expedition_timer"
local last_minute_sound = "wwise/events/player/play_device_auspex_exps_timer_signal_last_minute"
local time_out_sound = "wwise/events/player/play_device_auspex_exps_timer_signal_timer_out"
local timer_paused_sound = "wwise/events/player/play_device_auspex_exps_timer_signal_timer_pause"
local timer_started_sound = "wwise/events/player/play_device_auspex_exps_timer_signal_timer_start"
local _time_left_events = {
	[150] = {
		description = "loc_game_mode_expedition_timer_popup_warning_desc_first",
		header = "loc_game_mode_expedition_timer_popup_warning_title_first",
		sound_event = UISoundEvents.mission_objective_popup_new_expeditions,
	},
	[60] = {
		alert_objective = true,
		description = "loc_game_mode_expedition_timer_popup_warning_desc_final",
		header = "loc_game_mode_expedition_timer_popup_warning_title_final",
		type = "alert",
		sound_event = UISoundEvents.mission_objective_popup_new_expeditions,
		auspex_sound = last_minute_sound,
	},
}
local ExpeditionTimerHandler = class("ExpeditionTimerHandler")

ExpeditionTimerHandler.init = function (self, template, is_server)
	local timer_settings = template.timer_settings

	if not timer_settings then
		self._enabled = false

		return
	end

	self._is_server = is_server
	self._timer_settings = timer_settings
	self._enabled = (timer_settings.total_time or timer_settings.per_location) ~= nil
	self._split_timer = timer_settings.per_location ~= nil
	self._max_time_extension = 0
	self._pacing_timer_started = false
	self._is_running = false
	self._time_at_timer_runout = nil
	self._corruption_tick_timer = 0
	self._play_last_minute = false
	self._play_half_time = false
	self._buff_ids_by_unit = {}
end

ExpeditionTimerHandler.hot_join_sync = function (self, channel_id)
	RPC.rpc_expedition_timer_set_active(channel_id, self._enabled)
end

ExpeditionTimerHandler.setup_timer = function (self)
	if not self._enabled or not self._is_server then
		return
	end

	local mission_objective_system = Managers.state.extension:system("mission_objective_system")
	local duration = self._split_timer and self:_get_timer_time_for_location(1) or self._timer_settings.total_time

	mission_objective_system:start_mission_objective(TIMER_OBJECTIVE_NAME, nil, nil, nil, nil, duration)
	self:set_active(false)
end

ExpeditionTimerHandler.location_finished = function (self, index)
	if not self._enabled or not self._is_server then
		return
	end

	local bonus_from_safe_zone = self._timer_settings.bonus_from_safe_zone or 0
	local mission_objective_system = Managers.state.extension:system("mission_objective_system")
	local timer_objective = mission_objective_system:active_objective(TIMER_OBJECTIVE_NAME)

	if self._split_timer or bonus_from_safe_zone > 0 then
		local time_left = 0

		if timer_objective then
			time_left = timer_objective:max_incremented_progression() * (1 - timer_objective:progression())
		end

		time_left = time_left + bonus_from_safe_zone

		local max_time = self:_max_time()

		if max_time then
			time_left = math.min(time_left, max_time)
		end

		if bonus_from_safe_zone > 0 then
			self:_remove_all_corruption_screenspace_effects()
		end

		if timer_objective then
			mission_objective_system:end_mission_objective(TIMER_OBJECTIVE_NAME)
		end

		local duration = self._split_timer and self:_get_timer_time_for_location(index + 1) or time_left

		mission_objective_system:start_mission_objective(TIMER_OBJECTIVE_NAME, nil, nil, nil, nil, duration)

		if mission_objective_system:is_current_active_objective("objective_expedition_escape") then
			mission_objective_system:end_mission_objective("objective_expedition_escape")
		end

		self._is_running = true
		self._time_at_timer_runout = nil
	end
end

ExpeditionTimerHandler._get_timer_time_for_location = function (self, index)
	local location_times = self._timer_settings.per_location

	return location_times[math.min(index, #location_times)]
end

ExpeditionTimerHandler.set_active = function (self, active)
	if not self._enabled then
		return
	end

	self._pacing_timer_started = true

	local was_running = self._is_running

	self._is_running = active

	if self._is_server then
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")

		if mission_objective_system:is_current_active_objective(TIMER_OBJECTIVE_NAME) then
			local synchronizer_unit = mission_objective_system:objective_synchronizer_unit(TIMER_OBJECTIVE_NAME)
			local synchronizer_extension = ScriptUnit.extension(synchronizer_unit, "event_synchronizer_system")

			if active then
				synchronizer_extension:resume_event()
			else
				synchronizer_extension:pause_event()
			end
		end

		Managers.state.game_session:send_rpc_clients("rpc_expedition_timer_set_active", active)
	end

	if active then
		if not was_running then
			self:_play_sound(timer_started_sound)

			self._play_last_minute = true
		end
	elseif not was_running then
		self:_play_sound(timer_paused_sound)
	end
end

ExpeditionTimerHandler.get_remaining_duration = function (self)
	if not self._enabled then
		return nil
	end

	local mission_objective_system = Managers.state.extension:system("mission_objective_system")
	local timer_objective = mission_objective_system:active_objective(TIMER_OBJECTIVE_NAME)

	if not timer_objective then
		return 0
	end

	return timer_objective:get_time_left()
end

ExpeditionTimerHandler._reset_timed_events = function (self, from, to)
	for time, event in pairs(_time_left_events) do
		if event.done and from <= time and time <= to then
			event.done = false
		end
	end
end

ExpeditionTimerHandler.extend_max_time = function (self, time_bonus)
	self._max_time_extension = self._max_time_extension + time_bonus

	local mission_objective_system = Managers.state.extension:system("mission_objective_system")
	local timer_objective = mission_objective_system:active_objective(TIMER_OBJECTIVE_NAME)
	local current_time_left = timer_objective:get_time_left()
	local current_increment = timer_objective:incremented_progression()
	local current_max_increment = timer_objective:max_incremented_progression()

	timer_objective:set_increment(current_increment + time_bonus)
	timer_objective:set_max_increment(current_max_increment + time_bonus)
	mission_objective_system:propagate_objective_increment(timer_objective)
	self:_reset_timed_events(current_time_left, current_time_left + time_bonus)

	local new_timer_progression = timer_objective:progression()
	local new_time_remaining = timer_objective:max_incremented_progression() * (1 - new_timer_progression)

	if new_time_remaining > 60 then
		self._play_last_minute = true
	end

	self:_remove_all_corruption_screenspace_effects()
end

ExpeditionTimerHandler.update = function (self, dt, t)
	if not self._enabled or not self._pacing_timer_started then
		return
	end

	local objective_system = Managers.state.extension:system("mission_objective_system")
	local timer_objective = objective_system:active_objective(TIMER_OBJECTIVE_NAME)

	if timer_objective then
		if self._play_last_minute and timer_objective:max_incremented_progression() * (1 - timer_objective:progression()) <= 60 then
			self:_play_sound(last_minute_sound)
			Vo.mission_giver_mission_info_vo("selected_voice", "tech_priest_a", "expeditions_mission_forced_extraction_a")

			self._play_last_minute = false
		end

		local time_left = self:get_remaining_duration()

		for time, event in pairs(_time_left_events) do
			if not event.done and time_left <= time then
				if event.header then
					Managers.event:trigger("event_show_objective_popup", event.description, event.header, event.sound_event, event.type)
				end

				if event.auspex_sound then
					self:_play_sound(event.auspex_sound)
				end

				if self._is_server and event.alert_objective then
					objective_system:set_objective_ui_state(TIMER_OBJECTIVE_NAME, nil, "alert")
				end

				event.done = true
			end
		end

		return
	end

	if self._is_running then
		if not self._time_at_timer_runout then
			self:_play_sound(time_out_sound)

			self._time_at_timer_runout = t
		end

		if self._is_server then
			if not objective_system:is_current_active_objective("objective_expedition_escape") then
				objective_system:start_mission_objective("objective_expedition_escape")
				objective_system:set_objective_ui_state("objective_expedition_escape", nil, "critical")
			end

			if not self._disable_heat_decay and Managers.state.pacing:disable_heat_decay() then
				Managers.state.pacing:set_heat_decay_rate(0)

				self._disable_heat_decay = true
			end

			if not self._add_heat_timer then
				self._add_heat_timer = t + 1
			elseif self._add_heat_timer and t > self._add_heat_timer then
				Managers.state.pacing:add_heat_by_type("timer", nil, "time_elapsed")

				self._add_heat_timer = t + 1
			end

			local corruption_tick_time = self._timer_settings.corruption_tick_time or 0.5

			if corruption_tick_time < self._corruption_tick_timer then
				self:_apply_corruption(t)

				self._corruption_tick_timer = self._corruption_tick_timer - corruption_tick_time
			else
				self._corruption_tick_timer = self._corruption_tick_timer + dt
			end
		end
	end
end

ExpeditionTimerHandler._apply_corruption = function (self, t)
	local players = Managers.player:players()
	local damage_profile = DamageProfileTemplates.grimoire_tick
	local target_index = 0
	local is_critical_strike = false
	local timer_settings = self._timer_settings
	local damage = (timer_settings.corruption_base_damage or 20) * math.pow(timer_settings.corruption_time_power or 1.02, t - self._time_at_timer_runout)

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if player_unit then
			local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
			local stat_buffs = buff_extension:stat_buffs()
			local corruption_taken_multiplier = stat_buffs.corruption_taken_multiplier or 1

			Attack.execute(player_unit, damage_profile, "target_index", target_index, "target_number", target_index, "power_level", damage * corruption_taken_multiplier, "is_critical_strike", is_critical_strike, "attack_type", AttackSettings.attack_types.buff, "damage_type", DamageSettings.damage_types.corruption)
			self:_add_corruption_screenspace_effect(t, player_unit, buff_extension)
		end
	end
end

local CORRUPTION_BUFF_NAME = "expeditions_death_imminent"
local CORRUPTION_BUFF_KEYWORD = "expeditions_death_imminent"

ExpeditionTimerHandler._add_corruption_screenspace_effect = function (self, t, player_unit, buff_extension)
	if not buff_extension:has_keyword(CORRUPTION_BUFF_NAME) then
		local _, buff_id = buff_extension:add_externally_controlled_buff(CORRUPTION_BUFF_NAME, t)

		self._buff_ids_by_unit[player_unit] = buff_id
	end
end

ExpeditionTimerHandler._remove_all_corruption_screenspace_effects = function (self)
	local players = Managers.player:players()

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if player_unit then
			local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")
			local buff_id = self._buff_ids_by_unit[player_unit]

			if buff_extension and buff_extension:has_keyword(CORRUPTION_BUFF_KEYWORD) and buff_id then
				buff_extension:remove_externally_controlled_buff(buff_id)
			end
		end
	end
end

ExpeditionTimerHandler._play_sound = function (self, event_name)
	local ui_manager = Managers.ui

	if not ui_manager then
		return
	end

	return ui_manager:play_2d_sound(event_name)
end

ExpeditionTimerHandler._max_time = function (self)
	local max_time = self._timer_settings.max_time

	if not max_time then
		return nil
	end

	return max_time + self._max_time_extension
end

return ExpeditionTimerHandler
