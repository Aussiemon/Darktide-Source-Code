local ItemUtils = require("scripts/utilities/items")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewAnimations = require("scripts/ui/views/end_player_view/end_player_view_animations")
local ViewStyles = require("scripts/ui/views/end_player_view/end_player_view_styles")
local WalletSettings = require("scripts/settings/wallet_settings")
local blueprint_styles = ViewStyles.blueprints
local ITEM_TYPES = UISettings.ITEM_TYPES
local folded_card_size = {
	ViewStyles.card_width,
	ViewStyles.card_folded_height
}
local end_player_view_blueprints = {}

local function _get_card_frame_pass_template()
	local card_frame_pass_template = {
		{
			value = "content/ui/materials/frames/end_of_round/reward_upper",
			value_id = "frame_top",
			pass_type = "texture",
			style_id = "frame_top"
		},
		{
			value = "content/ui/materials/frames/end_of_round/reward_middle",
			value_id = "frame_middle",
			pass_type = "texture",
			style_id = "frame_middle"
		},
		{
			value = "content/ui/materials/frames/end_of_round/reward_lower",
			value_id = "frame_bottom",
			pass_type = "texture",
			style_id = "frame_bottom"
		},
		{
			pass_type = "rect",
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

local function _card_frame_pass_template_init(widget, index)
	local style = widget.style
	widget.offset[1] = index * ViewStyles.card_offset_x
	local frame_color = table.clone(style.dimmed_out_color)
	style.frame_top.color = frame_color
	style.frame_middle.color = frame_color
	style.frame_bottom.color = frame_color
	style.frame_color = frame_color
	style.text_color = table.clone(style.in_focus_text_color)
end

local function _get_currency_icon(pass_template, currency)
	local background_id, icon_id, icon_material = nil

	if currency then
		background_id = currency .. "_icon_background"
		icon_id = currency .. "_icon"
		local wallet_settings = WalletSettings[currency]
		icon_material = wallet_settings and wallet_settings.icon_texture_big
	else
		background_id = "icon_background"
		icon_id = "icon"
	end

	icon_material = icon_material or WalletSettings.plasteel.icon_texture_big
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

	local next_index = pass_template[last_index].pass_type == "empty_row" and last_index or last_index + 1
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

local function _get_item_pass_templates(pass_template, item, item_group)
	local item_rarity = item.rarity or 1
	local icon_material, style = nil

	if item_group == "outfits" or item_group == "poses" or item_group == "emotes" then
		icon_material = UISettings.item_rarity_texture_types.portrait[item_rarity]
		style = blueprint_styles.pass_styles.item_icon_portrait
	elseif item_group == "weapons" or item_group == "devices" then
		icon_material = UISettings.item_rarity_texture_types.landscape[item_rarity]
		style = blueprint_styles.pass_styles.item_icon_landscape
	elseif item_group == "nameplates" then
		icon_material = UISettings.item_rarity_texture_types.square[item_rarity]
		style = blueprint_styles.pass_styles.item_icon_square
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
			value_id = "item_icon",
			style_id = "item_icon",
			pass_type = "texture",
			value = icon_material,
			style = style
		},
		{
			style_id = "item_sub_display_name",
			value_id = "item_sub_display_name",
			pass_type = "text"
		}
	})
end

local function _item_pass_template_init(widget, config)
	local content = widget.content
	local reward_item = config.reward_item
	local item_group = config.item_group
	content.reward_item = reward_item
	content.item_display_name = ItemUtils.display_name(reward_item)
	content.item_sub_display_name = ItemUtils.sub_display_name(reward_item)
	content.item_group = item_group
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

local function _apply_live_item_icon_cb_func(widget, grid_index, rows, columns)
	local widget_style = widget.style
	local icon_style = widget_style.item_icon
	local material_values = icon_style.material_values
	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
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
		local cb = nil

		if content.item_group == "nameplates" then
			cb = callback(_apply_live_nameplate_icon_cb_func, widget)
		else
			cb = callback(_apply_live_item_icon_cb_func, widget)
		end

		content.icon_load_id = Managers.ui:load_item_icon(reward_item, cb)
	end
