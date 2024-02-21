local AchievementUIHelper = require("scripts/managers/achievements/utility/achievement_ui_helper")
local ConstantElementNotificationFeedSettings = require("scripts/ui/constant_elements/elements/notification_feed/constant_element_notification_feed_settings")
local ContractCriteriaParser = require("scripts/utilities/contract_criteria_parser")
local Definitions = require("scripts/ui/constant_elements/elements/notification_feed/constant_element_notification_feed_definitions")
local ItemUtils = require("scripts/utilities/items")
local TextUtilities = require("scripts/utilities/ui/text")
local TextUtils = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local WalletSettings = require("scripts/settings/wallet_settings")
local DEBUG_RELOAD = true
local _localization_context = {}

local function _apply_package_item_icon_cb_func(widget, item)
	local icon = item.icon
	local icon_style = widget.style.icon
	local material_values = icon_style.material_values

	if item.icon_material and item.icon_material ~= "" then
		if material_values.texture_icon then
			material_values.texture_icon = nil
		end

		widget.content.old_icon = widget.content.icon
		widget.content.icon = item.icon_material
	else
		material_values.icon_size = {
			icon_style.size[1],
			icon_style.size[2]
		}
		material_values.texture_icon = icon
	end

	material_values.use_placeholder_texture = 0
	material_values.use_render_target = 0
	widget.content.use_placeholder_texture = material_values.use_placeholder_texture
end

local function _remove_package_item_icon_cb_func(widget, ui_renderer)
	if ui_renderer then
		UIWidget.set_visible(widget, ui_renderer, false)
		UIWidget.set_visible(widget, ui_renderer, true)
	end

	if widget.content.old_icon then
		widget.content.icon = widget.content.old_icon
		widget.content.old_icon = nil
	end

	local material_values = widget.style.icon.material_values
	widget.style.icon.material_values.texture_icon = nil
	material_values.use_placeholder_texture = 1
	material_values.use_render_target = 0
end

local function _apply_live_item_icon_cb_func(widget, grid_index, rows, columns, render_target)
	local material_values = widget.style.icon.material_values
	material_values.use_placeholder_texture = 0
	material_values.use_render_target = 1
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.render_target = render_target
end

local function _remove_live_item_icon_cb_func(widget, ui_renderer)
	local material_values = widget.style.icon.material_values
	material_values.use_placeholder_texture = 1
	material_values.texture_icon = nil
	material_values.use_render_target = 0

	if ui_renderer then
		UIWidget.set_visible(widget, ui_renderer, false)
		UIWidget.set_visible(widget, ui_renderer, true)
	end
end

local ConstantElementNotificationFeed = class("ConstantElementNotificationFeed", "ConstantElementBase")
local MESSAGE_TYPES = table.enum("default", "alert", "mission", "item_granted", "currency", "achievement", "contract", "custom", "voting", "matchmaking")

