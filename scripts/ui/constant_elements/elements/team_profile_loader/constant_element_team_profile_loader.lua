-- chunkname: @scripts/ui/constant_elements/elements/team_profile_loader/constant_element_team_profile_loader.lua

local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local UICharacterProfilePackageLoader = require("scripts/managers/ui/ui_character_profile_package_loader")
local PlayerCompositions = require("scripts/utilities/players/player_compositions")
local MasterItems = require("scripts/backend/master_items")
local temp_team_players = {}
local player_template = {
	on_activation = function (self)
		local player = self.player

		if not self.active then
			local profile = player:profile()
			local account_id = player:account_id()
			local reference_name = "ConstantElementTeamProfileLoader_" .. account_id
			local item_definitions = MasterItems.get_cached()
			local profile_package_loader = UICharacterProfilePackageLoader:new(reference_name, item_definitions)
			local loading_items = profile_package_loader:load_profile(profile)

			self.loading_data = {
				player = player,
				profile = profile,
				account_id = account_id,
				loading_items = loading_items,
				profile_package_loader = profile_package_loader,
				item_definitions = item_definitions,
			}
			self.active = true
		end
	end,
	on_deactivation = function (self)
		local loading_data = self.loading_data
		local profile_package_loader = loading_data.profile_package_loader

		profile_package_loader:destroy()

		self.loading_data = nil
		self.active = false
	end,
	sync_profile_changes = function (self, updated_profile)
		local loading_data = self.loading_data

		if self.active then
			local loadout = updated_profile.loadout
			local loading_items = loading_data.loading_items
			local ignored_slots = loading_data.ignored_slots
			local profile_package_loader = loading_data.profile_package_loader

			for slot_id, config in pairs(ItemSlotSettings) do
				if not config.ignore_character_spawning and (not ignored_slots or not ignored_slots[slot_id]) then
					local item = loadout[slot_id]
					local loadout_item_name = item and item.name

					if loading_items[slot_id] ~= loadout_item_name then
						profile_package_loader:load_slot_item(slot_id, item)

						loading_items[slot_id] = loadout_item_name
					end
				end
			end
		end
	end,
}
local PLAYER_SYNC_DELAY_TIME = 10
local ConstantElementTeamProfileLoader = class("ConstantElementTeamProfileLoader")

ConstantElementTeamProfileLoader.init = function (self, parent, draw_layer, start_scale)
	self._player_instance_templates_by_account_id = {}
	self._event_listeners_initialized = false
	self._delay_timer = nil
end

ConstantElementTeamProfileLoader.destroy = function (self)
	if self._event_listeners_initialized then
		Managers.event:unregister(self, "event_player_profile_updated")
	end
end

ConstantElementTeamProfileLoader._on_state_changed = function (self, new_state_name)
	self._current_state_name = new_state_name
	self._delay_timer = nil
end

ConstantElementTeamProfileLoader.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	local current_sub_state_name = Managers.ui:get_current_sub_state_name()
	local current_state_name = current_sub_state_name == "" and Managers.ui:get_current_state_name() or current_sub_state_name

	if current_state_name ~= self._current_state_name then
		self:_on_state_changed(current_state_name)
	end

	if not Network.is_active() then
		return
	end

	if not self._event_listeners_initialized then
		local player_manager = Managers.player
		local local_player = player_manager and player_manager:local_player(self._local_player_id or 1)

		if local_player then
			self._event_listeners_initialized = true

			Managers.event:register(self, "event_player_profile_updated", "event_player_profile_updated")
		else
			return
		end
	end

	if self._delay_timer then
		self._delay_timer = self._delay_timer - dt

		if self._delay_timer <= 0 then
			self._delay_timer = nil
		end
	else
		self:_sync_player_template_instances()

		self._delay_timer = PLAYER_SYNC_DELAY_TIME
	end
end

ConstantElementTeamProfileLoader._sync_template_instances_by_players = function (self, players)
	local player_instance_templates_by_account_id = self._player_instance_templates_by_account_id

	for _, player in pairs(players) do
		local account_id = player:account_id()

		if account_id and player:profile() and not player_instance_templates_by_account_id[account_id] then
			player_instance_templates_by_account_id[account_id] = table.clone_instance(player_template)
			player_instance_templates_by_account_id[account_id].player = player
		end

		local instance = player_instance_templates_by_account_id[account_id]

		if instance and not instance.synced then
			if not instance.active then
				instance.on_activation(instance)

				instance.active = true
			end

			instance.synced = true
		end
	end
end

local player_composition_name_party = "party"
local player_composition_name_game_session = "game_session_players"

ConstantElementTeamProfileLoader._sync_player_template_instances = function (self)
	local party_players = PlayerCompositions.players(player_composition_name_party, temp_team_players)

	if party_players then
		self:_sync_template_instances_by_players(party_players)
	end

	if Managers.state.game_session then
		local game_session_players = PlayerCompositions.players(player_composition_name_game_session, temp_team_players)

		if game_session_players then
			self:_sync_template_instances_by_players(game_session_players)
		end
	end

	local player_instance_templates_by_account_id = self._player_instance_templates_by_account_id

	for account_id, instance in pairs(player_instance_templates_by_account_id) do
		if not instance.synced then
			if instance.active then
				local sync_on_events = instance.sync_on_events

				if sync_on_events then
					for j = 1, #sync_on_events do
						local event_name = sync_on_events[j]

						Managers.event:unregister(instance, event_name)
					end
				end

				instance.on_deactivation(instance)

				instance.active = false
			end

			player_instance_templates_by_account_id[account_id] = nil
		end

		instance.synced = nil
	end
end

ConstantElementTeamProfileLoader.event_player_profile_updated = function (self, peer_id, local_player_id, updated_profile)
	local character_id = updated_profile and updated_profile.character_id

	if character_id then
		local player_instance_templates_by_account_id = self._player_instance_templates_by_account_id

		for account_id, instance in pairs(player_instance_templates_by_account_id) do
			local player_template_instance = player_instance_templates_by_account_id[account_id]

			if player_template_instance then
				local instance_player = instance.player

				if instance_player and not instance_player.__deleted then
					local instance_profile = instance_player:profile()
					local instance_character_profile_id = instance_profile and instance_profile.character_id

					if instance_character_profile_id == character_id then
						player_template_instance.sync_profile_changes(player_template_instance, updated_profile)
					end
				end
			end
		end
	end

	self._delay_timer = nil
end

ConstantElementTeamProfileLoader.set_visible = function (self, visible, optional_visibility_parameters)
	return
end

ConstantElementTeamProfileLoader.should_update = function (self)
	return true
end

ConstantElementTeamProfileLoader.should_draw = function (self)
	return false
end

return ConstantElementTeamProfileLoader