end

local function _reward_unload_icon_func(parent, widget, element, ui_renderer)
	local content = widget.content

	if content.icon_load_id then
		_remove_live_item_icon_cb_func(widget, ui_renderer)
		Managers.ui:unload_item_icon(content.icon_load_id)

		content.icon_load_id = nil
	end
end

local function _reward_destroy_icon_func(parent, widget, element, ui_renderer)
	local content = widget.content

	if content.icon_load_id then
		_remove_live_item_icon_cb_func(widget, ui_renderer)
		Managers.ui:unload_item_icon(content.icon_load_id)

		content.icon_load_id = nil
	end
end

local function _get_talents_passes(pass_template, group_name, talent_icons)
	pass_template[#pass_template + 1] = {
		value_id = "unlocked_talents_label",
		pass_type = "text",
		style_id = "unlocked_talents_label",
		value = Localize("loc_eor_unlocked_talents_label")
	}

	for i = 1, #talent_icons do
		local alignment = i == 1 and "left" or i == 2 and "center" or "right"
		pass_template[#pass_template + 1] = {
			pass_type = "texture",
			value_id = "talent_icon_" .. alignment,
			style_id = "talent_icon_" .. alignment,
			value = talent_icons[i]
		}
		pass_template[#pass_template + 1] = {
			value = "content/ui/materials/icons/talents/menu/frame_inactive",
			pass_type = "texture",
			value_id = "talent_icon_frame_" .. alignment,
			style_id = "talent_icon_frame_" .. alignment
		}
	end

	pass_template[#pass_template + 1] = {
		value_id = "talent_group_name",
		pass_type = "text",
		style_id = "talent_group_name",
		value = Localize(group_name)
	}
end

