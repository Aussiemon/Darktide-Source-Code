local PlayerTalents = {}

PlayerTalents.add_archetype_base_talents = function (archetype, talents)
	local talent_definitions = archetype.talents
	local has_combat_ability = false
	local has_grenade_ability = false
	local combat_ability_talent, grenade_ability_talent = nil

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
			else
				ferror("Unknown ability_type(%q) found in talent(%q) for archetype(%q)", ability_type, talent_name, archetype.name)
			end
		end
	end

	local base_talents = archetype.base_talents

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
