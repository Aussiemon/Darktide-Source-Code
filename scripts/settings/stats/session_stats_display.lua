-- chunkname: @scripts/settings/stats/session_stats_display.lua

local TextUtilities = require("scripts/utilities/ui/text")

local function _tostring(value)
	return tostring(value)
end

local function _format_time(seconds)
	return TextUtilities.format_time_span_localized(seconds, true, true)
end

local session_stat_display_settings = {
	{
		best = "max",
		display_name = "loc_stat_display_total_kills",
		private = "session_kills",
		team = "session_team_kills",
	},
	{
		best = "max",
		display_name = "loc_stat_display_damage_dealt",
		private = "session_damage_dealt",
		team = "session_team_damage_dealt",
	},
	{
		best = "max",
		display_name = "loc_stat_display_boss_damage_dealt",
		private = "session_boss_damage_dealt",
		team = "session_team_boss_damage_dealt",
	},
	{
		best = "max",
		display_name = "loc_stat_display_specials_killed",
		private = "session_special_kills",
		team = "session_team_special_kills",
	},
	{
		best = "max",
		display_name = "loc_stat_display_elites_killed",
		private = "session_elite_kills",
		team = "session_team_elite_kills",
	},
	{
		best = "max",
		display_name = "loc_stat_display_enemies_staggered",
		private = "session_enemies_staggered",
		team = "session_team_enemies_staggered",
	},
	{
		best = "max",
		display_name = "loc_stat_display_attacks_blocked",
		private = "session_attacks_blocked",
		team = "session_team_attacks_blocked",
	},
	{
		best = "max",
		display_name = "loc_stat_display_attacks_dodged",
		private = "session_attacks_dodged",
		team = "session_team_attacks_dodged",
	},
	{
		best = "max",
		display_name = "loc_stat_display_blitzes_used",
		private = "session_blitzes_used",
		team = "session_team_blitzes_used",
	},
	{
		best = "max",
		display_name = "loc_stat_display_abilities_used",
		private = "session_abilities_used",
		team = "session_team_abilities_used",
	},
	{
		best = "max",
		display_name = "loc_stat_display_headshots",
		private = "session_weakspot_kills",
		team = "session_team_weakspot_kills",
	},
	{
		best = "max",
		display_name = "loc_stat_display_saves",
		private = "session_saves",
		team = "session_team_saves",
	},
	{
		best = "max",
		display_name = "loc_stat_display_revives",
		private = "session_revives",
		team = "session_team_revives",
	},
	{
		best = "max",
		display_name = "loc_stat_display_time_in_coherency",
		private = "session_time_coherency",
		team = nil,
		format_value = _format_time,
	},
}

for i = 1, #session_stat_display_settings do
	local row = session_stat_display_settings[i]

	row.format_value = row.format_value or _tostring
end

return settings("SessionStatsDisplay", session_stat_display_settings)
