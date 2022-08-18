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

		for i = start_index, layer, 1 do
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
	local remaining_weight = 1

	if #blend_layers > 0 then
		for i = #blend_layers, 1, -1 do
			local layer_blends = blend_layers[i]

			if layer_blends and #layer_blends > 0 and remaining_weight > 0.001 then
				local weight_indices = {}
				local total_layer_weight = 0

				for _, blend in ipairs(layer_blends) do
					local weight = blend:weight(camera_pos)

					if weight > 0 then
						local resource = blend:resource()
						local blend_mask = blend:blend_mask()
						blend_list[#blend_list + 1] = resource
						local weight_index = #blend_list + 1
						weight_indices[#weight_indices + 1] = weight_index
						blend_list[weight_index] = weight
						blend_list[#blend_list + 1] = blend_mask
						total_layer_weight = total_layer_weight + weight
					end
				end

				if remaining_weight < total_layer_weight then
					for _, weight_index in ipairs(weight_indices) do
						blend_list[weight_index] = (blend_list[weight_index] * remaining_weight) / total_layer_weight
					end

					remaining_weight = 0
				else
					remaining_weight = remaining_weight - total_layer_weight
				end
			end
		end
	end

	if remaining_weight > 0 then
		blend_list[#blend_list + 1] = default_shading_environment_resource
		blend_list[#blend_list + 1] = remaining_weight
		blend_list[#blend_list + 1] = ShadingEnvironmentBlendMask.ALL
	end

	return blend_list
end

return EnvironmentBlend
