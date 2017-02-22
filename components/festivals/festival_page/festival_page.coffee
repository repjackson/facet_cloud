
FlowRouter.route '/view_festival/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'festival_page'



if Meteor.isClient
    Template.festival_page.onCreated ->
        self = @
        self.autorun ->
            self.subscribe 'doc', FlowRouter.getParam('doc_id')
    
    
    
    Template.festival_page.helpers
        item: ->
            Docs.findOne FlowRouter.getParam('doc_id')
    
        day: -> moment(@start_datetime).format("dddd, MMMM Do");
        start_time: -> moment(@start_datetime).format("h:mm a")
        end_time: -> moment(@end_datetime).format("h:mm a")

    
    Template.festival_page.events
        'click .edit': ->
            doc_id = FlowRouter.getParam('doc_id')
            FlowRouter.go "/edit/#{doc_id}"
