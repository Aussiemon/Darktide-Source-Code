-- chunkname: @scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_leftover.lua

require("scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_base")

local LiveEvents = require("scripts/settings/live_event/live_events")
local Promise = require("scripts/foundation/utilities/promise")
local FixedFrame = require("scripts/utilities/fixed_frame")
local MutatorGameplayLiveEventLeftover = class("MutatorGameplayLiveEventLeftover", "MutatorGameplayBase")
local RESOURCE_TYPE = "artifacts"
local EVENT_SETTINGS = LiveEvents.leftover and LiveEvents.leftover
local GLOBAL_STATS_SETTINGS = EVENT_SETTINGS and EVENT_SETTINGS.global_stats

MutatorGameplayLiveEventLeftover.init = function (self, owner, settings, triggered_by_level)
	MutatorGameplayLiveEventLeftover.super.init(self, owner, settings, triggered_by_level)

	if not self._is_server then
		return
	end

	self._collected_artefacts = 0
	self._player_faction_buffs = {}

	Managers.event:register(self, "on_pickup_collected", "_on_pickup_collected")
	Managers.event:register(self, "mission_buffs_event_player_spawned", "_on_event_mission_buffs_event_player_spawned")
	Managers.data_service.global_stats:subscribe(self, "_on_global_stat_change_callback", GLOBAL_STATS_SETTINGS.category, GLOBAL_STATS_SETTINGS.stats.pure, 0)
	Managers.data_service.global_stats:subscribe(self, "_on_global_stat_change_callback", GLOBAL_STATS_SETTINGS.category, GLOBAL_STATS_SETTINGS.stats.impure, 0)
	Managers.data_service.global_stats:get(GLOBAL_STATS_SETTINGS.category):next(function (stats)
		local current_pure = stats[GLOBAL_STATS_SETTINGS.stats.pure] or 0
		local current_impure = stats[GLOBAL_STATS_SETTINGS.stats.impure] or 0

		self._saved_global_stats = self._saved_global_stats or {}
		self._saved_global_stats[GLOBAL_STATS_SETTINGS.stats.pure] = current_pure
		self._saved_global_stats[GLOBAL_STATS_SETTINGS.stats.impure] = current_impure
	end)
end

MutatorGameplayLiveEventLeftover.destroy = function (self)
	MutatorGameplayLiveEventLeftover.super.destroy(self)

	if not self._is_server then
		return
	end

	local players = Managers.player:human_players()
	local data = {
		statistics = {
			collected = self._collected_artefacts,
		},
	}
	local event_data = Managers.live_event:get_event_data_by_name("leftover")
	local track_id = event_data and event_data.id

	for _, player in pairs(players) do
		Managers.backend.interfaces.tracks:set_track_statistics_by_type(player:account_id(), track_id, RESOURCE_TYPE, data):next(function (result)
			Log.info("MutatorGameplayLiveEventLeftover", "Successfully saved leftover track statistics for player %s", player:account_id())
		end):catch(function (error)
			Log.error("MutatorGameplayLiveEventLeftover", "Failed to save leftover track statistics for player %s, error: %s", player:account_id(), error)
		end)
	end

	if self._current_leading_faction then
		for _, player in pairs(players) do
			self:_remove_player_faction_buffs(player)
		end

		self._current_leading_faction = nil
	end

	self._player_faction_buffs = nil

	Managers.event:unregister(self, "on_pickup_collected")
	Managers.event:unregister(self, "mission_buffs_event_player_spawned")
	Managers.data_service.global_stats:unsubscribe(self, GLOBAL_STATS_SETTINGS.category, GLOBAL_STATS_SETTINGS.stats.pure)
	Managers.data_service.global_stats:unsubscribe(self, GLOBAL_STATS_SETTINGS.category, GLOBAL_STATS_SETTINGS.stats.impure)
end

MutatorGameplayLiveEventLeftover._on_global_stat_change_callback = function (self, stat_name, new_value)
	self._saved_global_stats = self._saved_global_stats or {}

	if self._saved_global_stats[stat_name] ~= new_value then
		self._saved_global_stats[stat_name] = new_value
		self._stats_changed = true
	end
end

