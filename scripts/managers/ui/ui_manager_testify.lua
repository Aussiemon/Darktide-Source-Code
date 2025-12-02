-- chunkname: @scripts/managers/ui/ui_manager_testify.lua

local Views = require("scripts/ui/views/views")
local UIManagerTestify = {
	all_views = function (ui_manager)
		return Views
	end,
	close_view = function (ui_manager, view_name)
		ui_manager:close_view(view_name)
	end,
	is_view_active = function (ui_manager, view_name)
		return ui_manager:view_active(view_name)
	end,
	wait_until_view_is_done_closing = function (ui_manager, view_name)
		if ui_manager:is_view_closing(view_name) then
			return Testify.RETRY
		end
	end,
	open_view = function (ui_manager, view)
		local context = view.dummy_data or {
			can_exit = true,
			debug_preview = true,
		}

		ui_manager:open_view(view.view_name, nil, nil, nil, nil, context)
	end,
	wait_for_view = function (ui_manager, view_name)
		if not ui_manager:view_active(view_name) then
			return Testify.RETRY
		end
	end,
	wait_for_view_to_close = function (ui_manager, view_name)
		if ui_manager:view_active(view_name) then
			return Testify.RETRY
		end
	end,
}

return UIManagerTestify
