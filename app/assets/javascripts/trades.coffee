hideErrors = ->
  $(".alert").hide()
  $("#new_trade input[type=submit]").prop('disabled', false)


showErrors = (error) ->
  $(".alert").show()
  $(".alert").html(error)
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
        showErrors("#{username} not found, please try again")
    ), 250

    false

$(document).on('page:load', ready)
$ ready
