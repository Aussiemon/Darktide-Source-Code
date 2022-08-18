local Ammo = require("scripts/utilities/ammo")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Pickups = require("scripts/settings/pickup/pickups")
local BotOrder = {
	lookup = {
		drop = "pickup_names"
	}
}
local AMMO_PICKUP_VALID_DURATION = 5

local function _order_ammo_pickup(bot_unit, pickup_unit, ordering_player)
	local group_extension = ScriptUnit.extension(bot_unit, "group_system")
	local bot_group_data = group_extension:bot_group_data()

	if bot_group_data then
		local has_full_ammo = Ammo.reserve_ammo_is_full(bot_unit)

		if has_full_ammo then
		else
			local time_manager = Managers.time
			local t = time_manager:time("gameplay")
			local bot_position = POSITION_LOOKUP[bot_unit]
			local pickup_position = POSITION_LOOKUP[pickup_unit]
			local pickup_distance = Vector3.distance(bot_position, pickup_position)
			local pickup_component = bot_group_data.pickup_component
			pickup_component.ammo_pickup = pickup_unit
			pickup_component.ammo_pickup_distance = pickup_distance
			pickup_component.ammo_pickup_valid_until = t + AMMO_PICKUP_VALID_DURATION
			local blackboard = BLACKBOARDS[bot_unit]
			local follow_component = Blackboard.write_component(blackboard, "follow")
			follow_component.needs_destination_refresh = true
			bot_group_data.ammo_pickup_order_unit = pickup_unit
		end
	else
		local bot_group = group_extension:bot_group()
		local bot_data = bot_group:data()

		for unit, data in pairs(bot_data) do
			local order_unit = data.ammo_pickup_order_unit

			if order_unit == pickup_unit then
				local pickup_component = data.pickup_component
				pickup_component.ammo_pickup = nil
				pickup_component.ammo_pickup_distance = math.huge
				pickup_component.ammo_pickup_valid_until = -math.huge
				local blackboard = BLACKBOARDS[unit]
				local follow_component = Blackboard.write_component(blackboard, "follow")
				follow_component.needs_destination_refresh = true
				data.ammo_pickup_order_unit = nil
			end
		end
	end
end

BotOrder.pickup = function (bot_unit, pickup_unit, ordering_player)
	local game_session_manager = Managers.state.game_session
	local is_server = game_session_manager:is_server()

	if is_server then
		local pickup_name = Unit.get_data(pickup_unit, "pickup_type")
		local pickup_settings = Pickups.by_name[pickup_name]
		local slot_name = pickup_settings.slot_name

		if pickup_settings.group == "ammo" then
			_order_ammo_pickup(bot_unit, pickup_unit, ordering_player)
		elseif slot_name then
			local group_extension = ScriptUnit.extension(bot_unit, "group_system")
			local bot_group = group_extension:bot_group()
			local bot_group_data = group_extension:bot_group_data()
			local bot_data = bot_group:data()

			if bot_group_data then
				for unit, data in pairs(bot_data) do
					local order = data.pickup_orders[slot_name]

					if order and order.unit == pickup_unit then
						if unit == bot_unit then
							return
						else
							data.pickup_orders[slot_name] = nil
							local blackboard = BLACKBOARDS[unit]
							local follow_component = Blackboard.write_component(blackboard, "follow")
							follow_component.needs_destination_refresh = true
						end
					end
				end

				bot_group_data.pickup_orders[slot_name] = {
					unit = pickup_unit,
					pickup_name = pickup_name
				}
				local blackboard = BLACKBOARDS[bot_unit]
				local follow_component = Blackboard.write_component(blackboard, "follow")
				follow_component.needs_destination_refresh = true
			else
				for unit, data in pairs(bot_data) do
					local order = data.pickup_orders[slot_name]

					if order and order.unit == pickup_unit then
						data.pickup_orders[slot_name] = nil
						local blackboard = BLACKBOARDS[unit]
						local follow_component = Blackboard.write_component(blackboard, "follow")
						follow_component.needs_destination_refresh = true
					end
				end
			end
		end
	else
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[bot_unit]
		local side_id = side.side_id
		local order_type_id = NetworkLookup.bot_orders.pickup
		local unit_spawner_manager = Managers.state.unit_spawner
		local bot_unit_id = unit_spawner_manager:game_object_id(bot_unit)
		local pickup_unit_id = unit_spawner_manager:game_object_id(pickup_unit)
		local ordering_player_peer_id = ordering_player:peer_id()
		local ordering_player_local_id = ordering_player:local_player_id()

		game_session_manager:send_rpc_server("rpc_bot_unit_order", side_id, order_type_id, bot_unit_id, pickup_unit_id, ordering_player_peer_id, ordering_player_local_id)
	end
end

BotOrder.drop = function (bot_unit, pickup_name, ordering_player)
	local game_session_manager = Managers.state.game_session
	local is_server = game_session_manager:is_server()

	if is_server then
		local group_extension = ScriptUnit.extension(bot_unit, "group_system")
		local bot_group_data = group_extension:bot_group_data()

		if bot_group_data == nil then
			return
		end

		local pickup_settings = Pickups.by_name[pickup_name]
		local slot_name = pickup_settings.slot_name
		local order = bot_group_data.pickup_orders[slot_name]

		if order and order.pickup_name == pickup_name then
			bot_group_data.pickup_orders[slot_name] = nil
		end
	else
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[bot_unit]
		local side_id = side.side_id
		local order_type_id = NetworkLookup.bot_orders.drop
		local bot_unit_id = Managers.state.unit_spawner:game_object_id(bot_unit)
		local pickup_id = NetworkLookup.pickup_names[pickup_name]
		local ordering_player_peer_id = ordering_player:peer_id()
		local ordering_player_local_id = ordering_player:local_player_id()

		game_session_manager:send_rpc_server("rpc_bot_lookup_order", side_id, order_type_id, bot_unit_id, pickup_id, ordering_player_peer_id, ordering_player_local_id)
	end
end

return BotOrder
