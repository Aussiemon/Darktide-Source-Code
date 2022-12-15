local ColorUtils = require("scripts/utilities/ui/colors")
local ItemUtils = require("scripts/utilities/items")
local RaritySettings = require("scripts/settings/item/rarity_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewAnimations = require("scripts/ui/views/end_player_view/end_player_view_animations")
local ViewSettings = require("scripts/ui/views/end_player_view/end_player_view_settings")
local ViewStyles = require("scripts/ui/views/end_player_view/end_player_view_styles")
local WalletSettings = require("scripts/settings/wallet_settings")
local blueprint_styles = ViewStyles.blueprints
local ITEM_TYPES = UISettings.ITEM_TYPES
local folded_card_size = {
	ViewStyles.card_width,
	ViewStyles.card_folded_height
}
local end_player_view_blueprints = {}

local function _card_default_frame_visibility_function(content, style)
	return style.color[1] > 0
end

local function _get_card_default_frame_pass_template()
	local card_frame_pass_template = {
		{
			value_id = "frame_default_top",
			style_id = "frame_default_top",
			pass_type = "texture",
			value = "content/ui/materials/frames/end_of_round/reward_default_upper",
			visibility_function = _card_default_frame_visibility_function
		},
		{
			value_id = "frame_default_middle",
			style_id = "frame_default_middle",
			pass_type = "texture",
			value = "content/ui/materials/frames/end_of_round/reward_default_middle",
			visibility_function = _card_default_frame_visibility_function
		},
		{
			value_id = "frame_default_bottom",
			style_id = "frame_default_bottom",
			pass_type = "texture",
			value = "content/ui/materials/frames/end_of_round/reward_default_lower",
			visibility_function = _card_default_frame_visibility_function
		},
		{
			pass_type = "rect",
			style_id = "background_rect"
		},
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "background",
			pass_type = "texture",
			style_id = "background"
		},
		{
			value = "",
			value_id = "label",
			pass_type = "text",
			style_id = "label"
		}
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
			value_id = "frame_levelup_top",
			style_id = "frame_levelup_top",
			pass_type = "texture",
			value = "content/ui/materials/frames/end_of_round/reward_levelup_upper",
			visibility_function = _card_default_frame_visibility_function
		},
		{
			value_id = "frame_levelup_bottom",
			style_id = "frame_levelup_bottom",
			pass_type = "texture",
			value = "content/ui/materials/frames/end_of_round/reward_levelup_lower",
			visibility_function = _card_default_frame_visibility_function
		},
		{
			value_id = "frame_levelup_effect",
			style_id = "frame_levelup_effect",
			pass_type = "texture",
			value = "content/ui/materials/effects/end_of_round/level_up_frame",
			visibility_function = _card_default_frame_visibility_function
		},
		{
			value = "content/ui/materials/frames/end_of_round/reward_levelup_upper_spikes",
			value_id = "spires",
			pass_type = "texture",
			style_id = "spires"
		},
		{
			value = "content/ui/materials/frames/end_of_round/reward_levelup_upper_skull",
			value_id = "frame_detail",
			pass_type = "texture",
			style_id = "frame_detail"
		}
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
	local background_id, icon_id, icon_material = nil

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
		value = "content/ui/materials/effects/end_of_round/reward_background",
		value_id = "icon_background",
		pass_type = "texture",
		style_id = background_id
	}
	pass_template[#pass_template + 1] = {
		pass_type = "texture",
		value_id = icon_id,
		style_id = icon_id,
		value = icon_material
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
		style = label_style
	}
	local value_style = table.clone(label_style)
	value_style.text_horizontal_alignment = "right"
	next_index = next_index + 1
	pass_template[next_index] = {
		pass_type = "text",
		value = "0",
		value_id = stat .. "_text",
		style_id = stat,
		style = value_style
	}
end

