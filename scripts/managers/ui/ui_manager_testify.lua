local Views = require("scripts/ui/views/views")
local UIManagerTestify = {
	all_views = function (_, ui_manager)
		return Views
	end,
	close_view = function (view_name, ui_manager)
		ui_manager:close_view(view_name)
	end,
	is_view_active = function (view_name, ui_manager)
		return ui_manager:view_active(view_name)
	end,
	open_view = function (view, ui_manager)
		local context = view.dummy_data or {
			debug_preview = true,
			can_exit = true
		}

		ui_manager:open_view(view.view_name, nil, nil, nil, nil, context)
	end,
	wait_for_view = function (view_name, ui_manager)
		if not ui_manager:view_active(view_name) then
			return Testify.RETRY
		end
	end,
	wait_for_view_to_close = function (view_name, ui_manager)
		if ui_manager:view_active(view_name) then
			return Testify.RETRY
		end
	end
}

return UIManagerTestify