ConstantElementNotificationFeed.init = function (self, parent, draw_layer, start_scale)
	ConstantElementNotificationFeed.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._notifications = {}
	self._queue_notifications = {}
	self._notification_message_delay_queue = {}
	self._num_notifications = 0
	self._notification_id_counter = 0
	self._notification_templates = {
		default = {
			animation_exit = "popup_leave",
			animation_enter = "popup_enter",
			total_time = 5,
			priority_order = 2,
			widget_definition = Definitions.notification_message
		},
		alert = {
			animation_exit = "popup_leave",
			animation_enter = "popup_enter",
			total_time = 5,
			priority_order = 1,
			widget_definition = Definitions.notification_message
		},
		mission = {
			animation_exit = "popup_leave",
			animation_enter = "popup_enter",
			priority_order = 1,
			widget_definition = Definitions.notification_message
		},
		item_granted = {
			animation_exit = "popup_leave",
			animation_enter = "popup_enter",
			total_time = 5,
			priority_order = 1,
			widget_definition = Definitions.notification_message
		},
		currency = {
			animation_exit = "popup_leave",
			animation_enter = "popup_enter",
			total_time = 5,
			priority_order = 1,
			widget_definition = Definitions.notification_message
		},
		contract = {
			animation_exit = "popup_leave",
			animation_enter = "popup_enter",
			total_time = 5,
			priority_order = 1,
			widget_definition = Definitions.notification_message
		},
		achievement = {
			animation_exit = "popup_leave",
			animation_enter = "popup_enter",
			total_time = 5,
			priority_order = 1,
			widget_definition = Definitions.notification_message
		},
		custom = {
			animation_exit = "popup_leave",
			animation_enter = "popup_enter",
			total_time = 5,
			priority_order = 1,
			widget_definition = Definitions.notification_message
		},
		matchmaking = {
			animation_exit = "popup_leave",
			animation_enter = "popup_enter",
			priority_order = 1,
			widget_definition = Definitions.notification_message
		},
		voting = {
			animation_exit = "popup_leave",
			animation_enter = "popup_enter",
			priority_order = 1,
			widget_definition = Definitions.notification_message
		}
	}
	self._crafting_pickup_notifications_enabled = true
	local event_manager = Managers.event
	local events = ConstantElementNotificationFeedSettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:register(self, event[1], event[2])
	end

	event_manager:register(self, "event_player_authenticated", "_event_player_authenticated")
end

ConstantElementNotificationFeed._event_player_authenticated = function (self)
	local save_manager = Managers.save
	local crafting_pickup_notifications_enabled = true

	if save_manager then
		local account_data = save_manager:account_data()
		crafting_pickup_notifications_enabled = account_data.interface_settings.show_crafting_pickup_notification
	end

	self._crafting_pickup_notifications_enabled = crafting_pickup_notifications_enabled
end

ConstantElementNotificationFeed._on_item_icon_loaded = function (self, notification, item, grid_index, rows, columns, render_target)
	local widget = notification.widget
	local item_type = item.item_type

	if item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED" or item_type == "GADGET" or item_type == "WEAPON_SKIN" or item_type == "WEAPON_TRINKET" then
		_apply_live_item_icon_cb_func(widget, grid_index, rows, columns, render_target)
	elseif item_type == "PORTRAIT_FRAME" or item_type == "CHARACTER_INSIGNIA" then
		_apply_package_item_icon_cb_func(widget, item)
	else
		_apply_live_item_icon_cb_func(widget, grid_index, rows, columns, render_target)
	end
end

ConstantElementNotificationFeed.event_update_show_crafting_pickup_notification = function (self, value)
	self._crafting_pickup_notifications_enabled = value
end

ConstantElementNotificationFeed.event_add_notification_message = function (self, message_type, data, callback, sound_event, done_callback, delay)
	if delay then
		self._notification_message_delay_queue[#self._notification_message_delay_queue + 1] = {
			message_type = message_type,
			data = data,
			callback = callback,
			sound_event = sound_event,
			done_callback = done_callback,
			delay = delay
		}
	else
		self:_add_notification_message(message_type, data, callback, sound_event, done_callback)
	end
end

ConstantElementNotificationFeed.event_update_notification_message = function (self, notification_id, texts)
	local notification = self:_notification_by_id(notification_id)

	if notification then
		self:_set_texts(notification, texts)
	end
end

ConstantElementNotificationFeed._set_texts = function (self, notification, texts)
	local widget = notification.widget

	for i = 1, #texts do
		local text = texts[i]
		widget.content[string.format("text_%d", i)] = text
	end
end

ConstantElementNotificationFeed.event_remove_notification = function (self, notification_id)
	local notification = self:_notification_by_id(notification_id)

	if notification then
		notification.total_time = 0
		notification.time = 0
	end
end

ConstantElementNotificationFeed.event_clear_notifications = function (self)
	self:clear()
end

ConstantElementNotificationFeed._get_new_id = function (self)
	self._notification_id_counter = self._notification_id_counter + 1

	return self._notification_id_counter
end

