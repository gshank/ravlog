
function toggle_tag_list() {
}

     
function sort_tags(field) {
   $.post('/ajax/sort_by',  {
		content: { field: field.id }
	});
}
