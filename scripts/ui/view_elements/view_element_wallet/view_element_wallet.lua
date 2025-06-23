-- chunkname: @scripts/ui/view_elements/view_element_wallet/view_element_wallet.lua

local Definitions = require("scripts/ui/view_elements/view_element_wallet/view_element_wallet_definitions")
local ViewElementWalletSettings = require("scripts/ui/view_elements/view_element_wallet/view_element_wallet_settings")
local WalletSettings = require("scripts/settings/wallet_settings")
local TextUtils = require("scripts/utilities/ui/text")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ViewElementWallet = class("ViewElementWallet", "ViewElementBase")

ViewElementWallet.init = function (self, parent, draw_layer, start_scale)
	ViewElementWallet.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._amount_by_currency = {}
	self._wallets_updated = {}
	self._wallets_by_type = {}
	self._pivot_offset = {
		0,
		0
	}
	self._text_options = {}
end

ViewElementWallet._generate_currencies = function (self, currencies_to_use, widget_size, wallets_per_column, grid_spacing)
	local widgets = {}
	local widgets_by_currency = {}
	local grid_spacing = {
		grid_spacing and grid_spacing[1] or ViewElementWalletSettings.row_spacing,
		grid_spacing and grid_spacing[2] or ViewElementWalletSettings.column_spacing
	}
	local widget_size = {
		widget_size and widget_size[1] or ViewElementWalletSettings.wallet_widget_width,
		widget_size and widget_size[2] or ViewElementWalletSettings.icon_size[2]
	}

	if not currencies_to_use then
		currencies_to_use = {}

		for currency_name, currency_data in pairs(WalletSettings) do
			currencies_to_use[currency_data.sort_order] = currency_name
		end
	end

	local max_wallets_per_column = #currencies_to_use
	local wallets_per_column = wallets_per_column or max_wallets_per_column

	self._min_width = widget_size[1]
	self._widget_height = widget_size[2]
	self._wallets_per_column = math.clamp(wallets_per_column, 1, max_wallets_per_column)
	self._grid_spacing = grid_spacing

	for i = 1, #currencies_to_use do
		local currency_to_use = currencies_to_use[i]
		local currency

		for currency_name, _ in pairs(WalletSettings) do
			if currency_to_use == currency_name then
				currency = currency_name

				break
			end
		end

		if currency then
			local widget = self:_generate_currency_widget(currency, WalletSettings[currency], widget_size)

			widgets[#widgets + 1] = widget
			widgets_by_currency[currency] = widget
		end
	end

	self._wallet_widgets = widgets
	self._widgets_by_currency = widgets_by_currency

	self:update_wallets()
end

ViewElementWallet.set_pivot_offset = function (self, x, y, horizontal_alignment, vertical_alignment)
	local scenegraph_name = "wallet_area"

	self._pivot_offset[1] = x or self._pivot_offset[1]
	self._pivot_offset[2] = y or self._pivot_offset[2]

	self:_set_scenegraph_position(scenegraph_name, x, y)

	self._ui_scenegraph[scenegraph_name].horizontal_alignment = horizontal_alignment or self._ui_scenegraph[scenegraph_name].horizontal_alignment
	self._ui_scenegraph[scenegraph_name].vertical_alignment = vertical_alignment or self._ui_scenegraph[scenegraph_name].vertical_alignment
end

ViewElementWallet.update_wallets = function (self)
	local store_service = Managers.data_service.store
	local promise = store_service:combined_wallets()

	promise:next(function (wallets_data)
		if self._destroyed or not self._wallet_promise then
			return
		end

		if wallets_data then
			for name, widget in pairs(self._widgets_by_currency) do
				local wallet = wallets_data:by_type(name)
				local balance = wallet and wallet.balance
				local amount = balance and balance.amount or 0

				self._wallets_by_type[name] = wallet

				if self._amount_by_currency[name] ~= amount then
					self._wallets_updated[name] = true
					self._amount_by_currency[name] = amount
				end
			end
		end

		self._wallet_promise = nil
	end):catch(function (error)
		self._wallet_promise = nil
	end)

	self._wallet_promise = promise

	return promise
end

ViewElementWallet._get_wallet_text_size = function (self, widget, currency_name, ui_renderer)
	local content = widget.content
	local style = widget.style.text
	local amount = self._amount_by_currency[currency_name]
	local text = TextUtils.format_currency(amount)

	content.text = text

	local text_options = UIFonts.get_font_options_by_style(style, self._text_options)
	local size = {
		1920,
		1080
	}
	local width, height = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, size, text_options)

	return width, height
end

ViewElementWallet.get_amount_by_currency = function (self, currency_name)
	return self._amount_by_currency and self._amount_by_currency[currency_name] or 0
end