ConstantElementNotificationFeed.clear = function (self)
	while #self._notifications > 0 do
		local notification = self._notifications[1]

		self:_remove_notification(notification)
	end
end

ConstantElementNotificationFeed.destroy = function (self)
	ConstantElementNotificationFeed.super.destroy(self)

	local event_manager = Managers.event
	local events = ConstantElementNotificationFeedSettings.events

	for i = 1, #events do
		local event = events[i]

		event_manager:unregister(self, event[1])
	end

	event_manager:unregister(self, "event_player_authenticated")
end

ConstantElementNotificationFeed._generate_notification_data = function (self, message_type, data)
	local notification_data = nil

	if message_type == MESSAGE_TYPES.default then
		notification_data = {
			texts = {
				{
					display_name = data
				}
			}
		}
	elseif message_type == MESSAGE_TYPES.mission then
		notification_data = {
			texts = {
				{
					display_name = data
				}
			}
		}
	elseif message_type == MESSAGE_TYPES.alert then
		slot4 = {
			texts = {
				{
					display_name = data.text,
					color = {
						255,
						255,
						101,
						101
					}
				}
			},
			color = {
				255 * ConstantElementNotificationFeedSettings.default_alpha_value,
				85,
				26,
				26
			},
			line_color = {
				255,
				255,
				101,
				101
			}
		}

		if data.type == "server" then
			-- Nothing
		end

		slot4.icon_color = {
			255,
			255,
			208,
			208
		}
		slot4.enter_sound_event = UISoundEvents.notification_warning
		notification_data = slot4
	elseif message_type == MESSAGE_TYPES.item_granted then
		local item = data
		local item_type = item.item_type
		local visual_item = item
		local has_rarity = not not visual_item.rarity
		local texts, rarity_color, background_rarity_color = nil
		local enter_sound_event = UISoundEvents.notification_item_received_rarity_1
		local icon_material_values = nil

		if has_rarity then
			local sound_event_name = string.format("notification_item_received_rarity_%d", visual_item.rarity)
			enter_sound_event = UISoundEvents[sound_event_name] or enter_sound_event
			rarity_color, background_rarity_color = ItemUtils.rarity_color(visual_item)
			rarity_color = table.clone(rarity_color)
			texts = {
				{
					display_name = ItemUtils.display_name(visual_item),
					color = rarity_color
				},
				{
					display_name = ItemUtils.rarity_display_name(data),
					color = rarity_color
				},
				{
					display_name = Localize("loc_notification_desc_added_to_inventory")
				}
			}
		else
			if item_type == "WEAPON_SKIN" then
				enter_sound_event = UISoundEvents.notification_weapon_skin_received
			elseif item_type == "GEAR_EXTRA_COSMETIC" or item_type == "GEAR_HEAD" or item_type == "GEAR_UPPERBODY" or item_type == "GEAR_LOWERBODY" then
				enter_sound_event = UISoundEvents.notification_cosmetic_received
			end

			texts = {
				{
					display_name = ItemUtils.display_name(visual_item)
				},
				{
					display_name = Localize(UISettings.item_type_localization_lookup[visual_item.item_type]),
					color = Color.terminal_frame(255, true)
				},
				{
					display_name = Localize("loc_notification_desc_added_to_inventory")
				}
			}
		end

		local icon, icon_size = nil

		if item_type == "PORTRAIT_FRAME" then
			icon = "content/ui/materials/icons/items/containers/item_container_square"
			icon_size = "portrait_frame"
		elseif item_type == "CHARACTER_INSIGNIA" then
			icon = "content/ui/materials/icons/items/containers/item_container_square"
			icon_size = "insignia"
		elseif item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED" or item_type == "WEAPON_TRINKET" then
			icon = "content/ui/materials/icons/items/containers/item_container_landscape"
			icon_size = "large_weapon"
		elseif item_type == "WEAPON_SKIN" then
			icon = "content/ui/materials/icons/items/containers/item_container_landscape"
			icon_size = "weapon_skin"
		elseif item_type == "GADGET" then
			icon = "content/ui/materials/icons/items/containers/item_container_landscape"
			icon_size = "large_gadget"
		elseif item_type == "TRAIT" then
			icon = "content/ui/materials/icons/traits/traits_container"
			icon_size = "medium"
			local rarity = visual_item.rarity
			local texture_icon, texture_frame = ItemUtils.trait_textures(visual_item, rarity)
			icon_material_values = {
				icon = texture_icon,
				frame = texture_frame
			}
			local trait_sound_events_by_rarity = ConstantElementNotificationFeedSettings.trait_sound_events_by_rarity
			enter_sound_event = trait_sound_events_by_rarity[rarity]
		else
			icon = "content/ui/materials/icons/items/containers/item_container_landscape"
			icon_size = "large_cosmetic"
		end

		if background_rarity_color then
			background_rarity_color = table.clone(background_rarity_color)
			background_rarity_color[1] = background_rarity_color[1] * ConstantElementNotificationFeedSettings.default_alpha_value
		end

		notification_data = {
			show_shine = true,
			glow_opacity = 0.35,
			scale_icon = true,
			texts = texts,
			icon = icon,
			item = visual_item,
			icon_size = icon_size,
			icon_material_values = icon_material_values,
			color = background_rarity_color,
			line_color = rarity_color,
			enter_sound_event = enter_sound_event
		}
	elseif message_type == MESSAGE_TYPES.currency and self:_can_show_currency_of_type(data.currency) then
		local currency_type = data.currency
		local amount = data.amount
		local amount_size = data.amount_size
		local player_name = data.player_name
		local optional_localization_key = data.optional_localization_key
		local wallet_settings = WalletSettings[currency_type]
		local ignore_wallet_display_name = false

		if amount_size and type(amount_size) == "string" and wallet_settings then
			local pickup_localization_by_size = wallet_settings.pickup_localization_by_size
			local localization_key = pickup_localization_by_size[amount_size]
			amount_size = Localize(localization_key)
			ignore_wallet_display_name = true
		end

		if wallet_settings then
			local icon_texture_large = wallet_settings and wallet_settings.icon_texture_big
			local selected_color = Color.terminal_corner_selected(255, true)
			amount = string.format("{#color(%d,%d,%d)}%s %s{#reset()}", selected_color[2], selected_color[3], selected_color[4], amount_size or TextUtils.format_currency(amount), not ignore_wallet_display_name and Localize(wallet_settings.display_name) or "")
			local text = Localize(optional_localization_key or "loc_notification_feed_currency_acquired", true, {
				amount = amount,
				player_name = player_name
			})
			local enter_sound_event = wallet_settings.notification_sound_event
			notification_data = {
				icon_size = "currency",
				texts = {
					{
						display_name = text
					}
				},
				icon = icon_texture_large,
				color = Color.terminal_grid_background(100, true),
				enter_sound_event = enter_sound_event
			}
		end
	elseif message_type == MESSAGE_TYPES.achievement then
		local achievement_title = AchievementUIHelper.localized_title(data)
		notification_data = {
			icon_size = "medium",
			icon = "content/ui/materials/icons/achievements/achievement_icon_container",
			texts = {
				{
					display_name = string.format("\"%s\"", achievement_title),
					color = {
						255,
						248,
						240,
						222
					}
				},
				{
					display_name = Localize("loc_notification_desc_achievement_completed"),
					color = {
						255,
						200,
						182,
						149
					}
				}
			},
			icon_material_values = {
				frame = "content/ui/textures/icons/achievements/frames/achieved",
				icon = data.icon,
				icon_color = Color.ui_achievement_icon_completed(255, true)
			},
			line_color = {
				255,
				200,
				182,
				149
			},
			color = {
				255 * ConstantElementNotificationFeedSettings.default_alpha_value,
				82,
				73,
				45
			},
			enter_sound_event = UISoundEvents.notification_achievement
		}
	elseif message_type == MESSAGE_TYPES.contract then
		local criteria = data.criteria
		local title, _, _ = ContractCriteriaParser.localize_criteria(criteria)
		local type = criteria.taskType
		notification_data = {
			icon = "content/ui/materials/icons/contracts/contract_task",
			icon_size = "medium",
			texts = {
				{
					display_name = title,
					color = Color.terminal_corner_selected(255, true)
				},
				{
					display_name = Localize("loc_notification_desc_contract_task_completed")
				}
			},
			icon_material_values = {
				checkbox = 1,
				contract_type = type and UISettings.contracts_icons_by_type[type] or UISettings.contracts_icons_by_type.default
			},
			icon_color = Color.terminal_text_header(255, true)
		}
	elseif message_type == MESSAGE_TYPES.custom then
		notification_data = {
			texts = {
				{
					display_name = data.line_1,
					color = data.line_1_color
				},
				{
					display_name = data.line_2,
					color = data.line_2_color
				},
				{
					display_name = data.line_3,
					color = data.line_3_color
				}
			},
			icon = data.icon,
			icon_size = data.icon_size,
			color = data.color,
			line_color = data.line_color,
			icon_color = data.icon_color,
			glow_opacity = data.glow_opacity or 0,
			show_shine = data.show_shine or false,
			scale_icon = data.scale_icon or false
		}
	elseif message_type == MESSAGE_TYPES.matchmaking then
		notification_data = {
			texts = {
				{
					display_name = data.texts[1],
					color = {
						255,
						200,
						200,
						200
					}
				},
				{
					font_size = 18,
					display_name = data.texts[2],
					color = {
						255,
						140,
						140,
						140
					}
				},
				{
					display_name = data.texts[3],
					color = {
						255,
						200,
						182,
						149
					}
				}
			}
		}
	elseif message_type == MESSAGE_TYPES.voting then
		notification_data = {
			texts = {
				{
					font_size = 22,
					display_name = data.texts[1],
					color = {
						255,
						232,
						238,
						219
					}
				},
				{
					font_size = 20,
					display_name = data.texts[2],
					color = Color.text_default(255, true)
				},
				{
					font_size = 20,
					display_name = data.texts[3],
					color = Color.text_default(255, true)
				}
			}
		}
	end

	if not notification_data then
		return
	end

	notification_data.type = message_type
	notification_data.enter_sound_event = notification_data.enter_sound_event or UISoundEvents.notification_default_enter
	notification_data.exit_sound_event = notification_data.exit_sound_event or UISoundEvents.notification_default_exit

	return notification_data
