local EnvironmentBlend = class("EnvironmentBlend")

EnvironmentBlend.init = function (self, world)
	self._active_blends = {}
	self._registered_blends = {}
	self._blend_layers = {}
end

EnvironmentBlend.register_environment = function (self, blend)
	local layer = blend:layer()
	local blend_layers = self._blend_layers

	if layer > #blend_layers then
		local start_index = math.max(1, #blend_layers)

		for i = start_index, layer do
			if blend_layers[i] == nil then
				blend_layers[i] = {}
			end
		end
	end

	local layer_blends = blend_layers[layer]
	layer_blends[#layer_blends + 1] = blend
end

EnvironmentBlend.unregister_environment = function (self, blend)
	local layer = blend:layer()
	local layer_blends = self._blend_layers[layer]

	for i = #layer_blends, 1, -1 do
		if layer_blends[i] == blend then
			table.remove(layer_blends, i)
		end
	end
end

local blend_list = {}

EnvironmentBlend.blend_list = function (self, camera_pos, default_shading_environment_resource)
	table.clear(blend_list)

	local blend_layers = self._blend_layers
	local solid_layer_found = false

	if #blend_layers > 0 then
		for i = #blend_layers, 1, -1 do
			if solid_layer_found then
				break
			end

			local layer_blends = blend_layers[i]

			for ii = 1, #layer_blends do
				local blend = layer_blends[ii]
				local weight = blend:weight(camera_pos)

				if weight > 0 then
					local resource = blend:resource()
					local blend_mask = blend:blend_mask()
					blend_list[#blend_list + 1] = blend_mask
					blend_list[#blend_list + 1] = weight
					blend_list[#blend_list + 1] = resource

					if weight >= 1 and blend_mask == ShadingEnvironmentBlendMask.ALL then
						solid_layer_found = true

						break
					end
				end
			end
		end
	end

	if not solid_layer_found then
		blend_list[#blend_list + 1] = ShadingEnvironmentBlendMask.ALL
		blend_list[#blend_list + 1] = 1
		blend_list[#blend_list + 1] = default_shading_environment_resource
	end

	table.reverse(blend_list)

	return blend_list
end

return EnvironmentBlend
