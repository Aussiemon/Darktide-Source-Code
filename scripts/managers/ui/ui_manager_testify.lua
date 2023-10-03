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
	end
}

UIManagerTestify.open_view = function (ui_manager, view)
	local context = view.dummy_data or {
		debug_preview = true,
		can_exit = true
	}

	ui_manager:open_view(view.view_name, nil, nil, nil, nil, context)
end

UIManagerTestify.wait_for_view = function (ui_manager, view_name)
	if not ui_manager:view_active(view_name) then
		return Testify.RETRY
	end
end

UIManagerTestify.wait_for_view_to_close = function (ui_manager, view_name)
	if ui_manager:view_active(view_name) then
		return Testify.RETRY
	end
end

return UIManagerTestify
