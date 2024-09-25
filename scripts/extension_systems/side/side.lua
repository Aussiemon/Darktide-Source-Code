-- chunkname: @scripts/extension_systems/side/side.lua

local Breeds = require("scripts/settings/breed/breeds")
local Side = class("Side")

Side.SIDE_RELATION_TYPES = table.mirror_array_inplace({
	"enemy",
	"allied",
	"neutral",
})

Side.init = function (self, definition, side_id)
	self._name = definition.name
	self._color_name = definition.color_name
	self._units = {}
	self.units_lookup = {}
	self._added_player_units = {}
	self.units_by_relation_tag = {
		enemy = {},
		allied = {},
		neutral = {},
	}
	self.units_by_relation_tag_lookup = {
		enemy = {},
		allied = {},
		neutral = {},
	}
	self.aggroed_minion_units = {}
	self.num_aggroed_minion_units = 0

	self:_create_relation_tables()

	self.side_id = side_id
	self.player_units = {}
	self.player_unit_positions = {}
	self.valid_human_units = {}
	self.valid_human_units_positions = {}
	self.valid_player_units = {}
	self.valid_player_units_positions = {}
	self.enemy_player_units = {}
	self.enemy_player_unit_positions = {}
	self.valid_enemy_human_units = {}
	self.valid_enemy_human_units_positions = {}
	self.valid_enemy_player_units = {}
	self.valid_enemy_player_units_positions = {}
	self.ai_target_units = {}
	self.aggroed_minion_target_units = {}
	self.num_aggroed_minion_target_units = 0
end

Side._create_tag_tables = function (self)
	local list, list_lookup = {}, {}

	for _, breed in pairs(Breeds) do
		if breed.tags then
			for tag_name, _ in pairs(breed.tags) do
				list[tag_name] = {
					size = 0,
				}
				list_lookup[tag_name] = {}
			end
		end
	end

	return list, list_lookup
end

Side._create_relation_tables = function (self)
	local relations = Side.SIDE_RELATION_TYPES
	local num_relations = #relations
	local relation_sides = Script.new_map(num_relations)
	local relation_sides_lookup = Script.new_map(num_relations)
	local relation_side_names = Script.new_map(num_relations)
	local relation_units = Script.new_map(num_relations)
	local relation_units_lookup = Script.new_map(num_relations)
	local relation_player_units = Script.new_map(num_relations)

	for i = 1, num_relations do
		local relation = relations[i]

		relation_sides[relation] = {}
		relation_sides_lookup[relation] = {}
		relation_side_names[relation] = {}
		relation_units[relation] = {}
		relation_units_lookup[relation] = {}
		relation_player_units[relation] = {}

		local sides_lookup_name = string.format("%s_sides_lookup", relation)
		local units_lookup_name = string.format("%s_units_lookup", relation)

		self[sides_lookup_name] = relation_sides_lookup[relation]
		self[units_lookup_name] = relation_units_lookup[relation]
		self.units_by_relation_tag[relation], self.units_by_relation_tag_lookup[relation] = self:_create_tag_tables()
	end

	self._relation_sides = relation_sides
	self._relation_sides_lookup = relation_sides_lookup
	self._relation_side_names = relation_side_names
	self._relation_units = relation_units
	self._relation_units_lookup = relation_units_lookup
	self._relation_player_units = relation_player_units
end

Side.set_relation = function (self, relation, sides)
	local relation_sides = self._relation_sides[relation]
	local relation_side_lookup = self._relation_sides_lookup[relation]
	local relation_side_names = self._relation_side_names[relation]

	for i = 1, #sides do
		local side = sides[i]
		local side_name = side:name()

		relation_sides[i] = side
		relation_side_names[i] = side_name
		relation_side_lookup[side] = true
	end
end

Side.add_unit = function (self, unit, side_extension)
	local units_lookup = self.units_lookup

	if side_extension.is_player_unit then
		local player_units = self._added_player_units
		local new_index = #player_units + 1

		player_units[new_index] = unit
	end

	local units = self._units
	local new_index = #units + 1

	units[new_index] = unit
	units_lookup[unit] = new_index
end

