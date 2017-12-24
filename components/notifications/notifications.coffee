if Meteor.isClient
    Template.notifications.onCreated ->
        @autorun -> Meteor.subscribe('my_notifications', Meteor.userId())
    
    Template.notifications.helpers
        notifications: -> 
            Docs.find
                type: 'notification'
                recipient_id: Meteor.userId()
    
    
    Template.notifications.events
        'click .tag': ->
            if @valueOf() in selected_people_tags.array() then selected_people_tags.remove @valueOf() else selected_people_tags.push @valueOf()

if Meteor.isServer
    Meteor.publish 'my_notifications', (user_id)->
        Docs.find
            type: 'notification'
            recipient_id: Meteor.userId()
