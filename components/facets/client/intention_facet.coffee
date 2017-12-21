@selected_intention_tags = new ReactiveArray []

# Template.intention_facet.onCreated ->
#     @autorun => 
#         Meteor.subscribe('facet', 
#             selected_theme_tags.array()
#             selected_author_ids.array()
#             selected_location_tags.array()
#             selected_intention_tags.array()
#             selected_timestamp_tags.array()
#             # author_id=@data.author_id
#             )

Template.intention_facet.helpers
    intention_tags: ->
        doc_count = Docs.find(type:Template.currentData().type).count()
        # if selected_intention_tags.array().length
        if 0 < doc_count < 3
            Intention_tags.find { 
                count: $lt: doc_count
                }, limit:20
        else
            Intention_tags.find({}, limit:20)
            
            
    intention_tag_class: ->
        button_class = []
        switch
            when @index <= 5 then button_class.push ' '
            when @index <= 10 then button_class.push 'small'
            when @index <= 15 then button_class.push 'tiny '
            when @index <= 20 then button_class.push ' mini'
        return button_class

    selected_intention_tags: -> selected_intention_tags.array()
    # selected_author_ids: -> selected_author_ids.array()



Template.intention_facet.events
    'click .select_intention_tag': -> selected_intention_tags.push @name
    'click .unselect_intention_tag': -> selected_intention_tags.remove @valueOf()
    'click #clear_intention_tags': -> selected_intention_tags.clear()

    'keyup #search': (e,t)->
        e.preventDefault()
        val = $('#search').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                switch val
                    when 'clear'
                        selected_intention_tags.clear()
                        $('#search').val ''
                    else
                        unless val.length is 0
                            selected_intention_tags.push val.toString()
                            $('#search').val ''
            when 8
                if val.length is 0
                    selected_intention_tags.pop()
                    
    'autocompleteselect #search': (event, template, doc) ->
        # console.log 'selected ', doc
        selected_intention_tags.push doc.name
        $('#search').val ''
