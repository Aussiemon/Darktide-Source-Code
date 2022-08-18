local TransitionManager = class("TransitionManager")

TransitionManager.init = function (self)
	self._color = {
		255,
		0,
		0,
		0
	}
	self._fade_speed = 0
end

TransitionManager.fade_in = function (self, speed, callback)
	self._fade_state = "fade_in"
	self._fade_speed = speed
	self._callback = callback
end

TransitionManager.fade_out = function (self, speed, callback)
	self._fade_state = "fade_out"
	self._fade_speed = -speed
	self._callback = callback
end

TransitionManager.force_fade_in = function (self)
	self._fade_state = "in"
	self._fade_speed = 0
	self._fade = 1

	if self._callback then
		self._callback()

		self._callback = nil
	end
end

TransitionManager.force_fade_out = function (self)
	self._fade_state = "out"
	self._fade_speed = 0
	self._fade = 0

	if self._callback then
		self._callback()

		self._callback = nil
	end
end

TransitionManager._render_overlay = function (self, dt)
	local w, h = nil

	if Application.screen_resolution then
		w, h = Application.screen_resolution()
	else
		w, h = Application.resolution()
	end

	local color = self._color

	Gui.rect(self._gui, Vector3(0, 0, self._layer), Vector2(w, h), Color(self._fade * color[1], color[2], color[3], color[4]))
end

TransitionManager.update = function (self, dt)
	if self._fade_state == "out" then
		return
	end

	if self._fade_state == "in" then
		self:_render_overlay(dt)

		return
	end

	self._fade = math.clamp(self._fade + self._fade_speed * math.min(dt, 0.03333333333333333), 0, 1)

	if self._fade_state == "fade_in" and self._fade >= 1 then
		self._fade = 1
		self._fade_state = "in"

		if self._callback then
			local callback = self._callback
			self._callback = nil

			callback()
		end
	elseif self._fade_state == "fade_out" and self._fade <= 0 then
		self._fade = 0
		self._fade_state = "out"

		if self._callback then
			local callback = self._callback
			self._callback = nil

			callback()
		end

		return
	end

	if self._fade_state ~= "out" then
		self:_render_overlay(dt)
	end
end

return TransitionManager
