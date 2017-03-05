if Meteor.isClient
    @selected_item_tags = new ReactiveArray []
    
    Template.item_cloud.onCreated ->
        @autorun -> Meteor.subscribe('item_tags', selected_item_tags.array())
    
    Template.item_cloud.helpers
        item_tags: ->
            doc_count = Docs.find().count()
            if 0 < doc_count < 3 then Tags.find { count: $lt: doc_count } else Tags.find()
            # Tags.find()    
    
    
        tag_cloud_class: ->
            button_class = switch
                when @index <= 10 then 'big'
                when @index <= 20 then 'large'
                when @index <= 30 then ''
                when @index <= 40 then 'small'
                when @index <= 50 then 'tiny'
            return button_class
    
        settings: -> {
            position: 'bottom'
            limit: 10
            rules: [
                {
                    collection: Tags
                    field: 'name'
                    matchAll: true
                    template: Template.tag_result
                }
                ]
        }
        
    
        selected_item_tags: -> selected_item_tags.array()
    
    
    Template.item_cloud.events
        'click .select_tag': -> selected_item_tags.push @name
        'click .unselect_tag': -> selected_item_tags.remove @valueOf()
        'click #clear_tags': -> selected_item_tags.clear()
        
        'keyup #search': (e,t)->
            e.preventDefault()
            val = $('#search').val().toLowerCase().trim()
            switch e.which
                when 13 #enter
                    switch val
                        when 'clear'
                            selected_item_tags.clear()
                            $('#search').val ''
                        else
                            unless val.length is 0
                                selected_item_tags.push val.toString()
                                $('#search').val ''
                when 8
                    if val.length is 0
                        selected_item_tags.pop()
                        
        'autocompleteselect #search': (event, template, doc) ->
            # console.log 'selected ', doc
            selected_item_tags.push doc.name
            $('#search').val ''

