require("scripts/extension_systems/interaction/interactions/base_interaction")

local Luggable = require("scripts/utilities/luggable")
local Pickups = require("scripts/settings/pickup/pickups")
local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local valid_interaction_states = ProjectileLocomotionSettings.valid_interaction_states
local NON_SUPPORTED_CHARACTER_STATES = {
	ladder_top_leaving = true,
	ledge_vaulting = true,
	ladder_climbing = true,
	ladder_top_entering = true
}
local LuggableInteraction = class("LuggableInteraction", "BaseInteraction")

LuggableInteraction.interactor_condition_func = function (self, interactor_unit, interactee_unit)
	if self:_interactor_disabled(interactor_unit) then
		return false
	end

	local unit_data_extension = ScriptUnit.extension(interactor_unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local wielded_slot = inventory_component.wielded_slot

	if wielded_slot == "slot_luggable" or wielded_slot == "slot_unarmed" then
		return false
	end

	local character_state_component = unit_data_extension:read_component("character_state")

	if NON_SUPPORTED_CHARACTER_STATES[character_state_component.state_name] then
		return false
	end

	local locomotion_extension = ScriptUnit.extension(interactee_unit, "locomotion_system")

	if locomotion_extension then
		local current_state = locomotion_extension:current_state()

		if not valid_interaction_states[current_state] then
			return false
		end
	end

	return true
end

LuggableInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, is_server)
	if is_server and result == "success" then
		local interactee_unit = unit_data_component.target_unit

		Luggable.equip_to_player_unit(interactor_unit, interactee_unit, t)

		local pickup_name = Unit.get_data(interactee_unit, "pickup_type")
		local pickup_data = Pickups.by_name[pickup_name]

		if pickup_data.pickup_sound then
			local interactee_position = POSITION_LOOKUP[interactee_unit]
			local fx_system = Managers.state.extension:system("fx_system")

			fx_system:trigger_wwise_event(pickup_data.pickup_sound, interactee_position)
		end

		local player_or_nil = Managers.state.player_unit_spawn:owner(interactor_unit)
		local session_id_or_nil = player_or_nil and player_or_nil:session_id()
		local pickup_system = Managers.state.extension:system("pickup_system")

		pickup_system:picked_up(interactee_unit, session_id_or_nil)
	end
end

return LuggableInteraction
