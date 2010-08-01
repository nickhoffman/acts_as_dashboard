// function includeJavaScriptFile(path) {{{
//
// Creates a JavaScript <script> element and appends it
// to the <head>.
//
function includeJavaScriptFile(path) {
  // Ensure that we have a non-empty string.'
  if ((typeof(path) != 'string') || (!path))
    {return;}

  // Ensure that we can find the <head>.
  var head = jQuery('head');
  if (!head)
    {return;}

  var element   = document.createElement('script');
  element.type  = 'text/javascript';
  element.src   = path;

  head.append(element);

  return true;
} // }}}

// function buildTheDashboard() {{{
//
// Determines which dashboard widgets to build,
// builds them, and adds them to the DOM.
//
function buildTheDashboard() {
  var parsed_widgets = jQuery.parseJSON(json_widgets);

  jQuery.each(parsed_widgets, function(index, widget) {
    if (widget.type == 'number')
      {dashboard.addNumberWidget(widget);}
    else if (widget.type == 'short_messages')
      {dashboard.addShortMessagesWidget(widget);}
    else if (widget.type == 'line_graph')
      {dashboard.addLineGraphWidget(widget);}
  });
} // }}}

function createUpdateTimerFor(widget) { // {{{
  $(this).everyTime(widget.update_interval, widget.name, function() {
    widget.updateData();
  });
} // }}}

// Begin Dashboard class. {{{
var Dashboard = new JS.Class({
  initialize: function(options) { // {{{
    this.basePath             = options.basePath;

    this.numberWidgets        = new Array();
    this.shortMessagesWidgets = new Array();
    this.lineGraphWidgets     = new Array();
  
    this.div                      = jQuery('#dashboard');
    this.numberWidgetsDiv         = this.div.find('.dashboard-numbers');
    this.shortMessagesWidgetsDiv  = this.div.find('.dashboard-short-messages');
    this.lineGraphWidgetsDiv      = this.div.find('.dashboard-line-graphs');
  }, // }}}

  addNumberWidget: function(options) { // {{{
    var widget      = new NumberWidget(options);
    var templateDiv = this.numberWidgetsDiv.find('.widget-template');

    var widgetDiv   = templateDiv.clone(false)
      .removeClass('widget-template')
      .addClass('number-widget')
      .attr('id', widget.divID())
      .appendTo(this.numberWidgetsDiv);

    // Set the new div's title.
    widgetDiv.find('.widget-title').html(widget.title);

    widget.setDataDivTo(widgetDiv.find('.widget-data'));
    widget.updateData();

    createUpdateTimerFor(widget);

    this.numberWidgets.push(widget);

    widgetDiv.show();
  }, // }}}

  addShortMessagesWidget: function(options) { // {{{
    var widget      = new ShortMessagesWidget(options);
    var templateDiv = this.shortMessagesWidgetsDiv.find('.widget-template');

    var widgetDiv   = templateDiv.clone(false)
      .removeClass('widget-template')
      .addClass('short-messages-widget')
      .attr('id', widget.divID())
      .appendTo(this.shortMessagesWidgetsDiv);

    // Set the new div's title.
    widgetDiv.find('.widget-title').html(widget.title);

    widget.setDataDivTo(widgetDiv.find('.widget-data'));
    widget.updateData();

    createUpdateTimerFor(widget);

    this.shortMessagesWidgets.push(widget);

    widgetDiv.show();
  }, // }}}

  addLineGraphWidget: function(options) { // {{{
    var widget      = new LineGraphWidget(options);
    var templateDiv = this.lineGraphWidgetsDiv.find('.widget-template');

    var widgetDiv   = templateDiv.clone(false)
      .removeClass('widget-template')
      .addClass('line-graph-widget')
      .attr('id', widget.divID())
      .appendTo(this.lineGraphWidgetsDiv);

    // Set the new div's title.
    widgetDiv.find('.widget-title').html(widget.title);

    var dataDiv = widgetDiv.find('.widget-data')
      .attr('id', widget.divID() + '-data');

    widget.setDataDivTo(dataDiv);

    widget.updateData();

    // I don't know why, but setting these properties when dataDiv
    // is initialized fails to work. They work here, though...
    dataDiv.css('height',  widget.height)
    dataDiv.css('width',   widget.width)

    createUpdateTimerFor(widget);

    this.lineGraphWidgets.push(widget);

    widgetDiv.show();
  } // }}}
});
// End Dashboard class. }}}

