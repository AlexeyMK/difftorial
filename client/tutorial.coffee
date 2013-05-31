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
        line
    # safestring fails really horribly when the diff has html in it itself
    return new Handlebars.SafeString(lines.join '\n')

Template.tutorial.events
  'click a#prev': (e) ->
    e.preventDefault()
    Session.set('diff', [filename:'previous', patch:'previous patch'])
  'click a#next': (e) ->
    e.preventDefault()
    Session.set('diff', [filename:'next', patch:'next patch'])
