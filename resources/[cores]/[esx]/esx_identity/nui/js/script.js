let reset = false
$(function() {
	$.post(`https://${GetParentResourceName()}/ready`, JSON.stringify({}))
	window.addEventListener('message', function(e) {
		if (e.data.type === "enableui") {
			document.body.style.display = e.data.enable ? "block" : "none"
			reset = e.data.reset
		} else if (e.data.type == "showError") {
			let ele = document.getElementById('errormsg');
			ele.innerHTML = "<strong>Oeps! </strong>" + e.data.text;
			$('.alert').fadeIn();
			$('#submit').css('margin-top', '2vh');
		}
	});

	$(".radio-toolbar-item").click(function(e) {
		$(".radio-toolbar-item").removeClass("small");
		$(".radio-toolbar-item").removeClass("checked");

		$(".radio-toolbar-item").addClass("small");
		$(this).removeClass("small");
		$(this).addClass("checked");
		if(!reset) {
			$.post(`https://${GetParentResourceName()}/setPed`, JSON.stringify({
				gender: $(this).attr("data-gender")
			}));
		}
	});

	$("#register").submit(function(e) {
		e.preventDefault() // Prevent form from submitting
		reset = false
		$.post(`https://${GetParentResourceName()}/register`, JSON.stringify({
			firstname: $("#firstname").val(),
			lastname: $("#lastname").val(),
			dateofbirth: $("#dateofbirth").val(),
			sex: $(".radio-toolbar-item").data('gender'),
			height: $("#height").val()
		}))
	});
});