// Begin DashboardWidget class. {{{
var DashboardWidget = new JS.Class({
  initialize: function(options) {
    this.type             = options.type;
    this.name             = options.name;
    this.title            = options.title;
    this.update_interval  = options.update_interval;
  },

  dataURL: function() {
    return dashboard.basePath + this.name;
  },

  divID: function() {
    return this.name + '-' + this.type + '-widget';
  },

  setDataDivTo: function(element) {
    this.dataDiv = element;
  }
});
// End DashboardWidget class. }}}

// Begin NumberWidget class. {{{
var NumberWidget = new JS.Class(DashboardWidget, {
  initialize: function(options) {
    options['type'] = 'number';
    this.callSuper(options);
  },

  updateData: function() {
    if (!this.dataDiv)
      {return false;}

    // This is needed so that the dataDiv property is accessible with jQuery.get() .
    var element = this.dataDiv;

    jQuery.get(this.dataURL(), function(data) {
      element.fadeOut(400, function() {
        element.html(data);
        element.fadeIn();
      });
    }, 'text');
  }
});
// End NumberWidget class. }}}

// Begin ShortMessagesWidget class. {{{
var ShortMessagesWidget = new JS.Class(DashboardWidget, {
  initialize: function(options) {
    options['type'] = 'short_messages';
    this.callSuper(options);
    this.maxDataItems = 5;
  },

  firstDataItem: function() {
    return this.dataDiv.find('li.widget-data-item:first');
  },

  dataItemsCount: function() {
    return this.dataDiv.find('li.widget-data-item').length;
  },

  createDataItem: function() {
    return this.dataDiv.find('li.widget-data-template')
      .clone(false)
      .removeClass('widget-data-template')
      .addClass('widget-data-item');
  },

  updateData: function() {
    if (!this.dataDiv)
      {return false;}

    var new_data  = '';
    var new_li    = this.createDataItem();

    // We use ajax() instead of get() because the "async" option must
    // be false. If it isn't, we're unable to determine if data was
    // obtained.
    var get_result = jQuery.ajax({
      url:      this.dataURL(),
      type:     'GET',
      async:    false,
      cache:    false,
      dataType: 'text',
      timeout:  this.updateInterval,
      success:  function(data) {
        new_li.html(data);
        new_data = data;
      }
    });

    // If no data was obtained, return. Otherwise, an empty list item
    // will be shown.
    if (new_data == '')
      {return false;}

    new_li.appendTo(this.dataDiv.find('ul'));

    // Hide the first list item if we've reached the maximum number of
    // list items to show in this widget.
    if (this.dataItemsCount() > this.maxDataItems) {
      var firstDataItem = this.firstDataItem();

      firstDataItem.slideUp(400, function() {
        firstDataItem.remove();
      });
    }

    new_li.slideDown();
  }
});
// End ShortMessagesWidget class. }}}

// Begin LineGraphWidget class. {{{
var LineGraphWidget = new JS.Class(DashboardWidget, {
  initialize: function(options) {
    this.height         = options.height;
    this.width          = options.width;
    this.seriesColours  = options.line_colours;
    this.x_axis         = options.x_axis;

    options.type  = 'line_graph';
    this.callSuper(options);
  },

  updateData: function() {
    if (!this.graph)
      {this.createGraph();}

    // This is needed so that the dataDiv property is accessible with jQuery.get() .
    var graph = this.graph;

    jQuery.get(this.dataURL(), function(data) {
      graph.series[0].data = data;
      graph.replot({resetAxes: true});
    }, 'json');
  },

  createGraph: function() {
    includeJavaScriptFile('/javascripts/jqplot-0.9.7/plugins/jqplot.dateAxisRenderer.min.js');

    var x_axis_format = {};
    if (this.x_axis === 'dates') {
      var x_axis_format = {
        renderer:     jQuery.jqplot.DateAxisRenderer,
        tickOptions:  {formatString: '%Y-%m-%d'}
      }
    }

    this.graph = jQuery.jqplot(this.dataDiv.attr('id'), [ [] ], {
      title:        this.title,
      seriesColors: this.seriesColours,
      axes:         {
                      xaxis: x_axis_format
                    }
    });
  }
});
// End LineGraphWidget class. }}}

