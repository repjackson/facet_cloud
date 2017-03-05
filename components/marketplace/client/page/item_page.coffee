Template.item_page.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.item_page.helpers
    item: -> Docs.findOne FlowRouter.getParam('doc_id')

    can_edit: -> Meteor.userId()


    
Template.item_page.events

    'click .edit_item': ->
        FlowRouter.go "/item/edit/#{@_id}"