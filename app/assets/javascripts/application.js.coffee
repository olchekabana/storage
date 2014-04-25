//= require jquery
//= require jquery_ujs
//= require jquery.arcticmodal
//= require trip.min

$ ->
	$.arcticmodal('setDefault', {closeOnOverlayClick: false})
	
	trip_block = $(".trip")
	trip = new Trip([
	   { 
		   sel : $('#step1'),
		   position : 's',
		   delay: -1,
		   content : trip_block.data('step1')
	   },
	   {
		   sel : $('#step2'),
		   position : 's',
		   delay: -1,
		   content : trip_block.data('step2')
	   },
	   {
		   sel : $('#step3'),
		   position : 's',
		   delay: -1,
		   content : trip_block.data('step3')
	   },
	   {
		   sel : $('#step4'),
		   position : 'e',
		   delay: -1,
		   content : trip_block.data('step4')
		   #callback: -> unless $('.content-item:first h2:first').length>0 then doLastOperation()
	   },
	   {
		   sel : $('.content-item:first h2:first'),
		   position : 's',
		   delay: -1,
		   content : trip_block.data('step5')
		   #callback: -> unless $('.link:first').length>0 then trip.stop()
	   },
	   {
		   sel : $('.link:first'),
		   position : 'n',
		   delay: -1,
		   content : trip_block.data('step6')
		   #callback: -> unless $('.attachment:first').length>0 then trip.stop()
	   },
	   {
		   sel : $('.attachment:first'),
		   position : 'n',
		   delay: -1,
		   content : trip_block.data('step7')
	   }
	], {
			showNavigation: true,
			prevLabel: trip_block.data('prev'),
			nextLabel: trip_block.data('next'),
			finishLabel: trip_block.data('finish')
		})
	
	$('.hover').hover(
    ->
      block = $(this).find('.item')
      block.stop(true, true).css("opacity", "1").delay(50).fadeIn(350)
      
      #block.css('display', 'block')
      #block.delay(50).animate({opacity: 1.0, marginLeft: '0px'}, 700)  
    ->
      block = $(this).find('.item')
      #block.delay(50).clearQueue()

      block.stop(true, true).css("opacity", "1").delay(50).fadeOut(350)
      #hide_block(block).done(
      # ->
      #   block.css({'display':'none', 'opacity':'0', 'marginLeft':'40px'})
      #)
  )
  
  $('.sub-hover').hover(
    ->
      block = $(this).children('.item2')
      block.stop(true, true).fadeIn(300)
    ->
      block = $(this).children('.item2')
      block.stop(true, true).fadeOut(300)
  )
	
	# Сброс чекбоксов
	$('body').on('click', '.clear_check'
		->
			$('.modal-content').find('.icon-check').toggleClass("icon-check icon-check-empty")
			$('.modal-content').find('input:checked').prop("checked", false)
	)
	
	# Сабмит фильтра
	$('body').on('click', '.submit'
		->
			customers = ''
			managers = ''
			departments = ''
			$('.customers-box').find('input:checked').each(
				->
					customers += $(this).val() + ' '
			)
			customers = $.trim(customers)
			$('.managers-box').find('input:checked').each(
				->
					managers += $(this).val() + ' '
			)
			managers = $.trim(managers)
			$('.departments-box').find('input:checked').each(
				->
					departments += $(this).val() + ' '
			)
			departments = $.trim(departments)
			if customers is '' then $('#customers').prop('disabled', true) else $('#customers').val(customers)
			if managers is '' then $('#managers').prop('disabled', true) else $('#managers').val(managers)
			if departments is '' then $('#departments').prop('disabled', true) else $('#departments').val(departments)
			$('.modal-content').find(':checkbox').prop('disabled', true)
	)
	
	# эвент сабмита
	$('#search-form').submit(
		->
			search = $('#search')
			if search.val() == ''
				return false
	)
	
	# сабмит по кнопке
	$('.btn-search').click(
		->
			$('#search-form').submit()
	)
	
	$('#login').click(
		->
			$('#auth').arcticmodal()
	)

	$('.download').click(
		->
			box = $(this).parents('.files')
			param = ""
			box.find('input:checked').each(
				->
					param += $(this).val() + ' '
			)
			param = $.trim(param)
			if param != ""
				window.open('/file/download' + "?fold="+$(this).data("type")+"&files=" + param,'_blank')
				#path = '/file/download' + "?fold="+$(this).data("type")+"&files=" + param
				#$('<a>').attr('href',path).attr('target','_blank').css('display', 'none').appendTo('body').click()
	)
	
	# Тултипы
	$(document).on(
		mouseenter:
			->
				content = $(this).attr('data-tooltip')
				x = $(this).offset().left + $(this).innerWidth()/2
				y = $(this).offset().top
				#tooltip = $('.tooltip')
				tooltip = jQuery(document.createElement('div'))
							.addClass("tooltip")
							.text(content)
							.appendTo("body")
				y -= tooltip.outerHeight()+10
				x -= tooltip.outerWidth()/2
				tooltip.css({'top': y+'px', 'left': x+'px'}).delay(700).fadeIn(300)
		, mouseleave:
			->
				#$(".tooltip").css('display', 'none').text('')
				$(".tooltip").remove();
		, '.tipped'
	)
	
	$('.help').click(
		->
			trip.start()
	)
	
	# Ховер логаута
	$('#logout').hover(
		->
			fio = $('.fio')
			x = $(this).offset().left + $(this).width()/2 - fio.outerWidth()/2
			y = $(this).offset().top + 80
			fio.clearQueue()
			fio.css({'top': y+'px', 'left': x+'px'}).stop(true, true).css("opacity", "1").delay(700).fadeIn(300)
		->
			fio = $('.fio')
			fio.clearQueue()
			fio.stop(true, true).css("opacity", "1").fadeOut(300)
	)
	
	# Отмена параметров поиска
	$('.params li').click(
		->
			a = $(this).data('option')
			query = location.search.substring(1)
			params = query.split("&")
			arr = []
			for option in params
				if option.search(a) == -1
					arr[arr.length] = option
			if arr.length == 0 || a == "all"
				window.location = window.location.pathname
			else
				window.location = window.location.pathname + "?" + arr.join('&')
	)
	
	$('.content-item').on('click', '.hide-tree'
		->
			$(this).parent().prev().slideUp(350)
			$(this).toggleClass("hide-tree show-tree")
			text_span = $(this).children(".text")
			text_span.text(text_span.data('show'))
	)
	
	$('.content-item').on('click', '.show-tree'
		->
			$(this).parent().prev().slideDown(350)
			$(this).toggleClass("show-tree hide-tree")
			text_span = $(this).children(".text")
			text_span.text(text_span.data('hide'))
	)
	
	$("#standards").hover(
		->
			$(this).children(".submenu").stop(true, true).css("opacity", "1").delay(50).fadeIn(350)
		->
			$(this).children(".submenu").stop(true, true).css("opacity", "1").delay(50).fadeOut(350)
	)