function dashboardDiv()
  {return $('#dashboard');}

function setWidgetValue(element, widget) { // {{{
  $.get('/dashboard/widgets/' + widget.name, function(data) {
    element.html(data);
  });
} // }}}

function createWidgetValueUpdater(element, widget) { // {{{
  $(this).everyTime(widget.update_interval, widget.name, function() {
    setWidgetValue(element, widget);
  });
} // }}}

function createDashboardNumberRow(widget) {
  var numbers_container = dashboardDiv().find('.dashboard-numbers');

  var widget_div_id = 'number-widget-' + widget.name;
  numbers_container.append('<div id="' + widget_div_id + '" class="number-widget"></div>');

  var widget_div = numbers_container.find('#' + widget_div_id);
  widget_div.append('<div class="widget-title">' + widget.title + '</div>');
  widget_div.append('<div class="widget-value">value not set</div>');
  widget_div.append('<div class="dashboard-cleared"></div>');

  var widget_value_div = widget_div.find('.widget-value');
  setWidgetValue(widget_value_div, widget);
  createWidgetValueUpdater(widget_value_div, widget);
}

jQuery(document).ready(function() { // {{{
  var dashboard = dashboardDiv();
  var widgets   = $.parseJSON(json_widgets);

  $.each(widgets, function(index, widget) {
    if (widget.type == 'block')
      {createDashboardBlock(widget);}
    else if (widget.type == 'number')
      {createDashboardNumberRow(widget);}
    else
      {/* Do nothing. This widget type isn't supported. */}
  });
}); // }}}
