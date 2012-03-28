$(document).ready(function(){
	console.log('in here');
	$('#btn_preview_email').bind('click',function(){
		console.log('in preview email');
		eb = $('#email_body').val();
		eb = eb.replace(/\n\r?/g,'<br>');
		eb = eb.replace(/\[user_name\]/g,'Mark Ward');
		eb = eb.replace(/\[experiment_title\]/g,'Bug Summary Evaluation');
		eb = eb.replace(/\[experiment_start_date\]/g,'03/24/2012');
		eb = eb.replace(/\[experiment_start_time\]/g,'01:00 PM');
		eb = eb.replace(/\[experiment_end_date\]/g,'04/04/2012');
		eb = eb.replace(/\[experiment_end_time\]/g,'05:00 PM');
		eb = eb.replace(/\[bug_report_id\]/g,'34546');
		eb = eb.replace(/\[bug_report_title\]/g,'FTBFS: gcc-4.0 got ICE when compiling glibc 2.3.5-2 in experimental on m68k');
		eb = eb.replace(/\[summary_link\]/g,'http://lebu.uwaterloo.ca/survey/286_43adc7d8fbbfaf04-1457/access#');
		$('#email_preview').html(eb);
	});
});