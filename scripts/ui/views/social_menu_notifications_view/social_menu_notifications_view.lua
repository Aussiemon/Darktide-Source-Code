local definition_path = "scripts/ui/views/social_menu_notifications_view/social_menu_notifications_view_definitions"
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local ViewStyles = require("scripts/ui/views/social_menu_notifications_view/social_menu_notifications_view_styles")
local SocialMenuNotificationsView = class("SocialMenuNotificationsView", "BaseView")

SocialMenuNotificationsView.init = function (self, settings, context)
	local definitions = require(definition_path)

	SocialMenuNotificationsView.super.init(self, definitions, settings)

	self._pass_input = true
	self._parent = context and context.parent

	if self._parent then
		self._parent:set_active_view_instance(self)
	end
end

SocialMenuNotificationsView.on_enter = function (self)
	SocialMenuNotificationsView.super.on_enter(self)
	self:_populate_data()
end

SocialMenuNotificationsView.update = function (self, dt, t, input_service)
	if self._grid then
		self:_update_notification_widgets(dt, input_service)
		self._grid:update(dt, t, input_service)
	end

	return SocialMenuNotificationsView.super.update(self, dt, t, input_service)
end

SocialMenuNotificationsView.draw = function (self, dt, t, input_service, layer)
	SocialMenuNotificationsView.super.draw(self, dt, t, input_service, layer)
end

SocialMenuNotificationsView.cb_remove_notification = function (self, notification)
	return
end

SocialMenuNotificationsView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	SocialMenuNotificationsView.super._draw_widgets(self, dt, t, input_service, ui_renderer)

	if self._grid then
		self:_draw_grid_widgets(dt, t, input_service, ui_renderer)
	end
end

SocialMenuNotificationsView._populate_data = function (self)
	self:_set_dummy_data(5)
	self:_setup_notifications_grid()
end

SocialMenuNotificationsView._setup_notifications_grid = function (self)
	local widgets, alignment_widgets = self:_create_notification_widgets()
	self._grid_widgets = widgets
	self._grid_alignment_widgets = alignment_widgets
	local grid_scenegraph_id = "grid"
	local grid_spacing = ViewStyles.grid_spacing
	local grid_direction = "down"
	local grid = UIWidgetGrid:new(widgets, alignment_widgets, self._ui_scenegraph, grid_scenegraph_id, grid_direction, grid_spacing)
	self._grid = grid
end