MutatorGameplayLiveEventLeftover.update = function (self, dt, t)
	MutatorGameplayLiveEventLeftover.super.update(self, dt, t)

	if not self._stats_changed then
		return
	end

	self._stats_changed = nil

	local current_pure = self._saved_global_stats and self._saved_global_stats[GLOBAL_STATS_SETTINGS.stats.pure] or 0
	local current_impure = self._saved_global_stats and self._saved_global_stats[GLOBAL_STATS_SETTINGS.stats.impure] or 0
	local new_leading_faction

	if current_impure < current_pure then
		new_leading_faction = GLOBAL_STATS_SETTINGS.stats.pure
	elseif current_pure < current_impure then
		new_leading_faction = GLOBAL_STATS_SETTINGS.stats.impure
	else
		return
	end

	local old_leading_faction = self._current_leading_faction

	if old_leading_faction == new_leading_faction then
		return
	end

	self._current_leading_faction = new_leading_faction

	local players = Managers.player:human_players()

	for _, player in pairs(players) do
		self:_set_player_faction(player, new_leading_faction)
	end
end

MutatorGameplayLiveEventLeftover._set_player_faction = function (self, player, faction)
	local account_id = player:account_id()
	local entry = self._player_faction_buffs[account_id]

	if not entry then
		entry = {
			faction = nil,
			indexes = {},
		}
		self._player_faction_buffs[account_id] = entry
	end

	if entry.faction == faction and #entry.indexes > 0 then
		return
	end

	self:_remove_player_faction_buffs(player)

	entry.faction = faction

	self:_add_player_faction_buffs(player)
end

MutatorGameplayLiveEventLeftover._add_player_faction_buffs = function (self, player)
	local account_id = player:account_id()
	local entry = self._player_faction_buffs[account_id]
	local faction = entry and entry.faction

	if not faction then
		return
	end

	local player_unit = player.player_unit
	local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

	if not ALIVE[player_unit] or not buff_extension then
		return
	end

	local buffs = GLOBAL_STATS_SETTINGS.buffs[faction]
	local t = FixedFrame.get_latest_fixed_time()

	for _, buff_name in ipairs(buffs) do
		local _, buff_index = buff_extension:add_externally_controlled_buff(buff_name, t)

		if buff_index ~= nil then
			entry.indexes[#entry.indexes + 1] = buff_index
		else
			Log.warning("MutatorGameplayLiveEventLeftover", "Failed to add leftover buff %s to player %s", buff_name, account_id)
		end
	end
end

MutatorGameplayLiveEventLeftover._remove_player_faction_buffs = function (self, player)
	local account_id = player:account_id()
	local entry = self._player_faction_buffs[account_id]

	if not entry or #entry.indexes == 0 then
		return
	end

	local player_unit = player.player_unit
	local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

	if ALIVE[player_unit] and buff_extension then
		for _, buff_index in ipairs(entry.indexes) do
			buff_extension:remove_externally_controlled_buff(buff_index)
		end
	end

	table.clear_array(entry.indexes, #entry.indexes)
end

MutatorGameplayLiveEventLeftover.get_side_notification_data_formatter = function (notification_settings)
	return function (data)
		local amount_size = data.amount_size
		local amount_value = data.amount_value
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

		local selected_color = Color.terminal_corner_selected(255, true)
		local localized_amount = string.format("{#color(%d,%d,%d)}%s{#reset()}", selected_color[2], selected_color[3], selected_color[4], amount_size)
		local amount = string.format(" %s \n +%s", localized_amount, data.amount_value)
		local for_amount = string.format("{#color(%d,%d,%d)}%s{#reset()}", selected_color[2], selected_color[3], selected_color[4], Localize("loc_player_leftover_pickup_notification", true, {
			player_name = player_name,
			amount = amount_value,
		}))
		local text = Localize(text_localization_key, true, {
			amount = amount,
			player_name = player_name,
		})
		local enter_sound_event = notification_settings.notification_sound_event
		local texts = {}

		texts[#texts + 1] = reason and {
			display_name = reason,
		}
		texts[#texts + 1] = {
			display_name = text,
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

MutatorGameplayLiveEventLeftover._on_pickup_collected = function (self, amount)
	self._collected_artefacts = self._collected_artefacts + amount
end

MutatorGameplayLiveEventLeftover._on_event_mission_buffs_event_player_spawned = function (self, player, is_respawn, unit)
	local account_id = player:account_id()

	if not account_id then
		Log.warning("MutatorGameplayLiveEventLeftover", "Player unit spawned without account_id; cannot apply leftover faction buffs.")

		return
	end

	local entry = self._player_faction_buffs[account_id]

	if entry then
		table.clear_array(entry.indexes, #entry.indexes)
	end

	self:_set_player_faction(player, self._current_leading_faction)
end

MutatorGameplayLiveEventLeftover.mutator_pickup_handler = function (caused_by_player, material_size_lookup, material_value)
	if not caused_by_player then
		return
	end

	Managers.event:trigger("on_pickup_collected", material_value)
end

return MutatorGameplayLiveEventLeftover
