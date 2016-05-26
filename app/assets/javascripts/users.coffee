class BT.User
  id: null
  username: null 
  reputation: 0
  positive_feedback_count: 0
  neutral_feedback_count: 0
  negative_feedback_count: 0


  @find: (username) ->
    user = $.extend(new BT.User(), {username: username})

    $.Deferred (defer) ->
      $.getJSON(user.path()).success (data) ->
        defer.resolve $.extend(user, data)
      .error ->
        $.getJSON("https://api.reddit.com/user/#{user.username}/about.json").success (data) ->
          defer.resolve user
        .error -> 
          defer.reject()
    

  hasNoTrades: ->
    @reputation == @positive_feedback_count == @negative_feedback_count == @neutral_feedback_count == 0 
  
  isBadTrader: ->
    @negative_feedback_count > 0

  isQuestionableTrader: ->
    @neutral_feedback_count > 0


  path: =>
    "/users/#{@username}"
