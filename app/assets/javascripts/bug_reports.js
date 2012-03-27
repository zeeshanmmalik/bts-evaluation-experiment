(function(){
	// on each sentence mouse over, highlight the sentence
	// a caption is shown on bottom right 'click to select/unselect sentence to be included in summary
	// on click selection: if sentence is selected it becomes bold and background color of corresponding sentences in each summary becomes red based upon their truth value

	var sentences_class       = ".eval-sen";

	var hover_selected_highlight_class = "hover-selected-highlight";
	var hover_unselected_highlight_class = "hover-unselected-highlight";
	var click_highlight_class = "click-highlight";
	var wrong_highlight_class = "wrong-highlight";

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
				($(this).hasClass('highlight'))? $(this).addClass(hover_selected_highlight_class) : $(this).addClass(hover_unselected_highlight_class);
			});
		}

		//show suggestion_message


	}

	summary_evaluator.prototype.handle_click_event = function(){
		var that = this;
		var sentence = $(this), sen_id_to_match = sentence.attr("sen_id"), corresponding_sentence = $(sentences_class).filter(function(index){
			return $(this).attr("sen_id") == sen_id_to_match && that != this;
		});

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

	window.summary_eveluator = summary_evaluator;

})();


$(document).ready(function(){
	$(".radio-buttons").buttonset();

	var user_summary_evaluator = new summary_eveluator();
	var imp_toggle = function(add_class,remove_class){
		var link_ele = $(this);
		var sen_id = link_ele.attr('sen_id');

		$('span[sen_id="'+sen_id+'"].eval-sen').addClass(add_class).removeClass(remove_class).removeClass('eval-begin');
		
		$('#cluetip').hide();
	};

	$('.btn-imp-sen').live('click', function(){imp_toggle.apply(this,['imp-sen','non-imp-sen']);});
	$('.btn-non-imp-sen').live('click', function(){imp_toggle.apply(this,['non-imp-sen','imp-sen']);});

	$('.summaries .fix-height').bind('click scroll', function(){
		$('.eval-begin').removeClass('eval-begin');
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
			   $('.eval-begin').removeClass('eval-begin');
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


});