hideErrors = ->
  $(".username-warning").hide()
  $("#new_trade input[type=submit]").prop('disabled', false)


showErrors = (error) ->
  $(".username-warning").show()
  $(".username-warning").html(error)
  $("#new_trade input[type=submit]").prop('disabled', true)


ready = ->
  $username = $("#participant_username")

  hideErrors()
  $("#new_trade input[type=submit]").prop('disabled', true)

  $username.keyup ->
    clearTimeout timer
    timer = setTimeout (->
      username = $username.val()
      return if username == ''

      $.getJSON("https://api.reddit.com/user/#{username}/about.json")
      .success (json, resp) ->
        hideErrors()
      .error ->
        showErrors("#{username} not found")
    ), 250

    false

$(document).on('page:load', ready)
$ ready
