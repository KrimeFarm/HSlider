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



      forwardIndex = 0
      moveForward = () ->
        forwardIndex++
        log forwardIndex
        if forwardIndex < slidesNumber
          transitionOn()
          $slideUl.css "margin-left", - (forwardIndex * frameWidth)
        else
          $("li:first-child", $slideUl).clone().insertAfter($("li:last", $slideUl))
          $slideUl.css "margin-left", - (forwardIndex * frameWidth)
          setTimeout ->
            transitionOff()
            $slideUl.css "margin-left", 0
            $("li:last-child", $slideUl).remove()
          , settings.slide_timing * 1000
          forwardIndex = 0

      moveBackward = () ->
        forwardIndex--
        log forwardIndex
        if  forwardIndex >= 0
          transitionOn()
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



      $(".next").on "click", ->
        moveForward()

      $(".before").on "click", ->
        moveBackward()



      if jQuery.browser.mobile
        $slides.swipe
          swipeRight: ->
            moveForward()
          swipeLeft: ->
            moveBackward()