local function _insert_empty_row(pass_template)
	local previous_row_style = pass_template[#pass_template].style
	local offset_y = previous_row_style.offset[2] + previous_row_style.size[2]
	local size = {
		[2] = ViewStyles.card_content_empty_row_height
	}
	pass_template[#pass_template + 1] = {
		pass_type = "empty_row",
		style = {
			offset = {
				nil,
				offset_y,
				0
			},
			size = size
		}
	}
end

end_player_view_blueprints.experience = {
	pass_template_function = function (parent, config)
		local pass_template = _get_card_frame_pass_template()

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

		_card_frame_pass_template_init(widget, index)

		content.label = Localize("loc_eor_card_title_experience")
		local details = config.rewards[1].details
		local circumstance_xp = details.from_circumstance
		local side_mission_xp = details.from_side_mission
		local side_mission_bonus_xp = details.from_side_mission_bonus
		local total_bonus_xp = details.from_total_bonus
		content.base_xp = details.total - (circumstance_xp + side_mission_xp + side_mission_bonus_xp + total_bonus_xp)
		content.base_xp_previous_value = 0
		content.side_mission_xp = side_mission_xp
		content.side_mission_xp_previous_value = content.base_xp_previous_value + content.base_xp
		content.circumstance_xp = circumstance_xp
		content.circumstance_xp_previous_value = content.side_mission_xp_previous_value + content.side_mission_xp
		content.side_mission_bonus_xp = side_mission_bonus_xp
		content.side_mission_bonus_xp_previous_value = content.circumstance_xp_previous_value + content.circumstance_xp
		content.total_bonus_xp = total_bonus_xp
		content.total_bonus_xp_previous_value = content.side_mission_bonus_xp_previous_value + content.side_mission_bonus_xp
		content.update_progress_func = callback(parent, "update_xp_bar")
		content.content_animation = "experience_card_show_content"
		content.content_animation_states = {}
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
		local pass_template = _get_card_frame_pass_template()
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

		_card_frame_pass_template_init(widget, index)

		content.label = Localize("loc_eor_card_title_salary")
		local rewards = config.rewards

		for i = 1, #rewards do
			local reward = rewards[i]
			local currency = reward.currency
			local details = reward.details
			local from_circumstance = details.from_circumstance
			local from_side_mission = details.from_side_mission
			local previous_amount = reward.current_amount - reward.amount_gained
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

		content.update_progress_func = callback(parent, "update_wallet")
		content.content_animation = "salary_card_show_content"
		content.content_animation_states = {}
	end
}
end_player_view_blueprints.item_reward = {
	pass_template_function = function (parent, config)
		local item_group = config.item_group
		local pass_template = _get_card_frame_pass_template()
		local reward_item = config.reward_item

		_get_item_pass_templates(pass_template, reward_item, item_group)

		return pass_template
	end,
	style = blueprint_styles.item_reward_card,
	size = folded_card_size,
	init = function (parent, widget, index, config)
		local content = widget.content

		_card_frame_pass_template_init(widget, index)
		_item_pass_template_init(widget, config)

		content.label = Localize("loc_eor_card_title_random_reward")
		content.content_animation = "item_reward_show_content"
	end,
	load_icon = _reward_load_icon_func,
	unload_icon = _reward_unload_icon_func,
	destroy = _reward_destroy_icon_func
}
end_player_view_blueprints.level_up = {
	pass_template_function = function (parent, config)
		local item_group = config.item_group
		local pass_template = _get_card_frame_pass_template()
		pass_template[#pass_template + 1] = {
			value = "content/ui/materials/effects/end_of_round/level_up_frame",
			value_id = "level_up_frame",
			pass_type = "texture",
			style_id = "level_up_frame"
		}
		local reward_item = config.reward_item

		_get_item_pass_templates(pass_template, reward_item, item_group)

		local talent_group_name = config.talent_group_name
		local unlocked_talents = config.unlocked_talents

		if unlocked_talents then
			_get_talents_passes(pass_template, talent_group_name, unlocked_talents)
		end

		return pass_template
	end,
	style = blueprint_styles.level_up_card,
	size = folded_card_size,
	init = function (parent, widget, index, config)
		local content = widget.content

		_card_frame_pass_template_init(widget, index)
		_item_pass_template_init(widget, config)

		content.blueprint_name = "level_up"
		content.label = Localize("loc_eor_card_title_level_up_reward")
		content.content_animation = config.unlocked_talents and "level_up_show_content" or "item_reward_show_content"
	end,
	load_icon = _reward_load_icon_func,
	unload_icon = _reward_unload_icon_func,
	destroy = _reward_destroy_icon_func
}
end_player_view_blueprints.level_up_talents_only = {
	pass_template_function = function (parent, config)
		local pass_template = _get_card_frame_pass_template()
		pass_template[#pass_template + 1] = {
			value = "content/ui/materials/effects/end_of_round/level_up_frame",
			value_id = "level_up_frame",
			pass_type = "texture",
			style_id = "level_up_frame"
		}
		local talent_group_name = config.talent_group_name
		local unlocked_talents = config.unlocked_talents

		_get_talents_passes(pass_template, talent_group_name, unlocked_talents)

		return pass_template
	end,
	style = blueprint_styles.level_up_talents_only_card,
	size = folded_card_size,
	init = function (parent, widget, index, config)
		local content = widget.content

		_card_frame_pass_template_init(widget, index)

		content.blueprint_name = "level_up"
		content.label = Localize("loc_eor_card_title_level_up_reward")
		content.content_animation = "unlocked_talents_show_content"
	end,
	load_icon = _reward_load_icon_func,
	unload_icon = _reward_unload_icon_func,
	destroy = _reward_destroy_icon_func
}
end_player_view_blueprints.empty_test_card = {
	pass_template_function = function (parent, config)
		local pass_template = _get_card_frame_pass_template()

		return pass_template
	end,
	style = blueprint_styles.empty_test_card,
	size = folded_card_size,
	init = function (parent, widget, index, config, content_animation)
		local content = widget.content

		_card_frame_pass_template_init(widget, index)

		content.label = config.label or "Test"
		content.content_animation = "test"
	end
}

return settings("EndPlayerViewBlueprints", end_player_view_blueprints)
