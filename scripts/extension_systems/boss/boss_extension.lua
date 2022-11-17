local BossExtension = class("BossExtension")

BossExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id)
	self._unit = unit
	local seed = extension_init_data.seed
	self._seed = seed
	local breed = extension_init_data.breed
	self._breed = breed
	self._world = extension_init_context.world
	self._wwise_world = extension_init_context.wwise_world
	self._is_server = extension_init_context.is_server
	self._boss_encounter_started = false

	self:_generate_display_name()

	if not self._is_server and breed.boss_template then
		self:_start_boss_template(breed.boss_template)
	end
end

BossExtension.game_object_initialized = function (self, session, object_id)
	local breed = self._breed

	if breed.boss_template then
		self:_start_boss_template(breed.boss_template)
	end

	local game_object_id = Managers.state.unit_spawner:game_object_id(self._unit)
	self._game_object_id = game_object_id
end

BossExtension.extensions_ready = function (self)
	local breed = self._breed

	if not breed.trigger_boss_health_bar_on_aggro and not breed.trigger_boss_health_bar_on_damaged and not breed.boss_health_bar_disabled then
		self:start_boss_encounter()
	end
end

BossExtension.hot_join_sync = function (self, unit, sender, channel_id)
	if self._boss_encounter_started then
		RPC.rpc_start_boss_encounter(channel_id, self._game_object_id)
	end
end

BossExtension.update = function (self, unit, dt, t)
	local boss_template = self._boss_template

	if boss_template then
		boss_template.update(self._template_data, self._template_context, dt, t)
	end

	if self._start_boss_encounter then
		Managers.event:trigger("boss_encounter_start", self._unit, self)

		self._boss_encounter_started = true
		self._start_boss_encounter = nil
	end
end

BossExtension.destroy = function (self)
	Managers.event:trigger("boss_encounter_end", self._unit, self)

	if self._boss_template then
		self._boss_template.stop(self._template_data, self._template_context)
	end
end

BossExtension.damaged = function (self)
	if self._first_damaged_at == nil then
		self._first_damaged_at = Managers.time:time("main")
		local breed = self._breed

		if breed.trigger_boss_health_bar_on_damaged and not breed.boss_health_bar_disabled then
			self:start_boss_encounter()

			if self._is_server then
				Managers.state.game_session:send_rpc_clients("rpc_start_boss_encounter", self._game_object_id)
			end
		end
	end
end

BossExtension.time_since_first_damage = function (self)
	if self._first_damaged_at ~= nil then
		return Managers.time:time("main") - self._first_damaged_at
	end

	return math.huge
end

BossExtension.start_boss_encounter = function (self)
	self._start_boss_encounter = true

	if self._is_server then
		Managers.telemetry_events:boss_encounter_started(self._breed.name)
	end
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

BossExtension._start_boss_template = function (self, boss_template)
	self._template_context = {
		is_server = self._is_server,
		world = self._world,
		wwise_world = self._wwise_world
	}
	self._template_data = {
		unit = self._unit
	}

	boss_template.start(self._template_data, self._template_context)

	self._boss_template = boss_template
end

return BossExtension
