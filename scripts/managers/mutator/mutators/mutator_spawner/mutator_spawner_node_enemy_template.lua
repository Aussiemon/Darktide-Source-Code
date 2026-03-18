-- chunkname: @scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_enemy_template.lua

require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node")

local MonsterInjectionTemplates = require("scripts/settings/mutator/mutator_monster_spawner_injection/mutator_monster_spawner_injection_templates")
local MutatorSpawnerNodeEnemyTemplate = class("MutatorSpawnerNodeEnemyTemplate", "MutatorSpawnerNode")

MutatorSpawnerNodeEnemyTemplate.init = function (self, template)
	MutatorSpawnerNodeEnemyTemplate.super.init(self, template)

	self._run_on_init = false
	self._enemy_placement_method = template.enemy_placement_method
	self._composition = template.composition
	self._force_horde = template.force_horde_on_spawn

	local injection_template_settings = template.injection_template_settings

	if injection_template_settings then
		local injection_template_name = injection_template_settings.name

		self._injection_template_settings = injection_template_settings
		self._injection_template = MonsterInjectionTemplates[injection_template_name]
	end
end

MutatorSpawnerNodeEnemyTemplate._do_spawn = function (self, spawn_position, ahead_target_unit)
	if self._injection_template then
		self._injection_template:spawn(spawn_position, ahead_target_unit, 2)

		return
	end

	if self._force_horde then
		Managers.state.pacing:force_horde_pacing_spawn()
	end

	local nav_mesh_manager = Managers.state.nav_mesh
	local nav_world = nav_mesh_manager:nav_world()
	local breed_data = {}
	local composition = self._composition
	local current_faction = Managers.state.pacing:current_faction()
	local faction_composition = composition[current_faction]
	local resistance_scaled_composition = Managers.state.difficulty:get_table_entry_by_resistance(faction_composition[1])

	for i = 1, #resistance_scaled_composition.breeds do
		local current_breed_data = resistance_scaled_composition.breeds[i]
		local amount_to_spawn = math.random(current_breed_data.amount[1], current_breed_data.amount[2])

		for ii = 1, amount_to_spawn do
			breed_data[#breed_data + 1] = current_breed_data.name
		end
	end

	local placement_settings = {
		position_offset = 4,
		num_slots = #breed_data,
	}
	local spawn_locations = self._enemy_placement_method(nav_world, Vector3Box(spawn_position), placement_settings, nil, MutatorSpawnerNodeEnemyTemplate.super:placement_logic_functions())
	local want_to_spawn = #breed_data

	if want_to_spawn <= #spawn_locations then
		table.shuffle(breed_data)
	end

	for i = 1, #spawn_locations do
		local spawn_data = spawn_locations[i]
		local minion_spawn_manager = Managers.state.minion_spawn
		local param_table = minion_spawn_manager:request_param_table()

		param_table.optional_aggro_state = "passive"

		minion_spawn_manager:spawn_minion(breed_data[i], spawn_data.position:unbox(), spawn_data.rotation:unbox(), 2, param_table)

		want_to_spawn = want_to_spawn - 1
	end
end

return MutatorSpawnerNodeEnemyTemplate
