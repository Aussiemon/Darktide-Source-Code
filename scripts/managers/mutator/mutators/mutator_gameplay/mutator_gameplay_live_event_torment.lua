-- chunkname: @scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_torment.lua

require("scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_base")

local FixedFrame = require("scripts/utilities/fixed_frame")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local NavQueries = require("scripts/utilities/nav_queries")
local MutatorSpawnerLocationSources = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_location_sources")
local TormentLightFlicker = require("scripts/managers/mutator/mutators/mutator_gameplay/torment_light_flicker")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local MutatorGameplayLiveEventTorment = class("MutatorGameplayLiveEventTorment", "MutatorGameplayBase")
local TARGET_SIDE_ID = 1
local ENEMY_SIDE_ID = 2
local TORMENT_SPAWN_DELAY = 5
local SPAWN_AHEAD_DISTANCE = {
	20,
	30,
}
local NAV_MESH_ABOVE, NAV_MESH_BELOW = 5, 5
local PROBABILITY_ARRAY = {
	0.15,
	0.35,
	1,
}
local ELITE_DAEMONHOST_SPAWN_STINGER_SFX = "wwise/events/world/play_event_daemonhost_spawn_stinger"
local TORMENT_TRACK_NAME = "torment_global-2026"
local TORMENT_STAT_CATEGORY = "lw-mb"
local TORMENT_STAT_NAME = "live_event_torment_witch_damage_dealt"

MutatorGameplayLiveEventTorment.init = function (self, owner, settings, triggered_by_level)
	MutatorGameplayLiveEventTorment.super.init(self, owner, settings, triggered_by_level)

	if not self._is_server then
		return
	end

	self._daemonhost_kills = 0
	self._torment_spawned = false
	self._torment_stat_value = Managers.data_service.global_stats:subscribe(self, "_on_global_stat_changed", TORMENT_STAT_CATEGORY, TORMENT_STAT_NAME, 0)
	self._light_flicker = TormentLightFlicker:new(self._settings.light_flicker)

	Managers.event:register(self, "on_minion_death_event", "_on_minion_death_event")
	Managers.event:register(self, "on_deamonhost_runs_event", "_on_daemonhost_boss_dies_event")
	Managers.event:register(self, "on_torment_daemonhost_should_spawn_event", "_on_torment_daemonhost_should_spawn")
end

MutatorGameplayLiveEventTorment.destroy = function (self)
	if self._is_server then
		Managers.event:unregister(self, "on_minion_death_event")
		Managers.event:unregister(self, "on_torment_daemonhost_should_spawn_event")
		Managers.event:unregister(self, "on_deamonhost_runs_event")
		self:_stop_spawn_indicator()
		Managers.data_service.global_stats:unsubscribe(self, TORMENT_STAT_CATEGORY, TORMENT_STAT_NAME)
		self._light_flicker:delete()

		self._light_flicker = nil
	end

	MutatorGameplayLiveEventTorment.super.destroy(self)
end

MutatorGameplayLiveEventTorment._client_setup = function (self)
	self._light_flicker = TormentLightFlicker:new(self._settings.light_flicker)
	self._client_flicker_triggered = false

	Managers.event:register(self, "mutator_objective_popup_shown", "_on_objective_popup_shown")
end

MutatorGameplayLiveEventTorment._client_update = function (self, dt, t)
	self._light_flicker:update(dt, t)
end

MutatorGameplayLiveEventTorment._client_destroy = function (self)
	Managers.event:unregister(self, "mutator_objective_popup_shown")
	self._light_flicker:delete()

	self._light_flicker = nil
end

MutatorGameplayLiveEventTorment._on_objective_popup_shown = function (self, key)
	if key ~= "torment_daemonhost_alert" then
		return
	end

	if self._client_flicker_triggered then
		return
	end

	self._client_flicker_triggered = true

	self._light_flicker:start(TORMENT_SPAWN_DELAY)
end

MutatorGameplayLiveEventTorment._on_minion_death_event = function (self, unit, breed)
	if not breed then
		return
	end

	if breed.name == "chaos_daemonhost" then
		self:_on_daemonhost_killed_event(unit, breed)

		return
	end

	if breed.name == "chaos_daemonhost_torment" then
		self:_on_daemonhost_boss_dies_event(unit, breed)

		return
	end
end

MutatorGameplayLiveEventTorment._on_daemonhost_killed_event = function (self, unit, breed)
	if self._torment_spawned then
		return
	end

	if not breed or breed.name ~= "chaos_daemonhost" then
		return
	end

	if self:_event_reached_max_tier() then
		return
	end

	local chance = table.remove(PROBABILITY_ARRAY, 1)
	local rng = math.random()

	if chance <= rng then
		return
	end

	Managers.event:trigger("on_torment_daemonhost_should_spawn_event")
end

MutatorGameplayLiveEventTorment._on_global_stat_changed = function (self, stat_name, new_value)
	self._torment_stat_value = new_value
end

MutatorGameplayLiveEventTorment._event_reached_max_tier = function (self)
	local max_tier_guard_value = self:_max_tier_guard_value()

	if not max_tier_guard_value or max_tier_guard_value <= 0 then
		return false
	end

	return max_tier_guard_value <= (self._torment_stat_value or 0)
end

