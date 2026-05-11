-- chunkname: @scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_skulls.lua

require("scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_base")

local MutatorGameplayLiveEventSkulls = class("MutatorGameplayLiveEventSkulls", "MutatorGameplayBase")
local EnemyCompositions = require("scripts/settings/live_event/live_event_enemy_compositions/live_event_skulls_enemy_compositions")

MutatorGameplayLiveEventSkulls.init = function (self, owner, settings, triggered_by_level)
	MutatorGameplayLiveEventSkulls.super.init(self, owner, settings, triggered_by_level)

	if not self._is_server then
		return
	end

	Managers.event:register(self, "event_skulls_totem_stage_01", "_on_event_skulls_totem_stage_01")
end

MutatorGameplayLiveEventSkulls.destroy = function (self)
	Managers.event:unregister(self, "event_skulls_totem_stage_01")
	MutatorGameplayLiveEventSkulls.super.destroy(self)
end

MutatorGameplayLiveEventSkulls._on_event_skulls_totem_stage_01 = function (self, unit)
	self:_spawn_enemy_composition(self:_get_enemy_composition(EnemyCompositions))
end

local side_id, target_side_id = 2, 1
local horde_template_key = "flood_horde"

MutatorGameplayLiveEventSkulls._spawn_enemy_composition = function (self, composition_template)
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

MutatorGameplayLiveEventSkulls._get_enemy_composition = function (self, enemy_compositions)
	local keys = self:_get_composition_keys(enemy_compositions)
	local key, _, index = math.random_array_entry(keys)

	table.swap_delete(keys, index)

	return enemy_compositions[key]
end

MutatorGameplayLiveEventSkulls._get_composition_keys = function (self, enemy_compositions)
	local keys = self._owner.scratchpad.enemy_composition_keys

	if keys and #keys > 0 then
		return keys
	end

	local enemy_composition_keys = {}

	for k, _ in pairs(enemy_compositions) do
		table.insert(enemy_composition_keys, k)
	end

	self._owner.scratchpad.enemy_composition_keys = enemy_composition_keys

	return enemy_composition_keys
end

MutatorGameplayLiveEventSkulls.get_side_notification_data_formatter = function (notification_settings)
	return function (data)
		local amount_size = data.amount_size
		local player_name = data.player_name
		local reason = data.reason
		local text_localization_key = data.localization_key
		local icon_texture_for_size, pickup_name

		if amount_size and type(amount_size) == "string" then
			local pickup_localization_by_size = notification_settings.pickup_localization_by_size
			local localization_key = pickup_localization_by_size[amount_size]

			if notification_settings.pickup_icon_by_size then
				icon_texture_for_size = notification_settings.pickup_icon_by_size[amount_size]
			end

			pickup_name = Localize(localization_key)
		end

		local icon_texture_large = notification_settings.icon_texture_big

		if icon_texture_for_size then
			icon_texture_large = icon_texture_for_size
		end

		local text = Localize(text_localization_key, true, {
			amount = pickup_name,
			player_name = player_name,
			amount_value = data.amount_value,
			pickup_name = pickup_name,
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

return MutatorGameplayLiveEventSkulls
