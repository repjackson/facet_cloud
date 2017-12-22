Template.view_tags.helpers
    theme_tag_class: -> if @valueOf() in selected_theme_tags.array() then 'blue' else 'basic'
    location_tag_class: -> if @valueOf() in selected_location_tags.array() then 'blue' else 'basic'
    intention_tag_class: -> if @valueOf() in selected_intention_tags.array() then 'blue' else 'basic'

Template.view_tags.events
    'click .theme_tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())
    'click .location_tag': -> if @valueOf() in selected_location_tags.array() then selected_location_tags.remove(@valueOf()) else selected_location_tags.push(@valueOf())
    'click .intention_tag': -> if @valueOf() in selected_intention_tags.array() then selected_intention_tags.remove(@valueOf()) else selected_intention_tags.push(@valueOf())
