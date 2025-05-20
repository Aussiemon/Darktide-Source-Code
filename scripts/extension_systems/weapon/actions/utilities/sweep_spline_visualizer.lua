-- chunkname: @scripts/extension_systems/weapon/actions/utilities/sweep_spline_visualizer.lua

local SweepSplineVisualizer = {}

SweepSplineVisualizer.draw_splines = function (sweep_spline, drawer, time, combined_spline, control_splines, color, reference_position, reference_rotation)
	color = color or Color.white()

	local time_step = Managers.state.game_session.fixed_time_step
	local t = 0
	local prev_pos, _, prev_outer_pos, prev_inner_pos = sweep_spline:position_and_rotation(t, reference_position, reference_rotation)

	while t < time do
		t = t + time_step

		local new_t = time < t and time or t
		local new_pos, _, new_outer_pos, new_inner_pos = sweep_spline:position_and_rotation(new_t / time, reference_position, reference_rotation)

		if combined_spline then
			drawer:line(prev_pos, new_pos, color)
		end

		if control_splines then
			drawer:line(prev_outer_pos, new_outer_pos, color)
			drawer:line(prev_inner_pos, new_inner_pos, color)
		end

		prev_pos, prev_outer_pos, prev_inner_pos = new_pos, new_outer_pos, new_inner_pos
	end
end

SweepSplineVisualizer.draw_point_on_spline = function (sweep_spline, drawer, t, show_rotation, color, reference_position, reference_rotation)
	color = color or Color.black()

	local pos, rot = sweep_spline:position_and_rotation(t, reference_position, reference_rotation)

	drawer:sphere(pos, 0.01, color)

	if show_rotation then
		drawer:quaternion(pos, rot, 0.1)
	end
end

return SweepSplineVisualizer
