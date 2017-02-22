if Meteor.isClient
    Template.edit_location.onRendered ->
        @autorun ->
            if GoogleMaps.loaded()
                $('#place').geocomplete().bind 'geocode:result', (event, result) ->
                    # console.log result.geometry.location.lat()
                    Meteor.call 'updatelocation', docId, result, ->

    
    
    Template.edit_location.events
        'change #location': ->
            doc_id = FlowRouter.getParam('doc_id')
            location = $('#location').val()
    
            Docs.update doc_id,
                $set: location: location



        'click .clearAddress': ->
            tagsWithoutAddress = _.difference(@tags, @addresstags)
            Docs.update FlowRouter.getParam('docId'),
                $set:
                    tags: tagsWithoutAddress
                    addresstags: []
                    locationob: null
            $('#place').val('')


if Meteor.isServer
    updatelocation: (doc_id, result)->
        addresstags = (component.long_name for component in result.address_components)
        loweredAddressTags = _.map(addresstags, (tag)->
            tag.toLowerCase()
            )

        #console.log addresstags

        doc = Docs.findOne doc_id
        tagsWithoutAddress = _.difference(doc.tags, doc.addresstags)
        tagsWithNew = _.union(tagsWithoutAddress, loweredAddressTags)

        Docs.update doc_id,
            $set:
                tags: tagsWithNew
                locationob: result
                addresstags: loweredAddressTags

