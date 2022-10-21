UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local training_grounds_options_view_styles = {}
local header_font_style = table.clone(UIFontSettings.header_1)
header_font_style.offset = {
	0,
	0,
	10
}
header_font_style.text_horizontal_alignment = "left"
header_font_style.font_size = 42
local sub_header_font_style = table.clone(UIFontSettings.body)
sub_header_font_style.text_color = Color.ui_grey_medium(255, true)
sub_header_font_style.offset = {
	0,
	5,
	10
}
sub_header_font_style.text_horizontal_alignment = "left"
sub_header_font_style.scenegraph_id = "sub_header"
local body_font_style = table.clone(UIFontSettings.body)
body_font_style.offset = {
	0,
	0,
	10
}
body_font_style.scenegraph_id = "body"
local play_button_font_style = table.clone(UIFontSettings.header_3)
play_button_font_style.text_color = Color.ui_grey_medium(255, true)
play_button_font_style.offset = {
	0,
	0,
	10
}
play_button_font_style.scenegraph_id = "play_button"
play_button_font_style.horizontal_alignment = "center"
play_button_font_style.vertical_alignment = "center"
local rewards_header_font_style = table.clone(UIFontSettings.header_1)
rewards_header_font_style.offset = {
	0,
	10,
	10
}
rewards_header_font_style.text_horizontal_alignment = "center"
rewards_header_font_style.font_size = 34
local reward_font_style = table.clone(UIFontSettings.body)
reward_font_style.offset = {
	0,
	60,
	10
}
reward_font_style.text_horizontal_alignment = "center"
reward_font_style.horizontal_alignment = "center"
reward_font_style.vertical_alignment = "bottom"
reward_font_style.size = {
	300,
	50
}
local rewards_claimed_font_style = table.clone(UIFontSettings.body)
rewards_claimed_font_style.offset = {
	0,
	0,
	10
}
rewards_claimed_font_style.scenegraph_id = "rewards_claimed"
rewards_claimed_font_style.text_color = Color.terminal_text_body(255, true)
rewards_claimed_font_style.text_horizontal_alignment = "center"
training_grounds_options_view_styles.header_font_style = header_font_style
training_grounds_options_view_styles.sub_header_font_style = sub_header_font_style
training_grounds_options_view_styles.body_font_style = body_font_style
training_grounds_options_view_styles.play_button_font_style = play_button_font_style
training_grounds_options_view_styles.rewards_header_font_style = rewards_header_font_style
training_grounds_options_view_styles.reward_font_style = reward_font_style
training_grounds_options_view_styles.rewards_claimed_font_style = rewards_claimed_font_style

return training_grounds_options_view_styles
