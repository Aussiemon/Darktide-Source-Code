local boss_patrols = {}

local function _create_boss_patrol_entry(path)
	local boss_patrol = require(path)
	local name = boss_patrol.name
	boss_patrols[name] = boss_patrol
end

_create_boss_patrol_entry("scripts/managers/pacing/monster_pacing/templates/renegade_boss_patrols")
_create_boss_patrol_entry("scripts/managers/pacing/monster_pacing/templates/cultist_boss_patrols")

return settings("BossPatrols", boss_patrols)
