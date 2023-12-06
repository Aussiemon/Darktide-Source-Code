local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local slot_configuration = PlayerCharacterConstants.slot_configuration
local gamepad_pocketable_wield_configuration = PlayerCharacterConstants.gamepad_pocketable_wield_configuration
local quick_wield_configuration = PlayerCharacterConstants.quick_wield_configuration
local scroll_wield_order = PlayerCharacterConstants.scroll_wield_order
local unit_flow_event = Unit.flow_event
local PlayerUnitVisualLoadout = {}
local _can_wield_from_scroll_input, _unwield_slot = nil

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
	if visual_loadout_extension.is_husk then
		return visual_loadout_extension:item_from_slot(slot_name) ~= nil
	end

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

	local fixed_frame = t / Managers.state.game_session.fixed_time_step

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

PlayerUnitVisualLoadout.slot_name_from_wield_input = function (wield_input, inventory_component, visual_loadout_extension, weapon_extension, ability_extension, input_extension)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-4, warpins: 1 ---
	local wielded_slot = inventory_component.wielded_slot
	local next_slot_name = nil

	if wield_input ~= "quick_wield" then

		-- Decompilation error in this vicinity:
		--- BLOCK #1 5-6, warpins: 1 ---
		local quick_wield = false
		--- END OF BLOCK #1 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #2 7-7, warpins: 1 ---
		local quick_wield = true
		--- END OF BLOCK #2 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #1 5-6, warpins: 1 ---
	local quick_wield = false
	--- END OF BLOCK #1 ---




	-- Decompilation error in this vicinity:
	--- BLOCK #2 7-7, warpins: 1 ---
	local quick_wield = true

	--- END OF BLOCK #2 ---




	-- Decompilation error in this vicinity:
	--- BLOCK #3 8-9, warpins: 2 ---
	if wield_input ~= "wield_scroll_down" then

		-- Decompilation error in this vicinity:
		--- BLOCK #4 10-11, warpins: 1 ---
		local wield_scroll_down = false
		--- END OF BLOCK #4 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #5 12-12, warpins: 1 ---
		local wield_scroll_down = true
		--- END OF BLOCK #5 ---



	end

	--- END OF BLOCK #3 ---

	FLOW; TARGET BLOCK #6



	-- Decompilation error in this vicinity:
	--- BLOCK #4 10-11, warpins: 1 ---
	local wield_scroll_down = false
	--- END OF BLOCK #4 ---




	-- Decompilation error in this vicinity:
	--- BLOCK #5 12-12, warpins: 1 ---
	local wield_scroll_down = true

	--- END OF BLOCK #5 ---




	-- Decompilation error in this vicinity:
	--- BLOCK #6 13-14, warpins: 2 ---
	if wield_input ~= "wield_scroll_up" then

		-- Decompilation error in this vicinity:
		--- BLOCK #7 15-16, warpins: 1 ---
		local wield_scroll_up = false
		--- END OF BLOCK #7 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #8 17-17, warpins: 1 ---
		local wield_scroll_up = true
		--- END OF BLOCK #8 ---



	end

	--- END OF BLOCK #6 ---

	FLOW; TARGET BLOCK #9



	-- Decompilation error in this vicinity:
	--- BLOCK #7 15-16, warpins: 1 ---
	local wield_scroll_up = false
	--- END OF BLOCK #7 ---




	-- Decompilation error in this vicinity:
	--- BLOCK #8 17-17, warpins: 1 ---
	local wield_scroll_up = true

	--- END OF BLOCK #8 ---




	-- Decompilation error in this vicinity:
	--- BLOCK #9 18-19, warpins: 2 ---
	if wield_input ~= "wield_3_gamepad" then

		-- Decompilation error in this vicinity:
		--- BLOCK #10 20-21, warpins: 1 ---
		local wield_pocketable_gamepad = false
		--- END OF BLOCK #10 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #11 22-22, warpins: 1 ---
		local wield_pocketable_gamepad = true
		--- END OF BLOCK #11 ---



	end

	--- END OF BLOCK #9 ---

	FLOW; TARGET BLOCK #12



	-- Decompilation error in this vicinity:
	--- BLOCK #10 20-21, warpins: 1 ---
	local wield_pocketable_gamepad = false
	--- END OF BLOCK #10 ---




	-- Decompilation error in this vicinity:
	--- BLOCK #11 22-22, warpins: 1 ---
	local wield_pocketable_gamepad = true
	--- END OF BLOCK #11 ---




	-- Decompilation error in this vicinity:
	--- BLOCK #12 23-26, warpins: 2 ---
	local slot_index = scroll_wield_order[wielded_slot]
	--- END OF BLOCK #12 ---

	FLOW; TARGET BLOCK #25



	-- Decompilation error in this vicinity:
	--- BLOCK #13 27-28, warpins: 1 ---
	--- END OF BLOCK #13 ---

	slot10 = if wield_scroll_up then
	JUMP TO BLOCK #14
	else
	JUMP TO BLOCK #29
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #14 29-30, warpins: 2 ---
	--- END OF BLOCK #14 ---

	slot12 = if slot_index then
	JUMP TO BLOCK #15
	else
	JUMP TO BLOCK #29
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #15 31-34, warpins: 1 ---
	local scroll_size = #scroll_wield_order
	--- END OF BLOCK #15 ---

	slot10 = if wield_scroll_up then
	JUMP TO BLOCK #16
	else
	JUMP TO BLOCK #17
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #16 35-36, warpins: 1 ---
	slot14 = 1
	--- END OF BLOCK #16 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #18



	-- Decompilation error in this vicinity:
	--- BLOCK #17 37-37, warpins: 1 ---
	local index_change = -1
	--- END OF BLOCK #17 ---

	FLOW; TARGET BLOCK #18



	-- Decompilation error in this vicinity:
	--- BLOCK #18 38-42, warpins: 2 ---
	local wrap = input_extension:get("weapon_switch_scroll_wrap")
	local next_slot_index = slot_index
	--- END OF BLOCK #18 ---

	FLOW; TARGET BLOCK #19



	-- Decompilation error in this vicinity:
	--- BLOCK #19 43-43, warpins: 2 ---
	--- END OF BLOCK #19 ---

	FLOW; TARGET BLOCK #19



	-- Decompilation error in this vicinity:
	--- BLOCK #20 44-46, warpins: 1 ---
	next_slot_index = next_slot_index + index_change
	--- END OF BLOCK #20 ---

	slot15 = if wrap then
	JUMP TO BLOCK #21
	else
	JUMP TO BLOCK #22
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #21 47-52, warpins: 1 ---
	next_slot_index = math.index_wrapper(next_slot_index, scroll_size)
	--- END OF BLOCK #21 ---

	FLOW; TARGET BLOCK #22



	-- Decompilation error in this vicinity:
	--- BLOCK #22 53-56, warpins: 2 ---
	local scroll_slot_name = scroll_wield_order[next_slot_index]

	--- END OF BLOCK #22 ---

	slot17 = if not scroll_slot_name then
	JUMP TO BLOCK #23
	else
	JUMP TO BLOCK #24
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #23 57-57, warpins: 1 ---
	break

	--- END OF BLOCK #23 ---

	FLOW; TARGET BLOCK #24



	-- Decompilation error in this vicinity:
	--- BLOCK #24 58-65, warpins: 1 ---
	local can_wield = _can_wield_from_scroll_input(scroll_slot_name, visual_loadout_extension, weapon_extension, ability_extension)
	--- END OF BLOCK #24 ---

	slot18 = if can_wield then
	JUMP TO BLOCK #25
	else
	JUMP TO BLOCK #26
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #25 66-67, warpins: 1 ---
	next_slot_name = scroll_slot_name

	break

	--- END OF BLOCK #25 ---




	-- Decompilation error in this vicinity:
	--- BLOCK #26 68-69, warpins: 1 ---
	--- END OF BLOCK #26 ---

	if next_slot_index == slot_index then
	JUMP TO BLOCK #27
	else
	JUMP TO BLOCK #19
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #27 70-71, warpins: 3 ---
	--- END OF BLOCK #27 ---

	slot7 = if not next_slot_name then
	JUMP TO BLOCK #28
	else
	JUMP TO BLOCK #29
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #28 72-72, warpins: 1 ---
	next_slot_name = wielded_slot

	--- END OF BLOCK #28 ---

	FLOW; TARGET BLOCK #29



	-- Decompilation error in this vicinity:
	--- BLOCK #29 73-74, warpins: 4 ---
	--- END OF BLOCK #29 ---

	slot7 = if next_slot_name then
	JUMP TO BLOCK #30
	else
	JUMP TO BLOCK #31
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #30 75-76, warpins: 1 ---
	return next_slot_name

	--- END OF BLOCK #30 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #54



	-- Decompilation error in this vicinity:
	--- BLOCK #31 77-78, warpins: 1 ---
	--- END OF BLOCK #31 ---

	slot11 = if wield_pocketable_gamepad then
	JUMP TO BLOCK #32
	else
	JUMP TO BLOCK #45
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #32 79-81, warpins: 1 ---
	--- END OF BLOCK #32 ---

	if inventory_component.slot_pocketable == "not_equipped" then
	JUMP TO BLOCK #33
	else
	JUMP TO BLOCK #34
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #33 82-83, warpins: 1 ---
	slot13 = false
	--- END OF BLOCK #33 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #35



	-- Decompilation error in this vicinity:
	--- BLOCK #34 84-84, warpins: 1 ---
	local pocketable_equipped = true
	--- END OF BLOCK #34 ---

	FLOW; TARGET BLOCK #35



	-- Decompilation error in this vicinity:
	--- BLOCK #35 85-87, warpins: 2 ---
	--- END OF BLOCK #35 ---

	if inventory_component.slot_pocketable_small == "not_equipped" then
	JUMP TO BLOCK #36
	else
	JUMP TO BLOCK #37
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #36 88-89, warpins: 1 ---
	slot14 = false
	--- END OF BLOCK #36 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #38



	-- Decompilation error in this vicinity:
	--- BLOCK #37 90-90, warpins: 1 ---
	local pocketable_small_equipped = true
	--- END OF BLOCK #37 ---

	FLOW; TARGET BLOCK #38



	-- Decompilation error in this vicinity:
	--- BLOCK #38 91-94, warpins: 2 ---
	next_slot_name = gamepad_pocketable_wield_configuration[wielded_slot]
	--- END OF BLOCK #38 ---

	slot7 = if not next_slot_name then
	JUMP TO BLOCK #39
	else
	JUMP TO BLOCK #44
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #39 95-96, warpins: 1 ---
	--- END OF BLOCK #39 ---

	slot13 = if not pocketable_equipped then
	JUMP TO BLOCK #40
	else
	JUMP TO BLOCK #42
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #40 97-98, warpins: 1 ---
	--- END OF BLOCK #40 ---

	slot14 = if pocketable_small_equipped then
	JUMP TO BLOCK #41
	else
	JUMP TO BLOCK #42
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #41 99-100, warpins: 1 ---
	next_slot_name = "slot_pocketable_small"
	--- END OF BLOCK #41 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #44



	-- Decompilation error in this vicinity:
	--- BLOCK #42 101-102, warpins: 2 ---
	--- END OF BLOCK #42 ---

	slot13 = if pocketable_equipped then
	JUMP TO BLOCK #43
	else
	JUMP TO BLOCK #44
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #43 103-103, warpins: 1 ---
	next_slot_name = "slot_pocketable"

	--- END OF BLOCK #43 ---

	FLOW; TARGET BLOCK #44



	-- Decompilation error in this vicinity:
	--- BLOCK #44 104-105, warpins: 4 ---
	return next_slot_name

	--- END OF BLOCK #44 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #54



	-- Decompilation error in this vicinity:
	--- BLOCK #45 106-107, warpins: 1 ---
	--- END OF BLOCK #45 ---

	slot8 = if not quick_wield then
	JUMP TO BLOCK #46
	else
	JUMP TO BLOCK #49
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #46 108-109, warpins: 1 ---
	--- END OF BLOCK #46 ---

	slot9 = if not wield_scroll_down then
	JUMP TO BLOCK #47
	else
	JUMP TO BLOCK #48
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #47 110-111, warpins: 1 ---
	--- END OF BLOCK #47 ---

	slot10 = if wield_scroll_up then
	JUMP TO BLOCK #48
	else
	JUMP TO BLOCK #52
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #48 112-113, warpins: 2 ---
	--- END OF BLOCK #48 ---

	slot7 = if not next_slot_name then
	JUMP TO BLOCK #49
	else
	JUMP TO BLOCK #52
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #49 114-117, warpins: 2 ---
	next_slot_name = quick_wield_configuration[wielded_slot]
	--- END OF BLOCK #49 ---

	slot7 = if not next_slot_name then
	JUMP TO BLOCK #50
	else
	JUMP TO BLOCK #51
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #50 118-119, warpins: 1 ---
	next_slot_name = quick_wield_configuration.default

	--- END OF BLOCK #50 ---

	FLOW; TARGET BLOCK #51



	-- Decompilation error in this vicinity:
	--- BLOCK #51 120-121, warpins: 2 ---
	return next_slot_name

	--- END OF BLOCK #51 ---

	UNCONDITIONAL JUMP; TARGET BLOCK #54



	-- Decompilation error in this vicinity:
	--- BLOCK #52 122-125, warpins: 2 ---
	--- END OF BLOCK #52 ---

	FLOW; TARGET BLOCK #53



	-- Decompilation error in this vicinity:
	--- BLOCK #53 126-142, warpins: 0 ---
	for slot_name, config in pairs(slot_configuration) do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 126-129, warpins: 1 ---
		local wield_inputs = config.wield_inputs

		--- END OF BLOCK #0 ---

		slot19 = if config.wieldable then
		JUMP TO BLOCK #1
		else
		JUMP TO BLOCK #4
		end



		-- Decompilation error in this vicinity:
		--- BLOCK #1 130-131, warpins: 1 ---
		--- END OF BLOCK #1 ---

		slot18 = if wield_inputs then
		JUMP TO BLOCK #2
		else
		JUMP TO BLOCK #4
		end



		-- Decompilation error in this vicinity:
		--- BLOCK #2 132-135, warpins: 1 ---
		--- END OF BLOCK #2 ---

		FLOW; TARGET BLOCK #3



		-- Decompilation error in this vicinity:
		--- BLOCK #3 136-140, warpins: 0 ---
		for ii = 1, #wield_inputs do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 136-138, warpins: 2 ---
			--- END OF BLOCK #0 ---

			if wield_inputs[ii] == wield_input then
			JUMP TO BLOCK #1
			else
			JUMP TO BLOCK #2
			end



			-- Decompilation error in this vicinity:
			--- BLOCK #1 139-139, warpins: 1 ---
			return slot_name
			--- END OF BLOCK #1 ---

			FLOW; TARGET BLOCK #2



			-- Decompilation error in this vicinity:
			--- BLOCK #2 140-140, warpins: 2 ---
			--- END OF BLOCK #2 ---



		end
		--- END OF BLOCK #3 ---

		FLOW; TARGET BLOCK #4



		-- Decompilation error in this vicinity:
		--- BLOCK #4 141-142, warpins: 4 ---
		--- END OF BLOCK #4 ---



	end

	--- END OF BLOCK #53 ---

	FLOW; TARGET BLOCK #54



	-- Decompilation error in this vicinity:
	--- BLOCK #54 143-143, warpins: 4 ---
	return
	--- END OF BLOCK #54 ---