local function _swap_delete_lookup(t, index, unit)
	local table_length = #t
	local keep_unit = t[table_length]

	t[index] = keep_unit
	t[keep_unit] = index
	t[table_length] = nil
	t[unit] = nil
end

Side.remove_unit = function (self, unit, side_extension)
	local units_lookup = self.units_lookup

	if side_extension.is_player_unit then
		local added_player_units = self._added_player_units
		local index = table.find(added_player_units, unit)

		table.swap_delete(added_player_units, index)

		local player_units = self.player_units
		local player_units_index = table.find(player_units, unit)

		if player_units_index then
			_swap_delete_lookup(player_units, player_units_index, unit)
			table.swap_delete(self.player_unit_positions, player_units_index)
		end

		local valid_player_units = self.valid_player_units
		local valid_player_units_index = valid_player_units[unit]

		if valid_player_units_index then
			_swap_delete_lookup(valid_player_units, valid_player_units_index, unit)
			table.swap_delete(self.valid_player_units_positions, valid_player_units_index)
		end
	end

	local units = self._units
	local num_units = #units
	local replace_index = units_lookup[unit]
	local last_unit = units[num_units]

	table.swap_delete(units, replace_index)

	units_lookup[last_unit] = replace_index
	units_lookup[unit] = nil
end

Side.add_relation_unit = function (self, unit, side_extension, relation)
	local units_lookup = self._relation_units_lookup[relation]

	if side_extension.is_player_unit then
		local player_units = self._relation_player_units[relation]
		local index = #player_units + 1

		player_units[index] = unit
	end

	local units = self._relation_units[relation]
	local index = #units + 1

	units[index] = unit
	units_lookup[unit] = index
end

Side.remove_relation_unit = function (self, unit, side_extension, relation)
	local units_lookup = self._relation_units_lookup[relation]

	if side_extension.is_player_unit then
		local player_units = self._relation_player_units[relation]
		local index = table.find(player_units, unit)

		table.swap_delete(player_units, index)
	end

	local units = self._relation_units[relation]
	local num_units = #units
	local replace_index = units_lookup[unit]
	local last_unit = units[num_units]

	table.swap_delete(units, replace_index)

	units_lookup[last_unit] = replace_index
	units_lookup[unit] = nil
end

Side.add_tag_unit = function (self, unit, side_extension, relation)
	local units_by_tag = self.units_by_relation_tag[relation]
	local units_by_tag_lookup = self.units_by_relation_tag_lookup[relation]

	for tag_name, _ in pairs(side_extension.breed_tags) do
		local unit_list = units_by_tag[tag_name]
		local new_index = unit_list.size + 1

		unit_list[new_index] = unit

		local units_lookup = units_by_tag_lookup[tag_name]

		units_lookup[unit] = new_index
		unit_list.size = new_index
	end
end

Side.remove_tag_unit = function (self, unit, side_extension, relation)
	local units_by_tag = self.units_by_relation_tag[relation]
	local units_by_tag_lookup = self.units_by_relation_tag_lookup[relation]

	for tag_name, _ in pairs(side_extension.breed_tags) do
		local unit_list = units_by_tag[tag_name]
		local units_lookup = units_by_tag_lookup[tag_name]
		local replace_index = units_lookup[unit]
		local size = unit_list.size
		local last_unit = unit_list[size]

		table.swap_delete(unit_list, replace_index)

		units_lookup[last_unit] = replace_index
		units_lookup[unit] = nil
		unit_list.size = size - 1
	end
end

Side.name = function (self)
	return self._name
end

Side.color = function (self)
	local color_name = self._color_name
	local color = Color[color_name]()

	return color
end

Side.added_player_units = function (self)
	return self._added_player_units
end

Side.relation_side_names = function (self, relation)
	return self._relation_side_names[relation]
end

Side.relation_sides = function (self, relation)
	return self._relation_sides[relation]
end

Side.relation_units = function (self, relation)
	return self._relation_units[relation]
end

Side.relation_player_units = function (self, relation)
	return self._relation_player_units[relation]
end

Side.alive_units_by_tag = function (self, relation, tag)
	return self.units_by_relation_tag[relation][tag]
end

return Side
