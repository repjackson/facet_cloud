# Template.q_a.helpers
#     sessions: ->
#         Docs.find
#             parent_id: FlowRouter.getParam('doc_id')
#             type: 'session'
    
#     questions: ->
#         Docs.find
#             parent_id: FlowRouter.getParam('doc_id')
#             type: $ne: 'session'


Template.sessions.helpers
    my_sessions: ->
        Docs.find
            type: 'session'
            author_id: Meteor.userId()
            parent_id: FlowRouter.getParam('doc_id')


Template.card_view.helpers
    child_view_fields: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        doc.child_fields
    
    doc: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
    parent_doc: ->
        Template.parentData()
    
    has_title: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        'title' in doc.child_fields
    show_header: -> @title or @number or @icon_class or @end_date
    
    has_content: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        'content' in doc.child_fields
        
    has_content: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        'tags' in doc.child_fields
        
    favoriter_list: ->
        if @favoriters
            if @favoriters.length > 0
        # console.log @completed_by
                Meteor.users.find _id: $in: @favoriters
        else 
            false
        
    upvoter_list: ->
        if @upvoters
            if @upvoters.length > 0
        # console.log @completed_by
                Meteor.users.find _id: $in: @upvoters
        else 
            false
        
        
        
        
Template.list_item.helpers
    child_view_fields: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        # console.log doc.child_fields
        doc.child_fields
    
    doc: ->
        # doc = Docs.findOne FlowRouter.getParam('doc_id')
        Template.parentData()
    
    has_title: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        'title' in doc.child_fields
    
    has_content: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        'content' in doc.child_fields
        
    has_content: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        'tags' in doc.child_fields
        
Template.grid_item.helpers
    card_class: -> 
        if @can_access() then '' else 'noborders'
