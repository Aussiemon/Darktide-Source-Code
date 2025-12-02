-- chunkname: @scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_saints.lua

require("scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_base")

local CrimesCompabilityMap = require("scripts/settings/character/crimes_compability_mapping")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Promise = require("scripts/foundation/utilities/promise")
local MutatorGameplayLiveEventSaints = class("MutatorGameplayLiveEventSaints", "MutatorGameplayBase")
local saint_red_data = {
	buff = "live_event_saints_buff_saint_red",
	name = "loc_saints_saint_name_red",
	color = Color.citadel_jokaero_orange(255, true),
}
local saint_blue_data = {
	buff = "live_event_saints_buff_saint_blue",
	name = "loc_saints_saint_name_blue",
	color = Color.citadel_guilliman_blue(255, true),
}
local particles = {
	player_screen_saints_revive = "content/fx/particles/player_buffs/player_screen_saints_revive",
	saints_relice_01 = "content/fx/particles/player_buffs/saints_relic_01",
	saints_revive_01 = "content/fx/particles/player_buffs/saints_revive_01",
}
local backstory_to_saint_mapping = {
	option_1 = saint_red_data,
	option_2 = saint_blue_data,
	option_3 = saint_red_data,
	option_4 = saint_blue_data,
	option_5 = saint_red_data,
	option_6 = saint_blue_data,
	option_7 = saint_red_data,
	option_8 = saint_blue_data,
	option_9 = saint_red_data,
	option_10 = saint_blue_data,
	option_11 = saint_red_data,
	option_12 = saint_blue_data,
	option_13 = saint_red_data,
	option_14 = saint_blue_data,
	option_15 = saint_red_data,
	option_16 = saint_blue_data,
}

local function _saint_for_crime(player)
	local player_profile = player:profile()
	local lore = player_profile.lore

	if not lore then
		return saint_red_data
	end

	local crime = CrimesCompabilityMap[lore.backstory.crime] or lore.backstory.crime
	local saint = backstory_to_saint_mapping[crime]

	if saint then
		return saint
	end

	return saint_red_data
end

local function _apply_buff_stacks_for_player(player, buff_key, stacks)
	if stacks <= 0 then
		return
	end

	for i = 1, stacks do
		Managers.event:trigger("mission_buffs_event_add_externally_controlled_to_player", player, buff_key)
	end
end

MutatorGameplayLiveEventSaints.on_global_stat_trigger_apply_player_buff_stacks = function (buff_key)
	return function (mutator, for_value, delta, caused_by_player)
		if not mutator._is_server then
			return
		end

		local players = Managers.player:players()

		if not players then
			return
		end

		for _, player in pairs(players) do
			_apply_buff_stacks_for_player(player, buff_key, delta)
		end
	end
end

MutatorGameplayLiveEventSaints.module_hot_join_sync = function (owner, sender, channel)
	Managers.data_service.global_stats:get("lw-mb"):next(function (stats)
		local player = Managers.player:player(sender, 1)

		if not player then
			return nil
		end

		local settings = owner:get_gameplay_settings()

		_apply_buff_stacks_for_player(player, saint_red_data.buff, stats[settings.saint_red_buff_stat] or 0)
		_apply_buff_stacks_for_player(player, saint_blue_data.buff, stats[settings.saint_blue_buff_stat] or 0)
	end, function (error)
		return Promise.resolved()
	end)
end

MutatorGameplayLiveEventSaints.init = function (self, owner, settings, triggered_by_level)
	MutatorGameplayLiveEventSaints.super.init(self, owner, settings, triggered_by_level)

	if not self._is_server then
		return
	end

	Managers.state.mutator:activate_mutator("mutator_respawn_modifier")

	self._current_wave_count = 0
	self._respawn_count = self._settings.respawns
	self._auto_event_component = nil

	Managers.event:register(self, "saints_auto_event_unit_set", "_on_event_saints_auto_event_unit_set")
	Managers.event:register(self, "auto_event_primary_wave_triggered", "_on_event_auto_event_primary_wave_triggered")
	Managers.event:register(self, "mission_buffs_event_player_spawned", "_on_event_mission_buffs_event_player_spawned")
end

MutatorGameplayLiveEventSaints.destroy = function (self)
	Managers.event:unregister(self, "saints_auto_event_unit_set")
	Managers.event:unregister(self, "auto_event_primary_wave_triggered")
	Managers.event:unregister(self, "mission_buffs_event_player_spawned")
	Managers.state.mutator:deactivate_mutator("mutator_respawn_modifier")
	MutatorGameplayLiveEventSaints.super.destroy(self)
end

MutatorGameplayLiveEventSaints.update = function (self, dt, t)
	if not self._is_server then
		return
	end

	if not self._auto_event_component then
		return
	end

	local event_data = self._auto_event_component:get_auto_event_data()

	if event_data then
		local total_alive = event_data.total_alive or math.huge

		if total_alive and total_alive < 10 then
			self:_tag_remaining_enemies()

			return
		end

		if total_alive > 0 then
			return
		end
	end

	if self._current_wave_count < self._settings.max_waves then
		return
	end

	if not event_data then
		self:_trigger_ending()
	end
end

