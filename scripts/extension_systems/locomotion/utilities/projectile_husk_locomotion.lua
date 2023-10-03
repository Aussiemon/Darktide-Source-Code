local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local NUM_BUFFERED_SNAPSHOTS = ProjectileLocomotionSettings.NUM_BUFFERED_SNAPSHOTS
local ProjectileHuskLocomotion = {
	snapshot_is_outdated = function (snapshot, t, fixed_time_step)
		local delta = t - snapshot.read_time

		return delta > NUM_BUFFERED_SNAPSHOTS * fixed_time_step
	end
}

return ProjectileHuskLocomotion
