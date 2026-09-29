-- chunkname: @scripts/ui/views/live_events_view/live_event_torment_progress_view/live_event_torment_progress_view.lua

require("scripts/ui/views/live_events_view/live_event_track_progress_view/live_event_track_progress_view")

local LiveEventTormentProgressViewContentBlueprints = require("scripts/ui/views/live_events_view/live_event_torment_progress_view/live_event_torment_progress_view_content_blueprints")
local LiveEventTormentProgressViewDefinitions = require("scripts/ui/views/live_events_view/live_event_torment_progress_view/live_event_torment_progress_view_definitions")
local LiveEventTormentProgressView = class("LiveEventTormentProgressView", "LiveEventTrackProgressView")

LiveEventTormentProgressView.open = function (context)
	Managers.ui:open_view("live_event_torment_progress_view", nil, false, nil, nil, context, nil)
end

LiveEventTormentProgressView.init = function (self, settings, context)
	local config = {
		event_name = "torment_global-2026",
		global_stat = "live_event_torment_witch_damage_dealt",
		global_stat_category = "lw-mb",
		global_track = "torment_global-2026",
		locked_entry_loc_key = "loc_skulls_guns_progress_view_entry_locked",
		mail_category = "track_reward",
		max_interpolation_time = 67,
		definitions = LiveEventTormentProgressViewDefinitions,
		content_blueprints = LiveEventTormentProgressViewContentBlueprints,
		grid = {
			column_count = 4,
			row_count = 2,
		},
	}

	LiveEventTormentProgressView.super.init(self, config, settings, context)
end

return LiveEventTormentProgressView
