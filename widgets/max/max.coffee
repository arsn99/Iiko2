class Dashing.Max extends Dashing.Widget

  constructor: ->
    super
    @observe 'value', (value) ->
      $(@node).find(".max").val(value).trigger('change')
      
    @observe 'max', (max) ->
      $(@node).find(".max").trigger('configure', {'max': max})

  @accessor 'value', Dashing.AnimatedValue

  ready: ->
    meter = $(@node).find(".max")
    meter.attr("data-bgcolor", meter.css("background-color"))
    meter.attr("data-fgcolor", meter.css("color"))

    meter.knob()