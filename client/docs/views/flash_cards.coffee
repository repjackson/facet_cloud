Template.flash_card.onRendered ->
    Meteor.setTimeout (->
        $('.shape').shape();
    ), 2000


Template.flash_cards.helpers
    flash_cards: ->
        Docs.find {
            parent_id: FlowRouter.getParam 'doc_id'
            upvoters: $nin: [Meteor.userId()]
        }, { 
            limit: 1
        }

Template.flash_card.events
    'click .flip': (e,t)->
        $('.shape').shape('flip over')
        # $(e.currentTarget).closest('.shape')
        # .val()
