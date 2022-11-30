local wallet_settings = {
	credits = {
		sort_order = 1,
		icon_texture_small = "content/ui/materials/icons/currencies/credits_small",
		display_name = "loc_currency_name_credits",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_credits",
		icon_texture_big = "content/ui/materials/icons/currencies/credits_big",
		string_symbol = "",
		backend_index = 1,
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		show_in_character_menu = true
	},
	marks = {
		sort_order = 2,
		icon_texture_small = "content/ui/materials/icons/currencies/marks_small",
		display_name = "loc_currency_name_marks",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_marks",
		icon_texture_big = "content/ui/materials/icons/currencies/marks_big",
		string_symbol = "",
		backend_index = 1,
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		show_in_character_menu = true
	},
	aquilas = {
		icon_texture_big = "content/ui/materials/icons/currencies/premium_big",
		icon_texture_small = "content/ui/materials/icons/currencies/premium_small",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_premium",
		display_name = "loc_currency_name_premium",
		sort_order = 5,
		string_symbol = "",
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		backend_index = 1
	},
	plasteel = {
		sort_order = 3,
		icon_texture_small = "content/ui/materials/icons/currencies/plasteel_small",
		display_name = "loc_currency_name_plasteel",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_plasteel",
		icon_texture_big = "content/ui/materials/icons/currencies/plasteel_big",
		string_symbol = "",
		backend_index = 1,
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		show_in_character_menu = true
	},
	diamantine = {
		sort_order = 4,
		icon_texture_small = "content/ui/materials/icons/currencies/diamantine_small",
		display_name = "loc_currency_name_diamantine",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_diamantine",
		icon_texture_big = "content/ui/materials/icons/currencies/diamantine_big",
		string_symbol = "",
		backend_index = 1,
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		show_in_character_menu = true
	}
}

for key, value in pairs(wallet_settings) do
	value.type = key
end

return settings("WalletSettings", wallet_settings)
