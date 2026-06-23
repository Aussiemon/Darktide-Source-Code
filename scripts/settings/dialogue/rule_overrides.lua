-- chunkname: @scripts/settings/dialogue/rule_overrides.lua

local RuleOverrides = {}

RuleOverrides.override_rules = {
	{
		chance_modifier = "binharic",
		class_requirement = "cryptic",
		name = "binharic_long_aggressive",
		override_chance = 0.15,
		rules_to_override = {
			"com_wheel_vo_for_the_emperor",
			"cryptic_ability_01_a",
			"cryptic_ability_02_a",
			"cryptic_ability_03_a",
			"cryptic_blitz_01_a",
			"cryptic_start_revive_cryptic",
			"event_kill_target_heavy_damage_a",
			"friendly_fire_from_acryptic_to_cryptic",
			"response_for_acryptic_seen_killstreak_cryptic",
			"response_for_cryptic_seen_killstreak_cryptic",
			"response_for_heard_horde_vector",
			"response_for_info_incoming_enemies",
			"response_for_seen_netgunner_flee",
			"seen_enemy_group_assaulting",
			"surrounded_response",
		},
	},
	{
		chance_modifier = "binharic",
		class_requirement = "cryptic",
		name = "binharic_long_hurt",
		override_chance = 0.15,
		rules_to_override = {
			"calling_for_help",
			"combat_monster_release_a",
			"critical_health",
			"knocked_down_2",
			"knocked_down_3",
			"ledge_hanging",
			"pinned_by_enemies",
			"response_for_acryptic_start_revive_cryptic",
			"response_for_cryptic_start_revive_cryptic",
			"surrounded",
		},
	},
}

RuleOverrides.override_chance = function (chosen_override_rule, user_contexts)
	local chance = chosen_override_rule.override_chance
	local chance_modifier = chosen_override_rule.chance_modifier

	if chance_modifier == "binharic" then
		local health = user_contexts.health
		local enemies_close = user_contexts.enemies_close
		local threat_level = user_contexts.threat_level

		if threat_level == "high" then
			chance = chance * 1.5
		end

		local enemies_close_multiplier = 0.1

		chance = math.max(chance, enemies_close * enemies_close_multiplier * chance)
		chance = math.clamp01(chance * (2 - health))
		chance = chance * 0.75
	end

	return chance
end

RuleOverrides.should_override = function (rule_name, user_contexts)
	local override_rules = RuleOverrides.override_rules
	local chosen_override_rule
	local user_class = user_contexts.class_name

	for i, settings in ipairs(override_rules) do
		if settings.class_requirement == user_class then
			local rules_to_override = settings.rules_to_override

			for j, value in ipairs(rules_to_override) do
				if rule_name == value then
					chosen_override_rule = override_rules[i]

					break
				end
			end

			if chosen_override_rule then
				break
			end
		end
	end

	if not chosen_override_rule then
		return
	end

	local chance = RuleOverrides.override_chance(chosen_override_rule, user_contexts)
	local random = math.random()

	if random < chance then
		return chosen_override_rule.name
	end
end

return RuleOverrides
