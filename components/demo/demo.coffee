FlowRouter.route '/demo', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'demo'


if Meteor.isClient
    Template.demo.onCreated -> 
        @autorun -> Meteor.subscribe('docs', selected_tags.array())

    Template.demo.helpers
        docs: -> 
            Docs.find()
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'primary' else 'basic'

    
    
    Template.demo.events
        