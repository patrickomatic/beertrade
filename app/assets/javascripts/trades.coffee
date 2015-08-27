hideErrors = ->
  $("#error_explanation").hide()
  $("#new_trade input[type=submit]").prop('disabled', false)


showErrors = (error) ->
  $("#error_explanation").show()
  $("#trade_errors").html(error)
  $("#new_trade input[type=submit]").prop('disabled', true)


$ ->
  $username = $("#participant_username")

  hideErrors()
  $("#new_trade input[type=submit]").prop('disabled', true)

  $username.keyup ->
    clearTimeout timer
    timer = setTimeout (->
      username = $username.val()

      $.getJSON("https://api.reddit.com/user/#{username}/about.json")
      .success (json, resp) ->
        hideErrors()
      .error ->
        showErrors("<li>#{username} not found, please try again</li>")
    ), 250

    false
