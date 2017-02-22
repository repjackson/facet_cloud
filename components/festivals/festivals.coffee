FlowRouter.route '/festivals', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'festivals'



if Meteor.isClient
    Template.festivals.onCreated -> 
        @autorun -> Meteor.subscribe('festivals', selected_tags.array())

    Template.festivals.helpers
        festivals: -> 
            Docs.find()
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'primary' else 'basic'


    
    Template.festival_item.helpers
        is_author: -> Meteor.userId() and @author_id is Meteor.userId()
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'primary' else 'basic'
    
        when: -> moment(@timestamp).fromNow()

    Template.festival_item.events
        'click .tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove(@valueOf()) else selected_tags.push(@valueOf())
    
    Template.festivals.events
        'click #add_festival': ->
            Meteor.call 'add_festival', (err,id)->
                FlowRouter.go "/edit_festival/#{id}"



if Meteor.isServer
    Meteor.methods
        add_festival: ->
            id = Docs.insert
                type: 'festival'
            return id
    
    
    
    Meteor.publish 'festivals', (selected_tags)->
    
        self = @
        match = {}
        if selected_tags.length > 0 then match.tags = $all: selected_tags
        match.type = 'festival'
    
        Docs.find match
    