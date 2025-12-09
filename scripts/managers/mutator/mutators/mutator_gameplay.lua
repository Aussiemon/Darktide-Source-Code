-- chunkname: @scripts/managers/mutator/mutators/mutator_gameplay.lua

require("scripts/managers/mutator/mutators/mutator_base")

local UISettings = require("scripts/settings/ui/ui_settings")
local Text = require("scripts/utilities/ui/text")
local MutatorGameplay = class("MutatorGameplay", "MutatorBase")
local CLIENT_RPCS = {
	"rpc_player_interacted_mutator_materials",
	"rpc_show_objective_popup_notification",
	"rpc_client_hordes_tag_remaining_enemies",
}

MutatorGameplay.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
	MutatorGameplay.super.init(self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)

	self._gameplay_levels = {}
	self._gameplay_instances = {}
	self._gameplay_module = require(self._template.gameplay_template.path)
	self._notifications = self._template.gameplay_template.settings.notifications
	self._side_notification_settings = self._template.side_notification

	if self._gameplay_module.get_side_notification_data_formatter then
		self._side_notification_data_formatter = self._gameplay_module.get_side_notification_data_formatter(self._side_notification_settings)
	end

	self.scratchpad = {}
end

MutatorGameplay.activate = function (self)
	MutatorGameplay.super.activate(self)
	self._network_event_delegate:register_connection_events(self, unpack(CLIENT_RPCS))

	if not self._is_server then
		return
	end

	Managers.event:register(self, "mutator_gameplay_start_module", "_on_event_mutator_gameplay_start_module")
	Managers.event:register(self, "mutator_gameplay_stop_module", "_on_event_mutator_gameplay_stop_module")
	Managers.event:register(self, "mutator_pickup_collected", "_on_event_mutator_pickup_collected")
end

MutatorGameplay.deactivate = function (self)
	if not self._is_active then
		return
	end

	MutatorGameplay.super.deactivate(self)
	self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))

	if not self._is_server then
		return
	end

	Managers.event:unregister(self, "mutator_gameplay_start_module")
	Managers.event:unregister(self, "mutator_gameplay_stop_module")
	Managers.event:unregister(self, "mutator_pickup_collected")

	for i = 1, #self._gameplay_levels do
		local instance, is_valid = self:gameplay_instance(self._gameplay_levels[i])

		if is_valid then
			instance:delete()
		end
	end

	table.clear(self._gameplay_instances)
	table.clear(self._gameplay_levels)
end

MutatorGameplay.update = function (self, dt, t)
	for i = 1, #self._gameplay_levels do
		local gameplay_instance, is_valid = self:gameplay_instance(self._gameplay_levels[i])

		if is_valid then
			gameplay_instance:update(dt, t)
		end
	end
end

MutatorGameplay._on_event_mutator_gameplay_start_module = function (self, triggered_on_level)
	if self._gameplay_instances[triggered_on_level] then
		Log.warning("MutatorGameplay", "instance of '%s' already created for level '%s'", self._template.gameplay_template.path, Level.name(triggered_on_level))

		return
	end

	table.insert(self._gameplay_levels, triggered_on_level)

	self._gameplay_instances[triggered_on_level] = self._gameplay_module:new(self, self._template.gameplay_template.settings, triggered_on_level)
end

MutatorGameplay._on_event_mutator_gameplay_stop_module = function (self, triggered_on_level)
	local gameplay_instance, is_valid = self:gameplay_instance(triggered_on_level)

	if not is_valid then
		Log.warning("MutatorGameplay", "instance of '%s' not valid on destroy attempt", self._template.gameplay_template.path)

		return
	end

	gameplay_instance:delete()
	table.swap_delete(self._gameplay_levels, table.index_of(self._gameplay_levels, triggered_on_level))

	self._gameplay_instances[triggered_on_level] = nil
end

MutatorGameplay.gameplay_instance = function (self, level)
	local gameplay_instance = self._gameplay_instances[level]

	return gameplay_instance, gameplay_instance and not gameplay_instance.__destroyed
end

MutatorGameplay.get_gameplay_settings = function (self)
	return self._template.gameplay_template.settings
end

MutatorGameplay._on_event_mutator_pickup_collected = function (self, caused_by_player, material_size_lookup, material_value)
	if self._gameplay_module.mutator_pickup_handler then
		self._gameplay_module.mutator_pickup_handler(caused_by_player, material_size_lookup, material_value)
	end

	local interaction_type = 1

	Managers.state.game_session:send_rpc_clients("rpc_player_interacted_mutator_materials", caused_by_player:peer_id(), NetworkLookup.material_type_lookup.event_material, material_size_lookup, interaction_type, material_value)
end

MutatorGameplay.rpc_player_interacted_mutator_materials = function (self, channel_id, peer_id, material_type_lookup, material_size_lookup, interaction_type_lookup, material_value)
	if not self._side_notification_data_formatter then
		return
	end

	local material_type = NetworkLookup.material_type_lookup[material_type_lookup]
	local material_size = NetworkLookup.material_size_lookup[material_size_lookup]

	self:_show_collected_materials_notification(peer_id, material_type, material_size, interaction_type_lookup, material_value)
end

MutatorGameplay._show_collected_materials_notification = function (self, peer_id, material_type, material_size, interaction_type_lookup, material_value)
	local player_manager = Managers.player
	local local_player_id = 1
	local player = player_manager:player(peer_id, local_player_id)
	local player_name = player and player:name()
	local player_slot = player and player.slot and player:slot()
	local player_slot_colors = UISettings.player_slot_colors
	local player_slot_color = player_slot and player_slot_colors[player_slot]

	if player_name and player_slot_color then
		player_name = Text.apply_color_to_text(player_name, player_slot_color)
	end

	local localization_key = self._side_notification_settings.interaction_type_loc_strings[interaction_type_lookup]

	Managers.event:trigger("event_add_notification_message", "mutator", {
		data_formatter = self._side_notification_data_formatter,
		data = {
			use_player_portrait = true,
			player = player,
			currency = material_type,
			amount_size = material_size,
			amount_value = material_value,
			player_name = player_name,
			localization_key = localization_key,
		},
	})
end

MutatorGameplay.rpc_show_objective_popup_notification = function (self, channel_id, key)
	if not self._notifications then
		return
	end

	local notification_data = self._notifications[key]

	if not notification_data then
		return
	end

	Managers.event:trigger("event_show_objective_popup", notification_data.title, notification_data.subtitle, notification_data.sound_event, notification_data.style)
end

MutatorGameplay.rpc_client_hordes_tag_remaining_enemies = function (self, channel_id)
	return
end

MutatorGameplay.hot_join_sync = function (self, sender, channel)
	MutatorGameplay.super.hot_join_sync(self, sender, channel)

	local did_handle = false

	for i = 1, #self._gameplay_levels do
		local gameplay_instance, is_valid = self:gameplay_instance(self._gameplay_levels[i])

		if is_valid then
			did_handle = true

			gameplay_instance:hot_join_sync(sender, channel)
		end
	end

	if did_handle then
		return
	end

	if self._gameplay_module.module_hot_join_sync then
		self._gameplay_module.module_hot_join_sync(self, sender, channel)
	end
end

return MutatorGameplay
