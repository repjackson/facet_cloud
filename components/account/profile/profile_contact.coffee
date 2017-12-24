if Meteor.isClient
    Template.profile_contact.onCreated -> 
        @autorun -> Meteor.subscribe('conversation_with_user', FlowRouter.getParam('username'))

    Template.profile_contact.helpers
        user: -> Meteor.users.findOne username: FlowRouter.getParam('username')
        
        conversation_with_user: ->
            user = Meteor.users.findOne username: FlowRouter.getParam('username')
            if user
                Docs.findOne
                    type: 'conversation'
                    participant_ids: [Meteor.userId(), user._id]

    Template.profile_contact.events
        'click #create_conversation_with_user': ->
            user = Meteor.users.findOne username: FlowRouter.getParam('username')
            Docs.insert
                type: 'conversation'
                participant_ids: [Meteor.userId(), user._id]
                published: false
                tags: ['private','messaging']

    
if Meteor.isServer
    Meteor.publish 'conversation_with_user', (username)->
        user = Meteor.users.findOne username: username
        Docs.find
            type: 'conversation'
            participant_ids: [Meteor.userId(), user._id]
            