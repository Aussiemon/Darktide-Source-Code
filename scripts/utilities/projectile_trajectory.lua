local ProjectileTrajectory = {
	trajectory_settings_from_aim_component = function (action_settings, action_aim_projectile_component, weapon_action_component, trajectory_settings)
		trajectory_settings.rotation = action_aim_projectile_component.rotation
		trajectory_settings.speed = action_aim_projectile_component.speed
		trajectory_settings.momentum = action_aim_projectile_component.momentum
		trajectory_settings.throw_type = action_settings.throw_type
		trajectory_settings.stop_on_impact = action_settings.stop_on_impact
		trajectory_settings.start_offset = action_settings.arc_start_offset and action_settings.arc_start_offset:unbox()
		trajectory_settings.time_in_action = Managers.time:time("gameplay") - weapon_action_component.start_t
	end
}

return ProjectileTrajectory
