local ChaosDaemonhostSettings = require("scripts/settings/monster/chaos_daemonhost_settings")
local STAGES = ChaosDaemonhostSettings.stages
local ANGER_DISTANCES = ChaosDaemonhostSettings.anger_distances
local Daemonhost = {
	anger_distance_settings = function (stage)
		if stage == STAGES.passive then
			return ANGER_DISTANCES.passive
		else
			return ANGER_DISTANCES.not_passive
		end
	end
}

return Daemonhost
