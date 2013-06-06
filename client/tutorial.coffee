Template.tutorial.helpers
  diff: -> Session.get('diff')
  getSections: (filename, p) =>
    return if not p? or not filename?
    @Diffco.document filename, p

  commit_message: -> Session.get('message')
  next_sha: -> Session.get('next')
  previous_sha: -> Session.get('previous')
  next_commit_url: ->
    return "/#{Session.get 'owner'}/#{Session.get 'repo'}/#{Session.get 'next'}"
  previous_commit_url: ->
    return "/#{Session.get 'owner'}/#{Session.get 'repo'}/#{Session.get 'previous'}"
  commit_count: -> Session.get('commit_count')
  index: -> Session.get('index')
