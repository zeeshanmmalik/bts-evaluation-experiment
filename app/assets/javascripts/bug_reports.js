(function(){
	// on each sentence mouse over, highlight the sentence
	// a caption is shown on bottom right 'click to select/unselect sentence to be included in summary
	// on click selection: if sentence is selected it becomes bold and background color of corresponding sentences in each summary becomes red based upon their truth value

	var sentences_class       = ".eval-sen";

	var hover_highlight_class = "hover-highlight";
	var click_highlight_class = "click-highlight";
	var wrong_highlight_class = "wrong-highlight";

	var rails_highlight_class = "highlight";

	var click_to_add_suggestion_msg    = "click to select sentence to be included in summary";
	var click_to_remove_suggestion_msg = "click to remove sentence from the summary";

	var summary_evaluator = function(){
		this.init();

	}

	summary_evaluator.prototype.init = function(){
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


	summary_evaluator.prototype.handle_in_out_event = function(event){
		var sentence = $(this), sen_id_to_match = sentence.attr("sen_id"), corresponding_sentences = $(sentences_class).filter(function(index){
			return $(this).attr("sen_id") == sen_id_to_match;
		});

		var suggestion_message = (sentence.hasClass(click_highlight_class))? click_to_remove_suggestion_msg : click_to_add_suggestion_msg;
		//if not highlighted then highlight
		if(sentence.hasClass(hover_highlight_class)){
			corresponding_sentences.removeClass(hover_highlight_class);
		}else{
			corresponding_sentences.addClass(hover_highlight_class);
		}

		//show suggestion_message


	}

	summary_evaluator.prototype.handle_click_event = function(event){
		var that = this;
		var sentence = $(this), sen_id_to_match = sentence.attr("sen_id"), corresponding_sentence = $(sentences_class).filter(function(index){
			return $(this).attr("sen_id") == sen_id_to_match && that != this;
		});

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
	}

	window.summary_eveluator = summary_evaluator;

})();


$(document).ready(function(){
	$(".radio-buttons").buttonset();

	var user_summary_evaluator = new summary_eveluator();

});