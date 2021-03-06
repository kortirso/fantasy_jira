# frozen_string_literal: true

module ApplicationHelper
  def react_component(component_name, **props)
    content_tag(
      'div',
      id:    props[:component_id],
      class: props[:component_class],
      data:  {
        react_component: component_name,
        props:           props.except(:component_id).to_json
      }
    ) { '' }
  end
end
