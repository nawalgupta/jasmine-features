jasmine ||= {}
jasmine.features ||= {}
jasmine.features.addDsl = ($, egspect=expect) ->
  o$ = $

  find = (nameOrSelector,type=":input") ->
    $r = o$("#{type}[name=#{nameOrSelector}]")
    $r = o$(nameOrSelector) if $r.length == 0
    $r

  dsl =
    #clicking
    click: (selector) ->
      $clickable = o$(selector)
      egspect($clickable).toBeAttached()
      $clickable.trigger('click')

    clickLink: (selector) ->
      $link = o$("a[id=\"#{selector}\"],a:contains(#{selector})")
      $link = o$('a').filter(selector) if $link.length == 0
      dsl.click $link

    clickButton: (selector) ->
      $button = o$(_([":button","input[type=\"submit\"]"]).map( (elPrefix) ->
        "#{elPrefix}[id=\"#{selector}\"],#{elPrefix}[name=\"#{selector}\"],#{elPrefix}[value=\"#{selector}\"],#{elPrefix}:contains(#{selector})"
      ).join(","))
      $button = o$(':button,"input[type=\"submit\"]"').filter(selector) if $button.length == 0
      dsl.click $button

    #forms
    fillIn: (name, options) ->
      $input = find(name)
      egspect($input).toBeAttached()
      switch $input.attr('type')
        when "checkbox"
          check(name,options.with)
        else
          $input.val(options.with).trigger('change')
          egspect($input.val()).toEqual(options.with)
    check: (name, doCheckIt = true) ->
      $checkbox = find(name,":checkbox")
      $checkbox.attr('checked',doCheckIt).trigger('change')
      egspect($checkbox.is(':checked')).toBe(doCheckIt)
    uncheck: (name) ->
      dsl.check(name,false)

    #querying
    findContent: (text) ->
      matches = $(o$.selector or 'body').text().indexOf(text) != -1
      egspect(matches).toBe(true)
      matches

    #scoping
    within: (selector, action) ->
      o$ = (s) -> $(s,selector)
      o$.selector = selector
      action()
      o$ = $

    drag: (selector,options) ->
      $from = o$(selector)
      $to = o$(options.to)

      $from.simulate 'drag',
        dx: $to.offset().left - $from.offset().left
        dy: $to.offset().top - $from.offset().top


  _(window).extend(dsl)
  dsl
