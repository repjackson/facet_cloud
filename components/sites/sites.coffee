FlowRouter.route '/sites', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'sites'


if Meteor.isClient
    Template.sites.onCreated ->
        @autorun -> Meteor.subscribe 'sites'
        
    Template.sites.helpers
        sites: ->
            Docs.find()
    
    Template.sites.events
    
    
    
if Meteor.isServer
    Meteor.publish 'sites', ->
        Docs.find   
            type: 'site'