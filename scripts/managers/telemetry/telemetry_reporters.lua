-- chunkname: @scripts/managers/telemetry/telemetry_reporters.lua

local ComWheelReporter = require("scripts/managers/telemetry/reporters/com_wheel_reporter")
local EnemySpawnedReporter = require("scripts/managers/telemetry/reporters/enemy_spawned_reporter")
local FixedUpdateMissedInputsReporter = require("scripts/managers/telemetry/reporters/fixed_update_missed_inputs_reporter")
local FrameTimeReporter = require("scripts/managers/telemetry/reporters/frame_time_reporter")
local HeartbeatReporter = require("scripts/managers/telemetry/reporters/heartbeat_reporter")
local LoadTimesReporter = require("scripts/managers/telemetry/reporters/load_times_reporter")
local MispredictReporter = require("scripts/managers/telemetry/reporters/mispredict_reporter")
local PacingReporter = require("scripts/managers/telemetry/reporters/pacing_reporter")
local PenanceViewReporter = require("scripts/managers/telemetry/reporters/penance_view_reporter")
local PickedItemsReporter = require("scripts/managers/telemetry/reporters/picked_items_reporter")
local PingReporter = require("scripts/managers/telemetry/reporters/ping_reporter")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlacedItemsReporter = require("scripts/managers/telemetry/reporters/placed_items_reporter")
local PlayerDealtDamageReporter = require("scripts/managers/telemetry/reporters/player_dealt_damage_reporter")
local PlayerTakenDamageReporter = require("scripts/managers/telemetry/reporters/player_taken_damage_reporter")
local PlayerTerminateEnemyReporter = require("scripts/managers/telemetry/reporters/player_terminate_enemy_reporter")
local AbilityReporter = require("scripts/managers/telemetry/reporters/ability_reporter")
local SharedItemsReporter = require("scripts/managers/telemetry/reporters/shared_items_reporter")
local SmartTagReporter = require("scripts/managers/telemetry/reporters/smart_tag_reporter")
local TacticalOverlayReporter = require("scripts/managers/telemetry/reporters/tactical_overlay_reporter")
local TrainingGroundsReporter = require("scripts/managers/telemetry/reporters/training_grounds_reporter")
local UsedItemsReporter = require("scripts/managers/telemetry/reporters/used_items_reporter")
local VoiceOverBankReshuffledReporter = require("scripts/managers/telemetry/reporters/voice_over_bank_reshuffled_reporter")
local VoiceOverEventTriggeredReporter = require("scripts/managers/telemetry/reporters/voice_over_event_triggered_reporter")
local ability_types = table.keys(PlayerCharacterConstants.ability_configuration)
local TelemetryReporters = class("TelemetryReporters")
local REPORTER_CLASS_MAP = {
	com_wheel = ComWheelReporter,
	enemy_spawns = EnemySpawnedReporter,
	fixed_update_missed_inputs = FixedUpdateMissedInputsReporter,
	frame_time = FrameTimeReporter,
	heartbeat = HeartbeatReporter,
	load_times = LoadTimesReporter,
	pacing = PacingReporter,
	penance_view = PenanceViewReporter,
	picked_items = PickedItemsReporter,
	used_items = UsedItemsReporter,
	ping = PingReporter,
	placed_items = PlacedItemsReporter,
	player_dealt_damage = PlayerDealtDamageReporter,
	player_taken_damage = PlayerTakenDamageReporter,
	mispredict = MispredictReporter,
	player_terminate_enemy = PlayerTerminateEnemyReporter,
	shared_items = SharedItemsReporter,
	smart_tag = SmartTagReporter,
	tactical_overlay = TacticalOverlayReporter,
	training_grounds = TrainingGroundsReporter,
	voice_over_bank_reshuffled = VoiceOverBankReshuffledReporter,
	voice_over_event_triggered = VoiceOverEventTriggeredReporter,
}

for i = 1, #ability_types do
	REPORTER_CLASS_MAP[ability_types[i]] = AbilityReporter
end

TelemetryReporters.init = function (self)
	self._reporters = {}

	self:start_reporter("heartbeat")
	self:start_reporter("load_times")
end

TelemetryReporters.start_reporter = function (self, name, params)
	Log.debug("TelemetryReporters", "Starting reporter '%s'", name)

	local reporter_class = REPORTER_CLASS_MAP[name]

	self._reporters[name] = reporter_class:new(params, name)
end

TelemetryReporters.stop_reporter = function (self, name)
	Log.debug("TelemetryReporters", "Stopping reporter '%s'", name)
	self._reporters[name]:report()
	self._reporters[name]:destroy()

	self._reporters[name] = nil
end

TelemetryReporters.reporter = function (self, name)
	return self._reporters[name]
end

TelemetryReporters.update = function (self, dt, t)
	for _, reporter in pairs(self._reporters) do
		reporter:update(dt, t)
	end
end

TelemetryReporters.destroy = function (self)
	for _, reporter in pairs(self._reporters) do
		reporter:destroy()
	end
end

return TelemetryReporters
