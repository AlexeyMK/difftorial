Template.tutorial.helpers
  diff: -> Session.get('diff')
  renderPatch: (p) ->
    return p if not p?
    esc = (string) ->
      escape =
        "&": "&amp;"
        "<": "&lt;"
        ">": "&gt;"
        '"': "&quot;"
        "'": "&#x27;"
        "`": "&#x60;"
      badChars = /[&<>"'`]/g
      escapeChar = (chr) -> escape[chr] or "&amp;"
      return string.replace(badChars, escapeChar).toString()

    lines = p.split /\n/
    lines = lines.map (line) ->
      if line[0] == "+"
        "<span class='plus'>#{esc line}</span>"
      else if line[0] == "-"
        "<span class='minus'>#{esc line}</span>"
      else
        esc line
    return new Handlebars.SafeString(lines.join '\n')
  commit_message: -> Session.get('message')
  next_sha: -> Session.get('next')
  previous_sha: -> Session.get('previous')
  next_commit_url: ->
    return "/#{Session.get 'owner'}/#{Session.get 'repo'}/#{Session.get 'next'}"
  previous_commit_url: ->
    return "/#{Session.get 'owner'}/#{Session.get 'repo'}/#{Session.get 'previous'}"