end

ConstantElementNotificationFeed._can_show_currency_of_type = function (self, currency_type)
	if currency_type ~= "plasteel" and currency_type ~= "diamantine" then
		return true
	end

	return self._crafting_pickup_notifications_enabled
end

ConstantElementNotificationFeed._add_notification_message = function (self, message_type, data, callback, sound_event, done_callback)
	local notifications = self._notifications
	local num_notifications = #notifications

	if ConstantElementNotificationFeedSettings.max_visible_notifications <= num_notifications then
		self._queue_notifications[#self._queue_notifications + 1] = {
			message_type = message_type,
			data = data,
			callback = callback,
			done_callback = done_callback,
			sound_event = sound_event
		}

		self:_update_notification_queue_counter()

		return
	end

	local notification_data = self:_generate_notification_data(message_type, data)

	if notification_data then
		local notification = self:_create_notification_entry(notification_data)
		local notification_id = notification.id
		notification.done_callback = done_callback

		if callback then
			callback(notification_id)
		end

		if notification.animation_enter then
			sound_event = sound_event or notification.enter_sound_event

			if sound_event then
				Managers.ui:play_2d_sound(sound_event)
			end

			self:_start_animation(notification.animation_enter, notification.widget)
		end
	end
end

ConstantElementNotificationFeed._remove_notification = function (self, notification_to_remove, ui_renderer)
	local notifications = self._notifications

	for i = 1, #notifications do
		local notification = notifications[i]
		local data = notification and notification.data
		local widget = notification_to_remove.widget

		if notification == notification_to_remove then
			if data.item then
				local item = data.item
				local item_type = item.item_type

				if item_type == "PORTRAIT_FRAME" or item_type == "CHARACTER_INSIGNIA" then
					_remove_package_item_icon_cb_func(widget, ui_renderer)
				else
					_remove_live_item_icon_cb_func(widget, ui_renderer)
				end
			end

			if notification.item_loaded_info then
				local item_loaded_info = notification.item_loaded_info
				local icon_load_id = item_loaded_info.icon_load_id

				Managers.ui:unload_item_icon(icon_load_id)

				notification.item_loaded_info = nil
			end

			self:_unregister_widget_name(widget.name)
			UIWidget.destroy(ui_renderer, widget)
			table.remove(notifications, i)

			local done_callback = notification.done_callback

			if done_callback then
				done_callback()
			end

			if self._queue_notifications[1] and ConstantElementNotificationFeedSettings.max_visible_notifications > #self._notifications then
				local notification = self._queue_notifications[1]
				local message_type = notification.message_type
				local data = notification.data
				local callback = notification.callback
				local sound_event = notification.sound_event

				self:_add_notification_message(message_type, data, callback, sound_event)
				table.remove(self._queue_notifications, 1)
				self:_update_notification_queue_counter()
			end
		end
	end
