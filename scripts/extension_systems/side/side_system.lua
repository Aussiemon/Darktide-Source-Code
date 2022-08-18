local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Side = require("scripts/extension_systems/side/side")
local keywords = BuffSettings.keywords
local SideSystem = class("SideSystem", "ExtensionSystemBase")

SideSystem.init = function (self, extension_system_creation_context, system_init_data, ...)
	SideSystem.super.init(self, extension_system_creation_context, system_init_data, ...)

	self._default_player_side_name = system_init_data.default_player_side_name
	local side_compositions = system_init_data.side_compositions
	self._sides, self._side_lookup, self._side_names = self:_create_sides(side_compositions)

	self:_setup_relations(side_compositions, self._sides, self._side_lookup)

	self.side_by_unit = {}
	self._unit_extension_data = {}
end

SideSystem._create_sides = function (self, side_compositions)
	local num_sides = #side_compositions
	local sides = Script.new_array(num_sides)
	local side_lookup = Script.new_map(num_sides)
	local side_names = Script.new_array(num_sides)

	for i = 1, num_sides, 1 do
		local definition = side_compositions[i]
		local side_name = definition.name

		fassert(side_lookup[side_name] == nil, "[SideSystem] Duplicate side %q exists in side_composition.", side_name)
		fassert(definition.color_name ~= nil, "[SideSystem] Missing color_name for side %q in side_composition.", side_name)

		local side = Side:new(definition, i)
		sides[i] = side
		side_lookup[side_name] = side
		side_names[i] = side_name
	end

	fassert(table.is_empty(sides) == false, "[SideSystem] No sides specified in side_composition.")

	return sides, side_lookup, side_names
end

SideSystem._setup_relations = function (self, side_compositions, sides, side_lookup)
	local num_sides = #sides

	for i = 1, num_sides, 1 do
		local definition = side_compositions[i]
		local side = sides[i]
		local relations = definition.relations

		for relation, side_list in pairs(relations) do
			local num_relation_sides = #side_list
			local temp_sides = Script.new_array(num_relation_sides)

			for j = 1, #side_list, 1 do
				local relation_side_name = side_list[j]

				fassert(side_lookup[relation_side_name], "[SideSystem] Side %q does not exist.", relation_side_name)

				temp_sides[#temp_sides + 1] = side_lookup[relation_side_name]
			end

			side:set_relation(relation, temp_sides)
		end
	end

	local relation_types = Side.SIDE_RELATION_TYPES
	local num_relation_types = #relation_types

	for i = 1, num_sides, 1 do
		local side = sides[i]

		for j = 1, num_relation_types, 1 do
			local relation = relation_types[j]
			local current_sides = side:relation_sides(relation)

			for k = 1, #current_sides, 1 do
				local relation_side = current_sides[k]
				local relation_sides = relation_side:relation_sides(relation)

				fassert(table.find(relation_sides, side), "[SideSystem] Asymmetrical %q relation between side %d and %d.", relation, i, relation_side.side_id)
			end
		end
	end
end

local EMPTY_TABLE = {}

SideSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, game_object_data)
	local extension = {}

	ScriptUnit.set_extension(unit, self._name, extension)

	extension.is_player_unit = extension_init_data.is_player_unit
	extension.is_human_unit = extension_init_data.is_human_unit
	extension.breed_tags = (extension_init_data.breed and extension_init_data.breed.tags) or EMPTY_TABLE
	self._unit_extension_data[unit] = extension
	local side_id = extension_init_data.side_id

	self:_add_unit_to_side(unit, side_id)

	return extension
end

SideSystem.register_extension_update = function (self, unit, extension_name, extension)
	extension.update_registered = true
end

SideSystem.on_remove_extension = function (self, unit, extension_name)
	self:remove_unit_from_tag_units(unit)
	self:_remove_unit_from_side(unit)

	self._unit_extension_data[unit] = nil

	ScriptUnit.remove_extension(unit, self._name)
end

SideSystem.sides = function (self)
	return self._sides
end

SideSystem.side_names = function (self)
	return self._side_names
end

SideSystem.get_side = function (self, side_id)
	return self._sides[side_id]
end

SideSystem.get_side_from_name = function (self, name)
	return self._side_lookup[name]
end

SideSystem.get_default_player_side_name = function (self)
	return self._default_player_side_name
end

SideSystem._add_unit_to_side = function (self, unit, side_id)
	local side = self._sides[side_id]
	local side_extension = self._unit_extension_data[unit]

	side:add_unit(unit, side_extension)

	side_extension.side_id = side_id
	side_extension.side = side
	self.side_by_unit[unit] = side
	local relation_types = Side.SIDE_RELATION_TYPES
	local num_relation_types = #relation_types

	for i = 1, num_relation_types, 1 do
		local relation = relation_types[i]
		local relation_sides = side:relation_sides(relation)

		for j = 1, #relation_sides, 1 do
			local relation_side = relation_sides[j]

			relation_side:add_relation_unit(unit, side_extension, relation)
			relation_side:add_tag_unit(unit, side_extension, relation)
		end
	end

	return side
