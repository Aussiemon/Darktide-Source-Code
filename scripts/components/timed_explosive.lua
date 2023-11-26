-- chunkname: @scripts/components/timed_explosive.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local TimedExplosivesSettings = require("scripts/settings/timed_explosives/timed_explosives_settings")
local TimedExplosive = component("TimedExplosive")

TimedExplosive.init = function (self, unit, is_server)
	self._is_server = is_server
	self._unit = unit
	self._power_level = self:get_data(unit, "power_level")
	self._charge_level = self:get_data(unit, "charge_level")

	local setting_name = self:get_data(unit, "setting_name")
	local settings = TimedExplosivesSettings[setting_name]

	self._fuse_time = settings.fuse_time or self:get_data(unit, "fuse_time")
	self._fuse_timer = nil
	self._exploded = false

	local start_timer_on_spawn = self:get_data(unit, "start_timer_on_spawn")

	if start_timer_on_spawn then
		self:_start_timer()
	end

	self._explosion_template = ExplosionTemplates[settings.explosion_template_name]

	local world = Managers.world:world("level_world")

	self._world = world

	local physics_world = World.physics_world(world)

	self._physics_world = physics_world

	local wwise_world = Managers.world:wwise_world(world)

	self._wwise_world = wwise_world

	local manual_source = WwiseWorld.make_manual_source(wwise_world, unit, 1)

	self._source_id = manual_source

	local start_sound_event = settings.start_sound_event

	if start_sound_event then
		self:_play_sfx(start_sound_event)
	end

	local stop_sound_event_time = settings.stop_sound_event_time

	self._stop_sound_event_time = stop_sound_event_time

	local stop_sound_event = settings.stop_sound_event

	self._stop_sound_event = stop_sound_event

	local start_flow_event = settings.start_flow_event

	if start_flow_event then
		Unit.flow_event(unit, start_flow_event)
	end

	local run_update = true

	return run_update
end

TimedExplosive.editor_init = function (self, unit)
	return
end

TimedExplosive.editor_validate = function (self, unit)
	return true, ""
end

TimedExplosive._play_sfx = function (self, event)
	local wwise_world = self._wwise_world

	WwiseWorld.trigger_resource_event(wwise_world, event, self._source_id)
end

TimedExplosive._start_timer = function (self)
	self._fuse_timer = self._fuse_time
end

TimedExplosive._stop_timer = function (self)
	self._fuse_timer = nil
end

TimedExplosive._update_timer = function (self, dt)
	local fuse_timer = self._fuse_timer

	fuse_timer = fuse_timer - dt
	self._fuse_timer = math.max(fuse_timer, 0)
end

TimedExplosive._is_timer_started = function (self)
	return self._fuse_timer ~= nil
end

TimedExplosive.update = function (self, unit, dt, t)
	local stop_sound_event_time = self._stop_sound_event_time

	if stop_sound_event_time then
		stop_sound_event_time = stop_sound_event_time - dt

		if stop_sound_event_time <= 0 then
			self:_play_sfx(self._stop_sound_event)

			self._stop_sound_event_time = nil
			self._source_id = nil
		else
			self._stop_sound_event_time = stop_sound_event_time
		end
	end

	if self:_is_timer_started() then
		self:_update_timer(dt)

		if self._fuse_timer == 0 then
			self:_stop_timer()

			if self._is_server then
				self:_create_explosion()
			end

			local destructible_extension = ScriptUnit.has_extension(unit, "destructible_system")

			if destructible_extension == nil then
				Managers.state.unit_spawner:mark_for_deletion(unit)
			end
		end
	end

	return true
end

TimedExplosive.events.add_damage = function (self, damage, hit_actor, attack_direction)
	if not self:_is_timer_started() then
		self:_start_timer()
	end
end

TimedExplosive._create_explosion = function (self)
	if not self._exploded then
		local attack_type = AttackSettings.attack_types.explosion
		local unit = self._unit
		local explosion_position = Unit.local_position(unit, 1)
		local power_level = self._power_level
		local charge_level = self._charge_level

		self._exploded = true

		Explosion.create_explosion(self._world, self._physics_world, explosion_position, Vector3.up(), unit, self._explosion_template, power_level, charge_level, attack_type)
	end
end

TimedExplosive.enable = function (self, unit)
	return
end

TimedExplosive.disable = function (self, unit)
	return
end

TimedExplosive.destroy = function (self, unit)
	local source_id = self._source_id

	if source_id then
		WwiseWorld.destroy_manual_source(self._wwise_world, source_id)
	end
end

TimedExplosive.start_timer = function (self)
	self:_start_timer()
end

TimedExplosive.component_data = {
	start_timer_on_spawn = {
		ui_type = "check_box",
		value = true,
		ui_name = "Start timer on Spawn"
	},
	setting_name = {
		value = "explosive_barrel",
		ui_type = "combo_box",
		ui_name = "Setting Name",
		options_keys = {
			"explosive_barrel",
			"explosive_luggable"
		},
		options_values = {
			"explosive_barrel",
			"explosive_luggable"
		}
	},
	power_level = {
		ui_type = "number",
		decimals = 0,
		value = 1000,
		ui_name = "Power Level",
		step = 1
	},
	charge_level = {
		ui_type = "number",
		decimals = 0,
		value = 1,
		ui_name = "Charge Level",
		step = 1
	},
	fuse_time = {
		ui_type = "number",
		decimals = 1,
		value = 5,
		ui_name = "Fuse Time (in sec.)",
		step = 0.1
	},
	inputs = {
		start_timer = {
			accessibility = "public",
			type = "event"
		}
	}
}

return TimedExplosive
