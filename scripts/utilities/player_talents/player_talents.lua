-- chunkname: @scripts/utilities/player_talents/player_talents.lua

local PlayerTalents = {}

PlayerTalents.base_talents = function (archetype, selected_talents)
	local base_talents = archetype.base_talents
	local out_talents = {}
	local conditional_talents = {}

	for talent_name, tier in pairs(base_talents) do
		out_talents[talent_name] = tier
		conditional_talents[talent_name] = tier
	end

	local conditional_base_talents = archetype.conditional_base_talents

	if conditional_base_talents then
		if selected_talents then
			for talent_name, tier in pairs(selected_talents) do
				conditional_talents[talent_name] = tier
			end
		end

		local conditions = archetype.conditional_base_talent_funcs

		for talent_name, tier in pairs(conditional_base_talents) do
			local condition_func = conditions[talent_name]

			if condition_func(conditional_talents) then
				out_talents[talent_name] = tier
			end
		end
	end

	return out_talents
end

PlayerTalents.add_archetype_base_talents = function (archetype, talents)
	local talent_definitions = archetype.talents
	local has_combat_ability, has_grenade_ability = false, false
	local combat_ability_talent, grenade_ability_talent

	for talent_name, _ in pairs(talents) do
		local talent = talent_definitions[talent_name]
		local player_ability = talent.player_ability

		if player_ability then
			local ability_type = player_ability.ability_type

			if ability_type == "combat_ability" then
				has_combat_ability = true
				combat_ability_talent = talent_name
			elseif ability_type == "grenade_ability" then
				has_grenade_ability = true
				grenade_ability_talent = talent_name
			elseif ability_type == "pocketable_ability" then
				-- Nothing
			else
				ferror("Unknown ability_type(%q) found in talent(%q) for archetype(%q)", ability_type, talent_name, archetype.name)
			end
		end
	end

	local base_talents = PlayerTalents.base_talents(archetype, talents)

	for talent_name, tier in pairs(base_talents) do
		local apply_talent = true
		local talent = talent_definitions[talent_name]
		local player_ability = talent.player_ability

		if player_ability then
			local ability_type = player_ability.ability_type

			if ability_type == "combat_ability" and has_combat_ability then
				apply_talent = false
			elseif ability_type == "grenade_ability" and has_grenade_ability then
				apply_talent = false
			end
		end

		if apply_talent then
			local prev_tier = talents[talent_name] or 0

			talents[talent_name] = prev_tier + tier
		end
	end
end

return PlayerTalents