end

PlayerUnitVisualLoadout.wield_input_from_slot_name = function (slot_name)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	local slot_config = slot_configuration[slot_name]

	return slot_config.wield_inputs[1]
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

function _can_wield_from_scroll_input(slot_name, visual_loadout_extension, weapon_extension, ability_extension)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	--- END OF BLOCK #0 ---

	slot4 = if not visual_loadout_extension:can_wield(slot_name)

	 then
	JUMP TO BLOCK #1
	else
	JUMP TO BLOCK #2
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #1 7-8, warpins: 1 ---
	return false

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 9-14, warpins: 2 ---
	--- END OF BLOCK #2 ---

	slot4 = if not weapon_extension:can_wield(slot_name)

	 then
	JUMP TO BLOCK #3
	else
	JUMP TO BLOCK #4
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #3 15-16, warpins: 1 ---
	return false

	--- END OF BLOCK #3 ---

	FLOW; TARGET BLOCK #4



	-- Decompilation error in this vicinity:
	--- BLOCK #4 17-22, warpins: 2 ---
	--- END OF BLOCK #4 ---

	slot4 = if not ability_extension:can_wield(slot_name)

	 then
	JUMP TO BLOCK #5
	else
	JUMP TO BLOCK #6
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #5 23-24, warpins: 1 ---
	return false

	--- END OF BLOCK #5 ---

	FLOW; TARGET BLOCK #6



	-- Decompilation error in this vicinity:
	--- BLOCK #6 25-30, warpins: 2 ---
	--- END OF BLOCK #6 ---

	slot4 = if not ability_extension:can_be_scroll_wielded(slot_name)

	 then
	JUMP TO BLOCK #7
	else
	JUMP TO BLOCK #8
	end



	-- Decompilation error in this vicinity:
	--- BLOCK #7 31-32, warpins: 1 ---
	return false
	--- END OF BLOCK #7 ---

	FLOW; TARGET BLOCK #8



	-- Decompilation error in this vicinity:
	--- BLOCK #8 33-34, warpins: 2 ---
	return true
	--- END OF BLOCK #8 ---



end

function _unwield_slot(slot_to_unwield, visual_loadout_extension, weapon_extension, t)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-10, warpins: 1 ---
	weapon_extension:on_slot_unwielded(slot_to_unwield, t)
	visual_loadout_extension:unwield_slot(slot_to_unwield)

	return
	--- END OF BLOCK #0 ---



end

return PlayerUnitVisualLoadout
