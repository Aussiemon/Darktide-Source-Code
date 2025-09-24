-- chunkname: @scripts/settings/buff/fire_step_functions.lua

local Ammo = require("scripts/utilities/ammo")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local FireStepFunctions = {
	default_continuous_fire_step_func = function (template_data, template_context)
		if ConditionalFunctions.is_reloading(template_data, template_context) then
			return 0
		end

		local inventory_slot_component = template_data.inventory_slot_component

		if not inventory_slot_component then
			return 0
		end

		local max_ammunition_clip = Ammo.max_ammo_in_clips(inventory_slot_component)

		return math.max(1, math.floor(max_ammunition_clip * 0.1))
	end,
	toughness_regen_continuous_fire_step_func = function (template_data, template_context)
		if ConditionalFunctions.is_reloading(template_data, template_context) then
			return 0
		end

		local inventory_slot_component = template_data.inventory_slot_component

		if not inventory_slot_component then
			return 0
		end

		local max_ammunition_clip = Ammo.max_ammo_in_clips(inventory_slot_component)

		return math.max(1, math.floor(max_ammunition_clip * 0.1))
	end,
	movement_speed_continuous_fire_step_func = function (template_data, template_context)
		if ConditionalFunctions.is_reloading(template_data, template_context) then
			return 0
		end

		local inventory_slot_component = template_data.inventory_slot_component

		if not inventory_slot_component then
			return 0
		end

		local max_ammunition_clip = Ammo.max_ammo_in_clips(inventory_slot_component)

		return math.max(1, math.floor(max_ammunition_clip * 0.05))
	end,
	suppression_continuous_fire_step_func = function (template_data, template_context)
		if ConditionalFunctions.is_reloading(template_data, template_context) then
			return 0
		end

		local inventory_slot_component = template_data.inventory_slot_component

		if not inventory_slot_component then
			return 0
		end

		local max_ammunition_clip = Ammo.max_ammo_in_clips(inventory_slot_component)

		return math.max(1, math.floor(max_ammunition_clip * 0.025))
	end,
}

return FireStepFunctions
