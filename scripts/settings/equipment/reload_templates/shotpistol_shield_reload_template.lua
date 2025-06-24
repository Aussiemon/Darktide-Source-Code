-- chunkname: @scripts/settings/equipment/reload_templates/shotpistol_shield_reload_template.lua

local Action = require("scripts/utilities/action/action")
local reload_template = {
	name = "shotpistol_shield",
	states = {
		"eject_mag",
		"fit_new_mag",
		"cock_weapon",
	},
	eject_mag = {
		show_magazine_ammo_time = 1,
		time = 4,
		anim_1p = function (condition_func_params)
			local weapon_action_component = condition_func_params.weapon_action_component
			local weapon_extension = condition_func_params.weapon_extension

			if not weapon_extension then
				return "reload_middle"
			end

			local weapon_template = weapon_extension:weapon_template()

			if not weapon_template then
				return "reload_middle"
			end

			local previous_action_name, previous_action_settings = Action.previous_action(weapon_action_component, weapon_template)

			if not previous_action_name then
				return "reload_middle"
			end

			local previous_action_kind = previous_action_settings.kind
			local from_block = previous_action_kind == "block_aim" or previous_action_kind == "block"

			if from_block then
				return "reload"
			else
				return "reload"
			end
		end,
		state_transitions = {
			cock_weapon = 2.467,
			eject_mag = 2.967,
			fit_new_mag = 0.967,
		},
		functionality = {
			refill_ammunition = 2.967,
			remove_ammunition = 0.967,
		},
	},
	fit_new_mag = {
		show_magazine_ammo_time = 1,
		time = 2.5,
		anim_1p = function (condition_func_params)
			local weapon_action_component = condition_func_params.weapon_action_component
			local weapon_extension = condition_func_params.weapon_extension

			if not weapon_extension then
				return "reload_middle"
			end

			local weapon_template = weapon_extension:weapon_template()

			if not weapon_template then
				return "reload_middle"
			end

			local previous_action_name, previous_action_settings = Action.previous_action(weapon_action_component, weapon_template)

			if not previous_action_name then
				return "reload_middle"
			end

			local previous_action_kind = previous_action_settings.kind
			local from_block = previous_action_kind == "block_aiming" or previous_action_kind == "block" or previous_action_kind == "block_unaim"

			if from_block then
				return "reload_middle_from_block"
			else
				return "reload_middle"
			end
		end,
		state_transitions = {
			cock_weapon = 0.967,
			eject_mag = 1.533,
		},
		functionality = {
			refill_ammunition = 1.533,
		},
	},
	cock_weapon = {
		show_magazine_ammo_time = 0,
		time = 1.5,
		anim_1p = function (condition_func_params)
			local weapon_action_component = condition_func_params.weapon_action_component
			local weapon_extension = condition_func_params.weapon_extension

			if not weapon_extension then
				return "reload_end"
			end

			local weapon_template = weapon_extension:weapon_template()

			if not weapon_template then
				return "reload_end"
			end

			local previous_action_name, previous_action_settings = Action.previous_action(weapon_action_component, weapon_template)

			if not previous_action_name then
				return "reload_end"
			end

			local previous_action_kind = previous_action_settings.kind
			local from_block = previous_action_kind == "block_aiming" or previous_action_kind == "block"

			if from_block then
				return "reload_end_from_block"
			else
				return "reload_end"
			end
		end,
		state_transitions = {
			eject_mag = 0.533,
		},
		functionality = {
			refill_ammunition = 0.533,
		},
	},
}

return reload_template
