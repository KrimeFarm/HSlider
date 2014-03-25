# Reference jQuery
$ = jQuery

# Adds plugin object to jQuery
$.fn.extend
  # Change pluginName to your plugin's name.
  hSlider: (options) ->
    # Default settings
    settings =
      debug: true
      slide_timing: 1
      slide_effect: "cubic-bezier(1,.34,.83,.9)"

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
      $signature = $("ul.signature", $this)

      # css3 transitions
      # on - off
      transitionOn = ->
        $slideUl.css
          "webkit-transition": "all #{settings.slide_timing}s #{settings.slide_effect}"
          "moz-transition":    "all #{settings.slide_timing}s #{settings.slide_effect}"
          "ms-transition":     "all #{settings.slide_timing}s #{settings.slide_effect}"
          "o-transition":      "all #{settings.slide_timing}s #{settings.slide_effect}"
          "transition":        "all #{settings.slide_timing}s #{settings.slide_effect}"
        return

      transitionOff = ->
        $slideUl.css
          "webkit-transition": "none"
          "moz-transition":    "none"
          "ms-transition":     "none"
          "o-transition":      "none"
          "transition":        "none"
        return

      frameWidth = $container.innerWidth()
      slidesNumber = $slides.size()

      totalFrameWidth = frameWidth * ( slidesNumber + 1 )

      $slideUl.css "width", totalFrameWidth
      $slides.css "width", frameWidth

      $(window).resize ->
        frameWidth = $container.innerWidth()
        totalFrameWidth = frameWidth * slidesNumber
        $slideUl.css "width", totalFrameWidth
        $slides.css "width", frameWidth


      slideIndex = 0
      while (slideIndex < slidesNumber)
        $signature.append("<li></li>")
        slideIndex++

      moveForward = (index) ->
        if index < slidesNumber
          $slideUl.css "margin-left", - (index * frameWidth)
        else
          $("li:first-child", $slideUl).clone().insertAfter($("li:last", $slideUl))
          $slideUl.css "margin-left", - (index * frameWidth)
          setTimeout ->
            transitionOff()
            $slideUl.css "margin-left", 0
            $("li:last", $slideUl).remove()
          , settings.slide_timing * 1000

      moveBackward = (index) ->
        $slideUl.css "margin-left", (index * frameWidth)

      forwardIndex = 0

      $(".next").on "click", ->
        transitionOn()
        if forwardIndex < slidesNumber
          forwardIndex++
        else
          forwardIndex = 1
        moveForward(forwardIndex)

      $(".before").on "click", ->
        transitionOn()
        forwardIndex--
        moveBackward(forwardIndex)

      if jQuery.browser.mobile
        $slides.swipe
          swipeRight: ->
            transitionOn()
            forwardIndex++
            moveForward(forwardIndex)
          swipeLeft: ->
            transitionOn()
            forwardIndex--
            moveBackward(forwardIndex)

