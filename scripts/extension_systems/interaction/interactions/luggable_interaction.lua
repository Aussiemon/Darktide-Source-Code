-- chunkname: @scripts/extension_systems/interaction/interactions/luggable_interaction.lua

require("scripts/extension_systems/interaction/interactions/base_interaction")

local Luggable = require("scripts/utilities/luggable")
local Pickups = require("scripts/settings/pickup/pickups")
local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local valid_interaction_states = ProjectileLocomotionSettings.valid_interaction_states
local NON_SUPPORTED_CHARACTER_STATES = {
	ladder_climbing = true,
	ladder_top_entering = true,
	ladder_top_leaving = true,
	ledge_vaulting = true,
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
		local pickup_name = Unit.get_data(interactee_unit, "pickup_type")
		local pickup_data = Pickups.by_name[pickup_name]

		Luggable.equip_to_player_unit(interactor_unit, interactee_unit, t)

		if pickup_data.on_pickup_func then
			pickup_data.on_pickup_func(interactee_unit, interactor_unit, pickup_data, t)
		end

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

LuggableInteraction.hud_block_text = function (self, interactor_unit, interactee_unit, target_node)
	local player = Managers.state.player_unit_spawn:owner(interactor_unit)

	if player then
		local mechanism_manager = Managers.mechanism
		local mechanism_name = mechanism_manager:mechanism_name()

		if mechanism_name == "expedition" then
			local game_mode_manager = Managers.state.game_mode
			local game_mode = game_mode_manager:game_mode()

			if game_mode:in_safe_zone() and game_mode:is_store_product(interactee_unit) then
				local peer_id = player:peer_id()
				local expedition_currency_amount = game_mode:expedition_currency(peer_id)
				local purchase_price = game_mode:get_unit_store_product_price(interactee_unit)
				local can_afford = purchase_price <= expedition_currency_amount

				if not can_afford then
					local blocked_text = "loc_mindwipe_insufficient_funds_popup_title"

					return blocked_text
				end
			end
		end
	end

	return LuggableInteraction.super.hud_block_text(self, interactor_unit, interactee_unit, target_node)
end

return LuggableInteraction
