-- chunkname: @scripts/settings/equipment/reload_templates/boltpistol_reload_template.lua

local reload_template = {
	name = "boltpistol",
	states = {
		"eject_mag",
		"fit_new_mag",
		"cock_weapon"
	},
	eject_mag = {
		time = 3.1,
		show_magazine_ammo_time = 0.8,
		anim_1p = function (condition_func_params)
			local inventory_slot_component = condition_func_params.inventory_slot_component

			if inventory_slot_component.current_ammunition_clip > 0 then
				return "reload_partial"
			else
				return "reload_start"
			end
		end,
		state_transitions = {
			eject_mag = 2.6,
			cock_weapon = 2,
			fit_new_mag = 0.4
		},
		functionality = {
			refill_ammunition = 2.6,
			remove_ammunition = 0.4
		}
	},
	fit_new_mag = {
		time = 2.3,
		show_magazine_ammo_time = 0.3,
		anim_1p = function (condition_func_params)
			local inventory_slot_component = condition_func_params.inventory_slot_component

			if inventory_slot_component.ammunition_at_reload_start > 0 then
				return "reload_middle_partial"
			else
				return "reload_middle"
			end
		end,
		state_transitions = {
			eject_mag = 1.8,
			cock_weapon = 1.2
		},
		functionality = {
			refill_ammunition = 1.8
		}
	},
	cock_weapon = {
		time = 1.3,
		show_magazine_ammo_time = 0,
		anim_1p = function (condition_func_params)
			local inventory_slot_component = condition_func_params.inventory_slot_component

			if inventory_slot_component.ammunition_at_reload_start > 0 then
				return "reload_end_partial"
			else
				return "reload_end_long"
			end
		end,
		state_transitions = {
			eject_mag = 0.4
		},
		functionality = {
			refill_ammunition = 0.4
		}
	}
}

return reload_template