ViewElementWallet.get_wallet_by_type = function (self, currency_name)
	return self._wallets_by_type and self._wallets_by_type[currency_name] or nil
end

ViewElementWallet._generate_currency_widget = function (self, currency_name, currency_data, widget_size)
	local widget_definition = Definitions.wallet_definitions
	local widget_name = "currency_" .. currency_name
	local widget = self:_create_widget(widget_name, widget_definition)
	local font_gradient_material = currency_data.font_gradient_material
	local icon_texture_small = currency_data.icon_texture_small

	widget.content.texture = icon_texture_small
	widget.style.text.material = font_gradient_material
	widget.content.size = table.clone(widget_size)

	local icon_width = widget_size[2] / ViewElementWalletSettings.wallet_icon_original_size[2] * ViewElementWalletSettings.wallet_icon_original_size[1]

	widget.style.texture.size = {
		icon_width,
		widget_size[2]
	}
	widget.style.text.offset[1] = -icon_width - ViewElementWalletSettings.text_margin
	widget.style.text.font_size = widget_size[2]

	return widget
end

ViewElementWallet.highlight_currencies = function (self, currency_names)
	if currency_names then
		for i = 1, #self._wallet_widgets do
			local widget = self._wallet_widgets[i]

			widget.alpha_multiplier = 0.5
		end

		if type(currency_names) == "table" then
			for i = 1, #currency_names do
				local currency_name = currency_names[i]

				if self._widgets_by_currency[currency_name] then
					self._widgets_by_currency[currency_name].alpha_multiplier = 1
				end
			end
		elseif self._widgets_by_currency[currency_names] then
			self._widgets_by_currency[currency_names].alpha_multiplier = 1
		end
	else
		for i = 1, #self._wallet_widgets do
			local widget = self._wallet_widgets[i]

			widget.alpha_multiplier = 1
		end
	end
end

ViewElementWallet.update = function (self, dt, t, input_service)
	return ViewElementWallet.super.update(self, dt, t, input_service)
end

ViewElementWallet._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ViewElementWallet.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local recalculate = false

	for name, is_updated in pairs(self._wallets_updated) do
		self._wallets_updated[name] = nil

		if is_updated then
			recalculate = true
		end
	end

	if recalculate then
		local widget_min_width = self._min_width
		local total_width = 0

		if self._wallets_per_column == #self._wallet_widgets then
			total_width = widget_min_width

			for name, widget in pairs(self._widgets_by_currency) do
				local text_width = self:_get_wallet_text_size(widget, name, ui_renderer)
				local size = widget.style.texture.size[1] + ViewElementWalletSettings.text_margin + text_width

				total_width = math.max(size, total_width)
			end

			for i = 1, #self._wallet_widgets do
				local widget = self._wallet_widgets[i]

				widget.content.size[1] = total_width
				widget.offset = {
					0,
					(i - 1) * self._widget_height + self._grid_spacing[2] * (i - 1),
					1
				}
			end
		else
			local count = 0

			for name, widget in pairs(self._widgets_by_currency) do
				count = count + 1

				local grid_position = {
					(count - 1) % self._wallets_per_column,
					math.floor((count - 1) / self._wallets_per_column)
				}
				local widget_size = widget.content.size
				local text_width = self:_get_wallet_text_size(widget, name, ui_renderer)
				local widget_width = widget.style.texture.size[1] + ViewElementWalletSettings.text_margin + text_width

				if self._wallets_per_column == 1 then
					widget.content.size[1] = widget_width
					widget.offset = {
						grid_position[1] * total_width,
						grid_position[2] * widget_size[2] + self._grid_spacing[2] * (count - 1),
						1
					}
				else
					widget.content.size[1] = math.max(widget_width, widget_min_width)
					widget.offset = {
						total_width,
						0,
						1
					}
				end

				total_width = total_width + widget.content.size[1] + self._grid_spacing[1] * (count - 1)
			end
		end

		local total_row_spacing = (self._wallets_per_column - 1) * self._grid_spacing[2]
		local area_width = total_width
		local max_wallets_heigh_count = #self._wallet_widgets == self._wallets_per_column and self._wallets_per_column or math.ceil(#self._wallet_widgets / self._wallets_per_column)
		local area_height = max_wallets_heigh_count * self._widget_height + total_row_spacing

		self:_set_scenegraph_size("wallet_area", area_width, area_height)
	end

	if self._wallet_widgets then
		for i = 1, #self._wallet_widgets do
			local widget = self._wallet_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end
end

ViewElementWallet.get_size = function (self)
	return self._ui_scenegraph.wallet_area.size
end

ViewElementWallet.on_exit = function (self)
	if self._wallet_promise then
		self._wallet_promise:cancel()
	end

	ViewElementWallet.super.on_exit(self)
end

return ViewElementWallet
