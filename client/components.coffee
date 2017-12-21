Template.resonate_button.helpers
    resonate_button_class: -> 
        if Meteor.userId()
            if @favoriters and Meteor.userId() in @favoriters then 'blue' else 'basic'
        else 'disabled basic'

Template.resonate_button.events
    'click .resonate_button': (e,t)-> 
        if Meteor.userId() 
            Meteor.call 'favorite', Template.parentData(0)
            $(e.currentTarget).closest('.resonate_button').transition('pulse')
        else FlowRouter.go '/sign-in'


Template.resonates_list.helpers
    resonates_with_people: ->
        if @favoriters
            if @favoriters.length > 0
        # console.log @favoriters
                Meteor.users.find _id: $in: @favoriters
    
    
Template.read_by_list.onCreated ->
    @autorun => Meteor.subscribe 'read_by', Template.parentData()._id
    
Template.read_by_list.helpers
    read_by: ->
        if @read_by
            if @read_by.length > 0
        # console.log @read_by
                Meteor.users.find _id: $in: @read_by
        else 
            false
            
            
Template.bookmarked_by_list.onCreated ->
    @autorun => Meteor.subscribe 'bookmarked_by', Template.parentData()._id
    
Template.bookmarked_by_list.helpers
    bookmarked_by: ->
        if @bookmarked_ids
            if @bookmarked_ids.length > 0
        # console.log @bookmarked_ids
                Meteor.users.find _id: $in: @bookmarked_ids
        else 
            false
            
            
Template.mark_read.events
    'click .mark_read': (e,t)-> 
        Meteor.call 'mark_read', @_id
        
    'click .mark_unread': (e,t)-> Meteor.call 'mark_unread', @_id

Template.mark_read.helpers
    read: -> @read_by and Meteor.userId() in @read_by
    # read: -> true
    
    

    
    
Template.doc_matches.onCreated ->
    @is_calculating = new ReactiveVar 'false'
    
Template.doc_matches.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500
    
Template.doc_match.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500
    
Template.doc_matches.helpers
    # calculate_button_class: ->
        # if Template.instance().is_calculating then 'loading' else ''
    
Template.doc_matches.events
    'click #compute_doc_matches': ->
        $( "#compute_doc_matches" ).toggleClass( "loading" )
        # console.log @
        Meteor.call 'find_top_doc_matches', @_id, (err, res)->
            $( "#compute_doc_matches" ).toggleClass( "loading" )
            $( ".title" ).addClass( "active" )
            $( ".match_content" ).addClass( "active" )
            # console.log res
            
            
Template.doc_match.onCreated ->
    @autorun => Meteor.subscribe 'doc', @data.doc_id
            
Template.doc_match.helpers
    match_doc: -> Docs.findOne @doc_id
            
            
            
        
        
Template.parent_doc_segment.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500
    
Template.parent_doc_segment.onCreated ->
    # console.log @data
    @autorun => Meteor.subscribe 'parent_doc', @data._id
    
    
    
Template.view_published_toggle.helpers
    viewing_mine: -> Session.equals 'view_private',true  
    viewing_all: -> Session.equals 'view_private',false  


Template.view_published_toggle.events
    'click #view_my_entries': (e,t)-> Session.set('view_private',true)    
    'click #view_all_entries': (e,t)-> Session.set('view_private', false)    


Template.view_read_toggle.helpers
    viewing_unread: -> Session.equals 'view_unread', true  
    viewing_all: -> Session.equals 'view_unread',false  


Template.view_read_toggle.events
    'click #view_unread': (e,t)-> Session.set('view_unread', true)    
    'click #view_all': (e,t)-> Session.set('view_unread', false)    



# Template.instance().stripe = Stripe.configure(
#     key: stripe_key
#     image: '/toriwebster-logomark-04.png'
#     locale: 'auto'
#     # zipCode: true
#     token: (token) ->
#         # console.log token
#         purchasing_item = Docs.findOne Session.get 'purchasing_item'
#         console.dir 'purchasing_item', purchasing_item
#         charge = 
#             amount: purchasing_item.price*100
#             currency: 'usd'
#             source: token.id
#             description: token.description
#             receipt_email: token.email
#         Meteor.call 'processPayment', charge, (error, response) =>
#             if error then Bert.alert error.reason, 'danger'
#             else
#                 Meteor.call 'register_transaction', purchasing_item._id, (err, response)->
#                     if err then console.error err
#                     else
#                         Bert.alert "You have purchased #{purchasing_item.title}.", 'success'
#                         Docs.remove Session.get('current_cart_item')
#                         FlowRouter.go "/account"
#     # closed: ->
#     #     Bert.alert "Payment Canceled", 'info', 'growl-top-right'
# )


# Template.icon.helpers
    # 
# Template.response_count.onCreated ->
#     @autorun => Meteor.subscribe 'response_count', @data._id

Template.save_button.events
    'click #toggle_off_editing': -> Session.set 'editing', false