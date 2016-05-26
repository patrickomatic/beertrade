redditUsernameSearch = ($formGroup) ->
  $form = $formGroup.closest("form")
  $submitButton = $form.find("input[type=submit]")
  $errorGlyph = $formGroup.find(".reddit-username-input-error")
  $successGlyph = $formGroup.find(".reddit-username-input-success")
  $messages = $form.find(".trader-alert")


  resetForm = ->
    $successGlyph.hide()
    $errorGlyph.hide()
    $messages.addClass("hidden");
    $formGroup.removeClass("has-error")
    $formGroup.removeClass("has-success")
    $submitButton.prop('disabled', true)


  resetForm()

  $username = $formGroup.find(".reddit-username-input-element")
  timer = null

  $username.bind "keyup change", ->
    resetForm()

    clearTimeout timer

    timer = setTimeout (->
      username = $username.val()
      if username == ''
        disableForm()
        return

      BT.User.find(username)
      .done (user) ->
        $submitButton.prop('disabled', false);

        $(".trader-link").attr('href', user.path)

        if user.hasNoTrades()
          $("#no-trades-message").removeClass("hidden");
        else if user.isQuestionableTrader()
          $("#neutral-trades-message").removeClass("hidden");
        else if user.isBadTrader()
          $("#bad-trades-message").removeClass("hidden");
        else
          $formGroup.addClass("has-success")
          $successGlyph.show()
      .fail ->
        $formGroup.addClass("has-error")
        $errorGlyph.show()
    ), 250

    false


ready = ->
  redditUsernameSearch($($el)) for $el in $(".reddit-username-input")


$(document).on('page:load', ready)
$ ready
