(function() {
  $(function() {
    return $(".content").hSlider({
      slide_timing: 1,
      loop_timing: 5000,
      slide_effect: "cubic-bezier(1,.34,.83,.9)"
    });
  });

}).call(this);
