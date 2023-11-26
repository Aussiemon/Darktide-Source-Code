-- chunkname: @scripts/settings/achievements/achievement_flags.lua

local achievement_flags = table.enum("hide_progress", "prioritize_running", "allow_solo", "private_only")

return settings("AchievementFlags", achievement_flags)
