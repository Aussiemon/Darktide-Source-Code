-- chunkname: @scripts/components/luggable_socket.lua

local LuggableSocket = component("LuggableSocket")

LuggableSocket.init = function (self, unit)
	self:enable(unit)

	local luggable_socket_extension = ScriptUnit.fetch_component_extension(unit, "luggable_socket_system")

	if luggable_socket_extension then
		local consume_luggable = self:get_data(unit, "consume_luggable")
		local is_side_mission_socket = self:get_data(unit, "is_side_mission_socket")
		local lock_offset_node = self:get_data(unit, "lock_offset_node")

		lock_offset_node = (lock_offset_node ~= "" or nil) and lock_offset_node

		luggable_socket_extension:setup_from_component(consume_luggable, is_side_mission_socket, lock_offset_node)
	end
end

LuggableSocket.editor_init = function (self, unit)
	self:enable(unit)
end

LuggableSocket.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if rawget(_G, "LevelEditor") then
		if Unit.find_actor(unit, "g_slot") == nil then
			success = false
			error_message = error_message .. "\nCouldn't find actor 'g_slot'"
		end

		if not Unit.has_visibility_group(unit, "main") then
			success = false
			error_message = error_message .. "\nCouldn't find visibility group 'main'"
		end
	end

	return success, error_message
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
		ui_name = "Consume Luggable",
		ui_type = "check_box",
		value = false,
	},
	is_side_mission_socket = {
		category = "Side Mission",
		ui_name = "Is Side Mission Socket",
		ui_type = "check_box",
		value = false,
	},
	lock_offset_node = {
		ui_name = "Lock Offset Node",
		ui_type = "text_box",
		value = "",
	},
	extensions = {
		"LuggableSocketExtension",
	},
}

return LuggableSocket
