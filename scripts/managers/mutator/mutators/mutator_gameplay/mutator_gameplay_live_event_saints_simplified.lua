-- chunkname: @scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_saints_simplified.lua

require("scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_base")

local TerrorEventQueries = require("scripts/managers/terror_event/utilities/terror_event_queries")
local EnemyCompositions = require("scripts/settings/live_event/live_event_enemy_compositions/live_event_saints_enemy_compositions")
local MutatorGameplayLiveEventSaintsSimplified = class("MutatorGameplayLiveEventSaintsSimplified", "MutatorGameplayBase")

MutatorGameplayLiveEventSaintsSimplified.init = function (self, owner, settings, triggered_by_level)
	MutatorGameplayLiveEventSaintsSimplified.super.init(self, owner, settings, triggered_by_level)

	self._level_translation = Vector3Box(Matrix4x4.translation(Level.pose(self._level)))

	if not self._is_server then
		return
	end

	Managers.event:register(self, "saints_shrine_interact_success", "_shrine_interaction_success")
end

MutatorGameplayLiveEventSaintsSimplified.destroy = function (self)
	if not self._is_server then
		return
	end

	Managers.event:unregister(self, "saints_shrine_interact_success")
	MutatorGameplayLiveEventSaintsSimplified.super.destroy(self)
end

MutatorGameplayLiveEventSaintsSimplified._shrine_interaction_success = function (self)
	self:show_objective_popup_notification(self:_get_notification_key())
	self:_spawn_enemy_composition(self:_get_enemy_composition())

	self._owner.scratchpad.shrines_completed = (self._owner.scratchpad.shrines_completed or 0) + 1

	if not self._is_server then
		return
	end

	Managers.stats:record_team("hook_saint_points_acquired", self._settings.shrine_points)
end

MutatorGameplayLiveEventSaintsSimplified._get_enemy_composition = function (self)
	local keys = self:_get_composition_keys()
	local key, _, index = math.random_array_entry(keys)

	table.swap_delete(keys, index)

	return EnemyCompositions[key]
end

MutatorGameplayLiveEventSaintsSimplified._get_composition_keys = function (self)
	local keys = self._owner.scratchpad.enemy_composition_keys

	if keys and #keys > 0 then
		return keys
	end

	local enemy_composition_keys = {}

	for k, _ in pairs(EnemyCompositions) do
		table.insert(enemy_composition_keys, k)
	end

	self._owner.scratchpad.enemy_composition_keys = enemy_composition_keys

	return enemy_composition_keys
end

MutatorGameplayLiveEventSaintsSimplified._get_notification_key = function (self)
	local keys = self:_get_objective_notification_keys()
	local key, _, index = math.random_array_entry(keys)

	table.swap_delete(keys, index)

	return key
end

MutatorGameplayLiveEventSaintsSimplified._get_objective_notification_keys = function (self)
	local keys = self._owner.scratchpad.objective_notification_keys

	if keys and #keys > 0 then
		return keys
	end

	local objective_notification_keys = {}

	for k, _ in pairs(self._settings.notifications) do
		table.insert(objective_notification_keys, k)
	end

	self._owner.scratchpad.objective_notification_keys = objective_notification_keys

	return objective_notification_keys
end

MutatorGameplayLiveEventSaintsSimplified.update = function (self, dt, t)
	if self._did_trigger_ritualists then
		return
	end

	local ritualists = TerrorEventQueries.get_alive_entities_in_level("ritualist") or {}
	local unboxed_level_translation = self._level_translation:unbox()

	ritualists = table.filter_array(ritualists, function (unit)
		local pos = Unit.world_position(unit, 1)

		return Vector3.distance_squared(pos, unboxed_level_translation) <= 25
	end)

	if #ritualists == 0 then
		self._did_trigger_ritualists = true

		Level.trigger_event(self._level, "saints_ritualists_killed")
	end
end

local side_id, target_side_id = 2, 1
local horde_template_key = "flood_horde"

MutatorGameplayLiveEventSaintsSimplified._spawn_enemy_composition = function (self, composition_template)
	if not self._is_server then
		return
	end

	local current_faction = Managers.state.pacing:current_faction()
	local compositions = composition_template[current_faction]

	if not compositions or #compositions < 1 then
		return
	end

	local random_index = math.random(1, #compositions)
	local chosen_compositions = compositions[random_index]
	local chosen_compositions_by_resistance = Managers.state.difficulty:get_table_entry_by_resistance(chosen_compositions)

	Managers.state.horde:horde(horde_template_key, horde_template_key, side_id, target_side_id, chosen_compositions_by_resistance)
end

MutatorGameplayLiveEventSaintsSimplified.get_side_notification_data_formatter = function (notification_settings)
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
		local amount = string.format("{#color(%d,%d,%d)}%s{#reset()}", selected_color[2], selected_color[3], selected_color[4], amount_size)
		local for_amount = string.format("{#color(%d,%d,%d)}%s{#reset()}", selected_color[2], selected_color[3], selected_color[4], Localize("loc_player_saints_relic_pickup_amount", true, {
			points = amount_value,
		}))
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
			display_name = for_amount,
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

MutatorGameplayLiveEventSaintsSimplified.mutator_pickup_handler = function (caused_by_player, material_size_lookup, material_value)
	Managers.stats:record_team("hook_saint_points_acquired", material_value)
end

return MutatorGameplayLiveEventSaintsSimplified
