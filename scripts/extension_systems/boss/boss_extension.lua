local BossExtension = class("BossExtension")

BossExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	self._unit = unit
	local seed = extension_init_data.seed
	self._seed = seed
	local breed = extension_init_data.breed
	self._breed = breed

	self:_generate_display_name()
end

BossExtension.extensions_ready = function (self)
	local breed = self._breed

	if not breed.trigger_boss_health_bar_on_aggro then
		Managers.event:trigger("boss_encounter_start", self._unit, self)
	end
end

BossExtension.destroy = function (self)
	Managers.event:trigger("boss_encounter_end", self._unit, self)
end

BossExtension.start_timer = function (self)
	if self._first_damaged_at == nil then
		self._first_damaged_at = Managers.time:time("main")
	end
end

BossExtension.time_since_first_damage = function (self)
	if self._first_damaged_at ~= nil then
		return Managers.time:time("main") - self._first_damaged_at
	end

	return math.huge
end

BossExtension._generate_display_name = function (self)
	local breed = self._breed
	local display_name = breed.boss_display_name

	if display_name then
		local seed = self._seed

		if type(display_name) == "table" then
			local next_seed, index = math.next_random(seed, 1, #display_name)
			display_name = display_name[index]
			self._seed = next_seed
		end

		self._display_name = display_name
	end
end

BossExtension.display_name = function (self)
	return self._display_name
end

return BossExtension
