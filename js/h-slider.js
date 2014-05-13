(function() {
  var $;

  $ = jQuery;

  $.fn.extend({
    hSlider: function(options) {
      var log, settings;
      settings = {
        debug: false,
        slide_timing: 1,
        loop_timing: 5000,
        slide_effect: "cubic-bezier(1,.34,.83,.9)"
      };
      settings = $.extend(settings, options);
      log = function(msg) {
        if (settings.debug) {
          return typeof console !== "undefined" && console !== null ? console.log(msg) : void 0;
        }
      };
      return this.each(function() {
        var $container, $interactions, $signature, $slideUl, $slides, $this, checkTheAction, forwardIndex, frameWidth, moveBackward, moveForward, preventTheAction, slideIndex, slidesNumber, theAutoLoop, theDottedConnection, totalFrameWidth, transitionOff, transitionOn;
        $this = $(this);
        $container = $(".container", $this);
        $slideUl = $('.slide', $this);
        $slides = $(".slide li", $this);
        $interactions = $(".next, .before", $this);
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
        $this.on("movestart", function(e) {
          if ((e.distX > e.distY && e.distX < -e.distY) || (e.distX < e.distY && e.distX > -e.distY)) {
            e.preventDefault();
          }
        });
        frameWidth = $container.innerWidth();
        slidesNumber = $slides.size();
        totalFrameWidth = frameWidth * (slidesNumber + 1);
        $slideUl.css("width", totalFrameWidth);
        $slides.css("width", frameWidth);
        $(window).resize(function() {
          frameWidth = $container.innerWidth();
          totalFrameWidth = frameWidth * (slidesNumber + 1);
          $slideUl.css("width", totalFrameWidth);
          $slides.css("width", frameWidth);
          $slideUl.css("margin-left", -(forwardIndex * frameWidth));
          return transitionOff();
        });
        slideIndex = 0;
        while (slideIndex < slidesNumber) {
          if (slideIndex === 0) {
            $signature.append("<li id=\"signature-" + slideIndex + "\" class=\"lightsOn\"></li>");
          } else {
            $signature.append("<li id=\"signature-" + slideIndex + "\"></li>");
          }
          slideIndex++;
        }
        theDottedConnection = function(elem) {
          log("this is the slide number " + elem);
          $("li", $signature).removeClass("lightsOn");
          if (elem === slidesNumber) {
            $("li#signature-0", $this).addClass("lightsOn");
            return log("this is max");
          } else if (elem < 0) {
            log("this is min");
            return $("li#signature-" + (slidesNumber - 1), $this).addClass("lightsOn");
          } else {
            return $("li#signature-" + elem, $this).addClass("lightsOn");
          }
        };
        checkTheAction = function() {
          log("prevent");
          $interactions.addClass("active");
          return setTimeout(function() {
            return $interactions.removeClass("active");
          }, settings.slide_timing * 1000);
        };
        forwardIndex = 0;
        moveForward = function() {
          transitionOn();
          checkTheAction();
          forwardIndex++;
          theDottedConnection(forwardIndex);
          log(forwardIndex);
          if (forwardIndex < slidesNumber) {
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
          transitionOn();
          checkTheAction();
          forwardIndex--;
          theDottedConnection(forwardIndex);
          log(forwardIndex);
          if (forwardIndex >= 0) {
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
        preventTheAction = function() {
          if ($interactions.hasClass("active")) {
            return false;
          } else {
            return true;
          }
        };
        $(".next").on("click", function() {
          if (preventTheAction()) {
            return moveForward();
          }
        });
        $(".before").on("click", function() {
          if (preventTheAction()) {
            return moveBackward();
          }
        });
        $container.on("swipeleft", function(e) {
          if (preventTheAction()) {
            return moveForward();
          }
        }).on("swiperight", function(e) {
          if (preventTheAction()) {
            return moveBackward();
          }
        });
        $("li", $signature).on("click", function() {
          var theSigId, theSigSliced;
          transitionOn();
          checkTheAction();
          theSigId = $(this).attr("id");
          theSigSliced = theSigId.slice(-1);
          forwardIndex = theSigSliced;
          theDottedConnection(forwardIndex);
          return $slideUl.css("margin-left", -(forwardIndex * frameWidth));
        });
        theAutoLoop = setInterval(function() {
          if (preventTheAction()) {
            moveForward();
          }
        }, settings.loop_timing);
        return $(document).on({
          mouseenter: function() {
            log("quit");
            return clearInterval(theAutoLoop);
          },
          mouseleave: function() {
            log("out");
            return theAutoLoop = setInterval(function() {
              if (preventTheAction()) {
                moveForward();
              }
            }, settings.loop_timing);
          }
        }, ".container", $this);
      });
    }
  });

}).call(this);
