# Reference jQuery
$ = jQuery

# Adds plugin object to jQuery
$.fn.extend
  # Change pluginName to your plugin's name.
  hSlider: (options) ->
    # Default settings
    settings =
      debug: false
      slide_timing: 1
      loop_timing: 5000
      slide_effect: "cubic-bezier(1,.34,.83,.9)"
      velocity_is_on: true

    # Merge default settings with options.
    settings = $.extend settings, options

    # Simple logger.
    log = (msg) ->
      console?.log msg if settings.debug

    # _Insert magic here._
    return @each ()->

      $this = $(this)
      $container = $(".container", $this)
      $slideUl = $('.slide', $this)
      $slides = $(".slide li", $this)
      $interactions = $(".next, .before", $this)
      $signature = $("ul.signature", $this)

      # css3 transitions
      # on - off only if
      # velocity.js is not
      # enabled
      transitionOn = ->
        if !settings.velocity_is_on
          $slideUl.css
            "webkit-transition": "all #{settings.slide_timing}s #{settings.slide_effect}"
            "moz-transition":    "all #{settings.slide_timing}s #{settings.slide_effect}"
            "ms-transition":     "all #{settings.slide_timing}s #{settings.slide_effect}"
            "o-transition":      "all #{settings.slide_timing}s #{settings.slide_effect}"
            "transition":        "all #{settings.slide_timing}s #{settings.slide_effect}"
        return

      transitionOff = ->
        if !settings.velocity_is_on
          $slideUl.css
            "webkit-transition": "none"
            "moz-transition":    "none"
            "ms-transition":     "none"
            "o-transition":      "none"
            "transition":        "none"
          return

      # prevent the vertical
      # swipe with event jquery.event.swipe
      $this.on "movestart", (e) ->
        e.preventDefault()  if (e.distX > e.distY and e.distX < -e.distY) or (e.distX < e.distY and e.distX > -e.distY)
        return

      # get the container width and
      # the number of the slides
      frameWidth = $container.innerWidth()
      slidesNumber = $slides.size()

      # calculate the complete width of the whole UL
      # plus one slide which is used to the back/forward
      # animation when it's about first or last slide
      totalFrameWidth = frameWidth * ( slidesNumber + 1 )

      # place the right width to UL and Li elements
      $slideUl.css "width", totalFrameWidth
      $slides.css "width", frameWidth

      # keep the correct proportions during
      # the responsive interactions
      $(window).resize ->
        frameWidth = $container.innerWidth()
        totalFrameWidth = frameWidth * ( slidesNumber + 1 )
        $slideUl.css "width", totalFrameWidth
        $slides.css "width", frameWidth
        $slideUl.css "margin-left", - (forwardIndex * frameWidth)
        transitionOff()



      # Generate the exact number of the
      # dotted indicators and relative
      # control class
      slideIndex = 0
      while (slideIndex < slidesNumber)
        if slideIndex is 0
          $signature.append("<li id=\"signature-#{slideIndex}\" class=\"lightsOn\"></li>")
        else
          $signature.append("<li id=\"signature-#{slideIndex}\"></li>")
        slideIndex++



      theDottedConnection = (elem) ->
        log "this is the slide number #{elem}"
        $("li", $signature).removeClass("lightsOn")
        if elem is slidesNumber
          $("li#signature-0", $this).addClass("lightsOn")
          log "this is max"
        else if elem < 0
          log "this is min"
          $("li#signature-#{slidesNumber - 1}", $this).addClass("lightsOn")
        else
          $("li#signature-#{elem}", $this).addClass("lightsOn")


      # Place a control class
      # to prevent overlapped animations
      checkTheAction = () ->
        log "prevent"
        $interactions.addClass("active")
        setTimeout ->
          $interactions.removeClass("active")
        , settings.slide_timing * 1000



      # the index variable to use for
      # the whole animation
      forwardIndex = 0

      # the complete forward animation
      moveForward = () ->
        transitionOn()
        checkTheAction()
        forwardIndex++
        theDottedConnection(forwardIndex)
        log forwardIndex
        if forwardIndex < slidesNumber

          # check if velocity is enabled
          # than start the animation accordingly
          if settings.velocity_is_on
            $slideUl.velocity
              "margin-left": - (forwardIndex * frameWidth)
            ,
            duration: settings.slide_timing * 1000
            easing: settings.slide_effect
          else
            $slideUl.css "margin-left", - (forwardIndex * frameWidth)

        else
          $("li:first-child", $slideUl).clone().insertAfter($("li:last", $slideUl))

          # check if velocity is enabled
          # than start the animation accordingly
          if settings.velocity_is_on
            $slideUl.velocity
              "margin-left": - (forwardIndex * frameWidth)
            ,
            duration: settings.slide_timing * 1000
            easing: settings.slide_effect
          else
            $slideUl.css "margin-left", - (forwardIndex * frameWidth)

          setTimeout ->
            transitionOff()
            $slideUl.css "margin-left", 0
            $("li:last-child", $slideUl).remove()
          , settings.slide_timing * 1000
          forwardIndex = 0

      # the backward animation
      moveBackward = () ->
        transitionOn()
        checkTheAction()
        forwardIndex--
        theDottedConnection(forwardIndex)
        log forwardIndex
        if  forwardIndex >= 0

          # check if velocity is enabled
          # than start the animation accordingly
          if settings.velocity_is_on
            $slideUl.velocity
              "margin-left": - (forwardIndex * frameWidth)
            ,
            duration: settings.slide_timing * 1000
            easing: settings.slide_effect
          else
            $slideUl.css "margin-left", - (forwardIndex * frameWidth)

        else
          forwardIndex = slidesNumber - 1
          $("li:last-child", $slideUl).clone().insertBefore($("li:first-child", $slideUl))
          transitionOff()
          $slideUl.css "margin-left", - frameWidth
          setTimeout ->
            transitionOn()
            $slideUl.css "margin-left", 0
            setTimeout ->
              transitionOff()
              $slideUl.css "margin-left", - ( (slidesNumber - 1) * frameWidth )
              $("li:first-child", $slideUl).remove()
            , settings.slide_timing * 1000
          , 10



      # Check if there is the control class
      # placed at line 59
      preventTheAction = () ->
        if $interactions.hasClass "active"
          return false
        else
          return true



      # the click interactions
      # forward and backward
      $(".next").on "click", ->
        if preventTheAction()
          moveForward()

      $(".before").on "click", ->
        if preventTheAction()
          moveBackward()


      $container
        .on "swipeleft",   (e) ->
          if preventTheAction()
            moveForward()
        .on "swiperight", (e) ->
          if preventTheAction()
            moveBackward()


      # the click on dotted things
      # interaction, which means
      # every dot is linked to a
      # slide and will slide to the
      # correct position

      $("li", $signature). on "click", ->
        transitionOn()
        checkTheAction()
        theSigId = $(this).attr "id"
        theSigSliced = theSigId.slice(-1)
        forwardIndex = theSigSliced
        theDottedConnection(forwardIndex)

        # check if velocity is enabled
        # than start the animation accordingly
        if settings.velocity_is_on
          $slideUl.velocity
            "margin-left": - (forwardIndex * frameWidth)
        else
          $slideUl.css "margin-left", - (forwardIndex * frameWidth)


      # auto loop start, to run
      # the animation automatically
      theAutoLoop = setInterval ->
        if preventTheAction()
          moveForward()
          return
      , settings.loop_timing


      # kill the loop when inside the main
      # div, start again when mouseleave
      $(document).on
        mouseenter:  ->
          log "quit"
          clearInterval(theAutoLoop)
        mouseleave: ->
          log "out"
          theAutoLoop = setInterval ->
            if preventTheAction()
              moveForward()
              return
          , settings.loop_timing
      , ".container", $this
