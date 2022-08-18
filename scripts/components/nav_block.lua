local NavBlock = component("NavBlock")

NavBlock.init = function (self, unit, is_server)
	self._is_server = is_server
	local nav_block_extension = ScriptUnit.fetch_component_extension(unit, "nav_block_system")

	if nav_block_extension then
		local start_blocked = self:get_data(unit, "start_blocked")

		nav_block_extension:setup_from_component(start_blocked)

		self._nav_block_extension = nav_block_extension
	end
end

NavBlock._set_block = function (self, val)
	local nav_block_extension = self._nav_block_extension

	if nav_block_extension and self._is_server then
		nav_block_extension:set_block(val)
	end
end

NavBlock.editor_init = function (self, unit)
	return
end

NavBlock.enable = function (self, unit)
	return
end

NavBlock.disable = function (self, unit)
	return
end

NavBlock.destroy = function (self, unit)
	return
end

NavBlock.block_nav = function (self)
	self:_set_block(true)
end

NavBlock.unblock_nav = function (self)
	self:_set_block(false)
end

NavBlock.component_data = {
	start_blocked = {
		ui_type = "check_box",
		value = true,
		ui_name = "Start blocked"
	},
	inputs = {
		block_nav = {
			accessibility = "public",
			type = "event"
		},
		unblock_nav = {
			accessibility = "public",
			type = "event"
		}
	},
	extensions = {
		"NavBlockExtension"
	}
}

return NavBlock
