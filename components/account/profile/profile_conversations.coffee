if Meteor.isClient
    Template.profile_conversations.onCreated -> 
        @autorun -> Meteor.subscribe('public_conversations_with_user', FlowRouter.getParam('username'))

    Template.profile_conversations.helpers
        user: ->
            Meteor.users.findOne username: FlowRouter.getParam('username')
    
        public_conversations_with_user: ->
            user = Meteor.users.findOne username: FlowRouter.getParam('username')
            if user
                Docs.find
                    type: 'conversation'
                    participant_ids: $in: [user._id]
                    published: true

    Template.profile_conversations.events

    
if Meteor.isServer
    Meteor.publish 'public_conversations_with_user', (username)->
        user = Meteor.users.findOne username: username
        Docs.find
            type: 'conversation'
            participant_ids: $in: [user._id]
            published: true