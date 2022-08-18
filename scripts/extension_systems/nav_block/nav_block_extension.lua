local NavBlockExtension = class("NavBlockExtension")

NavBlockExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._start_blocked = nil
	self._layer_name = ""

	fassert(Unit.has_volume(unit, "g_volume_block"), "[NavBlockExtension][init][Unit: %s] Missing volume 'g_volume_block'.", Unit.id_string(unit))
	self:_setup_nav_gate(unit, not self._start_blocked)
end

NavBlockExtension.destroy = function (self)
	if self._is_server then
		local nav_mesh_manager = Managers.state.nav_mesh
		local layer_name = self._layer_name

		if not nav_mesh_manager:is_nav_tag_volume_layer_allowed(layer_name) then
			nav_mesh_manager:set_allowed_nav_tag_layer(layer_name, true)
		end
	end
end

NavBlockExtension.setup_from_component = function (self, start_blocked)
	self._start_blocked = start_blocked
end

NavBlockExtension.update = function (self, unit, dt, t)
	if self._is_server and self._start_blocked ~= nil then
		self:set_block(self._start_blocked)

		self._start_blocked = nil
	end
end

NavBlockExtension.set_block = function (self, block)
	fassert(self._is_server, "[NavBlockExtension][set_block] Method should only be called on the server")

	local nav_mesh_manager = Managers.state.nav_mesh
	local is_allowed = not block

	nav_mesh_manager:set_allowed_nav_tag_layer(self._layer_name, is_allowed)
end

NavBlockExtension._get_volume_alt_min_max = function (self, volume_points)
	fassert(#volume_points > 0, "[NavBlockExtension][_get_volume_alt_min_max][Unit: %s] No volume points.", Unit.id_string(self._unit))

	local alt_min, alt_max = nil

	for i = 1, #volume_points, 1 do
		local alt = volume_points[i].z

		if not alt_min or alt < alt_min then
			alt_min = alt
		end

		if not alt_max or alt_max < alt then
			alt_max = alt
		end
	end

	return alt_min, alt_max
end

NavBlockExtension._setup_nav_gate = function (self, unit, layer_allowed)
	local unit_level_index = Managers.state.unit_spawner:level_index(unit)
	local layer_name = "nav_block_volume_" .. tostring(unit_level_index)
	local volume_points = Unit.volume_points(unit, "g_volume_block")
	local volume_alt_min, volume_alt_max = self:_get_volume_alt_min_max(volume_points)

	Managers.state.nav_mesh:add_nav_tag_volume(volume_points, volume_alt_min, volume_alt_max, layer_name, layer_allowed)

	self._layer_name = layer_name
end

return NavBlockExtension
