Meteor.methods 
    enroll: (slug)->
        Meteor.users.update Meteor.userId(),
            $addToSet: courses: slug
            
            
    # # generate_upvoted_cloud: ->
    # #     match = {}
    # #     match.upvoters = $in: [Meteor.userId()]
    # #     match.type = 'facet'

        
    # #     upvoted_cloud = Docs.aggregate [
    # #         { $match: match }
    # #         { $project: tags: 1 }
    # #         { $unwind: '$tags' }
    # #         { $group: _id: '$tags', count: $sum: 1 }
    # #         { $sort: count: -1, _id: 1 }
    # #         { $limit: 100 }
    # #         { $project: _id: 0, name: '$_id', count: 1 }
    # #         ]
    # #     upvoted_list = (tag.name for tag in upvoted_cloud)
    # #     Meteor.users.update Meteor.userId(),
    # #         $set:
    # #             upvoted_cloud: upvoted_cloud
    # #             upvoted_list: upvoted_list



    # # generate_downvoted_cloud: ->
    # #     match = {}
    # #     match.downvoters = $in: [Meteor.userId()]
    # #     match.type = 'facet'
    # #     downvoted_cloud = Docs.aggregate [
    # #         { $match: match }
    # #         { $project: tags: 1 }
    #         { $unwind: '$tags' }
    #         { $group: _id: '$tags', count: $sum: 1 }
    #         { $sort: count: -1, _id: 1 }
    #         { $limit: 100 }
    #         { $project: _id: 0, name: '$_id', count: 1 }
    #         ]
    #     downvoted_list = (tag.name for tag in downvoted_cloud)
    #     Meteor.users.update Meteor.userId(),
    #         $set:
    #             downvoted_cloud: downvoted_cloud
    #             downvoted_list: downvoted_list
            
            
            
    add_doc: (body, parent_id, tags) ->
        result = Docs.insert
            body: body
            parent_id: parent_id
            tags: tags
        console.log result
                
                
                
    update_username:  (username) ->
        userId = Meteor.userId()
        if not userId
            throw new Meteor.Error(401, "Unauthorized")
        Accounts.setUsername(userId, username)
        return "Updated Username: #{username}"
        
        
    update_email: (new_email) ->
        userId = Meteor.userId();
        if !userId
            throw new Meteor.Error(401, "Unauthorized");
        Accounts.addEmail(userId, new_email);
        return "Updated Email to #{new_email}"
        
        
        
    # send_new_message_email: (user_id, message_id) ->
    #     user = Meteor.users.findOne user_id
    #     message = Messages.findOne message_id
    #     console.log "Sending new message email #{user.username}"
    #     SSR.compileTemplate 'message_email', Assets.getText('emailTemplates/message_email.html')
    #     email_data = 
    #         registrationFullName: device.adminName
    #         climberName: device.climberName
    #         adminemail_address: device.adminemail_address
    #     Meteor.defer ->
    #         Email.send
    #             to: "<#{email_address}>"
    #             from: 'Versaclimber'
    #             subject: 'Versaclimber Administration Invitation`'
    #             html: SSR.render('message_email', email_data)


    generate_personal_cloud: (user_id)->
        authored_cloud = Docs.aggregate [
            { $match: author_id: user_id }
            { $project: tags: 1 }
            { $unwind: '$tags' }
            { $group: _id: '$tags', count: $sum: 1 }
            { $sort: count: -1, _id: 1 }
            { $limit: 50 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        authored_list = (tag.name for tag in authored_cloud)
        Meteor.users.update Meteor.userId(),
            $set:
                authored_cloud: authored_cloud
                authored_list: authored_list


        upvoted_cloud = Docs.aggregate [
            { $match: up_voters: $in: [Meteor.userId()] }
            { $project: tags: 1 }
            { $unwind: '$tags' }
            { $group: _id: '$tags', count: $sum: 1 }
            { $sort: count: -1, _id: 1 }
            { $limit: 50 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        upvoted_list = (tag.name for tag in upvoted_cloud)
        Meteor.users.update Meteor.userId(),
            $set:
                upvoted_cloud: upvoted_cloud
                upvoted_list: upvoted_list


        downvoted_cloud = Docs.aggregate [
            { $match: down_voters: $in: [Meteor.userId()] }
            { $project: tags: 1 }
            { $unwind: '$tags' }
            { $group: _id: '$tags', count: $sum: 1 }
            { $sort: count: -1, _id: 1 }
            { $limit: 50 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        downvoted_list = (tag.name for tag in downvoted_cloud)
        Meteor.users.update Meteor.userId(),
            $set:
                downvoted_cloud: downvoted_cloud
                downvoted_list: downvoted_list

    tagify_date_time: (val)->
        console.log moment(val).format("dddd, MMMM Do YYYY, h:mm:ss a")
        minute = moment(val).minute()
        hour = moment(val).format('h')
        date = moment(val).format('Do')
        ampm = moment(val).format('a')
        weekdaynum = moment(val).isoWeekday()
        weekday = moment().isoWeekday(weekdaynum).format('dddd')

        month = moment(val).format('MMMM')
        year = moment(val).format('YYYY')

        date_array = [hour, minute, ampm, weekday, month, date, year]
        date_array = _.map(date_array, (el)-> el.toString().toLowerCase())
        # date_array = _.each(date_array, (el)-> console.log(typeof el))
        console.log date_array
        return date_array
        

    calculate_user_match: (username)->
        my_cloud = Meteor.user().cloud
        other_user = Meteor.users.findOne "profile.name": username
        console.log username
        console.log other_user
        Meteor.call 'generate_personal_cloud', other_user._id
        other_cloud = other_user.cloud

        my_linear_cloud = _.pluck(my_cloud, 'name')
        other_linear_cloud = _.pluck(other_cloud, 'name')
        intersection = _.intersection(my_linear_cloud, other_linear_cloud)
        console.log intersection


    create_message: (recipient_id, text, parent_id)->
        # console.log 'recipient_id', recipient_id
        
        found_conversation = Docs.findOne
            type: 'conversation'
            participant_ids: $all: [Meteor.userId(), recipient_id]
            
        if found_conversation 
            # console.log 'found conversation with id:', found_conversation._id
            convo_id = found_conversation._id
        else
            new_conversation_id = 
                Docs.insert
                    type: 'conversation'
                    participant_ids: [Meteor.userId(), recipient_id]
            # console.log 'convo NOT found, created new one with id:', new_conversation_id
            convo_id = new_conversation_id
        new_message_id = 
            new_message_id = Docs.insert
                type: 'message'
                group_id: convo_id
                parent_id: parent_id
                body: text
        return new_message_id
        
    verify_email: (user_id)->
        Accounts.sendVerificationEmail(user_id)        
        
        
        
    calculate_doc_responses: (doc_id)->
        doc = Docs.findOne doc_id
        doc_response = Docs.findOne parent_id: doc._id
        if doc_response
            Docs.update doc_id,
                $addToSet: responder_ids: Meteor.userId()
                
        # calculate children_count
        children_count = Docs.find(parent_id:doc_id).count()
        console.log 'children_count', children_count
        Docs.update doc_id,
            $set: children_count: children_count
            
    import_imdb: (imdb_id, doc_id)->
        # console.log imdb_id
        HTTP.call 'get', "http://www.omdbapi.com/?i=#{imdb_id}&apikey=9f3c9221", (err,res)->
            if err 
                console.error err
            else
                tags = []
                # console.log res.data.Type
                actors = res.data.Actors.split ','
                trimmed_lowered_actors = []
                for actor in actors
                    # console.log actor
                    tags.push actor.trim().toLowerCase()
                # tags.push trimmed_lowered_actors
                
                
                writers = res.data.Writer.split ','
                trimmed_lowered_writers = []
                for writer in writers
                    tags.push writer.trim().toLowerCase()
                # tags.push trimmed_lowered_actors
                
                languages = res.data.Language.split ','
                trimmed_lowered_languages = []
                for language in languages
                    tags.push language.trim().toLowerCase()
                # tags.push trimmed_lowered_actors
                
                
                genres = res.data.Genre.split ','
                trimmed_lowered_genres = []
                for genre in genres
                    tags.push genre.trim().toLowerCase()
                # tags.push trimmed_lowered_genres
                tags.push res.data.Type?.toLowerCase()
                # tags.push res.data.Production?.toLowerCase() 
                tags.push res.data.Director?.toLowerCase() 
                tags.push res.data.Rated?.toLowerCase() 
                tags.push res.data.Year?.toLowerCase()
                tags.push res.data.Country?.toLowerCase()
                tags.push res.data.imdbRating?.toLowerCase()

                
                Docs.update doc_id,
                    $set:
                        title: res.data.Title
                        link: res.data.Website
                        content: res.data.Plot
                        image_url: res.data.Poster
                    $addToSet: 
                        tags: $each: tags
                        
                        
    import_recipe: (recipe_id, doc_id)->
        console.log doc_id
        HTTP.call 'get', "https://api.edamam.com/search?r=#{recipe_id}&app_id=19ab4b92&app_key=77074c0869aeb48e9a1842182352d518",(err,res)->
            if err 
                console.error err
            else
                console.dir res.data[0]
                Docs.update doc_id,
                    $set:
                        title: res.data[0].label
                        image_url: res.data[0].image
                        link: res.data[0].url
                        content: res.data[0].ingredientLines
                        tags: res.data[0].tags
                        # response: res.data                        