SocialMenuNotificationsView._create_notification_widgets = function (self)
	self:_clear_widgets(self._grid_widgets)
	self:_clear_widgets(self._grid_alignment_widgets)

	local widgets = {}
	local alignment_widgets = {}
	local notification_data = self._notification_data
	local notifications = notification_data.notifications
	local server_time = notification_data.server_time
	local blueprints = self._definitions.notification_blueprints
	local notification_types = self._definitions.notification_types

	for i = 1, #notifications do
		local notification = notifications[i]
		local type_settings = notification_types[notification.notification_type]
		local blueprint_name = type_settings.blueprint
		local blueprint = blueprints[blueprint_name]
		local name = "notification_" .. i
		local new_widget = self:_create_widget(name, blueprint.widget_definition)

		blueprint.init(self, new_widget, notification, type_settings, server_time)

		widgets[#widgets + 1] = new_widget
		alignment_widgets[#alignment_widgets + 1] = new_widget
	end

	return widgets, alignment_widgets
end

SocialMenuNotificationsView._clear_widgets = function (self, widgets)
	if widgets then
		for i = 1, #widgets do
			local widget = widgets[i]
			local widget_name = widget.name

			if self:has_widget(widget_name) then
				self:_unregister_widget_name(widget_name)
			end
		end
	end
end

SocialMenuNotificationsView._update_notification_widgets = function (self, dt, input_service)
	local widgets = self._grid_widgets
	local seconds_in_a_minute = 60
	local seconds_in_an_hour = seconds_in_a_minute * 60
	local seconds_in_a_day = seconds_in_an_hour * 24

	for i = 1, #widgets do
		local widget = widgets[i]
		local widget_content = widget.content
		local age = widget_content.age + dt
		local age_formatted = nil

		if seconds_in_a_day < age then
			local days = math.floor(age / seconds_in_a_day)
			age_formatted = self:_localize("loc_social_menu_notifications_age_days", true, {
				days = days
			})
		elseif seconds_in_an_hour < age then
			local hours = math.floor(age / seconds_in_an_hour)
			age_formatted = self:_localize("loc_social_menu_notifications_age_hours", true, {
				hours = hours
			})
		elseif seconds_in_a_minute < age then
			local minutes = math.floor(age / seconds_in_a_minute)
			age_formatted = self:_localize("loc_social_menu_notifications_age_minutes", true, {
				minutes = minutes
			})
		else
			age_formatted = self:_localize("loc_social_menu_notifications_age_seconds")
		end

		widget_content.age = age
		widget_content.age_formatted = age_formatted
		local hotspot = widget_content.hotspot

		if hotspot.is_hover or hotspot.is_selected then
			widget_content.data.is_read = true
		end
	end
end

SocialMenuNotificationsView._draw_grid_widgets = function (self, dt, t, input_service, ui_renderer)
	local grid = self._grid
	local grid_widgets = self._grid_widgets

	for i = 1, #grid_widgets do
		local widget = grid_widgets[i]

		if grid:is_widget_visible(widget) then
			UIWidget.draw(widget, ui_renderer)
		end
	end
end

local FirstNameParts = {
	"Rouge",
	"Red",
	"Furious",
	"Lame",
	"SlightlyGreyish",
	"Drunken",
	"Baby",
	"Deadly",
	"Green",
	"Milk",
	"Digital",
	"Dog",
	"SWAT"
}
local SecondNameParts = {
	"Killer",
	"Psycho",
	"Eyes",
	"Grapefruit",
	"Monster",
	"Accountant",
	"Cleaner",
	"Stereoids",
	"Monday",
	"Baby",
	"Ribbon",
	"Sting",
	"Swatter",
	"Driver",
	"Postman",
	"Magic"
}
local GuildNames = {
	"A Clan",
	"Awesome Gang",
	"Lead And Guild",
	"The misfits",
	"Kindergarden",
	"Nobles and Pirates"
}

SocialMenuNotificationsView._generate_random_notification = function (self, order, last_used_time_stamp)
	local notification_types = self._definitions.notification_types
	local notification_type = nil
	local n = 0

	for type_name in pairs(notification_types) do
		n = n + 1

		if math.random() < 1 / n then
			notification_type = type_name
		end
	end

	local time_since_last_message = math.floor(math.random() * math.max(order - 2, 0) * 24 * 3600 + math.random() * (order - 1) * 3600 + math.random() * order * 60)

	return {
		is_read = math.random() > 1 / order,
		notification_type = notification_type,
		requesting_player = FirstNameParts[math.random(#FirstNameParts)] .. SecondNameParts[math.random(#SecondNameParts)],
		clan = GuildNames[math.random(#GuildNames)],
		time = last_used_time_stamp - time_since_last_message
	}
end

SocialMenuNotificationsView._set_dummy_data = function (self, num_items)
	local dummy_data = self._notification_data

	if not dummy_data then
		dummy_data = {
			notifications = {}
		}
		self._notification_data = dummy_data
	end

	dummy_data.server_time = os.time()
	num_items = num_items or math.floor(math.random() * 1.05)
	local last_used_time_stamp = dummy_data.server_time

	for i = 1, num_items do
		local random_notification = self:_generate_random_notification(i, last_used_time_stamp)
		dummy_data.notifications[i] = random_notification
		last_used_time_stamp = random_notification.time
	end

	return dummy_data
end

return SocialMenuNotificationsView
