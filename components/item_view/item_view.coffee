if Meteor.isClient
    Template.item_view.events
        'click .doc_tag': ->
            if @valueOf() in selected_tags.array() then selected_tags.remove @valueOf() else selected_tags.push @valueOf()
            
    Template.item_view.helpers
        tag_class: -> if @valueOf() in selected_tags.array() then 'primary' else 'basic'
