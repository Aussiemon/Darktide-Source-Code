local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local Vo = require("scripts/utilities/vo")

local function _unit_by_voice_profile(voice_profile)
	local voice_over_spawn_manager = Managers.state.voice_over_spawn
	local unit = voice_over_spawn_manager:voice_over_unit(voice_profile)

	return unit
end

local DialogueSystemTestify = {
	all_dialogue_sound_events = function (dialogue_extension, _)
		local vo_sources = dialogue_extension._vo_sources_cache._vo_sources
		local sound_events = {}

		for _, sound_event_types in pairs(vo_sources) do
			for _, sound_event_type in pairs(sound_event_types) do
				local events_of_type = sound_event_type.sound_events

				for _, sound_event in pairs(events_of_type) do
					table.insert(sound_events, sound_event)
				end
			end
		end

		return sound_events
	end,
	all_wwise_voices = function (_, _)
		local voices = {}

		for _, breed in pairs(DialogueBreedSettings) do
			local wwise_voices = (type(breed) ~= "function" and breed.wwise_voices) or nil

			if wwise_voices ~= nil then
				for _, voice in pairs(wwise_voices) do
					table.insert(voices, voice)
				end
			end
		end

		voices = table.unique_array_values(voices)

		return voices
	end,
	dialogue_extension = function (unit, _)
		local dialogue_extension = ScriptUnit.has_extension(unit, "dialogue_system")

		return dialogue_extension
	end,
	play_dialogue_event = function (vo_settings, _)
		local dialogue_extension = vo_settings.dialogue_extension
		local event = vo_settings.event

		dialogue_extension:play_event(event)
	end,
	set_vo_profile = function (vo_settings, _)
		local dialogue_extension = vo_settings.dialogue_extension
		local voice = vo_settings.voice

		dialogue_extension:set_vo_profile(voice)
	end,
	trigger_mission_giver_conversation_starter = function (mission_giver_conversation_starter_data, dialogue_system)
		local trigger_id = mission_giver_conversation_starter_data.trigger_id
		local voice_profile = mission_giver_conversation_starter_data.voice_profile
		local unit = _unit_by_voice_profile(voice_profile)

		Log.info("Testify", "Triggering player environmental story vo %s", trigger_id)
		Vo.mission_giver_conversation_starter(unit, trigger_id)
	end,
	trigger_vo_on_demand = function (vo_on_demand_starter_data, dialogue_system)
		local vo_concept = vo_on_demand_starter_data.vo_concept
		local trigger_id = vo_on_demand_starter_data.trigger_id
		local local_player = Managers.player:local_player(1)
		local local_player_unit = local_player.player_unit

		Log.info("Testify", "Triggering on demand VO:  %s, of %s cateogry", trigger_id, vo_concept)
		Vo.on_demand_vo_event(local_player_unit, vo_concept, trigger_id)
	end,
	trigger_vo_query_faction_look_at = function (look_at_data, dialogue_system)
		local look_at_tag = look_at_data.look_at_tag
		local distance = look_at_data.distance
		local faction = look_at_data.faction
		local faction_event = "look_at"
		local unit = dialogue_system:random_player()
		local dialogue_extension = ScriptUnit.has_extension(unit, "dialogue_system")

		Log.info("Testify", "Faction %s looking at tag %s at distance %s", faction, look_at_tag, distance)
		Vo.faction_look_at_event(dialogue_extension, faction_event, faction, look_at_tag, distance)
	end,
	trigger_vo_query_mission_brief = function (mission_brief_data, _)
		local mission_brief_starter_line = mission_brief_data.mission_brief_starter_line
		local voice_profile = mission_brief_data.voice_profile
		local unit = _unit_by_voice_profile(voice_profile)

		Log.info("Testify", "Triggering Mission brief line %s with voice profile %s", mission_brief_starter_line, voice_profile)
		Vo.mission_giver_mission_brief_event(unit, mission_brief_starter_line)
	end,
	trigger_vo_query_mission_giver_mission_info = function (mission_giver_data, _)
		local trigger_id = mission_giver_data.trigger_id
		local voice_profile = mission_giver_data.voice_profile
		local unit = _unit_by_voice_profile(voice_profile)

		Vo.mission_giver_mission_info(unit, trigger_id)
	end,
	trigger_vo_query_player_environmental_story_vo = function (environmental_story_data, dialogue_system)
		local trigger_id = environmental_story_data.trigger_id
		local unit = dialogue_system:random_player()

		Log.info("Testify", "Triggering player environmental story vo %s", trigger_id)
		Vo.environmental_story_vo_event(unit, trigger_id)
	end,
	trigger_vo_query_player_generic_vo = function (player_generic_mission_vo_data, dialogue_system)
		local trigger_id = player_generic_mission_vo_data.trigger_id
		local unit = dialogue_system:random_player()

		Log.info("Testify", "Triggering player generic vo %s", trigger_id)
		Vo.generic_mission_vo_event(unit, trigger_id)
	end,
	trigger_vo_query_player_look_at = function (look_at_data, dialogue_system)
		local look_at_tag = look_at_data.look_at_tag
		local distance = look_at_data.distance
		local unit = dialogue_system:random_player()
		local dialogue_extension = ScriptUnit.has_extension(unit, "dialogue_system")

		Log.info("Testify", "Looking at tag %s at distance %s", look_at_tag, distance)
		Vo.look_at_event(dialogue_extension, look_at_tag, distance)
	end,
	wait_for_dialogue_played = function (_, dialogue_system)
		if dialogue_system:is_dialogue_playing() then
			return Testify.RETRY
		end
	end,
	wait_for_dialogue_playing = function (start_time, dialogue_system)
		local SOUND_TIMEOUT = 5

		if SOUND_TIMEOUT < os.clock() - start_time then
			Log.error("Testify", "The triggered dialogue has not started to play after %ss. ", SOUND_TIMEOUT)

			return false
		elseif dialogue_system:is_dialogue_playing() then
			return true
		else
			return Testify.RETRY
		end
	end
}

return DialogueSystemTestify