MutatorGameplayLiveEventTorment._max_tier_guard_value = function (self)
	local guards = Managers.live_event and Managers.live_event:get_tier_guards(TORMENT_TRACK_NAME, TORMENT_STAT_CATEGORY, TORMENT_STAT_NAME)
	local max_value

	if guards then
		for i = 1, #guards do
			if not max_value or max_value < guards[i].limit then
				max_value = guards[i].limit
			end
		end
	end

	return max_value
end

MutatorGameplayLiveEventTorment._on_daemonhost_boss_dies_event = function (self, unit, breed)
	if breed.name ~= "chaos_daemonhost_torment" then
		return
	end

	local max_health = Managers.state.difficulty:get_minion_max_health(breed.name)
	local health_extension = ScriptUnit.extension(unit, "health_system")
	local damage_dealt = math.clamp(max_health - health_extension:current_health(), 0, max_health)

	Managers.stats:record_team("hook_live_event_torment_daemonhost_damage_dealt", damage_dealt)
end

MutatorGameplayLiveEventTorment._on_torment_daemonhost_should_spawn = function (self)
	if self._torment_spawned then
		return
	end

	self._torment_spawn_timer = FixedFrame.get_latest_fixed_time() + TORMENT_SPAWN_DELAY

	self:show_objective_popup_notification("torment_daemonhost_alert")
	Managers.state.extension:system("fx_system"):trigger_wwise_event(ELITE_DAEMONHOST_SPAWN_STINGER_SFX)
	self._light_flicker:start(TORMENT_SPAWN_DELAY)

	local spawn_position = self:_find_spawn_position()

	if spawn_position then
		self._torment_spawn_position = Vector3Box(spawn_position)

		local fx_system = Managers.state.extension:system("fx_system")

		self._spawn_indicator_effect_id = fx_system:start_template_effect(EffectTemplates.chaos_daemonhost_torment_spawn_indicator, nil, nil, spawn_position)
	end
end

MutatorGameplayLiveEventTorment._stop_spawn_indicator = function (self)
	if not self._spawn_indicator_effect_id then
		return
	end

	Managers.state.extension:system("fx_system"):stop_template_effect(self._spawn_indicator_effect_id)

	self._spawn_indicator_effect_id = nil
end

MutatorGameplayLiveEventTorment._spawn_torment_daemonhost = function (self)
	self:_stop_spawn_indicator()

	local ahead_target_unit = Managers.state.main_path:ahead_unit(TARGET_SIDE_ID)
	local spawn_position = self._torment_spawn_position and self._torment_spawn_position:unbox() or self:_find_spawn_position()

	self._torment_spawn_position = nil

	if not spawn_position then
		Log.warning("MutatorGameplayLiveEventTorment", "No valid spawn position for chaos_daemonhost_torment; skipping spawn.")

		return
	end

	local minion_spawn_manager = Managers.state.minion_spawn
	local param_table = minion_spawn_manager:request_param_table()

	param_table.optional_aggro_state = "aggroed"
	param_table.optional_target_unit = ahead_target_unit

	minion_spawn_manager:spawn_minion("chaos_daemonhost_torment", spawn_position, Quaternion.identity(), ENEMY_SIDE_ID, param_table)

	self._torment_spawned = true
end

MutatorGameplayLiveEventTorment._find_spawn_position = function (self)
	local main_path = Managers.state.main_path
	local ahead_unit, ahead_travel_distance = main_path:ahead_unit(TARGET_SIDE_ID)

	if not ahead_unit then
		return
	end

	local nav_world = Managers.state.nav_mesh:nav_world()
	local offset = math.random(SPAWN_AHEAD_DISTANCE[1], SPAWN_AHEAD_DISTANCE[2])
	local ahead_position = MainPathQueries.position_from_distance(ahead_travel_distance + offset)

	if ahead_position then
		local on_mesh = NavQueries.position_on_mesh(nav_world, ahead_position, NAV_MESH_ABOVE, NAV_MESH_BELOW)

		if on_mesh then
			return on_mesh
		end
	end

	return self:_next_gizmo_position_ahead(main_path, ahead_travel_distance, nav_world)
end

MutatorGameplayLiveEventTorment._next_gizmo_position_ahead = function (self, main_path, ahead_travel_distance, nav_world)
	local locations = MutatorSpawnerLocationSources.mission_provided_gizmo()()

	if not locations or #locations == 0 then
		return
	end

	local best_position, best_travel_distance

	for i = 1, #locations do
		local position = locations[i].position:unbox()
		local travel_distance = main_path:travel_distance_from_position(position)

		if travel_distance and ahead_travel_distance < travel_distance and (not best_travel_distance or travel_distance < best_travel_distance) then
			best_travel_distance = travel_distance
			best_position = position
		end
	end

	if not best_position then
		return
	end

	return NavQueries.position_on_mesh(nav_world, best_position, NAV_MESH_ABOVE, NAV_MESH_BELOW) or best_position
end

MutatorGameplayLiveEventTorment.update = function (self, dt, t)
	MutatorGameplayLiveEventTorment.super.update(self, dt, t)

	if not self._is_server then
		return
	end

	self._light_flicker:update(dt, t)

	if self._torment_spawn_timer and FixedFrame.get_latest_fixed_time() >= self._torment_spawn_timer then
		self._torment_spawn_timer = nil

		self:_spawn_torment_daemonhost()
	end
end

return MutatorGameplayLiveEventTorment
