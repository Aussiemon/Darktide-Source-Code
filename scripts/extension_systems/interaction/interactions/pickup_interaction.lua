require("scripts/extension_systems/interaction/interactions/base_interaction")

local Pickups = require("scripts/settings/pickup/pickups")
local PickupInteraction = class("PickupInteraction", "BaseInteraction")

PickupInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	if interactor_is_server and result == "success" then
		local interactee_unit = unit_data_component.target_unit
		local pickup_name = Unit.get_data(interactee_unit, "pickup_type")
		local pickup_data = Pickups.by_name[pickup_name]

		pickup_data.on_pickup_func(interactee_unit, interactor_unit)

		local player_or_nil = Managers.state.player_unit_spawn:owner(interactor_unit)
		local interactor_session_id_or_nil = player_or_nil and player_or_nil:session_id()

		self:_picked_up(interactee_unit, interactor_session_id_or_nil)
		self:_trigger_sound(interactor_unit, pickup_data)

		local pickup_animation_system = Managers.state.extension:system("pickup_animation_system")

		if not pickup_animation_system:start_animation_to_unit(interactee_unit, interactor_unit) then
			local pickup_system = Managers.state.extension:system("pickup_system")

			pickup_system:despawn_pickup(interactee_unit)
		end
	end
end

PickupInteraction.interactee_show_marker_func = function (self, interactor_unit, interactee_unit)
	local interactee_ext = ScriptUnit.extension(interactee_unit, "interactee_system")

	if interactee_ext:used() then
		return false
	end

	return not self:_interactor_disabled(interactor_unit)
end

PickupInteraction._trigger_sound = function (self, interactor_unit, pickup_data)
	if pickup_data and pickup_data.pickup_sound then
		local pickup_position = POSITION_LOOKUP[interactor_unit]
		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:trigger_wwise_event(pickup_data.pickup_sound, pickup_position)
	end
end

PickupInteraction._update_stats = function (self, target_unit, interactor_session_id)
	if not interactor_session_id then
		return
	end

	local pickup_name = Unit.get_data(target_unit, "pickup_type")
	local player_or_nil = Managers.player:player_from_session_id(interactor_session_id)

	if player_or_nil then
		Managers.telemetry_reporters:reporter("picked_items"):register_event(player_or_nil, pickup_name)

		local is_human_player = player_or_nil:is_human_controlled()

		if Managers.stats.can_record_stats() and is_human_player then
			Managers.stats:record_pickup_item(player_or_nil, pickup_name)
		end
	end

	local pickup_system = Managers.state.extension:system("pickup_system")
	local owner_session_id_or_nil = pickup_system:get_owner(target_unit)
	local owning_player_or_nil = owner_session_id_or_nil and Managers.player:player_from_session_id(owner_session_id_or_nil)
	local is_human_owner = owning_player_or_nil and owning_player_or_nil:is_human_controlled()
	local interacted_before = pickup_system:has_interacted(target_unit, interactor_session_id)
	local interactor_is_owner = interactor_session_id == owner_session_id_or_nil

	if owning_player_or_nil and not interacted_before and not interactor_is_owner then
		Managers.telemetry_reporters:reporter("shared_items"):register_event(owning_player_or_nil, pickup_name)

		if Managers.stats.can_record_stats() and is_human_owner then
			Managers.stats:record_share_item(owning_player_or_nil, pickup_name)
		end
	end
end

PickupInteraction._interact_with = function (self, target_unit, interactor_session_id)
	local pickup_system = Managers.state.extension:system("pickup_system")

	self:_update_stats(target_unit, interactor_session_id)
	pickup_system:interact_with(target_unit, interactor_session_id)
end

PickupInteraction._picked_up = function (self, target_unit, interactor_session_id)
	local pickup_system = Managers.state.extension:system("pickup_system")

	self:_update_stats(target_unit, interactor_session_id)
	pickup_system:picked_up(target_unit, interactor_session_id)
end

PickupInteraction._use_charge = function (self, target_unit, interactor_unit)
	local game_session = Managers.state.game_session:game_session()
	local game_object_id = Managers.state.unit_spawner:game_object_id(target_unit)
	local remaining_charges = GameSession.game_object_field(game_session, game_object_id, "charges")
	local player_or_nil = Managers.state.player_unit_spawn:owner(interactor_unit)
	local interactor_session_id_or_nil = player_or_nil and player_or_nil:session_id()

	if remaining_charges > 1 then
		GameSession.set_game_object_field(game_session, game_object_id, "charges", remaining_charges - 1)
		self:_interact_with(target_unit, interactor_session_id_or_nil)
	else
		local interactee_ext = ScriptUnit.extension(target_unit, "interactee_system")

		interactee_ext:set_used()
		self:_picked_up(target_unit, interactor_session_id_or_nil)

		local pickup_animation_system = Managers.state.extension:system("pickup_animation_system")

		if not pickup_animation_system:start_animation_to_unit(target_unit, interactor_unit) then
			local pickup_system = Managers.state.extension:system("pickup_system")

			pickup_system:despawn_pickup(target_unit)
		end
	end
end

return PickupInteraction
