local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local VOQueryConstants = require("scripts/settings/dialogue/vo_query_constants")
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
		voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
		voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_yes
	},
	dibs = {
		voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
		voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_need_that
	},
	follow_you = {
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
	health_booster_over_here = {
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
		}
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
