local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buff_types = BuffSettings.stat_buffs
local WeaponSpecial = {}

WeaponSpecial.update_active = function (t, tweak_data, inventory_slot_component, buff_extension, input_extension)
	local stat_buffs = buff_extension:stat_buffs()
	local active_duration = tweak_data.active_duration

	if active_duration then
		local special_active_start_t = inventory_slot_component.special_active_start_t
		local end_t = special_active_start_t + active_duration

		if t >= end_t then
			inventory_slot_component.special_active = false
			inventory_slot_component.num_special_activations = 0
		end
	end

	local num_activations = tweak_data.num_activations and tweak_data.num_activations + stat_buffs[stat_buff_types.weapon_special_max_activations]
	local current_num_activations = inventory_slot_component.num_special_activations

	if num_activations and num_activations <= current_num_activations then
		inventory_slot_component.special_active = false
		inventory_slot_component.num_special_activations = 0
	end
end

WeaponSpecial.disable = function (unit)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local wielded_slot = inventory_component.wielded_slot
	local is_wielded_slot_weapon = PlayerUnitVisualLoadout.is_slot_of_type(wielded_slot, "weapon")

	if is_wielded_slot_weapon then
		local inventory_slot_component = unit_data_extension:write_component(wielded_slot)
		inventory_slot_component.special_active = false
		inventory_slot_component.num_special_activations = 0
	end
end

return WeaponSpecial
