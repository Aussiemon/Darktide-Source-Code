-- chunkname: @scripts/ui/views/training_grounds_view/training_grounds_view.lua

require("scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base")

local Definitions = require("scripts/ui/views/training_grounds_view/training_grounds_view_definitions")
local TrainingGroundsView = class("TrainingGroundsView", "VendorInteractionViewBase")

TrainingGroundsView.init = function (self, settings, context)
	TrainingGroundsView.super.init(self, Definitions, settings, context)
end

TrainingGroundsView.on_enter = function (self)
	TrainingGroundsView.super.on_enter(self)

	local viewport_name = Definitions.background_world_params.viewport_name

	if self._world_spawner then
		self._world_spawner:set_listener(viewport_name)
	end

	self:play_vo_events({
		"hub_interact_training_ground_psyker",
	}, "training_ground_psyker_a", nil, 0.8, true)
end

TrainingGroundsView.on_exit = function (self)
	if self._world_spawner then
		self._world_spawner:release_listener()
	end

	TrainingGroundsView.super.on_exit(self)
end

return TrainingGroundsView
