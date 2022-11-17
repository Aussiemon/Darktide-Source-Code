local FixedFrame = require("scripts/utilities/fixed_frame")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local MasterItems = require("scripts/backend/master_items")
local PlayerUnitGadgetExtension = class("PlayerUnitGadgetExtension")

PlayerUnitGadgetExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	local is_server = extension_init_data.is_server
	self._is_server = is_server
	self._is_client = not DEDICATED_SERVER
	local is_local_unit = extension_init_data.is_local_unit
	self._is_local_unit = is_local_unit
	self._gadget_buff_indexes = {}
end

PlayerUnitGadgetExtension.extensions_ready = function (self, world, unit)
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	self._buff_extension = buff_extension
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._unit_data_extension = unit_data_extension
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	self._visual_loadout_extension = visual_loadout_extension
end

PlayerUnitGadgetExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id
	self._game_object_created = true
	local visual_loadout_extension = self._visual_loadout_extension
	local num_slots = 3

	for i = 1, num_slots do
		repeat
			local slot_name = "slot_attachment_" .. i
			local item = visual_loadout_extension:item_in_slot(slot_name)

			if not item then
				break
			end

			local item_type = item.item_type

			if item_type == "GADGET" then
				self:_add_gadget_buffs(item, slot_name)
			end
		until true
	end
end

PlayerUnitGadgetExtension.update = function (self, unit, dt, t)
	return
end

PlayerUnitGadgetExtension.on_slot_equipped = function (self, item, slot_name)
	self:_add_gadget_buffs(item, slot_name)
end

PlayerUnitGadgetExtension.on_slot_unequipped = function (self, item, slot_name)
	self:_remove_gadget_buffs(item, slot_name)
end

PlayerUnitGadgetExtension._add_gadget_buffs = function (self, item, slot_name)
	local gadget_buffs = {}
	local perks = item.perks

	if perks then
		for i = 1, #perks do
			local data = perks[i]
			local master_item_id = data.id
			local lerp_value = data.value
			local buff_data = self:_add_gadget_buff(master_item_id, lerp_value, slot_name)

			if buff_data then
				gadget_buffs[#gadget_buffs + 1] = buff_data
			end
		end
	end

	local traits = item.traits

	if traits then
		for i = 1, #traits do
			local data = traits[i]
			local master_item_id = data.id
			local lerp_value = data.value
			local buff_data = self:_add_gadget_buff(master_item_id, lerp_value, slot_name)

			if buff_data then
				gadget_buffs[#gadget_buffs + 1] = buff_data
			end
		end
	end

	local gear_id = item.gear_id
	local id = slot_name .. ":" .. gear_id
	self._gadget_buff_indexes[id] = gadget_buffs

	table.dump(self._gadget_buff_indexes, "_gadget_buff_indexes", 3)
end

PlayerUnitGadgetExtension._add_gadget_buff = function (self, master_item_id, lerp_value, slot_name)
	local t = FixedFrame.get_latest_fixed_time()
	local item_exists = MasterItems.item_exists(master_item_id)

	if not item_exists then
		Log.error("PlayerUnitGadgetExtension", "Trying to equip a Gadget Item with a non-existing Trait Item attached: %s", master_item_id)

		return
	end

	local item = MasterItems.get_item(master_item_id)
	local trait_name = item.trait
	local buff_template = BuffTemplates[trait_name]

	if not buff_template then
		Log.error("PlayerUnitGadgetExtension", "Trying to Equip a Gadget Item Trait with a non-existing buff template: %s", trait_name)

		return
	end

	local is_meta_buff = buff_template.meta_buff
	local buff_data = nil

	if is_meta_buff then
		local gadget_system = Managers.state.extension:system("gadget_system")
		local player = Managers.state.player_unit_spawn:owner(self._unit)
		local index = gadget_system:add_meta_buff(player, trait_name, t, lerp_value)
		buff_data = {
			meta_buff_index = index
		}

		Log.info("PlayerUnitGadgetExtension", "Added gadget meta trait name:%s lerp_value:%s", trait_name, lerp_value)
	else
		local buff_extension = self._buff_extension
		local client_tried_adding_rpc_buff, local_index, component_index = buff_extension:add_externally_controlled_buff(trait_name, t, "buff_lerp_value", lerp_value, "item_slot_name", slot_name)

		if not client_tried_adding_rpc_buff then
			buff_data = {
				local_index = local_index,
				component_index = component_index
			}
		end

		Log.info("PlayerUnitGadgetExtension", "Added gadget trait name:%s lerp_value:%s", trait_name, lerp_value)
	end

	return buff_data
end

PlayerUnitGadgetExtension._remove_gadget_buffs = function (self, item, slot_name)
	local gear_id = item.gear_id
	local id = slot_name .. ":" .. gear_id
	local buff_extension = self._buff_extension
	local gadget_buffs = self._gadget_buff_indexes[id]
	local gadget_system = Managers.state.extension:system("gadget_system")
	local player = Managers.state.player_unit_spawn:owner(self._unit)

	for _, buff in pairs(gadget_buffs) do
		local meta_buff_index = buff.meta_buff_index

		if meta_buff_index then
			gadget_system:remove_meta_buff(player, meta_buff_index)
		else
			local local_index = buff.local_index
			local component_index = buff.component_index

			buff_extension:remove_externally_controlled_buff(local_index, component_index)
		end
	end
end

return PlayerUnitGadgetExtension
