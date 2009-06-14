function clear_cache(id) {
	var handler = dojo.xhrGet({
		url: '/admin/clear/' + id,
		content: { field: null }
	});
	handler.addCallback(function(data) {
	    dojo.byId('jaxdate').innerHTML="Cleared Cache";
	});
}

function clear_cache_page(id) {
	var handler = dojo.xhrGet({
		url: '/admin/clear_page/' + id,
		content: { field: null }
	});
	handler.addCallback(function(data) {
	    dojo.byId('jaxdate').innerHTML="Cleared Cache";
	});
}

function help_complete_combobox(field,db_table,db_field) {
	var handler = dojo.xhrGet({
		url: '/ajax/help_complete_combobox/'+db_table+'/'+db_field,
		mimetype: "text/json",
		content: { field: field.getValue() } 
	});
	handler.addCallback(function(data) {
	    field.dataProvider.setData(data['result']);
	});
}

function sort_tags(field) {
	var handler = dojo.xhrGet({
		url: '/ajax/sort_by',
		content: { field: field.id }
	});
	handler.addCallback(function(data) {
	    dojo.byId('tag_list').innerHTML=data;
	});
}

function toggle_tag_list() {
    dojo.connect(
		dojo.byId("alpha"), "onclick" , function (e) { 
			e.preventDefault(); 
			dojo.byId("alpha").className="selected";
			dojo.byId("freq").className="";
			sort_tags(dojo.byId("alpha"));  
			}
	);
	dojo.connect(
		dojo.byId("freq"), "onclick" , function (e) { 
			e.preventDefault(); 
			dojo.byId("alpha").className="";
			dojo.byId("freq").className="selected";
			sort_tags(dojo.byId("freq")); 
			 }
	);
}

function switch_editor(what) {
	if(what == 'wysiwyg') {
		dojo.widget.createWidget("Editor2", 
			{ 	shareToolbar: false, 
				toolbarAlwaysVisible: true,
				height: "90%",
				width: "800",
				focusOnLoad: false 
			}, dojo.byId("body"));
			dojo.byId("pborder").style.border="1px solid";
	}
	else {
		var value="";
		dojo.forEach(dojo.widget.byType('Editor2'), 
			function(e) { value= e.getEditorContent(); });
			
		dojo.forEach(dojo.widget.byType('Editor2'), 
			function(e){ e.destroy(); });
		dojo.byId('body').value=value;
		dojo.byId("pborder").style.border="";
	}
}

function toggle_tags() {
	if( dojo.byId("select_tags").style.display=="none" ) {
		dojo.byId("select_tags").style.display="block";
	}
	else {
		dojo.byId("select_tags").style.display="none";
	}
}

function check_articles(field) {
	if ((field.value.length > 0 && field.value.length < 3) || field.value.length==0 ) {
		dojo.byId('search_board').style.display="none";
		return;
	}
	var handler = dojo.xhrGet({
		url: '/ajax/check_articles',
		content: { field: field.value }
	});
	handler.addCallback(function(data) {
	    dojo.byId('search_board').style.display="block";
		dojo.byId('search_board').innerHTML=data;
	});
}
