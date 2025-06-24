-- chunkname: @scripts/ui/render_target_atlas_generator.lua

local RenderTargetAtlasGenerator = class("RenderTargetAtlasGenerator")

RenderTargetAtlasGenerator.init = function (self, render_settings)
	self._atlases = {}
	self._indexes_to_remove = {}
	self._atlases_to_destroy = {}
	self._default_atlas_rows = 5
	self._default_atlas_columns = 5
	self._atlas_destruction_delay_time = 1
end

RenderTargetAtlasGenerator.generate_atlas_grid_index = function (self, slot_width, slot_height, optional_atlas_width, optional_atlas_height)
	local atlas = self:_get_available_atlas_by_slot_size(slot_width, slot_height)

	atlas = atlas or self:_create_atlas_grid(slot_width, slot_height, optional_atlas_width, optional_atlas_height)

	local grid_index = self:_get_atlas_free_grid_index(atlas)

	self:_occupy_atlas_grid_index(atlas, grid_index)

	local atlas_id = atlas.id

	return grid_index, atlas_id
end

RenderTargetAtlasGenerator.free_atlas_grid_index = function (self, atlas_id, grid_index)
	local atlas = self:_get_atlas_by_id(atlas_id)

	self._indexes_to_remove[#self._indexes_to_remove + 1] = {
		atlas = atlas,
		grid_index = grid_index,
	}
end

RenderTargetAtlasGenerator.update = function (self, dt, t)
	self:_handle_grid_index_removal()
	self:_handle_atlas_destruction(dt)
end

RenderTargetAtlasGenerator._handle_grid_index_removal = function (self)
	local indexes_to_remove = self._indexes_to_remove

	for i = #self._indexes_to_remove, 1, -1 do
		local index_to_remove = self._indexes_to_remove[i]
		local atlas = index_to_remove.atlas
		local grid_index = index_to_remove.grid_index
		local atlas_id = atlas.id
		local occupied_grid_slots = atlas.occupied_grid_slots
		local num_used_grid_slots = atlas.num_used_grid_slots

		atlas.num_used_grid_slots = num_used_grid_slots - 1
		occupied_grid_slots[grid_index] = false

		table.remove(self._indexes_to_remove, i)

		if atlas.num_used_grid_slots == 0 then
			local atlases = self._atlases

			if atlases[atlas_id] then
				self._atlases[atlas_id] = nil
				self._atlases_to_destroy[atlas_id] = atlas
			end
		end
	end
end

RenderTargetAtlasGenerator._handle_atlas_destruction = function (self, dt, instant)
	local atlases_to_destroy = self._atlases_to_destroy

	for atlas_id, atlas in pairs(atlases_to_destroy) do
		if not instant and (not atlas.destruction_timer or atlas.destruction_timer > 0) then
			atlas.destruction_timer = (atlas.destruction_timer or self._atlas_destruction_delay_time) - dt
		else
			atlases_to_destroy[atlas_id] = nil

			local render_target = atlas.render_target

			Renderer.destroy_resource(render_target)
		end
	end
end

RenderTargetAtlasGenerator.store_render_target_to_atlas = function (self, render_target, atlas_id, grid_index)
	local atlas = self:_get_atlas_by_id(atlas_id)
	local uv_grid = atlas.uv_grid
	local grid_uvs = uv_grid[grid_index]
	local size_scale_x = grid_uvs[2][1] - grid_uvs[1][1]
	local size_scale_y = grid_uvs[2][2] - grid_uvs[1][2]
	local position_scale_x = grid_uvs[1][1]
	local position_scale_y = grid_uvs[1][2]
	local atlas_render_target = atlas.render_target

	Renderer.copy_render_target_rect(render_target, 0, 0, 1, 1, atlas_render_target, position_scale_x, position_scale_y, size_scale_x, size_scale_y)
end

