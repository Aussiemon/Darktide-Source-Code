-- chunkname: @scripts/ui/views/base_view_testify.lua

local BaseViewTestify = {
	trigger_widget_callback = function (base_view, widget_name)
		local widget = base_view:widgets_by_name()[widget_name]

		if not widget then
			return Testify.RETRY
		end

		local hotspot_content = base_view:widget_hotspot_content(widget_name)

		if not hotspot_content then
			return Testify.RETRY
		end

		local callback = hotspot_content.pressed_callback

		callback()
	end,
}

return BaseViewTestify
