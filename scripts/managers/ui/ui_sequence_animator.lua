local UISequenceAnimator = class("UISequenceAnimator")

UISequenceAnimator.init = function (self, ui_scenegraph, scenegraph_definition, animation_definitions)
	self._ui_scenegraph = ui_scenegraph
	self._animation_definitions = animation_definitions
	self._scenegraph_definition = scenegraph_definition
	self._active_animations = {}
	self._animation_id = 0
end

UISequenceAnimator.start_animation = function (self, parent, animation_sequence_name, widgets, params, speed, callback)
	fassert(not speed or speed > 0, "[UISequenceAnimator] - speed must be a value higher than zero. currently (%s)", tostring(speed))

	local animation_sequence = self._animation_definitions[animation_sequence_name]
	local animation_id = self._animation_id + 1
	self._animation_id = animation_id
	self._active_animations[animation_id] = {
		time = 0,
		completed = false,
		parent = parent,
		animation_sequence_name = animation_sequence_name,
		widgets = widgets,
		callback = callback,
		running_animations = {},
		completed_animations = {},
		params = params or {},
		times = {}
	}
	local times = self._active_animations[animation_id].times

	for i = 1, #animation_sequence, 1 do
		local animation = animation_sequence[i]
		local start_time = animation.start_time
		local end_time = animation.end_time

		if speed then
			local duration = (end_time - start_time) / speed
			start_time = start_time / speed
			end_time = start_time + duration
		end

		local start_time_index = (i - 1) * 2 + 1
		local end_time_index = (i - 1) * 2 + 2
		times[start_time_index] = start_time
		times[end_time_index] = end_time
	end

	return animation_id
end

UISequenceAnimator.update = function (self, dt, t)
	local ui_scenegraph = self._ui_scenegraph
	local scenegraph_definition = self._scenegraph_definition
	local animation_definitions = self._animation_definitions
	local active_animations = self._active_animations
	local is_scenegraph_dirty = false
	local update_scenegraph = false

	for name, data in pairs(active_animations) do
		local animation_sequence_name = data.animation_sequence_name
		local widgets = data.widgets
		local parent = data.parent
		local completed_animations = data.completed_animations
		local times = data.times
		local params = data.params
		local force_complete = data.force_complete
		local time = data.time + dt
		data.time = time
		local all_done = true
		local animation_sequence = animation_definitions[animation_sequence_name]

		for i = 1, #animation_sequence, 1 do
			local animation = animation_sequence[i]
			local animation_name = animation.name
			local start_time = times[(i - 1) * 2 + 1]
			local end_time = times[(i - 1) * 2 + 2]

			if time < end_time and not force_complete then
				all_done = false
			end

			if (force_complete or start_time < time) and not completed_animations[animation.name] then
				local local_progress = (force_complete and 1) or math.min((time - start_time) / (end_time - start_time), 1)
				local running_animations = data.running_animations

				if not running_animations[animation_name] then
					running_animations[animation_name] = true
					local init = animation.init

					if init then
						init(parent, ui_scenegraph, scenegraph_definition, widgets, params)
					end
				end

				local update = animation.update

				if update then
					update_scenegraph = update(parent, ui_scenegraph, scenegraph_definition, widgets, local_progress, params) or update_scenegraph
				end

				if local_progress == 1 then
					local on_complete = animation.on_complete

					if on_complete then
						on_complete(parent, ui_scenegraph, scenegraph_definition, widgets, params)
					end

					completed_animations[animation.name] = true
					running_animations[animation_name] = nil
				end
			end
		end

		if all_done then
			local callback = active_animations[name].callback

			if callback then
				callback()
			end

			active_animations[name] = nil
		end

		is_scenegraph_dirty = is_scenegraph_dirty or update_scenegraph
	end

	return is_scenegraph_dirty
end

UISequenceAnimator.complete_animation = function (self, animation_id)
	local animation_definitions = self._animation_definitions
	local animation = self._active_animations[animation_id]
	animation.force_complete = true
end

UISequenceAnimator.is_animation_active = function (self, animation_id)
	return self._active_animations[animation_id] ~= nil
end

UISequenceAnimator.is_animation_completed = function (self, animation_id)
	return self._active_animations[animation_id] == nil
end

UISequenceAnimator.stop_animation = function (self, animation_id)
	self._active_animations[animation_id] = nil
end

return UISequenceAnimator
