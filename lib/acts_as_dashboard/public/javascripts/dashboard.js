console.log('new dashboard.js');

function createUpdateTimerFor(widget) { // {{{
  $(this).everyTime(widget.update_interval, widget.name, function() {
    widget.updateDataDiv();
  });
} // }}}

// Begin Dashboard class. {{{
var Dashboard = new JS.Class({
  initialize: function(options) {
    this.basePath         = options.basePath;

    this.numberWidgets    = new Array();
  
    this.div              = jQuery('#dashboard');
    this.numberWidgetsDiv = this.div.find('.dashboard-numbers');
  },

  addNumberWidget: function(options) {
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
    widget.updateDataDiv();

    createUpdateTimerFor(widget);

    this.numberWidgets.push(widget);

    widgetDiv.show();
  }
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

  updateDataDiv: function() {
    if (!this.dataDiv)
      {return false;}

    // This is needed so that the dataDiv property is accessible with jQuery.get() .
    var element = this.dataDiv;

    jQuery.get(this.dataURL(), function(data) {
      element.html(data);
    }, 'text');
  }
});
// End NumberWidget class. }}}

jQuery(document).ready(function() { // {{{
  var parsed_widgets  = jQuery.parseJSON(json_widgets);

  jQuery.each(parsed_widgets, function(index, widget) {
    if (widget.type == 'number') {
      dashboard.addNumberWidget(widget);
    }
  });
}); // }}}
