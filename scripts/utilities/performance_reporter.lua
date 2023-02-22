local PerformanceReporter = class("PerformanceReporter")

PerformanceReporter.init = function (self, mspf_threads, batchcount, primitives)
	self._frame_count = 0
	self._measurements_aligned = false
	self._min_ms_per_frame_main = math.huge
	self._max_ms_per_frame_main = 0
	self._avg_ms_per_frame_main = 0
	self._mspf_main = {}
	self._mspf_threads = mspf_threads

	if mspf_threads then
		self._min_ms_per_frame_render = math.huge
		self._max_ms_per_frame_render = 0
		self._avg_ms_per_frame_render = 0
		self._mspf_render = {}
		self._min_ms_per_frame_gpu = math.huge
		self._max_ms_per_frame_gpu = 0
		self._avg_ms_per_frame_gpu = 0
		self._mspf_gpu = {}

		Renderer.set_gpu_profiling(true)
	end

	self._batchcount = batchcount == nil and true or batchcount

	if batchcount then
		self._min_batchcount = math.huge
		self._max_batchcount = 0
		self._avg_batchcount = 0
		self._batchcounts = {}
	end

	self._primitives = primitives == nil and true or primitives

	if primitives then
		self._min_primitives_count = math.huge
		self._max_primitives_count = 0
		self._avg_primitives_count = 0
		self._primitives_count = {}
	end
end

PerformanceReporter.update = function (self, dt, t)
	local ms_per_frame_main = dt * 1000
	local ms_per_frame_render, ms_per_frame_gpu = nil

	if self._mspf_threads then
		ms_per_frame_render, ms_per_frame_gpu = Application.get_frame_times()
	end

	if self._mspf_threads and ms_per_frame_gpu == 0 then
		return
	end

	local batchcount = self._batchcount and Application.get_batchcount_stats()
	local primitives_count = self._primitives and Application.get_primitives_count()
	self._frame_count = self._frame_count + 1

	self:_add_current_frame_values(ms_per_frame_main, ms_per_frame_render, ms_per_frame_gpu, batchcount, primitives_count)
	self:_update_min_values(ms_per_frame_main, ms_per_frame_render, ms_per_frame_gpu, batchcount, primitives_count)
	self:_update_max_values(ms_per_frame_main, ms_per_frame_render, ms_per_frame_gpu, batchcount, primitives_count)
	self:_update_avg_values(ms_per_frame_main, ms_per_frame_render, ms_per_frame_gpu, batchcount, primitives_count)
end

PerformanceReporter.performance_measurements = function (self)
	self:_stitch_together_frame_values()

	local math_median = math.get_median_value
	local performance_measurements = {
		ms_per_frame_main = {
			min = self._min_ms_per_frame_main,
			max = self._max_ms_per_frame_main,
			avg = self._avg_ms_per_frame_main,
			median = math_median(self._mspf_main)
		},
		ms_per_frame_render = self._mspf_threads and {
			min = self._min_ms_per_frame_render,
			max = self._max_ms_per_frame_render,
			avg = self._avg_ms_per_frame_render,
			median = math_median(self._mspf_render)
		} or nil,
		ms_per_frame_gpu = self._mspf_threads and {
			min = self._min_ms_per_frame_gpu,
			max = self._max_ms_per_frame_gpu,
			avg = self._avg_ms_per_frame_gpu,
			median = math_median(self._mspf_gpu)
		} or nil,
		batchcount = self._batchcount and {
			min = self._min_batchcount,
			max = self._max_batchcount,
			avg = self._avg_batchcount,
			median = math_median(self._batchcounts)
		} or nil,
		primitives_count = self._primitives and {
			min = self._min_primitives_count,
			max = self._max_primitives_count,
			avg = self._avg_primitives_count,
			median = math_median(self._primitives_count)
		} or nil
	}

	return performance_measurements
end

PerformanceReporter._add_current_frame_values = function (self, ms_per_frame_main, ms_per_frame_render, ms_per_frame_gpu, batchcount, primitives_count)
	local frame_count = self._frame_count
	self._mspf_main[frame_count] = ms_per_frame_main

	if self._mspf_threads then
		self._mspf_gpu[frame_count] = ms_per_frame_gpu
		self._mspf_render[frame_count] = ms_per_frame_render
	end

	if self._batchcount then
		self._batchcounts[frame_count] = batchcount
	end

	if self._primitives then
		self._primitives_count[frame_count] = primitives_count
	end
end

