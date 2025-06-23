-- chunkname: @scripts/managers/companion/companion_interactions_manager.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local CompanionHubInteractionsSettings = require("scripts/settings/companion_hub_interactions/companion_hub_interactions_settings")
local NavQueries = require("scripts/utilities/nav_queries")
local CompanionInteractionsManager = class("CompanionInteractionsManager")
local SERVER_RPCS = {}
local CLIENT_RPCS = {
	"rpc_client_start_companion_interaction",
	"rpc_client_stop_companion_interaction",
	"rpc_client_start_companion_interaction_anim_event",
	"rpc_client_interrupt_companion_interaction_anim_event"
}

CompanionInteractionsManager.init = function (self, is_host, network_event_delegate)
	self._is_host = is_host
	self._active_interactions = {}
	self._network_event_delegate = network_event_delegate

	network_event_delegate:register_session_events(self, unpack(is_host and SERVER_RPCS or CLIENT_RPCS))
end

CompanionInteractionsManager.destroy = function (self)
	self._network_event_delegate:unregister_events(unpack(self._is_host and SERVER_RPCS or CLIENT_RPCS))
	table.clear(self._active_interactions)
end

CompanionInteractionsManager.fixed_update = function (self, dt, fixed_t, frame)
	if self._is_host then
		local active_interactions = self._active_interactions
		local finished_interactions = {}

		for player_unit, interaction in pairs(active_interactions) do
			if interaction.has_animation_started then
				interaction.time_remaining = interaction.time_remaining - dt

				if interaction.time_remaining <= 0 then
					table.insert(finished_interactions, player_unit)
				end
			end
		end

		for _, player_unit in pairs(finished_interactions) do
			local owning_player = Managers.state.player_unit_spawn:owner(player_unit)

			self._interaction_fully_completed(owning_player, active_interactions[player_unit].settings)
			self:stop_interaction(player_unit)

			active_interactions[player_unit] = nil
		end
	else
		local local_interaction = self._local_player_active_interaction

		if local_interaction and local_interaction.has_animation_started then
			local_interaction.time_remaining = local_interaction.time_remaining - dt

			if local_interaction.time_remaining <= 0 then
				self:stop_interaction(local_interaction.player_unit)
			end
		end
	end
end

CompanionInteractionsManager.is_player_interacting = function (self, player_unit)
	return self._active_interactions[player_unit] ~= nil
end

local function _get_target_distance_from_player_based_on_height(player, base_distance)
	local profile = player:profile()
	local profile_size = profile.personal and profile.personal.character_height or 1

	return base_distance * profile_size
end

local function _try_get_interaction_position_for_companion(player_unit, target_position_distance_from_player)
	local owning_player = Managers.state.player_unit_spawn:owner(player_unit)
	local player_position = Unit.world_position(player_unit, 1)
	local rotation = Unit.world_rotation(player_unit, 1)
	local player_forward_direction = Quaternion.forward(rotation)
	local player_flat_forward_direction = Vector3.normalize(Vector3.flat(player_forward_direction))
	local companion_distance_to_player = target_position_distance_from_player
	local companion_distance_to_player_scaled = _get_target_distance_from_player_based_on_height(owning_player, companion_distance_to_player)
	local companion_interaction_position = player_position + Vector3.multiply(player_flat_forward_direction, companion_distance_to_player_scaled)
	local nav_world = Managers.state.nav_mesh:nav_world()
	local nav_new_position = NavQueries.position_on_mesh(nav_world, companion_interaction_position, 0.5, 0.5)

	return nav_new_position
end

