local definition_path = "scripts/ui/constant_elements/elements/stay_in_party/constant_element_stay_in_party_definitions"
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ConstantElementBase = require("scripts/ui/constant_elements/constant_element_base")
local ConstantElementStayInParty = class("ConstantElementStayInParty", "ConstantElementBase")
local STAY_IN_PARTY = table.enum("YES", "NO")

ConstantElementStayInParty.init = function (self, parent, draw_layer, start_scale)
	local definitions = require(definition_path)

	ConstantElementBase.init(self, parent, draw_layer, start_scale, definitions)

	self._active = false

	Managers.event:register(self, "event_stay_in_party_voting_started", "_event_voting_started")
	Managers.event:register(self, "event_stay_in_party_voting_completed", "_event_voting_completed")
	Managers.event:register(self, "event_stay_in_party_voting_aborted", "_event_voting_aborted")
	Managers.event:register(self, "event_stay_in_party_vote_casted", "_event_vote_casted")

	self._stay_in_party = STAY_IN_PARTY.NO
end

ConstantElementStayInParty._event_voting_started = function (self, voting_id)
	if self._active then
		return
	end

	local all_is_same_party = self:_all_is_same_party()

	if all_is_same_party then
		Managers.voting:cast_vote(voting_id, "no")
		Log.info("STAY_IN_PARTY_VOTING", "everyone is same party, voting NO to merge")

		return
	end

	self._voting_id = voting_id
	self._active = true

	self:_sync_votes()
end

ConstantElementStayInParty._event_voting_completed = function (self)
	self._active = false
	self._voting_id = nil
end

ConstantElementStayInParty._event_voting_aborted = function (self)
	self._active = false
	self._voting_id = nil
end

ConstantElementStayInParty._event_vote_casted = function (self)
	if not self._active then
		return
	end

	self:_sync_votes()
end

ConstantElementStayInParty._all_is_same_party = function (self)
	local human_players = Managers.player:human_players()
	local num_human_players = table.size(human_players)
	local party_manager = Managers.party_immaterium
	local num_party_members = party_manager:num_party_members_in_mission()
	local all_is_same_party = num_party_members == num_human_players

	return all_is_same_party
end

ConstantElementStayInParty._sync_votes = function (self)
	local voting_id = self._voting_id
	local votes = Managers.voting:votes(voting_id)
	local local_player_peer_id = Network.peer_id()
	local num_votes = 0
	local yes_votes = 0
	local player_voted_yes = false

	for peer_id, vote in pairs(votes) do
		if vote == "yes" then
			yes_votes = yes_votes + 1

			if peer_id == local_player_peer_id then
				player_voted_yes = true
			end
		end

		num_votes = num_votes + 1
	end

	local num_votes_text = yes_votes .. "/" .. num_votes
	local text_widget = self._widgets_by_name.vote_count_text
	text_widget.content.text = num_votes_text
	local all_voted_yes = yes_votes == num_votes
	local rect_color, text_color = nil

	if all_voted_yes then
		rect_color = "pale_golden_rod"
		text_color = "black"
	elseif player_voted_yes then
		rect_color = "white"
		text_color = "black"
	else
		rect_color = "black"
		text_color = "white"
	end

	local vote_count_rect_widget = self._widgets_by_name.vote_count_rect
	vote_count_rect_widget.style.frame.color = Color[rect_color](255, true)
	text_widget.style.style_id_1.text_color = Color[text_color](255, true)
end

ConstantElementStayInParty.destroy = function (self)
	Managers.event:unregister(self, "event_stay_in_party_voting_started")
	Managers.event:unregister(self, "event_stay_in_party_voting_completed")
	Managers.event:unregister(self, "event_stay_in_party_voting_aborted")
	Managers.event:unregister(self, "event_stay_in_party_vote_casted")
	ConstantElementBase.destroy(self)
end

ConstantElementStayInParty._setup_input_legend = function (self)
	self._render_scale = Managers.ui:view_render_scale()
	local parent = self
	local draw_layer = 10
	local scale = RESOLUTION_LOOKUP.scale
	self._input_legend_element = ViewElementInputLegend:new(parent, draw_layer, scale)

	self._input_legend_element:set_render_scale(self._render_scale)

	local legend_inputs = self._definitions.legend_inputs
	local input_legends_by_key = {}

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)
		local id = self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
		local key = legend_input.key

		if key then
			input_legends_by_key[key] = {
				id = id,
				settings = legend_input
			}
		end
	end

	self._input_legends_by_key = input_legends_by_key
end

ConstantElementStayInParty.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self._active then
		if GameParameters.prod_like_backend then
			local active_party_vote = Managers.party_immaterium:active_stay_in_party_vote()

			if active_party_vote then
				self:_voting_started(active_party_vote.voting_id)
			end
		end

		return
	end

	if not self._setup_done then
		self:_setup_input_legend()

		self._setup_done = true
	end

	self:_update_num_voters()
	self:_update_warning_text()
	self._input_legend_element:update(dt, t, input_service)
	ConstantElementBase.update(self, dt, t, ui_renderer, render_settings, input_service)
end

ConstantElementStayInParty._update_num_voters = function (self)
	self:_sync_votes()
end

ConstantElementStayInParty._update_warning_text = function (self)
	local party_manager = Managers.party_immaterium
	local all_party_members_in_mission = party_manager:are_all_members_in_mission()
	local party_member_not_in_mission = not all_party_members_in_mission
	local warning_text_widget = self._widgets_by_name.warning_text
	warning_text_widget.content.visible = party_member_not_in_mission
end

ConstantElementStayInParty._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ConstantElementBase._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

ConstantElementStayInParty.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self._active then
		return
	end

	self._input_legend_element:draw(dt, t, ui_renderer, render_settings, input_service)
	ConstantElementBase.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

ConstantElementStayInParty.cb_on_stay_in_party_pressed = function (self)
	local input_legends_by_key = self._input_legends_by_key
	local input_legend = input_legends_by_key.stay_in_party
	local input_id = input_legend.id
	local vote_count_rect_widget = self._widgets_by_name.vote_count_rect
	local voting_id = self._voting_id

	if self._stay_in_party == STAY_IN_PARTY.NO then
		self._input_legend_element:set_display_name(input_id, "loc_eor_stay_in_party_no")

		self._stay_in_party = STAY_IN_PARTY.YES
		vote_count_rect_widget.style.frame.color = Color.pale_golden_rod(255, true)

		Managers.voting:cast_vote(voting_id, "yes")
	elseif self._stay_in_party == STAY_IN_PARTY.YES then
		self._input_legend_element:set_display_name(input_id, "loc_eor_stay_in_party_yes")

		self._stay_in_party = STAY_IN_PARTY.NO
		vote_count_rect_widget.style.frame.color = Color.black(255, true)

		Managers.voting:cast_vote(voting_id, "no")
	end
end

return ConstantElementStayInParty