MutatorGameplayLiveEventSaints._on_event_saints_auto_event_unit_set = function (self, auto_event_unit)
	self._auto_event_unit = auto_event_unit

	local component_system = Managers.state.extension:system("component_system")
	local components = component_system:get_components(self._auto_event_unit, "AutoEvent")

	self._auto_event_component = components[1]
end

MutatorGameplayLiveEventSaints._on_event_auto_event_primary_wave_triggered = function (self)
	self._current_wave_count = self._current_wave_count + 1
	self._tag_enemies_sent = false

	self:show_objective_popup_notification(string.format("wave_progress_notification_%02d", self._current_wave_count))

	if self._current_wave_count >= self._settings.max_waves then
		Level.trigger_event(self._level, "saints_shrine_auto_event_stop")

		return
	end
end

MutatorGameplayLiveEventSaints._on_event_mission_buffs_event_player_spawned = function (self, player, is_respawn, player_unit)
	if not is_respawn then
		return
	end

	self._respawn_count = self._respawn_count - 1

	if self._respawn_count > 0 then
		local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

		if ALIVE[player_unit] and buff_extension then
			local current_time = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff("live_event_saints_buff_revive", current_time)
		end

		Level.trigger_event(self._level, "saints_player_revived")

		return
	end

	self:_trigger_ending()
end

MutatorGameplayLiveEventSaints._trigger_ending = function (self)
	if self._end_triggered then
		return
	end

	self._end_triggered = true

	if self._current_wave_count > self._settings.waves_for_success then
		self:_trigger_victory(self._current_wave_count >= self._settings.waves_for_success)

		return
	end

	self:_trigger_failure()
end

MutatorGameplayLiveEventSaints._trigger_failure = function (self)
	Level.trigger_event(self._level, "saints_shrine_auto_event_stop")
	self:show_objective_popup_notification("event_failed_notification")

	if self._auto_event_component then
		self._auto_event_component:kill_remaining_enemies()
		Level.trigger_event(self._level, "saints_shrine_lose")
	end
end

MutatorGameplayLiveEventSaints._trigger_victory = function (self, is_perfect)
	if is_perfect then
		self:show_objective_popup_notification("event_complete_success_notification")
	else
		self:show_objective_popup_notification("event_success_notification")
	end

	if self._auto_event_component then
		Level.trigger_event(self._level, "saints_shrine_win")
	end
end

MutatorGameplayLiveEventSaints.current_auto_event_wave = function (self)
	return self._current_wave_count
end

MutatorGameplayLiveEventSaints._tag_remaining_enemies = function (self)
	if self._is_server then
		if self._tag_enemies_sent then
			return
		end

		self._tag_enemies_sent = true

		Managers.state.game_session:send_rpc_clients("rpc_client_hordes_tag_remaining_enemies")

		return
	end

	if DEDICATED_SERVER then
		return
	end

	local outline_system = Managers.state.extension:system("outline_system")

	if not outline_system then
		return
	end

	local side = Managers.state.extension:system("side_system"):get_side_from_name("villains")
	local _, target_units = side:relation_sides("allied"), side:alive_units_by_tag("allied", "minion")

	for _, unit in pairs(target_units) do
		if HEALTH_ALIVE[unit] then
			outline_system:add_outline(unit, "hordes_tagged_remaining_target")
		end
	end
end

MutatorGameplayLiveEventSaints.rpc_client_hordes_tag_remaining_enemies = function (self, channel_id)
	self:_tag_remaining_enemies()
end

MutatorGameplayLiveEventSaints.get_side_notification_data_formatter = function (notification_settings)
	return function (data)
		local amount_size = data.amount_size
		local player_name = data.player_name
		local reason = data.reason
		local text_localization_key = data.localization_key
		local icon_texture_for_size

		if amount_size and type(amount_size) == "string" then
			local pickup_localization_by_size = notification_settings.pickup_localization_by_size
			local localization_key = pickup_localization_by_size[amount_size]

			if notification_settings.pickup_icon_by_size then
				icon_texture_for_size = notification_settings.pickup_icon_by_size[amount_size]
			end

			amount_size = Localize(localization_key)
		end

		local icon_texture_large = notification_settings.icon_texture_big

		if icon_texture_for_size then
			icon_texture_large = icon_texture_for_size
		end

		local for_saint = _saint_for_crime(data.player)
		local selected_color = Color.terminal_corner_selected(255, true)
		local amount = string.format("{#color(%d,%d,%d)}%s{#reset()}", selected_color[2], selected_color[3], selected_color[4], amount_size)

		selected_color = for_saint.color
		for_saint = string.format("{#color(%d,%d,%d)}%s{#reset()}", selected_color[2], selected_color[3], selected_color[4], Localize(for_saint.name))

		local text = Localize(text_localization_key, true, {
			amount = amount,
			player_name = player_name,
			amount_value = data.amount_value,
		})
		local enter_sound_event = notification_settings.notification_sound_event
		local texts = {}

		texts[#texts + 1] = reason and {
			display_name = reason,
		}
		texts[#texts + 1] = {
			display_name = text,
		}
		texts[#texts + 1] = {
			display_name = for_saint,
		}

		return {
			icon_size = "currency",
			texts = texts,
			icon = icon_texture_large,
			color = Color.terminal_grid_background(100, true),
			enter_sound_event = enter_sound_event,
		}
	end
end

return MutatorGameplayLiveEventSaints
