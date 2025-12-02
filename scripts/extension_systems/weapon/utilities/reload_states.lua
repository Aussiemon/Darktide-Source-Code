-- chunkname: @scripts/extension_systems/weapon/utilities/reload_states.lua

local Ammo = require("scripts/utilities/ammo")
local _reset_state
local ReloadStates = {}

ReloadStates.reload_kinds = {
	reload_shotgun = true,
	reload_state = true,
}

ReloadStates.reset = function (reload_template, inventory_slot_component)
	_reset_state(reload_template, inventory_slot_component)
end

ReloadStates.start_reload_state = function (reload_template, inventory_slot_component, condition_func_params)
	local state_name = inventory_slot_component.reload_state
	local state_config = reload_template[state_name]
	local anim_1p = state_config.anim_1p
	local anim_3p = state_config.anim_3p or anim_1p
	local action_time_offset = state_config.action_time_offset

	if type(anim_1p) == "function" then
		anim_1p = anim_1p(condition_func_params)
	end

	if type(anim_3p) == "function" then
		anim_3p = anim_3p(condition_func_params)
	end

	return anim_1p, anim_3p, action_time_offset
end

ReloadStates.get_total_time = function (reload_template, inventory_slot_component)
	local reload_state = ReloadStates.reload_state(reload_template, inventory_slot_component)

	return reload_state.time
end

ReloadStates.uses_reload_states = function (inventory_slot_component)
	return inventory_slot_component.reload_state ~= "none"
end

ReloadStates.started_reload = function (reload_template, inventory_slot_component)
	local reload_state = inventory_slot_component.reload_state
	local state = reload_template[reload_state]

	return state.state_index > 1
end

ReloadStates.reload_state = function (reload_template, inventory_slot_component)
	local reload_state = inventory_slot_component.reload_state

	return reload_template[reload_state]
end

ReloadStates.reimburse_clip_to_reserve = function (inventory_slot_component)
	local current_ammo_reserve = inventory_slot_component.current_ammunition_reserve
	local current_ammo_clip = Ammo.current_ammo_in_clips(inventory_slot_component)

	inventory_slot_component.ammunition_at_reload_start = current_ammo_clip

	if not inventory_slot_component.free_ammunition_transfer then
		local new_ammunition_reserve = current_ammo_reserve + current_ammo_clip

		if Managers.state.game_mode:infinite_ammo_reserve() then
			new_ammunition_reserve = inventory_slot_component.max_ammunition_reserve
		end

		inventory_slot_component.current_ammunition_reserve = new_ammunition_reserve
	end

	Ammo.set_current_ammo_in_clips(inventory_slot_component, 0)
end

ReloadStates.reload = function (inventory_slot_component)
	local missing_ammo_in_clip = Ammo.missing_ammo_in_clips(inventory_slot_component)

	Ammo.transfer_from_reserve_to_clip(inventory_slot_component, missing_ammo_in_clip)
end

function _reset_state(reload_template, inventory_slot_component)
	local first_state = reload_template.states[1]

	inventory_slot_component.reload_state = first_state
end

return ReloadStates
