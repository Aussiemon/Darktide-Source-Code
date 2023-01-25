local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local slot_configuration = PlayerCharacterConstants.slot_configuration
local quick_wield_configuration = PlayerCharacterConstants.quick_wield_configuration
local scroll_wield_order = PlayerCharacterConstants.scroll_wield_order
local unit_flow_event = Unit.flow_event
local PlayerUnitVisualLoadout = {}
local _unwield_slot = nil

PlayerUnitVisualLoadout.wield_slot = function (slot_to_wield, player_unit, t, skip_wield_action)
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
	weapon_extension:on_slot_wielded(slot_to_wield, t, skip_wield_action)
end

PlayerUnitVisualLoadout.wield_previous_slot = function (inventory_component, unit, t)
	local previously_wielded_slot_name = inventory_component.previously_wielded_slot

	if previously_wielded_slot_name == "none" then
		return
	end

	local ability_extension = ScriptUnit.has_extension(unit, "ability_system")
	local can_wield_slot = ability_extension and ability_extension:can_wield(previously_wielded_slot_name, true)

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

	if wielded_slot == "none" then
		return nil
	end

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

local function _can_wield(slot_name, visual_loadout_extension, weapon_extension, ability_extension)
	if not visual_loadout_extension:can_wield(slot_name) then
		return false
	end

	if not weapon_extension:can_wield(slot_name) then
		return false
	end

	if not ability_extension:can_wield(slot_name) then
		return false
	end

	return true
end

local SCROLL_WRAP_ENABLED = true

