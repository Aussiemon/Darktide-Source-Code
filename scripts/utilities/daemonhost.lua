local DaemonhostSettings = require("scripts/settings/specials/daemonhost_settings")
local STAGES = DaemonhostSettings.stages
local ANGER_DISTANCES = DaemonhostSettings.anger_distances
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
