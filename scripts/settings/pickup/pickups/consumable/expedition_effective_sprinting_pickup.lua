-- chunkname: @scripts/settings/pickup/pickups/consumable/expedition_effective_sprinting_pickup.lua

local pickup_data = {
	buff_name = "expedition_effective_sprinting_buff",
	description = "loc_game_mode_expedition_pickup_buff_effective_sprinting",
	group = "forge_material",
	interaction_type = "forge_material",
	look_at_tag = "forge_material",
	name = "expedition_effective_sprinting",
	pickup_sound = "wwise/events/player/play_pick_up_expeditions_store_sprinting",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/consumables/expeditions/boons/boon",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data, t)
		local target_buff_extension = ScriptUnit.has_extension(interactor_unit, "buff_system")

		if target_buff_extension then
			local buff_name = pickup_data.buff_name

			target_buff_extension:add_internally_controlled_buff(buff_name, t)
		end
	end,
}

return pickup_data
