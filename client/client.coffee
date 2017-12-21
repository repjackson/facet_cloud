$.cloudinary.config
    cloud_name:"facet"

Session.setDefault 'cart_item', null
Session.setDefault 'view_mode', 'cards'
# Session.setDefault 'doc_limit', 10
Session.setDefault 'view_complete', null
Session.setDefault 'editing', false


Session.setDefault 'view_unread', false
Session.setDefault 'admin_mode', false
    
    
    
    
# Meteor.startup ->
#     stripeKey = Meteor.settings.public.stripe.livePublishableKey
#     Stripe.setPublishableKey stripeKey
    
#     STRIPE =
#         getToken: (domElement, card, callback) ->
#             Stripe.card.createToken card, (status, response) ->
#                 if response.error
#                     Bert.alert response.error.message, 'danger'
#                 else
#                     STRIPE.setToken response.id, domElement, callback
#                 return
#             return
#         setToken: (token, domElement, callback) ->
#             $(domElement).append $('<input type=\'hidden\' name=\'stripeToken\' />').val(token)
#             callback()
#             return

#     return

    
Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'is_user', () ->  Meteor.userId() is @_id
Template.registerHelper 'is_person_by_username', () ->  Meteor.user().username is FlowRouter.getParam('username')

Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')

# Template.registerHelper 'zen_mode', () -> Session.get 'zen_mode'
Template.registerHelper 'admin_mode', () ->  Session.get 'admin_mode'
Template.registerHelper 'editing', () ->  
    Session.get('editing') or Session.equals('editing_id', @_id)


# Template.registerHelper 'is_admin', () ->  
#     Roles.userIsInRole(Meteor.userId(), 'admin') and Session.equals 'admin_mode', true

Template.registerHelper 'publish_when', () -> moment(@publish_date).fromNow()

Template.registerHelper 'theme_tag_class': -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'
Template.registerHelper 'location_tag_class': -> if @valueOf() in selected_location_tags.array() then 'teal' else 'basic'
Template.registerHelper 'intention_tag_class': -> if @valueOf() in selected_intention_tags.array() then 'teal' else 'basic'

Template.registerHelper 'segment_class', () -> 
    if Roles.userIsInRole 'admin'
        if @published is 1 then 'raised blue' else ''
    else
        ''
# Template.registerHelper 'card_class', () -> if Session.equals('admin_mode', true) then '' else 'noborders'

Template.registerHelper 'read_segment_class', () -> if @read_by and Meteor.userId() in @read_by then 'raised green' else 'basic'
Template.registerHelper 'ribbon_class', () -> if @published then 'blue' else 'basic'

Template.registerHelper 'from_now', () -> moment(@timestamp).fromNow()

Template.registerHelper 'long_date', () -> moment(@timestamp).format("dddd, MMMM Do, h:mm a")
# Template.registerHelper 'long_date', () -> moment(@timestamp).format("dddd, MMMM Do YYYY, h:mm:ss a")


# Template.registerHelper 'in_course', () -> @_id in Meteor.user().courses
# Template.registerHelper 'in_sol', () -> Roles.userIsInRole 'sol_member'
# Template.registerHelper 'in_demo', () -> Roles.userIsInRole 'sol_demo_member'

Template.registerHelper 'tag_class', ()-> if @valueOf() in selected_tags.array() then 'blue' else 'basic'




# messages
Template.registerHelper 'message_segment_class', -> if @read then '' else 'blue raised'



Template.registerHelper 'is_editing', () -> 
    # console.log 'this', @
    Session.equals 'editing_id', @_id

Template.registerHelper 'is_editing_something', () -> 
    # console.log 'this', @
    Session.get('editing_id') or Session.get 'editing'


Template.registerHelper 'is_dev', () -> Meteor.isDevelopment

FlowRouter.wait()
Tracker.autorun ->
  # if the roles subscription is ready, start routing
  # there are specific cases that this reruns, so we also check
  # that FlowRouter hasn't initalized already
  if Roles.subscription.ready() and !FlowRouter._initialized
     FlowRouter.initialize()



Template.staus_indicator.helpers
    labelClass: ->
        if @status?.idle
            'yellow'
        else if @status?.online
            'green'
        else
            'basic'

    online: ->  @status?.online
    
    idle: ->  @status?.idle



Meteor.startup ->
    Status.setTemplate('semantic_ui')
