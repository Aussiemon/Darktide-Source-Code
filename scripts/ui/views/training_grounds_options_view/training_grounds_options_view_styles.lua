-- chunkname: @scripts/ui/views/training_grounds_options_view/training_grounds_options_view_styles.lua

UIFontSettings = require("scripts/managers/ui/ui_font_settings")

local training_grounds_options_view_styles = {}
local header_font_style = table.clone(UIFontSettings.header_2)

header_font_style.offset = {
	0,
	0,
	50,
}
header_font_style.text_horizontal_alignment = "center"
header_font_style.font_size = 32
header_font_style.text_color = Color.terminal_text_header(255, true)

local sub_header_font_style = table.clone(UIFontSettings.body)
local sub_header_font_style = table.clone(UIFontSettings.body)

sub_header_font_style.text_color = Color.terminal_text_body_sub_header(255, true)
sub_header_font_style.offset = {
	0,
	5,
	10,
}
sub_header_font_style.text_horizontal_alignment = "center"
sub_header_font_style.scenegraph_id = "sub_header"
sub_header_font_style.font_size = 28

local body_font_style = table.clone(UIFontSettings.body)

body_font_style.text_color = Color.terminal_text_body(255, true)
body_font_style.offset = {
	0,
	0,
	10,
}
body_font_style.scenegraph_id = "body"
body_font_style.font_size = 24

local play_button_font_style = table.clone(UIFontSettings.header_3)

play_button_font_style.text_color = Color.ui_grey_medium(255, true)
play_button_font_style.offset = {
	0,
	0,
	10,
}
play_button_font_style.scenegraph_id = "play_button"
play_button_font_style.horizontal_alignment = "center"
play_button_font_style.vertical_alignment = "center"

local rewards_header_font_style = table.clone(UIFontSettings.header_2)

rewards_header_font_style.offset = {
	0,
	10,
	10,
}
rewards_header_font_style.text_horizontal_alignment = "center"
rewards_header_font_style.font_size = 24

local select_difficulty_text_style = table.clone(UIFontSettings.header_2)

select_difficulty_text_style.offset = {
	0,
	-60,
	10,
}
select_difficulty_text_style.text_horizontal_alignment = "center"
select_difficulty_text_style.vertical_alignment = "top"
select_difficulty_text_style.horizontal_alignment = "center"
select_difficulty_text_style.font_size = 28
select_difficulty_text_style.size = {
	600,
	50,
}

local reward_font_style = table.clone(UIFontSettings.body)

reward_font_style.text_color = Color.terminal_text_header(255, true)
reward_font_style.offset = {
	0,
	60,
	10,
}
reward_font_style.text_horizontal_alignment = "center"
reward_font_style.horizontal_alignment = "center"
reward_font_style.vertical_alignment = "bottom"
reward_font_style.size = {
	300,
	50,
}
training_grounds_options_view_styles.header_font_style = header_font_style
training_grounds_options_view_styles.sub_header_font_style = sub_header_font_style
training_grounds_options_view_styles.body_font_style = body_font_style
training_grounds_options_view_styles.play_button_font_style = play_button_font_style
training_grounds_options_view_styles.rewards_header_font_style = rewards_header_font_style
training_grounds_options_view_styles.select_difficulty_text_style = select_difficulty_text_style
training_grounds_options_view_styles.reward_font_style = reward_font_style

return training_grounds_options_view_styles
