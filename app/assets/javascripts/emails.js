$(document).ready(function(){
	console.log('in here');
	$('#btn_preview_email').bind('click',function(){
		console.log('in preview email');
		eb = $('#email_body').val();
		eb = eb.replace(/\n\r?/g,'<br>');
		// email_markers set on the page in inline javascript fron app_config file
		for(var marker in email_markers){
			console.log(marker);
			if(email_markers.hasOwnProperty(marker)){
				var re = new RegExp("\\["+marker+"\\]", "g");
				eb = eb.replace(re, email_markers[marker]);
			}
		}
		$('#email_preview').html(eb);
	});
});