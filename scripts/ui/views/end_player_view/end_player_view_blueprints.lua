-- chunkname: @scripts/ui/views/end_player_view/end_player_view_blueprints.lua

local Colors = require("scripts/utilities/ui/colors")
local Items = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local RaritySettings = require("scripts/settings/item/rarity_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewSettings = require("scripts/ui/views/end_player_view/end_player_view_settings")
local ViewStyles = require("scripts/ui/views/end_player_view/end_player_view_styles")
local WalletSettings = require("scripts/settings/wallet_settings")
local Text = require("scripts/utilities/ui/text")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local ExpeditionService = require("scripts/managers/data_service/services/expedition_service")
local blueprint_styles = ViewStyles.blueprints
local ITEM_TYPES = UISettings.ITEM_TYPES
local folded_card_size = {
	ViewStyles.card_width,
	ViewStyles.card_folded_height,
}
local EXPEDITION_UNLOCK_TYPE = ExpeditionService.UNLOCK_TYPE
local end_player_view_blueprints = {}

local function _card_default_frame_visibility_function(content, style)
	return style.color[1] > 0
end

local function _get_card_default_frame_pass_template()
	local card_frame_pass_template = {
		{
			pass_type = "texture",
			style_id = "frame_default_top",
			value = "content/ui/materials/frames/end_of_round/reward_default_upper",
			value_id = "frame_default_top",
			visibility_function = _card_default_frame_visibility_function,
		},
		{
			pass_type = "texture",
			style_id = "frame_default_middle",
			value = "content/ui/materials/frames/end_of_round/reward_default_middle",
			value_id = "frame_default_middle",
			visibility_function = _card_default_frame_visibility_function,
		},
		{
			pass_type = "texture",
			style_id = "frame_default_bottom",
			value = "content/ui/materials/frames/end_of_round/reward_default_lower",
			value_id = "frame_default_bottom",
			visibility_function = _card_default_frame_visibility_function,
		},
		{
			pass_type = "rect",
			style_id = "background_rect",
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "background",
		},
		{
			pass_type = "text",
			style_id = "label",
			value = "",
			value_id = "label",
		},
	}

	return card_frame_pass_template
end

local function _card_default_frame_pass_template_init(widget, index)
	local style = widget.style

	widget.alpha_multiplier = 0
	widget.offset[1] = index * ViewStyles.card_offset_x

	local frame_color = table.clone(style.dimmed_out_color)

	style.frame_default_top.color = frame_color
	style.frame_default_middle.color = frame_color
	style.frame_default_bottom.color = frame_color
	style.frame_color = frame_color
	style.text_color = table.clone(style.in_focus_text_color)
end

local function _get_card_levelup_frame_pass_template()
	local card_frame_pass_template = _get_card_default_frame_pass_template()
	local levelup_frame_pass_template = {
		{
			pass_type = "texture",
			style_id = "frame_levelup_top",
			value = "content/ui/materials/frames/end_of_round/reward_levelup_upper",
			value_id = "frame_levelup_top",
			visibility_function = _card_default_frame_visibility_function,
		},
		{
			pass_type = "texture",
			style_id = "frame_levelup_bottom",
			value = "content/ui/materials/frames/end_of_round/reward_levelup_lower",
			value_id = "frame_levelup_bottom",
			visibility_function = _card_default_frame_visibility_function,
		},
		{
			pass_type = "texture",
			style_id = "frame_levelup_effect",
			value = "content/ui/materials/effects/end_of_round/level_up_frame",
			value_id = "frame_levelup_effect",
			visibility_function = _card_default_frame_visibility_function,
		},
		{
			pass_type = "texture",
			style_id = "spires",
			value = "content/ui/materials/frames/end_of_round/reward_levelup_upper_spikes",
			value_id = "spires",
		},
		{
			pass_type = "texture",
			style_id = "frame_detail",
			value = "content/ui/materials/frames/end_of_round/reward_levelup_upper_skull",
			value_id = "frame_detail",
		},
	}

	table.append(card_frame_pass_template, levelup_frame_pass_template)

	return card_frame_pass_template
end

local function _card_levelup_frame_pass_template_init(widget, index)
	_card_default_frame_pass_template_init(widget, index)

	local style = widget.style
	local frame_color = table.clone(style.start_color)

	style.frame_levelup_top.color = frame_color
	style.frame_levelup_bottom.color = frame_color
	style.spires.color = frame_color
	style.frame_detail.color = frame_color
	style.levelup_frame_color = frame_color
end

local function _get_currency_icon(pass_template, currency)
	local background_id, icon_id, icon_material

	if currency == "experience" then
		background_id = "experience_icon_background"
		icon_id = "experience_icon"
		icon_material = "content/ui/materials/icons/currencies/experience_big"
	elseif currency then
		background_id = currency .. "_icon_background"
		icon_id = currency .. "_icon"

		local wallet_settings = WalletSettings[currency]

		icon_material = wallet_settings and wallet_settings.icon_texture_big
	else
		background_id = "icon_background"
		icon_id = "icon"
	end

	pass_template[#pass_template + 1] = {
		pass_type = "texture",
		value = "content/ui/materials/effects/end_of_round/reward_background",
		value_id = "icon_background",
		style_id = background_id,
	}
	pass_template[#pass_template + 1] = {
		pass_type = "texture",
		value_id = icon_id,
		style_id = icon_id,
		value = icon_material,
	}
end

local function _get_stat_pass_template(pass_template, stat, label, row_type, offset_y)
	local card_content_styles = blueprint_styles.card_content
	local last_index = #pass_template

	if not offset_y then
		local previous_row_style = pass_template[last_index].style

		offset_y = previous_row_style.offset[2] + previous_row_style.size[2]
	end

	local next_index = pass_template[last_index].is_empty_row and last_index or last_index + 1
	local label_style = row_type == "small" and table.clone(card_content_styles.text_small) or table.clone(card_content_styles.text_normal)

	label_style.offset[2] = offset_y
	pass_template[next_index] = {
		pass_type = "text",
		value_id = stat .. "_label",
		style_id = stat .. "_label",
		value = Localize(label),
		style = label_style,
	}

	local value_style = table.clone(label_style)

	value_style.text_horizontal_alignment = "right"
	next_index = next_index + 1
	pass_template[next_index] = {
		pass_type = "text",
		value = "0",
		value_id = stat .. "_text",
		style_id = stat,
		style = value_style,
	}
end

local function _get_item_pass_templates(pass_template, item_data)
	local item_group = item_data.item_group
	local icon_material

	icon_material = item_group == "nameplates" and "content/ui/materials/icons/items/containers/item_container_square" or "content/ui/materials/icons/items/containers/item_container_landscape"

	if not icon_material then
		return
	end

	table.append(pass_template, {
		{
			pass_type = "text",
			style_id = "item_display_name",
			value_id = "item_display_name",
		},
		{
			pass_type = "texture",
			style_id = "item_icon",
			value = "content/ui/materials/icons/items/containers/item_container_landscape",
			value_id = "item_icon",
		},
		{
			pass_type = "text",
			style_id = "item_sub_display_name",
			value_id = "item_sub_display_name",
		},
		{
			pass_type = "text",
			style_id = "item_level",
			value = "",
			value_id = "item_level",
		},
		{
			pass_type = "text",
			style_id = "added_to_inventory_text",
			value_id = "added_to_inventory_text",
			value = Localize("loc_notification_desc_added_to_inventory"),
		},
	})
end

local function _get_item_pass_styles(pass_style, item_data)
	local item_group = item_data.item_group
	local item_rarity = item_data.rarity or 1
	local item_rarity_color = RaritySettings[item_rarity].color
	local item_rarity_dark_color = RaritySettings[item_rarity].color_dark
	local item_icon_style = pass_style.item_icon
	local horizontal_aspect_ratio

	if item_group == "weapons" or item_group == "devices" then
		horizontal_aspect_ratio = 2
	elseif item_group == "nameplates" then
		horizontal_aspect_ratio = 1
		item_icon_style.scale_to_material = true
	else
		horizontal_aspect_ratio = 1
	end

	local icon_size = item_icon_style.size
	local icon_height = icon_size[2]

	icon_size[1] = icon_height * horizontal_aspect_ratio

	local item_icon_offset = item_icon_style.offset
	local item_icon_bottom = item_icon_offset[2] + icon_height
	local item_display_name_style = pass_style.item_display_name

	item_display_name_style.in_focus_text_color = table.clone(item_rarity_color)
	item_display_name_style.dimmed_out_text_color = table.clone(item_rarity_dark_color)

	local item_sub_display_name_style = pass_style.item_sub_display_name

	item_sub_display_name_style.in_focus_text_color = table.clone(item_rarity_color)
	item_sub_display_name_style.dimmed_out_text_color = table.clone(item_rarity_dark_color)

	local sub_display_name_offset = item_sub_display_name_style.offset

	sub_display_name_offset[2] = item_icon_bottom + sub_display_name_offset[2]

	local item_level_style = pass_style.item_level
	local item_level_offset = item_level_style.offset

	item_level_offset[2] = item_icon_bottom + item_level_offset[2]

	local added_to_inventory_text_style = pass_style.added_to_inventory_text
	local added_to_inventory_text_offset = added_to_inventory_text_style.offset

	added_to_inventory_text_offset[2] = item_icon_bottom + added_to_inventory_text_offset[2]

	local offset_compressed = item_icon_style.offset_compressed

	if offset_compressed then
		item_icon_style.offset_original[2] = item_icon_offset[2]

		local icon_bottom_compressed = offset_compressed[2] + icon_height * 0.5
		local item_sub_display_name_offset_compressed = item_sub_display_name_style.offset_compressed

		item_sub_display_name_offset_compressed[2] = icon_bottom_compressed + item_sub_display_name_offset_compressed[2]
		item_sub_display_name_style.offset_original[2] = sub_display_name_offset[2]

		local item_level_offset_compressed = item_level_style.offset_compressed

		item_level_offset_compressed[2] = icon_bottom_compressed + item_level_offset_compressed[2]
		item_level_style.offset_original[2] = item_level_offset[2]

		local added_text_offset_compressed = added_to_inventory_text_style.offset_compressed

		added_text_offset_compressed[2] = icon_bottom_compressed + added_text_offset_compressed[2]
		added_to_inventory_text_style.offset_original[2] = added_to_inventory_text_offset[2]
	end

	if item_rarity > 1 then
		item_icon_style.sound_event_on_show = ViewSettings.item_rarity_sounds[item_rarity]
	end

	return pass_style
end

local function _item_pass_template_init(widget, config)
	local content = widget.content
	local reward_item = config.reward_item
	local item_group = config.item_group
	local item_rarity = config.rarity or 1
	local item_level = config.item_level

	content.reward_item = reward_item

	local item_type = reward_item.item_type

	if Items.is_weapon(item_type) then
		content.item_display_name = string.format("%s\n%s", Items.weapon_card_display_name(reward_item), Items.weapon_card_sub_display_name(reward_item))
		content.item_sub_display_name = Items.sub_display_name(reward_item)
	else
		content.item_display_name = Items.display_name(reward_item)
		content.item_sub_display_name = Items.sub_display_name(reward_item)
	end

	content.item_group = item_group

	local item_level_style = widget.style.item_level

	if item_level_style then
		content.item_level = item_level and string.format(" %d", item_level) or ""
		item_level_style.visible = item_level ~= nil
	end
end

local function _apply_live_nameplate_icon_cb_func(widget, item)
	local widget_style = widget.style
	local icon_style = widget_style.item_icon
	local material_values = icon_style.material_values

	material_values.texture_icon = item.icon

	if item.item_type == ITEM_TYPES.CHARACTER_INSIGNIA then
		material_values.icon_size = ViewStyles.item_insignia_size
	elseif item.item_type == ITEM_TYPES.PORTRAIT_FRAME then
		material_values.icon_size = ViewStyles.item_portrait_frame_size
	end

	material_values.use_placeholder_texture = 0
end

local function _apply_live_item_icon_cb_func(widget, grid_index, rows, columns, render_target)
	local widget_style = widget.style
	local icon_style = widget_style.item_icon
	local material_values = icon_style.material_values

	material_values.use_placeholder_texture = 0
	material_values.use_render_target = 1
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.render_target = render_target
end

local function _remove_live_item_icon_cb_func(widget, ui_renderer)
	UIWidget.set_visible(widget, ui_renderer, false)

	local widget_style = widget.style
	local icon_style = widget_style.item_icon
	local material_values = icon_style.material_values

	material_values.texture_icon = nil
	material_values.use_placeholder_texture = 1
	material_values.use_render_target = 0
end

local function _reward_load_icon_func(parent, widget, config, optional_icon_size)
	local content = widget.content
	local reward_item = content.reward_item

	if reward_item and not content.icon_load_id then
		local slot_name = Items.slot_name(reward_item)
		local item_state_machine = reward_item.state_machine
		local item_animation_event = reward_item.animation_event
		local render_context = {
			camera_focus_slot_name = slot_name,
			state_machine = item_state_machine,
			animation_event = item_animation_event,
			size = optional_icon_size,
		}
		local item_group = content.item_group
		local cb

		if item_group == "nameplates" then
			cb = callback(_apply_live_nameplate_icon_cb_func, widget)
			content.icon_load_id = Managers.ui:load_item_icon(reward_item, cb, render_context)
		elseif item_group == "weapon_skin" then
			cb = callback(_apply_live_item_icon_cb_func, widget)

			local preview_item = Items.weapon_skin_preview_item(reward_item)

			content.icon_load_id = parent:load_weapon_pattern_icon(preview_item or reward_item, cb, render_context)
		else
			cb = callback(_apply_live_item_icon_cb_func, widget)

			local prioritize = true

			content.icon_load_id = Managers.ui:load_item_icon(reward_item, cb, render_context, prioritize)
		end
	end
end

local function _get_level_up_label_pass_template(pass_template)
	pass_template[#pass_template + 1] = {
		pass_type = "text",
		style_id = "level_up_label",
		value = "",
		value_id = "level_up_label",
	}
	pass_template[#pass_template + 1] = {
		pass_type = "texture",
		style_id = "level_up_label_divider",
		value = "content/ui/materials/dividers/skull_center_02",
		value_id = "level_up_label_divider",
	}
end

local function _insert_empty_row(pass_template)
	local previous_row_style = pass_template[#pass_template].style
	local offset_y = previous_row_style.offset[2] + previous_row_style.size[2]
	local size = {
		[2] = ViewStyles.card_content_empty_row_height,
	}
	local pass_type = "rect"

	pass_template[#pass_template + 1] = {
		is_empty_row = true,
		pass_type = pass_type,
		style = {
			offset = {
				0,
				offset_y,
				0,
			},
			size = size,
			color = {
				0,
				0,
				0,
				0,
			},
		},
	}
end

end_player_view_blueprints.experience = {
	pass_template_function = function (parent, config)
		local pass_template = _get_card_default_frame_pass_template()

		_get_currency_icon(pass_template, "experience")
		_get_stat_pass_template(pass_template, "base_xp", "loc_eor_card_base_xp", "normal", ViewStyles.card_content_text_offset_y)
		_get_stat_pass_template(pass_template, "side_mission_xp", "loc_eor_card_side_mission_xp_label", "small")
		_get_stat_pass_template(pass_template, "circumstance_xp", "loc_eor_card_circumstance_xp", "small")
		_insert_empty_row(pass_template)
		_get_stat_pass_template(pass_template, "side_mission_bonus_xp", "loc_eor_card_side_mission_bonus_xp", "small")
		_get_stat_pass_template(pass_template, "total_bonus_xp", "loc_eor_card_total_bonus_xp", "small")

		return pass_template
	end,
	style = blueprint_styles.experience_card,
	size = folded_card_size,
	init = function (parent, widget, index, config)
		local content = widget.content

		_card_default_frame_pass_template_init(widget, index)

		content.label = Localize("loc_eor_card_title_experience")

		local details = config.rewards[1].details
		local circumstance_xp = details.from_circumstance
		local side_mission_xp = details.from_side_mission
		local side_mission_bonus_xp = details.from_side_mission_bonus
		local total_bonus_xp = details.from_total_bonus
		local total_xp_gained = details.total

		content.base_xp = total_xp_gained - (circumstance_xp + side_mission_xp + side_mission_bonus_xp + total_bonus_xp)
		content.base_xp_previous_value = 0
		content.side_mission_xp = side_mission_xp
		content.side_mission_xp_previous_value = content.base_xp_previous_value + content.base_xp
		content.circumstance_xp = circumstance_xp
		content.circumstance_xp_previous_value = content.side_mission_xp_previous_value + content.side_mission_xp
		content.side_mission_bonus_xp = side_mission_bonus_xp
		content.side_mission_bonus_xp_previous_value = content.circumstance_xp_previous_value + content.circumstance_xp
		content.total_bonus_xp = total_bonus_xp
		content.total_bonus_xp_previous_value = content.side_mission_bonus_xp_previous_value + content.side_mission_bonus_xp
		content.total_xp_gained = total_xp_gained
		content.content_animation = "experience_card_show_content"
		content.dim_out_animation = "experience_card_dim_out_content"
	end,
}

local function _add_currency_passes(pass_template, currency, rewards, optional_offset_y)
	for i = 1, #rewards do
		local reward = rewards[i]

		if reward.currency == currency then
			local details = reward.details

			_get_stat_pass_template(pass_template, currency, "loc_eor_card_base_" .. currency, "normal", optional_offset_y)

			if details.from_side_mission then
				_get_stat_pass_template(pass_template, "side_mission_" .. currency, "loc_eor_card_side_mission_credits_label", "small")
			end

			if details.from_circumstance then
				_get_stat_pass_template(pass_template, "circumstance_" .. currency, "loc_eor_card_circumstance_xp", "small")
			end

			break
		end
	end
end

end_player_view_blueprints.salary = {
	pass_template_function = function (parent, config)
		local pass_template = _get_card_default_frame_pass_template()
		local rewards = config.rewards

		_get_currency_icon(pass_template, "credits")
		_get_currency_icon(pass_template, "plasteel")
		_get_currency_icon(pass_template, "diamantine")
		_add_currency_passes(pass_template, "credits", rewards, ViewStyles.card_content_text_offset_y)
		_insert_empty_row(pass_template)
		_add_currency_passes(pass_template, "plasteel", rewards)
		_add_currency_passes(pass_template, "diamantine", rewards)

		return pass_template
	end,
	style = blueprint_styles.salary_card,
	size = folded_card_size,
	init = function (parent, widget, index, config)
		local content = widget.content

		_card_default_frame_pass_template_init(widget, index)

		content.label = Localize("loc_eor_card_title_salary")

		local rewards = config.rewards

		for i = 1, #rewards do
			local reward = rewards[i]
			local currency = reward.currency
			local details = reward.details
			local from_circumstance = details.from_circumstance
			local from_side_mission = details.from_side_mission
			local previous_amount = reward.current_amount
			local base_gained_amount = details.total

			if from_side_mission then
				base_gained_amount = base_gained_amount - from_side_mission
			end

			if from_circumstance then
				base_gained_amount = base_gained_amount - from_circumstance
			end

			content[currency] = base_gained_amount
			content[currency .. "_previous_value"] = previous_amount
			previous_amount = previous_amount + base_gained_amount

			if from_side_mission then
				content["side_mission_" .. currency] = from_side_mission
				content["side_mission_" .. currency .. "_previous_value"] = previous_amount
				previous_amount = previous_amount + from_side_mission
			end

			if from_circumstance then
				content["circumstance_" .. currency] = from_circumstance
				content["circumstance_" .. currency .. "_previous_value"] = previous_amount
			end
		end

		content.update_progress_func = callback(parent, "belate_wallet_update")
		content.content_animation = "salary_card_show_content"
		content.dim_out_animation = "salary_card_dim_out_content"
	end,
}
end_player_view_blueprints.level_up = {
	pass_template_function = function (parent, config)
		local pass_template = _get_card_levelup_frame_pass_template()

		_get_item_pass_templates(pass_template, config)

		return pass_template
	end,
	style = blueprint_styles.level_up_card,
	size = folded_card_size,
	init = function (parent, widget, index, config)
		local content = widget.content

		_card_levelup_frame_pass_template_init(widget, index)
		_item_pass_template_init(widget, config)

		content.blueprint_name = "level_up"
		content.label = Localize("loc_eor_card_title_level_up_reward")
		content.content_animation = "level_up_show_content"
		content.dim_out_animation = "level_up_dim_out_content"
	end,
	load_icon = _reward_load_icon_func,
	unload_icon = function (parent, widget, element, ui_renderer)
		local content = widget.content

		if content.icon_load_id then
			_remove_live_item_icon_cb_func(widget, ui_renderer)
			Managers.ui:unload_item_icon(content.icon_load_id)

			content.icon_load_id = nil
		end
	end,
	destroy = function (parent, widget, element, ui_renderer)
		local content = widget.content

		if content.icon_load_id then
			_remove_live_item_icon_cb_func(widget, ui_renderer)
			Managers.ui:unload_item_icon(content.icon_load_id)

			content.icon_load_id = nil
		end
	end,
}
end_player_view_blueprints.weapon_unlock = {
	pass_template_function = function (parent, config)
		local pass_template = _get_card_levelup_frame_pass_template()

		_get_level_up_label_pass_template(pass_template)
		table.append(pass_template, {
			{
				pass_type = "text",
				style_id = "item_display_name",
				value_id = "item_display_name",
			},
			{
				pass_type = "rect",
				style_id = "item_icon_background",
				value_id = "item_icon_background",
			},
			{
				pass_type = "texture",
				style_id = "item_icon_frame",
				value = "content/ui/materials/frames/eor_weapon_frame",
				value_id = "item_icon_frame",
			},
			{
				pass_type = "texture",
				style_id = "item_icon",
				value = "content/ui/materials/icons/items/containers/item_container_landscape",
				value_id = "item_icon",
			},
			{
				pass_type = "text",
				style_id = "weapon_unlocked_text",
				value_id = "weapon_unlocked_text",
				value = Localize("loc_eor_weapon_unlocked_desc"),
			},
		})

		return pass_template
	end,
	style = blueprint_styles.weapon_unlock,
	size = folded_card_size,
	init = function (parent, widget, index, config)
		local content = widget.content

		_card_levelup_frame_pass_template_init(widget, index)
		_item_pass_template_init(widget, config)

		content.blueprint_name = "weapon_unlock"
		content.label = Localize("loc_eor_card_title_level_up_reward")
		content.content_animation = "unlocked_weapon_show_content"
		content.dim_out_animation = "unlocked_weapon_dim_out_content"
		content.level_up_label = Localize("loc_eor_unlocked_weapon_label")
		content.weapon_unlocked_text = Localize("loc_eor_weapon_unlocked_desc")
	end,
	load_icon = _reward_load_icon_func,
	unload_icon = function (parent, widget, element, ui_renderer)
		local content = widget.content

		if content.icon_load_id then
			_remove_live_item_icon_cb_func(widget, ui_renderer)
			parent:unload_weapon_pattern_icon(content.icon_load_id)

			content.icon_load_id = nil
		end
	end,
	destroy = function (parent, widget, element, ui_renderer)
		local content = widget.content

		if content.icon_load_id then
			_remove_live_item_icon_cb_func(widget, ui_renderer)
			parent:unload_weapon_pattern_icon(content.icon_load_id)

			content.icon_load_id = nil
		end
	end,
}
end_player_view_blueprints.item_reward = {
	pass_template_function = function (parent, config)
		local pass_template = {
			{
				pass_type = "texture",
				style_id = "frame_top",
				value = "content/ui/materials/frames/end_of_round/reward_random_item_upper",
				value_id = "frame_top",
				visibility_function = _card_default_frame_visibility_function,
			},
			{
				pass_type = "texture",
				style_id = "frame_middle",
				value = "content/ui/materials/frames/end_of_round/reward_random_item_middle",
				value_id = "frame_middle",
				visibility_function = _card_default_frame_visibility_function,
			},
			{
				pass_type = "texture",
				style_id = "frame_bottom",
				value = "content/ui/materials/frames/end_of_round/reward_random_item_lower",
				value_id = "frame_bottom",
				visibility_function = _card_default_frame_visibility_function,
			},
			{
				pass_type = "rect",
				style_id = "background",
			},
			{
				pass_type = "texture",
				style_id = "rarity_background",
				value = "content/ui/materials/gradients/gradient_vertical",
				value_id = "rarity_background",
			},
			{
				pass_type = "text",
				style_id = "label",
				value = "",
				value_id = "label",
			},
		}

		_get_item_pass_templates(pass_template, config)

		return pass_template
	end,
	style_function = function (parent, config)
		local style = table.clone(blueprint_styles.item_reward_card)

		_get_item_pass_styles(style, config)

		return style
	end,
	size = folded_card_size,
	init = function (parent, widget, index, config)
		local content = widget.content
		local style = widget.style

		widget.offset[1] = index * ViewStyles.card_offset_x
		widget.alpha_multiplier = 0
		widget.content.size = table.clone(style.size)

		local frame_color = table.clone(style.default_frame_dimmed_out_color)

		style.frame_top.color = frame_color
		style.frame_middle.color = frame_color
		style.frame_bottom.color = frame_color
		style.frame_color = frame_color
		style.text_color = table.clone(style.in_focus_text_color)

		local item_rarity = config.rarity or 1
		local background_color = style.rarity_background.color

		Colors.color_copy(RaritySettings[item_rarity].color, background_color, true)
		_item_pass_template_init(widget, config)

		content.label = Localize("loc_eor_card_title_random_reward")
		content.content_animation = "item_reward_show_content"
		content.dim_out_animation = "item_reward_dim_out_content"
	end,
	load_icon = _reward_load_icon_func,
	unload_icon = function (parent, widget, element, ui_renderer)
		local content = widget.content

		if content.icon_load_id then
			_remove_live_item_icon_cb_func(widget, ui_renderer)
			Managers.ui:unload_item_icon(content.icon_load_id)

			content.icon_load_id = nil
		end
	end,
	destroy = function (parent, widget, element, ui_renderer)
		local content = widget.content

		if content.icon_load_id then
			_remove_live_item_icon_cb_func(widget, ui_renderer)
			Managers.ui:unload_item_icon(content.icon_load_id)

			content.icon_load_id = nil
		end
	end,
}
end_player_view_blueprints.empty_test_card = {
	pass_template_function = function (parent, config)
		local pass_template = _get_card_default_frame_pass_template()

		return pass_template
	end,
	style = blueprint_styles.empty_test_card,
	size = folded_card_size,
	init = function (parent, widget, index, config)
		local content = widget.content

		_card_default_frame_pass_template_init(widget, index)

		content.label = config.label or "Test"
		content.content_animation = "test"
		content.dim_out_animation = "test"
	end,
}

local weapon_size = folded_card_size

end_player_view_blueprints.weapon = {
	size = folded_card_size,
	pass_template_function = function (parent, config)
		local card_size = folded_card_size
		local area_size = {
			folded_card_size[1],
			folded_card_size[2] * 0.5,
		}
		local icon_size = {
			150,
			50,
		}
		local bar_width = area_size[1] * 0.7
		local weapon_pass_template = {
			{
				pass_type = "text",
				style_id = "title",
				value = "",
				value_id = "title",
				style = {
					text_horizontal_alignment = "center",
					text_color = Color.terminal_text_body(0, true),
					in_focus_color = Color.terminal_text_body(255, true),
					offset = {
						0,
						30,
						0,
					},
				},
			},
			{
				pass_type = "text",
				style_id = "level",
				value = "",
				value_id = "level",
				style = {
					default_font_size = 18,
					font_size = 18,
					text_horizontal_alignment = "center",
					default_text_color = Color.white(255, true),
					highlight_text_color = Color.white(255, true),
					text_color = Color.white(0, true),
					in_focus_color = Color.white(255, true),
					offset = {
						0,
						55,
						0,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "icon",
				value = "content/ui/materials/icons/weapons/hud/combat_blade_01",
				value_id = "icon",
				style = {
					horizontal_alignment = "center",
					color = Color.terminal_text_body(0, true),
					default_color = Color.terminal_text_body(nil, true),
					in_focus_color = Color.terminal_text_body(nil, true),
					offset = {
						0,
						95,
						5,
					},
					size = {
						icon_size[1] * 0.8,
						icon_size[2] * 0.8,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "background",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					horizontal_alignment = "center",
					in_focus_color = Color.terminal_background_dark(nil, true),
					color = Color.terminal_background_dark(0, true),
					offset = {
						0,
						90,
						0,
					},
					size = icon_size,
				},
			},
			{
				pass_type = "texture",
				style_id = "background_gradient",
				value = "content/ui/materials/gradients/gradient_vertical",
				style = {
					horizontal_alignment = "center",
					default_color = {
						100,
						33,
						35,
						37,
					},
					in_focus_color = {
						100,
						33,
						35,
						37,
					},
					color = {
						0,
						33,
						35,
						37,
					},
					offset = {
						0,
						90,
						1,
					},
					size = icon_size,
				},
			},
			{
				pass_type = "texture",
				style_id = "button_gradient",
				value = "content/ui/materials/gradients/gradient_diagonal_down_right",
				style = {
					horizontal_alignment = "center",
					color = Color.terminal_background_gradient(0, true),
					in_focus_color = Color.terminal_background_gradient(nil, true),
					offset = {
						0,
						90,
						1,
					},
					size = icon_size,
				},
			},
			{
				pass_type = "texture",
				style_id = "frame",
				value = "content/ui/materials/frames/frame_tile_2px",
				style = {
					horizontal_alignment = "center",
					color = Color.terminal_frame(0, true),
					default_color = Color.terminal_frame(nil, true),
					in_focus_color = Color.terminal_frame(nil, true),
					offset = {
						0,
						90,
						6,
					},
					size = icon_size,
				},
			},
			{
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					horizontal_alignment = "center",
					color = Color.terminal_corner(0, true),
					default_color = Color.terminal_corner(nil, true),
					in_focus_color = Color.terminal_corner(nil, true),
					offset = {
						0,
						90,
						7,
					},
					size = icon_size,
				},
			},
			{
				pass_type = "text",
				style_id = "total_exp",
				value = "",
				value_id = "total_exp",
				style = {
					horizontal_alignment = "center",
					text_horizontal_alignment = "right",
					in_focus_color = Color.terminal_text_body(255, true),
					text_color = Color.terminal_text_body(0, true),
					size = {
						bar_width,
					},
					offset = {
						0,
						140,
						0,
					},
				},
			},
			{
				pass_type = "rect",
				style_id = "experience_bar",
				style = {
					horizontal_alignment = "left",
					color = Color.terminal_icon(0, true),
					in_focus_color = Color.terminal_icon(255, true),
					default_color = Color.terminal_icon(255, true),
					size = {
						0,
						10,
					},
					offset = {
						(area_size[1] - bar_width) * 0.5,
						170,
						4,
					},
				},
			},
			{
				pass_type = "rect",
				style_id = "experience_bar_background",
				style = {
					horizontal_alignment = "left",
					color = Color.black(0, true),
					in_focus_color = Color.black(255, true),
					size = {
						bar_width,
						10,
					},
					offset = {
						(area_size[1] - bar_width) * 0.5,
						170,
						3,
					},
				},
			},
			{
				pass_type = "rect",
				style_id = "experience_bar_line",
				style = {
					horizontal_alignment = "left",
					in_focus_color = Color.terminal_text_body(255, true),
					color = Color.terminal_text_body(0, true),
					size = {
						bar_width,
						10,
					},
					offset = {
						(area_size[1] - bar_width) * 0.5 - 2,
						168,
						2,
					},
					size_addition = {
						4,
						4,
					},
				},
			},
			{
				pass_type = "text",
				style_id = "added_exp_text",
				value = "",
				value_id = "added_exp_text",
				style = {
					horizontal_alignment = "center",
					text_horizontal_alignment = "center",
					text_color = Color.terminal_text_body(0, true),
					in_focus_color = Color.terminal_text_body(255, true),
					size = {
						bar_width,
					},
					offset = {
						0,
						185,
						0,
					},
				},
			},
		}
		local full_pass = _get_card_default_frame_pass_template()
		local slots = {
			"slot_primary",
			"slot_secondary",
		}

		for i = 1, #slots do
			local slot_type = slots[i]
			local pass_template = table.clone(weapon_pass_template)
			local offset = ViewStyles.card_fully_expanded_height * 0.5

			for f = 1, #pass_template do
				local pass = pass_template[f]

				if pass.style_id then
					pass.style_id = string.format("%s_%s_%s", "weapon", pass.style_id, slot_type)
				end

				if pass.value_id then
					pass.value_id = string.format("%s_%s_%s", "weapon", pass.value_id, slot_type)
				end

				pass.style = pass.style or {}
				pass.style.offset = pass.style.offset or {
					0,
					0,
					0,
				}
				pass.style.offset[2] = pass.style.offset[2] + offset * (i - 1)
				pass.style.offset[3] = pass.style.offset[3] + 7
				pass.style.start_offset = table.clone(pass.style.offset)
			end

			table.append(full_pass, pass_template)
		end

		return full_pass
	end,
	style = blueprint_styles.empty_test_card,
	init = function (parent, widget, index, config)
		widget.alpha_multiplier = 0

		local content = widget.content

		_card_default_frame_pass_template_init(widget, index)

		local loadout = config.loadout

		content.label = Localize("loc_eor_card_title_mastery")
		content.content_animation = "weapon_card_show_content"
		content.dim_out_animation = "weapon_card_dim_out_content"

		local slots = {
			"slot_primary",
			"slot_secondary",
		}

		for f = 1, #slots do
			local slot = slots[f]
			local item = MasterItems.get_item(config.loadout[slot].name)
			local exp_per_level = config["exp_per_level_" .. slot]

			content["exp_per_level_" .. slot] = exp_per_level

			local start_exp = config["start_exp_" .. slot] or 0
			local added_exp = config["added_exp_" .. slot] or 0

			widget.content["weapon_icon_" .. slot] = item.hud_icon or widget.content["weapon_icon_" .. slot]
			widget.content["weapon_title_" .. slot] = Items.weapon_lore_family_name(config.loadout[slot])
			widget.content["weapon_added_exp_" .. slot] = added_exp
			widget.content["weapon_start_exp_" .. slot] = start_exp

			local max_level = #exp_per_level or 0
			local current_mastery_level = max_level

			widget.content["weapon_current_mastery_level_" .. slot] = max_level
			widget.content["weapon_start_mastery_level_" .. slot] = max_level

			for i = 1, #exp_per_level - 1 do
				local level_exp = exp_per_level[i]

				if start_exp <= level_exp then
					widget.content["weapon_current_mastery_level_" .. slot] = i - 1
					widget.content["weapon_start_mastery_level_" .. slot] = i - 1
					current_mastery_level = i

					break
				end
			end

			local max_exp = exp_per_level[max_level] or 0
			local previous_level_max_exp = exp_per_level[max_level - 1] or 0
			local start_mastery_level = widget.content["weapon_start_mastery_level_" .. slot] or 1
			local current_mastery_level = widget.content["weapon_current_mastery_level_" .. slot] or 1
			local is_max_level = max_level <= current_mastery_level

			if is_max_level then
				local diff_exp_level = max_exp - previous_level_max_exp

				widget.content["weapon_total_exp_" .. slot] = Localize("loc_mastery_exp_current_next", true, {
					current = diff_exp_level,
					next = diff_exp_level,
				})

				local style = widget.style["weapon_experience_bar_" .. slot]
				local background_style = widget.style["weapon_experience_bar_background_" .. slot]

				widget.content["weapon_level_" .. slot] = Localize("loc_mastery_level_current", true, {
					level = max_level,
				})
				style.size[1] = background_style.size[1]
			else
				local next_exp_level = exp_per_level[current_mastery_level + 1] or 0
				local current_exp_level = exp_per_level[current_mastery_level] or 0
				local diff_exp_level = next_exp_level - current_exp_level
				local start_exp_count = current_exp_level - start_exp
				local new_exp = start_exp

				widget.content["weapon_total_exp_" .. slot] = Localize("loc_mastery_exp_current_next", true, {
					current = new_exp,
					next = diff_exp_level,
				})
				widget.content["weapon_current_exp_level_" .. slot] = new_exp or 0
				widget.content["weapon_current_mastery_level_" .. slot] = current_mastery_level or 0
				widget.content["weapon_level_" .. slot] = Localize("loc_mastery_level_current", true, {
					level = current_mastery_level,
				})

				local bar_style = widget.style["weapon_experience_bar_" .. slot]
				local bar_background_style = widget.style["weapon_experience_bar_background_" .. slot]
				local clamped_new_exp = math.clamp(new_exp, current_exp_level, next_exp_level)
				local exp_progress = current_exp_level == next_exp_level and 1 or math.ilerp(current_exp_level, next_exp_level, clamped_new_exp)
				local bar_progress = math.clamp(exp_progress, 0, 1)

				bar_style.size[1] = bar_background_style.size[1] * bar_progress
			end
		end
	end,
}

local rank_badges = {
	{
		level = 1,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_1",
	},
	{
		level = 5,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_2",
	},
	{
		level = 10,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_3",
	},
	{
		level = 15,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_4",
	},
	{
		level = 20,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_5",
	},
	{
		level = 25,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_6",
	},
	{
		level = 30,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_7",
	},
	{
		level = 35,
		texture = "content/ui/textures/frames/havoc_ranks/havoc_rank_8",
	},
}

end_player_view_blueprints.havoc = {
	size = folded_card_size,
	pass_template_function = function (parent, config)
		local full_pass = _get_card_default_frame_pass_template()
		local icon_size = {
			75,
			75,
		}
		local badge_size = {
			210,
			168,
		}
		local letter_size = {
			43,
			43,
		}
		local letter_margin = 9
		local current_charges = config.order_reward and config.order_reward.current_charges
		local previous_charges = config.order_reward and config.order_reward.previous_charges
		local previous_rank = config.order_reward and config.order_reward.previous_rank
		local current_rank = config.order_reward and config.order_reward.current_rank
		local max_charges = config.order_reward and config.order_reward.max_charges
		local min_rank = config.order_reward and config.order_reward.min_rank
		local max_rank = config.order_reward and config.order_reward.max_rank
		local are_ranks_equal = previous_rank == current_rank
		local use_charges = current_charges and previous_charges
		local is_min = are_ranks_equal and previous_rank == min_rank
		local previous_rank_badge = rank_badges[#rank_badges]
		local current_rank_badge = rank_badges[#rank_badges]
		local found_prev_badge = false
		local found_current_badge = false

		for i = 1, #rank_badges do
			local rank_badge = rank_badges[i]
			local level = rank_badge.level

			if previous_rank and not found_prev_badge and previous_rank < level then
				previous_rank_badge = rank_badges[i - 1]
				found_prev_badge = true
			end

			if current_rank and not found_current_badge and current_rank < level then
				current_rank_badge = rank_badges[i - 1]
				found_current_badge = true
			end

			if found_prev_badge and found_current_badge then
				break
			end
		end

		if not previous_rank and current_rank then
			previous_rank_badge = current_rank_badge
		elseif not current_rank and previous_rank then
			current_rank_badge = previous_rank_badge
		end

		local badge_start_y_offset = -40
		local pass_templates = {
			{
				pass_type = "circle",
				style_id = "havoc_badge_background",
				value_id = "havoc_badge_background",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					offset = {
						0,
						badge_start_y_offset - 20,
						4,
					},
					size = {
						icon_size[1],
						icon_size[2],
					},
					color = Color.black(0, true),
					start_color = Color.black(0, true),
					in_focus_color = Color.black(nil, true),
				},
			},
		}

		pass_templates[#pass_templates + 1] = {
			pass_type = "texture",
			style_id = "havoc_rank_badge",
			value = "content/ui/materials/effects/screen/havoc_01_rank_anim",
			value_id = "havoc_rank_badge",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.white(0, true),
				start_color = Color.white(0, true),
				in_focus_color = Color.white(255, true),
				offset = {
					0,
					badge_start_y_offset,
					10,
				},
				size = {
					badge_size[1],
					badge_size[2],
				},
				material_values = {
					AnimationSpeedFireAmountt = {
						previous_rank and current_rank and current_rank < previous_rank and 1 or 0,
						0.045,
					},
					beforeTexure = previous_rank and current_rank and current_rank < previous_rank and current_rank_badge.texture or previous_rank_badge.texture,
					afterTexture = previous_rank and current_rank and current_rank < previous_rank and previous_rank_badge.texture or current_rank_badge.texture,
				},
			},
		}

		if use_charges and not is_min then
			local charge_size = 62
			local x_offset = charge_size + 10
			local total_size = charge_size * max_charges + 10 * (max_charges - 1)
			local start_x_offset = -((total_size - charge_size) * 0.5)

			for i = 1, max_charges do
				local current_x_offset = start_x_offset + x_offset * (i - 1)

				pass_templates[#pass_templates + 1] = {
					pass_type = "texture",
					value = "content/ui/materials/base/ui_default_base",
					value_id = "havoc_charge_" .. i,
					style_id = "havoc_charge_" .. i,
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "center",
						color = Color.terminal_text_header(0, true),
						start_color = Color.terminal_text_header(0, true),
						in_focus_color = Color.terminal_text_header(255, true),
						charges_color = Color.terminal_text_header(255, true),
						no_charges_color = {
							255,
							74,
							21,
							21,
						},
						offset = {
							current_x_offset,
							badge_start_y_offset + 120,
							1,
						},
						size = {
							charge_size,
							charge_size,
						},
						default_size = {
							charge_size,
							charge_size,
						},
						material_values = {
							texture_map = "content/ui/textures/icons/generic/havoc_strike",
						},
					},
				}
				pass_templates[#pass_templates + 1] = {
					pass_type = "texture",
					value = "content/ui/materials/base/ui_default_base",
					value_id = "havoc_charge_ghost_" .. i,
					style_id = "havoc_charge_ghost_" .. i,
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "center",
						color = Color.terminal_text_header(0, true),
						offset = {
							current_x_offset,
							badge_start_y_offset + 120,
							0,
						},
						size = {
							charge_size,
							charge_size,
						},
						default_size = {
							charge_size,
							charge_size,
						},
						material_values = {
							texture_map = "content/ui/textures/icons/generic/havoc_strike",
						},
					},
				}
			end
		end

		local previous_rank_to_string = tostring(previous_rank)
		local previous_rank_width = (letter_size[1] - letter_margin * 2) * #previous_rank_to_string
		local start_previous_offset = -(previous_rank_width - letter_size[1] + letter_margin * 2) * 0.5

		for i = 1, #previous_rank_to_string do
			local rank_number = tonumber(string.sub(previous_rank_to_string, i, i))
			local x_offset = start_previous_offset + (letter_size[1] - letter_margin * 2) * (i - 1)

			pass_templates[#pass_templates + 1] = {
				pass_type = "texture",
				value = "content/ui/materials/frames/havoc_numbers",
				value_id = "previous_havoc_rank_value_" .. i,
				style_id = "previous_havoc_rank_value_" .. i,
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = Color.white(0, true),
					start_color = Color.white(0, true),
					in_focus_color = Color.white(nil, true),
					size = {
						letter_size[1],
						letter_size[2],
					},
					offset = {
						x_offset,
						badge_start_y_offset - 12,
						5,
					},
					start_offset_y = badge_start_y_offset - 12,
					material_values = {
						number = rank_number,
					},
				},
			}
		end

		local current_rank_to_string = tostring(current_rank)
		local current_rank_width = (letter_size[1] - letter_margin * 2) * #current_rank_to_string
		local start_current_offset = -(current_rank_width - letter_size[1] + letter_margin * 2) * 0.5

		for i = 1, #current_rank_to_string do
			local rank_number = tonumber(string.sub(current_rank_to_string, i, i))
			local x_offset = start_current_offset + (letter_size[1] - letter_margin * 2) * (i - 1)

			pass_templates[#pass_templates + 1] = {
				pass_type = "texture",
				value = "content/ui/materials/frames/havoc_numbers",
				value_id = "current_havoc_rank_value_" .. i,
				style_id = "current_havoc_rank_value_" .. i,
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					size = {
						letter_size[1],
						letter_size[2],
					},
					color = Color.white(0, true),
					start_color = Color.white(0, true),
					in_focus_color = Color.white(nil, true),
					offset = {
						x_offset,
						badge_start_y_offset - 12,
						6,
					},
					start_offset_y = badge_start_y_offset - 12,
					material_values = {
						number = rank_number,
					},
				},
			}
		end

		pass_templates[#pass_templates + 1] = {
			pass_type = "text",
			style_id = "havoc_order_text",
			value = "",
			value_id = "havoc_order_text",
			style = {
				font_size = 18,
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				start_color = Color.terminal_text_header(0, true),
				text_color = Color.terminal_text_header(0, true),
				in_focus_text_color = Color.terminal_text_header(255, true),
				offset = {
					20,
					badge_start_y_offset - 120,
					5,
				},
				size = {
					folded_card_size[1] - 40,
					30,
				},
			},
		}
		pass_templates[#pass_templates + 1] = {
			pass_type = "text",
			style_id = "havoc_icon",
			value = "",
			value_id = "havoc_icon",
			style = {
				font_size = 72,
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				start_color = Color.white(0, true),
				text_color = Color.white(0, true),
				in_focus_text_color = Color.white(255, true),
				offset = {
					-30,
					-40,
					5,
				},
				size = {
					folded_card_size[1],
					50,
				},
			},
		}
		pass_templates[#pass_templates + 1] = {
			pass_type = "text",
			style_id = "highest_havoc_rank",
			value_id = "highest_havoc_rank",
			value = config.highest_rank and config.highest_rank.rank,
			style = {
				font_size = 48,
				font_type = "machine_medium",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				start_color = Color.terminal_text_header(0, true),
				text_color = Color.terminal_text_header(0, true),
				in_focus_text_color = Color.terminal_text_header(255, true),
				offset = {
					30,
					-40,
					5,
				},
				size = {
					folded_card_size[1],
					50,
				},
			},
		}
		pass_templates[#pass_templates + 1] = {
			pass_type = "text",
			style_id = "highest_havoc_description",
			value_id = "highest_havoc_description",
			value = Localize("loc_havoc_eor_highest"),
			style = {
				font_size = 18,
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				start_color = Color.terminal_text_header(0, true),
				text_color = Color.terminal_text_header(0, true),
				in_focus_text_color = Color.terminal_text_header(255, true),
				offset = {
					20,
					40,
					5,
				},
				size = {
					folded_card_size[1] - 40,
					30,
				},
			},
		}
		pass_templates[#pass_templates + 1] = {
			pass_type = "text",
			style_id = "havoc_week_description",
			value_id = "havoc_week_description",
			value = Localize("loc_havoc_eor_week_highest"),
			style = {
				font_size = 18,
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				text_color = Color.terminal_text_header(0, true),
				start_color = Color.terminal_text_header(0, true),
				in_focus_text_color = Color.terminal_text_header(255, true),
				offset = {
					20,
					-120,
					5,
				},
				size = {
					folded_card_size[1] - 40,
					30,
				},
			},
		}
		pass_templates[#pass_templates + 1] = {
			pass_type = "texture",
			style_id = "havoc_reward_week_icon_glow",
			value = "content/ui/materials/frames/achievements/wintrack_claimed_reward_display_background_glow",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.item_rarity_4(0, true),
				in_focus_color = Color.item_rarity_1(255, true),
				start_color = Color.item_rarity_1(0, true),
				size = {
					165,
					165,
				},
				start_size = {
					165,
					165,
				},
				offset = {
					0,
					-20,
					6,
				},
			},
		}
		pass_templates[#pass_templates + 1] = {
			pass_type = "texture",
			style_id = "havoc_reward_week_icon",
			value = "content/ui/materials/icons/engrams/engram_rarity_04",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.white(0, true),
				in_focus_color = Color.white(255, true),
				start_color = Color.white(0, true),
				size = {
					192,
					128,
				},
				start_size = {
					192,
					128,
				},
				offset = {
					0,
					-20,
					7,
				},
				material_values = {
					texture_map = "content/ui/textures/icons/engrams/engram_rarity_01",
				},
			},
		}
		pass_templates[#pass_templates + 1] = {
			pass_type = "text",
			style_id = "week_havoc_icon",
			value = "",
			value_id = "week_havoc_icon",
			style = {
				font_size = 52,
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				size = {
					folded_card_size[1],
					50,
				},
				start_color = Color.white(0, true),
				text_color = Color.white(0, true),
				in_focus_text_color = Color.white(255, true),
				offset = {
					-20,
					90,
					5,
				},
			},
		}
		pass_templates[#pass_templates + 1] = {
			pass_type = "text",
			style_id = "week_havoc_rank",
			value_id = "week_havoc_rank",
			value = config.week_rank and config.week_rank.rank,
			style = {
				font_size = 32,
				font_type = "machine_medium",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				size = {
					folded_card_size[1],
					50,
				},
				start_color = Color.terminal_text_header(0, true),
				text_color = Color.terminal_text_header(0, true),
				in_focus_text_color = Color.terminal_text_header(255, true),
				offset = {
					20,
					90,
					5,
				},
			},
		}

		table.append(full_pass, pass_templates)

		return full_pass
	end,
	style = blueprint_styles.empty_test_card,
	init = function (parent, widget, index, config)
		_card_default_frame_pass_template_init(widget, index)

		local content = widget.content
		local style = widget.style

		content.content_animation = "havoc_card_show_content"
		content.dim_out_animation = "havoc_card_dim_out_content"

		local order_reward = config.order_reward

		content.label = Localize("loc_havoc_name")

		if order_reward then
			local current_charges = order_reward.current_charges
			local previous_charges = order_reward.previous_charges
			local previous_rank = order_reward.previous_rank
			local current_rank = order_reward.current_rank
			local max_charges = order_reward.max_charges
			local min_rank = order_reward.min_rank
			local max_rank = order_reward.max_rank
			local animation_state

			content.previous_rank = previous_rank
			content.current_rank = current_rank
			content.max_charges = max_charges
			content.min_rank = min_rank
			content.max_rank = max_rank

			local uses_charges = not not style.havoc_charge_1

			content.uses_charges = uses_charges

			if uses_charges then
				content.current_charges = current_charges
				content.previous_charges = previous_charges

				for i = 1, max_charges do
					local charge_style = style["havoc_charge_" .. i]

					if charge_style then
						local no_charges_color = charge_style.no_charges_color

						if no_charges_color and i > content.previous_charges then
							Colors.color_copy(no_charges_color, charge_style.start_color, true)
							Colors.color_copy(no_charges_color, charge_style.in_focus_color)
						end
					end
				end
			end

			if current_rank and previous_rank then
				if previous_rank < current_rank then
					animation_state = "rank_increase"
					content.havoc_order_text = Localize("loc_havoc_eor_promotion")
				elseif current_rank < previous_rank then
					animation_state = "rank_decrease"
					content.havoc_order_text = Localize("loc_havoc_eor_demotion")
				elseif current_rank == previous_rank and uses_charges and content.previous_charges > content.current_charges then
					animation_state = "charge_change"
					content.havoc_order_text = Localize("loc_havoc_eor_charge_used")
				else
					animation_state = "charge_change"
					content.havoc_order_text = ""
				end
			end

			content.order_reward_state = animation_state

			local previous_rank_to_string = content.previous_rank and tostring(content.previous_rank)
			local current_rank_to_string = content.current_rank and tostring(content.current_rank)

			content.previous_rank_size = previous_rank_to_string and #previous_rank_to_string
			content.current_rank_size = current_rank_to_string and #current_rank_to_string
		end

		local highest_rank_reward = config.highest_rank and config.highest_rank.rank

		if highest_rank_reward then
			content.highest_rank = highest_rank_reward
		end

		local week_rank_reward = config.week_rank and config.week_rank.rank

		if week_rank_reward then
			content.week_rank = week_rank_reward
		end
	end,
}
end_player_view_blueprints.expedition = {
	size = folded_card_size,
	pass_template_function = function (parent, config)
		local pass_template = _get_card_default_frame_pass_template()
		local next_index = #pass_template + 1
		local all_unlock_progress = config.all_unlock_progress
		local has_progress = all_unlock_progress and not table.is_empty(all_unlock_progress)
		local offset_y = has_progress and 50 or ViewStyles.card_fully_expanded_height * 0.5 - 30
		local offset_x = 55

		pass_template[next_index] = {
			pass_type = "texture",
			style_id = "currency_background",
			value = "content/ui/materials/masks/gradient_horizontal_sides_02",
			value_id = "currency_background",
			style = {
				scale_to_material = true,
				offset = {
					10,
					offset_y - 15 - 5,
					1,
				},
				size_addition = {
					-20,
					10,
				},
				color = Color.white(0, true),
				size = {
					nil,
					80,
				},
			},
		}

		local next_index = #pass_template + 1

		pass_template[next_index] = {
			pass_type = "texture",
			style_id = "currency_icon_background",
			value = "content/ui/materials/effects/end_of_round/reward_background",
			value_id = "currency_icon_background",
			style = {
				size = {
					170,
					170,
				},
				offset = {
					offset_x + 20 - 60,
					offset_y - 60,
					1,
				},
			},
		}

		local next_index = #pass_template + 1

		pass_template[#pass_template + 1] = {
			pass_type = "texture",
			style_id = "currency_icon",
			value = "content/ui/materials/icons/currencies/tech_remnant_big",
			value_id = "currency_icon",
			style = {
				size = {
					52,
					44,
				},
				offset = {
					offset_x + 20,
					offset_y,
					2,
				},
			},
		}

		local next_index = #pass_template + 1

		offset_y = offset_y + 10

		local new_main_color = {
			255,
			133,
			216,
			158,
		}
		local new_body_color = {
			255,
			225,
			222,
			207,
		}
		local new_body_color_glow = Color.white(255, true)
		local next_index = #pass_template + 1
		local card_content_styles = blueprint_styles.card_content
		local label_style = table.clone(UIFontSettings.terminal_header_3)

		label_style.offset = {
			offset_x + 110,
			offset_y - 24,
			3,
		}
		label_style.text_color = table.clone(new_main_color)
		label_style.font_size = 24
		pass_template[next_index] = {
			pass_type = "text",
			style_id = "currency_label",
			value_id = "currency_label",
			value = Localize("loc_expedition_eor_collected"),
			style = label_style,
		}
		next_index = next_index + 1
		card_content_styles = blueprint_styles.card_content

		local value_style = table.clone(UIFontSettings.terminal_header_3)

		value_style.offset = {
			offset_x + 110,
			offset_y + 8,
			3,
		}
		value_style.font_size = 36
		value_style.text_color = table.clone(new_body_color)
		value_style.text_color_glow = Color.white(255, true)
		pass_template[next_index] = {
			pass_type = "text",
			style_id = "currency_text",
			value = "0",
			value_id = "currency_text",
			style = value_style,
		}
		next_index = next_index + 1
		offset_y = offset_y + 70

		local complete_remaining_space = ViewStyles.card_fully_expanded_height - offset_y - 15
		local remaining_space = complete_remaining_space
		local remaining_all_progress_count = #all_unlock_progress
		local used_indexes = {}
		local affected_nodes = {}

		if all_unlock_progress then
			local progress_by_unlocked_node = {}

			for i = 1, #all_unlock_progress do
				local unlock_progress = all_unlock_progress[i]
				local affected_node = unlock_progress.affected_node

				if affected_node then
					progress_by_unlocked_node[affected_node] = progress_by_unlocked_node[affected_node] or {
						affected_node_name = unlock_progress.affected_node_name,
						indexes = {},
					}
					progress_by_unlocked_node[affected_node].indexes[#progress_by_unlocked_node[affected_node].indexes + 1] = i
				end
			end

			local pass_index = 1

			for node_id, unlock_progresses_by_node in pairs(progress_by_unlocked_node) do
				offset_y = offset_y + 15

				local node_name_id = "node_name_" .. node_id
				local node_text_style = table.clone(label_style)

				node_text_style.offset = {
					offset_x,
					offset_y,
					3,
				}
				node_text_style.font_size = 18

				local node_id_height = Text.text_height(parent._ui_renderer, node_id, node_text_style, {
					ViewStyles.card_width,
					ViewStyles.card_fully_expanded_height,
				}, true)

				remaining_space = remaining_space - 25 - node_id_height

				if remaining_space < 50 then
					remaining_space = 0

					break
				end

				affected_nodes[#affected_nodes + 1] = node_id

				local node_name = unlock_progresses_by_node.affected_node_name and Localize(unlock_progresses_by_node.affected_node_name) or ""

				pass_template[next_index] = {
					pass_type = "text",
					value_id = node_name_id,
					style_id = node_name_id,
					value = node_name,
					style = node_text_style,
				}
				offset_y = offset_y + node_id_height
				next_index = next_index + 1

				for i = 1, #unlock_progresses_by_node.indexes do
					remaining_all_progress_count = remaining_all_progress_count - 1

					local unlock_progress_index = unlock_progresses_by_node.indexes[i]
					local unlock_progress = all_unlock_progress[unlock_progress_index]
					local limit = unlock_progress.limit or 0
					local previous_progress = unlock_progress.previous_progress or 0
					local progress = unlock_progress.progress or previous_progress
					local key = unlock_progress.key
					local unlock_type = unlock_progress.type
					local progress_node_name = unlock_progress.progress_node_name
					local progress_text = ""
					local context = {
						node_name = progress_node_name and Localize(progress_node_name) or "",
						gathered = unlock_progress.previous_progress,
						goal = unlock_progress.limit,
					}

					if unlock_type == EXPEDITION_UNLOCK_TYPE.personal_best_loot then
						progress_text = Localize("loc_personal_best_loot", true, context)
					elseif unlock_type == EXPEDITION_UNLOCK_TYPE.personal_total_loot then
						progress_text = Localize("loc_personal_total_loot", true, context)
					elseif unlock_type == EXPEDITION_UNLOCK_TYPE.personal_count then
						progress_text = Localize("loc_personal_count", true, context)
					elseif unlock_type == EXPEDITION_UNLOCK_TYPE.personal_total_loot_mapwide then
						progress_text = Localize("loc_personal_total_loot_mapwide", true, context)
					end

					progress_text = string.gsub(progress_text, string.format("%d/%d", unlock_progress.previous_progress, unlock_progress.limit), "")

					local progress_value = string.format("%s / %s", Text.format_currency(math.floor(previous_progress)), Text.format_currency(math.floor(limit)))
					local progress_text_id = "progress_text_" .. pass_index

					offset_y = offset_y + 10

					local checkbox_size = {
						20,
						20,
					}
					local checkbox_color = table.clone(new_main_color)

					checkbox_color[1] = 0

					local progress_checkbox_shadow_id = "progress_checkbox_shadow_" .. pass_index

					pass_template[next_index] = {
						pass_type = "texture",
						value = "content/ui/materials/buttons/slider_handle_line",
						value_id = progress_checkbox_shadow_id,
						style_id = progress_checkbox_shadow_id,
						style = {
							scale_to_material = true,
							color = Color.black(0, true),
							offset = {
								offset_x + 0.5,
								offset_y + 2.5,
								4,
							},
							size = checkbox_size,
						},
					}
					next_index = next_index + 1

					local progress_checkbox_line_id = "progress_checkbox_line_" .. pass_index

					pass_template[next_index] = {
						pass_type = "texture",
						value = "content/ui/materials/buttons/slider_handle_line",
						value_id = progress_checkbox_line_id,
						style_id = progress_checkbox_line_id,
						style = {
							scale_to_material = true,
							color = checkbox_color,
							offset = {
								offset_x,
								offset_y + 2,
								5,
							},
							size = checkbox_size,
						},
					}
					next_index = next_index + 1

					local progress_checkbox_fill_id = "progress_checkbox_fill_" .. pass_index

					pass_template[next_index] = {
						pass_type = "texture",
						value = "content/ui/materials/buttons/slider_handle_fill",
						value_id = progress_checkbox_fill_id,
						style_id = progress_checkbox_fill_id,
						style = {
							scale_to_material = true,
							original_color = checkbox_color,
							highlight_color = table.clone(new_main_color),
							color = checkbox_color,
							offset = {
								offset_x + 5,
								offset_y + 7,
								5,
							},
							size = {
								checkbox_size[1] - 10,
								checkbox_size[2] - 10,
							},
						},
					}
					next_index = next_index + 1

					local progress_text_style = table.clone(label_style)

					progress_text_style.offset = {
						offset_x + 30,
						offset_y,
						3,
					}
					progress_text_style.font_size = 20

					local text_height = Text.text_height(parent._ui_renderer, progress_text, progress_text_style, {
						ViewStyles.card_width - offset_x * 2,
						ViewStyles.card_fully_expanded_height,
					}, true)

					pass_template[next_index] = {
						pass_type = "text",
						value_id = progress_text_id,
						style_id = progress_text_id,
						value = progress_text,
						style = progress_text_style,
					}
					next_index = next_index + 1
					offset_y = offset_y + text_height + 5

					local value_text_style = table.clone(value_style)

					value_text_style.offset = {
						offset_x + 30,
						offset_y,
						3,
					}
					value_text_style.font_size = 24
					value_text_style.size = {
						ViewStyles.card_width - offset_x * 2,
					}
					value_text_style.text_color = Color.terminal_text_header(255, true)

					local value_height = Text.text_height(parent._ui_renderer, progress_value, value_text_style, {
						ViewStyles.card_width - offset_x * 2,
						ViewStyles.card_fully_expanded_height,
					}, true)
					local progress_value_id = "progress_value_" .. pass_index

					pass_template[next_index] = {
						pass_type = "text",
						value_id = progress_value_id,
						style_id = progress_value_id,
						value = progress_value,
						style = value_text_style,
					}
					next_index = next_index + 1

					local progress_complete_square_id = "progress_complete_square_" .. pass_index

					pass_template[next_index] = {
						pass_type = "rect",
						value_id = progress_complete_square_id,
						style_id = progress_complete_square_id,
						style = {
							offset = {
								offset_x,
								offset_y,
								4,
							},
							size = {
								0,
								text_height,
							},
						},
					}
					next_index = next_index + 1
					offset_y = offset_y + value_height

					local progress_background_id = "progress_background_" .. pass_index

					pass_template[next_index] = {
						pass_type = "texture",
						value = "content/ui/materials/masks/gradient_horizontal_sides_02",
						value_id = progress_background_id,
						style_id = progress_background_id,
						style = {
							scale_to_material = true,
							offset = {
								10,
								progress_text_style.offset[2] - 5,
								1,
							},
							size_addition = {
								-20,
								10,
							},
							color = Color.white(0, true),
							size = {
								[2] = text_height + 5 + value_height,
							},
						},
					}
					next_index = #pass_template + 1
					remaining_space = remaining_space - text_height - 5 - value_height - 10
					used_indexes[pass_index] = unlock_progress_index
					pass_index = pass_index + 1

					if remaining_space < text_height + 5 + value_height + 10 + 20 then
						remaining_space = 0

						break
					end
				end
			end

			local resume_text_style = table.clone(UIFontSettings.body)

			resume_text_style.offset = {
				offset_x,
				-30,
				3,
			}
			resume_text_style.vertical_alignment = "bottom"
			resume_text_style.text_vertical_alignment = "bottom"
			resume_text_style.text_horizontal_alignment = "center"
			resume_text_style.size = {
				ViewStyles.card_width - offset_x * 2,
			}
			resume_text_style.text_color = Color.terminal_text_body(255, true)
			pass_template[next_index] = {
				pass_type = "text",
				style_id = "expedition_resume_text",
				value_id = "expedition_resume_text",
				value = remaining_all_progress_count > 0 and Localize("loc_expedition_eor_additional", true, {
					requirements = remaining_all_progress_count,
				}) or "",
				style = resume_text_style,
			}
		end

		config.affected_nodes = affected_nodes
		config.used_indexes = used_indexes

		return pass_template
	end,
	style = blueprint_styles.empty_test_card,
	init = function (parent, widget, index, config)
		_card_default_frame_pass_template_init(widget, index)

		local content = widget.content
		local style = widget.style
		local node_name_played = config.node_name_played and Localize(config.node_name_played)

		content.label = string.format("%s\n%s %s", Localize("loc_expedition_eor_title"), Localize("loc_grid_point"), node_name_played)

		local all_unlock_progress = config.all_unlock_progress
		local loot_collected = config.loot_collected

		content.loot_collected = loot_collected
		content.all_unlock_progress = all_unlock_progress
		content.affected_nodes = config.affected_nodes or {}
		content.used_indexes = config.used_indexes or {}
		content.content_animation = "expedition_card_show_content"
		content.dim_out_animation = "expedition_card_dim_out_content"

		local pass_styles = {
			widget.style.currency_icon_background,
			widget.style.currency_icon,
			widget.style.currency_label,
			widget.style.currency_text,
			widget.style.expedition_resume_text,
		}

		for i = 1, #config.affected_nodes do
			local affected_node = config.affected_nodes[i]

			pass_styles[#pass_styles + 1] = widget.style["node_name_" .. affected_node]
		end

		for i = 1, #config.used_indexes do
			pass_styles[#pass_styles + 1] = widget.style["progress_text_" .. i]
			pass_styles[#pass_styles + 1] = widget.style["progress_value_" .. i]
		end

		for i = 1, #pass_styles do
			local pass_style = pass_styles[i]

			if pass_style.color then
				pass_style.color[1] = 0
			end

			if pass_style.text_color then
				pass_style.text_color[1] = 0
			end
		end
	end,
}

return settings("EndPlayerViewBlueprints", end_player_view_blueprints)
