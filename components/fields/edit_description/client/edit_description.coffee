Template.edit_description.events
    'blur .froala-container': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        doc_id = FlowRouter.getParam('doc_id')
        Docs.update doc_id,
            $set: 
                description: html


    # 'blur #description': (e,t)->
    #     description = t.$('#description').val()
    #     # console.log description
        
    #     doc_id = FlowRouter.getParam('doc_id')

    #     Docs.update doc_id,
    #         $set: 
    #             description: description


    # 'blur #snippet': (e,t)->
    #     text = $('#snippet').val()
    #     doc_id = FlowRouter.getParam('doc_id')

    #     Docs.update doc_id,
    #         $set: 
    #             snippet: text


    # 'click #upload_widget_opener': (e,t)->
    #     cloudinary.openUploadWidget {
    #         cloud_name: 'facet'
    #         upload_preset: 'rodonu5a'
    #     }, (error, result) ->
    #         # console.log error, result
    #         Docs.update FlowRouter.getParam('doc_id'),
    #             $addToSet: image_array: $each: result




Template.edit_description.helpers
    getFEContext: ->
        @current_doc = Docs.findOne FlowRouter.getParam('doc_id')
        self = @
        {
            _value: self.current_doc.description
            _keepMarkers: true
            _className: 'froala-reactive-meteorized-override'
            toolbarInline: false
            initOnClick: false
            toolbarButtons:
                [
                  'fullscreen'
                  'bold'
                  'italic'
                  'underline'
                  'strikeThrough'
                #   'subscript'
                #   'superscript'
                  '|'
                #   'fontFamily'
                  'fontSize'
                  'color'
                #   'inlineStyle'
                #   'paragraphStyle'
                  '|'
                  'paragraphFormat'
                  'align'
                  'formatOL'
                  'formatUL'
                  'outdent'
                  'indent'
                  'quote'
                #   '-'
                  'insertLink'
                #   'insertImage'
                #   'insertVideo'
                #   'embedly'
                #   'insertFile'
                #   'insertTable'
                #   '|'
                  'emoticons'
                #   'specialCharacters'
                #   'insertHR'
                  'selectAll'
                  'clearFormatting'
                  '|'
                #   'print'
                #   'spellChecker'
                #   'help'
                  'html'
                #   '|'
                  'undo'
                  'redo'
                ]
            imageInsertButtons: ['imageBack', '|', 'imageByURL']
            tabSpaces: false
            height: 300
        }
