local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local text_styles = {
	title_text_style = table.clone(UIFontSettings.header_2),
	slide_title_style = table.clone(UIFontSettings.header_2),
	slide_text_style = table.clone(UIFontSettings.body)
}
text_styles.title_text_style.text_horizontal_alignment = "center"
text_styles.title_text_style.text_vertical_alignment = "top"
text_styles.slide_title_style.text_horizontal_alignment = "left"
text_styles.slide_title_style.text_vertical_alignment = "top"
text_styles.slide_text_style.text_horizontal_alignment = "left"
text_styles.slide_text_style.text_vertical_alignment = "top"

return text_styles
