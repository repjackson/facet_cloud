if Meteor.isClient
    Template.profile_karma.onCreated -> 
        @autorun -> Meteor.subscribe('user_profile', FlowRouter.getParam('username'))
        @autorun -> Meteor.subscribe('karma_docs', FlowRouter.getParam('username'))

    Template.profile_karma.helpers
        user: -> Meteor.users.findOne username: FlowRouter.getParam('username')
        
        karma_docs: ->
            user = Meteor.users.findOne username:FlowRouter.getParam('username')
            
            Docs.find
                author_id:user._id
                points: $gt: 1
                
            
            
            
    Template.profile_karma.events


if Meteor.isServer
    Meteor.publish 'karma_docs', (username)->
        user = Meteor.users.findOne username:username
        
        Docs.find
            author_id:user._id
            points: $gt: 1
            
            