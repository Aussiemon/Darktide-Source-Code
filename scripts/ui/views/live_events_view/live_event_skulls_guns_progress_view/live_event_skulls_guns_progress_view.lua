-- chunkname: @scripts/ui/views/live_events_view/live_event_skulls_guns_progress_view/live_event_skulls_guns_progress_view.lua

require("scripts/ui/views/live_events_view/live_event_track_progress_view/live_event_track_progress_view")

local LiveEventSkullsGunsProgressViewContentBlueprints = require("scripts/ui/views/live_events_view/live_event_skulls_guns_progress_view/live_event_skulls_guns_progress_view_content_blueprints")
local LiveEventSkullsGunsProgressViewDefinitions = require("scripts/ui/views/live_events_view/live_event_skulls_guns_progress_view/live_event_skulls_guns_progress_view_definitions")
local LiveEventSkullsGunsProgressView = class("LiveEventSkullsGunsProgressView", "LiveEventTrackProgressView")

LiveEventSkullsGunsProgressView.open = function (context)
	Managers.ui:open_view("live_event_skulls_guns_progress_view", nil, false, nil, nil, context, nil)
end

LiveEventSkullsGunsProgressView.init = function (self, settings, context)
	local config = {
		event_name = "skulls_guns_global-2026",
		global_stat = "live_event_skulls_guns_recovered",
		global_stat_category = "lw-mb",
		global_track = "skulls_guns_global-2026",
		locked_entry_loc_key = "loc_skulls_guns_progress_view_entry_locked",
		mail_category = "track_reward",
		max_interpolation_time = 67,
		definitions = LiveEventSkullsGunsProgressViewDefinitions,
		content_blueprints = LiveEventSkullsGunsProgressViewContentBlueprints,
		grid = {
			column_count = 4,
			row_count = 2,
		},
	}

	LiveEventSkullsGunsProgressView.super.init(self, config, settings, context)
end

return LiveEventSkullsGunsProgressView
