local WeaponMovementStateSettings = require("scripts/settings/equipment/weapon_movement_state_settings")
local weapon_movement_states = WeaponMovementStateSettings.weapon_movement_states

local function recoil_template_test(name, template)
	for _, movement_state in pairs(weapon_movement_states) do
		local move_state_settings = template[movement_state]

		fassert(move_state_settings.rise_duration, "Recoil template [\"%s\"] has no rise_duration setting defined!", name)
		fassert(move_state_settings.rise_duration > 0, "rise_duration for recoil template [\"%s\"] must be larger that 0!", name)
		fassert(move_state_settings.rise, "Recoil template [\"%s\"] has no rise settings table defined!", name)
		fassert(#move_state_settings.rise > 0, "Recoil template [\"%s\"] has no entries defined for rise!", name)
		fassert(move_state_settings.decay, "Recoil template [\"%s\"] has no decay settings table defined!", name)
		fassert(move_state_settings.decay.shooting, "decay for recoil template [\"%s\"] has no shooting setting defined!", name)
		fassert(move_state_settings.decay.idle, "decay for recoil template [\"%s\"] has no idle setting defined!", name)
		fassert(move_state_settings.new_influence_percent, "Recoil template [\"%s\"] has no new_influence_percent setting defined!", name)

		local offset_range = move_state_settings.offset_range
		local offset = move_state_settings.offset

		if offset_range then
			fassert(#move_state_settings.offset_range > 0, "Recoil template [\"%s\"] has no entries defined for offset_range!", name)
		elseif offset then
			fassert(#move_state_settings.offset > 0, "Recoil template [\"%s\"] has no entries defined for offset!", name)
			fassert(move_state_settings.offset_random_range, "Recoil template [\"%s\"] has no offset_random_range table defined!", name)
		else
			ferror("Recoil template [%q] has neither offset_range nor offset table defined!", name)
		end

		if offset_range then
			for i, offset_range_entry in ipairs(move_state_settings.offset_range) do
				fassert(offset_range_entry.pitch, "offset_range entry #%i for recoil template [\"%s\"] has no pitch setting defined!", i, name)
				fassert(offset_range_entry.yaw, "offset_range entry #%i for recoil template [\"%s\"] has no yaw setting defined!", i, name)
				fassert(offset_range_entry.pitch[1], "offset_range entry #%i for recoil template [\"%s\"] has no lower pitch limit defined!", i, name)
				fassert(offset_range_entry.pitch[2], "offset_range entry #%i for recoil template [\"%s\"] has no upper pitch limit defined!", i, name)
				fassert(offset_range_entry.yaw[1], "offset_range entry #%i for recoil template [\"%s\"] has no lower yaw limit defined!", i, name)
				fassert(offset_range_entry.yaw[2], "offset_range entry #%i for recoil template [\"%s\"] has no upper yaw limit defined!", i, name)
				fassert(offset_range_entry.pitch[1] <= offset_range_entry.pitch[2], "first value of pitch offset_range entry #%i for recoil template [\"%s\"] must be less or equal to second value!", i, name)
				fassert(offset_range_entry.yaw[1] <= offset_range_entry.yaw[2], "first value of yaw offset_range entry #%i for recoil template [\"%s\"] must be less or equal to second value!", i, name)
			end
		else
			local offset_random_range = move_state_settings.offset_random_range

			for i, offset_entry in ipairs(offset) do
				fassert(offset_entry.pitch, "offset entry #%i for recoil template [%q] has no pitch defined!", i, name)
				fassert(offset_entry.yaw, "offset entry #%i for recoil template [%q] has no yaw defined!", i, name)

				local random_range_entry = offset_random_range[i]

				fassert(random_range_entry, "missing offset_random_range entry for #%i for recoil template [%q]", i, name)
				fassert(random_range_entry.pitch, "offset_random_range entry #%i for recoil template [%q] has no pitch defined!", i, name)
				fassert(random_range_entry.yaw, "offset_random_range entry #%i for recoil template [%q] has no yaw defined!", i, name)
			end
		end
	end
end

return recoil_template_test
