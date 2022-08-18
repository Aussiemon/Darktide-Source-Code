local ProtoUI = require("scripts/ui/proto_ui/proto_ui")
local min = math.min
local V2 = Vector2
local V3 = Vector3
ProtoUI.CENTER = ProtoUI.CENTER or {
	0.5,
	0.5
}
ProtoUI.SOUTH_WEST = ProtoUI.SOUTH_WEST or {
	0,
	1
}
ProtoUI.SOUTH_EAST = ProtoUI.SOUTH_EAST or {
	1,
	1
}
ProtoUI.NORTH_WEST = ProtoUI.NORTH_WEST or {
	0,
	0
}
ProtoUI.NORTH_EAST = ProtoUI.NORTH_EAST or {
	1,
	0
}
ProtoUI.SOUTH = ProtoUI.SOUTH or {
	0.5,
	1
}
ProtoUI.NORTH = ProtoUI.NORTH or {
	0.5,
	0
}
ProtoUI.WEST = ProtoUI.WEST or {
	0,
	0.5
}
ProtoUI.EAST = ProtoUI.EAST or {
	1,
	0.5
}

ProtoUI.split_horizontal = function (y, pos, size)
	local Vy = V2(0, y)

	return pos, V2(size[1], y), pos + Vy, size - Vy
end

ProtoUI.split_vertical = function (x, pos, size)
	local Vx = V2(x, 0)

	return pos, V2(x, size[2]), pos + Vx, size - Vx
end

local split_horizontal = ProtoUI.split_horizontal
local split_vertical = ProtoUI.split_vertical

ProtoUI.split_horizontal_percent = function (py, pos, size)
	return split_horizontal(size[2] * py, pos, size)
end

ProtoUI.split_vertical_percent = function (px, pos, size)
	return split_vertical(size[1] * px, pos, size)
end

ProtoUI.apply_margins = function (margins, pos, size)
	return V3(pos[1] + margins[1], pos[2] + margins[2], pos[3]), V2(size[1] - 2 * margins[1], size[2] - 2 * margins[2])
end

ProtoUI.align_pos = function (align, pos, size)
	return V3(pos[1] + align[1] * size[1], pos[2] + align[2] * size[2], pos[3])
end

ProtoUI.align_box = function (align, sub_size, pos, size)
	return V3(pos[1] + align[1] * (size[1] - sub_size[1]), pos[2] + align[2] * (size[2] - sub_size[2]), pos[3])
end

ProtoUI.align_box_outer = function (align, sub_size, pos, size)
	local ss1 = sub_size[1]
	local ss2 = sub_size[2]

	return V3(pos[1] - ss1 + align[1] * (size[1] + ss1), pos[2] - ss2 + align[2] * (size[2] + ss2), pos[3])
end

ProtoUI.apply_transform = function (translation, scale, pos)
	return V3(pos[1] * scale + translation[1], pos[2] * scale + translation[2], pos[3])
end

ProtoUI.sub_uv = function (base_uv00, base_uv11, uv00, uv11)
	local dx = base_uv11[1] - base_uv00[1]
	local dy = base_uv11[2] - base_uv00[2]

	return V2(base_uv00[1] + uv00[1] * dx, base_uv00[2] + uv00[2] * dy), V2(base_uv00[1] + uv11[1] * dx, base_uv00[2] + uv11[2] * dy)
end

ProtoUI.fit_box = function (sub_size, pos, size)
	local s1 = size[1]
	local s2 = size[2]
	local ss1 = sub_size[1]
	local ss2 = sub_size[2]
	local scale = min(s1 / ss1, s2 / ss2)

	return V3(pos[1] + 0.5 * (s1 - scale * ss1), pos[2] + 0.5 * (s2 - scale * ss2), pos[3]), V2(scale * ss1, scale * ss2)
end

return ProtoUI
