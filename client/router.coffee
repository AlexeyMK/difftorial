Meteor.Router.add(
  '/': 'hello'
  '/tutorial/:owner/:repo/:base/:head': (owner, repo, base, head) ->
    Session.set('owner', owner)
    Session.set('repo', repo)
    Session.set('base', base)
    Session.set('head', head)
    'tutorial'
  '*': '404'
)
