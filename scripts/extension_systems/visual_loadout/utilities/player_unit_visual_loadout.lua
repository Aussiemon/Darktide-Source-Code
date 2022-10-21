local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local slot_configuration = PlayerCharacterConstants.slot_configuration
local quick_wield_configuration = PlayerCharacterConstants.quick_wield_configuration
local scroll_wield_order = PlayerCharacterConstants.scroll_wield_order
local unit_flow_event = Unit.flow_event
local PlayerUnitVisualLoadout = {}
local _unwield_slot = nil

PlayerUnitVisualLoadout.wield_slot = function (slot_to_wield, player_unit, t)
	local visual_loadout_extension = ScriptUnit.extension(player_unit, "visual_loadout_system")
	local weapon_extension = ScriptUnit.extension(player_unit, "weapon_system")
	local animation_extension = ScriptUnit.extension(player_unit, "animation_system")
	local action_input_extension = ScriptUnit.extension(player_unit, "action_input_system")
	local inventory_comp = ScriptUnit.extension(player_unit, "unit_data_system"):read_component("inventory")
	local wielded_slot = inventory_comp.wielded_slot

	if wielded_slot ~= visual_loadout_extension.NO_WIELDED_SLOT then
		_unwield_slot(wielded_slot, visual_loadout_extension, weapon_extension, t)
	end

	action_input_extension:clear_input_queue_and_sequences("weapon_action")
	visual_loadout_extension:wield_slot(slot_to_wield)

	local weapon_template = visual_loadout_extension:weapon_template_from_slot(slot_to_wield)

	animation_extension:inventory_slot_wielded(weapon_template, t)
	weapon_extension:on_slot_wielded(slot_to_wield, t)
end

PlayerUnitVisualLoadout.wield_previous_slot = function (inventory_component, unit, t)
	local previously_wielded_slot_name = inventory_component.previously_wielded_slot

	if previously_wielded_slot_name == "none" then
		return
	end

	local ability_extension = ScriptUnit.has_extension(unit, "ability_system")
	local can_wield_slot = ability_extension and ability_extension:can_wield(previously_wielded_slot_name)

	if can_wield_slot then
		PlayerUnitVisualLoadout.wield_slot(previously_wielded_slot_name, unit, t)
	else
		PlayerUnitVisualLoadout.wield_previous_weapon_slot(inventory_component, unit, t)
	end
end

PlayerUnitVisualLoadout.wield_previous_weapon_slot = function (inventory_component, unit, t)
	local previously_wielded_weapon_slot_name = inventory_component.previously_wielded_weapon_slot

	if previously_wielded_weapon_slot_name == "none" then
		return
	end

	PlayerUnitVisualLoadout.wield_slot(previously_wielded_weapon_slot_name, unit, t)
end

PlayerUnitVisualLoadout.wield_slot_husk = function (unit, slot_to_wield, visual_loadout_extension, animation_extension)
	visual_loadout_extension:wield_slot(slot_to_wield)

	local weapon_template = visual_loadout_extension:weapon_template_from_slot(slot_to_wield)

	animation_extension:inventory_slot_wielded(weapon_template)

	local aim_extension = ScriptUnit.has_extension(unit, "aim_system")

	if aim_extension then
		aim_extension:state_machine_changed(unit)
	end
end

PlayerUnitVisualLoadout.unwield_slot_husk = function (slot_to_unwield, visual_loadout_extension)
	visual_loadout_extension:unwield_slot(slot_to_unwield)
end

PlayerUnitVisualLoadout.slot_equipped = function (inventory_component, visual_loadout_extension, slot_name)
	return inventory_component[slot_name] ~= visual_loadout_extension.UNEQUIPPED_SLOT
end

