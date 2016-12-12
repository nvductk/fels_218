// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

var PER_PAGE = 5;
function index_for(){
  var index = PER_PAGE * (current_page() - 1) + 1;
  var tr_result = $('#result_search').children('tr');
  $.each(tr_result,function(id,val){
    val = $(val);
    val.children('td').first().html(index);
    index++;
  });
}

function current_elements_in_page() {
  return $('#result_search').children('tr').length;
}

$(document).on('turbolinks:load', function() {
  index_for();
  console.log(index_for());
});

function current_page(){
  if($('.pagination').length){
    var li_paginate = $('.pagination').children('li');
    var result;
    $.each(li_paginate, function(index,value){
      value = $(value);
      if(value.hasClass('active')){
        result = parseInt(value.children('a').first().html(),10);
        return result;
      }
    });
    return result;
  } else {
    return 1;
  }
}
