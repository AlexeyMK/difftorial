Template.tutorial.helpers
  diff: -> Session.get('diff')
  renderPatch: (p) ->
    return p if not p?
    lines = p.split /\n/
    lines = lines.map (line) ->
      if line[0] == "+"
        "<span class='plus'>#{line}</span>"
      else if line[0] == "-"
        "<span class='minus'>#{line}</span>"
      else
        line
    # safestring fails really horribly when the diff has html in it itself
    return new Handlebars.SafeString(lines.join '\n')
