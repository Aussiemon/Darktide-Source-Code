-- chunkname: @scripts/managers/error/error_manager_testify.lua

local BanError = require("scripts/managers/error/errors/ban_error")
local BanSettings = require("scripts/managers/error/errors/ban_settings")
local CATEGORY_LOC_KEY_PREFIX = "loc_error_banned_"
local UNKNOWN_BAN_REASON = "TESTIFY_UNKNOWN_REASON"
local BAN_ISSUED_TIMESTAMP = 1735689600000
local BAN_EXPIRY_TIMESTAMP = "4102444800000"

local function _ban_variant(variants, name, banned_data)
	local index = #variants + 1

	variants[index] = {
		name = string.format("%02d_%s", index, name),
		banned_data = banned_data,
	}
end

local ErrorManagerTestify = {
	ban_popup_variants = function ()
		local variants = {}
		local categories = BanSettings.categories
		local detailed_reason

		for i = 1, #categories do
			local category = categories[i]
			local reason = category.reasons[1]
			local name = string.gsub(category.category, "^" .. CATEGORY_LOC_KEY_PREFIX, "")

			_ban_variant(variants, "category_" .. name, {
				reason = reason,
			})

			if not detailed_reason and category.description and category.violation then
				detailed_reason = reason
			end
		end

		_ban_variant(variants, "frozen", {
			frozen = true,
		})
		_ban_variant(variants, "unknown_reason", {
			reason = UNKNOWN_BAN_REASON,
		})
		_ban_variant(variants, "issued_date", {
			reason = detailed_reason,
			issued = BAN_ISSUED_TIMESTAMP,
		})
		_ban_variant(variants, "issued_and_expiry_date", {
			reason = detailed_reason,
			issued = BAN_ISSUED_TIMESTAMP,
			expiry = BAN_EXPIRY_TIMESTAMP,
		})

		return variants
	end,
	show_ban_error_popup = function (_, banned_data)
		local error_object = BanError:new({
			banned = banned_data,
		})
		local loc_description, loc_description_params = error_object:loc_description()
		local options = error_object:options() or {}

		options[#options + 1] = {
			close_on_pressed = true,
			text = "loc_popup_button_close",
		}

		local popup_id

		Managers.event:trigger("event_show_ui_popup", {
			title_text = error_object:loc_title(),
			description_text = loc_description,
			description_text_params = loc_description_params,
			options = options,
			priority_order = math.huge,
		}, function (id)
			popup_id = id
		end)

		return popup_id
	end,
	remove_ui_popup = function (_, popup_id)
		Managers.event:trigger("event_remove_ui_popup", popup_id)
	end,
}

return ErrorManagerTestify