end

ConstantElementNotificationFeed._create_notification_entry = function (self, notification_data)
	local notification_type = notification_data.type
	local notification_template = self._notification_templates[notification_type]
	local priority_order = notification_template.priority_order
	local id = self:_get_new_id()
	local name = "notification_" .. id
	local pass_template_function = notification_template.widget_definition.pass_template_function
	local pass_template = pass_template_function and pass_template_function(self) or notification_template.widget_definition.pass_template
	local widget_definition = UIWidget.create_definition(pass_template, "background", nil)
	local widget = self:_create_widget(name, widget_definition)
	local notification = {
		priority_order = notification_template.priority_order,
		total_time = notification_template.total_time,
		widget = widget,
		id = id,
		time = 0,
		data = notification_data,
		animation_enter = notification_template.animation_enter,
		animation_exit = notification_template.animation_exit,
		enter_sound_event = notification_data.enter_sound_event,
		exit_sound_event = notification_data.exit_sound_event
	}
	local notifications = self._notifications
	local num_notifications = #notifications
	local init = notification_template.widget_definition.init

	if init then
		init(self, widget, notification_data)
	end

	local item = notification_data.item

	if item then
		local slots = item.slots

		if slots then
			local slot_name = slots[1]
			local item_state_machine = item.state_machine
			local item_animation_event = item.animation_event
			local context = {
				camera_focus_slot_name = slot_name,
				state_machine = item_state_machine,
				animation_event = item_animation_event
			}
			local on_load_callback = callback(self, "_on_item_icon_loaded", notification, item)
			local icon_load_id = Managers.ui:load_item_icon(item, on_load_callback, context)
			notification.item_loaded_info = {
				icon_load_id = icon_load_id
			}
		end
	end

	local start_index = nil

	if num_notifications > 0 then
		for i = 1, num_notifications do
			if priority_order <= notifications[i].priority_order then
				start_index = i

				break
			elseif i == num_notifications then
				start_index = i + 1
			end
		end
	end

	start_index = start_index or 1
	local start_height = self:_get_height_of_notification_index(start_index)

	self:_set_widget_position(widget, nil, start_height)
	table.insert(notifications, start_index, notification)

	return notification
