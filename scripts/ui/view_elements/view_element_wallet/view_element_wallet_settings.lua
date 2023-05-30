local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local wallet_icon_original_size = {
	56,
	40
}
local wallet_height = 14
local view_element_wallet_settings = {
	wallet_widget_width = 150,
	text_margin = 0,
	column_spacing = 0,
	row_spacing = 0,
	background_margin = 20,
	wallet_icon_original_size = wallet_icon_original_size,
	icon_size = {
		wallet_height / wallet_icon_original_size[2] * wallet_icon_original_size[1],
		wallet_height
	}
}

return settings("ViewElementWalletSettings", view_element_wallet_settings)
