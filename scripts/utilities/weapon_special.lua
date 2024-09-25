-- chunkname: @scripts/utilities/weapon_special.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buff_types = BuffSettings.stat_buffs
local WeaponSpecial = {}

WeaponSpecial.update_active = function (t, tweak_data, inventory_slot_component, buff_extension, input_extension, weapon_extension)
	local stat_buffs = buff_extension:stat_buffs()
	local active_duration = tweak_data.active_duration
	local was_special_active = inventory_slot_component.special_active

	if active_duration then
		local special_active_start_t = inventory_slot_component.special_active_start_t
		local end_t = special_active_start_t + active_duration

		if was_special_active and end_t <= t then
			weapon_extension:set_wielded_weapon_weapon_special_active(t, false, "active_duration_end")
		end
	end

	local num_activations = tweak_data.num_activations and tweak_data.num_activations + stat_buffs[stat_buff_types.weapon_special_max_activations]
	local current_num_activations = inventory_slot_component.num_special_charges

	if was_special_active and num_activations and num_activations <= current_num_activations then
		weapon_extension:set_wielded_weapon_weapon_special_active(t, false, "num_activations")
	end
end

return WeaponSpecial
