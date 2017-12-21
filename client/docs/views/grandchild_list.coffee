Template.grandchild_list.onCreated -> 
    Meteor.subscribe 'author', @data._id
    Meteor.subscribe 'child_docs', @data._id

Template.grandchild_list.helpers
    grandchildren: ->
        Docs.find {
            type: $ne: 'session'
            parent_id: @_id
            }, sort: number: 1
