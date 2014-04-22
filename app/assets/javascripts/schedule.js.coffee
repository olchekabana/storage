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
  
  block_fade_out = (block) ->
    dfd = $.Deferred()
    block.fadeOut(350, dfd.resolve)
    return dfd.promise()
  
  $('.content-item').on('click', '.submit'
    ->
      id = $(this).attr('data-id')
      if $('#task_result_'+id).val().trim() != ''
        $('#confirm').arcticmodal({
          afterClose: (data, el) -> $('#confirm').removeAttr('data-id')
        })
        $('#confirm').attr('data-id', id)
      else
        content = $("#errors").data("empty")
        $(".tooltip").remove()
        x = $(this).innerWidth()/2 + $(this).offset().left
        y = $(this).offset().top
        tooltip = jQuery(document.createElement('div'))
          .addClass("tooltip")
          .text(content)
          .appendTo("body")
          .css({'max-width': '250px', 'text-align': 'center'})
        x -= tooltip.innerWidth()/2
        y -= tooltip.outerHeight()+10
        
        tooltip.css({'top': y+'px', 'left': x+'px'}).fadeIn(300).delay(3000)
        block_fade_out(tooltip).done(
          ->
            $(".tooltip").remove()
        )
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
