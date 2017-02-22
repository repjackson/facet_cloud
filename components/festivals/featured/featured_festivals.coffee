if Meteor.isClient
    Template.featured_festivals.onCreated -> 
        @autorun -> Meteor.subscribe 'featured_festivals'

    Template.featured_festivals.helpers
        featured_festivals: -> 
            Docs.find()
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'primary' else 'basic'


    
    Template.festival_item.helpers
        is_author: -> Meteor.userId() and @author_id is Meteor.userId()
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'primary' else 'basic'
    
        when: -> moment(@timestamp).fromNow()

    Template.festival_item.events
        'click .tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove(@valueOf()) else selected_tags.push(@valueOf())
    
    Template.featured_festivals.events
        'click #add_festival': ->
            Meteor.call 'add_festival', (err,id)->
                FlowRouter.go "/edit_festival/#{id}"



if Meteor.isServer
    Meteor.publish 'featured_festivals', ->
    
        self = @
        match = {}
        match.type = 'festival'
        match.featured = true
    
        Docs.find match,
            limit: 3
    
    
    
