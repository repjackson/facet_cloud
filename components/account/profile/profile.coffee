if Meteor.isClient
    # loggedIn = FlowRouter.group
    #     triggersEnter: [ ->
    #         unless Meteor.loggingIn() or Meteor.userId()
    #             route = FlowRouter.current()
    #             unless route.route.name is 'login'
    #                 Session.set 'redirectAfterLogin', route.path
    #             FlowRouter.go ‘login’
    #     ]
    
    FlowRouter.route '/u/:username', 
        name: 'profile_home'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                profile_content: 'profile_about'
                
    FlowRouter.route '/u/:username/about', 
        name: 'profile_about'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                profile_content: 'profile_about'
    
    FlowRouter.route '/u/:username/contact', 
        name: 'profile_contact'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                profile_content: 'profile_contact'
    
    FlowRouter.route '/u/:username/membership', 
        name: 'profile_membership'
        action: (params) ->
            BlazeLayout.render 'profile_membership',
                profile_content: 'profile_membership'
    
    
    
    FlowRouter.route '/u/:username/karma', 
        name: 'profile_karma'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                profile_content: 'profile_karma'
    
    FlowRouter.route '/u/:username/quizzes', 
        name: 'profile_quizzes'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                profile_content: 'profile_quizzes'


    FlowRouter.route '/u/:username/badges', 
        name: 'profile_badges'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                profile_content: 'profile_badges'

    FlowRouter.route '/u/:username/clouds', action: (params) ->
        BlazeLayout.render 'profile_layout',
            profile_content: 'clouds'

    FlowRouter.route '/u/:username/favorites', action: (params) ->
        BlazeLayout.render 'profile_layout',
            profile_content: 'favorites'



    Template.profile_layout.onCreated ->
        @autorun -> Meteor.subscribe('user_profile', FlowRouter.getParam('username'))

        
    Template.profile_layout.onRendered ->
    
    
    Template.profile_about.helpers
        person: -> Meteor.users.findOne username:FlowRouter.getParam('username') 
    
    Template.profile_layout.helpers
        person: -> Meteor.users.findOne username:FlowRouter.getParam('username') 
        is_user: -> FlowRouter.getParam('username') is Meteor.user()?.username
        
    Template.profile_layout.events
    # 	'mouseenter .item': -> $( ".corner.icon" ).addClass( "large" )
    # 	'mouseenter .item': (e,t)-> $(e.currentTarget).closest('.item').transition('pulse')

    # # 	'mouseleave .item': -> $( ".corner.icon" ).removeClass( "large" )
    # 	'mouseleave .item': (e,t)-> $( ".corner.icon" ).removeClass( "large" )
    
        'click #logout': -> AccountsTemplates.logout()
