-- chunkname: @scripts/settings/wallet_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local wallet_settings = {
	credits = {
		icon_texture_small = "content/ui/materials/icons/currencies/credits_small",
		display_name = "loc_currency_name_credits",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_credits",
		icon_texture_big = "content/ui/materials/icons/currencies/credits_big",
		string_symbol = "",
		sort_order = 1,
		backend_index = 1,
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		show_in_character_menu = true,
		notification_sound_event = UISoundEvents.notification_currency_recieved
	},
	marks = {
		icon_texture_small = "content/ui/materials/icons/currencies/marks_small",
		display_name = "loc_currency_name_marks",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_marks",
		icon_texture_big = "content/ui/materials/icons/currencies/marks_big",
		string_symbol = "",
		sort_order = 2,
		backend_index = 1,
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		show_in_character_menu = true,
		notification_sound_event = UISoundEvents.notification_currency_recieved
	},
	aquilas = {
		icon_texture_small = "content/ui/materials/icons/currencies/premium_small",
		display_name = "loc_currency_name_premium",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_premium",
		icon_texture_big = "content/ui/materials/icons/currencies/premium_big",
		string_symbol = "",
		sort_order = 5,
		backend_index = 1,
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		notification_sound_event = UISoundEvents.notification_currency_recieved
	},
	plasteel = {
		icon_texture_small = "content/ui/materials/icons/currencies/plasteel_small",
		display_name = "loc_currency_name_plasteel",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_plasteel",
		icon_texture_big = "content/ui/materials/icons/currencies/plasteel_big",
		string_symbol = "",
		sort_order = 3,
		backend_index = 1,
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		show_in_character_menu = true,
		notification_sound_event = UISoundEvents.notification_crafting_material_recieved_pasteel,
		pickup_localization_by_size = {
			small = "loc_pickup_small_metal",
			large = "loc_pickup_large_metal"
		}
	},
	diamantine = {
		icon_texture_small = "content/ui/materials/icons/currencies/diamantine_small",
		display_name = "loc_currency_name_diamantine",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_diamantine",
		icon_texture_big = "content/ui/materials/icons/currencies/diamantine_big",
		string_symbol = "",
		sort_order = 4,
		backend_index = 1,
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		show_in_character_menu = true,
		notification_sound_event = UISoundEvents.notification_crafting_material_recieved_diamantine,
		pickup_localization_by_size = {
			small = "loc_pickup_small_platinum",
			large = "loc_pickup_large_platinum"
		}
	}
}

for key, value in pairs(wallet_settings) do
	value.type = key
end

return settings("WalletSettings", wallet_settings)
