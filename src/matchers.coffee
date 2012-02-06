beforeEach ->
  this.addMatchers
    toBeAttached: (within = 'body') ->
      $ = jasmine.features.$
      $el = $(this.actual)
      $within = $(within)
      isContainedWithin = $.contains($within[0],$el[0])
      this.message = ->
        "Expected '#{$el.selector}' #{if @isNot "not" else ""} to be contained within '#{$within.selector}'"
      isContainedWithin
