function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp('new_' + association, 'g');
  var answers = $('#answer-pnl').children('#answer-form');
  if(answers.length < 4) {
    $(link).parent().parent().children().last().after(content.replace(regexp, new_id));
  }
  else {
    alert(I18n.t('only_4'));
  }
}

function remove_fields(link) {
  var answers = $(link).parent().parent().parent().children('#answer-form');
  if(answers.length > 2){
    $(link).prev().val('true');
    $(link).closest('.form-group').remove();
  }
  else{
    alert(I18n.t('answer_not_less_2'));
  }
}
