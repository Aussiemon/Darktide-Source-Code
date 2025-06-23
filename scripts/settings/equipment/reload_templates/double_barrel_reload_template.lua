-- chunkname: @scripts/settings/equipment/reload_templates/double_barrel_reload_template.lua

local reload_template = {
	name = "double_barrel",
	states = {
		"eject_mag",
		"eject_mag_restart",
		"fit_new_mag",
		"cock_weapon"
	},
	eject_mag = {
		time = 2.8,
		show_magazine_ammo_time = 1,
		anim_1p = function (condition_func_params)
			local inventory_slot_component = condition_func_params.inventory_slot_component

			if inventory_slot_component.current_ammunition_reserve == 1 then
				return "reload_partial"
			elseif inventory_slot_component.current_ammunition_clip > 0 then
				return "reload_partial"
			else
				return "reload_start"
			end
		end,
		state_transitions = {
			eject_mag = 1.65,
			cock_weapon = 1.3,
			fit_new_mag = 0.5
		},
		functionality = {
			refill_ammunition = 1.3
		}
	},
	eject_mag_restart = {
		anim_1p = "reload_restart",
		time = 2.8,
		show_magazine_ammo_time = 1,
		state_transitions = {
			eject_mag = 1.65,
			cock_weapon = 1.3,
			fit_new_mag = 0.5
		},
		functionality = {
			refill_ammunition = 1.3
		}
	},
	fit_new_mag = {
		time = 2.3,
		show_magazine_ammo_time = 0.3,
		anim_1p = function (condition_func_params)
			local inventory_slot_component = condition_func_params.inventory_slot_component

			if inventory_slot_component.current_ammunition_clip > 0 or inventory_slot_component.current_ammunition_reserve == 1 then
				return "reload_middle_partial"
			else
				return "reload_middle"
			end
		end,
		state_transitions = {
			eject_mag = 1.05,
			cock_weapon = 0.7
		},
		functionality = {
			refill_ammunition = 0.7
		}
	},
	cock_weapon = {
		anim_1p = "reload_end",
		time = 0.9,
		show_magazine_ammo_time = 0,
		state_transitions = {
			eject_mag = 0.3
		},
		functionality = {}
	}
}

return reload_template
