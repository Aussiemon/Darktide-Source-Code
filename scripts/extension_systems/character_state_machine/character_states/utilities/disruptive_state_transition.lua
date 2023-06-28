local Overheat = require("scripts/utilities/overheat")
local WarpCharge = require("scripts/utilities/warp_charge")
local DisruptiveStateTransition = {}

DisruptiveStateTransition.poll = function (unit, unit_data_extension, next_state_params)
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local overheat_explode, slot_name = Overheat.wants_overheat_character_state(unit, unit_data_extension)

	if overheat_explode then
		local configuration = Overheat.configuration(visual_loadout_extension, slot_name)
		local explode_action = configuration.explode_action
		next_state_params.slot_name = slot_name
		next_state_params.reason = "overheat"
		next_state_params.explode_action = explode_action
		next_state_params.wield_slot = nil

		return "exploding"
	end

	local warp_charge_explode = WarpCharge.wants_warp_charge_character_state(unit, unit_data_extension)

	if warp_charge_explode then
		local weapon_warp_charge_template = WarpCharge.weapon_warp_charge_template(unit)
		local explode_action = weapon_warp_charge_template and weapon_warp_charge_template.explode_action_override
		local slot_to_wield = nil

		if not explode_action then
			local player = Managers.state.player_unit_spawn:owner(unit)
			local base_warp_charge_template = WarpCharge.specialization_warp_charge_template(player)
			explode_action = base_warp_charge_template.explode_action
			slot_to_wield = "slot_unarmed"
		end

		next_state_params.slot_name = "slot_unarmed"
		next_state_params.reason = "warp_charge"
		next_state_params.explode_action = explode_action
		next_state_params.wield_slot = slot_to_wield

		return "exploding"
	end

	local disabled_state_input = unit_data_extension:read_component("disabled_state_input")

	if disabled_state_input.wants_disable and disabled_state_input.disabling_unit then
		local disabling_type = disabled_state_input.disabling_type

		if disabling_type == "pounced" then
			return "pounced"
		end

		if disabling_type == "netted" then
			return "netted"
		end

		if disabling_type == "warp_grabbed" then
			return "warp_grabbed"
		end

		if disabling_type == "mutant_charged" then
			return "mutant_charged"
		end

		if disabling_type == "consumed" then
			return "consumed"
		end

		if disabling_type == "grabbed" then
			return "grabbed"
		end
	end

	local catapulted_state_input = unit_data_extension:read_component("catapulted_state_input")

	if catapulted_state_input.new_input then
		local velocity = catapulted_state_input.velocity
		next_state_params.velocity = velocity

		return "catapulted"
	end

	local stun_state_input = unit_data_extension:read_component("stun_state_input")
	local disorientation_type = stun_state_input.disorientation_type

	if disorientation_type ~= "none" then
		local current_frame = unit_data_extension:last_fixed_frame()

		if stun_state_input.stun_frame <= current_frame then
			next_state_params.disorientation_type = disorientation_type
			local push_direction = stun_state_input.push_direction

			if Vector3.length_squared(push_direction) ~= 0 then
				next_state_params.push_direction = push_direction
			end

			return "stunned"
		end
	end
end

return DisruptiveStateTransition
