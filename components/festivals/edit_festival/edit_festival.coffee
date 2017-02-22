FlowRouter.route '/edit_festival/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_festival'



if Meteor.isClient
    Template.edit_festival.onCreated ->
        self = @
        self.autorun ->
            self.subscribe 'doc', FlowRouter.getParam('doc_id')
    
    
    Template.edit_festival.helpers
        doc: ->
            Docs.findOne FlowRouter.getParam('doc_id')
        
    
            
            
    Template.edit_festival.events
        'click #save': ->
            start_datetime = $('#start_datetime').val()
            end_datetime = $('#end_datetime').val()
            
            Docs.update FlowRouter.getParam('doc_id'),
                $set:
                    start_datetime: start_datetime
                    end_datetime: end_datetime

            FlowRouter.go "/view/#{FlowRouter.getParam('doc_id')}"
