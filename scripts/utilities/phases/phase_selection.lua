-- chunkname: @scripts/utilities/phases/phase_selection.lua

local PhaseSelection = {}

PhaseSelection.resolve = function (phase_template, optional_used_weapon_slot_names)
	if optional_used_weapon_slot_names == nil then
		return phase_template
	end

	local phase_selection = table.clone(phase_template)

	for combat_range, phase_data in pairs(phase_selection) do
		local entry_phase = phase_data.entry_phase
		local entry_phase_is_table = type(entry_phase) == "table"
		local phases = phase_data.phases

		for phase_name, data in pairs(phases) do
			local wanted_weapon_slot = data.wanted_weapon_slot

			if wanted_weapon_slot and not optional_used_weapon_slot_names[wanted_weapon_slot] then
				phases[phase_name] = nil

				if entry_phase_is_table then
					local phase_index = table.index_of(entry_phase, phase_name)

					table.swap_delete(entry_phase, phase_index)
				end
			end
		end
	end

	return phase_selection
end

return PhaseSelection