CompanionInteractionsManager._start_interaction = function (self, player_unit, companion_unit, is_local_player)
	local active_interactions = self._active_interactions
	local companion_interaction_position = _try_get_interaction_position_for_companion(player_unit, CompanionHubInteractionsSettings.distance_to_player)

	if not companion_interaction_position then
		return false
	end

	if self._is_host then
		local companion_blackboard = BLACKBOARDS[companion_unit]
		local behavior_component = Blackboard.write_component(companion_blackboard, "behavior")
		local interaction_component = Blackboard.write_component(companion_blackboard, "hub_interaction_with_player")
		local navigation_extension = ScriptUnit.extension(companion_unit, "navigation_system")

		navigation_extension:set_enabled(true, 6)
		behavior_component.move_to_position:store(companion_interaction_position)

		behavior_component.has_move_to_position = true
		interaction_component.has_owner_started_interaction = true

		local companion_interactee_extension = ScriptUnit.has_extension(companion_unit, "interactee_system")

		companion_interactee_extension:set_active(false)

		local player_unit_id = Managers.state.unit_spawner:game_object_id(player_unit)
		local companion_unit_id = Managers.state.unit_spawner:game_object_id(companion_unit)
		local owning_player = Managers.state.player_unit_spawn:owner(player_unit)

		if player_unit_id and companion_unit_id and owning_player then
			local channel_id = owning_player:channel_id()

			Managers.state.game_session:send_rpc_clients_except("rpc_client_start_companion_interaction", channel_id, player_unit_id, companion_unit_id)
		end
	end

	local interaction = {
		time_remaining = 15,
		has_animation_started = false,
		player_unit = player_unit,
		companion_unit = companion_unit
	}

	active_interactions[player_unit] = interaction

	if is_local_player then
		self._local_player_active_interaction = interaction
	end

	return true
end

CompanionInteractionsManager._stop_interaction = function (self, player_unit)
	local current_interaction = self._active_interactions[player_unit]
	local companion_unit = current_interaction and current_interaction.companion_unit

	if self._is_host and companion_unit and ALIVE[companion_unit] then
		local companion_blackboard = BLACKBOARDS[companion_unit]
		local interaction_component = Blackboard.write_component(companion_blackboard, "hub_interaction_with_player")

		interaction_component.has_owner_started_interaction = false

		local companion_interactee_extension = ScriptUnit.has_extension(companion_unit, "interactee_system")

		companion_interactee_extension:set_active(true)

		local player_unit_id = Managers.state.unit_spawner:game_object_id(player_unit)
		local owning_player = Managers.state.player_unit_spawn:owner(player_unit)

		if player_unit_id and owning_player then
			local channel_id = owning_player:channel_id()

			Managers.state.game_session:send_rpc_clients_except("rpc_client_stop_companion_interaction", channel_id, player_unit_id)
		end
	end

	self._active_interactions[player_unit] = nil

	if self._local_player_active_interaction and self._local_player_active_interaction.player_unit == player_unit then
		self._local_player_active_interaction = nil
	end
end

CompanionInteractionsManager._interaction_fully_completed = function (player, interaction_settings)
	if DEDICATED_SERVER and player then
		Managers.achievements:unlock_achievement(player, "adamant_pet_companion")
		Managers.telemetry_events:player_interacted_with_companion_in_hub(player, interaction_settings and interaction_settings.animation_name, 1)
	end
end

CompanionInteractionsManager.trigger_interaction = function (self, player_unit, companion_unit)
	if ALIVE[player_unit] and ALIVE[companion_unit] then
		self:_start_interaction(player_unit, companion_unit, not self._is_host)
	end
end

CompanionInteractionsManager.stop_interaction = function (self, player_unit)
	self:_stop_interaction(player_unit)
end

CompanionInteractionsManager.start_interaction_animation = function (self, interaction)
	if self._is_host then
		local player_unit = interaction.player_unit
		local companion_unit = interaction.companion_unit
		local player_unit_id = Managers.state.unit_spawner:game_object_id(player_unit)
		local companion_unit_id = Managers.state.unit_spawner:game_object_id(companion_unit)
		local animation_system = Managers.state.extension:system("animation_system")
		local interactions_settings = CompanionHubInteractionsSettings.interactions
		local num_interactions = #interactions_settings
		local target_interaction_index = math.random(1, num_interactions)
		local target_interaction_settings = interactions_settings[target_interaction_index]
		local player_anim_event = CompanionHubInteractionsSettings.default_anim_event
		local companion_anim_event = CompanionHubInteractionsSettings.default_anim_event
		local animation_selection_variable_name = CompanionHubInteractionsSettings.animation_selection_variable_name

		interaction.settings = target_interaction_settings

		self:set_interaction_duration_for_player_unit(player_unit, target_interaction_settings.duration)
		animation_system.play_companion_interaction_anim_event(player_unit, companion_unit, player_anim_event, companion_anim_event, animation_selection_variable_name, target_interaction_index)
		Managers.state.game_session:send_rpc_clients("rpc_client_start_companion_interaction_anim_event", player_unit_id, companion_unit_id, target_interaction_index)
	end