PlayerUnitVisualLoadout.slot_name_from_wield_input = function (wield_input, inventory_component, visual_loadout_extension, weapon_extension, ability_extension)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-4, warpins: 1 ---
	local wielded_slot = inventory_component.wielded_slot
	local next_slot_name = nil

	if wield_input ~= "wield_scroll_down" then

		-- Decompilation error in this vicinity:
		--- BLOCK #1 5-6, warpins: 1 ---
		local wield_scroll_down = false
		--- END OF BLOCK #1 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #2 7-7, warpins: 1 ---
		local wield_scroll_down = true
		--- END OF BLOCK #2 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #1 5-6, warpins: 1 ---
	local wield_scroll_down = false
	--- END OF BLOCK #1 ---




	-- Decompilation error in this vicinity:
	--- BLOCK #2 7-7, warpins: 1 ---
	local wield_scroll_down = true

	--- END OF BLOCK #2 ---




	-- Decompilation error in this vicinity:
	--- BLOCK #3 8-9, warpins: 2 ---
	if wield_input ~= "wield_scroll_up" then

		-- Decompilation error in this vicinity:
		--- BLOCK #4 10-11, warpins: 1 ---
		local wield_scroll_up = false
		--- END OF BLOCK #4 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #5 12-12, warpins: 1 ---
		local wield_scroll_up = true
		--- END OF BLOCK #5 ---



	end

	--- END OF BLOCK #3 ---

	FLOW; TARGET BLOCK #6



	-- Decompilation error in this vicinity:
	--- BLOCK #4 10-11, warpins: 1 ---
	local wield_scroll_up = false
	--- END OF BLOCK #4 ---




	-- Decompilation error in this vicinity:
	--- BLOCK #5 12-12, warpins: 1 ---
	local wield_scroll_up = true
	--- END OF BLOCK #5 ---




	-- Decompilation error in this vicinity:
	--- BLOCK #6 13-16, warpins: 2 ---
	local slot_index = scroll_wield_order[wielded_slot]
	--- END OF BLOCK #6 ---

	FLOW; TARGET BLOCK #19



	-- Decompilation error in this vicinity:
	--- BLOCK #7 17-18, warpins: 1 ---
	--- END OF BLOCK #7 ---

	slot8 = if wield_scroll_up then
	JUMP TO BLOCK #8
	else
	JUMP TO BLOCK #23
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #8 19-20, warpins: 2 ---
	--- END OF BLOCK #8 ---

	slot9 = if slot_index then
	JUMP TO BLOCK #9
	else
	JUMP TO BLOCK #23
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #9 21-24, warpins: 1 ---
	local scroll_size = #scroll_wield_order
	--- END OF BLOCK #9 ---

	slot8 = if wield_scroll_up then
	JUMP TO BLOCK #10
	else
	JUMP TO BLOCK #11
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #10 25-26, warpins: 1 ---
	slot11 = 1
	--- END OF BLOCK #10 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #12



	-- Decompilation error in this vicinity:
	--- BLOCK #11 27-27, warpins: 1 ---
	local index_change = -1
	--- END OF BLOCK #11 ---

	FLOW; TARGET BLOCK #12



	-- Decompilation error in this vicinity:
	--- BLOCK #12 28-29, warpins: 2 ---
	local wrap = SCROLL_WRAP_ENABLED
	local next_slot_index = slot_index
	--- END OF BLOCK #12 ---

	FLOW; TARGET BLOCK #13



	-- Decompilation error in this vicinity:
	--- BLOCK #13 30-30, warpins: 2 ---
	--- END OF BLOCK #13 ---

	FLOW; TARGET BLOCK #13



	-- Decompilation error in this vicinity:
	--- BLOCK #14 31-33, warpins: 1 ---
	next_slot_index = next_slot_index + index_change
	--- END OF BLOCK #14 ---

	slot12 = if wrap then
	JUMP TO BLOCK #15
	else
	JUMP TO BLOCK #16
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #15 34-39, warpins: 1 ---
	next_slot_index = math.index_wrapper(next_slot_index, scroll_size)
	--- END OF BLOCK #15 ---

	FLOW; TARGET BLOCK #16



	-- Decompilation error in this vicinity:
	--- BLOCK #16 40-43, warpins: 2 ---
	local scroll_slot_name = scroll_wield_order[next_slot_index]

	--- END OF BLOCK #16 ---

	slot14 = if not scroll_slot_name then
	JUMP TO BLOCK #17
	else
	JUMP TO BLOCK #18
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #17 44-44, warpins: 1 ---
	break

	--- END OF BLOCK #17 ---

	FLOW; TARGET BLOCK #18



	-- Decompilation error in this vicinity:
	--- BLOCK #18 45-52, warpins: 1 ---
	local can_wield = _can_wield(scroll_slot_name, visual_loadout_extension, weapon_extension, ability_extension)
	--- END OF BLOCK #18 ---

	slot15 = if can_wield then
	JUMP TO BLOCK #19
	else
	JUMP TO BLOCK #20
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #19 53-54, warpins: 1 ---
	next_slot_name = scroll_slot_name

	break

	--- END OF BLOCK #19 ---




	-- Decompilation error in this vicinity:
	--- BLOCK #20 55-56, warpins: 1 ---
	--- END OF BLOCK #20 ---

	if next_slot_index == slot_index then
	JUMP TO BLOCK #21
	else
	JUMP TO BLOCK #13
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #21 57-58, warpins: 3 ---
	--- END OF BLOCK #21 ---

	slot6 = if not next_slot_name then
	JUMP TO BLOCK #22
	else
	JUMP TO BLOCK #23
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #22 59-59, warpins: 1 ---
	next_slot_name = wielded_slot

	--- END OF BLOCK #22 ---

	FLOW; TARGET BLOCK #23



	-- Decompilation error in this vicinity:
	--- BLOCK #23 60-61, warpins: 4 ---
	--- END OF BLOCK #23 ---

	slot6 = if next_slot_name then
	JUMP TO BLOCK #24
	else
	JUMP TO BLOCK #25
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #24 62-63, warpins: 1 ---
	return next_slot_name

	--- END OF BLOCK #24 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #34



	-- Decompilation error in this vicinity:
	--- BLOCK #25 64-65, warpins: 1 ---
	--- END OF BLOCK #25 ---

	if wield_input ~= "quick_wield" then
	JUMP TO BLOCK #26
	else
	JUMP TO BLOCK #29
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #26 66-67, warpins: 1 ---
	--- END OF BLOCK #26 ---

	slot7 = if not wield_scroll_down then
	JUMP TO BLOCK #27
	else
	JUMP TO BLOCK #28
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #27 68-69, warpins: 1 ---
	--- END OF BLOCK #27 ---

	slot8 = if wield_scroll_up then
	JUMP TO BLOCK #28
	else
	JUMP TO BLOCK #32
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #28 70-71, warpins: 2 ---
	--- END OF BLOCK #28 ---

	slot6 = if not next_slot_name then
	JUMP TO BLOCK #29
	else
	JUMP TO BLOCK #32
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #29 72-75, warpins: 2 ---
	next_slot_name = quick_wield_configuration[wielded_slot]
	--- END OF BLOCK #29 ---

	slot6 = if not next_slot_name then
	JUMP TO BLOCK #30
	else
	JUMP TO BLOCK #31
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #30 76-77, warpins: 1 ---
	next_slot_name = quick_wield_configuration.default

	--- END OF BLOCK #30 ---

	FLOW; TARGET BLOCK #31



	-- Decompilation error in this vicinity:
	--- BLOCK #31 78-79, warpins: 2 ---
	return next_slot_name

	--- END OF BLOCK #31 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #34



	-- Decompilation error in this vicinity:
	--- BLOCK #32 80-83, warpins: 2 ---
	--- END OF BLOCK #32 ---

	FLOW; TARGET BLOCK #33



	-- Decompilation error in this vicinity:
	--- BLOCK #33 84-92, warpins: 0 ---
	for slot_name, config in pairs(slot_configuration) do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 84-86, warpins: 1 ---
		--- END OF BLOCK #0 ---

		slot15 = if config.wieldable then
		JUMP TO BLOCK #1
		else
		JUMP TO BLOCK #3
		end



		-- Decompilation error in this vicinity:
		--- BLOCK #1 87-89, warpins: 1 ---
		--- END OF BLOCK #1 ---

		if config.wield_input == wield_input then
		JUMP TO BLOCK #2
		else
		JUMP TO BLOCK #3
		end



		-- Decompilation error in this vicinity:
		--- BLOCK #2 90-90, warpins: 1 ---
		return slot_name
		--- END OF BLOCK #2 ---

		FLOW; TARGET BLOCK #3



		-- Decompilation error in this vicinity:
		--- BLOCK #3 91-92, warpins: 4 ---
		--- END OF BLOCK #3 ---



	end

	--- END OF BLOCK #33 ---

	FLOW; TARGET BLOCK #34



	-- Decompilation error in this vicinity:
	--- BLOCK #34 93-93, warpins: 3 ---
	return
	--- END OF BLOCK #34 ---



