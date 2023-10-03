local BakedPhysics = component("BakedPhysics")

BakedPhysics.editor_init = function (self, unit)
	return
end

BakedPhysics.editor_validate = function (self, unit)
	return true, ""
end

BakedPhysics.editor_reset_physics = function (self, unit)
	self:enable_actors(unit)
end

BakedPhysics.enable_actors = function (self, unit)
	local num_actors = Unit.num_actors(unit)

	for i = 1, Unit.num_actors(unit) do
		Unit.create_actor(unit, i, false)
		Actor.put_to_sleep(Unit.actor(unit, i))
	end
end

BakedPhysics.init = function (self, unit)
	self:enable(unit)

	if Unit.has_data(unit, "dynamic_ingame") and Unit.get_data(unit, "dynamic_ingame") then
		self:enable_actors(unit)
	end
end

BakedPhysics.enable = function (self, unit)
	Unit.set_visibility(unit, "picking", false)
end

BakedPhysics.disable = function (self, unit)
	return
end

BakedPhysics.destroy = function (self, unit)
	return
end

BakedPhysics.component_config = {
	disable_event_public = false,
	enable_event_public = false,
	starts_enabled_default = true
}

return BakedPhysics
