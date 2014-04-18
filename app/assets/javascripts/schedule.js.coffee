# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->  
  
  # Туггл формы для отправки отчета о работе
  $('.content-item').on('click', '.report'
    ->
     $(this).prev().slideToggle(350)
     submit = $(this).next()
     data_hide = $(this).attr('data-hide')
     data_show = $(this).attr('data-show')
     if !$(this).attr('data-toggled') || $(this).attr('data-toggled') == "off"
       $(this).attr('data-toggled', 'on')
       $(this).html(data_hide)
       submit.fadeIn(350)
     else
       $(this).attr('data-toggled', 'off')
       $(this).html(data_show)
       submit.fadeOut(350)
  )
  
  # Отправка формы с отчетом о работе
  #$('.content-item').on('submit', '.form'
    #->
     # if $(this).find('.set_status').val() == "false"
        #alert(1)
      #  $('#confirm').arcticmodal();
        
      #  return false
 # )
  
  $('.content-item').on('click', '.submit'
    ->
      $('#confirm').arcticmodal({
        afterClose: (data, el) -> $('#confirm').removeAttr('data-id')
      })
      $('#confirm').attr('data-id', $(this).attr('data-id'))
  )
  
  $('#cancel').click(
    ->
      $.arcticmodal('close')
  )
  
  $('#send').click(
    ->
      id = $('#confirm').attr('data-id')
      $.arcticmodal('close')
      $('#form_'+id).trigger('submit')
  )
