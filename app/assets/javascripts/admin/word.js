$(document).on('turbolinks:load', function() {
  $(document).on('click', '#new-word', function (event) {
    event.preventDefault();
    var form_data = $('#new_word');
    $.ajax({
      type: 'POST',
      url: '/admin/words',
      data: form_data.serialize(),
      dataType: 'html',
      success: function(resp) {
        if($(resp).filter('#error_explanation').length){
          $('#error_explanation').remove();
          $('#main-content').prepend(resp);
        } else {
          alert(I18n.t('admin.words.word.success'));
          $('#main-content').find('#error_explanation').slideUp();
          $('#answer-pnl').find('.answer_field').children('input').val('');
          $('#word_content').val('');
          $('#result_search').prepend(resp);
          if (current_elements_in_page() >= PER_PAGE) {
            $('#result_search').children('tr').last().remove();
          }
          index_for();
        }
        $('#new-word-modal').slideUp();
        $('.modal-backdrop').fadeOut();
      },
      error: function () {
        alert(I18n.t('admin.words.word.warning'));
      }
    })
  });

  $(document).on('click', '.update-word', function (event) {
    event.preventDefault();
    var id = $(this).attr('id');
    $('#edit-word-modal-' + id).modal();
    $('#update-word-' + id).click(function () {
      event.preventDefault();
      var form_data = $('#edit_word_'+id);
      $.ajax({
        type: 'PUT',
        url: '/admin/words/'+id,
        data: form_data.serialize(),
        dataType: 'html',
        success: function(resp) {
          if($(resp).filter('#error_explanation').length){
            $('#error_explanation').remove();
            $('#main-content').prepend(resp);
          } else {
            alert(I18n.t('admin.words.word.update.success'));
            $('#main-content').find('#error_explanation').slideUp();
            $('#result_search').children('#word-' + id).replaceWith(resp);
            index_for();
          }
          $('#edit-word-modal-' + id).slideUp();
          $('.modal-backdrop').fadeOut();
        },
        error: function () {
          alert(I18n.t('admin.words.word.update.danger'));
        }
      })
    });
  });

  $(document).on('click', '.del-word', function (event) {
    event.preventDefault();
    var id = $(this).attr('id');
    var content = $('#word-' + id).children('td').eq(1).text().trim();
    if (confirm("Delete category " + content + " ?")) {
      $.ajax({
        url: '/admin/words/' + id,
        method: 'DELETE',
        success: function () {
          alert(I18n.t('admin.words.word.destroy.success'));
          $('#word-' + id).remove();
          index_for();
        },
        error: function () {
          alert(I18n.t('admin.words.word.destroy.danger'))
        }
      });
    }
  });
});