local function _get_item_pass_templates(pass_template, item_data)
	local item_group = item_data.item_group
	local icon_material = nil

	if item_group == "nameplates" then
		icon_material = "content/ui/materials/icons/items/containers/item_container_square"
	else
		icon_material = "content/ui/materials/icons/items/containers/item_container_landscape"
	end

	if not icon_material then
		return
	end

	table.append(pass_template, {
		{
			style_id = "item_display_name",
			value_id = "item_display_name",
			pass_type = "text"
		},
		{
			value = "content/ui/materials/icons/items/containers/item_container_landscape",
			value_id = "item_icon",
			pass_type = "texture",
			style_id = "item_icon"
		},
		{
			style_id = "item_sub_display_name",
			value_id = "item_sub_display_name",
			pass_type = "text"
		},
		{
			value = "",
			value_id = "item_level",
			pass_type = "text",
			style_id = "item_level"
		},
		{
			value_id = "added_to_inventory_text",
			pass_type = "text",
			style_id = "added_to_inventory_text",
			value = Localize("loc_notification_desc_added_to_inventory")
		}
	})
end

local function _get_item_pass_styles(pass_style, item_data)
	local item_group = item_data.item_group
	local item_rarity = item_data.rarity or 1
	local item_rarity_color = RaritySettings[item_rarity].color
	local item_rarity_dark_color = RaritySettings[item_rarity].color_dark
	local item_icon_style = pass_style.item_icon
	local horizontal_aspect_ratio = nil

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
	content.item_display_name = ItemUtils.display_name(reward_item)
	content.item_sub_display_name = ItemUtils.sub_display_name(reward_item)
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
	local widget_style = widget.style
	local icon_style = widget_style.item_icon
	local material_values = icon_style.material_values
	material_values.texture_icon = nil
	material_values.use_placeholder_texture = 1

	UIWidget.set_visible(widget, ui_renderer, false)
	UIWidget.set_visible(widget, ui_renderer, true)
end

local function _reward_load_icon_func(parent, widget, config)
	local content = widget.content
	local reward_item = content.reward_item

	if reward_item and not content.icon_load_id then
		local slot_name = ItemUtils.slot_name(reward_item)
		local item_state_machine = reward_item.state_machine
		local item_animation_event = reward_item.animation_event
		local render_context = {
			camera_focus_slot_name = slot_name,
			state_machine = item_state_machine,
			animation_event = item_animation_event
		}
		local item_group = content.item_group
		local cb = nil

		if item_group == "nameplates" then
			cb = callback(_apply_live_nameplate_icon_cb_func, widget)
			content.icon_load_id = Managers.ui:load_item_icon(reward_item, cb, render_context)
		elseif item_group == "weapon_skin" then
			cb = callback(_apply_live_item_icon_cb_func, widget)
			local preview_item = ItemUtils.weapon_skin_preview_item(reward_item)
			content.icon_load_id = parent:load_weapon_pattern_icon(preview_item or reward_item, cb, render_context)
		else
			cb = callback(_apply_live_item_icon_cb_func, widget)
			content.icon_load_id = Managers.ui:load_item_icon(reward_item, cb, render_context)
		end
	end
end

local function _get_level_up_label_pass_template(pass_template)
	pass_template[#pass_template + 1] = {
		value = "",
		value_id = "level_up_label",
		pass_type = "text",
		style_id = "level_up_label"
	}
	pass_template[#pass_template + 1] = {
		value = "content/ui/materials/dividers/skull_center_02",
		value_id = "level_up_label_divider",
		pass_type = "texture",
		style_id = "level_up_label_divider"
	}
end

