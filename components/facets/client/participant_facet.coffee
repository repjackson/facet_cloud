@selected_participant_ids = new ReactiveArray []

Template.participant_facet.onCreated ->
    Meteor.subscribe 'usernames'

Template.participant_facet.helpers
    participant_tags: ->
        participant_usernames = []
        
        for participant_id in Participant_ids.find().fetch()
            found_user = Meteor.users.findOne(participant_id.text).username
            participant_tag_object = {}
            # if found_user
                # console.log Meteor.users.findOne(participant_id.text).username
            # participant_usernames.push Meteor.users.findOne(participant_id.text).username
            participant_tag_object.username = Meteor.users.findOne(participant_id.text).username
            participant_tag_object.count = participant_id.count
            participant_usernames.push participant_tag_object
        participant_usernames


    selected_participant_ids: ->
        selected_participant_usernames = []
        for selected_participant_id in selected_participant_ids.array()
            selected_participant_usernames.push Meteor.users.findOne(selected_participant_id).username
        selected_participant_usernames
    
    
Template.participant_facet.events

    'click .select_participant': ->
        selected_participant = Meteor.users.findOne username: @username
        selected_participant_ids.push selected_participant._id
    'click .unselect_participant': -> 
        selected_participant = Meteor.users.findOne username: @valueOf()
        selected_participant_ids.remove selected_participant._id
    'click #clear_participants': -> selected_participant_ids.clear()