$(document).on('turbolinks:load', function() {
  $('#new-category').click(function(event) {
    event.preventDefault();
    create_category();
  });

  $('.update').click(function (event) {
    event.preventDefault();
    var id = $(this).attr('id');
    $('#edit-category-modal-' + id).modal();
    $('#update-category-'+id).click(function () {
      event.preventDefault();
      update_category(id);
    });
  });

  $('.del').click(function (event) {
    event.preventDefault();
    var id = $(this).attr('id');
    $.ajax({
      url: '/admin/categories/' + id,
      method: 'DELETE',
      success: function(){
        alert('Delete category successfully!');
        $('#category-'+id).remove();
      },
      error: function () {
        alert('Fail to delete category!')
      }
    });
  });

  function create_category() {
    var form_data = $('#new_category');
    $.ajax({
      type: 'POST',
      url: '/admin/categories',
      data: form_data.serialize(),
      dataType: 'html',
      success: function(resp) {
        alert('Create new category successfully!');
        $('#category_name').val('');
        $('#result_search').prepend(resp);
        if(current_elements_in_page() >= PER_PAGE){
          $('#result_search').children('tr').last().remove();
        }
        index_for();
        $('#new-category-modal').slideUp();
        $('.modal-backdrop').fadeOut();
      },
      error: function () {
        alert('Fail to create new category!');
      }
    })
  }

  function update_category(id){
    var form_data = $('#edit_category_'+id);
    $.ajax({
      type: 'PUT',
      url: '/admin/categories/'+id,
      data: form_data.serialize(),
      dataType: 'html',
      success: function(resp) {
        alert('Update category successfully!');
        $('#result_search').children('#category-'+id).replaceWith(resp);
        index_for();
        $('#edit-category-modal-'+id).slideUp();
        $('.modal-backdrop').fadeOut();
      },
      error: function () {
        alert('Fail to update category!');
      }
    })
  }
});
