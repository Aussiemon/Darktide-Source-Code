local WeaponMovementStateSettings = require("scripts/settings/equipment/weapon_movement_state_settings")
local weapon_movement_states = WeaponMovementStateSettings.weapon_movement_states

local function recoil_template_test(name, template)
	for _, movement_state in pairs(weapon_movement_states) do
		local move_state_settings = template[movement_state]
		local offset_range = move_state_settings.offset_range
		local offset = move_state_settings.offset

		if offset_range then
			-- Nothing
		elseif not offset then
			ferror("Recoil template [%q] has neither offset_range nor offset table defined!", name)
		end

		if offset_range then
			for i, offset_range_entry in ipairs(move_state_settings.offset_range) do
				-- Nothing
			end
		else
			local offset_random_range = move_state_settings.offset_random_range

			for i, offset_entry in ipairs(offset) do
				local random_range_entry = offset_random_range[i]
			end
		end
	end
end

return recoil_template_test
