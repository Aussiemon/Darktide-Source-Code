-- chunkname: @scripts/utilities/player_talents/player_talents.lua

local PlayerTalents = {}

PlayerTalents.base_talents = function (archetype, selected_talents)
	local base_talents = archetype.base_talents
	local out_talents = {}
	local conditional_talents = {}

	for talent_name, talent_data in pairs(base_talents) do
		out_talents[talent_name] = talent_data
		conditional_talents[talent_name] = {
			tier = talent_data.tier,
			target_slot = talent_data.target_slot,
		}
	end

	local conditional_base_talents = archetype.conditional_base_talents

	if conditional_base_talents then
		if selected_talents then
			for talent_name, selection_data in pairs(selected_talents) do
				conditional_talents[talent_name] = selection_data
			end
		end

		local conditions = archetype.conditional_base_talent_funcs

		for talent_name, talent_data in pairs(conditional_base_talents) do
			local condition_func = conditions[talent_name]
			local result = condition_func(conditional_talents)

			if result then
				out_talents[talent_name] = type(result) == "table" and result or talent_data
			end
		end
	end

	return out_talents
end

local _has_target_slot_scratch = {}

PlayerTalents.add_archetype_base_talents = function (archetype, talents)
	table.clear(_has_target_slot_scratch)

	for talent_name, talent_data in pairs(talents) do
		local target_slot = talent_data.target_slot

		if target_slot then
			_has_target_slot_scratch[target_slot] = true
		end
	end

	local base_talents = PlayerTalents.base_talents(archetype, talents)

	for talent_name, base_talent_data in pairs(base_talents) do
		local apply_talent = true
		local target_slot = base_talent_data.target_slot

		if target_slot and _has_target_slot_scratch[target_slot] then
			apply_talent = false
		end

		if apply_talent then
			local talent_data = talents[talent_name] or {
				tier = 0,
			}

			talent_data.tier = talent_data.tier + base_talent_data.tier
			talent_data.target_slot = base_talent_data.target_slot
			talents[talent_name] = talent_data
		end
	end
end

return PlayerTalents
