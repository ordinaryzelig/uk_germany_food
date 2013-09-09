(function() {

  $(function() {
    var addCurrentLocationNavClasses, anjaFoods, api, hideInstructions, locationBackgroundImagePath, locationBackgroundImageProperty, removeCurrentLocationNavClasses, root, setLocationBackgroundImage, toggleInstructions;
    root = $('#impress')[0];
    root.addEventListener('click', function(event) {
      var el, isChildOfMapStep, isFoodStep, isMapStep, isNotCurrentLocation;
      el = $(event.target);
      isMapStep = el.attr('id') === 'map';
      isChildOfMapStep = el.parents('#map').length >= 1;
      if (isMapStep || isChildOfMapStep) {
        event.stopImmediatePropagation();
        return;
      }
      isNotCurrentLocation = el.getLocation() !== window.currentLocation;
      isFoodStep = el.parents('.step.food').length >= 1;
      if (isFoodStep && window.currentLocation && isNotCurrentLocation) {
        return event.stopImmediatePropagation();
      }
    });
    root.addEventListener('impress:init', function(event) {
      return window.instructionsShown = false;
    });
    api = impress();
    api.init();
    root.addEventListener('impress:stepenter', function(event) {
      var locationName, step;
      step = $(event.target);
      locationName = step.data('location');
      window.currentLocation = locationName;
      if (locationName) {
        setLocationBackgroundImage(locationBackgroundImageProperty(locationName));
        return addCurrentLocationNavClasses(locationName);
      } else {
        setLocationBackgroundImage('none');
        return removeCurrentLocationNavClasses();
      }
    });
    root.addEventListener('impress:stepenter', function(event) {
      var step;
      step = $(event.target);
      if (step.attr('id') === 'map' && !window.instructionsShown) {
        return toggleInstructions();
      }
    });
    root.addEventListener('impress:stepenter', function(even) {
      var step;
      step = $(event.target);
      if (step.attr('id') === 'end_Aachen') {
        return setLocationBackgroundImage('none');
      }
    });
    root.addEventListener('impress:stepleave', function(event) {
      return hideInstructions();
    });
    $('#showInstructions').click(function(event) {
      return toggleInstructions();
    });
    $('#instructions').click(function(event) {
      return hideInstructions();
    });
    toggleInstructions = function() {
      window.instructionsShown = true;
      return $('#instructions').fadeToggle();
    };
    hideInstructions = function() {
      return $('#instructions').fadeOut();
    };
    anjaFoods = ['Aachen-Maronencremesuppe', 'Aachen-Schokoecken', 'Aachen-Bratapfel', 'Aachen-Apple__berry_pie', 'Aachen-Potato_soup'];
    $.each(anjaFoods, function(idx, foodName) {
      var food, note;
      food = $("#" + foodName);
      note = '<div class="anjaNote">' + '* Wonderfully prepared by ' + '<a href="http://foodstories.de" target="blank">Anja</a>' + '</div>';
      return food.find('.name').after(note);
    });
    setLocationBackgroundImage = function(value) {
      var body;
      body = $('#outerImpress');
      if (body.css('background-image') !== value) {
        return body.css('background-image', value);
      }
    };
    addCurrentLocationNavClasses = function(locationName) {
      removeCurrentLocationNavClasses();
      return $("#location_" + locationName).addClass('current');
    };
    removeCurrentLocationNavClasses = function() {
      return $("nav .location").removeClass('current');
    };
    locationBackgroundImagePath = function(locationName) {
      return "https://s3.amazonaws.com/UK_Germany_food/location_backgrounds/" + locationName + ".jpg";
    };
    locationBackgroundImageProperty = function(locationName) {
      return "url(" + (locationBackgroundImagePath(locationName)) + ")";
    };
    return $('.step.location').each(function() {
      var img, locationName, src;
      locationName = $(this).data('location');
      src = locationBackgroundImagePath(locationName);
      img = new Image();
      return img.src = src;
    });
  });

  $.fn.getLocation = function() {
    var ownLocation;
    ownLocation = $(this).data('location');
    if (ownLocation) {
      return ownLocation;
    } else {
      return $(this).parents('.step').data('location');
    }
  };

}).call(this);
