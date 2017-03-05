Template.edit_item.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'doc', FlowRouter.getParam('doc_id')


Template.edit_item.helpers
    item: ->
        Docs.findOne FlowRouter.getParam('doc_id')
    

        
        
Template.edit_item.events
    'click #save_item': ->
        FlowRouter.go "/item/view/#{@_id}"
