local ClassSelectionViewTestify = {}

ClassSelectionViewTestify.class_selection_view_select_archetype = function (class_selection_view, archetype_id)
	local wanted_archetype = class_selection_view:archetype_options()[archetype_id]

	class_selection_view:on_archetype_pressed(wanted_archetype)
	class_selection_view:on_continue_pressed(wanted_archetype)
	class_selection_view:on_continue_pressed(wanted_archetype)
end

return ClassSelectionViewTestify
