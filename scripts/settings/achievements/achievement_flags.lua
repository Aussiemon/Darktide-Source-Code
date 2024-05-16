-- chunkname: @scripts/settings/achievements/achievement_flags.lua

local achievement_flags = table.enum("hide_progress", "allow_solo", "private_only", "hide_missing", "hide_from_carousel")

return settings("AchievementFlags", achievement_flags)
