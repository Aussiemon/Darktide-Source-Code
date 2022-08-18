local ScriptGui = {
	text = function (gui, text, font_material, font_size, pos, color, drop_shadow_color)
		if drop_shadow_color then
			Gui.slug_text(gui, text, font_material, font_size, pos, nil, color, "shadow", drop_shadow_color)
		else
			Gui.slug_text(gui, text, font_material, font_size, pos, nil, color)
		end
	end,
	irect = function (gui, res_x, res_y, x1, y1, x2, y2, layer, color)
		local bottom_left = Vector3(x1 * res_x, y1 * res_y, layer)
		local size = Vector3((x2 - x1) * res_x, (y2 - y1) * res_y, layer)

		Gui.rect(gui, bottom_left, size, color)
	end,
	itext = function (gui, res_x, res_y, text, font_material, font_size, x1, y1, layer, color)
		Gui.slug_text(gui, text, font_material, font_size, Vector3(x1 * res_x, y1 * res_y, layer), nil, color)
	end,
	itext_next_xy = function (gui, res_x, res_y, text, font_material, font_size, x1, y1, layer, color)
		Gui.slug_text(gui, text, font_material, font_size, Vector3(x1 * res_x, y1 * res_y, layer), nil, color)

		local min, max = Gui.text_extents(gui, text, font_material, font_size)
		local x = (max.x - min.x) / res_x + x1
		local y = (max.y - min.y) / res_y + y1

		return x, y
	end,
	icrect = function (gui, res_x, res_y, x1, y1, x2, y2, layer, color)
		local bottom_left = Vector3(x1, y1, layer)
		local size = Vector3(x2 - x1, y2 - y1, layer)

		Gui.rect(gui, bottom_left, size, color)
	end,
	ictext = function (gui, res_x, res_y, text, font_material, font_size, x1, y1, layer, color)
		Gui.slug_text(gui, text, font_material, font_size, Vector3(x1, y1, layer), nil, color)
	end,
	hud_line = function (gui, p1, p2, layer, line_width, color)
		line_width = line_width or 3
		layer = layer or 1
		local xd = p2.x - p1.x
		local yd = p2.y - p1.y
		local angle = -math.atan2(yd, xd)
		local size = Vector2(math.sqrt(xd * xd + yd * yd), line_width)
		local transform = Rotation2D(p1, angle)

		Gui.rect_3d(gui, transform, Vector2(0, 0), layer, size, color)
	end,
	hud_iline = function (gui, res_x, res_y, p1, p2, layer, line_width, color)
		local c1 = Vector2(p1.x * res_x, p1.y * res_y)
		local c2 = Vector2(p2.x * res_x, p2.y * res_y)

		ScriptGui.hud_line(gui, c1, c2, layer, line_width, color)
	end
}

return ScriptGui
