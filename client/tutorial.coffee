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
        "<li class='plus'>#{esc line}</li>"
      else if line[0] == "-"
        "<li class='minus'>#{esc line}</li>"
      else
        "<li>#{esc line}</li>"
    return new Handlebars.SafeString("<ul>#{lines.join ''}</ul>")
  commit_message: -> Session.get('message')
  next_sha: -> Session.get('next')
  previous_sha: -> Session.get('previous')
  next_commit_url: ->
    return "/#{Session.get 'owner'}/#{Session.get 'repo'}/#{Session.get 'next'}"
  previous_commit_url: ->
    return "/#{Session.get 'owner'}/#{Session.get 'repo'}/#{Session.get 'previous'}"
  commits_length: -> Session.get('commits_length')
  index: -> Session.get('index')
