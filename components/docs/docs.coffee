@Tags = new Meteor.Collection 'tags'
@Location_tags = new Meteor.Collection 'location_tags'
@Intention_tags = new Meteor.Collection 'intention_tags'
@Timestamp_tags = new Meteor.Collection 'timestamp_tags'
@Watson_keywords = new Meteor.Collection 'watson_keywords'
@People_tags = new Meteor.Collection 'people_tags'
@Docs = new Meteor.Collection 'docs'
@Author_ids = new Meteor.Collection 'author_ids'
@Participant_ids = new Meteor.Collection 'participant_ids'
@Upvoter_ids = new Meteor.Collection 'upvoter_ids'

# @Component =
#     create: (spec) ->
#         React.createFactory React.createClass(spec)


Docs.before.insert (userId, doc)=>
    timestamp = Date.now()
    doc.timestamp = timestamp
    # console.log moment(timestamp).format("dddd, MMMM Do YYYY, h:mm:ss a")
    date = moment(timestamp).format('Do')
    weekdaynum = moment(timestamp).isoWeekday()
    weekday = moment().isoWeekday(weekdaynum).format('dddd')


    month = moment(timestamp).format('MMMM')
    year = moment(timestamp).format('YYYY')

    date_array = [weekday, month, date, year]
    if _
        date_array = _.map(date_array, (el)-> el.toString().toLowerCase())
    # date_array = _.each(date_array, (el)-> console.log(typeof el))
    # console.log date_array
        doc.timestamp_tags = date_array

    doc.author_id = Meteor.userId()
    doc.tag_count = doc.tags?.length
    doc.points = 0
    # doc.components = {}
    doc.read_by = [Meteor.userId()]
    doc.upvoters = []
    doc.downvoters = []
    doc.child_fields = ['title']
    doc.published = 0
    doc.child_view = 'card_view'
    doc.access = 'available'
    doc.completion_type = 'none'
    return

Docs.after.update ((userId, doc, fieldNames, modifier, options) ->
    if doc.tags
        doc.tag_count = doc.tags.length
    # console.log doc
    # doc.child_count = Meteor.call('calculate_child_count', doc._id)
    # console.log Meteor.call 'calculate_child_count', doc._id, (err, res)-> return res
), fetchPrevious: true


# Docs.before.update (userId, doc, fieldNames, modifier, options) ->
#   modifier.$set = modifier.$set or {}
#   modifier.$set.tag_count = doc.tags.length
#   return


Docs.after.insert (userId, doc)->
    if doc.parent_id
        Meteor.call 'calculate_child_count', doc.parent_id
    
    
Docs.after.remove (userId, doc)->
    if doc.parent_id
        Meteor.call 'calculate_child_count', doc.parent_id



Docs.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()
    is_published: -> @published is 1
    is_anonymous: -> @published is 0
    is_private: -> @published is -1
    
    only_child: -> Docs.findOne parent_id: @_id
    parent: -> Docs.findOne @parent_id
    recipient: -> Meteor.users.findOne @recipient_id
    subject: -> Meteor.users.findOne @subject_id
    object: -> Docs.findOne @object_id
    has_children: -> if Docs.findOne(parent_id: @_id) then true else false
    responded: -> 
        response = Docs.findOne
            author_id: Meteor.userId()
            parent_id: @_id
            type: 'response'
        if response then true else false

    completed: -> 
        if @completion_type is 'none' then true
        else
            if @completed_by and Meteor.userId() in @completed_by
                true 
            else false

    can_access: ->
        if @access is 'available' then true
        else if @access is 'admin_only'
            if Roles.userIsInRole(Meteor.userId(), 'admin') and Session.equals('admin_mode', true) then true else false
        else if Session.equals 'admin_mode', true then true
        else
            previous_number = @number - 1
            previous_doc = 
                Docs.findOne
                    parent_id: @parent_id
                    number: previous_number
            if previous_doc
                if previous_doc.completed_by and Meteor.userId() in previous_doc.completed_by then true else false
            else
                true
    readers: ->
        if @read_by
            readers = []
            for reader_id in @read_by
                readers.push Meteor.users.findOne reader_id
            readers
        else []