end

ConstantElementNotificationFeed._notification_by_id = function (self, notification_id)
	local notifications = self._notifications

	for i = 1, #notifications do
		local notification = notifications[i]

		if notification.id == notification_id then
			return notification
		end
	end
end

ConstantElementNotificationFeed._get_notifications_text_height = function (self, notification, ui_renderer)
	local widget = notification.widget
	local content = widget.content
	local text = content.text
	local style = widget.style
	local text_style = style.text
	local text_font_data = UIFonts.data_by_type(text_style.font_type)
	local text_font = text_font_data.path
	local text_size = text_style.size
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local _, text_height = UIRenderer.text_size(ui_renderer, text, text_style.font_type, text_style.font_size, text_size, text_options)

	return text_height
end

ConstantElementNotificationFeed.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	if DEBUG_RELOAD then
		DEBUG_RELOAD = false

		self:clear()
	end

	local notification_message_delay_queue = self._notification_message_delay_queue

	for i = #notification_message_delay_queue, 1, -1 do
		local message_data = notification_message_delay_queue[i]
		local delay = message_data.delay

		if delay <= 0 then
			local message_type = message_data.message_type
			local data = message_data.data
			local callback = message_data.callback
			local sound_event = message_data.sound_event
			local done_callback = message_data.done_callback

			self:_add_notification_message(message_type, data, callback, sound_event, done_callback)
			table.remove(notification_message_delay_queue, i)
		else
			message_data.delay = delay - dt
		end
	end

	self:_align_notification_widgets(dt)
	ConstantElementNotificationFeed.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

