-- chunkname: @scripts/settings/smart_tag/double_tag/adamant_double_tag_templates.lua

local EffectTemplates = require("scripts/settings/fx/effect_templates")
local FixedFrame = require("scripts/utilities/fixed_frame")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local Vo = require("scripts/utilities/vo")
local VoQueryConstants = require("scripts/settings/dialogue/vo_query_constants")
local vo_concepts = VoQueryConstants.concepts
local templates = {
	enemy_companion_target = {
		can_override = true,
		display_name = "loc_smart_tag_type_threat",
		group = "double_tag",
		lifetime = 25,
		marker_type = "unit_threat_companion",
		target_unit_outline = "adamant_smart_tag",
		voice_tag_concept = vo_concepts.on_demand_vo_tag_enemy,
		sound_enter_tagger = UISoundEvents.smart_tag_location_threat_enter,
		sound_enter_others = UISoundEvents.smart_tag_location_threat_enter_others,
		start = function (tag, tagger_unit)
			if not tag._is_server then
				return
			end

			local t = FixedFrame.get_latest_fixed_time()

			tag.start_time = t

			local vo_tag = "ability_targeting_a"
			local currently_playing = Vo.is_currently_playing_dialogue(tagger_unit)

			if currently_playing then
				Vo.set_unit_vo_memory(tagger_unit, "user_memory", "command_triggered", "timeset")
			else
				Vo.play_combat_ability_event(tagger_unit, vo_tag)
			end
		end,
		update = function (tag)
			if not tag._is_server then
				return
			end

			local t = FixedFrame.get_latest_fixed_time()
			local time_in_tag = t - tag.start_time

			if time_in_tag >= 1 and not tag.played_sound then
				tag.played_sound = true

				local companion_spawner_extension = ScriptUnit.has_extension(tag:tagger_unit(), "companion_spawner_system")

				if companion_spawner_extension then
					local companion_units = companion_spawner_extension and companion_spawner_extension:companion_units()

					if companion_units then
						for i = 1, #companion_units do
							repeat
								local companion_unit = companion_units[i]

								if not companion_unit then
									break
								end

								local companion_tag_manager_extension = ScriptUnit.has_extension(companion_unit, "companion_tag_manager_system")

								if companion_tag_manager_extension then
									local fx_system = Managers.state.extension:system("fx_system")

									if not fx_system:has_running_template_of_name(companion_unit, EffectTemplates.companion_dog_bark.name) then
										local template_effect_id = fx_system:start_template_effect(EffectTemplates.companion_dog_bark, companion_unit)

										tag.template_effect_id = template_effect_id
									end
								end
							until true
						end
					end
				end
			end
		end,
		stop = function (tag)
			if not tag._is_server or not tag.template_effect_id then
				return
			end

			local companion_spawner_extension = ScriptUnit.has_extension(tag:tagger_unit(), "companion_spawner_system")
			local companion_units = companion_spawner_extension and companion_spawner_extension:companion_units()

			if companion_units then
				for i = 1, #companion_units do
					repeat
						local companion_unit = companion_units[i]

						if not companion_unit then
							break
						end

						local companion_tag_manager_extension = ScriptUnit.has_extension(companion_unit, "companion_tag_manager_system")

						if companion_tag_manager_extension then
							local fx_system = Managers.state.extension:system("fx_system")

							if fx_system:has_running_template_of_name(companion_unit, EffectTemplates.companion_dog_bark.name) then
								fx_system:stop_template_effect(tag.template_effect_id)

								tag.template_effect_id = nil
							end
						end
					until true
				end
			end
		end,
	},
}

return templates
