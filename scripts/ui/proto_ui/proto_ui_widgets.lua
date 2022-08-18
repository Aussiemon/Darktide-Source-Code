local Vector3 = Vector3
local Vector2 = Vector2
local Color = Color
local ProtoUI = require("scripts/ui/proto_ui/proto_ui")

ProtoUI.bishop_button_primary = function (idx, label, pos, disabled)
	ProtoUI.begin_group(idx, pos)

	local size = Vector2(347, 76)
	local data, is_clicked = ProtoUI.use_data("button_data", ProtoUI.behaviour_button, Vector3(0, 0, 0), size, disabled)
	local state = data.state
	local text_color = nil

	if state == "default" then
		text_color = Color.ui_brown_light()
	elseif state == "hover" or state == "warm" then
		text_color = Color.ui_brown_super_light()
	elseif state == "hot" then
		text_color = Color.ui_brown_medium()
	elseif state == "disabled" then
		text_color = Color.ui_grey_light()
	end

	if state == "hover" or state == "warm" or state == "hot" then
		ProtoUI.draw_bitmap("content/ui/materials/buttons/background_selected", Vector3(0, 0, 1), size, Color.ui_terminal())
	end

	ProtoUI.draw_rect(Vector3(17, 6, 2), size + Vector2(-34, -12), Color(16, 16, 16))
	ProtoUI.draw_bitmap("content/ui/materials/buttons/primary", Vector3(0, 0, 3), size)
	ProtoUI.draw_text("Play", "content/ui/fonts/proxima_nova_bold", 24, Vector3(0, -2, 5), size, text_color, "flags", Gui.MultiLine, "character_spacing", 0.1, "vertical_align_center", "horizontal_align_center", "shadow", Color(0, 0, 0))
	ProtoUI.end_group(idx)

	return data, not disabled and is_clicked
end

return
