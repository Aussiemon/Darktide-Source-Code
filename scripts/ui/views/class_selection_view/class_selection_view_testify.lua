local ClassSelectionViewTestify = {}

ClassSelectionViewTestify.class_selection_view_select_archetype = function (class_selection_view, archetype_id)
	local target_option = class_selection_view:archetype_options()[archetype_id]

	class_selection_view:on_domain_pressed(target_option)
	class_selection_view:on_choose_pressed()
	class_selection_view:on_choose_pressed()
end

return ClassSelectionViewTestify
