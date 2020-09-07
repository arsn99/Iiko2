class Dashing.MeterRg extends Dashing.Widget

  @accessor 'value', Dashing.AnimatedValue

  constructor: ->
    super
    @observe 'value', (value) ->
      $(@node).find(".meter").val(value).trigger('change')

  ready: ->
    meter = $(@node).find(".meter")
    meter.attr("data-bgcolor", meter.css("background-color"))
    meter.attr("data-fgcolor", meter.css("color"))
	
    meter.knob()
    @onData(this)

  onData: (data) ->
    if not data.value?
      $(@node).removeClass('good')
      $(@node).removeClass('bad')
    else if data.value > @get('threshold')
      $(@node).addClass('bad')
      $(@node).removeClass('good')
    else
      $(@node).addClass('good')
      $(@node).removeClass('bad')