end

SideSystem._remove_unit_from_side = function (self, unit)
	local side = self.side_by_unit[unit]
	local side_extension = self._unit_extension_data[unit]

	side:remove_unit(unit, side_extension)

	local relation_types = Side.SIDE_RELATION_TYPES
	local num_relation_types = #relation_types

	for i = 1, num_relation_types, 1 do
		local relation = relation_types[i]
		local relation_sides = side:relation_sides(relation)

		for j = 1, #relation_sides, 1 do
			local relation_side = relation_sides[j]

			relation_side:remove_relation_unit(unit, side_extension, relation)
		end
	end

	self.side_by_unit[unit] = nil
end

SideSystem.remove_unit_from_tag_units = function (self, unit)
	local side_extension = self._unit_extension_data[unit]

	if side_extension.is_removed_from_tag_units then
		return
	end

	local side = self.side_by_unit[unit]
	local relation_types = Side.SIDE_RELATION_TYPES
	local num_relation_types = #relation_types

	for i = 1, num_relation_types, 1 do
		local relation = relation_types[i]
		local relation_sides = side:relation_sides(relation)

		for j = 1, #relation_sides, 1 do
			local relation_side = relation_sides[j]

			relation_side:remove_tag_unit(unit, side_extension, relation)
		end
	end

	side_extension.is_removed_from_tag_units = true
end

SideSystem.is_ally = function (self, unit1, unit2)
	local side = self.side_by_unit[unit1]

	if side == nil then
		return false
	end

	return side.units_lookup[unit2] ~= nil or side.allied_units_lookup[unit2] ~= nil
end

SideSystem.is_enemy = function (self, unit1, unit2)
	local side = self.side_by_unit[unit1]

	if side == nil then
		return false
	end

	return side.enemy_units_lookup[unit2] ~= nil
end

SideSystem.is_same_side = function (self, unit1, unit2)
	local side1 = self.side_by_unit[unit1]
	local side2 = self.side_by_unit[unit2]

	return side1 == side2
end

SideSystem.is_enemy_by_side = function (self, side1, side2)
	return side1.enemy_sides_lookup[side2] ~= nil
end

SideSystem.pre_update = function (self, context, dt, t)
	local sides = self._sides
	local num_sides = #sides

	for i = 1, num_sides, 1 do
		local side = sides[i]

		self:_update_frame_tables(side)
		self:_update_enemy_frame_tables(side)
	end
end

SideSystem.add_aggroed_minion = function (self, unit)
	local side = self.side_by_unit[unit]
	local enemy_sides = side:relation_sides("enemy")
	local num_enemy_sides = #enemy_sides

	for i = 1, num_enemy_sides, 1 do
		local enemy_side = enemy_sides[i]
		local num_aggroed_minion_target_units = enemy_side.num_aggroed_minion_target_units + 1
		enemy_side.num_aggroed_minion_target_units = num_aggroed_minion_target_units
		local aggroed_minion_target_units = enemy_side.aggroed_minion_target_units
		aggroed_minion_target_units[num_aggroed_minion_target_units] = unit
		aggroed_minion_target_units[unit] = num_aggroed_minion_target_units
	end
end

SideSystem.remove_aggroed_minion = function (self, unit)
	local side = self.side_by_unit[unit]
	local enemy_sides = side:relation_sides("enemy")
	local num_enemy_sides = #enemy_sides

	for i = 1, num_enemy_sides, 1 do
		local enemy_side = enemy_sides[i]
		local aggroed_minion_target_units = enemy_side.aggroed_minion_target_units
		local index = aggroed_minion_target_units[unit]
		local last_index = enemy_side.num_aggroed_minion_target_units
		local last_unit = aggroed_minion_target_units[last_index]
		aggroed_minion_target_units[index] = last_unit
		aggroed_minion_target_units[last_unit] = index
		aggroed_minion_target_units[last_index] = nil
		aggroed_minion_target_units[unit] = nil
		enemy_side.num_aggroed_minion_target_units = last_index - 1
	end
end

local function _is_valid_target(unit, side_extension)
	if not HEALTH_ALIVE[unit] then
		return false
	end

	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if buff_extension and buff_extension:has_keyword(keywords.invisible) then
		return false
	end

	local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

	if unit_data_extension then
		local breed_or_nil = unit_data_extension:breed()
		local is_player = Breed.is_player(breed_or_nil)

		if is_player then
			local character_state_component = unit_data_extension:read_component("character_state")

			if PlayerUnitStatus.is_hogtied(character_state_component) then
				return false
			end
		end
	end

	return true
end