RenderTargetAtlasGenerator.destroy = function (self)
	local atlases = self._atlases

	for atlas_id, atlas in pairs(atlases) do
		local render_target = atlas.render_target

		Renderer.destroy_resource(render_target)
	end

	self._atlases = nil

	local handle_instantly = true

	self:_handle_atlas_destruction(nil, handle_instantly)
end

RenderTargetAtlasGenerator.get_atlas_render_target = function (self, atlas_id)
	local atlas = self:_get_atlas_by_id(atlas_id)

	if atlas then
		local rows = atlas.rows
		local columns = atlas.columns
		local render_target = atlas.render_target

		return render_target, rows, columns
	end
end

RenderTargetAtlasGenerator._create_uv_grid = function (self, grid_size, slot_size)
	local num_columns = math.floor(grid_size[1] / slot_size[1])
	local num_rows = math.floor(grid_size[2] / slot_size[2])
	local uv_grid = {}

	for i = 1, num_rows do
		local y_start = (i - 1) / num_rows
		local y_end = i / num_rows

		for j = 1, num_columns do
			local x_start = (j - 1) / num_columns
			local x_end = j / num_columns
			local uvs = {
				{
					x_start,
					y_start,
				},
				{
					x_end,
					y_end,
				},
			}
			local grid_index = #uv_grid + 1

			uv_grid[grid_index] = uvs
		end
	end

	return uv_grid, num_rows, num_columns
end

RenderTargetAtlasGenerator._create_atlas_grid = function (self, slot_width, slot_height, optional_atlas_width, optional_atlas_height)
	local atlas_id = math.uuid()
	local slot_size = {
		slot_width,
		slot_height,
	}
	local default_atlas_rows = self._default_atlas_rows
	local default_atlas_columns = self._default_atlas_columns
	local atlas_size = {
		optional_atlas_width or slot_width * default_atlas_rows,
		optional_atlas_height or slot_height * default_atlas_columns,
	}
	local uv_grid, num_rows, num_columns = self:_create_uv_grid(atlas_size, slot_size)
	local atlas = {
		num_used_grid_slots = 0,
		slot_id_generator_counter = 0,
		id = atlas_id,
		slot_size = slot_size,
		atlas_size = atlas_size,
		columns = num_columns,
		rows = num_rows,
		uv_grid = uv_grid,
		render_target = Renderer.create_resource("render_target", "R8G8B8A8", nil, atlas_size[1], atlas_size[2], atlas_id),
		occupied_grid_slots = {},
		max_grid_slots = num_columns * num_rows,
	}

	self._atlases[atlas_id] = atlas

	return atlas
end

RenderTargetAtlasGenerator._get_atlas_by_id = function (self, atlas_id)
	local atlases = self._atlases

	return atlases[atlas_id]
end

RenderTargetAtlasGenerator._get_available_atlas_by_slot_size = function (self, width, height)
	local atlases = self._atlases

	for atlas_id, atlas in pairs(atlases) do
		local max_grid_slots = atlas.max_grid_slots
		local num_used_grid_slots = atlas.num_used_grid_slots

		if num_used_grid_slots < max_grid_slots then
			local slot_size = atlas.slot_size

			if slot_size[1] == width and slot_size[2] == height then
				return atlas
			end
		end
	end
end

RenderTargetAtlasGenerator._get_atlas_free_grid_index = function (self, atlas)
	local occupied_grid_slots = atlas.occupied_grid_slots
	local max_grid_slots = atlas.max_grid_slots

	for i = 1, max_grid_slots do
		if not occupied_grid_slots[i] then
			return i
		end
	end
end

RenderTargetAtlasGenerator._occupy_atlas_grid_index = function (self, atlas, grid_index)
	local num_used_grid_slots = atlas.num_used_grid_slots
	local occupied_grid_slots = atlas.occupied_grid_slots
	local max_grid_slots = atlas.max_grid_slots

	if num_used_grid_slots == max_grid_slots then
		-- Nothing
	end

	atlas.num_used_grid_slots = num_used_grid_slots + 1
	occupied_grid_slots[grid_index] = true
end

return RenderTargetAtlasGenerator
