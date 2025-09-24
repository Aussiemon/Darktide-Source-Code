-- chunkname: @scripts/extension_systems/interaction/interactions/companion_hub_interaction.lua

local FixedFrame = require("scripts/utilities/fixed_frame")
local CompanionHubInteractionsSettings = require("scripts/settings/companion/companion_hub_interactions_settings")
local CompanionHubInteraction = class("CompanionHubInteraction", "BaseInteraction")

CompanionHubInteraction.start = function (self, world, interactor_unit, unit_data_component, t, interactor_is_server)
	local target_unit = unit_data_component.target_unit
	local blocked = self:_is_blocked(interactor_unit, target_unit)

	if not blocked then
		self:_start(interactor_unit, target_unit)
	end

	return false
end

CompanionHubInteraction._start = function (self, interactor_unit, interactee_unit)
	Managers.state.companion_interaction:trigger_interaction(interactor_unit, interactee_unit)
end

CompanionHubInteraction._is_blocked = function (self, interactor_unit, interactee_unit)
	local player = Managers.state.player_unit_spawn:owner(interactee_unit)

	if not player then
		return true
	end

	return false
end

CompanionHubInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	local interactee_data_extension = ScriptUnit.extension(interactee_unit, "unit_data_system")
	local breed = interactee_data_extension and interactee_data_extension:breed()

	if breed.name ~= "companion_dog" then
		return false
	end

	local companion_owner = Managers.state.player_unit_spawn:owner(interactor_unit)
	local interactee_owner = Managers.state.player_unit_spawn:owner(interactee_unit)
	local is_our_companion = companion_owner == interactee_owner

	if not is_our_companion then
		return false
	end

	local interactor_data_extension = ScriptUnit.extension(interactor_unit, "unit_data_system")
	local hub_jog_component = interactor_data_extension:read_component("hub_jog_character_state")
	local locomotion_component = interactor_data_extension:read_component("locomotion")
	local locomotion_steering_component = interactor_data_extension:read_component("locomotion_steering")
	local current_velocity = locomotion_component.velocity_current
	local current_rotation = locomotion_component.rotation
	local target_rotation = locomotion_steering_component.target_rotation
	local dot_rotation = Quaternion.dot(current_rotation, target_rotation)
	local character_not_moving = Vector3.length_squared(current_velocity) == 0
	local is_character_facing_target_rotation = dot_rotation < 1.005 and dot_rotation > 0.995
	local is_interactor_idle = hub_jog_component.method == "idle" and character_not_moving and is_character_facing_target_rotation

	if not is_interactor_idle then
		self._last_time_character_not_idle = nil

		return false
	end

	if not self._last_time_character_not_idle then
		self._last_time_character_not_idle = FixedFrame.get_latest_fixed_time()
	end

	local current_time = FixedFrame.get_latest_fixed_time()
	local time_to_enable_interaction = self._last_time_character_not_idle + CompanionHubInteractionsSettings.delay_before_can_interact_with_companion_when_idled

	if current_time < time_to_enable_interaction then
		return false
	end

	return CompanionHubInteraction.super.interactor_condition_func(self, interactor_unit, interactee_unit)
end

return CompanionHubInteraction