end

CompanionInteractionsManager.interrupt_interaction_animation = function (self, player_unit)
	local interaction = self._active_interactions[player_unit]

	if not interaction or not interaction.settings then
		return
	end

	local companion_unit = interaction.companion_unit
	local animation_system = Managers.state.extension:system("animation_system")

	animation_system.play_companion_interaction_anim_event(player_unit, companion_unit, "emote_finished", "idle", nil, nil)

	if self._is_host then
		local player_unit_id = Managers.state.unit_spawner:game_object_id(player_unit)
		local companion_unit_id = Managers.state.unit_spawner:game_object_id(companion_unit)
		local owning_player = Managers.state.player_unit_spawn:owner(player_unit)

		if player_unit_id and companion_unit_id and owning_player then
			local channel_id = owning_player:channel_id()
			local animation_completion_percentage = math.clamp01((interaction.settings.duration - interaction.time_remaining) / interaction.settings.duration)

			Managers.telemetry_events:player_interacted_with_companion_in_hub(owning_player, interaction.settings.animation_name, animation_completion_percentage)
			Managers.state.game_session:send_rpc_clients_except("rpc_client_interrupt_companion_interaction_anim_event", channel_id, player_unit_id, companion_unit_id)
		end
	end
end

CompanionInteractionsManager.set_interaction_duration_for_player_unit = function (self, player_unit, interaction_time)
	if self:is_player_interacting(player_unit) then
		local active_interaction = self._active_interactions[player_unit]

		active_interaction.time_remaining = interaction_time
		active_interaction.has_animation_started = true
	end
end

CompanionInteractionsManager.companion_is_in_position_for_interaction = function (self, companion_owner_unit, companion_unit)
	if not self._is_host then
		return
	end

	local companion_interaction = self._active_interactions[companion_owner_unit]

	if companion_interaction then
		self:start_interaction_animation(companion_interaction)
	end
end

CompanionInteractionsManager.rpc_client_start_companion_interaction = function (self, _, player_unit_id, companion_unit_id)
	local player_unit = Managers.state.unit_spawner:unit(player_unit_id)
	local companion_unit = Managers.state.unit_spawner:unit(companion_unit_id)

	if player_unit and companion_unit then
		self:_start_interaction(player_unit, companion_unit, false)
	end
end

CompanionInteractionsManager.rpc_client_stop_companion_interaction = function (self, _, player_unit_id)
	local player_unit = Managers.state.unit_spawner:unit(player_unit_id)

	if player_unit then
		self:_stop_interaction(player_unit)
	end
end

CompanionInteractionsManager.rpc_client_start_companion_interaction_anim_event = function (self, channel_id, player_unit_id, companion_unit_id, target_interaction_index)
	local player_unit = Managers.state.unit_spawner:unit(player_unit_id)
	local companion_unit = Managers.state.unit_spawner:unit(companion_unit_id)
	local animation_system = Managers.state.extension:system("animation_system")
	local interactions_settings = CompanionHubInteractionsSettings.interactions
	local target_interaction_settings = interactions_settings[target_interaction_index]
	local player_anim_event = CompanionHubInteractionsSettings.default_anim_event
	local companion_anim_event = CompanionHubInteractionsSettings.default_anim_event
	local animation_selection_variable_name = CompanionHubInteractionsSettings.animation_selection_variable_name

	if self._local_player_active_interaction then
		self._local_player_active_interaction.settings = target_interaction_settings
	end

	self:set_interaction_duration_for_player_unit(player_unit, target_interaction_settings.duration)
	animation_system.play_companion_interaction_anim_event(player_unit, companion_unit, player_anim_event, companion_anim_event, animation_selection_variable_name, target_interaction_index)
end

CompanionInteractionsManager.rpc_client_interrupt_companion_interaction_anim_event = function (self, channel_id, player_unit_id, companion_unit_id)
	local player_unit = Managers.state.unit_spawner:unit(player_unit_id)
	local companion_unit = Managers.state.unit_spawner:unit(companion_unit_id)
	local animation_system = Managers.state.extension:system("animation_system")

	animation_system.play_companion_interaction_anim_event(player_unit, companion_unit, "emote_finished", "idle", nil, nil)
end

return CompanionInteractionsManager
