Template.tutorial.helpers
  diff: -> Session.get('diff')

Template.tutorial.events
  'click a#prev': (e) ->
    e.preventDefault()
    Session.set('diff', [filename:'previous', patch:'previous patch'])
  'click a#next': (e) ->
    e.preventDefault()
    Session.set('diff', [filename:'next', patch:'next patch'])
