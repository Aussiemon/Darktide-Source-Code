-- chunkname: @scripts/managers/ui/ui_passes_testify.lua

local function _center_position(position, size)
	local center_x = position[1] + size[1] * 0.5
	local center_y = position[2] + size[2] * 0.5

	return {
		x = center_x,
		y = center_y,
	}
end

local UIPassesTestify = {
	widget_position_by_name = function (_, name, pass_data)
		local widget_name = pass_data.widget_name

		if widget_name ~= name then
			return Testify.RETRY
		end

		local position = pass_data.position
		local size = pass_data.size

		return _center_position(position, size)
	end,
	widget_position_by_text = function (_, text, pass_data)
		local ui_content = pass_data.ui_content
		local widget_text = ui_content.parent.text

		if widget_text ~= text then
			return Testify.RETRY
		end

		local position = pass_data.position
		local size = pass_data.size

		return _center_position(position, size)
	end,
	widget_position_by_title_text = function (_, text, pass_data)
		local ui_content = pass_data.ui_content
		local widget_title_text = ui_content.parent.title_text

		if widget_title_text ~= text then
			return Testify.RETRY
		end

		local position = pass_data.position
		local size = pass_data.size

		return _center_position(position, size)
	end,
}

return UIPassesTestify
