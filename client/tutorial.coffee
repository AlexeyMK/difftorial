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

    # break up by comments, not by lines
    lines = p.split /\n/
    lines = lines.map (line) ->
      class_to_add = switch line[0]
        when "+" then "plus"
        when "-" then "minus"
        else ""
      """
        <li>
          <div class='annotation'>
          </div>
          <div class='content #{class_to_add}'>
            <div class='highlight'>
              <pre>#{esc line}</pre>
            </div>
          </div>
        </li>
      """
    return lines.join('')

  commit_message: -> Session.get('message')
  next_sha: -> Session.get('next')
  previous_sha: -> Session.get('previous')
  next_commit_url: ->
    return "/#{Session.get 'owner'}/#{Session.get 'repo'}/#{Session.get 'next'}"
  previous_commit_url: ->
    return "/#{Session.get 'owner'}/#{Session.get 'repo'}/#{Session.get 'previous'}"
  commits_length: -> Session.get('commits_length')
  index: -> Session.get('index')
