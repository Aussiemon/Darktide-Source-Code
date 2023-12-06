local MinionPerception = require("scripts/utilities/minion_perception")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local VOQueryConstants = require("scripts/settings/dialogue/vo_query_constants")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local special_rules = SpecialRulesSetting.special_rules
local groups = {
	enemy = {
		limit = 1
	},
	object = {
		limit = 4
	},
	health_station = {
		limit = 1
	},
	location_ping = {
		limit = 1
	},
	location_threat = {
		limit = 1
	},
	location_attention = {
		limit = 1
	}
}
local replies = {
	ok = {
		description = "loc_reply_smart_tag_ok",
		voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
		voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_yes
	},
	dibs = {
		description = "loc_reply_smart_tag_dibs",
		voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
		voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_need_that
	},
	follow_you = {
		description = "loc_reply_smart_tag_follow",
		voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
		voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_follow_you
	}
}
local templates = {
	location_ping = {
		group = "location_ping",
		display_name = "loc_smart_tag_type_location",
		marker_type = "location_ping",
		lifetime = 60,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_location_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_location_default_enter_others,
		sound_exit_tagger = UISoundEvents.smart_tag_location_default_exit,
		sound_exit_others = UISoundEvents.smart_tag_location_default_exit,
		voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
		voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_lets_go_this_way,
		replies = {
			replies.follow_you
		}
	},
	location_threat = {
		display_name = "loc_smart_tag_type_threat",
		group = "location_threat",
		marker_type = "location_threat",
		lifetime = 30,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_location_threat_enter,
		sound_enter_others = UISoundEvents.smart_tag_location_threat_enter_others,
		voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
		voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_enemy_over_here,
		replies = {
			replies.ok
		}
	},
	location_attention = {
		display_name = "loc_smart_tag_type_attention",
		group = "location_attention",
		marker_type = "location_attention",
		lifetime = 30,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_location_attention_enter,
		sound_enter_others = UISoundEvents.smart_tag_location_attention_enter_others,
		voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
		voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_over_here,
		replies = {
			replies.ok
		}
	},
	small_clip_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_ammo
	},
	large_clip_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_ammo
	},
	syringe_corruption_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_health_booster
	},
	syringe_ability_boost_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item
	},
	syringe_power_boost_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item
	},
	syringe_speed_boost_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item
	},
	small_grenade_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_small_grenade
	},
	side_mission_consumable_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_side_mission_consumable
	},
	side_mission_grimoire_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_side_mission_grimoire
	},
	side_mission_tome_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_side_mission_tome
	},
	luggable_battery_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.ok
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_battery
	},
	luggable_container_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.ok
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_container
	},
	luggable_control_rod_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.ok
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_control_rod
	},
	pocketable_medical_crate_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_medical_crate
	},
	pocketable_ammo_cache_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.dibs
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_deployed_ammo_crate
	},
	deployed_medical_crate_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		replies = {
			replies.ok
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_deployed_medical_crate
	},
	deployed_ammo_cache_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		replies = {
			replies.ok
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_deployed_ammo_crate
	},
	small_metal_pickup_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.ok
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_forge_metal
	},
	large_metal_pickup_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.ok
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_forge_metal
	},
	small_platinum_pickup_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.ok
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_platinum
	},
	large_platinum_pickup_over_here = {
		group = "object",
		lifetime = 10,
		is_cancelable = true,
		sound_enter_tagger = UISoundEvents.smart_tag_pickup_default_enter,
		sound_enter_others = UISoundEvents.smart_tag_pickup_default_enter_others,
		replies = {
			replies.ok
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_platinum
	},
	health_station_without_battery_over_here = {
		group = "health_station",
		lifetime = 10,
		is_cancelable = true,
		replies = {
			replies.ok
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_station_health_without_battery
	},
	health_station_over_here = {
		group = "health_station",
		lifetime = 10,
		is_cancelable = true,
		replies = {
			replies.dibs
		},
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
		voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_station_health
	},
	enemy_over_here = {
		display_name = "loc_smart_tag_type_threat",
		target_unit_outline = "smart_tagged_enemy",
		group = "enemy",
		marker_type = "unit_threat",
		lifetime = 10,
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_enemy,
		sound_enter_tagger = UISoundEvents.smart_tag_location_threat_enter,
		sound_enter_others = UISoundEvents.smart_tag_location_threat_enter_others,
		replies = {
			replies.ok
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
		end
	},
	enemy_over_here_veteran = {
		display_name = "loc_smart_tag_type_threat",
		target_unit_outline = "veteran_smart_tag",
		group = "enemy",
		marker_type = "unit_threat_veteran",
		lifetime = 25,
		can_override = true,
		voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_enemy,
		sound_enter_tagger = UISoundEvents.smart_tag_location_threat_enter,
		sound_enter_others = UISoundEvents.smart_tag_location_threat_enter_others,
		replies = {
			replies.ok
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
		end
	}
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
	templates = templates
}

return settings("SmartTagSettings", smart_tag_settings)
