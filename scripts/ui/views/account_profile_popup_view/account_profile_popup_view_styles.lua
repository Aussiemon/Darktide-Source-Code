local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local PopupStyles = {}
local icon_size = {
	240,
	240
}
local content_width = 1000
local info_height = 160
local headline_height = 60
local popup_margin = 40
local info_margin = 50
PopupStyles.popup_margin = popup_margin
PopupStyles.info_margin = info_margin
PopupStyles.icon_size = icon_size
PopupStyles.info_area_size = {
	content_width - (icon_size[1] + info_margin),
	info_height
}
PopupStyles.popup_content_size = {
	content_width,
	icon_size[2] + popup_margin * 2,
	info_height + headline_height + info_margin * 2
}
local background_style = {
	screen_overlay = {
		color = Color.black(150, true)
	},
	background = {
		color = Color.black(128, true)
	},
	top_border = {
		vertical_alignment = "top",
		size = {
			nil,
			2
		},
		color = Color.ui_brown_medium(255, true),
		offset = {
			0,
			0,
			1
		}
	}
}
background_style.bottom_border = table.clone(background_style.top_border)
background_style.bottom_border.vertical_alignment = "bottom"
PopupStyles.background = background_style
PopupStyles.headline = table.clone(UIFontSettings.header_2)
PopupStyles.headline.size = {
	PopupStyles.info_area_size[1],
	headline_height
}
PopupStyles.headline.text_vertical_alignment = "top"

return PopupStyles