PlayerUnitVisualLoadout.unequip_item_from_slot = function (player_unit, slot_name, t)
	local inventory = ScriptUnit.extension(player_unit, "unit_data_system"):read_component("inventory")
	local visual_loadout_extension = ScriptUnit.extension(player_unit, "visual_loadout_system")

	fassert(inventory[slot_name] ~= visual_loadout_extension.UNEQUIPPED_SLOT, "[PlayerUnitVisualLoadout] %s was already unequipped!", slot_name)

	if inventory.wielded_slot == slot_name then
		local weapon_extension = ScriptUnit.extension(player_unit, "weapon_system")

		_unwield_slot(slot_name, visual_loadout_extension, weapon_extension, t)
	end

	local slot_config = slot_configuration[slot_name]
	local slot_type = slot_config.slot_type
	local gadget_slot = slot_type == "gadget"

	if gadget_slot then
		local item = visual_loadout_extension:item_in_slot(slot_name)
		local gadget_extension = ScriptUnit.extension(player_unit, "gadget_system")

		gadget_extension:on_slot_unequipped(item, slot_name)
	end

	local fixed_frame = t / GameParameters.fixed_time_step

	visual_loadout_extension:unequip_item_from_slot(slot_name, fixed_frame)
end

PlayerUnitVisualLoadout.equip_item_to_slot = function (player_unit, item, slot_name, optional_existing_unit_3p, t)
	local inventory = ScriptUnit.extension(player_unit, "unit_data_system"):read_component("inventory")
	local visual_loadout_extension = ScriptUnit.extension(player_unit, "visual_loadout_system")
	local wield_equipped_slot = false

	if inventory[slot_name] ~= visual_loadout_extension.UNEQUIPPED_SLOT then
		wield_equipped_slot = inventory.wielded_slot == slot_name

		PlayerUnitVisualLoadout.unequip_item_from_slot(player_unit, slot_name, t)
	end

	visual_loadout_extension:equip_item_to_slot(item, slot_name, optional_existing_unit_3p, t)

	local slot_config = slot_configuration[slot_name]
	local slot_type = slot_config.slot_type
	local gadget_slot = slot_type == "gadget"

	if gadget_slot then
		local gadget_extension = ScriptUnit.extension(player_unit, "gadget_system")

		gadget_extension:on_slot_equipped(item, slot_name)
	end

	if wield_equipped_slot then
		PlayerUnitVisualLoadout.wield_slot(slot_name, player_unit, t)
	end

	if not DEDICATED_SERVER then
		local has_outline_system = Managers.state.extension:has_system("outline_system")

		if has_outline_system then
			local outline_system = Managers.state.extension:system("outline_system")

			outline_system:trigger_outline_update(player_unit)
		end
	end
end

PlayerUnitVisualLoadout.wielded_weapon_template = function (visual_loadout_extension, inventory_component)
	local wielded_slot = inventory_component.wielded_slot
	local weapon_template = visual_loadout_extension:weapon_template_from_slot(wielded_slot)

	return weapon_template
end

PlayerUnitVisualLoadout.has_wielded_weapon_keyword = function (visual_loadout_extension, inventory_component, keyword)
	local weapon_template = PlayerUnitVisualLoadout.wielded_weapon_template(visual_loadout_extension, inventory_component)
	local keywords = weapon_template and weapon_template.keywords
	local has_keyword = keywords and table.index_of(keywords, keyword) > 0

	return has_keyword
end

PlayerUnitVisualLoadout.has_weapon_keyword_from_slot = function (visual_loadout_extension, slot_name, keyword)
	local weapon_template = visual_loadout_extension:weapon_template_from_slot(slot_name)
	local keywords = weapon_template and weapon_template.keywords
	local has_keyword = keywords and table.index_of(keywords, keyword) > 0

	return has_keyword
end