end

PlayerUnitVisualLoadout.wield_input_from_slot_name = function (slot_name)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-4, warpins: 1 ---
	local slot_config = slot_configuration[slot_name]

	return slot_config.wield_input
	--- END OF BLOCK #0 ---



end

PlayerUnitVisualLoadout.slot_is_wieldable = function (visual_loadout_extension, slot_name)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	local visual_loadout_slot_configuration = visual_loadout_extension:slot_configuration()
	local slot_config = visual_loadout_slot_configuration[slot_name]

	return slot_config.wieldable
	--- END OF BLOCK #0 ---



end

PlayerUnitVisualLoadout.wielded_slot_disallows_ladders = function (visual_loadout_extension, inventory_component)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	--- END OF BLOCK #0 ---

	if inventory_component.wielded_slot == "none" then
	JUMP TO BLOCK #1
	else
	JUMP TO BLOCK #2
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #1 4-5, warpins: 1 ---
	return false

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 6-12, warpins: 2 ---
	local wielded_slot_configuration = visual_loadout_extension:wielded_slot_configuration()
	local disallow_ladders_on_wield = not not wielded_slot_configuration.disallow_ladders_on_wield

	return disallow_ladders_on_wield
	--- END OF BLOCK #2 ---



end

PlayerUnitVisualLoadout.slot_flow_event = function (first_person_extension, visual_loadout_extension, inventory_slot, flow_event_name)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	--- END OF BLOCK #0 ---

	if inventory_slot == "none" then
	JUMP TO BLOCK #1
	else
	JUMP TO BLOCK #2
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #1 3-3, warpins: 1 ---
	return

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 4-12, warpins: 2 ---
	local is_first_person = first_person_extension:is_in_first_person_mode()
	local unit_1p, unit_3p, attachments_1p, attachments_3p = visual_loadout_extension:unit_and_attachments_from_slot(inventory_slot)

	--- END OF BLOCK #2 ---

	slot4 = if is_first_person then
	JUMP TO BLOCK #3
	else
	JUMP TO BLOCK #9
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #3 13-14, warpins: 1 ---
	--- END OF BLOCK #3 ---

	slot5 = if unit_1p then
	JUMP TO BLOCK #4
	else
	JUMP TO BLOCK #5
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #4 15-18, warpins: 1 ---
	unit_flow_event(unit_1p, flow_event_name)

	--- END OF BLOCK #4 ---

	FLOW; TARGET BLOCK #5



	-- Decompilation error in this vicinity:
	--- BLOCK #5 19-20, warpins: 2 ---
	--- END OF BLOCK #5 ---

	slot7 = if attachments_1p then
	JUMP TO BLOCK #6
	else
	JUMP TO BLOCK #14
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #6 21-24, warpins: 1 ---
	--- END OF BLOCK #6 ---

	FLOW; TARGET BLOCK #7



	-- Decompilation error in this vicinity:
	--- BLOCK #7 25-30, warpins: 0 ---
	for i = 1, #attachments_1p do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 25-30, warpins: 2 ---
		local attachment_unit = attachments_1p[i]

		unit_flow_event(attachment_unit, flow_event_name)
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #7 ---

	FLOW; TARGET BLOCK #8



	-- Decompilation error in this vicinity:
	--- BLOCK #8 31-31, warpins: 1 ---
	--- END OF BLOCK #8 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #14



	-- Decompilation error in this vicinity:
	--- BLOCK #9 32-33, warpins: 1 ---
	--- END OF BLOCK #9 ---

	slot6 = if unit_3p then
	JUMP TO BLOCK #10
	else
	JUMP TO BLOCK #11
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #10 34-37, warpins: 1 ---
	unit_flow_event(unit_3p, flow_event_name)

	--- END OF BLOCK #10 ---

	FLOW; TARGET BLOCK #11



	-- Decompilation error in this vicinity:
	--- BLOCK #11 38-39, warpins: 2 ---
	--- END OF BLOCK #11 ---

	slot8 = if attachments_3p then
	JUMP TO BLOCK #12
	else
	JUMP TO BLOCK #14
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #12 40-43, warpins: 1 ---
	--- END OF BLOCK #12 ---

	FLOW; TARGET BLOCK #13



	-- Decompilation error in this vicinity:
	--- BLOCK #13 44-49, warpins: 0 ---
	for i = 3, #attachments_3p do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 44-49, warpins: 2 ---
		local attachment_unit = attachments_3p[i]

		unit_flow_event(attachment_unit, flow_event_name)
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #13 ---

	FLOW; TARGET BLOCK #14



	-- Decompilation error in this vicinity:
	--- BLOCK #14 50-50, warpins: 4 ---
	return
	--- END OF BLOCK #14 ---



