FlowRouter.route '/clients', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'clients'


if Meteor.isClient
    Template.clients.onCreated ->
        @autorun -> Meteor.subscribe 'clients'
        
    Template.clients.helpers
        clients: ->
            Docs.find()
    
    Template.clients.events
    
    
    
if Meteor.isServer
    Meteor.publish 'clients', ->
        Docs.find   
            type: 'client'