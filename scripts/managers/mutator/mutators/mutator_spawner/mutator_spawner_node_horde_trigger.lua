-- chunkname: @scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_horde_trigger.lua

require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node")

local MutatorMonsterSpawnerNodeHordeTriger = class("MutatorMonsterSpawnerNodeHordeTriger", "MutatorSpawnerNode")

MutatorMonsterSpawnerNodeHordeTriger.init = function (self, template)
	MutatorMonsterSpawnerNodeHordeTriger.super.init(self, template)

	self._run_on_init = false
end

MutatorMonsterSpawnerNodeHordeTriger._do_spawn = function (self, spawn_position, ahead_target_unit)
	Managers.state.pacing:force_horde_pacing_spawn()
end

return MutatorMonsterSpawnerNodeHordeTriger
