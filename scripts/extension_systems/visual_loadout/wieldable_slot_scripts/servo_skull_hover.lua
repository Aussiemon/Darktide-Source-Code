local Action = require("scripts/utilities/weapon/action")
local ServoSkullHover = class("ServoSkullHover")
local LOOPING_PARTICLE_ALIAS = "equipped_item_passive"
local FX_SOURCE_NAME = "_antigrav"
local EXTERNAL_PROPERTIES = {}

ServoSkullHover.init = function (self, context, slot, weapon_template, fx_sources)
	self._world = context.world
	local fx_extension = context.fx_extension
	local visual_loadout_extension = context.visual_loadout_extension
	self._fx_extension = fx_extension
	self._visual_loadout_extension = visual_loadout_extension
	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._weapon_template = weapon_template
	self._weapon_actions = weapon_template.actions
	local fx_source_name = fx_sources[FX_SOURCE_NAME]
	self._fx_source_name = fx_source_name
	self._vfx_link_unit, self._vfx_link_node = fx_extension:vfx_spawner_unit_and_node(fx_source_name)
	self._looping_effect_id = nil
end

ServoSkullHover.fixed_update = function (self, unit, dt, t, frame)
	return
end

ServoSkullHover.update = function (self, unit, dt, t)
	return
end

ServoSkullHover.update_first_person_mode = function (self, first_person_mode)
	return
end

ServoSkullHover.wield = function (self)
	self:_create_effects()
end

ServoSkullHover.unwield = function (self)
	self:_destroy_effects()
end

ServoSkullHover.destroy = function (self)
	self:_destroy_effects()
end

ServoSkullHover._create_effects = function (self)
	local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(LOOPING_PARTICLE_ALIAS, EXTERNAL_PROPERTIES)

	if resolved then
		local world = self._world
		local effect_id = World.create_particles(world, effect_name, Vector3.zero())
		local pose = Matrix4x4.from_translation(Vector3.down() * 0.15)

		World.link_particles(world, effect_id, self._vfx_link_unit, self._vfx_link_node, pose, "stop")

		self._looping_effect_id = effect_id
	end
end

ServoSkullHover._destroy_effects = function (self)
	if self._looping_effect_id then
		World.destroy_particles(self._world, self._looping_effect_id)

		self._looping_effect_id = nil
	end
end

return ServoSkullHover
