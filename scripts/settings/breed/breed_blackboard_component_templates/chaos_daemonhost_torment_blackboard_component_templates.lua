-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/chaos_daemonhost_torment_blackboard_component_templates.lua

require("scripts/foundation/utilities/table")

local daemonhost_templates = require("scripts/settings/breed/breed_blackboard_component_templates/chaos_daemonhost_blackboard_component_templates")
local chaos_daemonhost_torment = table.clone(daemonhost_templates.chaos_daemonhost)

chaos_daemonhost_torment.behavior.warp_nova_cooldown = "number"
chaos_daemonhost_torment.behavior.death_leave_cooldown = "number"
chaos_daemonhost_torment.behavior.spawned_in = "boolean"

local templates = {
	chaos_daemonhost_torment = chaos_daemonhost_torment,
}

return templates
