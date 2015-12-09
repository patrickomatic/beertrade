redditUsernameSearch = ($formGroup) ->
  $form = $formGroup.closest("form")
  $submitButton = $form.find("input[type=submit]")
  $errorGlyph = $formGroup.find(".reddit-username-input-error")
  $successGlyph = $formGroup.find(".reddit-username-input-success")

  disableForm = ->
    $submitButton.prop('disabled', true)


  hideGlyphs = ->
    $successGlyph.hide()
    $errorGlyph.hide()
    $formGroup.removeClass("has-error")
    $formGroup.removeClass("has-success")

  hideErrors = ->
    $submitButton.prop('disabled', false)
    $formGroup.addClass("has-success")
    $formGroup.removeClass("has-error")
    $errorGlyph.hide()
    $successGlyph.show()

  showErrors = ->
    disableForm()
    $formGroup.addClass("has-error")
    $formGroup.removeClass("has-success")
    $errorGlyph.show()
    $successGlyph.hide()


  hideGlyphs()
  disableForm()

  $username = $formGroup.find(".reddit-username-input-element")
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


ready = ->
  redditUsernameSearch($($el)) for $el in $(".reddit-username-input")


$(document).on('page:load', ready)
$ ready