SideSystem._update_frame_tables = function (self, side)
	Profiler.start("SideSystem:_update_frame_tables()")

	local unit_extension_data = self._unit_extension_data
	local player_units = side.player_units
	local player_unit_positions = side.player_unit_positions
	local num_player_units = 0

	table.clear(player_units)
	table.clear(player_unit_positions)

	local valid_human_units = side.valid_human_units
	local valid_human_unit_positions = side.valid_human_units_positions
	local num_valid_human_units = 0

	table.clear(valid_human_units)
	table.clear(valid_human_unit_positions)

	local valid_human_and_bot_units = side.valid_player_units
	local valid_human_and_bot_unit_positions = side.valid_player_units_positions
	local num_valid_human_and_bot_units = 0

	table.clear(valid_human_and_bot_units)
	table.clear(valid_human_and_bot_unit_positions)

	local added_player_units = side:added_player_units()
	local num_added_player_units = #added_player_units

	for i = 1, num_added_player_units, 1 do
		local unit = added_player_units[i]
		local side_extension = unit_extension_data[unit]

		if side_extension.update_registered then
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local character_state_component = unit_data_extension:read_component("character_state")
			local valid = not PlayerUnitStatus.is_hogtied(character_state_component)
			local position = POSITION_LOOKUP[unit]
			num_player_units = num_player_units + 1
			player_units[num_player_units] = unit
			player_unit_positions[num_player_units] = position
			player_units[unit] = num_player_units

			if valid then
				num_valid_human_and_bot_units = num_valid_human_and_bot_units + 1
				valid_human_and_bot_units[num_valid_human_and_bot_units] = unit
				valid_human_and_bot_unit_positions[num_valid_human_and_bot_units] = position
				valid_human_and_bot_units[unit] = num_valid_human_and_bot_units

				if side_extension.is_human_unit then
					num_valid_human_units = num_valid_human_units + 1
					valid_human_units[num_valid_human_units] = unit
					valid_human_unit_positions[num_valid_human_units] = position
					valid_human_units[unit] = num_valid_human_units
				end
			end
		end
	end

	Profiler.stop("SideSystem:_update_frame_tables()")
end

SideSystem._update_enemy_frame_tables = function (self, side)
	Profiler.start("SideSystem:_update_enemy_frame_tables()")

	local unit_extension_data = self._unit_extension_data
	local enemy_player_units = side.enemy_player_units
	local enemy_player_unit_positions = side.enemy_player_unit_positions
	local num_enemy_player_units = 0

	table.clear(enemy_player_units)
	table.clear(enemy_player_unit_positions)

	local valid_enemy_human_units = side.valid_enemy_human_units
	local valid_enemy_human_unit_positions = side.valid_enemy_human_units_positions
	local num_valid_enemy_human_units = 0

	table.clear(valid_enemy_human_units)
	table.clear(valid_enemy_human_unit_positions)

	local valid_human_and_bot_units = side.valid_enemy_player_units
	local valid_human_and_bot_unit_positions = side.valid_enemy_player_units_positions
	local num_valid_enemy_human_and_bot_units = 0

	table.clear(valid_human_and_bot_units)
	table.clear(valid_human_and_bot_unit_positions)

	local added_enemy_player_units = side:relation_player_units("enemy")
	local num_added_enemy_player_units = #added_enemy_player_units

	for i = 1, num_added_enemy_player_units, 1 do
		local unit = added_enemy_player_units[i]
		local side_extension = unit_extension_data[unit]

		if side_extension.update_registered then
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local character_state_component = unit_data_extension:read_component("character_state")
			local valid = not PlayerUnitStatus.is_hogtied(character_state_component)
			local position = POSITION_LOOKUP[unit]
			num_enemy_player_units = num_enemy_player_units + 1
			enemy_player_units[num_enemy_player_units] = unit
			enemy_player_unit_positions[num_enemy_player_units] = position
			enemy_player_units[unit] = num_enemy_player_units

			if valid then
				num_valid_enemy_human_and_bot_units = num_valid_enemy_human_and_bot_units + 1
				valid_human_and_bot_units[num_valid_enemy_human_and_bot_units] = unit
				valid_human_and_bot_unit_positions[num_valid_enemy_human_and_bot_units] = position
				valid_human_and_bot_units[unit] = num_valid_enemy_human_and_bot_units

				if side_extension.is_human_unit then
					num_valid_enemy_human_units = num_valid_enemy_human_units + 1
					valid_enemy_human_units[num_valid_enemy_human_units] = unit
					valid_enemy_human_unit_positions[num_valid_enemy_human_units] = position
					valid_enemy_human_units[unit] = num_valid_enemy_human_units
				end
			end
		end
	end

	local ai_target_units = side.ai_target_units
	local num_ai_target_units = 0

	table.clear(ai_target_units)

	local enemy_units = side:relation_units("enemy")
	local num_enemy_units = #enemy_units

	for i = 1, num_enemy_units, 1 do
		local unit = enemy_units[i]
		local side_extension = unit_extension_data[unit]

		if side_extension.update_registered and _is_valid_target(unit, side_extension) then
			num_ai_target_units = num_ai_target_units + 1
			ai_target_units[num_ai_target_units] = unit
			ai_target_units[unit] = num_ai_target_units
		end
	end

	Profiler.stop("SideSystem:_update_enemy_frame_tables()")
end

return SideSystem
