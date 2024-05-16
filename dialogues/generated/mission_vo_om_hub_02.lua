-- chunkname: @dialogues/generated/mission_vo_om_hub_02.lua

return function ()
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "mission_vo_om_hub_02",
		name = "prologue_hub_go_chapel",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "prologue_hub_go_chapel",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"prologue_hub_go_chapel",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"prologue_hub_go_chapel",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"prologue_hub_go_chapel",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
end
