require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_base")

local MissionSoundEvents = require("scripts/settings/sound/mission_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local WwiseStateGroupEventIntensity = class("WwiseStateGroupEventIntensity", "WwiseStateGroupBase")
local STATES = WwiseGameSyncSettings.state_groups.event_intensity
local TRIGGER_THRESHOLD = 10
local MAX_INTENSITY = 120
local DEFAULT_PROGRESS_VALUE = 80
local EVENT_INTENSITY = {
	[MissionSoundEvents.objective_start_collect] = -80,
	[MissionSoundEvents.objective_start_destination] = 80,
	[MissionSoundEvents.objective_start_goal] = 80,
	[MissionSoundEvents.objective_start_decode] = 0,
	[MissionSoundEvents.decode_moving] = 80,
	[MissionSoundEvents.decode_blocked] = -30,
	[MissionSoundEvents.objective_start_kill] = 80,
	[MissionSoundEvents.objective_start_timed] = 80,
	[MissionSoundEvents.objective_start_demolition] = 80,
	[MissionSoundEvents.objective_start_luggable] = 80,
	[MissionSoundEvents.objective_start_scanning] = 0,
	[MissionSoundEvents.scanning_travel_start] = 80,
	[MissionSoundEvents.scanning_scan_start] = 80,
	[MissionSoundEvents.objective_finished] = 0
}
local INTENSITY_PROGRESS_RATE = {
	[MissionSoundEvents.objective_start_collect] = DEFAULT_PROGRESS_VALUE,
	[MissionSoundEvents.objective_start_destination] = DEFAULT_PROGRESS_VALUE,
	[MissionSoundEvents.objective_start_goal] = 0,
	[MissionSoundEvents.objective_start_decode] = 0,
	[MissionSoundEvents.objective_start_kill] = 0,
	[MissionSoundEvents.objective_start_timed] = DEFAULT_PROGRESS_VALUE * 2,
	[MissionSoundEvents.objective_start_demolition] = DEFAULT_PROGRESS_VALUE,
	[MissionSoundEvents.objective_start_luggable] = DEFAULT_PROGRESS_VALUE * 2
}

WwiseStateGroupEventIntensity.init = function (self, wwise_world, wwise_state_group_name)
	WwiseStateGroupEventIntensity.super.init(self, wwise_world, wwise_state_group_name)

	self._mission_objective_system = nil
	self._intensity = 0
	self._progression_rate = DEFAULT_PROGRESS_VALUE
	self._previous_event_progress = 0
end

WwiseStateGroupEventIntensity.on_gameplay_post_init = function (self, level)
	WwiseStateGroupEventIntensity.super.on_gameplay_post_init(self, level)

	local mission_objective_system = Managers.state.extension:system("mission_objective_system")
	self._mission_objective_system = mission_objective_system

	mission_objective_system:register_music_event_listener(self)
end

WwiseStateGroupEventIntensity.sound_event_triggered = function (self, event)
	if EVENT_INTENSITY[event] then
		self._intensity = math.clamp(self._intensity + EVENT_INTENSITY[event], -TRIGGER_THRESHOLD, MAX_INTENSITY)
	end

	if INTENSITY_PROGRESS_RATE[event] then
		self._progression_rate = INTENSITY_PROGRESS_RATE[event]
	end
end

WwiseStateGroupEventIntensity.update = function (self, dt, t)
	WwiseStateGroupEventIntensity.super.update(self, dt, t)

	local wwise_state = STATES.none

	if self._mission_objective_system then
		local event_progress = self._mission_objective_system:get_objective_event_music_progress()
		local progression_intensity = math.max(event_progress - self._previous_event_progress, 0) * self._progression_rate
		self._previous_event_progress = event_progress
		local previous_intensity = self._intensity
		local new_intensity = (self._intensity + progression_intensity) - dt

		if previous_intensity <= 0 and new_intensity > 0 then
			new_intensity = new_intensity + TRIGGER_THRESHOLD
		end

		local intensity = math.clamp(new_intensity, -TRIGGER_THRESHOLD, MAX_INTENSITY)
		self._intensity = intensity

		if intensity > 0 then
			wwise_state = STATES.high
		else
			wwise_state = STATES.low
		end
	end

	self:_set_wwise_state(wwise_state)
end

WwiseStateGroupEventIntensity.on_gameplay_shutdown = function (self)
	WwiseStateGroupEventIntensity.super.on_gameplay_shutdown(self)

	self._mission_objective_system = nil
end

return WwiseStateGroupEventIntensity
