-- chunkname: @scripts/settings/wallet_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local wallet_settings = {
	credits = {
		backend_index = 1,
		display_name = "loc_currency_name_credits",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_credits",
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		icon_texture_big = "content/ui/materials/icons/currencies/credits_big",
		icon_texture_small = "content/ui/materials/icons/currencies/credits_small",
		show_in_character_menu = true,
		sort_order = 1,
		string_symbol = "",
		notification_sound_event = UISoundEvents.notification_currency_recieved,
	},
	marks = {
		backend_index = 1,
		display_name = "loc_currency_name_marks",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_marks",
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		icon_texture_big = "content/ui/materials/icons/currencies/marks_big",
		icon_texture_small = "content/ui/materials/icons/currencies/marks_small",
		show_in_character_menu = true,
		sort_order = 2,
		string_symbol = "",
		notification_sound_event = UISoundEvents.notification_currency_recieved,
	},
	aquilas = {
		backend_index = 1,
		display_name = "loc_currency_name_premium",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_premium",
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		icon_texture_big = "content/ui/materials/icons/currencies/premium_big",
		icon_texture_small = "content/ui/materials/icons/currencies/premium_small",
		sort_order = 5,
		string_symbol = "",
		notification_sound_event = UISoundEvents.notification_currency_recieved,
	},
	plasteel = {
		backend_index = 1,
		display_name = "loc_currency_name_plasteel",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_plasteel",
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		icon_texture_big = "content/ui/materials/icons/currencies/plasteel_big",
		icon_texture_small = "content/ui/materials/icons/currencies/plasteel_small",
		show_in_character_menu = true,
		sort_order = 3,
		string_symbol = "",
		notification_sound_event = UISoundEvents.notification_crafting_material_recieved_pasteel,
		pickup_localization_by_size = {
			large = "loc_pickup_large_metal",
			small = "loc_pickup_small_metal",
		},
	},
	diamantine = {
		backend_index = 1,
		display_name = "loc_currency_name_diamantine",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_diamantine",
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		icon_texture_big = "content/ui/materials/icons/currencies/diamantine_big",
		icon_texture_small = "content/ui/materials/icons/currencies/diamantine_small",
		show_in_character_menu = true,
		sort_order = 4,
		string_symbol = "",
		notification_sound_event = UISoundEvents.notification_crafting_material_recieved_diamantine,
		pickup_localization_by_size = {
			large = "loc_pickup_large_platinum",
			small = "loc_pickup_small_platinum",
		},
	},
}

for key, value in pairs(wallet_settings) do
	value.type = key
end

return settings("WalletSettings", wallet_settings)
