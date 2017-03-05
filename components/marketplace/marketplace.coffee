FlowRouter.route '/marketplace', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'marketplace'

FlowRouter.route '/item/edit/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_item'

FlowRouter.route '/item/view/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'item_page'



if Meteor.isClient
    Template.items.onRendered ->
        $('#marketplace_slider').layerSlider
            autoStart: true
     
        
    Template.marketplace.events
        'click #add_item': ->
            id = Docs.insert 
                type: 'item'
            FlowRouter.go "/item/edit/#{id}"
    
    
    
    
    Template.items.onCreated -> 
        @autorun -> Meteor.subscribe('selected_items', selected_item_tags.array())
    
    
    Template.items.helpers
        items: ->
            Docs.find
                type: 'item'
    
    
    
    Template.item.helpers
    
        item_tag_class: -> if @valueOf() in selected_item_tags.array() then 'primary' else 'basic'
    
    
    
    Template.item.events
        # 'click .item_tag': ->
        #     if @valueOf() in selected_item_tags.array() then selected_item_tags.remove @valueOf() else selected_item_tags.push @valueOf()


if Meteor.isServer
    Meteor.publish 'selected_items', (selected_item_tags)->
        
        self = @
        match = {}
    
        if selected_item_tags.length > 0 then match.tags = $all: selected_item_tags
        match.type = 'item'
        
        Docs.find match
    
    
    
    
    Meteor.publish 'items', ->
        Docs.find type: 'item'
    
    Meteor.publish 'item_tags', (selected_item_tags)->
        self = @
        match = {}
        if selected_item_tags.length > 0 then match.tags = $all: selected_item_tags
        match.type = 'item'
        
    
    
        cloud = Docs.aggregate [
            { $match: match }
            { $project: "tags": 1 }
            { $unwind: "$tags" }
            { $group: _id: "$tags", count: $sum: 1 }
            { $match: _id: $nin: selected_item_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
    
        cloud.forEach (tag, i) ->
            self.added 'item_tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i
    
        self.ready()
    