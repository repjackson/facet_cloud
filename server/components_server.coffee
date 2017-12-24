Meteor.methods
    mark_read: (doc_id)->
        Docs.update doc_id,
            $addToSet: read_by: Meteor.userId()
        
        
    mark_unread: (doc_id)->
        Docs.update doc_id,
            $pull: read_by: Meteor.userId()

    approve_bug: (bug_id)->
        bug = Docs.findOne bug_id
        # console.log bug
        Docs.update bug_id,
            $set:approved: true
        Docs.insert
            type: 'notification'
            recipient_id: bug.author_id
            notification_type: 'bug_approval'
            content: "<p>Your bug report <br>#{bug.body}<br> has been approved.  Your account has been credited 5 points.<br> You can view the transaction <a href={transaction_link}>here</a>."
            
    calculate_child_count: (doc_id)->
        child_count = Docs.find(parent_id: doc_id).count()
        Docs.update doc_id, 
            $set: child_count: child_count
        
        
        
        
Meteor.publish 'read_by', (doc_id)->
    doc = Docs.findOne doc_id
    if doc and doc.read_by
        Meteor.users.find
            _id: $in: doc.read_by
            
Meteor.publish 'feedback_requested', (doc_id)->
    Docs.find
        type: 'transaction'
        parent_id: 'AHQnLo2eDES57mzJD'
        author_id: Meteor.userId()
        object_id: doc_id
            
Meteor.publish 'person_tags', (username)->
    user = Meteor.users.findOne username: username
    Docs.find
        type: 'person_tags'
        parent_user_id: user._id
        
Meteor.publish 'document_tags', (doc_id)->
    Docs.find
        type: 'tag_rating'
        parent_id: doc_id        
        
        
Meteor.publish 'response_count', (doc_id)->
    Counts.publish this, 'response_count', 
        Docs.find(
            parent_id: doc_id
        )
    return undefined    # otherwise coffeescript returns a Counts.publish
        
        