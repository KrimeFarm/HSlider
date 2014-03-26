(function() {
  var $;

  $ = jQuery;

  $.fn.extend({
    hSlider: function(options) {
      var log, settings;
      settings = {
        debug: true,
        slide_timing: 1,
        slide_effect: "cubic-bezier(1,.34,.83,.9)"
      };
      settings = $.extend(settings, options);
      log = function(msg) {
        if (settings.debug) {
          return typeof console !== "undefined" && console !== null ? console.log(msg) : void 0;
        }
      };
      return this.each(function() {
        var $container, $signature, $slideUl, $slides, $this, forwardIndex, frameWidth, moveBackward, moveForward, slideIndex, slidesNumber, totalFrameWidth, transitionOff, transitionOn;
        $this = $(this);
        $container = $(".container", $this);
        $slideUl = $('.slide', $this);
        $slides = $(".slide li", $this);
        $signature = $("ul.signature", $this);
        transitionOn = function() {
          $slideUl.css({
            "webkit-transition": "all " + settings.slide_timing + "s " + settings.slide_effect,
            "moz-transition": "all " + settings.slide_timing + "s " + settings.slide_effect,
            "ms-transition": "all " + settings.slide_timing + "s " + settings.slide_effect,
            "o-transition": "all " + settings.slide_timing + "s " + settings.slide_effect,
            "transition": "all " + settings.slide_timing + "s " + settings.slide_effect
          });
        };
        transitionOff = function() {
          $slideUl.css({
            "webkit-transition": "none",
            "moz-transition": "none",
            "ms-transition": "none",
            "o-transition": "none",
            "transition": "none"
          });
        };
        frameWidth = $container.innerWidth();
        slidesNumber = $slides.size();
        totalFrameWidth = frameWidth * (slidesNumber + 1);
        $slideUl.css("width", totalFrameWidth);
        $slides.css("width", frameWidth);
        $(window).resize(function() {
          frameWidth = $container.innerWidth();
          totalFrameWidth = frameWidth * slidesNumber;
          $slideUl.css("width", totalFrameWidth);
          return $slides.css("width", frameWidth);
        });
        slideIndex = 0;
        while (slideIndex < slidesNumber) {
          $signature.append("<li></li>");
          slideIndex++;
        }
        forwardIndex = 0;
        moveForward = function() {
          forwardIndex++;
          log(forwardIndex);
          if (forwardIndex < slidesNumber) {
            transitionOn();
            return $slideUl.css("margin-left", -(forwardIndex * frameWidth));
          } else {
            $("li:first-child", $slideUl).clone().insertAfter($("li:last", $slideUl));
            $slideUl.css("margin-left", -(forwardIndex * frameWidth));
            setTimeout(function() {
              transitionOff();
              $slideUl.css("margin-left", 0);
              return $("li:last-child", $slideUl).remove();
            }, settings.slide_timing * 1000);
            return forwardIndex = 0;
          }
        };
        moveBackward = function() {
          forwardIndex--;
          log(forwardIndex);
          if (forwardIndex >= 0) {
            transitionOn();
            return $slideUl.css("margin-left", -(forwardIndex * frameWidth));
          } else {
            forwardIndex = slidesNumber - 1;
            $("li:last-child", $slideUl).clone().insertBefore($("li:first-child", $slideUl));
            transitionOff();
            $slideUl.css("margin-left", -frameWidth);
            return setTimeout(function() {
              transitionOn();
              $slideUl.css("margin-left", 0);
              return setTimeout(function() {
                transitionOff();
                $slideUl.css("margin-left", -((slidesNumber - 1) * frameWidth));
                return $("li:first-child", $slideUl).remove();
              }, settings.slide_timing * 1000);
            }, 10);
          }
        };
        $(".next").on("click", function() {
          return moveForward();
        });
        $(".before").on("click", function() {
          return moveBackward();
        });
        if (jQuery.browser.mobile) {
          return $slides.swipe({
            swipeRight: function() {
              return moveForward();
            },
            swipeLeft: function() {
              return moveBackward();
            }
          });
        }
      });
    }
  });

}).call(this);
