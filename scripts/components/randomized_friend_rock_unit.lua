local RandomizedFriendRockUnit = component("RandomizedFriendRockUnit")

RandomizedFriendRockUnit.init = function (self, unit)
	self._unit = unit
	local visiblity_group_names = {}
	self._visiblity_group_names = visiblity_group_names
	local visiblity_groups = self:get_data(unit, "visiblity_groups")
	local num_visiblity_groups = #visiblity_groups

	for ii = 1, num_visiblity_groups do
		local entry = visiblity_groups[ii]
		local visiblity_group_name = entry.visiblity_group_name
		visiblity_group_names[#visiblity_group_names + 1] = visiblity_group_name
	end

	self._num_visibility_groups = #visiblity_group_names
	self._current_visibility_group_index = 1

	self:_setup()
end

RandomizedFriendRockUnit.enable = function (self, unit)
	return
end

RandomizedFriendRockUnit.disable = function (self, unit)
	return
end

RandomizedFriendRockUnit.destroy = function (self, unit)
	return
end

RandomizedFriendRockUnit._setup = function (self)
	local unit = self._unit
	local visiblity_group_names = self._visiblity_group_names
	local num_visibility_groups = self._num_visibility_groups

	for ii = 1, num_visibility_groups do
		local group_name = visiblity_group_names[ii]

		Unit.set_visibility(unit, group_name, false, true)
	end

	local visibility_group_index = math.random(1, num_visibility_groups)

	Unit.set_visibility(unit, visiblity_group_names[visibility_group_index], true, true)

	self._current_visibility_group_index = visibility_group_index
end

RandomizedFriendRockUnit.random_visibility_group_index = function (self)
	local num_visibility_groups = self._num_visibility_groups
	local current_visibility_group_index = self._current_visibility_group_index
	local min = 1
	local max = num_visibility_groups
	local new_index = math.floor(math.random() * (max - min)) + min

	if current_visibility_group_index <= new_index then
		new_index = new_index + 1
	end

	return new_index
end

RandomizedFriendRockUnit.show_visibility_group = function (self, visibility_group_index)
	local current_visibility_group_index = self._current_visibility_group_index

	if visibility_group_index ~= current_visibility_group_index then
		local unit = self._unit
		local visiblity_group_names = self._visiblity_group_names

		Unit.set_visibility(unit, visiblity_group_names[current_visibility_group_index], false, true)
		Unit.set_visibility(unit, visiblity_group_names[visibility_group_index], true, true)

		self._current_visibility_group_index = visibility_group_index
	end
end

RandomizedFriendRockUnit.component_data = {
	visiblity_groups = {
		ui_type = "struct_array",
		ui_name = "Visiblity Groups",
		definition = {
			visiblity_group_name = {
				ui_type = "text_box",
				value = "",
				ui_name = "Visiblity Group Name"
			}
		},
		control_order = {
			"visiblity_group_name"
		}
	}
}

return RandomizedFriendRockUnit
