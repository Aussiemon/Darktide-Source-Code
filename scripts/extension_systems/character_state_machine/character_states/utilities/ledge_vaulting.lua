local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local LedgeVaulting = {}

LedgeVaulting.can_enter = function (ledge_finder_extension, ledge_tweak_data, unit_data_extension, input_extension, visual_loadout_extension)
	local inventory_component = unit_data_extension:read_component("inventory")

	if PlayerUnitVisualLoadout.slot_equipped(inventory_component, visual_loadout_extension, "slot_luggable") then
		return false
	end

	local num_ledges, ledge_data = ledge_finder_extension:ledges()

	if num_ledges == 0 then
		return false
	end

	local character_state_component = unit_data_extension:read_component("character_state")
	local state_name = character_state_component.state_name
	local in_air = state_name == "falling" or state_name == "jumping"
	local allowed_height_distance_max, allowed_height_distance_min = nil

	if in_air then
		allowed_height_distance_max = ledge_tweak_data.inair_allowed_height_distance_max or ledge_tweak_data.allowed_height_distance_max
		allowed_height_distance_min = ledge_tweak_data.inair_allowed_height_distance_min or ledge_tweak_data.allowed_height_distance_min
	else
		allowed_height_distance_max = ledge_tweak_data.allowed_height_distance_max
		allowed_height_distance_min = ledge_tweak_data.allowed_height_distance_min
	end

	local allowed_flat_distance_to_ledge = ledge_tweak_data.allowed_flat_distance_to_ledge
	local allowed_flat_distance_to_ledge_sq = allowed_flat_distance_to_ledge * allowed_flat_distance_to_ledge
	local ledge = ledge_data[1]
	local height_distance = ledge.height_distance_from_player_unit

	if allowed_height_distance_max < height_distance then
		return false
	end

	if height_distance < allowed_height_distance_min then
		return false
	end

	local distance_flat_sq = ledge.distance_flat_sq_from_player_unit

	if allowed_flat_distance_to_ledge_sq < distance_flat_sq then
		return false
	end

	local move = input_extension:get("move")
	local move_norm = Vector3.normalize(move)
	local first_person_component = unit_data_extension:read_component("first_person")
	local fp_rotation = first_person_component.rotation
	local wanted_move_dir = Quaternion.rotate(fp_rotation, move_norm)
	local ledge_forward = ledge.forward:unbox()
	local dot = Vector3.dot(ledge_forward, wanted_move_dir)

	if dot < 0.3 then
		return false
	end

	return true, ledge
end

return LedgeVaulting