PlayerUnitVisualLoadout.slot_name_from_wield_input = function (wield_input, inventory_component)
	local wielded_slot = inventory_component.wielded_slot
	local next_slot_name = nil
	local wield_prev = wield_input == "wield_prev"
	local wield_next = wield_input == "wield_next"

	if wield_prev or wield_next then
		local slot_index = scroll_wield_order[wielded_slot]

		if slot_index then
			local next_slot_index = math.clamp(wield_prev and slot_index - 1 or slot_index + 1, 1, #scroll_wield_order)
			next_slot_name = scroll_wield_order[next_slot_index]
		end
	end

	if next_slot_name then
		return next_slot_name
	elseif wield_input == "quick_wield" or (wield_prev or wield_next) and not next_slot_name then
		next_slot_name = quick_wield_configuration[wielded_slot]
		next_slot_name = next_slot_name or quick_wield_configuration.default

		return next_slot_name
	else
		for slot_name, config in pairs(slot_configuration) do
			if config.wieldable and config.wield_input == wield_input then
				return slot_name
			end
		end
	end
end

PlayerUnitVisualLoadout.wield_input_from_slot_name = function (slot_name)
	local slot_config = slot_configuration[slot_name]

	fassert(slot_config.wieldable, "Slot %q is not a wieldable slot. Can't find wield_input.", slot_name)
	fassert(slot_config.wield_input, "Slot %q can't be wielded from input. Can't find wield_input.", slot_name)

	return slot_config.wield_input
end

PlayerUnitVisualLoadout.slot_is_wieldable = function (visual_loadout_extension, slot_name)
	local visual_loadout_slot_configuration = visual_loadout_extension:slot_configuration()
	local slot_config = visual_loadout_slot_configuration[slot_name]

	return slot_config.wieldable
end

PlayerUnitVisualLoadout.wielded_slot_disallows_ladders = function (visual_loadout_extension, inventory_component)
	if inventory_component.wielded_slot == "none" then
		return false
	end

	local wielded_slot_configuration = visual_loadout_extension:wielded_slot_configuration()
	local disallow_ladders_on_wield = not not wielded_slot_configuration.disallow_ladders_on_wield

	return disallow_ladders_on_wield
end

PlayerUnitVisualLoadout.slot_flow_event = function (first_person_extension, visual_loadout_extension, inventory_slot, flow_event_name)
	if inventory_slot == "none" then
		return
	end

	local is_first_person = first_person_extension:is_in_first_person_mode()
	local unit_1p, unit_3p, attachments_1p, attachments_3p = visual_loadout_extension:unit_and_attachments_from_slot(inventory_slot)

	if is_first_person then
		if unit_1p then
			unit_flow_event(unit_1p, flow_event_name)
		end

		if attachments_1p then
			for i = 1, #attachments_1p do
				local attachment_unit = attachments_1p[i]

				unit_flow_event(attachment_unit, flow_event_name)
			end
		end
	else
		if unit_3p then
			unit_flow_event(unit_3p, flow_event_name)
		end

		if attachments_3p then
			for i = 3, #attachments_3p do
				local attachment_unit = attachments_3p[i]

				unit_flow_event(attachment_unit, flow_event_name)
			end
		end
	end
end

function _unwield_slot(slot_to_unwield, visual_loadout_extension, weapon_extension, t)
	weapon_extension:on_slot_unwielded(slot_to_unwield, t)
	visual_loadout_extension:unwield_slot(slot_to_unwield)
end

PlayerUnitVisualLoadout.slot_to_slot_type = function (slot)
	local slot_config = slot_configuration[slot]
	local slot_type = slot_config.slot_type

	return slot_type
end

PlayerUnitVisualLoadout.is_slot_of_type = function (slot, slot_type)
	if slot == "none" then
		return false
	end

	local current_slot_type = PlayerUnitVisualLoadout.slot_to_slot_type(slot)
	local is_of_type = current_slot_type == slot_type

	return is_of_type
end

PlayerUnitVisualLoadout.slot_config_from_slot_name = function (slot_name)
	return slot_configuration[slot_name]
end

return PlayerUnitVisualLoadout
