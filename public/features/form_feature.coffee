Feature "simple form", ->
  Given -> fillIn "firstName", with: "santa"
  Given -> fillIn "lastName", with: "claus"
  Given -> click '#submitButton'
  Then -> expect($('#submitButton')).toBeAttached()