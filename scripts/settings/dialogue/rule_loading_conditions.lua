-- chunkname: @scripts/settings/dialogue/rule_loading_conditions.lua

local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")
local RuleLoadingConditions = {}

local function _player_voices()
	local player_voices = {}
	local players = Managers.player:players()

	for _, player in pairs(players) do
		local profile = player:profile()
		local selected_voice = profile.selected_voice

		player_voices[#player_voices + 1] = selected_voice
	end

	return player_voices
end

local function _players_with_voice_profile(voice_profile)
	local voice_players = {}
	local players = Managers.player:players()

	for _, player in pairs(players) do
		local profile = player:profile()
		local selected_voice = profile.selected_voice

		if selected_voice == voice_profile then
			voice_players[#voice_players + 1] = player
		end
	end

	return voice_players
end

local function _has_talent(talent, optional_voice_profile)
	local voice_players = optional_voice_profile and _players_with_voice_profile(optional_voice_profile) or Managers.player:players()

	for _, player in pairs(voice_players) do
		local profile = player:profile()
		local talents = profile.talents

		if talents[talent] then
			return true
		end
	end

	return false
end

local function _all_completed_journey_step(journey_step)
	local human_players = Managers.player:human_players()

	for _, player in pairs(human_players) do
		local profile = player:profile()
		local step_completed = profile.narrative and profile.narrative.campaigns and profile.narrative.campaigns[journey_step]

		if not step_completed then
			return false
		end
	end

	return true
end

local function _all_players_at_least_level(level_requirement)
	local human_players = Managers.player:human_players()

	for _, player in pairs(human_players) do
		local profile = player:profile()
		local player_level = profile.current_level

		if player_level < level_requirement then
			return false
		end
	end

	return true
end

RuleLoadingConditions.conversations_core = {
	exclude_conditions = {
		all_max_level = function ()
			return _all_players_at_least_level(30)
		end,
	},
	all_max_level = {
		"lore",
		"conversation_explicator",
		"conversation_pilot",
		"conversation_sergeant",
		"conversation_tech_priest",
		"conversation_zealot",
	},
}
RuleLoadingConditions.adamant_female_a = {
	exclude_conditions = {
		all_adamant_not_has_dog = function ()
			return _has_talent("adamant_disable_companion")
		end,
		not_has_dog = function ()
			return _has_talent("adamant_disable_companion", "adamant_female_a")
		end,
	},
	all_adamant_not_has_dog = {
		"adamant_to_adamant_bonding_conversation_13",
		"adamant_to_adamant_bonding_conversation_19",
		"adamant_to_adamant_bonding_conversation_39",
	},
	not_has_dog = {
		"adamant_female_a_ogryn_bonding_conversation_13",
		"adamant_female_a_psyker_bonding_conversation_32",
		"adamant_female_a_veteran_bonding_conversation_24",
		"adamant_female_a_zealot_bonding_conversation_06",
		"adamant_female_a_zealot_bonding_conversation_13",
		"adamant_female_a_zealot_bonding_conversation_28",
		"adamant_female_a_zealot_bonding_conversation_36",
		"adamant_female_a_zealot_bonding_conversation_48",
		"adamant_female_a_zealot_bonding_conversation_57",
	},
	pre_habs = {
		"adamant_female_a_ogryn_bonding_conversation_04",
	},
}
RuleLoadingConditions.adamant_female_b = {
	exclude_conditions = {
		not_has_dog = function ()
			return _has_talent("adamant_disable_companion", "adamant_female_b")
		end,
	},
	not_has_dog = {
		"adamant_female_b_ogryn_bonding_conversation_10",
		"adamant_female_b_psyker_bonding_conversation_09",
		"adamant_female_b_psyker_bonding_conversation_19",
		"adamant_female_b_psyker_bonding_conversation_20",
		"adamant_female_b_psyker_bonding_conversation_30",
		"adamant_female_b_psyker_bonding_conversation_39",
		"adamant_female_b_psyker_bonding_conversation_57",
		"adamant_female_b_veteran_bonding_conversation_34",
		"adamant_female_b_zealot_bonding_conversation_30",
	},
}
RuleLoadingConditions.adamant_female_c = {
	exclude_conditions = {
		all_adamant_not_has_dog = function ()
			return _has_talent("adamant_disable_companion")
		end,
		not_has_dog = function ()
			return _has_talent("adamant_disable_companion", "adamant_female_c")
		end,
	},
	all_adamant_not_has_dog = {
		"adamant_to_adamant_bonding_conversation_114",
	},
	not_has_dog = {
		"adamant_female_c_ogryn_bonding_conversation_05",
		"adamant_female_c_psyker_bonding_conversation_25",
		"adamant_female_c_zealot_bonding_conversation_19",
		"adamant_female_c_zealot_bonding_conversation_38",
		"adamant_female_c_zealot_bonding_conversation_42",
		"adamant_female_c_zealot_bonding_conversation_45",
		"adamant_female_c_zealot_bonding_conversation_48",
		"adamant_female_c_zealot_bonding_conversation_55",
	},
}
RuleLoadingConditions.adamant_male_a = {
	exclude_conditions = {
		all_adamant_not_has_dog = function ()
			return _has_talent("adamant_disable_companion")
		end,
		not_has_dog = function ()
			return _has_talent("adamant_disable_companion", "adamant_male_a")
		end,
	},
	all_adamant_not_has_dog = {
		"adamant_to_adamant_bonding_conversation_02",
		"adamant_to_adamant_bonding_conversation_06",
		"adamant_to_adamant_bonding_conversation_08",
		"adamant_to_adamant_bonding_conversation_25",
		"adamant_to_adamant_bonding_conversation_33",
	},
	not_has_dog = {
		"adamant_male_a_ogryn_bonding_conversation_05",
		"adamant_male_a_ogryn_bonding_conversation_07",
		"adamant_male_a_ogryn_bonding_conversation_11",
		"adamant_male_a_ogryn_bonding_conversation_18",
		"adamant_male_a_ogryn_bonding_conversation_20",
		"adamant_male_a_ogryn_bonding_conversation_32",
		"adamant_male_a_psyker_bonding_conversation_01",
		"adamant_male_a_psyker_bonding_conversation_18",
		"adamant_male_a_psyker_bonding_conversation_24",
		"adamant_male_a_psyker_bonding_conversation_39",
		"adamant_male_a_psyker_bonding_conversation_40",
		"adamant_male_a_psyker_bonding_conversation_43",
		"adamant_male_a_psyker_bonding_conversation_57",
		"adamant_male_a_zealot_bonding_conversation_53",
	},
}
RuleLoadingConditions.adamant_male_b = {
	exclude_conditions = {
		not_has_dog = function ()
			return _has_talent("adamant_disable_companion", "adamant_male_b")
		end,
	},
	not_has_dog = {
		"adamant_male_b_ogryn_bonding_conversation_29",
		"adamant_male_b_psyker_bonding_conversation_27",
		"adamant_male_b_psyker_bonding_conversation_36",
		"adamant_male_b_psyker_bonding_conversation_58",
		"adamant_male_b_zealot_bonding_conversation_14",
		"adamant_male_b_zealot_bonding_conversation_40",
		"adamant_male_b_zealot_bonding_conversation_47",
	},
}
RuleLoadingConditions.adamant_male_c = {
	exclude_conditions = {
		not_has_dog = function ()
			return _has_talent("adamant_disable_companion", "adamant_male_c")
		end,
	},
	not_has_dog = {
		"adamant_male_c_psyker_bonding_conversation_13",
		"adamant_male_c_psyker_bonding_conversation_60",
		"adamant_male_c_veteran_bonding_conversation_15",
		"adamant_male_c_zealot_bonding_conversation_01",
		"adamant_male_c_zealot_bonding_conversation_22",
		"adamant_male_c_zealot_bonding_conversation_33",
		"adamant_male_c_zealot_bonding_conversation_58",
	},
}
RuleLoadingConditions.ogryn_c = {
	pre_heresy = {
		"pimlico_bonding_conversation_penances",
	},
}
RuleLoadingConditions.psyker_female_a = {
	pre_core_research = {
		"pimlico_bonding_conversation_daviot_clandestium_02",
	},
	pre_twins = {
		"bonding_conversation_hammersmith_even_more_zola",
	},
}
RuleLoadingConditions.psyker_female_b = {
	pre_resurgence = {
		"pimlico_bonding_conversation_conversation",
	},
	pre_heresy = {
		"pimlico_bonding_conversation_road",
	},
	pre_twins = {
		"bonding_conversation_hammersmith_zola_steam",
	},
}
RuleLoadingConditions.psyker_female_c = {
	pre_heresy = {
		"pimlico_bonding_conversation_enemy",
		"pimlico_bonding_conversation_forever",
	},
	pre_twins = {
		"bonding_conversation_hammersmith_more_zola",
		"bonding_conversation_hammersmith_zola",
	},
}
RuleLoadingConditions.psyker_male_c = {
	pre_resurgence = {
		"pimlico_bonding_conversation_elvanfoot_hestia_01",
	},
}
RuleLoadingConditions.veteran_female_b = {
	pre_resurgence = {
		"pimlico_bonding_conversation_cumbernauld_01",
	},
}
RuleLoadingConditions.veteran_male_c = {
	pre_core_research = {
		"pimlico_bonding_conversation_daviot_moebian_steel_02",
	},
	pre_twins = {
		"bonding_conversation_hammersmith_even_more_zola_two",
	},
}
RuleLoadingConditions.zealot_female_c = {
	pre_heresy = {
		"pimlico_bonding_conversation_gareloch_01",
	},
}
RuleLoadingConditions.zealot_male_c = {
	pre_heresy = {
		"pimlico_bonding_conversation_charge",
		"adamant_female_b_zealot_bonding_conversation_29_a",
	},
}

local all_char_conditions = {
	exclude_non_loaded_voices = function ()
		return _player_voices()
	end,
	exclude_conditions = {
		pre_twins = function ()
			return not _all_completed_journey_step("journey_km_enforcer_twins")
		end,
		pre_nobles = function ()
			return not _all_completed_journey_step("journey_cm_habs")
		end,
		pre_resurgence = function ()
			return not _all_completed_journey_step("journey_fm_resurgence")
		end,
		pre_core_research = function ()
			return not _all_completed_journey_step("journey_core_research")
		end,
		pre_heresy = function ()
			return not _all_completed_journey_step("journey_km_heresy")
		end,
	},
	pre_twins = {
		"bonding_conversation_waterloo_twins",
	},
	pre_habs = {
		"oval_world_conversation_balta_nobles",
		"pimlico_bonding_conversation_balta_nobles",
	},
	pre_resurgence = {
		"bonding_conversation_waterloo_brahms",
		"oval_world_conversation_cumbernauld_brahms",
		"oval_world_conversation_elvanfoot_hestia",
		"oval_world_conversation_universal_hestia",
	},
	pre_core_research = {
		"oval_world_conversation_daviot_steel",
		"oval_world_conversation_fingal_swagger",
		"pimlico_bonding_conversation_fingal_swagger",
	},
	pre_heresy = {
		"bonding_conversation_waterloo_wolfer",
		"oval_world_conversation_gareloch",
	},
}

for voice, rule_groups in pairs(DialogueSettings.player_load_files) do
	for i = 1, #rule_groups do
		local rule_group = rule_groups[i]

		RuleLoadingConditions[rule_group] = RuleLoadingConditions[rule_group] or {}

		table.merge_recursive(RuleLoadingConditions[rule_group], all_char_conditions)
	end
end

return RuleLoadingConditions
