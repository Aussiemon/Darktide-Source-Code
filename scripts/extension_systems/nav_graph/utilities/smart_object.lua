-- chunkname: @scripts/extension_systems/nav_graph/utilities/smart_object.lua

local SmartObject = class("SmartObject")

SmartObject.LAST_SMART_OBJECT_ID = SmartObject.LAST_SMART_OBJECT_ID or 0
SmartObject.MAX_SMART_OBJECT_ID = 471100

SmartObject.increment_smart_object_id = function ()
	local new_value = SmartObject.LAST_SMART_OBJECT_ID + 1

	SmartObject.LAST_SMART_OBJECT_ID = new_value

	return new_value
end

SmartObject.reset_last_smart_object_id = function ()
	SmartObject.LAST_SMART_OBJECT_ID = 0
end

SmartObject.init = function (self)
	local smart_object_id = SmartObject.increment_smart_object_id()

	self._id = smart_object_id
	self._layer_type = ""
	self._entrance_position = Vector3Box()
	self._exit_position = Vector3Box()
	self._data = {
		ledge_type = "",
		jump_flat_distance = 0,
		is_bidirectional = true,
		ledge_position = Vector3Box(),
		ledge_position1 = Vector3Box(),
		ledge_position2 = Vector3Box()
	}

	return smart_object_id
end

SmartObject.to_simple = function (self)
	local data = self._data
	local entrance_position = self._entrance_position:unbox()
	local exit_position = self._exit_position:unbox()
	local ledge_position = data.ledge_position:unbox()
	local ledge_position1 = data.ledge_position1:unbox()
	local ledge_position2 = data.ledge_position2:unbox()
	local smart_object = {
		layer_type = self._layer_type,
		entrance_position = Vector3.to_array(entrance_position),
		exit_position = Vector3.to_array(exit_position),
		data = {
			is_bidirectional = data.is_bidirectional,
			jump_flat_distance = data.jump_flat_distance,
			ledge_type = data.ledge_type,
			ledge_position = Vector3.to_array(ledge_position),
			ledge_position1 = Vector3.to_array(ledge_position1),
			ledge_position2 = Vector3.to_array(ledge_position2)
		}
	}

	return smart_object
end

SmartObject.from_simple = function (self, simple_smart_object)
	self._layer_type = simple_smart_object.layer_type

	self._entrance_position:store(Vector3.from_array(simple_smart_object.entrance_position))
	self._exit_position:store(Vector3.from_array(simple_smart_object.exit_position))

	local data, simple_smart_object_data = self._data, simple_smart_object.data

	data.is_bidirectional = simple_smart_object_data.is_bidirectional
	data.jump_flat_distance = simple_smart_object_data.jump_flat_distance
	data.ledge_type = simple_smart_object_data.ledge_type

	data.ledge_position:store(Vector3.from_array(simple_smart_object_data.ledge_position))
	data.ledge_position1:store(Vector3.from_array(simple_smart_object_data.ledge_position1))
	data.ledge_position2:store(Vector3.from_array(simple_smart_object_data.ledge_position2))
end

SmartObject.id = function (self)
	return self._id
end

SmartObject.set_entrance_exit_positions = function (self, entrance_position, exit_position)
	self._entrance_position:store(entrance_position)
	self._exit_position:store(exit_position)
end

SmartObject.get_entrance_exit_positions = function (self)
	local entrance_position = self._entrance_position:unbox()
	local exit_position = self._exit_position:unbox()

	return entrance_position, exit_position
end

SmartObject.data = function (self)
	return self._data
end

SmartObject.set_is_bidirectional = function (self, is_bidirectional)
	self._data.is_bidirectional = is_bidirectional
end

SmartObject.is_bidirectional = function (self)
	return self._data.is_bidirectional
end

SmartObject.set_layer_type = function (self, layer_type)
	self._layer_type = layer_type
end

SmartObject.layer_type = function (self)
	return self._layer_type
end

SmartObject.set_ledge = function (self, ledge_type, ledge_position, ledge_position1, ledge_position2)
	self._data.ledge_type = ledge_type

	local ledge_position_vec = Vector3.from_array(ledge_position)

	self._data.ledge_position:store(ledge_position_vec)

	local ledge_position1_vec = Vector3.from_array(ledge_position1)

	self._data.ledge_position1:store(ledge_position1_vec)

	local ledge_position2_vec = Vector3.from_array(ledge_position2)

	self._data.ledge_position2:store(ledge_position2_vec)
end

SmartObject.set_jump_distance = function (self, distance)
	self._data.jump_flat_distance = distance
end

return SmartObject
