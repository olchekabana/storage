$ ->	
	share_roll_out = (label) ->
		dfd = $.Deferred()
		label.animate({width: "258px"}, 250, dfd.resolve)
		return dfd.promise()
		
	share_roll_in = (inp_link) ->
		dfd = $.Deferred()
		inp_link.fadeOut(250, dfd.resolve)
		return dfd.promise()
		
	block_fade_out = (block) ->
		dfd = $.Deferred()
		block.fadeOut(350, dfd.resolve)
		return dfd.promise()
		
	# Красивые чекбоксы
	$('body').on('click', '.check'
		->
			$(this).children().first().toggleClass("icon-check-empty icon-check")
	)
	
	# Показ файлов
	$('.show').click(
		->
			box = $(this).parents('.files')
			folder = $(this).data("type")
			bool = false
			all_bool = true
			box.find('input:checked').each(
				->
					unless $(this).hasClass("cant")
						window.open('/file/'+folder+'/show/'+$(this).val(),'_blank')
						all_bool = false
					else
						bool = true				
			)
			if bool and all_bool
				content = $("#errors").data("cant-show-all")
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
	
	# Анимация линка для шары
	$('.link').click(
		->
			label = $(this).parent('li')
			inp_link = $(this).prev()
			
			if !$(this).attr('data-toggled') || $(this).attr('data-toggled') == "off"
				$(this).attr('data-toggled', "on")
				share_roll_out(label).done(
					->
						inp_link.fadeIn(250)
						inp_link.select()
				)
			else
				$(this).attr('data-toggled', "off")
				share_roll_in(inp_link).done(
					->
						label.animate({width: "50px"}, 250)
				)
	)
	
	# Свитч отображения информации о работе и списка файлов
	$('.attachment').click(
		->
			block = $(this)
			icon = $(this).children()
			item_id = $(this).data('itemLink')
			item = $("[data-item-id='" + item_id + "']")
			info = item.children(".info")
			files = item.children(".files")
			if !$(this).attr('data-toggled') || $(this).attr('data-toggled') == "off"
				$(this).attr('data-toggled', "on")
				block_fade_out(info).done(
					->
						files.fadeIn(350)
						icon.toggleClass("icon-attachment icon-list")
						block.attr('data-tooltip', block.attr('data-tool-list'))
				)
			else
				$(this).attr('data-toggled', "off")
				block_fade_out(files).done(
					->
						info.fadeIn(350)
						icon.toggleClass("icon-attachment icon-list")
						block.attr('data-tooltip', block.attr('data-tool-attach'))
				)
	)
	
	$('.struct').click(
		->
			block = $(this)
			icon = $(this).children()
			item_id = $(this).data('itemLink')
			item = $("[data-item-id='" + item_id + "']")
			ul = item.siblings(".item-ul")
			tooltip = $(".tooltip")
			if !$(this).attr('data-toggled') || $(this).attr('data-toggled') == "off"
				$(this).attr('data-toggled', "on")
				icon.toggleClass("icon-plus icon-minus")
				block.attr('data-tooltip', block.attr('data-tool-minus'))
				ul.stop(true, true).slideDown(700)
				if tooltip
					tooltip.text(block.attr('data-tool-minus'))
			else
				$(this).attr('data-toggled', "off")
				icon.toggleClass("icon-plus icon-minus")
				block.attr('data-tooltip', block.attr('data-tool-plus'))
				ul.stop(true, true).slideUp(700)
				if tooltip
					tooltip.text(block.attr('data-tool-plus'))
	)
	
	# Подгрузка фильтра
	$('.filter').click(
		->
			path = window.location.pathname.substring(1)
			ind = path.indexOf("/", 0)
			if ind != -1
				path = path.substring(0, ind)
			if window.location.search == ''
				url = "/filter?locate=" + path
			else
				url = '/filter'+window.location.search+'&locate=' + path
			$.arcticmodal({
				type: 'ajax',
				url: url
			})
			return false;
	)
	
	$('.item').click(
		->
			$(this).parent().prev().triggerHandler('click')
	)
	
	hide_block = (block) ->
		dfd = $.Deferred()
		block.delay(150).animate({opacity: 0.0, marginLeft: '40px'}, 700, dfd.resolve)
		return dfd.promise()
	
	