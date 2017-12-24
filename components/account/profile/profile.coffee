if Meteor.isClient
    # loggedIn = FlowRouter.group
    #     triggersEnter: [ ->
    #         unless Meteor.loggingIn() or Meteor.userId()
    #             route = FlowRouter.current()
    #             unless route.route.name is 'login'
    #                 Session.set 'redirectAfterLogin', route.path
    #             FlowRouter.go ‘login’
    #     ]
    
    FlowRouter.route '/profile/:username', 
        name: 'profile_home'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                sub_nav: 'member_nav'
                profile_content: 'profile_about'
                
    FlowRouter.route '/profile/:username/about', 
        name: 'profile_about'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                sub_nav: 'member_nav'
                profile_content: 'profile_about'
    
    FlowRouter.route '/profile/:username/contact', 
        name: 'profile_contact'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                sub_nav: 'member_nav'
                profile_content: 'profile_contact'
    
    FlowRouter.route '/profile/:username/membership', 
        name: 'profile_membership'
        action: (params) ->
            BlazeLayout.render 'profile_membership',
                sub_nav: 'member_nav'
                profile_content: 'profile_membership'
    
    
    
    FlowRouter.route '/profile/:username/karma', 
        name: 'profile_karma'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                sub_nav: 'member_nav'
                profile_content: 'profile_karma'
    
    FlowRouter.route '/profile/:username/quizzes', 
        name: 'profile_quizzes'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                sub_nav: 'member_nav'
                profile_content: 'profile_quizzes'

    FlowRouter.route '/profile/:username/journal', 
        name: 'profile_journal'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                sub_nav: 'member_nav'
                profile_content: 'profile_journal'

    FlowRouter.route '/profile/:username/badges', 
        name: 'profile_badges'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                sub_nav: 'member_nav'
                profile_content: 'profile_badges'





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
