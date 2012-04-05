$(document).ready(function(){
	$('#btn_preview_email').bind('click',function(){
		eb = $('#email_body').val();
		eb = eb.replace(/\n\r?/g,'<br>');
		es = $('#email_subject').val();
		// email_markers set on the page in inline javascript fron app_config file
		for(var marker in email_markers){
			console.log(marker);
			if(email_markers.hasOwnProperty(marker)){
				var re = new RegExp("\\["+marker+"\\]", "g");
				eb = eb.replace(re, email_markers[marker]);
				es = es.replace(re, email_markers[marker]);
			}
		}
		$('#email_preview').html("<b>Subject:</b> " + es + "<br><br><b>Message:</b> " + eb);
	});
});