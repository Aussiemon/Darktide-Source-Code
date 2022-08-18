local LuggableSocket = component("LuggableSocket")

LuggableSocket.init = function (self, unit)
	self:enable(unit)

	local luggable_socket_extension = ScriptUnit.fetch_component_extension(unit, "luggable_socket_system")

	if luggable_socket_extension then
		local consume_luggable = self:get_data(unit, "consume_luggable")
		local is_side_mission_socket = self:get_data(unit, "is_side_mission_socket")
		local lock_offset_node = self:get_data(unit, "lock_offset_node")

		if lock_offset_node == "" then
			lock_offset_node = nil
		else
			fassert(Unit.has_node(unit, lock_offset_node), "[LuggableSocket] Missing custom node '%s'", lock_offset_node)
		end

		luggable_socket_extension:setup_from_component(consume_luggable, is_side_mission_socket, lock_offset_node)
	end
end

LuggableSocket.editor_init = function (self, unit)
	self:enable(unit)
end

LuggableSocket.enable = function (self, unit)
	return
end

LuggableSocket.disable = function (self, unit)
	return
end

LuggableSocket.destroy = function (self, unit)
	return
end

LuggableSocket.component_data = {
	consume_luggable = {
		ui_type = "check_box",
		value = false,
		ui_name = "Consume Luggable"
	},
	is_side_mission_socket = {
		ui_type = "check_box",
		value = false,
		ui_name = "Is Side Mission Socket",
		category = "Side Mission"
	},
	lock_offset_node = {
		ui_type = "text_box",
		value = "",
		ui_name = "Lock Offset Node"
	},
	extensions = {
		"LuggableSocketExtension"
	}
}

return LuggableSocket