Meteor.methods
    add: (tags=[])->
        id = Docs.insert {}
        return id
    add_checkin: (tags=[])->
        id = Docs.insert
            tags: tags
            type: 'checkin'
        return id


    update_rating: (session_id, rating, question_id)->
        Docs.update {_id:session_id,  "ratings.question_id": question_id},
            $set: "ratings.$.rating": rating


    calculate_completion: (doc_id) ->
        doc = Docs.findOne doc_id
        # console.log doc.completion_type
        if doc.completion_type is 'mark_read'
            if Meteor.userId() in doc.read_by
                Docs.update doc_id, 
                    $addToSet: completed_by: Meteor.userId()
            else
                Docs.update doc_id, 
                    $pull: completed_by: Meteor.userId()
        if doc.completion_type is 'response'
            # console.log 'response completion'
            response_docs = 
                Docs.find(
                    parent_id: doc_id
                    # author_id: Meteor.userId()
                    ).fetch()
            if response_docs
                # console.log 'response docs found', response_docs
                for response_doc in response_docs
                    Docs.update doc_id, 
                        $addToSet: completed_by: response_doc.author_id
            # else
            #     Docs.update doc_id, 
            #         $pull: completed_by: Meteor.userId()
        if doc.completion_type is 'check_children'
            children_array = Docs.find(parent_id: doc_id).fetch()
            children_count = Docs.find(parent_id: doc_id).count()
            for user in Meteor.users.find().fetch()
                child_completion_count = 0
                for child in children_array
                    # if Meteor.userId() in child.completed_by
                    if user._id in child.completed_by
                        child_completion_count++
                # console.log 'child_completion_count', child_completion_count
                # console.log 'children_count', children_count
                if child_completion_count is children_count
                    Docs.update doc_id, 
                        $addToSet: completed_by: user._id
                        # $addToSet: completed_by: Meteor.userId()
                else
                    Docs.update doc_id, 
                        $pull: completed_by: user._id
                        # $pull: completed_by: Meteor.userId()
                
        next_number = doc.number + 1
        older_sibling = 
            Docs.findOne 
                parent_id: doc.parent_id
                number: next_number
        unless older_sibling
            Meteor.call 'calculate_completion', doc.parent_id


FlowRouter.notFound =
    action: ->
        BlazeLayout.render 'layout', 
            main: 'not_found'


FlowRouter.route '/', action: ->
    BlazeLayout.render 'layout', 
        main: 'home'



Meteor.users.helpers
    name: -> 
        if @profile?.first_name and @profile?.last_name
            "#{@profile.first_name}  #{@profile.last_name}"
        else
            "#{@username}"
    last_login: -> 
        moment(@status?.lastLogin.date).fromNow()

    five_tags: -> if @tags then @tags[0..3]
    
            
            
Meteor.methods
    mark_complete: (doc)->
        if doc.completed_ids and Meteor.userId() in doc.completed_ids
            Docs.update doc._id,
                $pull: completed_ids: Meteor.userId()
                $inc: completed_count: -1
        else
            Docs.update doc._id,
                $addToSet: completed_ids: Meteor.userId()
                $inc: completed_count: 1
    
    
    bookmark: (doc)->
        if doc.bookmarked_ids and Meteor.userId() in doc.bookmarked_ids
            Docs.update doc._id,
                $pull: bookmarked_ids: Meteor.userId()
                $inc: bookmarked_count: -1
        else
            Docs.update doc._id,
                $addToSet: bookmarked_ids: Meteor.userId()
                $inc: bookmarked_count: 1
    
    pin: (doc)->
        if doc.pinned_ids and Meteor.userId() in doc.pinned_ids
            Docs.update doc._id,
                $pull: pinned_ids: Meteor.userId()
                $inc: pinned_count: -1
        else
            Docs.update doc._id,
                $addToSet: pinned_ids: Meteor.userId()
                $inc: pinned_count: 1
    
    subscribe: (doc)->
        if doc.subscribed_ids and Meteor.userId() in doc.subscribed_ids
            Docs.update doc._id,
                $pull: subscribed_ids: Meteor.userId()
                $inc: subscribed_count: -1
        else
            Docs.update doc._id,
                $addToSet: subscribed_ids: Meteor.userId()
                $inc: subscribed_count: 1
    
