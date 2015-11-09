ready = ->
  $form_group = $(".reddit-username-input")
  $error_glyph = $form_group.find(".reddit-username-input-error")
  $success_glyph = $form_group.find(".reddit-username-input-success")
  $username = $form_group.find("#participant_username")

  hideGlyphs = ->
    $success_glyph.hide()
    $error_glyph.hide()
    $form_group.removeClass("has-error")
    $form_group.removeClass("has-success")

  disableForm = ->
    $("#new_trade input[type=submit]").prop('disabled', true)

  hideErrors = ->
    $("#new_trade input[type=submit]").prop('disabled', false)
    $form_group.addClass("has-success")
    $form_group.removeClass("has-error")
    $error_glyph.hide()
    $success_glyph.show()


  showErrors = ->
    disableForm()
    $form_group.addClass("has-error")
    $form_group.removeClass("has-success")
    $error_glyph.show()
    $success_glyph.hide()


  hideGlyphs()
  disableForm()

  $username.bind "keyup change input", ->
    clearTimeout timer

    timer = setTimeout (->
      username = $username.val()
      if username == ''
        disableForm()
        hideGlyphs()
        return
        

      $.getJSON("https://api.reddit.com/user/#{username}/about.json")
      .success (json, resp) ->
        hideErrors()
      .error ->
        showErrors()
    ), 250

    false

$(document).on('page:load', ready)
$ ready
