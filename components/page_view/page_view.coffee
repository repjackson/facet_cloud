
FlowRouter.route '/view/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'page_view'



if Meteor.isClient
    Template.page_view.onCreated ->
        self = @
        self.autorun ->
            self.subscribe 'doc', FlowRouter.getParam('doc_id')
    
    
    
    Template.page_view.helpers
        item: ->
            Docs.findOne FlowRouter.getParam('doc_id')
    
        day: -> moment(@start_datetime).format("dddd, MMMM Do");
        start_time: -> moment(@start_datetime).format("h:mm a")
        end_time: -> moment(@end_datetime).format("h:mm a")

    
    Template.page_view.events
        'click .edit': ->
            doc_id = FlowRouter.getParam('doc_id')
            FlowRouter.go "/edit/#{doc_id}"