local function _insert_empty_row(pass_template)
	local previous_row_style = pass_template[#pass_template].style
	local offset_y = previous_row_style.offset[2] + previous_row_style.size[2]
	local size = {
		[2] = ViewStyles.card_content_empty_row_height
	}
	local pass_type = "rect"
	pass_template[#pass_template + 1] = {
		is_empty_row = true,
		pass_type = pass_type,
		style = {
			offset = {
				0,
				offset_y,
				0
			},
			size = size,
			color = {
				0,
				0,
				0,
				0
			}
		}
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
	end
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
	end
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
	end
}
end_player_view_blueprints.weapon_unlock = {
	pass_template_function = function (parent, config)
		local pass_template = _get_card_levelup_frame_pass_template()

		_get_level_up_label_pass_template(pass_template)
		table.append(pass_template, {
			{
				style_id = "item_display_name",
				value_id = "item_display_name",
				pass_type = "text"
			},
			{
				style_id = "item_icon_background",
				value_id = "item_icon_background",
				pass_type = "rect"
			},
			{
				value = "content/ui/materials/frames/eor_weapon_frame",
				value_id = "item_icon_frame",
				pass_type = "texture",
				style_id = "item_icon_frame"
			},
			{
				value = "content/ui/materials/icons/items/containers/item_container_landscape",
				value_id = "item_icon",
				pass_type = "texture",
				style_id = "item_icon"
			},
			{
				value_id = "weapon_unlocked_text",
				pass_type = "text",
				style_id = "weapon_unlocked_text",
				value = Localize("loc_eor_weapon_unlocked_desc")
			}
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
		content.talents_unlocked_text = Localize("loc_eor_weapon_unlocked_desc")
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
	end
}
end_player_view_blueprints.talents_unlocked = {
	pass_template_function = function (parent, config)
		local pass_template = _get_card_levelup_frame_pass_template()

		_get_level_up_label_pass_template(pass_template)

		for i = 1, 3 do
			local talent_icon_id = "talent_icon_" .. i
			local talent_icon_background_id = "talent_icon_background_" .. i
			pass_template[#pass_template + 1] = {
				value = "content/ui/materials/icons/talents/menu/talent_terminal_frame",
				pass_type = "texture",
				value_id = talent_icon_background_id,
				style_id = talent_icon_background_id
			}
			pass_template[#pass_template + 1] = {
				value = "content/ui/materials/icons/talents/talent_icon_container",
				pass_type = "texture",
				value_id = talent_icon_id,
				style_id = talent_icon_id
			}
		end

		pass_template[#pass_template + 1] = {
			value = "",
			value_id = "talents_unlocked_text",
			pass_type = "text",
			style_id = "talents_unlocked_text"
		}

		return pass_template
	end,
	style = blueprint_styles.talents_unlocked,
	size = folded_card_size,
	init = function (parent, widget, index, config)
		local content = widget.content

		_card_levelup_frame_pass_template_init(widget, index)

		content.blueprint_name = "talents_unlocked"
		content.label = Localize("loc_eor_card_title_level_up_reward")
		content.content_animation = "unlocked_talents_show_content"
		content.dim_out_animation = "unlocked_talents_dim_out_content"
		content.level_up_label = Localize("loc_eor_unlocked_talents_label")
		content.talents_unlocked_text = Localize("loc_eor_card_talent_group_unlocked")
		local unlocked_talents = config.unlocked_talents
		local widget_style = widget.style

		for i = 1, #unlocked_talents do
			local talent_icon_id = "talent_icon_" .. i
			local icon_style = widget_style[talent_icon_id]
			local material_values = icon_style.material_values
			material_values.icon_texture = unlocked_talents[i]
		end
	end
}
end_player_view_blueprints.item_reward = {
	pass_template_function = function (parent, config)
		local pass_template = {
			{
				value_id = "frame_top",
				style_id = "frame_top",
				pass_type = "texture",
				value = "content/ui/materials/frames/end_of_round/reward_random_item_upper",
				visibility_function = _card_default_frame_visibility_function
			},
			{
				value_id = "frame_middle",
				style_id = "frame_middle",
				pass_type = "texture",
				value = "content/ui/materials/frames/end_of_round/reward_random_item_middle",
				visibility_function = _card_default_frame_visibility_function
			},
			{
				value_id = "frame_bottom",
				style_id = "frame_bottom",
				pass_type = "texture",
				value = "content/ui/materials/frames/end_of_round/reward_random_item_lower",
				visibility_function = _card_default_frame_visibility_function
			},
			{
				pass_type = "rect",
				style_id = "background"
			},
			{
				value = "content/ui/materials/gradients/gradient_vertical",
				value_id = "rarity_background",
				pass_type = "texture",
				style_id = "rarity_background"
			},
			{
				value = "",
				value_id = "label",
				pass_type = "text",
				style_id = "label"
			}
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

		ColorUtils.color_copy(RaritySettings[item_rarity].color, background_color, true)
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
	end
}
end_player_view_blueprints.empty_test_card = {
	pass_template_function = function (parent, config)
		local pass_template = _get_card_default_frame_pass_template()

		return pass_template
	end,
	style = blueprint_styles.empty_test_card,
	size = folded_card_size,
	init = function (parent, widget, index, config, content_animation)
		local content = widget.content

		_card_default_frame_pass_template_init(widget, index)

		content.label = config.label or "Test"
		content.content_animation = "test"
		content.dim_out_animation = "test"
	end
}

return settings("EndPlayerViewBlueprints", end_player_view_blueprints)
