local wallet_settings = {
	credits = {
		icon_texture_big = "content/ui/materials/icons/currencies/credits_big",
		icon_texture_small = "content/ui/materials/icons/currencies/credits_small",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_credits",
		display_name = "loc_currency_name_credits",
		sort_order = 2,
		string_symbol = "",
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		backend_index = 1
	},
	marks = {
		icon_texture_big = "content/ui/materials/icons/currencies/marks_big",
		icon_texture_small = "content/ui/materials/icons/currencies/marks_small",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_marks",
		display_name = "loc_currency_name_marks",
		sort_order = 2,
		string_symbol = "",
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		backend_index = 1
	},
	aquilas = {
		icon_texture_big = "content/ui/materials/icons/currencies/credits_big",
		icon_texture_small = "content/ui/materials/icons/currencies/credits_small",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_premium",
		display_name = "loc_currency_name_premium",
		sort_order = 3,
		string_symbol = "",
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		backend_index = 1
	},
	plasteel = {
		icon_texture_big = "content/ui/materials/icons/currencies/plasteel_big",
		icon_texture_small = "content/ui/materials/icons/currencies/plasteel_small",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_plasteel",
		display_name = "loc_currency_name_plasteel",
		sort_order = 3,
		string_symbol = "",
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		backend_index = 1
	},
	diamantine = {
		icon_texture_big = "content/ui/materials/icons/currencies/diamantine_big",
		icon_texture_small = "content/ui/materials/icons/currencies/diamantine_small",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_diamantine",
		display_name = "loc_currency_name_diamantine",
		sort_order = 3,
		string_symbol = "",
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		backend_index = 1
	}
}

for key, value in pairs(wallet_settings) do
	value.type = key
end

return settings("WalletSettings", wallet_settings)