end

function _unwield_slot(slot_to_unwield, visual_loadout_extension, weapon_extension, t)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-10, warpins: 1 ---
	weapon_extension:on_slot_unwielded(slot_to_unwield, t)
	visual_loadout_extension:unwield_slot(slot_to_unwield)

	return
	--- END OF BLOCK #0 ---



end

PlayerUnitVisualLoadout.slot_to_slot_type = function (slot)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-4, warpins: 1 ---
	local slot_config = slot_configuration[slot]
	local slot_type = slot_config.slot_type

	return slot_type
	--- END OF BLOCK #0 ---



end

PlayerUnitVisualLoadout.is_slot_of_type = function (slot, slot_type)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	--- END OF BLOCK #0 ---

	if slot == "none" then
	JUMP TO BLOCK #1
	else
	JUMP TO BLOCK #2
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #1 3-4, warpins: 1 ---
	return false

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 5-10, warpins: 2 ---
	local current_slot_type = PlayerUnitVisualLoadout.slot_to_slot_type(slot)
	--- END OF BLOCK #2 ---

	if current_slot_type ~= slot_type then
	JUMP TO BLOCK #3
	else
	JUMP TO BLOCK #4
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #3 11-12, warpins: 1 ---
	slot3 = false
	--- END OF BLOCK #3 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #5



	-- Decompilation error in this vicinity:
	--- BLOCK #4 13-13, warpins: 1 ---
	local is_of_type = true

	--- END OF BLOCK #4 ---

	FLOW; TARGET BLOCK #5



	-- Decompilation error in this vicinity:
	--- BLOCK #5 14-14, warpins: 2 ---
	return is_of_type
	--- END OF BLOCK #5 ---



end

PlayerUnitVisualLoadout.slot_config_from_slot_name = function (slot_name)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	return slot_configuration[slot_name]
	--- END OF BLOCK #0 ---



end

return PlayerUnitVisualLoadout
