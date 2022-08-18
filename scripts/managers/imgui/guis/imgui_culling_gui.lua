local ImguiCullingGui = class("ImguiCullingGui")
local CullingAPIs = {
	"None",
	"Moc"
}

ImguiCullingGui.init = function (self, world, ...)
	self._input_manager = Managers.input
	self._world = world
	self.debug_options = {
		{
			mask = 16,
			name = "Draw Viewcell",
			enabled = false,
			query = 0
		},
		{
			mask = 32,
			name = "Draw Portals",
			enabled = false,
			query = 0
		},
		{
			mask = 64,
			name = "Draw Visibility Lines",
			enabled = false,
			query = 0
		},
		{
			mask = 128,
			name = "Draw Object bounds",
			enabled = false,
			query = 0
		},
		{
			mask = 256,
			name = "Draw Visible Volume",
			enabled = false,
			query = 0
		},
		{
			mask = 512,
			name = "Draw View Frustum",
			enabled = false,
			query = 0
		},
		{
			mask = 32,
			name = "Draw Shadow Projection",
			enabled = false,
			query = 1
		},
		{
			mask = 1024,
			name = "Show Statistics",
			enabled = false,
			query = 0
		},
		{
			mask = 1,
			name = "Single Threaded Query",
			enabled = false,
			query = 2
		},
		{
			mask = 2,
			name = "Show Occlusion Buffer",
			enabled = false,
			query = 2
		},
		{
			mask = 4,
			name = "Show Shadow Mask Buffer",
			enabled = false,
			query = 2
		},
		{
			mask = 64,
			name = "Show Downsampled Occlusion Buffer",
			enabled = false,
			query = 2
		},
		{
			mask = 8,
			name = "Draw Visible Objects",
			enabled = false,
			query = 2
		},
		{
			mask = 16,
			name = "Draw Culled Shadow Casters",
			enabled = false,
			query = 2
		},
		{
			mask = 32,
			name = "Draw Visible Shadow Casters",
			enabled = false,
			query = 2
		}
	}
	self.debug_config = {
		portal_query_distance = {
			speed = 1,
			idx = 0,
			min = 0,
			max = 100
		},
		portal_query_accurate_occlusion_threshold = {
			speed = 1,
			idx = 1,
			min = 0,
			max = 255
		},
		portal_query_contribution_threshold_distance = {
			speed = 1,
			idx = 2,
			min = 0,
			max = 255
		},
		portal_query_contribution_threshold = {
			speed = 1,
			idx = 3,
			min = 0,
			max = 1
		}
	}
end

ImguiCullingGui._subwindow_count = function (self)
	return 0
end

ImguiCullingGui.update = function (self, dt, t)
	local world = self._world
	local api = World.get_culling_api()
	local new_api = Imgui.combo("Culling API", api, CullingAPIs) - 1

	if api ~= new_api then
		World.set_culling_api(new_api)
	end

	if new_api == 1 then
		World.imgui_draw_moc(world)
	end
end

return ImguiCullingGui
