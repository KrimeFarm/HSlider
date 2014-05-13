HSlider
=================

An horizontal slider, responsive and compatible with Bootstrap, animations with CSS3 transitions,

### Requires:
- [jquery.event.move](http://stephband.info/jquery.event.move/)
- [jquery.event.swipe](http://stephband.info/jquery.event.swipe/)
- [velocity](https://github.com/julianshapiro/velocity)

### They can be installed with [Bower](http://bower.io/)
`bower install jquery.event.move`
`bower install jquery.event.swipe`

## Html side

```html
<div class="content">

  <div class="container">
    <ul class="slide">
      <li><p>content-1</p></li>
      <li><p>content-2</p></li>
      <li><p>content-3</p></li>
    </ul>
    <div class="before"></div>
    <div class="next"></div>
  </div>

  <ul class="signature"></ul>

</div>
```

## Less side

```scss
.content .signature {
  list-style: none;
  padding: 0;
  margin: 0;
  text-align: center;
  li {
    display: inline-block;
    background: magenta;
    height: 10px;
    width: 10px;
    border-radius: 10px;
    margin: 0 10px;

    &.lightsOn {
      background: blue;
    }
  }
}

.slide {
  list-style: none;
  padding: 0;
  margin: 0;
  li {
    float: left;
    height: 200px;
    background-color: red;
  }
  p {
    text-align: center;
    font-size: 30px;
  }
}
```

## Coffeescript side

```coffeescript
$ ->
  $(".content").hSlider
      slide_timing: 1
      loop_timing: 5000
      slide_effect: "cubic-bezier(1,.34,.83,.9)"
      velocity_is_on: true
```