PerformanceReporter._update_min_values = function (self, ms_per_frame_main, ms_per_frame_render, ms_per_frame_gpu, batchcount, primitives_count)
	self._min_ms_per_frame_main = ms_per_frame_main < self._min_ms_per_frame_main and ms_per_frame_main or self._min_ms_per_frame_main
	self._min_ms_per_frame_render = ms_per_frame_render and ms_per_frame_render < self._min_ms_per_frame_render and ms_per_frame_render or self._min_ms_per_frame_render
	self._min_ms_per_frame_gpu = ms_per_frame_gpu and ms_per_frame_gpu < self._min_ms_per_frame_gpu and ms_per_frame_gpu or self._min_ms_per_frame_gpu
	self._min_batchcount = batchcount and batchcount < self._min_batchcount and batchcount or self._min_batchcount
	self._min_primitives_count = primitives_count and primitives_count < self._min_primitives_count and primitives_count or self._min_primitives_count
end

PerformanceReporter._update_max_values = function (self, ms_per_frame_main, ms_per_frame_render, ms_per_frame_gpu, batchcount, primitives_count)
	self._max_ms_per_frame_main = self._max_ms_per_frame_main < ms_per_frame_main and ms_per_frame_main or self._max_ms_per_frame_main
	self._max_ms_per_frame_render = ms_per_frame_render and self._max_ms_per_frame_render < ms_per_frame_render and ms_per_frame_render or self._max_ms_per_frame_render
	self._max_ms_per_frame_gpu = ms_per_frame_gpu and self._max_ms_per_frame_gpu < ms_per_frame_gpu and ms_per_frame_gpu or self._max_ms_per_frame_gpu
	self._max_batchcount = batchcount and self._max_batchcount < batchcount and batchcount or self._max_batchcount
	self._max_primitives_count = primitives_count and self._max_primitives_count < primitives_count and primitives_count or self._max_primitives_count
end

PerformanceReporter._update_avg_values = function (self, ms_per_frame, batchcount, primitives_count)
	self._avg_ms_per_frame = (ms_per_frame + self._avg_ms_per_frame * (#self._mspf - 1)) / #self._mspf
	self._avg_batchcount = (batchcount + self._avg_batchcount * (#self._batchcounts - 1)) / #self._batchcounts
	self._avg_primitives_count = (primitives_count + self._avg_primitives_count * (#self._primitives_count - 1)) / #self._primitives_count
end

PerformanceReporter._update_avg_values = function (self, ms_per_frame_main, ms_per_frame_render, ms_per_frame_gpu, batchcount, primitives_count)
	local frame_count = self._frame_count
	self._avg_ms_per_frame_main = (ms_per_frame_main + self._avg_ms_per_frame_main * (frame_count - 1)) / frame_count
	self._avg_ms_per_frame_render = ms_per_frame_render and (ms_per_frame_render + self._avg_ms_per_frame_render * (frame_count - 1)) / frame_count
	self._avg_ms_per_frame_gpu = ms_per_frame_gpu and (ms_per_frame_gpu + self._avg_ms_per_frame_gpu * (frame_count - 1)) / frame_count
	self._avg_batchcount = batchcount and (batchcount + self._avg_batchcount * (frame_count - 1)) / frame_count
	self._avg_primitives_count = primitives_count and (primitives_count + self._avg_primitives_count * (frame_count - 1)) / frame_count
end

PerformanceReporter._stitch_together_frame_values = function (self)
	if self._measurements_aligned then
		return
	end

	self._measurements_aligned = true
	local frame_count = self._frame_count
	local mspf_main = self._mspf_main
	local mspf_render = self._mspf_render
	local mspf_gpu = self._mspf_gpu
	local batchcounts = self._batchcounts
	local primitives_counts = self._primitives_count

	if self._mspf_threads then
		mspf_main[frame_count - 1] = nil
		mspf_main[frame_count] = nil
		mspf_render[frame_count] = nil

		table.remove(mspf_render, 1)
		table.remove_sequence(mspf_gpu, 1, 2)

		if self._batchcount then
			batchcounts[frame_count] = nil

			table.remove(batchcounts, 1)
		end

		if self._primitives then
			primitives_counts[frame_count] = nil

			table.remove(primitives_counts, 1)
		end
	elseif self._batchcount or self._primitives then
		mspf_main[frame_count] = nil

		if self._batchcount then
			table.remove(batchcounts, 1)
		end

		if self._primitives then
			table.remove(primitives_counts, 1)
		end
	end
end

return PerformanceReporter
