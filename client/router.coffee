Meteor.Router.add(
  '/tutorial/:owner/:repo/:sha': (owner, repo, sha) ->
    base = ""
    console.log sha
    $.ajax
      url: "https://api.github.com/repos/#{owner}/#{repo}/commits"
      success: (commits) ->
        for commit, index in commits
          if commit.sha == sha
            Session.set('next', commits[index-1]?.sha)
            Session.set('previous', commits[index+1]?.sha)
            Session.set('message', commit.commit.message)

        $.ajax
          url: "https://api.github.com/repos/#{owner}/#{repo}/commits/#{sha}",
          success: (result) ->
            diff = ({filename: file.filename, patch: file.patch} for file in result.files)
            Session.set('diff', diff)
    return 'tutorial'
  '*': '404'
)
