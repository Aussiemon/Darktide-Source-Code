-- chunkname: @scripts/settings/smart_tag/smart_tag_settings.lua

local CompanionVisualLoadout = require("scripts/utilities/companion_visual_loadout")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local FixedFrame = require("scripts/utilities/fixed_frame")
local MinionPerception = require("scripts/utilities/minion_perception")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local Vo = require("scripts/utilities/vo")
local VoQueryConstants = require("scripts/settings/dialogue/vo_query_constants")
local vo_concepts = VoQueryConstants.concepts
local vo_trigger_ids = VoQueryConstants.trigger_ids
local groups = {
	enemy = {
		limit = 1,
	},
	object = {
		limit = 4,
	},
	health_station = {
		limit = 1,
	},
	location_ping = {
		limit = 1,
	},
	location_threat = {
		limit = 1,
	},
	location_attention = {
		limit = 1,
	},
}
local replies = {
	ok = {
		description = "loc_reply_smart_tag_ok",
		voice_tag_concept = vo_concepts.on_demand_com_wheel,
		voice_tag_id = vo_trigger_ids.com_wheel_vo_yes,
	},
	dibs = {
		description = "loc_reply_smart_tag_dibs",
		voice_tag_concept = vo_concepts.on_demand_com_wheel,
		voice_tag_id = vo_trigger_ids.com_wheel_vo_need_that,
	},
	follow_you = {
		description = "loc_reply_smart_tag_follow",
		voice_tag_concept = vo_concepts.on_demand_com_wheel,
		voice_tag_id = vo_trigger_ids.com_wheel_vo_follow_you,
	},
}
local templates = {
	location_ping = {
		display_name = "loc_smart_tag_type_location",
		group = "location_ping",
		is_cancelable = true,
		lifetime = 60,
		marker_type = "location_ping",
		sound_enter_tagger = UISoundEvents.smart_tag_location_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_location_default_enter_others,
		sound_exit_tagger = UISoundEvents.smart_tag_location_default_exit,
		sound_exit_others = UISoundEvents.smart_tag_location_default_exit,
		voice_tag_concept = vo_concepts.on_demand_com_wheel,
		voice_tag_id = vo_trigger_ids.com_wheel_vo_lets_go_this_way,
		replies = {
			replies.follow_you,
		},
	},
	location_threat = {
		display_name = "loc_smart_tag_type_threat",
		group = "location_threat",
		is_cancelable = true,
		lifetime = 30,
		marker_type = "location_threat",
		sound_enter_tagger = UISoundEvents.smart_tag_location_threat_enter,
		sound_enter_others = UISoundEvents.smart_tag_location_threat_enter_others,
		voice_tag_concept = vo_concepts.on_demand_com_wheel,
		voice_tag_id = vo_trigger_ids.com_wheel_vo_enemy_over_here,
		replies = {
			replies.ok,
		},
	},
	location_attention = {
		display_name = "loc_smart_tag_type_attention",
		group = "location_attention",
		is_cancelable = true,
		lifetime = 30,
		marker_type = "location_attention",
		sound_enter_tagger = UISoundEvents.smart_tag_location_attention_enter,
		sound_enter_others = UISoundEvents.smart_tag_location_attention_enter_others,
		voice_tag_concept = vo_concepts.on_demand_com_wheel,
		voice_tag_id = vo_trigger_ids.com_wheel_vo_over_here,
		replies = {
			replies.ok,
		},
	},
	small_clip_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_ammo,
	},
	large_clip_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_ammo,
	},
	syringe_corruption_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_stimm_health,
	},
	syringe_ability_boost_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_stimm_concentration,
	},
	syringe_power_boost_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_stimm_power,
	},
	syringe_speed_boost_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_stimm_speed,
	},
	small_grenade_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_small_grenade,
	},
	side_mission_consumable_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_side_mission_consumable,
	},
	side_mission_grimoire_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_side_mission_grimoire,
	},
	side_mission_tome_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_side_mission_tome,
	},
	side_mission_communication_device_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_side_mission_communication_device,
	},
	luggable_battery_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.ok,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_battery,
	},
	luggable_container_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.ok,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_container,
	},
	luggable_control_rod_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.ok,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_control_rod,
	},
	pocketable_medical_crate_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_medical_crate,
	},
	pocketable_ammo_cache_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_deployed_ammo_crate,
	},
	deployed_medical_crate_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		replies = {
			replies.ok,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_deployed_medical_crate,
	},
	deployed_ammo_cache_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		replies = {
			replies.ok,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_deployed_ammo_crate,
	},
	small_metal_pickup_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.ok,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_forge_metal,
	},
	large_metal_pickup_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.ok,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_forge_metal,
	},
	small_platinum_pickup_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.ok,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_platinum,
	},
	large_platinum_pickup_over_here = {
		group = "object",
		is_cancelable = true,
		lifetime = 10,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.ok,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_pickup_platinum,
	},
	health_station_without_battery_over_here = {
		group = "health_station",
		is_cancelable = true,
		lifetime = 10,
		replies = {
			replies.ok,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_station_health_without_battery,
	},
	health_station_over_here = {
		group = "health_station",
		is_cancelable = true,
		lifetime = 10,
		replies = {
			replies.dibs,
		},
		voice_tag_concept = vo_concepts.on_demand_vo_tag_item,
		voice_tag_id = vo_trigger_ids.smart_tag_vo_station_health,
	},
	enemy_over_here = {
		display_name = "loc_smart_tag_type_threat",
		group = "enemy",
		lifetime = 10,
		marker_type = "unit_threat",
		target_unit_outline = "smart_tagged_enemy",
		voice_tag_concept = vo_concepts.on_demand_vo_tag_enemy,
		sound_enter_tagger = UISoundEvents.smart_tag_location_threat_enter,
		sound_enter_others = UISoundEvents.smart_tag_location_threat_enter_others,
		replies = {
			replies.ok,
		},
		start = function (tag, tagger_unit)
			local breed = tag:breed()

			if breed.smart_tag_breed_aggroed_context then
				local tag_unit = tag:target_unit()
				local game_session = Managers.state.game_session:game_session()
				local game_object_id = Managers.state.unit_spawner:game_object_id(tag_unit)
				local target_unit = MinionPerception.target_unit(game_session, game_object_id)
				local wanted_target_unit_outline = tag:target_unit_outline()
				local current_target_unit_outline = wanted_target_unit_outline

				if not target_unit then
					wanted_target_unit_outline = "smart_tagged_enemy_passive"
				end

				if wanted_target_unit_outline ~= current_target_unit_outline then
					tag:set_target_unit_outline(wanted_target_unit_outline)
				end
			end
		end,
		update = function (tag)
			local breed = tag:breed()

			if breed.smart_tag_breed_aggroed_context then
				local tag_unit = tag:target_unit()
				local game_session = Managers.state.game_session:game_session()
				local game_object_id = Managers.state.unit_spawner:game_object_id(tag_unit)
				local target_unit = MinionPerception.target_unit(game_session, game_object_id)
				local wanted_target_unit_outline = tag:target_unit_outline()
				local current_target_unit_outline = wanted_target_unit_outline

				if target_unit then
					wanted_target_unit_outline = "smart_tagged_enemy"
				end

				if wanted_target_unit_outline ~= current_target_unit_outline then
					Managers.event:trigger("event_smart_tag_removed", tag)
					tag:set_target_unit_outline(wanted_target_unit_outline)
					Managers.event:trigger("event_smart_tag_created", tag)
				end
			end
		end,
	},
	enemy_over_here_veteran = {
		can_override = true,
		display_name = "loc_smart_tag_type_threat",
		group = "enemy",
		lifetime = 25,
		marker_type = "unit_threat_veteran",
		target_unit_outline = "veteran_smart_tag",
		voice_tag_concept = vo_concepts.on_demand_vo_tag_enemy,
		sound_enter_tagger = UISoundEvents.smart_tag_location_threat_enter,
		sound_enter_others = UISoundEvents.smart_tag_location_threat_enter_others,
		replies = {
			replies.ok,
		},
		start = function (tag, tagger_unit)
			local breed = tag:breed()

			if breed.smart_tag_breed_aggroed_context then
				local tag_unit = tag:target_unit()
				local game_session = Managers.state.game_session:game_session()
				local game_object_id = Managers.state.unit_spawner:game_object_id(tag_unit)
				local target_unit = MinionPerception.target_unit(game_session, game_object_id)
				local wanted_target_unit_outline = tag:target_unit_outline()
				local current_target_unit_outline = wanted_target_unit_outline

				if not target_unit then
					wanted_target_unit_outline = "smart_tagged_enemy_passive"
				end

				if wanted_target_unit_outline ~= current_target_unit_outline then
					tag:set_target_unit_outline(wanted_target_unit_outline)
				end
			end
		end,
		update = function (tag)
			local breed = tag:breed()

			if breed.smart_tag_breed_aggroed_context then
				local tag_unit = tag:target_unit()
				local game_session = Managers.state.game_session:game_session()
				local game_object_id = Managers.state.unit_spawner:game_object_id(tag_unit)
				local target_unit = MinionPerception.target_unit(game_session, game_object_id)
				local wanted_target_unit_outline = tag:target_unit_outline()
				local current_target_unit_outline = wanted_target_unit_outline

				if target_unit then
					wanted_target_unit_outline = "veteran_smart_tag"
				end

				if wanted_target_unit_outline ~= current_target_unit_outline then
					Managers.event:trigger("event_smart_tag_removed", tag)
					tag:set_target_unit_outline(wanted_target_unit_outline)
					Managers.event:trigger("event_smart_tag_created", tag)
				end
			end
		end,
	},
	enemy_companion_target = {
		can_override = true,
		display_name = "loc_smart_tag_type_threat",
		group = "enemy",
		lifetime = 25,
		marker_type = "unit_threat_adamant",
		target_unit_outline = "adamant_smart_tag",
		voice_tag_concept = vo_concepts.on_demand_vo_tag_enemy,
		sound_enter_tagger = UISoundEvents.smart_tag_location_threat_enter,
		sound_enter_others = UISoundEvents.smart_tag_location_threat_enter_others,
		replies = {
			replies.ok,
		},
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
					local companion_unit = companion_spawner_extension:companion_unit()

					if not companion_unit then
						return
					end

					local fx_system = Managers.state.extension:system("fx_system")

					if not fx_system:has_running_template_of_name(companion_unit, EffectTemplates.companion_dog_bark.name) then
						local template_effect_id = fx_system:start_template_effect(EffectTemplates.companion_dog_bark, companion_unit)

						tag.template_effect_id = template_effect_id
					end
				end
			end
		end,
		stop = function (tag)
			if not tag._is_server or not tag.template_effect_id then
				return
			end

			local companion_spawner_extension = ScriptUnit.has_extension(tag:tagger_unit(), "companion_spawner_system")
			local companion_unit = companion_spawner_extension and companion_spawner_extension:companion_unit()

			if not companion_unit then
				return
			end

			local fx_system = Managers.state.extension:system("fx_system")

			if fx_system:has_running_template_of_name(companion_unit, EffectTemplates.companion_dog_bark.name) then
				fx_system:stop_template_effect(tag.template_effect_id)

				tag.template_effect_id = nil
			end
		end,
	},
}

for name, template in pairs(templates) do
	template.name = name
end

for name, reply in pairs(replies) do
	reply.name = name
end

local smart_tag_settings = {
	groups = groups,
	replies = replies,
	templates = templates,
}

return settings("SmartTagSettings", smart_tag_settings)