ConstantElementNotificationFeed._align_notification_widgets = function (self, dt)
	local entry_spacing = ConstantElementNotificationFeedSettings.entry_spacing
	local offset_y = 0
	local notifications = self._notifications

	for i = 1, #notifications do
		local notification = notifications[i]

		if notification then
			local widget = notification.widget
			local widget_offset = widget.offset
			local widget_height = widget.size[2]

			if widget_offset[2] < offset_y then
				widget_offset[2] = math.lerp(widget_offset[2], offset_y, dt * 6)
			else
				widget_offset[2] = math.lerp(widget_offset[2], offset_y, dt * 2)
			end

			offset_y = offset_y + widget_height + entry_spacing
		end
	end
end

ConstantElementNotificationFeed._get_height_of_notification_index = function (self, index)
	local notifications = self._notifications
	local notification = notifications[index - 1]

	if not notification then
		return 0
	else
		local widget = notification.widget
		local widget_offset = widget.offset

		return widget_offset[2]
	end
end

ConstantElementNotificationFeed._set_widget_position = function (self, widget, x, y)
	local widget_offset = widget.offset

	if x then
		widget_offset[1] = x
	end

	if y then
		widget_offset[2] = y
	end
end

ConstantElementNotificationFeed._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ConstantElementNotificationFeed.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local notifications = self._notifications

	for i = #notifications, 1, -1 do
		local notification = notifications[i]

		if notification then
			notification.time = (notification.time or 0) + dt
			local widget = notification.widget

			UIWidget.draw(widget, ui_renderer)

			local total_time = notification.total_time
			local time = notification.time

			if time and total_time and total_time <= time then
				self:_evaluate_notification_removal(notification, ui_renderer)
			end
		end
	end
end

ConstantElementNotificationFeed._evaluate_notification_removal = function (self, notification, ui_renderer)
	local widget = notification.widget

	if notification.animation_exit_id and not self:_is_animation_completed(notification.animation_exit_id) then
		return
	elseif notification.animation_exit and not notification.animation_exit_id then
		local sound_event = notification.exit_sound_event

		if sound_event then
			Managers.ui:play_2d_sound(sound_event)
		end

		notification.animation_exit_id = self:_start_animation(notification.animation_exit, widget)
	else
		notification.animation_exit_id = nil

		self:_remove_notification(notification, ui_renderer)
	end
end

ConstantElementNotificationFeed._update_notification_queue_counter = function (self)
	self._widgets_by_name.queue_notification_counter.content.visible = #self._queue_notifications > 0
	self._widgets_by_name.queue_notification_counter.content.queue_counter = Localize("loc_notification_queue_more", true, {
		queue = #self._queue_notifications
	})
end

return ConstantElementNotificationFeed
