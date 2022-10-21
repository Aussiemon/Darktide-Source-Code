local ProjectileHuskLocomotion = require("scripts/extension_systems/locomotion/utilities/projectile_husk_locomotion")
local ProjectileSnapshotVisualizer = {}
local TEXT_OPTIONS = {
	text_size = 0.1,
	time = math.huge
}

ProjectileSnapshotVisualizer.draw_snapshot = function (snapshot_id, position, rotation, velocity)
	return
end

local RING_BUFFER_BACKGROUND_SIZE = {
	400,
	200
}
local RING_BUFFER_ANCHOR_POS = {
	50,
	400,
	10
}
local SNAPSHOT_WINDOW_SIZE = {
	RING_BUFFER_BACKGROUND_SIZE[1] * 0.99,
	80
}
local SNAPSHOT_WINDOW_POS = {
	2,
	-2,
	1
}
local SNAPSHOT_SIZE = {
	13,
	20
}
local SNAPSHOT_PADDING = 2

ProjectileSnapshotVisualizer.draw_ring_buffer = function (snapshot_ring_buffer, interpolation_data, t)
	local byte_count = Script.temp_byte_count()
	local gui = Debug:debug_gui()
	local font = DevParameters.debug_text_font
	local font_size = 16
	local bg_size = Vector2(RING_BUFFER_BACKGROUND_SIZE[1], RING_BUFFER_BACKGROUND_SIZE[2])
	local anchor_pos = Vector3(RING_BUFFER_ANCHOR_POS[1], RING_BUFFER_ANCHOR_POS[2], RING_BUFFER_ANCHOR_POS[3])

	Gui.rect(gui, anchor_pos, bg_size, Color.white(100))

	local y_offset = font_size + 2
	local x_offset = 180
	local time_scale = interpolation_data.time_scale
	local time_scale_s = string.format("time_scale: %.2f", time_scale)
	local time_scale_pos = Vector3(anchor_pos.x + 5, anchor_pos.y + 5, anchor_pos.z + 1)

	Gui.slug_text(gui, time_scale_s, font, font_size, time_scale_pos, nil, Color.cheeseburger(), "flags", Gui.FormatDirectives, "shadow", Color.black())

	local visualizer_data = interpolation_data.visualizer_data
	local snapshots_per_read = visualizer_data.snapshots_per_read
	local max_spr = 0
	local num_spr = #snapshots_per_read

	for i = 1, num_spr do
		max_spr = max_spr + snapshots_per_read[i]
	end

	local avg_spr = num_spr > 0 and math.round(max_spr / num_spr) or 0
	local avg_spr_s = string.format("avg_spr: %i", avg_spr)
	local avg_spr_pos = Vector3(anchor_pos.x + 5, anchor_pos.y + 5 + y_offset, anchor_pos.z + 1)

	Gui.slug_text(gui, avg_spr_s, font, font_size, avg_spr_pos, nil, Color.cheeseburger(), "flags", Gui.FormatDirectives, "shadow", Color.black())

	local snapshots_behind_latest = visualizer_data.snapshots_behind_latest
	local max_sbl = 0
	local num_sbl = #snapshots_behind_latest

	for i = 1, num_sbl do
		max_sbl = max_sbl + snapshots_behind_latest[i]
	end

	local avg_sbl = num_sbl > 0 and math.round(max_sbl / num_sbl) or 0
	local avg_sbl_s = string.format("avg_sbl: %i", avg_sbl)
	local avg_sbl_pos = Vector3(anchor_pos.x + 5, anchor_pos.y + 5 + y_offset * 2, anchor_pos.z + 1)

	Gui.slug_text(gui, avg_sbl_s, font, font_size, avg_sbl_pos, nil, Color.cheeseburger(), "flags", Gui.FormatDirectives, "shadow", Color.black())

	local position = visualizer_data.position:unbox()
	local position_s = string.format("position: %.2f %.2f %.2f", position.x, position.y, position.z)
	local position_pos = Vector3(anchor_pos.x + 5 + x_offset, anchor_pos.y + 5 + y_offset * 0, anchor_pos.z + 1)

	Gui.slug_text(gui, position_s, font, font_size, position_pos, nil, Color.cheeseburger(), "flags", Gui.FormatDirectives, "shadow", Color.black())

	local rotation = visualizer_data.rotation:unbox()
	local rot_x, rot_y, rot_z, rot_w = Quaternion.to_elements(rotation)
	local rotation_s = string.format("rotation: %.2f %.2f %.2f %.2f", rot_x, rot_y, rot_z, rot_w)
	local rotation_pos = Vector3(anchor_pos.x + 5 + x_offset, anchor_pos.y + 5 + y_offset * 1, anchor_pos.z + 1)

	Gui.slug_text(gui, rotation_s, font, font_size, rotation_pos, nil, Color.cheeseburger(), "flags", Gui.FormatDirectives, "shadow", Color.black())

	local locomotion_state = visualizer_data.locomotion_state
	local loc_state_s = string.format("loc_state: %s", locomotion_state)
	local loc_state_pos = Vector3(anchor_pos.x + 5 + x_offset, anchor_pos.y + 5 + y_offset * 2, anchor_pos.z + 1)

	Gui.slug_text(gui, loc_state_s, font, font_size, loc_state_pos, nil, Color.cheeseburger(), "flags", Gui.FormatDirectives, "shadow", Color.black())

	local window_size = Vector2(SNAPSHOT_WINDOW_SIZE[1], SNAPSHOT_WINDOW_SIZE[2])
	local window_pos = Vector3(anchor_pos.x + SNAPSHOT_WINDOW_POS[1], anchor_pos.y + bg_size.y - window_size.y + SNAPSHOT_WINDOW_POS[2], anchor_pos.z + SNAPSHOT_WINDOW_POS[3])

	Gui.rect(gui, window_pos, window_size, Color.light_cyan(200))

	local snapshot_plus_padding_x = SNAPSHOT_SIZE[1] + SNAPSHOT_PADDING
	local snapshot_plus_padding_y = SNAPSHOT_SIZE[2] + SNAPSHOT_PADDING
	local num_snapshots_per_row = math.floor(SNAPSHOT_WINDOW_SIZE[1] / snapshot_plus_padding_x)
	local num_snapshots = #snapshot_ring_buffer

	for i = 1, num_snapshots do
		local snapshot = snapshot_ring_buffer[i]
		local row = math.ceil(i / num_snapshots_per_row)
		local column = (i - 1) % num_snapshots_per_row + 1
		local snapshot_size = Vector2(SNAPSHOT_SIZE[1], SNAPSHOT_SIZE[2])
		local snapshot_pos = Vector3(window_pos.x + snapshot_plus_padding_x * (column - 1) + 2, window_pos.y + snapshot_plus_padding_y * (row - 1) + 2, window_pos.z + 1)
		local is_interpolating = interpolation_data.is_interpolating
		local is_start = is_interpolating and interpolation_data.start_snapshot_id == i
		local is_target = is_interpolating and interpolation_data.target_snapshot_id == i
		local is_outdated = ProjectileHuskLocomotion.snapshot_is_outdated(snapshot, t)
		local is_approximated = snapshot.approximated
		local snapshot_color = nil

		if is_start then
			snapshot_color = Color.deep_sky_blue()
		elseif is_target then
			snapshot_color = Color.medium_orchid()
		elseif is_outdated then
			snapshot_color = Color.black()
		elseif is_approximated then
			snapshot_color = Color.red()
		else
			snapshot_color = Color.green()
		end

		Gui.rect(gui, snapshot_pos, snapshot_size, snapshot_color)
	end

	Script.set_temp_byte_count(byte_count)
end

return ProjectileSnapshotVisualizer
