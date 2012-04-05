(function(){
	// on each sentence mouse over, highlight the sentence
	// a caption is shown on bottom right 'click to select/unselect sentence to be included in summary
	// on click selection: if sentence is selected it becomes bold and background color of corresponding sentences in each summary becomes red based upon their truth value

	var sentences_class       = ".eval-sen";

	var hover_selected_highlight_class = "hover-selected-highlight";
	var hover_unselected_highlight_class = "hover-unselected-highlight";
	var click_highlight_class = "click-highlight";
	var wrong_highlight_class = "wrong-highlight";
	var important_highlight_class = "important-highlight";

	var rails_highlight_class = "highlight";

	var click_to_add_suggestion_msg    = "click to select sentence to be included in summary";
	var click_to_remove_suggestion_msg = "click to remove sentence from the summary";

	var summary_evaluator = function(){
		this.init();

	}

	summary_evaluator.prototype.init = function(){
		console.log('in init');
		//set internal state vars

		//attach events
		this.attach_events();
	}

	summary_evaluator.prototype.attach_events = function(){
		var that = this;
		//attach hover event
		$(sentences_class).live("hover",that.handle_in_out_event);

		//attach click event
		$(sentences_class).live("click",that.handle_click_event);

		//apply tooltip events
		//that.apply_tooltip();
	}

	summary_evaluator.prototype.handle_in_out_event = function(){
		console.log('in inout');
		var sentence = $(this), sen_id_to_match = sentence.attr("sen_id"), corresponding_sentences = $(sentences_class).filter(function(index){
			return $(this).attr("sen_id") == sen_id_to_match;
		});

		var suggestion_message = (sentence.hasClass(click_highlight_class))? click_to_remove_suggestion_msg : click_to_add_suggestion_msg;
		//if not highlighted then highlight
		if(sentence.hasClass(hover_selected_highlight_class) || sentence.hasClass(hover_unselected_highlight_class)){
			corresponding_sentences.removeClass(hover_selected_highlight_class).removeClass(hover_unselected_highlight_class);
		}else{
			corresponding_sentences.each(function(index){
				($(this).hasClass(rails_highlight_class))? $(this).addClass(hover_selected_highlight_class) : $(this).addClass(hover_unselected_highlight_class);
			});
		}

		//show suggestion_message
	}

	summary_evaluator.prototype.handle_click_event = function(){
		var that = this;
		var sentence = $(this), sen_id = sentence.attr("sen_id"), corresponding_sentences = $(".user-summary").filter(function(index){
			return $(this).attr("sen_id") == sen_id;
		});
		
		sen_imp = sentence.attr("importance");
		if( sen_imp == '1' ){
			if( sentence.hasClass(rails_highlight_class) ){
				sentence.addClass(wrong_highlight_class);
				corresponding_sentences.addClass(wrong_highlight_class);
				sentence.attr("importance", "-1");
				$("#sentences__"+sen_id).val("-1");
			}else{
				sentence.removeClass(important_highlight_class);
				corresponding_sentences.removeClass(important_highlight_class);
				sentence.attr("importance", "0");
				$("#sentences__"+sen_id).val("0");
			}
		}
		else if( sen_imp == '-1' ){
			sentence.removeClass(wrong_highlight_class);
			corresponding_sentences.removeClass(wrong_highlight_class);
			sentence.attr("importance", "1");
			$("#sentences__"+sen_id).val("1");
		}
		else{
			sentence.addClass(important_highlight_class);
			corresponding_sentences.addClass(important_highlight_class);
			sentence.attr("importance", "1");
			$("#sentences__"+sen_id).val("1");
		}

                var comment_id = sentence.attr("com_id");
                handle_comment_headers(comment_id);

        /*
		//if not highlighted then highlight
		if(sentence.hasClass(click_highlight_class)){
			sentence.removeClass(click_highlight_class).removeClass(wrong_highlight_class);
			corresponding_sentence.removeClass(click_highlight_class).removeClass(wrong_highlight_class);
		}else{
			var click_class_to_apply_to_sentence               = (sentence.hasClass(rails_highlight_class))? '' : wrong_highlight_class;
			var click_class_to_apply_to_corresponding_sentence = (corresponding_sentence.hasClass(rails_highlight_class))? '' : wrong_highlight_class;

			sentence.addClass(click_class_to_apply_to_sentence).addClass(click_highlight_class);
			corresponding_sentence.addClass(click_class_to_apply_to_corresponding_sentence).addClass(click_highlight_class);
		}
        */
	}

	summary_evaluator.prototype.apply_tooltip = function(){
		var imp_toggle = function(add_class,remove_class){
			var link_ele = $(this);
			var sen_id = link_ele.attr('sen_id');

			$('span[sen_id="'+sen_id+'"].eval-sen').addClass(add_class).removeClass(remove_class).removeClass('eval-begin').removeClass('cluetip-clicked').css('cursor','');
			
			$('#cluetip').hide();
		};

		$('.btn-imp-sen').live('click', function(){imp_toggle.apply(this,['imp-sen','non-imp-sen']);});
		$('.btn-non-imp-sen').live('click', function(){imp_toggle.apply(this,['non-imp-sen','imp-sen']);});

		$('.summaries .fix-height').bind('click scroll', function(){
			$('.eval-begin').removeClass('eval-begin').removeClass('cluetip-clicked').css('cursor','');
			$('#cluetip').hide();
		});
		

		$('.eval-sen').each(function(index,item){
			var ele = $(item);
			ele.cluetip(function(){
				return '<a href="javascript:void(0)" sen_id="'+ ele.attr('sen_id') +'" class="btn-imp-sen" title="click to mark as important"><img src="/assets/arrow_up_green.png" alt="important"/></a><span style="border: 1px solid;margin: 0px 10px;"></span><a href="javascript:void(0)" sen_id="'+ ele.attr('sen_id') +'" class="btn-non-imp-sen" title="click to mark as Unimportant"><img src="/assets/arrow_down_red.gif" alt="not important"/></a>';
			},{cluetipClass: 'rounded',
			   positionBy: 'bottomTop',
			   showTitle:false,
			   arrows: false,
			   dropShadow: false,
			   hoverIntent: false,
			   sticky: true,
			   activation: 'click',
			   topOffset:7,
			   leftOffset:0,
			   width: 72,
			   height: 'auto',
			   onShow: function(ct, c){
				   $('.eval-begin').removeClass('eval-begin').removeClass('cluetip-clicked').css('cursor','');
				   $('span[sen_id="'+ele.attr('sen_id')+'"].eval-sen').addClass('eval-begin');
			   },
			   onHide: function(ct, c){
				   $('span[sen_id="'+ele.attr('sen_id')+'"].eval-sen').removeClass('eval-begin');
			   }
			   /*
				 onShow: function(ct, c){
				 var offset = ele.offset();
				 var left = offset.left, top = offset.top;
				 var height = ele.height();

				 //$(ct).css("left",left+'px');
				 //$(ct).css("top",top+height+0+'px');
				 $(ct).css("top",top+15+'px');
				 }*/
			  });
		});
	}

	window.summary_eveluator = summary_evaluator;

})();

       function handle_comment_headers(comment_id) {
            // after every click, check if there are any other selected sentences
            // for the same comment. apply style to hide/show comment for user-summary
            var comment_sentences = $("[com_id=" + comment_id+"]");
            var highlighted_sentences = comment_sentences.filter(function(index) { 
                                                                     return (!$(this).hasClass("wrong-highlight")) &&
                                                                         $(this).hasClass("highlight") || 
                                                                         $(this).hasClass("important-highlight");
                                                                 });
            if (highlighted_sentences.length > 0) {
                $("#" + comment_id).addClass("show-header")
            }
            else {
                $("#" + comment_id).removeClass("show-header")
            }
         }



$(document).ready(function(){
	$(".radio-buttons").buttonset();

	var user_summary_evaluator = new summary_eveluator();
            
    var all_comments = $(".comment-header.user-summary");
    all_comments.each(function(index, c){ 
        return handle_comment_headers($(c).attr("id")); 
    });

	form_validator = $('.new_response,.edit_response').validate({
		rules:{
			'response[imp_points_incl_lex_sum]': "required",
			'response[imp_points_incl_email_sum]': "required",
			'response[redundancy_lex_sum]': "required",
			'response[redundancy_email_sum]': "required",
			'response[unnecessary_info_lex_sum]': "required",
			'response[unnecessary_info_email_sum]': "required",
			'response[coherence_lex_sum]': "required",
			'response[coherence_email_sum]': "required",
		},
		// the errorPlacement has to take the table layout into account 
        errorPlacement: function(error, element) { 
            if ( element.is(":radio") ){ 
                error.appendTo( element.parent() );
				error.addClass('alert alert-error');
				error.text('Please input your answer.');
			} 
        }
	});	
});


