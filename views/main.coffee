$ ->

  root = $('#impress')[0]

  # Prevent undesirable clicks:
  #   clicking on map
  #   clicking on other countries' images that just happen to be in the vicinity.
  root.addEventListener 'click', (event) ->
    el = $(event.target)
    isMapStep = el.attr('id') == 'map'
    isChildOfMapStep = el.parents('#map').length >= 1
    if isMapStep or isChildOfMapStep
      event.stopImmediatePropagation()
      return

    isNotCurrentLocation = el.getLocation() != window.currentLocation
    isFoodStep = el.parents('.step.food').length >= 1
    if isFoodStep and window.currentLocation and isNotCurrentLocation
      event.stopImmediatePropagation()

  ##############
  # impress:init
  ##############

  # When initializing, mark instructionsShown as false.
  root.addEventListener 'impress:init', (event) ->
    window.instructionsShown = false

  api = impress()
  api.init()

  ###################
  # impress:stepenter
  ###################

  # Set background image to image for current location.
  # Add/Remove class to sidebar link for current location.
  root.addEventListener 'impress:stepenter', (event) ->
    step = $(event.target)
    locationName = step.data('location')

    window.currentLocation = locationName

    if locationName
      setLocationBackgroundImage(locationBackgroundImageProperty(locationName))
      addCurrentLocationNavClasses(locationName)
    else
      setLocationBackgroundImage('none')
      removeCurrentLocationNavClasses()

  # Show instructions if we're on the map step for the first time.
  root.addEventListener 'impress:stepenter', (event) ->
    step = $(event.target)
    if step.attr('id') == 'map' and !window.instructionsShown
      toggleInstructions()

  # A smoother transition from end_Aachen to the_end.
  root.addEventListener 'impress:stepenter', (even) ->
    step = $(event.target)
    if step.attr('id') == 'end_Aachen'
      setLocationBackgroundImage('none')

  ########################
  # Hide/Show instructions
  ########################

  # Remove instructions when leaving step.
  root.addEventListener 'impress:stepleave', (event) ->
    hideInstructions()

  # Show instructions when clicked.
  $('#showInstructions').click (event) ->
    toggleInstructions()

  # Remove instructions when clicked.
  $('#instructions').click (event) ->
    hideInstructions()

  toggleInstructions = ->
    window.instructionsShown = true
    $('#instructions').fadeToggle()

  hideInstructions = ->
    $('#instructions').fadeOut()

  ###########
  # Anja pics
  ###########

  anjaFoods = [
    'Aachen-Maronencremesuppe',
    'Aachen-Schokoecken',
    'Aachen-Bratapfel',
    'Aachen-Apple__berry_pie',
    'Aachen-Potato_soup'
  ]
  $.each anjaFoods, (idx, foodName) ->
    food = $("##{foodName}")
    note = '<div class="anjaNote">' +
           '* Wonderfully prepared by ' +
           '<a href="http://foodstories.de" target="blank">Anja</a>' +
           '</div>'
    food.find('.name').after note

  #########
  # Helpers
  #########

  setLocationBackgroundImage = (value) ->
    body = $('#outerImpress')
    unless body.css('background-image') == value
      body.css 'background-image', value

  addCurrentLocationNavClasses = (locationName) ->
    removeCurrentLocationNavClasses()
    $("#location_#{locationName}").addClass('current')

  removeCurrentLocationNavClasses = ->
    $("nav .location").removeClass('current')

  locationBackgroundImagePath = (locationName) ->
    "https://s3.amazonaws.com/UK_Germany_food/location_backgrounds/#{locationName}.jpg"

  locationBackgroundImageProperty = (locationName) ->
    "url(#{locationBackgroundImagePath(locationName)})"

  # Preload location background images.
  $('.step.location').each ->
    locationName = $(this).data('location')
    src = locationBackgroundImagePath(locationName)
    img = new Image()
    img.src = src

###############
# jQery Helpers
###############

# Get the location of an element from either itself or a parent step.
$.fn.getLocation = ->
  ownLocation = $(this).data('location')
  if ownLocation
    return ownLocation
  else
    $(this).parents('.step').data('location')
